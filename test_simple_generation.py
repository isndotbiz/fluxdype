#!/usr/bin/env python3
"""
Simple test to generate one high-quality image with Flux Kria FP8 + Turbo LoRA
Tests the complete production system with minimal workflow
"""

import requests
import json
import time
import sys
from pathlib import Path

SERVER_URL = "http://localhost:8188"
OUTPUT_DIR = Path("D:/workspace/fluxdype/ComfyUI/output")

# Minimal working workflow for Flux Kria FP8
workflow = {
    "1": {
        "inputs": {
            "unet_name": "flux1-krea-dev_fp8_scaled.safetensors",
            "weight_dtype": "default"
        },
        "class_type": "UNETLoader",
        "_meta": {"title": "Load Flux Kria FP8 UNET"}
    },
    "2": {
        "inputs": {
            "clip_name1": "clip_l.safetensors",
            "clip_name2": "t5xxl_fp16.safetensors",
            "type": "flux"
        },
        "class_type": "DualCLIPLoader",
        "_meta": {"title": "Load CLIP Encoders"}
    },
    "3": {
        "inputs": {
            "vae_name": "ae.safetensors"
        },
        "class_type": "VAELoader",
        "_meta": {"title": "Load VAE"}
    },
    "4": {
        "inputs": {
            "text": "professional luxury watch product photograph, studio lighting, sharp focus, 8k, museum quality, perfectly exposed, high contrast, crystal clear, masterpiece, best quality",
            "clip": ["2", 0]
        },
        "class_type": "CLIPTextEncode",
        "_meta": {"title": "Positive Prompt"}
    },
    "5": {
        "inputs": {
            "text": "low quality, blurry, distorted, cartoon, anime, painting, illustration, sketch, 3d, cgi, watermark, text, logo, amateur",
            "clip": ["2", 0]
        },
        "class_type": "CLIPTextEncode",
        "_meta": {"title": "Negative Prompt"}
    },
    "6": {
        "inputs": {
            "lora_name": "FLUX.1-Turbo-Alpha.safetensors",
            "strength_model": 0.75,
            "strength_clip": 0.75,
            "model": ["1", 0],
            "clip": ["2", 0]
        },
        "class_type": "LoraLoader",
        "_meta": {"title": "Load Turbo LoRA"}
    },
    "8": {
        "inputs": {
            "width": 1024,
            "height": 1024,
            "batch_size": 1
        },
        "class_type": "EmptyLatentImage",
        "_meta": {"title": "Initialize Latent Space"}
    },
    "9": {
        "inputs": {
            "seed": 42,
            "steps": 10,
            "cfg": 2.0,
            "sampler_name": "euler",
            "scheduler": "simple",
            "denoise": 1.0,
            "model": ["6", 0],
            "positive": ["4", 0],
            "negative": ["5", 0],
            "latent_image": ["8", 0]
        },
        "class_type": "KSampler",
        "_meta": {"title": "Sampler - Turbo 10 Steps"}
    },
    "10": {
        "inputs": {
            "samples": ["9", 0],
            "vae": ["3", 0]
        },
        "class_type": "VAEDecode",
        "_meta": {"title": "VAE Decode"}
    },
    "11": {
        "inputs": {
            "filename_prefix": "test_photo_",
            "images": ["10", 0]
        },
        "class_type": "SaveImage",
        "_meta": {"title": "Save Image"}
    }
}

def test_connectivity():
    """Test server is accessible"""
    print("Testing server connectivity...")
    try:
        resp = requests.get(f"{SERVER_URL}/system_stats", timeout=5)
        resp.raise_for_status()
        data = resp.json()
        print(f"[OK] ComfyUI server online")
        print(f"     Version: {data.get('comfyui_version', 'unknown')}")
        return True
    except Exception as e:
        print(f"[ERROR] Cannot connect to server: {e}")
        return False

def verify_models():
    """Verify all required models exist"""
    print("\nVerifying models...")
    models = [
        "ComfyUI/models/diffusion_models/flux1-krea-dev_fp8_scaled.safetensors",
        "ComfyUI/models/text_encoders/clip_l.safetensors",
        "ComfyUI/models/text_encoders/t5xxl_fp16.safetensors",
        "ComfyUI/models/vae/ae.safetensors",
        "ComfyUI/models/loras/FLUX.1-Turbo-Alpha.safetensors"
    ]

    base_path = Path("D:/workspace/fluxdype")
    missing = []

    for model in models:
        full_path = base_path / model
        if full_path.exists():
            size_gb = full_path.stat().st_size / (1024**3)
            print(f"[OK] {full_path.name} ({size_gb:.1f}GB)")
        else:
            missing.append(model)
            print(f"[!] {model} - MISSING")

    return len(missing) == 0

def generate_image():
    """Generate one test image"""
    print("\nGenerating test image...")
    print("Prompt: luxury watch product photograph, studio lighting...")

    try:
        # Submit workflow
        print("[..] Submitting workflow to server...")
        resp = requests.post(
            f"{SERVER_URL}/prompt",
            json={"prompt": workflow},
            timeout=30
        )

        if resp.status_code == 400:
            data = resp.json()
            print(f"[ERROR] Workflow validation failed:")
            print(json.dumps(data, indent=2))
            return False
        elif resp.status_code == 500:
            print(f"[ERROR] Server error (500): {resp.text}")
            return False

        resp.raise_for_status()
        data = resp.json()
        prompt_id = data.get("prompt_id")

        if not prompt_id:
            print(f"[ERROR] No prompt_id in response: {data}")
            return False

        print(f"[OK] Submitted (Job ID: {prompt_id[:8]}...)")

        # Wait for completion
        print("[..] Generating image... (this takes 5-8 seconds)")
        start_time = time.time()
        max_wait = 120

        while time.time() - start_time < max_wait:
            time.sleep(1)

            try:
                hist_resp = requests.get(
                    f"{SERVER_URL}/history/{prompt_id}",
                    timeout=5
                )
                hist_resp.raise_for_status()
                history = hist_resp.json()

                if history.get(prompt_id):
                    elapsed = time.time() - start_time
                    print(f"[OK] Generation completed in {elapsed:.1f}s")
                    return True

            except Exception as e:
                pass

        print(f"[ERROR] Generation timeout after {max_wait}s")
        return False

    except Exception as e:
        print(f"[ERROR] Generation failed: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    print("=" * 60)
    print("FLUX KRIA FP8 + TURBO LORA - SIMPLE TEST")
    print("=" * 60)

    # Step 1: Check connectivity
    if not test_connectivity():
        print("\n[FATAL] Cannot reach ComfyUI server")
        print("Start the server: .\\start-comfy.ps1")
        return 1

    # Step 2: Verify models
    if not verify_models():
        print("\n[FATAL] Some required models are missing")
        return 1

    # Step 3: Generate image
    if not generate_image():
        print("\n[FAILED] Image generation test failed")
        return 1

    # Check if image was created
    output_files = list(OUTPUT_DIR.glob("test_photo_*.png"))
    if output_files:
        print("\n" + "=" * 60)
        print("TEST PASSED - Production system is operational!")
        print("=" * 60)
        print(f"Generated {len(output_files)} image(s):")
        for img in sorted(output_files)[-1:]:  # Show last image
            size_mb = img.stat().st_size / (1024**2)
            print(f"  [OK] {img.name} ({size_mb:.1f}MB)")
        return 0
    else:
        print("\n[WARNING] No images found in output directory")
        print(f"Check: {OUTPUT_DIR}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
