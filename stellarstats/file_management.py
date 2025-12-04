#!/usr/bin/env python3

"""
Module Name: file_management
Description: Functions for managing output files.
"""

import os
import glob
import shutil

def move_files(source_dir, target_dir, file_extension):
    os.makedirs(target_dir, exist_ok=True)
    files = glob.glob(os.path.join(source_dir, f"*.{file_extension}"))
    for file_path in files:
        shutil.move(file_path, os.path.join(target_dir, os.path.basename(file_path)))
    print(f"All .{file_extension} files from {source_dir} have been moved to {target_dir}.")
