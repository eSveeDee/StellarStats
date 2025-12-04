# stellarstats/segmentation_single_image.py

import os
import argparse
import tifffile as tiff
import sys
import matplotlib.pyplot as plt


import warnings
warnings.filterwarnings("ignore", message=".*weights_only=False.*", category=FutureWarning)


def main():
    parser = argparse.ArgumentParser(description="Segment a cells from a single 3D TIFF stack by 2D projection.")
    parser.add_argument("--tiff", type=str, help="Path to the input TIFF stack.")
    parser.add_argument("--flows", type=float, default=0.4, help="Threshold on flow error to accept a mask (set higher to get more cells, e.g. in range from (0.1, 3.0). Default 0.4.")
    parser.add_argument("--cellprob", type=float, default=0, help="Threshold on cell probability output to seed cell masks (set lower to include more pixels or higher to include fewer, e.g. in range from (-6, 6). Default 0.")
    parser.add_argument("--model_type", type=str, default="cyto3", help="Type of Cellpose model to use for segmentation. Default cyto3 (ultrageneralized).")
    parser.add_argument("--mip_dir", type=str, help="Directory to save MIP images. Defaults to 'MIPs' in TIFF directory.")
    parser.add_argument("--output_dir", type=str, help="Directory to save segmentation outputs. Defaults to 'Masks' in TIFF directory.")
    parser.add_argument("--diameter", type=float, default=None, help="Approximate diameter of cells to help Cellpose segment correctly.")
    parser.add_argument("--channels", type=int, nargs=2, default=[0, 0], help="Channel to use for segmentation (default is grayscale single channel).")
    parser.add_argument("--use_gpu", action="store_true", help="Enable GPU for segmentation if available.")
    parser.add_argument("--trial", action="store_true", help="Display the segmentation results without saving. Use to test parameters")

    args = parser.parse_args()

    from stellarstats.image_io import save_image
    from stellarstats.file_management import move_files
    from stellarstats.mip import create_mip
    from stellarstats.segmentation import  segment_image, save_segmentation_outputs 
    from cellpose import models, io, plot


    # Determine the directory of the input TIFF file
    tiff_dir = os.path.dirname(args.tiff)

    # Default directories if none specified
    mip_dir = args.mip_dir if args.mip_dir else os.path.join(tiff_dir, "MIPs")
    output_dir = args.output_dir if args.output_dir else os.path.join(tiff_dir, "Masks")

    # Ensure MIPs and Masks directories exist
    os.makedirs(mip_dir, exist_ok=True)
    os.makedirs(output_dir, exist_ok=True)

    # Step 1: Create MIP using the mip module and save it
    mip_output_path = os.path.join(mip_dir, f"{os.path.splitext(os.path.basename(args.tiff))[0]}_MIP.tif")
    create_mip(args.tiff, mip_output_path)
    print(f"Saved MIP image to {mip_output_path}")

    # Step 2: Load MIP image for segmentation
    mip_image = tiff.imread(mip_output_path)

    # Step 3: Apply Segmentation Model from segmentation.py
    model = models.Cellpose(model_type=args.model_type, gpu=args.use_gpu)
    masks, flows = segment_image(mip_output_path, model=model, channels=args.channels, diameter=args.diameter, flow_th=args.flows, cellprob =args.cellprob)

    # Step 4: Save or Show Segmentation Outputs
    if args.trial:
        fig = plt.figure(figsize=(12, 5))
        plot.show_segmentation(fig, mip_image, masks, flows[0], args.channels)
        plt.tight_layout()
        plt.show()

    else:
        save_segmentation_outputs(mip_image, masks, flows, args.tiff, output_dir)
        
    

if __name__ == "__main__":
    main()
