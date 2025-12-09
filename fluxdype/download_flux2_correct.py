#!/usr/bin/env python3
"""Download Flux 2.0 Dev - trying both official and FP8 versions"""

from huggingface_hub import hf_hub_download
from dotenv import load_dotenv
import os
from pathlib import Path

load_dotenv()
token = os.getenv('HUGGINGFACE_TOKEN')

if not token:
    print('ERROR: HUGGINGFACE_TOKEN not found!')
    exit(1)

print("="*80)
print("Flux 2.0 Dev Model Download")
print("="*80)
print()

target_dir = Path('D:/workspace/fluxdype/ComfyUI/models/diffusion_models')
target_dir.mkdir(parents=True, exist_ok=True)

# Option 1: Try FP8 from Kijai (community quantization)
print("[Option 1] Trying FP8 quantized version (Kijai/flux-fp8)...")
print("           This is optimized for RTX 3090 (14.8GB VRAM)")
print()

try:
    # Check if Kijai has Flux 2 FP8
    from huggingface_hub import list_repo_files
    kijai_files = list_repo_files('Kijai/flux-fp8', token=token)
    flux2_files = [f for f in kijai_files if 'flux2' in f.lower() or 'flux.2' in f.lower()]

    if flux2_files:
        print(f"           Found Flux 2 files: {flux2_files}")
        for file in flux2_files:
            if file.endswith('.safetensors') or file.endswith('.gguf'):
                print(f"           Downloading {file}...")
                model_path = hf_hub_download(
                    repo_id='Kijai/flux-fp8',
                    filename=file,
                    local_dir=target_dir,
                    token=token
                )
                print(f"           SUCCESS: {model_path}")
    else:
        print("           No Flux 2 FP8 files found in Kijai/flux-fp8")
except Exception as e:
    print(f"           ERROR: {str(e)[:150]}")

print()

# Option 2: Download official Flux 2 Dev (full model)
print("[Option 2] Downloading official Flux 2.0 Dev model...")
print("           Repository: black-forest-labs/FLUX.2-dev")
print("           File: flux2-dev.safetensors (~24GB)")
print("           WARNING: This uses more VRAM than FP8!")
print()

try:
    model_path = hf_hub_download(
        repo_id='black-forest-labs/FLUX.2-dev',
        filename='flux2-dev.safetensors',
        local_dir=target_dir,
        token=token
    )

    file_size = Path(model_path).stat().st_size / 1024**3
    print()
    print(f"           SUCCESS: Downloaded to {model_path}")
    print(f"           Size: {file_size:.2f} GB")
    print()

except Exception as e:
    print(f"           ERROR: {str(e)[:150]}")
    print()

print("="*80)
print("Download Summary")
print("="*80)
print()

# List all Flux 2 models
all_models = list(target_dir.glob("flux2*.safetensors")) + list(target_dir.glob("FLUX.2*.safetensors"))
if all_models:
    print("Flux 2.0 models available:")
    for model in all_models:
        size_gb = model.stat().st_size / 1024**3
        print(f"  - {model.name} ({size_gb:.2f} GB)")
else:
    print("No Flux 2.0 models downloaded.")

print()
print("All Flux models:")
flux_models = list(target_dir.glob("flux*.safetensors"))
for model in flux_models[:10]:  # Limit to 10
    size_gb = model.stat().st_size / 1024**3
    print(f"  - {model.name} ({size_gb:.2f} GB)")

print()
print("Next steps:")
print("1. Restart ComfyUI if it's running")
print("2. The new model(s) will appear in the checkpoint dropdown")
print("3. Use start-comfy-rtx3090-optimized.ps1 for best performance")
print()
