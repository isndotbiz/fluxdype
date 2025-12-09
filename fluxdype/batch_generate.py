#!/usr/bin/env python3
"""
Ultra-Realistic Batch Image Generator for Phone Apps
Generates high-quality, HD images optimized for mobile viewing.
"""

import os
import sys
import json
import time
import uuid
import random
import argparse
import requests
from pathlib import Path
from typing import List, Dict, Optional
from datetime import datetime

# Configuration
COMFY_HOST = "localhost"
COMFY_PORT = 8188
COMFY_URL = f"http://{COMFY_HOST}:{COMFY_PORT}"

# Phone-optimized resolutions
RESOLUTIONS = {
    "portrait": (1024, 1536),      # 2:3 aspect ratio (Instagram portrait)
    "portrait_hd": (1080, 1920),   # Full HD portrait (9:16)
    "square": (1024, 1024),        # Square (1:1)
    "landscape": (1536, 1024),     # Landscape (3:2)
    "landscape_hd": (1920, 1080),  # Full HD landscape (16:9)
    "story": (1080, 1920),         # Instagram/TikTok story
}

# Quality presets
QUALITY_PRESETS = {
    "ultra": {
        "steps": 30,
        "cfg": 3.5,
        "loras": [
            {"name": "ultrafluxV1.aWjp.safetensors", "strength": 0.9},
            {"name": "facebookQuality.3t4R.safetensors", "strength": 0.7}
        ],
        "description": "Maximum quality for professional use"
    },
    "high": {
        "steps": 25,
        "cfg": 3.5,
        "loras": [
            {"name": "ultrafluxV1.aWjp.safetensors", "strength": 0.85},
            {"name": "facebookQuality.3t4R.safetensors", "strength": 0.65}
        ],
        "description": "High quality, balanced speed"
    },
    "balanced": {
        "steps": 20,
        "cfg": 3.0,
        "loras": [
            {"name": "ultrafluxV1.aWjp.safetensors", "strength": 0.75}
        ],
        "description": "Good quality, faster generation"
    },
    "fast": {
        "steps": 15,
        "cfg": 2.5,
        "loras": [
            {"name": "FLUX.1-Turbo-Alpha.safetensors", "strength": 1.0}
        ],
        "description": "Quick generation for previews"
    }
}


class BatchImageGenerator:
    """Batch image generation for ultra-realistic phone app content"""

    def __init__(self, host: str = COMFY_HOST, port: int = COMFY_PORT):
        self.host = host
        self.port = port
        self.base_url = f"http://{host}:{port}"
        self.session_id = str(uuid.uuid4())
        self.generated_images = []

    def check_server(self) -> bool:
        """Check if ComfyUI server is running"""
        try:
            response = requests.get(f"{self.base_url}/system_stats", timeout=5)
            return response.status_code == 200
        except:
            return False

    def create_workflow(
        self,
        prompt: str,
        negative_prompt: str,
        resolution: tuple,
        quality: str = "high",
        seed: Optional[int] = None,
        batch_size: int = 1
    ) -> Dict:
        """Create workflow JSON for image generation"""

        if seed is None:
            seed = random.randint(0, 2**32 - 1)

        preset = QUALITY_PRESETS[quality]
        width, height = resolution

        # Build workflow
        workflow = {
            "1": {
                "inputs": {
                    "ckpt_name": "flux1-dev-fp8.safetensors"
                },
                "class_type": "CheckpointLoaderSimple"
            },
            "2": {
                "inputs": {
                    "text": f"{prompt}, ultra realistic, high resolution, 8k uhd, professional photography, detailed, sharp focus, perfect composition, masterpiece, best quality",
                    "clip": ["1", 1]
                },
                "class_type": "CLIPTextEncode"
            },
            "3": {
                "inputs": {
                    "text": f"{negative_prompt}, low quality, blurry, pixelated, compressed, jpeg artifacts, watermark, text, logo, oversaturated, cartoon, anime, painting, illustration, unrealistic, distorted, deformed, amateur, grainy",
                    "clip": ["1", 1]
                },
                "class_type": "CLIPTextEncode"
            },
            "4": {
                "inputs": {
                    "seed": seed,
                    "steps": preset["steps"],
                    "cfg": preset["cfg"],
                    "sampler_name": "euler",
                    "scheduler": "simple",
                    "denoise": 1.0,
                    "model": ["10", 0],
                    "positive": ["2", 0],
                    "negative": ["3", 0],
                    "latent_image": ["5", 0]
                },
                "class_type": "KSampler"
            },
            "5": {
                "inputs": {
                    "width": width,
                    "height": height,
                    "batch_size": batch_size
                },
                "class_type": "EmptyLatentImage"
            },
            "6": {
                "inputs": {
                    "samples": ["4", 0],
                    "vae": ["1", 2]
                },
                "class_type": "VAEDecode"
            },
            "7": {
                "inputs": {
                    "filename_prefix": f"batch_{datetime.now().strftime('%Y%m%d_%H%M%S')}",
                    "images": ["6", 0]
                },
                "class_type": "SaveImage"
            }
        }

        # Add LoRAs based on quality preset
        current_node_id = 10
        prev_model_node = "1"

        for i, lora in enumerate(preset["loras"]):
            workflow[str(current_node_id)] = {
                "inputs": {
                    "lora_name": lora["name"],
                    "strength_model": lora["strength"],
                    "strength_clip": lora["strength"],
                    "model": [prev_model_node, 0],
                    "clip": ["1", 1]
                },
                "class_type": "LoraLoader"
            }
            prev_model_node = str(current_node_id)
            current_node_id += 1

        # Update sampler to use the last LoRA node
        workflow["4"]["inputs"]["model"] = [prev_model_node, 0]

        return {"prompt": workflow}

    def submit_workflow(self, workflow: Dict) -> Optional[str]:
        """Submit workflow to ComfyUI and return prompt_id"""
        try:
            response = requests.post(
                f"{self.base_url}/prompt",
                json=workflow,
                timeout=10
            )
            response.raise_for_status()
            result = response.json()
            return result.get("prompt_id")
        except Exception as e:
            print(f"✗ Error submitting workflow: {e}")
            return None

    def check_status(self, prompt_id: str) -> Optional[Dict]:
        """Check if generation is complete"""
        try:
            response = requests.get(f"{self.base_url}/history/{prompt_id}", timeout=5)
            response.raise_for_status()
            history = response.json()
            return history.get(prompt_id)
        except:
            return None

    def wait_for_completion(self, prompt_id: str, timeout: int = 300) -> bool:
        """Wait for image generation to complete"""
        start_time = time.time()

        print(f"  Generating (ID: {prompt_id[:8]}...)...", end="", flush=True)

        while time.time() - start_time < timeout:
            status = self.check_status(prompt_id)
            if status:
                print(" ✓ Complete")
                return True

            time.sleep(2)
            print(".", end="", flush=True)

        print(" ✗ Timeout")
        return False

    def generate_batch(
        self,
        prompts: List[str],
        resolution: str = "portrait",
        quality: str = "high",
        variations: int = 1,
        negative_prompt: str = "",
        wait: bool = True
    ) -> List[str]:
        """Generate batch of images from prompts"""

        if not self.check_server():
            print("✗ ComfyUI server is not running!")
            print(f"  Start server: .\\start-comfy.ps1")
            return []

        if resolution not in RESOLUTIONS:
            print(f"✗ Invalid resolution: {resolution}")
            print(f"  Available: {', '.join(RESOLUTIONS.keys())}")
            return []

        if quality not in QUALITY_PRESETS:
            print(f"✗ Invalid quality: {quality}")
            print(f"  Available: {', '.join(QUALITY_PRESETS.keys())}")
            return []

        res = RESOLUTIONS[resolution]
        preset = QUALITY_PRESETS[quality]

        print("=" * 70)
        print("ULTRA-REALISTIC BATCH IMAGE GENERATOR")
        print("=" * 70)
        print(f"Resolution: {resolution} ({res[0]}x{res[1]})")
        print(f"Quality: {quality} - {preset['description']}")
        print(f"Steps: {preset['steps']} | CFG: {preset['cfg']}")
        print(f"LoRAs: {', '.join([l['name'].split('.')[0] for l in preset['loras']])}")
        print(f"Prompts: {len(prompts)} | Variations: {variations}")
        print(f"Total images: {len(prompts) * variations}")
        print("=" * 70)
        print()

        generated_ids = []
        total_images = len(prompts) * variations
        current = 0

        for prompt_idx, prompt in enumerate(prompts, 1):
            print(f"[{prompt_idx}/{len(prompts)}] Prompt: {prompt[:60]}...")

            for var in range(variations):
                current += 1
                print(f"  [{current}/{total_images}] Variation {var + 1}/{variations}")

                # Create and submit workflow
                workflow = self.create_workflow(
                    prompt=prompt,
                    negative_prompt=negative_prompt,
                    resolution=res,
                    quality=quality,
                    seed=None  # Random seed for each variation
                )

                prompt_id = self.submit_workflow(workflow)

                if prompt_id:
                    generated_ids.append(prompt_id)

                    if wait:
                        success = self.wait_for_completion(prompt_id)
                        if not success:
                            print(f"  ⚠ Generation timed out, moving to next...")
                    else:
                        print(f"  ✓ Submitted (ID: {prompt_id[:8]}...)")
                else:
                    print(f"  ✗ Failed to submit")

            print()

        print("=" * 70)
        print(f"BATCH COMPLETE: {len(generated_ids)}/{total_images} images generated")
        print(f"Output directory: D:\\workspace\\fluxdype\\ComfyUI\\output\\")
        print("=" * 70)

        return generated_ids


def load_prompts_from_file(filepath: str) -> List[str]:
    """Load prompts from text file (one per line)"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            prompts = [line.strip() for line in f if line.strip() and not line.startswith('#')]
        return prompts
    except Exception as e:
        print(f"✗ Error loading prompts from {filepath}: {e}")
        return []


def main():
    parser = argparse.ArgumentParser(
        description="Ultra-Realistic Batch Image Generator for Phone Apps",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Generate 3 variations of a single prompt
  python batch_generate.py -p "beautiful sunset over ocean" -v 3

  # Generate from prompt file with ultra quality
  python batch_generate.py -f prompts.txt -q ultra -r portrait_hd

  # Fast batch generation in landscape
  python batch_generate.py -f prompts.txt -q fast -r landscape

  # Generate for Instagram stories
  python batch_generate.py -p "fashion model portrait" -r story -v 5

Available resolutions:
  portrait      1024x1536   (2:3 - Instagram portrait)
  portrait_hd   1080x1920   (9:16 - Full HD portrait)
  square        1024x1024   (1:1 - Square)
  landscape     1536x1024   (3:2 - Landscape)
  landscape_hd  1920x1080   (16:9 - Full HD landscape)
  story         1080x1920   (9:16 - Instagram/TikTok)

Quality presets:
  ultra     30 steps - Maximum quality
  high      25 steps - High quality (default)
  balanced  20 steps - Good quality, faster
  fast      15 steps - Quick previews
        """
    )

    parser.add_argument('-p', '--prompt', type=str, help='Single prompt to generate')
    parser.add_argument('-f', '--file', type=str, help='File with prompts (one per line)')
    parser.add_argument('-r', '--resolution', type=str, default='portrait',
                        choices=list(RESOLUTIONS.keys()),
                        help='Output resolution (default: portrait)')
    parser.add_argument('-q', '--quality', type=str, default='high',
                        choices=list(QUALITY_PRESETS.keys()),
                        help='Quality preset (default: high)')
    parser.add_argument('-v', '--variations', type=int, default=1,
                        help='Number of variations per prompt (default: 1)')
    parser.add_argument('-n', '--negative', type=str, default='',
                        help='Additional negative prompt')
    parser.add_argument('--no-wait', action='store_true',
                        help='Submit all and exit without waiting')
    parser.add_argument('--host', type=str, default=COMFY_HOST,
                        help=f'ComfyUI host (default: {COMFY_HOST})')
    parser.add_argument('--port', type=int, default=COMFY_PORT,
                        help=f'ComfyUI port (default: {COMFY_PORT})')

    args = parser.parse_args()

    # Validate input
    if not args.prompt and not args.file:
        parser.print_help()
        print("\n✗ Error: Must provide either --prompt or --file")
        sys.exit(1)

    # Load prompts
    prompts = []
    if args.file:
        prompts = load_prompts_from_file(args.file)
        if not prompts:
            print(f"✗ No valid prompts found in {args.file}")
            sys.exit(1)
    elif args.prompt:
        prompts = [args.prompt]

    # Create generator
    generator = BatchImageGenerator(host=args.host, port=args.port)

    # Generate batch
    generator.generate_batch(
        prompts=prompts,
        resolution=args.resolution,
        quality=args.quality,
        variations=args.variations,
        negative_prompt=args.negative,
        wait=not args.no_wait
    )


if __name__ == "__main__":
    main()
