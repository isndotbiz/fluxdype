#!/usr/bin/env python3
import requests
import json
import sys

# Simple test to submit a workflow and see the error
workflow = {
    "3": {
        "inputs": {
            "seed": 42,
            "steps": 5,
            "cfg": 3.5,
            "sampler_name": "euler",
            "scheduler": "simple",
            "denoise": 1,
            "model": ["11", 0],
            "positive": ["6", 0],
            "negative": ["7", 0],
            "latent_image": ["5", 0]
        },
        "class_type": "KSampler"
    },
    "5": {
        "inputs": {
            "width": 512,
            "height": 512,
            "batch_size": 1
        },
        "class_type": "EmptyLatentImage"
    },
    "6": {
        "inputs": {
            "text": "test landscape",
            "clip": ["10", 1]
        },
        "class_type": "CLIPTextEncode"
    },
    "7": {
        "inputs": {
            "text": "blurry, low quality",
            "clip": ["10", 1]
        },
        "class_type": "CLIPTextEncode"
    },
    "8": {
        "inputs": {
            "samples": ["3", 0],
            "vae": ["11", 2]
        },
        "class_type": "VAEDecode"
    },
    "9": {
        "inputs": {
            "filename_prefix": "test_image",
            "images": ["8", 0]
        },
        "class_type": "SaveImage"
    },
    "10": {
        "inputs": {
            "clip_name1": "clip_l.safetensors",
            "clip_name2": "t5xxl_fp16.safetensors",
            "type": "flux"
        },
        "class_type": "DualCLIPLoader"
    },
    "11": {
        "inputs": {
            "unet_name": "flux1-krea-dev_fp8_scaled.safetensors",
            "weight_dtype": "fp8_e4m3fn"
        },
        "class_type": "UNETLoader"
    }
}

try:
    url = "http://localhost:8188/prompt"
    response = requests.post(url, json=workflow, timeout=10)
    print(f"Status: {response.status_code}")
    print(f"Response: {response.text}")

    if response.status_code == 200:
        data = response.json()
        print(f"Job ID: {data.get('prompt_id')}")

except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
