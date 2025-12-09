#!/usr/bin/env python3
"""
Download ultra-realistic LoRAs optimized for phone app image generation.
These LoRAs focus on photorealism, detail enhancement, and HD quality.
"""

import os
import sys
import requests
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configuration
LORA_DIR = Path("ComfyUI/models/loras")
CIVITAI_API_KEY = os.getenv("CIVITAI_API_KEY", "")

# Ultra-realistic LoRAs for phone app quality
LORAS_TO_DOWNLOAD = [
    {
        "name": "Hyper-SD15-8steps",
        "model_id": "242709",
        "version_id": "272376",
        "filename": "Hyper-SD15-8steps-lora.safetensors",
        "description": "Fast high-quality generation in 8 steps"
    },
    {
        "name": "Perfect_Hands_v3",
        "model_id": "138842",
        "version_id": "150782",
        "filename": "Perfect_Hands_v3.safetensors",
        "description": "Perfect hand anatomy"
    },
    {
        "name": "RealVisXL_V4_Lightning",
        "model_id": "361593",
        "version_id": "406635",
        "filename": "RealVisXL_V4_Lightning.safetensors",
        "description": "Ultra-realistic visuals with lightning speed"
    }
]

def download_lora(lora_info):
    """Download a LoRA from CivitAI"""
    filename = lora_info["filename"]
    filepath = LORA_DIR / filename

    if filepath.exists():
        print(f"✓ {filename} already exists, skipping...")
        return True

    print(f"Downloading {filename}...")

    # CivitAI download URL
    url = f"https://civitai.com/api/download/models/{lora_info['version_id']}"

    headers = {}
    if CIVITAI_API_KEY:
        headers["Authorization"] = f"Bearer {CIVITAI_API_KEY}"

    try:
        response = requests.get(url, headers=headers, stream=True, timeout=30)
        response.raise_for_status()

        # Get file size
        total_size = int(response.headers.get('content-length', 0))

        # Download with progress
        downloaded = 0
        with open(filepath, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                if chunk:
                    f.write(chunk)
                    downloaded += len(chunk)
                    if total_size > 0:
                        progress = (downloaded / total_size) * 100
                        print(f"\r  Progress: {progress:.1f}%", end='', flush=True)

        print(f"\n✓ Downloaded {filename}")
        return True

    except Exception as e:
        print(f"\n✗ Error downloading {filename}: {e}")
        if filepath.exists():
            filepath.unlink()  # Clean up partial download
        return False

def main():
    """Main download function"""
    print("=" * 60)
    print("Ultra-Realistic LoRA Downloader for Phone App Quality")
    print("=" * 60)
    print()

    # Check if CivitAI API key is set
    if not CIVITAI_API_KEY:
        print("⚠ Warning: CIVITAI_API_KEY not found in .env file")
        print("  Downloads may be rate-limited or fail for some models")
        print("  Get your API key from: https://civitai.com/user/account")
        print()

    # Ensure LoRA directory exists
    LORA_DIR.mkdir(parents=True, exist_ok=True)

    # Download each LoRA
    success_count = 0
    for lora in LORAS_TO_DOWNLOAD:
        print(f"\n{lora['name']}")
        print(f"  Description: {lora['description']}")
        if download_lora(lora):
            success_count += 1
        print()

    # Summary
    print("=" * 60)
    print(f"Download complete: {success_count}/{len(LORAS_TO_DOWNLOAD)} successful")
    print("=" * 60)

    if success_count < len(LORAS_TO_DOWNLOAD):
        print("\n⚠ Some downloads failed. Check your internet connection")
        print("  or add CIVITAI_API_KEY to your .env file")
        sys.exit(1)

if __name__ == "__main__":
    main()
