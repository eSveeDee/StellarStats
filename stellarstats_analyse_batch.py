#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import glob
import argparse
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sys


def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Batch analysis of spectral data from lambda scans. Processes all images in a specified input directory.")
    parser.add_argument('-p', '--project_dir', type=str, default="./", help="Project directory path. Outputs will be saved in this directory.")
    parser.add_argument('--plot_intensity', action='store_true', help="Plot raw intensity values for each file.")
    parser.add_argument('--plot_normalized_intensity', action='store_true', help="Plot normalized intensity values for each file.")
    parser.add_argument('--normalization', type=str, default="max", choices=["max", "range"], help="Normalization type for intensity plot.")
    parser.add_argument('--min', type=float, help="Minimum value for range normalization.")
    parser.add_argument('--max', type=float, help="Maximum value for range normalization.")
    
    parser.add_argument('--get_ratios', action='store_true', help="Calculate peak intensity ratios for each file.")
    parser.add_argument('--ratio_histogram', action='store_true', help="Plot histogram of intensity ratios for each file.")
    parser.add_argument('--ratio_mask', action='store_true', help="Generate ratio mask visualization for each file.")
    parser.add_argument('--vmax', type=int, default=None, help="Max value for ratio mask. Set to defined value to compare bewteen images. Default: None (scale to max of dataset)")
    parser.add_argument('--range1', type=int, nargs=2, default=(670, 690), help="Wavelength range 1 for ratio calculation. Default: 670 690 (PSII).")
    parser.add_argument('--range2', type=int, nargs=2, default=(705, 725), help="Wavelength range 2 for ratio calculation. Default: 705 725 (PSI).")
    parser.add_argument('--bins', type=int, default=20, help="Number of bins for ratio histogram. Default: 20.")

    parser.add_argument('--shape_metrics', action='store_true', help='Add max/min Feret diameters and sphericity.')
    parser.add_argument('--sphericity_mask', action='store_true', help='Plot cell masks back, coloured by the sphericity metric.')
    
    parser.add_argument('--save_output', action='store_true', help="Save output dataframes and figures.")
    args = parser.parse_args()

    from stellarstats.extract_spectra import (
        load_mask,
        calculate_intensity,
        read_meta,
        plot_combined_intensities,
        plot_normalized_combined_intensities,
    )
    from stellarstats.analyse_intensities import (
        calculate_peak_intensity_ratios,
        plot_intensity_ratios_histogram,
        get_ratio_mask,
        calculate_peak_intensity_ratios,
        calculate_combined_peak_intensity_ratios,
    )
    from stellarstats.analyse_cell_masks import (
        calculate_cell_sizes,
        plot_sphericity_mask
    )

    # Setup directories
    input_dir = args.project_dir  # Use the provided project directory as the main input directory
    mask_dir = os.path.join(input_dir, "Masks")  # Masks directory
    xml_dir = os.path.join(input_dir, "MetaData")  # MetaData directory for XML files

    # Find all .npy segmentation files in the Masks directory
    segmentation_files = glob.glob(os.path.join(mask_dir, "*.npy"))

    combined_intensity_data = []
    combined_size_data = []

    # Process each file in the Masks directory
    for segmentation_npy_path in segmentation_files:
        # Extract the base name of the segmentation file (without path)
        base_name = os.path.basename(segmentation_npy_path)
        
        # Construct the corresponding image stack path by replacing the "_MIP_seg.npy" suffix with ".tif"
        image_stack_path = os.path.join(input_dir, base_name.replace("_MIP_seg.npy", ".tif"))
        
        # Construct the corresponding XML metadata file path by replacing "_RAW_ch00_MIP_seg.npy" with "_Properties.xml"
        xml_file_path = os.path.join(xml_dir, base_name.replace("_MIP_seg.npy", "_Properties.xml"))

        if not os.path.exists(image_stack_path):
            print(f"Image file not found for {segmentation_npy_path}. Skipping...")
            continue
        if not os.path.exists(xml_file_path):
            print(f"Metadata XML file not found for {segmentation_npy_path}. Skipping...")
            continue

        print(f"Processing file: {base_name}")

        # Load the mask
        mask = load_mask(segmentation_npy_path)

        # Calculate intensities
        intensity_df = calculate_intensity(image_stack_path, mask)

        # Identify all columns with intensity values
        intensity_columns = [col for col in intensity_df.columns if col.startswith("_mean_intensity")]

        # Read emission details
        emission_details = read_meta(xml_file_path)
        if emission_details is None:
            print(f"Failed to read metadata for {xml_file_path}. Skipping...")
            continue

        # Calculate cell sizes from mask
        size_df = calculate_cell_sizes(
                      mask,
                      pixel_size_x=emission_details.get('Pixel Size X (µm)'),
                      pixel_size_y=emission_details.get('Pixel Size Y (µm)'),
                      image_name=base_name.replace('_MIP_seg.npy', ''),
                      compute_shape=args.shape_metrics
                  )
        combined_size_data.append(size_df)

        # Save cell sizes
        if args.save_output:
            size_csv_path = os.path.join(input_dir, "combined_cell_sizes.csv")
            size_df.to_csv(size_csv_path, index=False)
            print(f"Saved cell sizes to {size_csv_path}")

        if args.sphericity_mask:
            plot_sphericity_mask(
                mask,
                size_df,
                vmax=None,                      # or None to autoscale
                save_path=os.path.join(args.project_dir,
                               base_name.replace('_MIP_seg.npy', '_sphericity.png'))
                if args.save_output else None
            )

        # Generate wavelength range (note lack of bandwidth correction --> doublecheck if correct)
        start_range = int(float(emission_details['Emission Start (nm)'])) #+ int(emission_details['Detection Bandwidth (nm)']) / 2
        end_range = int(float(emission_details['Emission End (nm)'])) #+ int(emission_details['Detection Bandwidth (nm)']) / 2
        n_steps = int(emission_details['Number of Steps'])
        wavelength = np.linspace(start_range, end_range, n_steps)
        intensity_df['wavelength'] = wavelength
        intensity_df = intensity_df.set_index('wavelength')

        # Restructure intensity data for combined plotting
        for col in intensity_columns:
            temp_df = intensity_df[[col]].copy()
            temp_df.rename(columns={col: 'intensity'}, inplace=True)
            temp_df['image'] = f"{base_name}_{col}"  # Use unique label for each intensity column
            combined_intensity_data.append(temp_df)

        if args.ratio_mask:
            range_1 = (args.range1[0], args.range1[1])
            range_2 = (args.range2[0], args.range2[1])
            ratios_df = calculate_peak_intensity_ratios(intensity_df, range_1, range_2)

            get_ratio_mask(
                    mask,
                    ratios_df,
                    input_filename=base_name,
                    output_dir=args.project_dir,
                    save_output=args.save_output,
                    vmax=args.vmax
                )

    # Check if combined_intensity_data is not empty
    if combined_intensity_data:
        # Combine all intensity data into a single DataFrame, ensuring wavelength is the index
        combined_intensity_df = pd.concat(combined_intensity_data, ignore_index=False)

        # Save combined intensity data to a single CSV file
        if args.save_output:
            combined_csv_path = os.path.join(args.project_dir, "combined_intensity_data.csv")
            combined_intensity_df.to_csv(combined_csv_path)
            print(f"Saved combined intensity data to {combined_csv_path}")

        # Conditional actions based on flags
        if args.plot_intensity:
            plot_combined_intensities(
                combined_intensity_df,
                save_output=args.save_output,
                output_dir=args.project_dir
            )

        if args.plot_normalized_intensity:
            plot_normalized_combined_intensities(
                combined_intensity_df,
                normalization=args.normalization,
                range_min=args.min,
                range_max=args.max,
                save_output=args.save_output,
                output_dir=args.project_dir
            ) 

        if args.get_ratios or args.ratio_histogram:
            # Calculate ratios
            range_1 = (args.range1[0], args.range1[1])
            range_2 = (args.range2[0], args.range2[1])
            ratios_df = calculate_combined_peak_intensity_ratios(combined_intensity_df, range_1, range_2)

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
                    input_filename="combined",  # Pass only the filename part
                    save_output=args.save_output   # Pass the save_output flag
                )


    else:
        print("No intensity data found. Check that your input files are correctly set up.")

if __name__ == "__main__":
    main()
