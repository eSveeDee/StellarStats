#!/usr/bin/env python3
"""stellarstats.analyse_cell_masks – compact helpers for per‑cell size/shape."""
from __future__ import annotations

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

try:
    from skimage.measure import regionprops
except ImportError:
    regionprops = None  # type: ignore

__all__ = [
    "calculate_cell_sizes",
    "plot_sphericity_mask",
]

# ------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------

def _feret_diameters(prop):
    """Return (max, min) Feret diameters in pixels for one regionprop."""
    max_f = getattr(prop, "feret_diameter_max", prop.major_axis_length)
    min_f = getattr(prop, "feret_diameter_min", prop.minor_axis_length)
    return max_f, min_f


# ------------------------------------------------------------------
# Public API: size / shape table
# ------------------------------------------------------------------

def calculate_cell_sizes(
    mask: np.ndarray,
    *,
    pixel_size_x: float | None = None,
    pixel_size_y: float | None = None,
    image_name: str | None = None,
    compute_shape: bool = True,
) -> pd.DataFrame:
    """Return per‑cell size (and optional shape) metrics from *mask*."""

    mask = np.asarray(mask)
    if mask.ndim != 2:
        raise ValueError(f"mask must be 2‑D – got shape {mask.shape}")

    sizes = np.bincount(mask.ravel())
    labels = np.nonzero(sizes)[0]
    if labels.size == 0:
        return pd.DataFrame({"label": [], "size_px": []})

    records: list[dict[str, float | int | str]] = []

    if compute_shape:
        if regionprops is None:
            raise ImportError(
                "scikit‑image required for shape metrics; install it or set compute_shape=False."
            )
        for prop in regionprops(mask):
            max_f, min_f = _feret_diameters(prop)
            rec = {
                "label": prop.label,
                "size_px": prop.area,
                "max_feret_px": max_f,
                "min_feret_px": min_f,
                "sphericity": min_f / max_f if max_f else np.nan,
            }
            records.append(rec)
    else:
        for lab in labels:
            records.append({"label": int(lab), "size_px": int(sizes[lab])})

    if pixel_size_x is not None and pixel_size_y is not None:
        for rec in records:
            area_um2 = rec["size_px"] * pixel_size_x * pixel_size_y
            rec["size_um2"] = area_um2
            rec["equivalent_diameter_um"] = 2 * np.sqrt(area_um2 / np.pi)

    if image_name is not None:
        for rec in records:
            rec["image"] = image_name

    df = pd.DataFrame.from_records(records)
    preferred = [
        "label",
        "image",
        "size_px",
        "size_um2",
        "equivalent_diameter_um",
        "max_feret_px",
        "min_feret_px",
        "sphericity",
    ]
    return df[[c for c in preferred if c in df.columns]]


# Legacy alias
calculate_cell_metrics = calculate_cell_sizes

# ------------------------------------------------------------------
# Visualisation helper – sphericity heat‑map on mask
# ------------------------------------------------------------------
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap


def plot_sphericity_mask(
    mask: np.ndarray,
    sizes_df: pd.DataFrame,
    *,
    vmax: float | None = 1.0,
    cmap: str | LinearSegmentedColormap = "viridis",
    save_path: str | None = None,
) -> None:
    """Plot or save a label mask coloured by *sphericity* (min/max Feret)."""

    mask_float = mask.astype(float)
    sph_map = dict(zip(sizes_df["label"], sizes_df["sphericity"]))
    for lbl, val in sph_map.items():
        mask_float[mask == lbl] = val

    if vmax is None:
        vmax = float(sizes_df["sphericity"].max())

    plt.figure(figsize=(8, 6))
    im = plt.imshow(mask_float, cmap=cmap, vmin=0, vmax=vmax, interpolation="nearest")
    plt.colorbar(im, label="Sphericity (min / max Feret)")
    plt.axis("off")

    if save_path:
        plt.savefig(save_path, format="png", bbox_inches="tight")
        plt.close()
    else:
        plt.show()
        plt.close()
