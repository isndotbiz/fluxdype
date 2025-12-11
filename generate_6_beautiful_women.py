#!/usr/bin/env python3
"""
Generate 6 test images of beautiful women using ComfyUI API
Using optimized Flux Dev FP8 model for RTX 3090
"""

import json
import requests
import time
import random
from pathlib import Path

COMFY_URL = "http://localhost:8188"
OUTPUT_DIR = Path("D:/workspace/fluxdype/outputs")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# 6 diverse prompts for beautiful women
PROMPTS = [
    "A professional portrait of a beautiful woman with flowing dark hair, natural makeup, soft studio lighting, elegant expression, photorealistic, high quality, detailed facial features, 8k, masterpiece",

    "A stunning blonde woman with blue eyes, golden hour sunlight, natural beauty, glowing skin, gentle smile, outdoor portrait, photorealistic, professional photography, sharp focus, bokeh background",

    "Beautiful asian woman with long black hair, traditional modern style, confident gaze, professional headshot, studio lighting, detailed eyes, photorealistic, high resolution, elegant pose",

    "A gorgeous red-haired woman with freckles, natural beauty, soft smile, warm lighting, close-up portrait, detailed skin texture, photorealistic, magazine quality, professional photography",

    "Beautiful latina woman with curly brown hair, vibrant personality, natural makeup, outdoor setting, sunlit portrait, confident expression, photorealistic, high quality, sharp details",

    "A stunning woman with platinum hair, piercing green eyes, editorial fashion portrait, dramatic lighting, high fashion makeup, photorealistic, professional photography, 8k, masterpiece"
]

NEGATIVE_PROMPT = "low quality, blurry, distorted, deformed, ugly, bad anatomy, extra limbs, mutation, artifacts, watermark, text, signature, jpeg artifacts, worst quality"

def create_workflow(prompt, seed):
    """Create ComfyUI workflow JSON"""
    return {
        "3": {
            "inputs": {
                "seed": seed,
                "steps": 20,
                "cfg": 3.5,
                "sampler_name": "euler",
                "scheduler": "simple",
                "denoise": 1,
                "model": ["4", 0],
                "positive": ["6", 0],
                "negative": ["7", 0],
                "latent_image": ["5", 0]
            },
            "class_type": "KSampler"
        },
        "4": {
            "inputs": {
                "ckpt_name": "flux1-krea-dev_fp8_scaled.safetensors"
            },
            "class_type": "CheckpointLoaderSimple"
        },
        "5": {
            "inputs": {
                "width": 1024,
                "height": 1024,
                "batch_size": 1
            },
            "class_type": "EmptyLatentImage"
        },
        "6": {
            "inputs": {
                "text": prompt,
                "clip": ["8", 1]
            },
            "class_type": "CLIPTextEncode"
        },
        "7": {
            "inputs": {
                "text": NEGATIVE_PROMPT,
                "clip": ["8", 1]
            },
            "class_type": "CLIPTextEncode"
        },
        "8": {
            "inputs": {
                "lora_name": "fluxInstaGirlsV2.dbl2.safetensors",
                "strength_model": 0.7,
                "strength_clip": 0.7,
                "model": ["4", 0],
                "clip": ["4", 1]
            },
            "class_type": "LoraLoader"
        },
        "9": {
            "inputs": {
                "samples": ["3", 0],
                "vae": ["4", 2]
            },
            "class_type": "VAEDecode"
        },
        "10": {
            "inputs": {
                "filename_prefix": f"beautiful_woman_{seed}",
                "images": ["9", 0]
            },
            "class_type": "SaveImage"
        }
    }

def check_server():
    """Check if ComfyUI server is running"""
    try:
        response = requests.get(f"{COMFY_URL}/system_stats", timeout=5)
        return response.status_code == 200
    except:
        return False

def queue_prompt(workflow):
    """Submit workflow to ComfyUI queue"""
    payload = {"prompt": workflow}
    try:
        response = requests.post(f"{COMFY_URL}/prompt", json=payload, timeout=10)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"Error queuing prompt: {e}")
        return None

def wait_for_completion(prompt_id, timeout=300):
    """Wait for generation to complete"""
    start_time = time.time()
    while time.time() - start_time < timeout:
        try:
            response = requests.get(f"{COMFY_URL}/history/{prompt_id}", timeout=5)
            history = response.json()
            if prompt_id in history:
                return True
        except:
            pass
        time.sleep(2)
    return False

def main():
    print("="* 80)
    print("Generating 6 Beautiful Women Portraits with Flux Dev FP8")
    print("="* 80)
    print()

    # Check server
    print("[1/2] Checking ComfyUI server status...")
    if not check_server():
        print("      ERROR: ComfyUI server not responding at http://localhost:8188")
        print("      Please start ComfyUI first!")
        return
    print("      SUCCESS: Server is online")
    print()

    # Get system stats
    try:
        stats = requests.get(f"{COMFY_URL}/system_stats").json()
        gpu_info = stats.get('devices', [{}])[0]
        vram_total = gpu_info.get('vram_total', 0) / 1024**3
        vram_free = gpu_info.get('vram_free', 0) / 1024**3
        print(f"      GPU: {gpu_info.get('name', 'Unknown')}")
        print(f"      VRAM: {vram_free:.2f}GB free / {vram_total:.2f}GB total")
        print()
    except:
        pass

    # Generate images
    print("[2/2] Generating 6 portraits...")
    print(f"      Model: Flux Dev FP8 (11.09GB)")
    print(f"      LoRA: Instagram Girls V2 (Strength: 0.7)")
    print(f"      Resolution: 1024x1024")
    print(f"      Steps: 20, CFG: 3.5, Sampler: Euler")
    print()

    successful = 0
    for i, prompt in enumerate(PROMPTS, 1):
        seed = random.randint(1, 1000000)
        print(f"   [{i}/6] Generating image {i}...")
        print(f"         Seed: {seed}")
        print(f"         Prompt: {prompt[:60]}...")

        workflow = create_workflow(prompt, seed)
        result = queue_prompt(workflow)

        if result and 'prompt_id' in result:
            prompt_id = result['prompt_id']
            print(f"         Queued: {prompt_id}")
            print(f"         Status: Generating... (this may take 30-60 seconds)")

            if wait_for_completion(prompt_id, timeout=300):
                successful += 1
                print(f"         SUCCESS: Image {i} completed!")
            else:
                print(f"         WARNING: Image {i} timed out or failed")
        else:
            print(f"         ERROR: Failed to queue prompt")

        print()

    print("="* 80)
    print(f"Generation Complete: {successful}/6 images generated successfully")
    print("="* 80)
    print()
    print("Output location:")
    print(f"  ComfyUI/output/beautiful_woman_*.png")
    print()

    # List generated files
    output_dir = Path("D:/workspace/fluxdype/ComfyUI/output")
    if output_dir.exists():
        recent_files = sorted(
            [f for f in output_dir.glob("beautiful_woman_*.png")],
            key=lambda x: x.stat().st_mtime,
            reverse=True
        )[:6]

        if recent_files:
            print("Recent generated images:")
            for f in recent_files:
                size_mb = f.stat().st_size / 1024**2
                print(f"  - {f.name} ({size_mb:.2f} MB)")

    print()
    print("="* 80)
    print("Next Steps:")
    print("="* 80)
    print()
    print("1. View images in: D:\\workspace\\fluxdype\\ComfyUI\\output\\")
    print("2. Access ComfyUI WebUI: http://localhost:8188")
    print("3. To get Flux 2.0 Dev FP8:")
    print("   - Visit: https://huggingface.co/black-forest-labs/FLUX.2-dev")
    print("   - Accept license agreement")
    print("   - Download with your HuggingFace token")
    print()
    print("Research Reports Created:")
    print("  - FLUX_2_DEV_RTX_3090_QUANTIZATION_REPORT.md")
    print("  - FLUX_COMFYUI_ESSENTIAL_CUSTOM_NODES.md")
    print("  - (Check your workspace for all research findings)")
    print()

if __name__ == "__main__":
    main()
