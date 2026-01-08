from __future__ import annotations

import argparse
import os
import numpy as np
import xarray as xr

from .download import download_tree
from .regrid import GeoC1440UnwrappedRegridder


def _cmd_download(a: argparse.Namespace) -> None:
    download_tree(
        base_url=a.base_url,
        out_dir=a.out,
        recursive=a.recursive,
        resume=a.resume,
        workers=a.workers,
        timeout=a.timeout,
        retries=a.retries,
    )


def _cmd_regrid(a: argparse.Namespace) -> None:
    lat_out = np.arange(-90, 90.0001, a.dlat)
    lon_out = np.arange(-180, 180.0001, a.dlon)

    R = GeoC1440UnwrappedRegridder.from_latlon_file(
        a.latlon,
        lat_name=a.lat_name,
        lon_name=a.lon_name,
        lat_out=lat_out,
        lon_out=lon_out,
        radius_of_influence_m=a.radius,
        neighbours=a.neighbours,
        cache_dir=a.cache_dir,
    )

    ds = xr.open_dataset(a.infile)
    if a.var not in ds:
        raise SystemExit(f"Variable '{a.var}' not found. Available: {list(ds.data_vars)[:25]} ...")

    da = ds[a.var]

    # If source dims are named lat/lon but are index dims, rename to avoid confusion.
    if a.src_y in da.dims and a.src_x in da.dims:
        da = da.rename({a.src_y: "cs_y", a.src_x: "cs_x"})
        da_ll = R.regrid_dataarray(da, src_dims=("cs_y","cs_x"))
    else:
        da_ll = R.regrid_dataarray(da, src_dims=(da.dims[-2], da.dims[-1]))

    out_ds = da_ll.to_dataset(name=da_ll.name or a.var)
    os.makedirs(os.path.dirname(a.out) or ".", exist_ok=True)
    out_ds.to_netcdf(a.out)


def main():
    p = argparse.ArgumentParser(prog="geos-c1440", description="GEOS C1440 download + regrid utilities.")
    sp = p.add_subparsers(dest="cmd", required=True)

    p_dl = sp.add_parser("download", help="Crawl and download NetCDF files from a directory listing.")
    p_dl.add_argument("--base-url", required=True)
    p_dl.add_argument("--out", required=True)
    p_dl.add_argument("--recursive", action="store_true")
    p_dl.add_argument("--resume", action="store_true")
    p_dl.add_argument("--workers", type=int, default=4)
    p_dl.add_argument("--timeout", type=int, default=60)
    p_dl.add_argument("--retries", type=int, default=8)
    p_dl.set_defaults(func=_cmd_download)

    p_rg = sp.add_parser("regrid", help="Regrid one file variable to a regular lat-lon grid.")
    p_rg.add_argument("--latlon", required=True, help="Bridge file with lats/lons 2D arrays.")
    p_rg.add_argument("--lat-name", default="lats")
    p_rg.add_argument("--lon-name", default="lons")
    p_rg.add_argument("--infile", required=True)
    p_rg.add_argument("--var", required=True)
    p_rg.add_argument("--out", required=True)
    p_rg.add_argument("--dlat", type=float, default=0.25)
    p_rg.add_argument("--dlon", type=float, default=0.25)
    p_rg.add_argument("--radius", type=float, default=20e3)
    p_rg.add_argument("--neighbours", type=int, default=1)
    p_rg.add_argument("--cache-dir", default="./weights")
    p_rg.add_argument("--src-y", default="lat")
    p_rg.add_argument("--src-x", default="lon")
    p_rg.set_defaults(func=_cmd_regrid)

    a = p.parse_args()
    a.func(a)

if __name__ == "__main__":
    main()
