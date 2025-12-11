#!/usr/bin/env python3
"""Collect generated images from ComfyUI output directory."""

import os
import shutil
from pathlib import Path
import time

# Paths
COMFYUI_OUTPUT = Path("D:/comfy-flux-wan-automation/outputs")
LOCAL_OUTPUT = Path("./outputs")

# Create local output directory
LOCAL_OUTPUT.mkdir(exist_ok=True)

# Expected filename prefixes from our workflows
PREFIXES = [
    "Brazilian_carnival_backstage",
    "Brazilian_ipanema_beach",
    "Brazilian_sao_paulo_penthouse"
]

print("🔍 Searching for generated images in ComfyUI output...\n")

found_images = []

# Search for images with our prefixes
if COMFYUI_OUTPUT.exists():
    for prefix in PREFIXES:
        # Find all matching images
        matches = list(COMFYUI_OUTPUT.glob(f"{prefix}_*.png"))
        
        if matches:
            # Get the most recent one
            latest = max(matches, key=lambda p: p.stat().st_mtime)
            found_images.append((prefix, latest))
            print(f"✓ Found: {latest.name}")
        else:
            print(f"⏳ Waiting: {prefix}_*.png")

if found_images:
    print(f"\n📁 Copying {len(found_images)} images to ./outputs/\n")
    
    for prefix, src_path in found_images:
        # Create a clean filename
        dest_name = f"{prefix}.png"
        dest_path = LOCAL_OUTPUT / dest_name
        
        # Copy the file
        shutil.copy2(src_path, dest_path)
        print(f"✓ Copied: {dest_name}")
        print(f"  Size: {dest_path.stat().st_size / 1024 / 1024:.2f} MB")
    
    print(f"\n✅ All images saved to: {LOCAL_OUTPUT.absolute()}")
else:
    print("\n⏳ No images found yet. They might still be generating.")
    print("   Run this script again in a few seconds.")
    print("\n   Or check manually at:")
    print(f"   {COMFYUI_OUTPUT}")
