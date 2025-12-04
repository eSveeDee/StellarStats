"""
StellarStats: segmentation and spectral analysis tools for spectrally
resolved cryo light microscopy / CLEM data.

Typical usage:

    from stellarstats import segment_image, create_mip, calculate_cell_sizes

or, for more advanced control:

    from stellarstats import segmentation, extract_spectra, analyse_intensities
"""

from importlib.metadata import PackageNotFoundError, version as _version

# Package version
try:
    __version__ = _version("stellarstats")
except PackageNotFoundError:
    # Fallback when running from source without installation
    __version__ = "0.0.0"

# Re-export key functions used by your CLI scripts
from .segmentation import segment_image, save_segmentation_outputs
from .mip import create_mip
from .image_io import read_images, save_image
from .file_management import move_files

from .extract_spectra import (
    load_mask,
    calculate_intensity,
    read_meta,
    plot_intensities,
    plot_normalized_intensities,
    plot_combined_intensities,
    plot_normalized_combined_intensities,
)

from .analyse_intensities import (
    calculate_peak_intensity_ratios,
    plot_intensity_ratios_histogram,
    get_ratio_mask,
    calculate_combined_peak_intensity_ratios,
)

from .analyse_cell_masks import (
    calculate_cell_sizes,
    plot_sphericity_mask,
)

# Optionally expose the submodules themselves
from . import (
    segmentation,
    mip,
    image_io,
    file_management,
    extract_spectra,
    analyse_intensities,
    analyse_cell_masks,
)

__all__ = [
    "__version__",
    # High-level functions
    "segment_image",
    "save_segmentation_outputs",
    "create_mip",
    "read_images",
    "save_image",
    "move_files",
    "load_mask",
    "calculate_intensity",
    "read_meta",
    "plot_intensities",
    "plot_normalized_intensities",
    "plot_combined_intensities",
    "plot_normalized_combined_intensities",
    "calculate_peak_intensity_ratios",
    "plot_intensity_ratios_histogram",
    "get_ratio_mask",
    "calculate_combined_peak_intensity_ratios",
    "calculate_cell_sizes",
    "plot_sphericity_mask",
    # Submodules
    "segmentation",
    "mip",
    "image_io",
    "file_management",
    "extract_spectra",
    "analyse_intensities",
    "analyse_cell_masks",
]
