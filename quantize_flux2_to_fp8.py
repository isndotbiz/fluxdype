"""
Quantize Flux 2.0 Dev from FP16 (61GB) to FP8 (12GB)
This will take 30-60 minutes and requires 80GB+ free disk space during conversion
"""

import os
import torch
from safetensors.torch import load_file, save_file
from tqdm import tqdm

# Configuration
INPUT_MODEL = "D:/workspace/fluxdype/ComfyUI/models/diffusion_models/flux2-dev.safetensors"
OUTPUT_MODEL = "D:/workspace/fluxdype/ComfyUI/models/diffusion_models/flux2-dev_fp8.safetensors"

def quantize_to_fp8(tensor):
    """Convert FP16/FP32 tensor to FP8 (e4m3fn format)"""
    # PyTorch FP8 support requires CUDA 11.8+
    if tensor.dtype in [torch.float16, torch.float32, torch.bfloat16]:
        # Convert to FP8 E4M3 (8-bit float with 4-bit mantissa, 3-bit exponent)
        return tensor.to(torch.float8_e4m3fn)
    return tensor

def main():
    print(f"Loading model from: {INPUT_MODEL}")
    print(f"This will take 5-10 minutes for a 61GB model...")

    # Check if input exists
    if not os.path.exists(INPUT_MODEL):
        print(f"ERROR: Input model not found at {INPUT_MODEL}")
        return

    # Check disk space (need 80GB free for safety)
    import shutil
    stat = shutil.disk_usage("D:/")
    free_gb = stat.free / (1024**3)
    print(f"Available disk space: {free_gb:.1f} GB")
    if free_gb < 80:
        print("WARNING: Low disk space! Need 80GB+ free for safe conversion")
        response = input("Continue anyway? (yes/no): ")
        if response.lower() != 'yes':
            return

    # Load the model
    print("Loading FP16 model weights...")
    state_dict = load_file(INPUT_MODEL)

    print(f"Loaded {len(state_dict)} tensors")

    # Quantize each tensor
    print("Quantizing to FP8...")
    quantized_dict = {}

    for key, tensor in tqdm(state_dict.items(), desc="Quantizing"):
        try:
            quantized_dict[key] = quantize_to_fp8(tensor)
        except Exception as e:
            print(f"Warning: Could not quantize {key}, keeping original dtype. Error: {e}")
            quantized_dict[key] = tensor

    # Save quantized model
    print(f"Saving FP8 model to: {OUTPUT_MODEL}")
    save_file(quantized_dict, OUTPUT_MODEL)

    # Check file sizes
    input_size = os.path.getsize(INPUT_MODEL) / (1024**3)
    output_size = os.path.getsize(OUTPUT_MODEL) / (1024**3)

    print("\n" + "="*50)
    print("QUANTIZATION COMPLETE!")
    print("="*50)
    print(f"Input (FP16):  {input_size:.2f} GB")
    print(f"Output (FP8):  {output_size:.2f} GB")
    print(f"Saved:         {input_size - output_size:.2f} GB ({((input_size - output_size) / input_size * 100):.1f}%)")
    print(f"\nQuantized model saved to:")
    print(f"  {OUTPUT_MODEL}")
    print("\nYou can now delete the original 61GB model to free space:")
    print(f"  rm \"{INPUT_MODEL}\"")

if __name__ == "__main__":
    main()
