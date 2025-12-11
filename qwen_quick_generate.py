#!/usr/bin/env python3
import json
import urllib.request
import urllib.error
import time
import sys
import os

os.environ['PYTHONIOENCODING'] = 'utf-8'

SERVER_URL = "http://localhost:8188"

# Quick prompts
PROMPTS = [
    ("A stunning portrait of a beautiful woman with warm eyes, professional photography, 8k, photorealistic, soft lighting", "portrait"),
    ("Epic fantasy landscape with magical mountains, glowing trees, crystal waterfalls, dreamlike atmosphere, ultra detailed, 8k masterpiece", "landscape"),
    ("Abstract digital art explosion, vibrant neon colors, flowing geometric shapes, swirling patterns, high energy, 8k artistic", "abstract")
]

print("=" * 70)
print("QWEN QUICK GENERATION - 3 Images")
print("=" * 70)

# Check server
print("\nChecking server...")
try:
    req = urllib.request.Request(f"{SERVER_URL}/system_stats")
    with urllib.request.urlopen(req, timeout=5) as response:
        print("[OK] Server ready!\n")
except Exception as e:
    print(f"[FAIL] Server not responding: {e}")
    sys.exit(1)

# Generate each image
jobs = []
for i, (prompt, name) in enumerate(PROMPTS, 1):
    workflow = {
        "1": {
            "inputs": {"unet_name": "qwen_image_fp8_e4m3fn.safetensors"},
            "class_type": "UNETLoader"
        },
        "2": {
            "inputs": {
                "clip_name": "qwen_2.5_vl_7b_fp8_scaled.safetensors",
                "type": "qwen_image"
            },
            "class_type": "CLIPLoader"
        },
        "3": {
            "inputs": {"vae_name": "qwen_image_vae.safetensors"},
            "class_type": "VAELoader"
        },
        "4": {
            "inputs": {"text": prompt, "clip": [2, 0]},
            "class_type": "CLIPTextEncode"
        },
        "5": {
            "inputs": {"text": "", "clip": [2, 0]},
            "class_type": "CLIPTextEncode"
        },
        "6": {
            "inputs": {"width": 1024, "height": 1024, "batch_size": 1},
            "class_type": "EmptySD3LatentImage"
        },
        "7": {
            "inputs": {
                "seed": 100 + i,
                "steps": 20,
                "cfg": 2.5,
                "sampler_name": "euler",
                "scheduler": "simple",
                "denoise": 1.0,
                "model": [1, 0],
                "positive": [4, 0],
                "negative": [5, 0],
                "latent_image": [6, 0]
            },
            "class_type": "KSampler"
        },
        "8": {
            "inputs": {"samples": [7, 0], "vae": [3, 0]},
            "class_type": "VAEDecode"
        },
        "9": {
            "inputs": {
                "filename_prefix": f"qwen_{i}_{name}",
                "images": [8, 0]
            },
            "class_type": "SaveImage"
        }
    }

    try:
        api_payload = {"prompt": workflow}
        json_data = json.dumps(api_payload).encode('utf-8')
        req = urllib.request.Request(
            f"{SERVER_URL}/prompt",
            data=json_data,
            headers={'Content-Type': 'application/json'}
        )

        with urllib.request.urlopen(req, timeout=30) as response:
            data = json.loads(response.read().decode('utf-8'))
            job_id = data.get('prompt_id')
            jobs.append((job_id, name))
            print(f"[{i}] {name.upper()}: {job_id}")
    except Exception as e:
        print(f"[FAIL] {name}: {e}")

print("\n" + "=" * 70)
print(f"Submitted {len(jobs)} jobs - generating with Qwen FP8")
print(f"Output: D:\\workspace\\fluxdype\\ComfyUI\\output\\")
print("=" * 70)
