#!/usr/bin/env python3
"""Download generated images via ComfyUI API."""

import requests
import os
from pathlib import Path

# Job IDs from our submissions
# Batch 1
JOB_IDS = [
    "ce911389-74e0-4b08-bb3d-2e73e875af1c",  # carnival_backstage
    "82e132e1-0498-4fe2-be2d-9019416b75bb",  # ipanema_beach
    "7940bb10-483e-48d1-9eb4-ababc5657421",  # sao_paulo_penthouse
]

# Batch 2 - Wet textures & dramatic lighting
JOB_IDS_BATCH2 = [
    "7e45e93e-abaa-4dc2-b5c3-9c641763a6db",  # amazon_storm
    "db392570-0b35-413c-87fa-c207595ad7e2",  # midnight_passenger
    "a1d81621-fdd4-46a1-a2ef-a475ab7447ec",  # rio_rooftop
]

# Combine all job IDs
ALL_JOBS = JOB_IDS + JOB_IDS_BATCH2

# Create outputs directory
OUTPUT_DIR = Path("outputs")
OUTPUT_DIR.mkdir(exist_ok=True)

print("📥 Downloading images from ComfyUI API...\n")

for job_id in ALL_JOBS:
    # Get job history
    history_url = f"http://localhost:8188/history/{job_id}"
    response = requests.get(history_url)
    
    if response.status_code != 200:
        print(f"❌ Failed to get history for {job_id}")
        continue
    
    data = response.json()
    job_data = data.get(job_id, {})
    
    # Extract output images
    outputs = job_data.get('outputs', {})
    
    for node_id, node_output in outputs.items():
        images = node_output.get('images', [])
        
        for img_info in images:
            filename = img_info['filename']
            subfolder = img_info.get('subfolder', '')
            file_type = img_info.get('type', 'output')
            
            # Download the image
            view_url = f"http://localhost:8188/view?filename={filename}&subfolder={subfolder}&type={file_type}"
            
            print(f"⬇️  Downloading: {filename}")
            
            img_response = requests.get(view_url)
            
            if img_response.status_code == 200:
                # Save locally
                output_path = OUTPUT_DIR / filename
                with open(output_path, 'wb') as f:
                    f.write(img_response.content)
                
                size_mb = len(img_response.content) / 1024 / 1024
                print(f"   ✓ Saved: {output_path} ({size_mb:.2f} MB)")
            else:
                print(f"   ❌ Failed to download (HTTP {img_response.status_code})")
    
    print()

print(f"✅ All images saved to: {OUTPUT_DIR.absolute()}")
