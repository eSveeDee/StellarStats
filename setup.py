#!/usr/bin/env python3

from setuptools import setup, find_packages

setup(
    name='stellarstats',
    version='0.1',
    packages=find_packages(),
    install_requires=[
        'numpy',         # numerical operations
        'pandas',        # tabular data / CSV handling
        'matplotlib',    # plotting
        'tifffile',      # reading/writing TIFF image stacks
        'scikit-image',  # skimage.* utilities in mask analysis
        'cellpose',      # cell segmentation
    ],
    author='Sofie van Dorst',
    author_email='sofie.vandorst@unibas.ch',
    description=(
        'A package for plotting spectral data and performing statistics '
        'for spectrally resolved cryo light microscopy.'
    ),
    long_description=open('README.md', encoding='utf-8').read(),
    long_description_content_type='text/markdown',
    url='https://github.com/eSveeDee/stellarstats',  # update once repo exists
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
)
