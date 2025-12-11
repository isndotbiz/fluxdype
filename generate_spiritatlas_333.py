#!/usr/bin/env python3
"""
SpiritAtlas - 333 Image Batch Generation
Cosmic, spiritual, mystical sacred geometry variations
GPU ONLY - Turbo Mode - 512x512 or 256x256
"""

import json
import requests
import time
import random
from pathlib import Path

COMFY_URL = "http://localhost:8188"

# Color palette from SpiritAtlas
COLORS = {
    "cosmic_violet": "#6B21A8",
    "mystic_purple": "#7C3AED",
    "spiritual_purple": "#8B5CF6",
    "night_sky": "#1E1B4B",
    "stardust_blue": "#3B82F6",
    "water_teal": "#14B8A6",
    "sacred_gold": "#D97706",
    "aura_gold": "#FBBF24",
    "temple_bronze": "#B45309",
    "aurora_pink": "#EC4899",
    "sensual_coral": "#F87171",
    "fire_orange": "#F97316",
    "earth_green": "#22C55E",
    "air_cyan": "#06B6D4"
}

# Base prompt variations
BASE_THEMES = [
    # Cosmic backgrounds
    "A mesmerizing cosmic space background with deep purple gradient from {night_sky} to {mystic_purple}, scattered twinkling stars, ethereal nebula clouds, sacred geometry patterns, volumetric lighting, mystical atmosphere",

    # Sacred geometry
    "Sacred geometry mandala pattern with flower of life design, glowing {sacred_gold} lines on {cosmic_violet} background, ethereal glow, perfect symmetry, spiritual symbolism",

    # Chakra themed
    "Spiritual chakra energy visualization with gradient transitioning through seven chakra colors, glowing energy particles, ethereal wisps, mystical atmosphere, cosmic background",

    # Lotus and spiritual symbols
    "Glowing lotus flower with {mystic_purple} petals, sacred geometry patterns, golden {sacred_gold} lines, ethereal light rays, spiritual energy, cosmic backdrop",

    # Celestial/Zodiac
    "Mystical constellation artwork with glowing {stardust_blue} stars connected by {sacred_gold} lines, cosmic nebula, deep space background {night_sky}, ethereal atmosphere",

    # Yin Yang cosmic
    "Cosmic yin yang symbol filled with starfield and nebula, {mystic_purple} and {night_sky} halves, {sacred_gold} outline, perfect balance, ethereal glow",

    # Om and mantras
    "Sacred Om symbol in luminous {sacred_gold}, ethereal golden light radiating outward, subtle mandala pattern in {mystic_purple}, cosmic gradient background",

    # Meditation and energy
    "Peaceful meditative cosmic background with perfect circle of {aura_gold} light in center, concentric glowing rings, minimal stars, zen atmosphere, spiritual focus",

    # Aurora and romantic
    "Romantic aurora cosmic background blending {mystic_purple} and {aurora_pink}, flowing energy ribbons, constellation stars, ethereal light painting, tantric energy",

    # Elements themed
    "Elemental symbol with sacred geometry triangle, gradient from {fire_orange} to {earth_green}, ethereal glow, alchemical symbolism, spiritual iconography"
]

# Additional prompt modifiers
MODIFIERS = [
    "ethereal", "mystical", "cosmic", "sacred", "divine", "transcendent",
    "spiritual energy", "volumetric lighting", "god rays", "soft glow",
    "gradient mapping", "dreamy", "celestial", "astral", "luminous"
]

QUALITY_TAGS = [
    "4K quality", "ultra detailed", "sharp focus", "professional",
    "premium aesthetic", "cinematic", "high resolution", "masterpiece"
]

def create_variation_prompt(base_theme, variation_num):
    """Create a unique prompt variation"""
    # Replace color placeholders
    prompt = base_theme
    for color_name, hex_code in COLORS.items():
        prompt = prompt.replace(f"{{{color_name}}}", hex_code)

    # Add random modifiers
    num_modifiers = random.randint(2, 4)
    selected_modifiers = random.sample(MODIFIERS, num_modifiers)

    # Add quality tags
    num_quality = random.randint(1, 2)
    selected_quality = random.sample(QUALITY_TAGS, num_quality)

    # Combine
    full_prompt = f"{prompt}, {', '.join(selected_modifiers)}, {', '.join(selected_quality)}"

    return full_prompt

def create_turbo_workflow(prompt, resolution=512, batch_size=4):
    """Create Turbo workflow for SpiritAtlas generation - Flux split model structure"""
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
            "inputs": {"vae_name": "ae.safetensors"},
            "class_type": "VAELoader"
        },
        "4": {
            "inputs": {
                "lora_name": "FLUX.1-Turbo-Alpha.safetensors",
                "strength_model": 1.0,
                "strength_clip": 1.0,
                "model": ["1", 0],
                "clip": ["2", 0]
            },
            "class_type": "LoraLoader"
        },
        "5": {
            "inputs": {"text": prompt, "clip": ["4", 1]},
            "class_type": "CLIPTextEncode"
        },
        "6": {
            "inputs": {
                "text": "low quality, blurry, distorted, ugly, bad anatomy, text, watermark, signature, jpeg artifacts",
                "clip": ["4", 1]
            },
            "class_type": "CLIPTextEncode"
        },
        "7": {
            "inputs": {
                "width": resolution,
                "height": resolution,
                "batch_size": batch_size
            },
            "class_type": "EmptyLatentImage"
        },
        "8": {
            "inputs": {
                "seed": random.randint(1, 999999999),
                "steps": 6,  # Turbo mode
                "cfg": 1.5,  # Low CFG for Turbo
                "sampler_name": "euler",
                "scheduler": "simple",
                "denoise": 1,
                "model": ["4", 0],
                "positive": ["5", 0],
                "negative": ["6", 0],
                "latent_image": ["7", 0]
            },
            "class_type": "KSampler"
        },
        "9": {
            "inputs": {"samples": ["8", 0], "vae": ["3", 0]},
            "class_type": "VAEDecode"
        },
        "10": {
            "inputs": {
                "filename_prefix": "spiritatlas",
                "images": ["9", 0]
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
        print(f"    ERROR queuing: {e}")
        return None

def wait_for_completion(prompt_id, timeout=300):
    """Wait for generation to complete"""
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
    # Configuration
    TOTAL_IMAGES = 333
    RESOLUTION = 512  # 512x512 (can change to 256)
    BATCH_SIZE = 4    # 4 images per batch

    print("="*80)
    print("SPIRITATLAS - 333 IMAGE GENERATION")
    print("="*80)
    print()
    print(f"Configuration:")
    print(f"  Total Images: {TOTAL_IMAGES}")
    print(f"  Resolution: {RESOLUTION}x{RESOLUTION}")
    print(f"  Batch Size: {BATCH_SIZE}")
    print(f"  Model: Flux 1 Kria FP8")
    print(f"  LoRA: FLUX.1-Turbo-Alpha (strength 1.0)")
    print(f"  Steps: 6 (Turbo mode)")
    print(f"  CFG: 1.5 (Turbo optimized)")
    print(f"  GPU: ONLY (no CPU fallback)")
    print()

    # Calculate batches
    num_batches = (TOTAL_IMAGES + BATCH_SIZE - 1) // BATCH_SIZE
    print(f"Batches needed: {num_batches} ({BATCH_SIZE} images each)")
    print()

    # Estimate time
    time_per_batch = 30  # ~30 seconds per batch of 4 at 512x512
    total_minutes = (num_batches * time_per_batch) / 60
    print(f"Estimated time: {total_minutes:.1f} minutes ({total_minutes/60:.1f} hours)")
    print()

    # Check server
    try:
        response = requests.get(f"{COMFY_URL}/system_stats", timeout=5)
        stats = response.json()
        print(f"Server Status: ONLINE")
        print(f"GPU: {stats.get('devices', [{}])[0].get('name', 'Unknown')}")
        print()
    except:
        print("ERROR: ComfyUI server not responding!")
        print("Start ComfyUI first with GPU-only mode!")
        return

    # Start generation
    print("Starting generation automatically...")
    print()

    successful = 0
    failed = 0
    start_time = time.time()

    current_image = 0

    for batch_num in range(1, num_batches + 1):
        # Determine batch size (last batch might be smaller)
        images_remaining = TOTAL_IMAGES - current_image
        current_batch_size = min(BATCH_SIZE, images_remaining)

        # Select random theme
        theme = random.choice(BASE_THEMES)

        # Create variation prompt
        prompt = create_variation_prompt(theme, batch_num)

        print(f"[Batch {batch_num}/{num_batches}] Generating {current_batch_size} images...")
        print(f"  Images {current_image + 1}-{current_image + current_batch_size} / {TOTAL_IMAGES}")
        print(f"  Theme: {theme[:60]}...")

        # Create and queue workflow
        workflow = create_turbo_workflow(prompt, RESOLUTION, current_batch_size)
        batch_start = time.time()

        result = queue_prompt(workflow)

        if result and 'prompt_id' in result:
            prompt_id = result['prompt_id']
            print(f"  Queued: {prompt_id}")
            print(f"  Status: Generating...", end='', flush=True)

            if wait_for_completion(prompt_id, timeout=300):
                batch_time = time.time() - batch_start
                successful += current_batch_size
                current_image += current_batch_size

                # Progress stats
                elapsed = time.time() - start_time
                images_per_sec = successful / elapsed
                remaining_images = TOTAL_IMAGES - current_image
                eta_seconds = remaining_images / images_per_sec if images_per_sec > 0 else 0

                print(f" DONE! ({batch_time:.1f}s)")
                print(f"  Progress: {current_image}/{TOTAL_IMAGES} ({100*current_image/TOTAL_IMAGES:.1f}%)")
                print(f"  Speed: {images_per_sec:.2f} images/sec")
                print(f"  ETA: {eta_seconds/60:.1f} minutes")
            else:
                print(f" TIMEOUT")
                failed += current_batch_size
                current_image += current_batch_size
        else:
            print(f"  ERROR: Failed to queue")
            failed += current_batch_size
            current_image += current_batch_size

        print()

        # Every 20 batches, show summary
        if batch_num % 20 == 0:
            print("-" * 80)
            print(f"CHECKPOINT - Batch {batch_num}/{num_batches}")
            print(f"  Successful: {successful} images")
            print(f"  Failed: {failed} images")
            print(f"  Elapsed: {(time.time() - start_time)/60:.1f} minutes")
            print("-" * 80)
            print()

    # Final summary
    total_time = time.time() - start_time

    print()
    print("="*80)
    print("GENERATION COMPLETE!")
    print("="*80)
    print()
    print(f"Total Images Generated: {successful}/{TOTAL_IMAGES}")
    print(f"Failed: {failed}")
    print(f"Total Time: {total_time/60:.1f} minutes ({total_time/3600:.2f} hours)")
    print(f"Average Speed: {successful/total_time:.2f} images/second")
    print()
    print(f"Output Directory:")
    print(f"  D:\\workspace\\fluxdype\\ComfyUI\\output\\spiritatlas_*.png")
    print()
    print("Theme Distribution:")
    print(f"  Cosmic backgrounds, Sacred geometry, Chakra energy,")
    print(f"  Lotus symbols, Celestial constellations, Yin Yang,")
    print(f"  Om mantras, Meditation, Aurora, Elemental symbols")
    print()

if __name__ == "__main__":
    main()
