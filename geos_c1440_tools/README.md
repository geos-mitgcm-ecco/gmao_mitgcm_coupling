# geos-c1440-tools

Toolkit to **download** NASA NAS GEOS/ECCO C1440 collections and **regrid** fields from the native
(unwrapped) cubed-sphere indexing to a regular **lat–lon** grid.

Highlights:
- Jupyter-friendly Python API
- CLI for download + regrid
- Resumable downloads (`.part`)
- Regridding neighbor-info caching (`--cache-dir ./weights`)

## Install

```bash
pip install -e .
# optional:
pip install -e ".[cartopy]"
```

## Download (CLI)

```bash
geos-c1440 download \
  --base-url "https://data.nas.nasa.gov/geosecco/c1440_llc2160/holding/geosgcm_surf/" \
  --out ./geosgcm_surf \
  --recursive --resume --workers 4
```

## Regrid one variable (CLI)

You need the bridge file `geos_c1440_lats_lons_2D.nc` containing:
- `lats(Ydim, Xdim)`
- `lons(Ydim, Xdim)`

```bash
geos-c1440 regrid \
  --latlon ./geos_c1440_lats_lons_2D.nc \
  --infile ./geosgcm_surf/DYAMOND_c1440_llc2160.geosgcm_surf.20200101_0000z.nc4 \
  --var T10M \
  --out ./T10M_0p25deg.nc \
  --dlat 0.25 --dlon 0.25 \
  --cache-dir ./weights
```

## Python API (Jupyter)

```python
import numpy as np, xarray as xr
from geos_c1440_tools.regrid import GeoC1440UnwrappedRegridder
from geos_c1440_tools.plot import plot_latlon

lat_out = np.arange(-90, 90.0001, 0.25)
lon_out = np.arange(-180, 180.0001, 0.25)

R = GeoC1440UnwrappedRegridder.from_latlon_file(
    "geos_c1440_lats_lons_2D.nc",
    lat_name="lats", lon_name="lons",
    lat_out=lat_out, lon_out=lon_out,
    cache_dir="./weights",
)

ds = xr.open_dataset("...nc4")
da_native = ds["T10M"].rename(lat="cs_y", lon="cs_x")  # avoid confusion (native are index dims)
da_ll = R.regrid_dataarray(da_native, src_dims=("cs_y","cs_x"))

plot_latlon(da_ll, time_index=0, cmap="coolwarm", title="T10M regridded")
```

## License

Apache-2.0
