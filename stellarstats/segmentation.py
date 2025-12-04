#!/usr/bin/env python3

"""
Module Name: segmentation
Description: Functions for segmenting images using Cellpose.
"""

import os
from cellpose import models, io

def segment_image(file_path, model, channels, diameter, flow_th, cellprob):
    img = io.imread(file_path)
    masks, flows, styles, diams = model.eval(img, diameter=diameter, channels=channels, flow_threshold = flow_th, cellprob_threshold = cellprob)
    return masks, flows

def save_segmentation_outputs(mip_image, masks, flows, tiff_path, output_dir):
    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Derive the base name for saving files
    base_name = os.path.splitext(os.path.basename(tiff_path))[0]
    
    # Create paths for the npy and png outputs
    npy_path = os.path.join(output_dir, f"{base_name}_MIP.npy")
    png_path = os.path.join(output_dir, f"{base_name}_MIP.png")

    # Save the segmentation outputs
    io.masks_flows_to_seg(mip_image, masks, flows, npy_path, diams=None, channels=[0, 0])
    io.save_to_png(mip_image, masks, flows, png_path)
    print(f"Segmentation saved to {npy_path} and {png_path}")