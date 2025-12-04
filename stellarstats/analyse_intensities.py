import os
import numpy as np
import pandas as pd
import re
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, BoundaryNorm

def calculate_peak_intensity_ratios(intensity_df, range_1, range_2):
    """
    Calculate the peak intensity ratios within specified ranges for each label.

    Parameters:
        intensity_df (pd.DataFrame): DataFrame with mean intensities for each label.
        range_1 (tuple): Wavelength range for the numerator in the ratio calculation (e.g., (670, 690)).
        range_2 (tuple): Wavelength range for the denominator in the ratio calculation (e.g., (705, 725)).

    Returns:
        pd.DataFrame: A DataFrame containing labels and their calculated intensity ratios.
    """
    # Filter rows for each range
    range_1_df = intensity_df[(intensity_df.index >= range_1[0]) & (intensity_df.index <= range_1[1])]
    range_2_df = intensity_df[(intensity_df.index >= range_2[0]) & (intensity_df.index <= range_2[1])]

    ratios = []
    labels = []

    for col in intensity_df.columns:
        if 'mean_intensity' in col:
            peak_range_1 = range_1_df[col].max()
            peak_range_2 = range_2_df[col].max()
            
            # Avoid division by zero
            ratio = peak_range_1 / peak_range_2 if peak_range_2 != 0 else np.nan
            
            label_number = col.split('_')[-1]
            labels.append(label_number)
            ratios.append(ratio)

    return pd.DataFrame({'Label Number': labels, 'Peak Intensity Ratio': ratios})

def plot_intensity_ratios_histogram(ratios_df, bins=20, output_dir="./", input_filename=None, save_output=False):
    """
    Plot a histogram of peak intensity ratios and save it as an SVG.

    Parameters:
        ratios_df (pd.DataFrame): DataFrame with 'Peak Intensity Ratio' column.
        bins (int): Number of histogram bins.
        output_dir (str): Directory to save the histogram SVG.
        input_filename (str): Base filename to use for saving the histogram.
        save_output (bool): Flag to determine if the output should be saved.
    """
    plt.figure(figsize=(10, 6))
    plt.hist(ratios_df['Peak Intensity Ratio'].dropna(), bins=bins, edgecolor='black')
    plt.xlabel("Peak Intensity Ratio")
    plt.ylabel("Frequency")
    plt.title("Histogram of Peak Intensity Ratios for Each Label")

    # Check if we should save the histogram
    if save_output and input_filename:
        # Construct the output filename based on the input filename
        base_name = os.path.splitext(input_filename)[0]  # Get the base name without extension
        histogram_path = os.path.join(output_dir, f"{base_name}_intensity_ratios_histogram.svg")
        plt.savefig(histogram_path, format='svg')
        print(f"Saved histogram to {histogram_path}")

    else:
        plt.show()

    plt.close()  # Close the figure to free memory


def get_ratio_mask(mask, ratios_df, input_filename, output_dir="./", save_output=False, vmax=None):
    """
    Visualize the mask with each region's ratio value as color and optionally save it as a TIFF.

    Parameters:
        mask (np.array): Original segmentation mask (2D array).
        ratios_df (pd.DataFrame): DataFrame containing labels and calculated intensity ratios.
        input_filename (str): The base name of the input file, used to name the saved output file.
        output_dir (str): Directory to save the TIFF mask.
        save_output (bool): Whether to save the output TIFF file.
    """
    mask_copy = np.copy(mask).astype(float)
    ratio_map = {int(row['Label Number']): row['Peak Intensity Ratio'] for _, row in ratios_df.iterrows()}

    for label, ratio in ratio_map.items():
        mask_copy[mask_copy == label] = ratio

    original_cmap = plt.cm.magma  # Or another colormap
    colors = original_cmap(np.linspace(0, 1, 256))  # Extract colors from the colormap
    colors[0] = [1, 1, 1, 1]  # Set the first color (for 0 values) to white (R, G, B, A)
    
    # Create a new colormap with the modified colors
    custom_cmap = ListedColormap(colors)
    
    # Plot using the custom colormap
    plt.figure(figsize=(10, 6))
    plt.imshow(mask_copy, cmap=custom_cmap, interpolation='nearest', vmin=0, vmax=vmax)
    plt.colorbar(label='Ratio Values')
    plt.title('Mask with Assigned Ratio Values')
    plt.xlabel('Width (pixels)')
    plt.ylabel('Height (pixels)')

    # Save the mask visualization as a TIFF file if save_output is True
    if save_output:
        sanitized_filename = re.sub(r'[^\w\-_\. ]', '_', os.path.splitext(input_filename)[0])  # Replace invalid characters with '_'
        output_filename = f"{sanitized_filename}_ratio_plot.svg"
        mask_visualization_path = os.path.join(output_dir, output_filename)
        plt.savefig(mask_visualization_path, format='svg')
        print(f"Saved ratio mask visualization to {mask_visualization_path}")

    else: 
        plt.show()
    
    plt.close()  # Close the figure to free memory


def calculate_combined_peak_intensity_ratios(combined_intensity_df, range_1, range_2):
    """
    Calculate the peak intensity ratios within specified ranges for each image.

    Parameters:
        combined_intensity_df (pd.DataFrame): Flat DataFrame with intensity data combined from various images.
        range_1 (tuple): Wavelength range for the numerator in the ratio calculation (e.g., (670, 690)).
        range_2 (tuple): Wavelength range for the denominator in the ratio calculation (e.g., (705, 725)).

    Returns:
        pd.DataFrame: A DataFrame containing image labels and their calculated intensity ratios.
    """
    # Initialize lists for storing results
    ratios = []
    images = []

    # Group by each image label
    for image, group in combined_intensity_df.groupby('image'):
        # Filter rows for each range
        range_1_df = group[(group.index >= range_1[0]) & (group.index <= range_1[1])]
        range_2_df = group[(group.index >= range_2[0]) & (group.index <= range_2[1])]

        # Calculate the max intensity within each range
        peak_range_1 = range_1_df['intensity'].max()
        peak_range_2 = range_2_df['intensity'].max()

        # Calculate the ratio, avoiding division by zero
        ratio = peak_range_1 / peak_range_2 if peak_range_2 != 0 else np.nan

        # Append results
        images.append(image)
        ratios.append(ratio)

    return pd.DataFrame({'Image': images, 'Peak Intensity Ratio': ratios})

