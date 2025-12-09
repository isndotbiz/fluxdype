#!/usr/bin/env python3
"""
ULTRA-FAST Batch Image Generation with Flux Turbo
Optimized for RTX 3090 24GB - Maximum Speed!
"""

import json
import requests
import time
import argparse
from pathlib import Path

COMFY_URL = "http://localhost:8188"

def create_turbo_workflow(prompt, negative_prompt, batch_size=4, steps=6, cfg=1.5, resolution=1024):
    """Create optimized Turbo workflow"""
    return {
        "1": {
            "inputs": {"ckpt_name": "flux1-krea-dev_fp8_scaled.safetensors"},
            "class_type": "CheckpointLoaderSimple"
        },
        "2": {
            "inputs": {
                "lora_name": "FLUX.1-Turbo-Alpha.safetensors",
                "strength_model": 1.0,
                "strength_clip": 1.0,
                "model": ["1", 0],
                "clip": ["1", 1]
            },
            "class_type": "LoraLoader"
        },
        "3": {
            "inputs": {
                "text": prompt,
                "clip": ["2", 1]
            },
            "class_type": "CLIPTextEncode"
        },
        "4": {
            "inputs": {
                "text": negative_prompt,
                "clip": ["2", 1]
            },
            "class_type": "CLIPTextEncode"
        },
        "5": {
            "inputs": {
                "width": resolution,
                "height": resolution,
                "batch_size": batch_size
            },
            "class_type": "EmptyLatentImage"
        },
        "6": {
            "inputs": {
                "seed": int(time.time() * 1000) % 1000000,  # Random seed
                "steps": steps,
                "cfg": cfg,
                "sampler_name": "euler",
                "scheduler": "simple",
                "denoise": 1,
                "model": ["2", 0],
                "positive": ["3", 0],
                "negative": ["4", 0],
                "latent_image": ["5", 0]
            },
            "class_type": "KSampler"
        },
        "7": {
            "inputs": {
                "samples": ["6", 0],
                "vae": ["1", 2]
            },
            "class_type": "VAEDecode"
        },
        "8": {
            "inputs": {
                "filename_prefix": "turbo_batch",
                "images": ["7", 0]
            },
            "class_type": "SaveImage"
        }
    }

def queue_prompt(workflow):
    """Submit workflow to ComfyUI"""
    try:
        response = requests.post(
            f"{COMFY_URL}/prompt",
            json={"prompt": workflow},
            timeout=10
        )
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"Error: {e}")
        return None

def wait_for_completion(prompt_id, timeout=300):
    """Wait for generation"""
    start = time.time()
    while time.time() - start < timeout:
        try:
            response = requests.get(f"{COMFY_URL}/history/{prompt_id}", timeout=5)
            if prompt_id in response.json():
                return True
        except:
            pass
        time.sleep(1)
    return False

def main():
    parser = argparse.ArgumentParser(description='Ultra-fast batch image generation')
    parser.add_argument('--prompt', type=str,
                       default='A beautiful woman, professional photography, high quality, detailed',
                       help='Positive prompt')
    parser.add_argument('--negative', type=str,
                       default='low quality, blurry, distorted, ugly',
                       help='Negative prompt')
    parser.add_argument('--batches', type=int, default=1,
                       help='Number of batches to generate')
    parser.add_argument('--batch-size', type=int, default=4,
                       help='Images per batch (1-8)')
    parser.add_argument('--steps', type=int, default=6,
                       help='Sampling steps (4-8 for Turbo)')
    parser.add_argument('--cfg', type=float, default=1.5,
                       help='CFG scale (1.0-2.0 for Turbo)')
    parser.add_argument('--resolution', type=int, default=1024,
                       help='Image resolution (512, 768, or 1024)')

    args = parser.parse_args()

    print("="*80)
    print("TURBO BATCH GENERATION - Flux Kria FP8 + Turbo LoRA")
    print("="*80)
    print()
    print(f"Configuration:")
    print(f"  Model: Flux 1 Kria FP8 (12GB)")
    print(f"  LoRA: FLUX.1-Turbo-Alpha (strength: 1.0)")
    print(f"  Batches: {args.batches}")
    print(f"  Batch Size: {args.batch_size} images")
    print(f"  Total Images: {args.batches * args.batch_size}")
    print(f"  Steps: {args.steps}")
    print(f"  CFG: {args.cfg}")
    print(f"  Resolution: {args.resolution}x{args.resolution}")
    print()
    print(f"Expected Time:")

    # Calculate expected time
    time_per_batch = 3 + (args.steps * args.batch_size * 0.5)  # Rough estimate
    total_time = time_per_batch * args.batches
    print(f"  ~{time_per_batch:.1f} seconds per batch")
    print(f"  ~{total_time:.1f} seconds total ({total_time/60:.1f} minutes)")
    print()

    # Check server
    try:
        requests.get(f"{COMFY_URL}/system_stats", timeout=5)
    except:
        print("ERROR: ComfyUI not running at http://localhost:8188")
        print("Start ComfyUI first!")
        return

    # Generate batches
    print("Starting generation...")
    print()

    successful_batches = 0
    total_images = 0
    start_time = time.time()

    for batch_num in range(1, args.batches + 1):
        print(f"[Batch {batch_num}/{args.batches}] Queuing {args.batch_size} images...")

        workflow = create_turbo_workflow(
            args.prompt,
            args.negative,
            args.batch_size,
            args.steps,
            args.cfg,
            args.resolution
        )

        batch_start = time.time()
        result = queue_prompt(workflow)

        if result and 'prompt_id' in result:
            prompt_id = result['prompt_id']
            print(f"              Prompt ID: {prompt_id}")
            print(f"              Generating... ", end='', flush=True)

            if wait_for_completion(prompt_id, timeout=300):
                batch_time = time.time() - batch_start
                time_per_image = batch_time / args.batch_size
                successful_batches += 1
                total_images += args.batch_size
                print(f"DONE! ({batch_time:.1f}s total, {time_per_image:.1f}s per image)")
            else:
                print("TIMEOUT or FAILED")
        else:
            print("              ERROR: Failed to queue")

        print()

    # Summary
    total_time = time.time() - start_time

    print("="*80)
    print("GENERATION COMPLETE!")
    print("="*80)
    print()
    print(f"Successful: {successful_batches}/{args.batches} batches")
    print(f"Total Images: {total_images}")
    print(f"Total Time: {total_time:.1f} seconds ({total_time/60:.1f} minutes)")
    if total_images > 0:
        print(f"Average: {total_time/total_images:.2f} seconds per image")
    print()
    print(f"Output: D:\\workspace\\fluxdype\\ComfyUI\\output\\turbo_batch_*.png")
    print()

if __name__ == "__main__":
    main()
