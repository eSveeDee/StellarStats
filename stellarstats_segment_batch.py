import os
import argparse
import tifffile as tiff
import matplotlib.pyplot as plt
import glob
import warnings
import sys


def main():
    parser = argparse.ArgumentParser(description="Batch process all TIFF files in a directory for segmentation.")
    parser.add_argument("-i", "--input_dir", type=str, required=True, help="Directory containing TIFF files to process.")
    parser.add_argument("--flows", type=float, default=0.4, help="Threshold on flow error to accept a mask (set higher to get more cells, e.g. in range from (0.1, 3.0). Default 0.4.")
    parser.add_argument("--cellprob", type=float, default=0, help="Threshold on cell probability output to seed cell masks (set lower to include more pixels or higher to include fewer, e.g. in range from (-6, 6). Default 0.")
    parser.add_argument("--model_type", type=str, default="cyto3", help="Type of Cellpose model to use for segmentation. Default cyto3 (ultrageneralized).")
    parser.add_argument("--mip_dir", type=str, help="Directory to save MIP images. (optional)")
    parser.add_argument("--output_dir", type=str, help="Directory to save segmentation outputs. (optional)")
    parser.add_argument("--diameter", type=float, default=None, help="Approximate diameter of cells. (optional)")
    parser.add_argument("--channels", type=int, nargs=2, default=[0, 0], help="Channels to use for segmentation. Default greyscale ([0,0])")
    parser.add_argument("--use_gpu", action="store_true", help="Enable GPU for segmentation if available.")
    
    args = parser.parse_args()
 

    from cellpose import models, io, plot
    from stellarstats.image_io import save_image
    from stellarstats.file_management import move_files
    from stellarstats.mip import create_mip
    from stellarstats.segmentation import segment_image, save_segmentation_outputs 

    warnings.filterwarnings("ignore", message=".*weights_only=False.*", category=FutureWarning)

    def process_file(tiff_path, model_type, mip_dir, output_dir, diameter, channels, use_gpu):
        # Step 1: Create MIP and save it
        tiff_dir = os.path.dirname(tiff_path)
        mip_dir = mip_dir if mip_dir else os.path.join(tiff_dir, "MIPs")
        output_dir = output_dir if output_dir else os.path.join(tiff_dir, "Masks")

        # Avoid overwriting existing directories
        if not os.path.exists(mip_dir):
            os.makedirs(mip_dir)
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)

        # Check if MIP file already exists, avoid overwriting
        mip_output_path = os.path.join(mip_dir, f"{os.path.splitext(os.path.basename(tiff_path))[0]}_MIP.tif")
        if os.path.exists(mip_output_path):
            print(f"MIP file already exists: {mip_output_path}. Skipping projection.")
        else:
            create_mip(tiff_path, mip_output_path)
            print(f"Saved MIP image to {mip_output_path}")

        # Step 2: Load MIP image for segmentation
        mip_image = tiff.imread(mip_output_path)

        # Step 3: Apply Segmentation Model
        model = models.Cellpose(model_type=model_type, gpu=use_gpu)
        masks, flows = segment_image(mip_output_path, model=model, channels=channels, diameter=diameter, flow_th=args.flows, cellprob=args.cellprob)

        # Step 4: Save Segmentation Outputs
        save_segmentation_outputs(mip_image, masks, flows, tiff_path, output_dir)
        print(f"Segmentation saved for {tiff_path}")


    # Find all TIFF files in the input directory
    tiff_files = glob.glob(os.path.join(args.input_dir, "*.tif"))
    if not tiff_files:
        print("No TIFF files found in the specified directory.")
        return

    # Loop through each TIFF file and process it
    for tiff_file in tiff_files:
        print(f"Processing file: {tiff_file}")
        process_file(
            tiff_path=tiff_file,
            model_type=args.model_type,
            mip_dir=args.mip_dir,
            output_dir=args.output_dir,
            diameter=args.diameter,
            channels=args.channels,
            use_gpu=args.use_gpu
        )


if __name__ == "__main__":
    main()
