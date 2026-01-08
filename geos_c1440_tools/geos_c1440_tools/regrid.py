from __future__ import annotations

import os
import pickle
from dataclasses import dataclass
from typing import Optional, Tuple
import inspect

import numpy as np
import xarray as xr
import pyresample


def _wrap_lon(lon, mode: str):
    lon = np.asarray(lon)
    if mode == "[-180,180]":
        return ((lon + 180) % 360) - 180
    if mode == "[0,360]":
        return lon % 360
    return lon


def sample_from_neighbour_info_compat(
    valid_in, valid_out, index_array, distance_array,
    data_1d, output_shape, fill_value=np.nan
):
    """Compatibility wrapper across pyresample versions."""
    fn = pyresample.kd_tree.get_sample_from_neighbour_info
    params = list(inspect.signature(fn).parameters.keys())

    # New signature: (resample_type, output_shape, data, valid_input_index, valid_output_index, index_array, distance_array, ...)
    if len(params) >= 7 and params[0] in ("resample_type", "resample"):
        return fn(
            "nn",
            output_shape,
            data_1d,
            valid_in,
            valid_out,
            index_array,
            distance_array,
            fill_value=fill_value,
        )

    # Older signature: (valid_input_index, valid_output_index, index_array, distance_array, data, output_shape, ...)
    return fn(
        valid_in,
        valid_out,
        index_array,
        distance_array,
        data_1d,
        output_shape,
        fill_value=fill_value,
    )


@dataclass
class GeoC1440UnwrappedRegridder:
    """
    Regrid GEOS C1440 fields stored on an unwrapped 2D index grid (Ydim, Xdim)
    to a regular lat-lon grid using KDTree nearest-neighbour.

    Bridge file must provide lats(Ydim,Xdim), lons(Ydim,Xdim).
    """

    lat_out: np.ndarray
    lon_out: np.ndarray
    radius_of_influence_m: float = 20e3
    neighbours: int = 1
    fill_value: float = np.nan
    lon_wrap: str = "[-180,180]"
    cache_dir: Optional[str] = None

    src_def: Optional[pyresample.geometry.SwathDefinition] = None
    tgt_def: Optional[pyresample.geometry.GridDefinition] = None
    valid_in: Optional[np.ndarray] = None
    valid_out: Optional[np.ndarray] = None
    index_array: Optional[np.ndarray] = None
    distance_array: Optional[np.ndarray] = None

    @staticmethod
    def _cache_key(lat_out, lon_out, radius, neighbours, lon_wrap) -> str:
        import hashlib
        payload = (
            f"lat:{lat_out.size}:{float(lat_out[0])}:{float(lat_out[-1])}:{float(np.diff(lat_out).mean())};"
            f"lon:{lon_out.size}:{float(lon_out[0])}:{float(lon_out[-1])}:{float(np.diff(lon_out).mean())};"
            f"r:{radius};k:{neighbours};wrap:{lon_wrap}"
        ).encode("utf-8")
        return hashlib.md5(payload).hexdigest()

    @classmethod
    def from_latlon_file(
        cls,
        latlon_path: str,
        lat_name: str = "lats",
        lon_name: str = "lons",
        lat_out: np.ndarray = None,
        lon_out: np.ndarray = None,
        **kwargs
    ) -> "GeoC1440UnwrappedRegridder":
        if lat_out is None or lon_out is None:
            raise ValueError("Provide lat_out and lon_out arrays.")
        ds = xr.open_dataset(latlon_path)
        lats_2d = ds[lat_name].values
        lons_2d = ds[lon_name].values
        R = cls(lat_out=np.asarray(lat_out), lon_out=np.asarray(lon_out), **kwargs)
        R._build(lats_2d, lons_2d)
        return R

    def _build(self, lats_2d: np.ndarray, lons_2d: np.ndarray) -> None:
        lons = _wrap_lon(lons_2d, self.lon_wrap)
        lats = np.asarray(lats_2d)

        lon2, lat2 = np.meshgrid(self.lon_out, self.lat_out)
        self.tgt_def = pyresample.geometry.GridDefinition(lons=lon2, lats=lat2)
        self.src_def = pyresample.geometry.SwathDefinition(lons=lons.ravel(), lats=lats.ravel())

        if self.cache_dir:
            os.makedirs(self.cache_dir, exist_ok=True)
            key = self._cache_key(self.lat_out, self.lon_out, self.radius_of_influence_m, self.neighbours, self.lon_wrap)
            cache_path = os.path.join(self.cache_dir, f"neigh_{key}.pkl")
            if os.path.exists(cache_path):
                with open(cache_path, "rb") as f:
                    d = pickle.load(f)
                self.valid_in = d["valid_in"]
                self.valid_out = d["valid_out"]
                self.index_array = d["index_array"]
                self.distance_array = d["distance_array"]
                return

        self.valid_in, self.valid_out, self.index_array, self.distance_array = pyresample.kd_tree.get_neighbour_info(
            self.src_def,
            self.tgt_def,
            radius_of_influence=float(self.radius_of_influence_m),
            neighbours=int(self.neighbours),
        )

        if self.cache_dir:
            key = self._cache_key(self.lat_out, self.lon_out, self.radius_of_influence_m, self.neighbours, self.lon_wrap)
            cache_path = os.path.join(self.cache_dir, f"neigh_{key}.pkl")
            with open(cache_path, "wb") as f:
                pickle.dump(
                    dict(
                        valid_in=self.valid_in,
                        valid_out=self.valid_out,
                        index_array=self.index_array,
                        distance_array=self.distance_array,
                    ),
                    f,
                    protocol=pickle.HIGHEST_PROTOCOL,
                )

    def regrid_dataarray(
        self,
        da: xr.DataArray,
        src_dims: Tuple[str, str] = ("Ydim", "Xdim"),
        lat_name_out: str = "lat",
        lon_name_out: str = "lon",
    ) -> xr.DataArray:
        if self.tgt_def is None or self.index_array is None:
            raise RuntimeError("Regridder not built. Use from_latlon_file(...)")

        for d in src_dims:
            if d not in da.dims:
                raise ValueError(f"Missing expected dim '{d}' in DataArray. Got dims={da.dims}")

        lead_dims = [d for d in da.dims if d not in src_dims]
        da_t = da.transpose(*lead_dims, *src_dims)

        lead_shape = [da_t.sizes[d] for d in lead_dims]
        arr = da_t.values.reshape((*lead_shape, -1))

        out_shape = (*lead_shape, self.lat_out.size, self.lon_out.size)
        out = np.full(out_shape, self.fill_value, dtype=arr.dtype)

        it = np.ndindex(*lead_shape) if lead_shape else [()]
        for idx in it:
            vec = arr[idx] if lead_shape else arr
            out2d = sample_from_neighbour_info_compat(
                self.valid_in, self.valid_out, self.index_array, self.distance_array,
                vec, self.tgt_def.shape, fill_value=self.fill_value
            )
            if lead_shape:
                out[idx] = out2d
            else:
                out = out2d

        coords = {d: da_t.coords[d] for d in lead_dims if d in da_t.coords}
        coords[lat_name_out] = self.lat_out
        coords[lon_name_out] = self.lon_out
        dims = (*lead_dims, lat_name_out, lon_name_out)
        return xr.DataArray(out, coords=coords, dims=dims, name=da.name, attrs=da.attrs)
