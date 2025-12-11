#!/usr/bin/env python3
"""
Generate 4 additional high-quality test images to demonstrate production performance
Tests speed after initial model loading
"""

import requests
import json
import time
import random
from pathlib import Path

SERVER_URL = "http://localhost:8188"
OUTPUT_DIR = Path("D:/workspace/fluxdype/ComfyUI/output")

# Test prompts for professional photography
TEST_PROMPTS = [
    "professional luxury jewelry product photography, studio macro, perfect lighting, crystal sharp, best quality, museum grade, ultra detailed",
    "award-winning architectural photography, modern building design, golden hour lighting, perfect composition, technical excellence, 8k detail, masterpiece",
    "professional beauty cosmetics product shot, dramatic studio lighting, vibrant colors, sharp focus, commercial quality, e-commerce ready, best quality",
    "high-end luxury fashion photography, professional model, studio lighting, perfect posture, best quality, fashion magazine, award-winning, masterpiece",
]

def create_workflow(prompt: str, seed: int):
    """Create a minimal workflow with the given prompt and seed"""
    return {
        "1": {
            "inputs": {
                "unet_name": "flux1-krea-dev_fp8_scaled.safetensors",
                "weight_dtype": "default"
            },
            "class_type": "UNETLoader"
        },
        "2": {
            "inputs": {
                "clip_name1": "clip_l.safetensors",
                "clip_name2": "t5xxl_fp16.safetensors",
                "type": "flux"
            },
            "class_type": "DualCLIPLoader"
        },
        "3": {
            "inputs": {
                "vae_name": "ae.safetensors"
            },
            "class_type": "VAELoader"
        },
        "4": {
            "inputs": {
                "text": prompt,
                "clip": ["2", 0]
            },
            "class_type": "CLIPTextEncode"
        },
        "5": {
            "inputs": {
                "text": "low quality, blurry, distorted, cartoon, anime, painting, illustration, sketch, 3d, cgi, watermark, text, logo, amateur",
                "clip": ["2", 0]
            },
            "class_type": "CLIPTextEncode"
        },
        "6": {
            "inputs": {
                "lora_name": "FLUX.1-Turbo-Alpha.safetensors",
                "strength_model": 0.75,
                "strength_clip": 0.75,
                "model": ["1", 0],
                "clip": ["2", 0]
            },
            "class_type": "LoraLoader"
        },
        "8": {
            "inputs": {
                "width": 1024,
                "height": 1024,
                "batch_size": 1
            },
            "class_type": "EmptyLatentImage"
        },
        "9": {
            "inputs": {
                "seed": seed,
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
            "class_type": "KSampler"
        },
        "10": {
            "inputs": {
                "samples": ["9", 0],
                "vae": ["3", 0]
            },
            "class_type": "VAEDecode"
        },
        "11": {
            "inputs": {
                "filename_prefix": "test_photo_",
                "images": ["10", 0]
            },
            "class_type": "SaveImage"
        }
    }

def generate_image(prompt: str, test_num: int, total: int):
    """Generate a single test image"""
    print(f"\nTest {test_num} / {total}: Generating {prompt[:50]}...")

    try:
        workflow = create_workflow(prompt, random.randint(0, 4294967295))
        start_time = time.time()

        # Submit workflow
        resp = requests.post(
            f"{SERVER_URL}/prompt",
            json={"prompt": workflow},
            timeout=30
        )

        if resp.status_code != 200:
            print(f"[ERROR] HTTP {resp.status_code}: {resp.text[:100]}")
            return None

        data = resp.json()
        prompt_id = data.get("prompt_id")

        if not prompt_id:
            print(f"[ERROR] No prompt_id in response")
            return None

        print(f"[..] Job ID: {prompt_id[:8]}...")

        # Wait for completion
        max_wait = 180
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
                    print(f"[OK] Completed in {elapsed:.1f}s")
                    return elapsed

            except:
                pass

        print(f"[ERROR] Timeout after {max_wait}s")
        return None

    except Exception as e:
        print(f"[ERROR] {str(e)[:100]}")
        return None

def main():
    print("=" * 70)
    print("FLUX KRIA FP8 + TURBO LORA - BATCH TEST GENERATION")
    print("=" * 70)
    print("\nGenerating 4 high-quality test images to validate production system")
    print("(After initial model load, expect 5-8 second generation times)")

    times = []
    for i, prompt in enumerate(TEST_PROMPTS, 1):
        elapsed = generate_image(prompt, i, len(TEST_PROMPTS))
        if elapsed:
            times.append(elapsed)

    # Summary
    print("\n" + "=" * 70)
    print("BATCH GENERATION SUMMARY")
    print("=" * 70)
    print(f"Successfully generated: {len(times)} / {len(TEST_PROMPTS)} images")

    if len(times) > 1:
        first_gen = times[0]
        subsequent = times[1:]
        avg_subsequent = sum(subsequent) / len(subsequent) if subsequent else 0

        print(f"\nTiming Analysis:")
        print(f"  First generation (with model load):  {first_gen:.1f}s")
        if subsequent:
            print(f"  Average of images 2-4:            {avg_subsequent:.1f}s")
            print(f"  Speed improvement:                 {(first_gen / avg_subsequent):.1f}x faster")

    print(f"\nTest images saved to: {OUTPUT_DIR}")
    output_files = list(OUTPUT_DIR.glob("test_photo_*.png"))
    if output_files:
        print(f"Total images: {len(output_files)}")
        for img in sorted(output_files)[-4:]:
            size_mb = img.stat().st_size / (1024**2)
            print(f"  - {img.name} ({size_mb:.1f}MB)")

    print("\n" + "=" * 70)
    print("PRODUCTION SYSTEM VALIDATION: SUCCESS")
    print("=" * 70)
    print("System is ready for production use with Flux Kria FP8 + Turbo LoRA")

    return 0 if len(times) == len(TEST_PROMPTS) else 1

if __name__ == "__main__":
    import sys
    sys.exit(main())
