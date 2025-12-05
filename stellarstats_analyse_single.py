#!/usr/bin/env python3

"""
Module Name: Analyse single
Description: Full analysis of spectral data extracted from one tomogram.



"""

import os
import argparse
import numpy as np
import sys


def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Analyze spectral data from a single lambda scan, that has already been segmented. Input is a lamda scan (tiff) and its metadata file, segmentation mask is presumed to be in <project_dir>/Masks.")
    parser.add_argument('-p', '--project_dir', type=str, default="./", help="Project directory path. Output will end up in this directory.")
    parser.add_argument('-i', '--input_file', type=str, required=True, help="Path to input image stack (TIFF format).")
    parser.add_argument('-m', '--meta_file', type=str, required=True, help="(Full) path to input Leica metadata file, e.g. 'Lambda001_Properties.xml' (XML format).")
    

    parser.add_argument('--plot_intensity', action='store_true', help="Plot raw intensity values.")
    parser.add_argument('--plot_normalized_intensity', action='store_true', help="Plot normalized intensity values.")
    parser.add_argument('--normalization', type=str, default="max", choices=["max", "range"], help="Normalization type for intensity plot.")
    parser.add_argument('--min', type=float, help="Minimum value for range normalization.")
    parser.add_argument('--max', type=float, help="Maximum value for range normalization.")
    parser.add_argument('--get_ratios', action='store_true', help="Calculate peak intensity ratios.")
    parser.add_argument('--ratio_histogram', action='store_true', help="Plot histogram of intensity ratios.")
    parser.add_argument('--ratio_mask', action='store_true', help="Generate ratio mask visualization.")
    parser.add_argument('--vmax', type=float, default=None, help="Max value for ratio mask. Set to defined value to compare bewteen images. Default: None (scale to max of dataset)")
    parser.add_argument('--range1', type=int, nargs=2, default=(670, 690), help="Wavelength range 1 for ratio calculation. Takes two wavelength inputs (in nm).Default: 670 690 (PSII)")
    parser.add_argument('--range2', type=int, nargs=2, default=(705, 725), help="Wavelength range 2 for ratio calculation. Takes two wavelength inputs (in nm). Default: 705 725 (PSI)")
    parser.add_argument('--bins', type=int, default=20, help="Number of bins for ratio histogram. Default:20")
    parser.add_argument('--save_output', action='store_true', help="Save output dataframes as CSV files and output figures as SVG files.")
    args = parser.parse_args()


    from stellarstats.extract_spectra import (
        load_mask,
        calculate_intensity,
        read_meta,
        plot_intensities,
        plot_normalized_intensities,
    )
    
    from stellarstats.analyse_cell_masks import (
        calculate_cell_sizes,
    )
    
    from stellarstats.analyse_intensities import (
        calculate_peak_intensity_ratios,
        plot_intensity_ratios_histogram,
        get_ratio_mask,
    )


    # Setup paths with separate mask directory
    image_stack_path = args.input_file
    mask_dir = os.path.join(args.project_dir, "Masks")
    input_filename = os.path.basename(args.input_file)  # Extracts the file name from the full path
    segmentation_filename = os.path.splitext(input_filename)[0] + "_MIP_seg.npy"  
    segmentation_npy_path = os.path.join(mask_dir, segmentation_filename)
    xml_file_path = args.meta_file

    # Load the mask
    mask = load_mask(segmentation_npy_path)

    # Calculate intensities 
    intensity_df = calculate_intensity(image_stack_path, mask)
    
    # Extract emission details
    emission_details = read_meta(xml_file_path)

    #Extract cell size    
    px_x = emission_details['Pixel Size X (µm)']
    px_y = emission_details['Pixel Size Y (µm)']
    size_df = calculate_cell_sizes(mask)
    size_df['size_um2'] = size_df['size_px'] * px_x * px_y

    # Generate the wavelength column based on emission details
    start_range = int(emission_details['Emission Start (nm)'])
    end_range = int(emission_details['Emission End (nm)'])
    n_steps = int(emission_details['Number of Steps'])
    wavelength = np.linspace(start_range, end_range, n_steps)

    # Organize the data
    intensity_df['wavelength'] = wavelength
    intensity_df.set_index('wavelength', inplace=True)

    # Save intensity_df if --save_output is specified
    if args.save_output:
        intensity_csv_path = os.path.join(args.project_dir, "intensity_data.csv")
        intensity_df.to_csv(intensity_csv_path)
        print(f"Saved intensity data to {intensity_csv_path}")

        size_csv_path = os.path.join(args.project_dir, "cell_sizes.csv")
        size_df.to_csv(size_csv_path, index=False)
        print(f"Saved cell sizes to {size_csv_path}")

    # Conditional actions based on flags
    if args.plot_intensity:
        plot_intensities(
            intensity_df,
            input_filename=input_filename,
            save_output=args.save_output,
            output_dir=args.project_dir
        )

    if args.plot_normalized_intensity:
        plot_normalized_intensities(
            intensity_df,
            normalization=args.normalization,
            range_min=args.min,
            range_max=args.max,
            input_filename=input_filename,
            save_output=args.save_output,
            output_dir=args.project_dir
        )   
    if args.get_ratios or args.ratio_histogram or args.ratio_mask:
        # Calculate ratios
        range_1 = (args.range1[0], args.range1[1])
        range_2 = (args.range2[0], args.range2[1])
        ratios_df = calculate_peak_intensity_ratios(intensity_df, range_1, range_2)

        if args.save_output:
            # Save ratios_df if --save_output is specified
            ratios_csv_path = os.path.join(args.project_dir, "intensity_ratios.csv")
            ratios_df.to_csv(ratios_csv_path)
            print(f"Saved intensity ratios to {ratios_csv_path}")

        if args.get_ratios:
            print(ratios_df)

        if args.ratio_histogram:
            plot_intensity_ratios_histogram(
                ratios_df,
                bins=args.bins,
                output_dir=args.project_dir,  # Pass the project directory for saving
                input_filename=os.path.basename(args.input_file),  # Pass only the filename part
                save_output=args.save_output   # Pass the save_output flag
            )

        if args.ratio_mask:
                get_ratio_mask(
                    mask,
                    ratios_df,
                    input_filename=os.path.basename(args.input_file),  # Only pass the filename part
                    output_dir=args.project_dir,  # Ensure you pass the correct output directory
                    save_output=args.save_output,   # Pass the save_output flag
                    vmax = args.vmax
                )

if __name__ == "__main__":
    main()