# stellarstats/segmentation_analysis.py

import os
import numpy as np
import tifffile as tiff
import pandas as pd
import matplotlib.pyplot as plt
import xml.etree.ElementTree as ET

def load_mask(segmentation_npy_path):
    """Load segmentation mask from .npy file."""
    seg_file = np.load(segmentation_npy_path, allow_pickle=True).item()
    return seg_file['masks']


def calculate_intensity(image_stack_path, mask, statistic="mean"):
    """
    Calculate intensity statistics for each region in the mask across image slices.

    Parameters:
    - image_stack_path: str
        Path to the image stack (TIFF file).
    - mask: np.array
        2D array representing the labeled regions in the mask.
    - statistic: str
        Statistic to use for calculating intensity. Options: "mean", "median", "sum".
    """
    # Load image stack
    image_stack = tiff.imread(image_stack_path)
    
    # Validations
    assert len(mask.shape) == 2, "Mask should be 2D to apply to each image slice."
    #assert image_stack.shape[1:] == mask.shape, "Each image slice and mask dimensions do not match."
    
    # Determine which numpy function to use based on statistic
    if statistic == "mean":
        stat_func = np.mean
    elif statistic == "median":
        stat_func = np.median
    elif statistic == "sum":
        stat_func = np.sum
    else:
        raise ValueError("Statistic must be 'mean', 'median', or 'sum'.")

    all_slices_intensities = []

    for slice_idx in range(image_stack.shape[0]):
        slice_data = image_stack[slice_idx]   
        slice_intensities = {"slice": slice_idx}
        unique_labels = np.unique(mask)

        for label in unique_labels:
            if label == 0:  # Skip background
                continue
            region_mask = (mask == label)
            region_intensities = slice_data[region_mask]
            slice_intensities[f"_{statistic}_intensity_{label}"] = stat_func(region_intensities)
        
        all_slices_intensities.append(slice_intensities)

    # Convert to DataFrame
    intensity_df = pd.DataFrame(all_slices_intensities)
    max_vals = intensity_df.max(axis=0)
    drop_col = ['slice'] + max_vals[max_vals < 2].index.tolist() #removing segmented regions with max value below 2 to drop false positive segmentations.
    intensity_df = intensity_df.drop(columns=drop_col, errors="ignore")
    return intensity_df



def read_meta(xml_file_path):
    """Extract emission details from the provided XML metadata file."""
    try:
        tree = ET.parse(xml_file_path)
        root = tree.getroot()

        emission_details = {
            'Emission Start (nm)': None,
            'Emission End (nm)': None,
            'Detection Bandwidth (nm)': None,
            'Number of Steps': None
        }

        lambda_emission = root.find('.//LambdaEmission')
        if lambda_emission is not None:
            emission_details['Emission Start (nm)'] = lambda_emission.get('LambdaDetectionBegin')
            emission_details['Emission End (nm)'] = lambda_emission.get('LambdaDetectionEnd')
            emission_details['Detection Bandwidth (nm)'] = lambda_emission.get('LambdaDetectionBandWidth')
            emission_details['Number of Steps'] = str(lambda_emission.get('LambdaDetectionStepCount'))

        for dim_desc in root.findall('.//DimensionDescription'):
            dim_id = dim_desc.get('DimID')
            voxel_size = dim_desc.get('Voxel')
            if voxel_size:
                voxel_size = float(voxel_size)
                if dim_id == 'X':
                    emission_details['Pixel Size X (µm)'] = voxel_size
                elif dim_id == 'Y':
                    emission_details['Pixel Size Y (µm)'] = voxel_size

        return emission_details

    except ET.ParseError as e:
        print(f"Error parsing XML file: {e}")
    except FileNotFoundError:
        print(f"File not found at the path: {xml_file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

def plot_intensities(intensity_df, input_filename, save_output=False, output_dir="./"):
    """
    Plot raw intensity values and optionally save the plot as a PNG.
    
    Parameters:
    - intensity_df (pd.DataFrame): DataFrame with intensity data.
    - input_filename (str): Name of the input file to base the output name.
    - save_output (bool): If True, save the plot as a PNG.
    - output_dir (str): Directory to save the plot.
    """
    plt.figure(figsize=(12, 8))
    for col in intensity_df.columns:
        plt.plot(intensity_df.index, intensity_df[col], label=col)
    
    plt.xlabel("Wavelength (nm)")
    plt.ylabel("Fluroescence Intensity")
    plt.title("Fluorescence intensity spectrum per segmented area")
    #plt.legend(loc='upper right')
    plt.tight_layout()
    
    if save_output:
        plot_path = os.path.join(output_dir, f"{os.path.splitext(input_filename)[0]}_spectrum.svg")
        plt.savefig(plot_path, format="svg")
        print(f"Saved raw intensity plot to {plot_path}")
    else:
        plt.show()
    
    plt.close()


def plot_normalized_intensities(intensity_df, normalization="max", range_min=None, range_max=None, 
                                input_filename=None, save_output=False, output_dir="./"):
    """
    Plot normalized intensity for each label and optionally save as a PNG.
    
    Parameters:
    - intensity_df (pd.DataFrame): DataFrame with intensity data.
    - statistic (str): Statistic for normalization.
    - normalization (str): Normalization method ("max" or "range").
    - range_min (float): Min value for range normalization.
    - range_max (float): Max value for range normalization.
    - input_filename (str): Name of the input file to base the output name.
    - save_output (bool): If True, save the plot as a PNG.
    - output_dir (str): Directory to save the plot.
    """
    x_values = intensity_df.index
    plt.figure(figsize=(12, 8))

    for col in intensity_df.columns:
        # Apply normalization based on specified range
        if normalization == "range" and range_min is not None and range_max is not None:
            # Filter for the specified wavelength range
            range_mask = (x_values >= range_min) & (x_values <= range_max)
            values_in_range = intensity_df[col][range_mask]
            if not values_in_range.empty:
                max_in_range = values_in_range.max()
                normalized_intensity = intensity_df[col] / max_in_range
            else:
                print(f"No wavelengths in range [{range_min}, {range_max}] for {col}. Skipping.")
                continue
        else:
            max_value = intensity_df[col].max()
            normalized_intensity = intensity_df[col] / max_value
            
        plt.plot(x_values, normalized_intensity, label=col)

    plt.xlabel("Wavelength (nm)")
    plt.ylabel(f"Normalized Fluorescence Intensity")
    plt.title(f"Normalized Fluorescence Intensity per segmented area")
    #plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
    plt.tight_layout()

    if save_output:
        plot_path = os.path.join(output_dir, f"{os.path.splitext(input_filename)[0]}_normalized_spectrum.svg")
        plt.savefig(plot_path, format="svg")
        print(f"Saved normalized intensity plot to {plot_path}")
    else:
        plt.show()
    
    plt.close()

def plot_combined_intensities(combined_intensity_df, save_output=False, output_dir="./"):
    """
    Plot raw intensity values and optionally save the plot as a PNG.
    
    Parameters:
    - combined_intensity_df (pd.DataFrame): Flat DataFrame with intensity data combined from various images.
    - save_output (bool): If True, save the plot as a PNG.
    - output_dir (str): Directory to save the plot.
    """ 
    plt.close()

    plt.figure(figsize=(12, 8))
    for name, group in combined_intensity_df.groupby('image'):
        plt.plot(group.index, group['intensity'], label=name)

    plt.xlabel("Wavelength (nm)")
    plt.ylabel("Intensity")
    plt.title("Combined Intensity Plot")
    #plt.legend()
    if save_output:
        combined_plot_path = os.path.join(output_dir, "combined_intensity_plot.svg")
        plt.savefig(combined_plot_path, format="svg")
        print(f"Saved combined intensity plot to {combined_plot_path}")
    else:
        plt.show()

    plt.close()

def plot_normalized_combined_intensities(combined_intensity_df, normalization="max", range_min=None, range_max=None, 
                                         save_output=False, output_dir="./"):
    """
    Plot normalized intensity values for each image in combined data and optionally save the plot.
    
    Parameters:
    - combined_intensity_df (pd.DataFrame): DataFrame with combined intensity data from various images.
    - normalization (str): Normalization method ("max" or "range").
    - range_min (float): Min value for range normalization.
    - range_max (float): Max value for range normalization.
    - save_output (bool): If True, save the plot as a PNG.
    - output_dir (str): Directory to save the plot.
    """

    # Prepare figure
    plt.figure(figsize=(12, 8))

    # Normalize and plot each image group
    for name, group in combined_intensity_df.groupby('image'):
        if normalization == "range" and range_min is not None and range_max is not None:
            # Normalize within the specified wavelength range
            range_mask = (group.index >= range_min) & (group.index <= range_max)
            values_in_range = group['intensity'][range_mask]
            if not values_in_range.empty:
                max_in_range = values_in_range.max()
                normalized_intensity = group['intensity'] / max_in_range
            else:
                print(f"No wavelengths in range [{range_min}, {range_max}] for {name}. Skipping.")
                continue
        else:
            # Default to max normalization
            max_value = group['intensity'].max()
            normalized_intensity = group['intensity'] / max_value
            
        # Plot the normalized intensity curve
        plt.plot(group.index, normalized_intensity, label=name)

    # Configure plot labels and title
    plt.xlabel("Wavelength (nm)")
    plt.ylabel("Normalized Intensity")
    plt.title("Normalized Combined Intensity Plot")
    plt.tight_layout()
    
    # Optional: Save or show the plot
    if save_output:
        os.makedirs(output_dir, exist_ok=True)
        plot_path = os.path.join(output_dir, "normalized_combined_intensity_plot.svg")
        plt.savefig(plot_path, format="svg")
        print(f"Saved normalized combined intensity plot to {plot_path}")
    else:
        plt.show()

    plt.close()  # Close the plot after displaying or saving

