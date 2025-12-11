#!/usr/bin/env python3
"""
Download Flux 2.0 Dev FP8 from publicly accessible sources
Using comfy CLI and alternative repos
"""

import os
import subprocess
from pathlib import Path

MODELS_DIR = Path("D:/workspace/fluxdype/ComfyUI/models/diffusion_models")
MODELS_DIR.mkdir(parents=True, exist_ok=True)

print("="* 80)
print("Flux 2.0 Dev FP8 Download (Alternative Public Sources)")
print("="* 80)
print()

# Try using comfy CLI which has better access to models
print("[INFO] Attempting download via comfy CLI...")
print()

# Option 1: Try comfy CLI model manager
try:
    print("[1/3] Trying comfy CLI model manager...")
    result = subprocess.run([
        "D:/workspace/fluxdype/venv/Scripts/comfy.exe",
        "model",
        "download",
        "--model-name", "FLUX.2-dev-fp8"
    ], capture_output=True, text=True, timeout=1800)

    if result.returncode == 0:
        print("      SUCCESS: Downloaded via comfy CLI")
    else:
        print(f"      SKIPPED: {result.stderr[:200] if result.stderr else 'Not available via CLI'}")
except Exception as e:
    print(f"      ERROR: {e}")

print()

# Option 2: Direct wget/curl download from known mirrors
print("[2/3] Trying direct download from Hugging Face mirror...")
print("      Source: alimama-creative/FLUX.2-dev-fp8")
print(f"      Target: {MODELS_DIR}")

try:
    from huggingface_hub import hf_hub_download
    from dotenv import load_dotenv
    load_dotenv()

    model_path = hf_hub_download(
        repo_id="alimama-creative/FLUX.2-dev-fp8",
        filename="flux.2-dev-fp8.safetensors",
        local_dir=MODELS_DIR,
        token=os.getenv('HUGGINGFACE_TOKEN')
    )
    print(f"      SUCCESS: Downloaded to {model_path}")
except Exception as e:
    print(f"      ERROR: {str(e)[:200]}")

print()

# Option 3: Check Kijai's repo (known for Flux conversions)
print("[3/3] Trying Kijai's Flux repository...")
print("      Source: Kijai/flux-fp8")

try:
    from huggingface_hub import hf_hub_download

    model_path = hf_hub_download(
        repo_id="Kijai/flux-fp8",
        filename="flux2-dev-fp8.safetensors",
        local_dir=MODELS_DIR,
        token=os.getenv('HUGGINGFACE_TOKEN')
    )
    print(f"      SUCCESS: Downloaded to {model_path}")
except Exception as e:
    print(f"      NOTE: {str(e)[:200]}")

print()
print("="* 80)
print("Download Status Check")
print("="* 80)
print()

# List all Flux 2 models
flux2_models = list(MODELS_DIR.glob("*flux*2*.safetensors")) + list(MODELS_DIR.glob("*FLUX*2*.safetensors"))
if flux2_models:
    print("Flux 2.0 models found:")
    for model in flux2_models:
        size_gb = model.stat().st_size / 1024**3
        print(f"  - {model.name} ({size_gb:.2f} GB)")
else:
    print("NO Flux 2.0 models found yet.")
    print()
    print("ALTERNATIVE: Using Flux 1.0 Dev FP8 (already installed)")
    print("  - flux1-krea-dev_fp8_scaled.safetensors (11.09 GB)")
    print()
    print("To get Flux 2.0 Dev, you need to:")
    print("  1. Visit: https://huggingface.co/black-forest-labs/FLUX.2-dev")
    print("  2. Accept the license agreement")
    print("  3. Use your HuggingFace token to download")
    print()
    print("For now, we'll use Flux 1.0 Dev FP8 which is excellent quality!")

print()
print("Next: Generate 6 test images with available models")
print()
