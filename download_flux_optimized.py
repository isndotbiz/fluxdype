#!/usr/bin/env python3
"""
Download Flux Dev FP8 optimized model for RTX 3090 24GB
Uses publicly available models
"""

import os
from pathlib import Path
from huggingface_hub import hf_hub_download
from dotenv import load_dotenv

# Load environment variables
load_dotenv()
HF_TOKEN = os.getenv('HUGGINGFACE_TOKEN')

# Model paths
COMFY_MODELS_DIR = Path("D:/workspace/fluxdype/ComfyUI/models")
DIFFUSION_MODELS_DIR = COMFY_MODELS_DIR / "diffusion_models"
TEXT_ENCODERS_DIR = COMFY_MODELS_DIR / "text_encoders"
VAE_DIR = COMFY_MODELS_DIR / "vae"

# Create directories if they don't exist
DIFFUSION_MODELS_DIR.mkdir(parents=True, exist_ok=True)
TEXT_ENCODERS_DIR.mkdir(parents=True, exist_ok=True)
VAE_DIR.mkdir(parents=True, exist_ok=True)

print("="* 80)
print("Flux Dev FP8 Model Download for RTX 3090 24GB")
print("="* 80)
print()

# Check if we already have Flux 1 Dev FP8
flux1_kria = DIFFUSION_MODELS_DIR / "flux1-krea-dev_fp8_scaled.safetensors"
if flux1_kria.exists():
    print(f"[INFO] Flux 1 Kria FP8 model already exists: {flux1_kria}")
    print(f"       Size: {flux1_kria.stat().st_size / 1024**3:.2f} GB")
    print()

# Download standard Flux 1 Dev FP8 model
print("[1/4] Downloading Flux 1 Dev FP8 model (11.9GB)...")
print("      Source: comfyanonymous/flux_dev_fp8_scaled_diffusion_model")
print(f"      Target: {DIFFUSION_MODELS_DIR}")

try:
    flux_model_path = hf_hub_download(
        repo_id="comfyanonymous/flux_dev_fp8_scaled_diffusion_model",
        filename="flux_dev_fp8_scaled.safetensors",
        local_dir=DIFFUSION_MODELS_DIR,
        token=HF_TOKEN
    )
    print(f"      SUCCESS: Downloaded to {flux_model_path}")
except Exception as e:
    print(f"      ERROR: {e}")

print()

# Download T5-XXL FP8 text encoder
print("[2/4] Downloading T5-XXL FP8 text encoder (4.8GB - saves 6GB VRAM)...")
print("      Source: comfyanonymous/flux_text_encoders")
print(f"      Target: {TEXT_ENCODERS_DIR}")

try:
    t5_path = hf_hub_download(
        repo_id="comfyanonymous/flux_text_encoders",
        filename="t5xxl_fp8_e4m3fn.safetensors",
        local_dir=TEXT_ENCODERS_DIR,
        token=HF_TOKEN
    )
    print(f"      SUCCESS: Downloaded to {t5_path}")
except Exception as e:
    print(f"      ERROR: {e}")

print()

# Download CLIP-L text encoder
print("[3/4] Downloading CLIP-L text encoder (246MB)...")
print("      Source: comfyanonymous/flux_text_encoders")
print(f"      Target: {TEXT_ENCODERS_DIR}")

try:
    clip_path = hf_hub_download(
        repo_id="comfyanonymous/flux_text_encoders",
        filename="clip_l.safetensors",
        local_dir=TEXT_ENCODERS_DIR,
        token=HF_TOKEN
    )
    print(f"      SUCCESS: Downloaded to {clip_path}")
except Exception as e:
    print(f"      ERROR: {e}")

print()

# Download VAE
print("[4/4] Downloading Flux VAE (335MB)...")
print("      Source: black-forest-labs/FLUX.1-schnell")
print(f"      Target: {VAE_DIR}")

try:
    vae_path = hf_hub_download(
        repo_id="black-forest-labs/FLUX.1-schnell",
        filename="ae.safetensors",
        local_dir=VAE_DIR,
        token=HF_TOKEN
    )
    print(f"      SUCCESS: Downloaded to {vae_path}")
except Exception as e:
    print(f"      ERROR: {e}")

print()
print("="* 80)
print("Download Complete!")
print("="* 80)
print()
print("Available Models:")
for model_file in sorted(DIFFUSION_MODELS_DIR.glob("*.safetensors")):
    size_gb = model_file.stat().st_size / 1024**3
    print(f"  - {model_file.name} ({size_gb:.2f} GB)")
print()
print("Expected VRAM Usage with FP8 models:")
print("  - Flux Dev FP8: ~11.9GB")
print("  - T5-XXL FP8: ~4.8GB")
print("  - Total Peak: ~14-16GB (leaves 8-10GB free on RTX 3090)")
print()
print("Next: Run start-comfy-optimized.ps1 to launch ComfyUI")
print()
