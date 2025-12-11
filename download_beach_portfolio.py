#!/usr/bin/env python3
"""Download all 10 beach portfolio images."""

import requests
import os
from pathlib import Path
import time

# Beach portfolio job IDs (in order)
BEACH_JOBS = [
    "4fa7d4da-3243-4752-8dda-f072e11bffd3",  # 01_moonlight_dip
    "f9fefa14-9040-4a52-bc22-e9170f5cdc26",  # 02_bonfire_glow
    "c4f6172f-db09-45fc-979e-f3d561e2ce4b",  # 03_flashlight_find
    "4ef1e566-2791-4a80-8e9e-acef25b465c9",  # 04_city_distant
    "53a1a15d-aeac-4a98-93b8-609d0c3efb8e",  # 05_wet_sand_sprawl
    "59efb9e0-ae80-46a7-a596-87e3eb52b5c1",  # 06_storm_chaser
    "4ed2484f-26c0-4549-80a2-aaba717801f2",  # 07_car_headlights
    "630f1ff0-c147-47cc-90bd-5ec35af2db07",  # 08_night_swim_exit
    "64db4f5d-439f-4516-b2ed-a623668364f4",  # 09_fireworks
    "42dbdf7e-1ffb-4e24-a4a5-52c240047d78",  # 10_pre_dawn_grey
]

# Create outputs directory
OUTPUT_DIR = Path("outputs/beach_portfolio")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

print("🌊 Downloading Beach Portfolio (10 images)...")
print("⏳ Waiting for generation to complete...\n")

# Wait a bit for generation to start
time.sleep(10)

downloaded = 0
max_wait = 180  # 3 minutes max wait
start_time = time.time()

while downloaded < len(BEACH_JOBS) and (time.time() - start_time) < max_wait:
    for idx, job_id in enumerate(BEACH_JOBS, 1):
        try:
            # Get job history
            history_url = f"http://localhost:8188/history/{job_id}"
            response = requests.get(history_url, timeout=5)
            
            if response.status_code != 200:
                continue
            
            data = response.json()
            job_data = data.get(job_id, {})
            
            # Check if completed
            status = job_data.get('status', {})
            if not status.get('completed', False):
                continue
            
            # Extract output images
            outputs = job_data.get('outputs', {})
            
            for node_id, node_output in outputs.items():
                images = node_output.get('images', [])
                
                for img_info in images:
                    filename = img_info['filename']
                    output_path = OUTPUT_DIR / filename
                    
                    # Skip if already downloaded
                    if output_path.exists():
                        continue
                    
                    subfolder = img_info.get('subfolder', '')
                    file_type = img_info.get('type', 'output')
                    
                    # Download the image
                    view_url = f"http://localhost:8188/view?filename={filename}&subfolder={subfolder}&type={file_type}"
                    img_response = requests.get(view_url, timeout=10)
                    
                    if img_response.status_code == 200:
                        with open(output_path, 'wb') as f:
                            f.write(img_response.content)
                        
                        size_mb = len(img_response.content) / 1024 / 1024
                        downloaded += 1
                        print(f"{downloaded:2d}/10 ✓ {filename} ({size_mb:.2f} MB)")
        
        except Exception as e:
            continue
    
    if downloaded < len(BEACH_JOBS):
        time.sleep(5)
        print(".", end="", flush=True)

print(f"\n\n✅ Downloaded {downloaded}/10 images to: {OUTPUT_DIR.absolute()}")

if downloaded < len(BEACH_JOBS):
    print(f"\n⚠️  Some images may still be processing. Run this script again in a moment.")
