from __future__ import annotations

from typing import Optional, Tuple
import matplotlib.pyplot as plt
import xarray as xr


def plot_latlon(
    da: xr.DataArray,
    time_index: int = 0,
    vmin=None,
    vmax=None,
    cmap: str = "viridis",
    title: Optional[str] = None,
    figsize: Tuple[float, float] = (10, 5),
    cbar_label: Optional[str] = None,
):
    """Quick Matplotlib lat-lon plot. Expects coords named 'lat' and 'lon'."""
    if "time" in da.dims:
        da2 = da.isel(time=time_index)
    else:
        da2 = da

    fig, ax = plt.subplots(figsize=figsize)
    im = ax.pcolormesh(da2["lon"], da2["lat"], da2, shading="auto", cmap=cmap, vmin=vmin, vmax=vmax)
    ax.set_xlabel("Longitude")
    ax.set_ylabel("Latitude")
    ax.set_title(title or (da.name or "field"))
    cbar = plt.colorbar(im, ax=ax, pad=0.02)
    if cbar_label:
        cbar.set_label(cbar_label)
    plt.tight_layout()
    return fig, ax


def plot_latlon_cartopy(
    da: xr.DataArray,
    time_index: int = 0,
    vmin=None,
    vmax=None,
    cmap: str = "viridis",
    title: Optional[str] = None,
    figsize: Tuple[float, float] = (12, 6),
    cbar_label: Optional[str] = None,
):
    """Cartopy lat-lon plot with coastlines (requires cartopy)."""
    import cartopy.crs as ccrs
    import cartopy.feature as cfeature

    if "time" in da.dims:
        da2 = da.isel(time=time_index)
    else:
        da2 = da

    fig = plt.figure(figsize=figsize)
    ax = plt.axes(projection=ccrs.PlateCarree())
    im = ax.pcolormesh(
        da2["lon"], da2["lat"], da2,
        transform=ccrs.PlateCarree(), shading="auto",
        cmap=cmap, vmin=vmin, vmax=vmax
    )
    ax.coastlines(resolution="110m", linewidth=0.8)
    ax.add_feature(cfeature.BORDERS, linewidth=0.5)
    ax.set_global()
    ax.set_title(title or (da.name or "field"))
    cbar = plt.colorbar(im, ax=ax, orientation="vertical", pad=0.02)
    if cbar_label:
        cbar.set_label(cbar_label)
    plt.tight_layout()
    return fig, ax
