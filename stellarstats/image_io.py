#!/usr/bin/env python3

"""
Module Name: image_io
Description: Functions for reading and saving image files.
"""

import os
import glob
import tifffile as tiff

def read_images(input_dir, image_format="tif"):
    files = []
    for r, d, f in os.walk(input_dir):
        for fil in f:
            if fil.endswith(image_format):
                files.append(os.path.join(r, fil))
        break  # Only read the root directory
    return files

def save_image(output_path, image_array):
    tiff.imwrite(output_path, image_array)