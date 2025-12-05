# **StellarStats**

StellarStats is a Python toolkit for extracting and analysing spectral data from fluorescence microscopy images acquired on Leica Stellaris systems. It provides a command-line workflow to:

- Segment cells in lambda-scan stacks using Cellpose.
- Extract per-cell emission spectra from lambda scans.
- Compute and visualise peak intensity ratios.
- Optionally derive simple shape metrics (Feret diameters, sphericity). \


StellarStats is designed to work on lambda-scan TIFF stacks with matching Leica XML metadata files. \
Additional notebooks are provided for more extensive analysis.

---

## **Installation**

### 1. Create a conda environment

```bash
conda create -n stellarstats python=3.10
conda activate stellarstats
```
### 2. Install dependencies and StellarStats

Install directly from github (for users)
```bash
pip install "git+https://github.com/eSveeDee/StellarStats.git"
```
Install from local clone (for developers)
```bash
git clone https://github.com/eSveeDee/StellarsStats.git
cd StellarStats
pip install -e .
pip install -r requirements.txt
```

## **Expected data structure**

StellarStats assumes a per-project directory with:

```bash
project_dir/
  Series001.tif
  Series002.tif
  ...
MetaData/
  Series001_Properties.xml
  Series002_Properties.xml
    ...
```

During segmentation and analysis, the following subdirectories are created:

- `MIPs/` – maximum-intensity projections of the lambda stacks.

- `Masks/` – segmentation outputs:

    - `*_MIP_seg.npy` (label mask)

    - `*_MIP_cp_masks.png` (mask visualisation)


The batch analysis scripts operate on this structure and assume this nomenclature.

## **Workflow overview**

1. Segment cells on 2D MIPs using Cellpose:

   - Test parameters on a single TIFF stack.
   - Run batch segmentation for all TIFFs in a folder.

2. Analyse spectra:

   - Extract per-cell spectra and plot (absolute or normalised).
   - Compute peak intensity ratios between two wavelength ranges.
   - Visualise ratios as histograms or as values mapped back onto the masks.

3. (Optional) Shape metrics:

   - Compute per-cell area and simple shape descriptors (Feret diameters, sphericity).
   - Visualise sphericity mapped onto masks.

4. Use generated csv outputs for further comparitive analyses (see notebooks for examples).


## **Usage**

For ease of use, it is recommended to run StellarStats from the `run_stellarstats.ipynb` notebook. \
Alternatively, all scripts can be use directly from the command line within your conda environment.

### 1. Cell segmentation

Segmentation is performed by [CellPose](https://cellpose.readthedocs.io/en/latest/) on 2D maximum intensity projections (MIPs) of each 3D lambda stack. \
This ensures a consistent 2D cell mask for the full spectral stack. \
Each identified cell instance is assigned a unique identifier value. 

#### 1.1 Segmenting a single TIFF stack
Use trial mode to optimise segmentation parameters for your data and visually inspect results:
```python
python run/stellarstats_segment_single.py \
    --tiff path/to/Series001.tif \
    --use_gpu \
    --trial
```
_Using a gpu is optional but recommended to speed up segmentation._

Key options:

`--tiff`: input 3D TIFF stack.

`--model_type`: Cellpose model (default: cyto3).

`--mip_dir`: output directory for MIPs (default: MIPs).

`--output_dir`: output directory for masks (default: Masks).

`--diameter`: approximate cell diameter (pixels).

`--channels`: channels used for segmentation (e.g. [0 0] for grayscale).

`--use_gpu` enable GPU if available.

`--trial`: display segmentation without saving output, use for tuning.

Parameters that most strongly affect segmentation quality:

`diameter`: override automatic size detection.

`flows`: flow-error threshold; higher → accept more masks.

`cellprob`: cell probability threshold; lower → more inclusive, higher → more conservative.

#### 1.2 Batch segmentation
Once settled on parameters for cell-segmentation, run segmentation on all TIFFs in a given directory:

```python
python run/stellarstats_segment_batch.py \
    -i /path/to/project_dir \
    --use_gpu
```
_Using a gpu is optional but recommended to speed up segmentation._

Outputs can be inspected by opening `Masks/*_MIP_cp_masks.png` in Fiji (recommended visualisation is LUT with distinct adjacent bins to judge segmentation quality, e.g. `glasbey-on-dark`).

### 2. Extract and analyse spectra
The analysis scripts:

- Extract per-cell emission spectra from segmented lambda scans.
- Plot spectra (raw or normalised, one line per cell).
- Compute intensity ratios between two peaks within specified ranges of the spectrum.
- Visualise peak ratios as histograms and/or as values mapped back onto the mask.

#### 2.1 Analysing a single image
To plot per-cell spectra from a single image, run:
```python
python run/stellarstats_analyse_single.py \
    -p /path/to/project_dir \
    -i /path/to/project_dir/Series001.tif \
    -m /path/to/project_dir/MetaData/Series001_Properties.xml \
    --plot_intensity \
    --ratio_histogram \
    --ratio_mask \
    --save_output
```

What this does:

1. Reads the TIFF, metadata XML, and corresponding mask from project_dir/Masks.
2. Builds per-cell spectra as a function of wavelength.

Optionally plots:

- raw spectra (`--plot_intensity`)
- normalised spectra (`--plot_normalized_intensity`, with `--normalization max|range`)
- ratio histograms (`--ratio_histogram`)
- ratio masks (--ratio_mask) \
    --> By default, the ratio is computed between wavelength windows corresponding to PSII and PSI regimes of the spectrum. (i.e. `--range1 670 690, --range2 705 725`), which can be changed.

With `--save_output`, it writes:

- Per-cell intensity tables (CSV).
- Per-cell ratio tables (CSV).
- SVG plots suitable for editing (e.g. Illustrator).

#### 2.2 Batch analysis
To analyse all scans in a standard project directory, run:
```python
python run/stellarstats_analyse_batch.py \
    -p /path/to/project_dir \
    --plot_normalized_intensity \
    --ratio_histogram \
    --bins 50 \
    --save_output
```

Batch analysis:
1. Looks for all *_MIP_seg.npy files in project_dir/Masks.
2. Infers the corresponding TIFF and metadata XML paths.
3. Aggregates per-cell spectra across all fields into a combined table.
4. Computes combined peak intensity ratios (e.g. PSII/PSI windows).

Produces:

- a combined intensity CSV (`combined_intensity_data.csv`)
- a combined ratio CSV (`intensity_ratios.csv`)
- spectra plots and ratio histograms, if requested.

The per-cell intensity columns follow a naming convention such as: \
`{segmentation_name}_mean_intensity_{cell_label}`

**For further analysis and comparison between conditions, see attached Jupyter Notebooks.**

## **Notes and limitations**

The batch scripts assume a naming convention consistent between TIFF stacks, Leica metadata (_Properties.xml), and the generated mask files (_MIP_seg.npy).\
If your acquisition uses different naming conventions, you may need to adapt the mapping logic in the analysis scripts where TIFF and XML filenames are constructed from the mask filenames.

Segmentation is currently 2D (MIP-based); 3D segmentation for lambda stacks is currently not implemented.

## License

StellarStats is licensed under the Creative Commons Attribution 4.0
International License (CC BY 4.0). See the `LICENSE` file for details.