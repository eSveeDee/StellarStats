#!/usr/bin/env python3

"""
Module Name: mip
Description: Functions for creating maximum intensity projections from image stacks.
"""

import numpy as np
from stellarstats.image_io import save_image
import tifffile as tiff

def create_mip(file_path, output_path):
    stack_array = tiff.imread(file_path)
    mip_array = np.max(stack_array, axis=0)
    save_image(output_path, mip_array)