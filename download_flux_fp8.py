"""Download Flux 1 Dev FP8 from HuggingFace"""
from huggingface_hub import hf_hub_download
import os

print("Downloading Flux 1 Dev FP8 (12GB)...")
print("This will take 5-15 minutes depending on your connection\n")

try:
    downloaded_path = hf_hub_download(
        repo_id="black-forest-labs/FLUX.1-dev",
        filename="flux1-dev-fp8.safetensors",
        local_dir="D:/workspace/fluxdype/ComfyUI/models/diffusion_models",
        local_dir_use_symlinks=False
    )

    print(f"\nDownload complete!")
    print(f"Saved to: {downloaded_path}")

    # Check file size
    size_gb = os.path.getsize(downloaded_path) / (1024**3)
    print(f"File size: {size_gb:.2f} GB")

except Exception as e:
    print(f"Error: {e}")
    print("\nAlternative: The file might not exist at that location.")
    print("Flux 2.0 Dev FP8 might be under a different filename.")
