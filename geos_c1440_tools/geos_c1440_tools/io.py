import xarray as xr

def open_geos_dataset(path: str, chunks=None) -> xr.Dataset:
    return xr.open_dataset(path, chunks=chunks)
