import numpy as np
import xarray as xr
from geos_c1440_tools.regrid import GeoC1440UnwrappedRegridder
from geos_c1440_tools.plot import plot_latlon


LATLON = "./geos_c1440_lats_lons_2D.nc"
INFILE = "./geosgcm_surf/DYAMOND_c1440_llc2160.geosgcm_surf.20200101_0000z.nc4"
VAR = "T10M"

lat_out = np.arange(-90, 90.0001, 0.25)
lon_out = np.arange(-180, 180.0001, 0.25)

R = GeoC1440UnwrappedRegridder.from_latlon_file(
    LATLON, lat_name="lats", lon_name="lons",
    lat_out=lat_out, lon_out=lon_out,
    cache_dir="./weights"
)

ds = xr.open_dataset(INFILE)
da = ds[VAR].rename(lat="cs_y", lon="cs_x")
da_ll = R.regrid_dataarray(da, src_dims=("cs_y","cs_x"))

plot_latlon(da_ll, time_index=0, cmap="coolwarm", title=f"{VAR} regridded")
