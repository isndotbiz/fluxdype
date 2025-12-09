#!/usr/bin/env python3
import json
import urllib.request
import urllib.error
import time
import sys
import os

os.environ['PYTHONIOENCODING'] = 'utf-8'

SERVER_URL = "http://localhost:8188"

print("Testing Qwen workflow...\n")

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
        "inputs": {"text": "a beautiful woman", "clip": [2, 0]},
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
            "seed": 100,
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
        "inputs": {"filename_prefix": "qwen_test", "images": [8, 0]},
        "class_type": "SaveImage"
    }
}

try:
    api_payload = {"prompt": workflow}
    json_data = json.dumps(api_payload).encode('utf-8')

    print(f"Sending {len(json_data)} bytes to server...\n")

    req = urllib.request.Request(
        f"{SERVER_URL}/prompt",
        data=json_data,
        headers={'Content-Type': 'application/json'}
    )

    with urllib.request.urlopen(req, timeout=30) as response:
        data = json.loads(response.read().decode('utf-8'))
        print(f"SUCCESS: {data.get('prompt_id')}")
except urllib.error.HTTPError as e:
    error_body = e.read().decode('utf-8')
    print(f"HTTP {e.code}: {e.reason}\n")
    print("ERROR RESPONSE:")
    print(error_body)
except Exception as e:
    print(f"ERROR: {e}")
