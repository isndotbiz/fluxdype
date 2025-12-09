#!/usr/bin/env python3
"""
API-Based Prompt Optimizer (No Local VRAM)
Usage: python optimize_prompt_api.py "your idea" --style photorealistic
"""

import requests
import os
import sys
import argparse

def load_env():
    """Load .env file manually"""
    env_path = os.path.join(os.path.dirname(__file__), '.env')
    env_vars = {}

    if os.path.exists(env_path):
        with open(env_path, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    env_vars[key] = value
    return env_vars

SYSTEM_PROMPT = """You are an expert Flux image prompt engineer. Optimize prompts following these rules:

1. Use clear, descriptive language with comma-separated keywords
2. Include technical details (lighting, composition, camera settings for photos)
3. Add quality markers: masterpiece, best quality, highly detailed, 8k
4. Match the requested style exactly
5. Suggest optimal negative prompt to avoid common issues
6. Recommend specific settings (sampler, steps, CFG, resolution)

Output format:
OPTIMIZED PROMPT: [detailed comma-separated prompt]

NEGATIVE PROMPT: [things to avoid]

RECOMMENDED SETTINGS:
- Model: [best Flux model for this]
- Sampler: [sampler name]
- Scheduler: [scheduler name]
- Steps: [number]
- CFG: [value]
- Resolution: [width x height]
- LoRAs: [suggested LoRAs if applicable]
"""

def optimize_prompt(prompt, style="photorealistic", model="anthropic/claude-3.5-sonnet"):
    # Load environment variables
    env_vars = load_env()
    api_key = env_vars.get("OPENROUTER_API_KEY")

    if not api_key:
        print("\nError: OPENROUTER_API_KEY not found in .env file", file=sys.stderr)
        print("\nTo fix this:", file=sys.stderr)
        print("1. Go to https://openrouter.ai/", file=sys.stderr)
        print("2. Sign in and get an API key", file=sys.stderr)
        print("3. Add to .env file: OPENROUTER_API_KEY=sk-or-v1-...", file=sys.stderr)
        print("\nSee API_PROMPT_HELPER_SETUP.md for details\n", file=sys.stderr)
        sys.exit(1)

    data = {
        "model": model,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": f"Style: {style}\nOriginal idea: {prompt}\n\nOptimize this for Flux image generation."}
        ]
    }

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/fluxdype",
        "X-Title": "Flux Prompt Optimizer"
    }

    print(f"\nOptimizing prompt...")
    print(f"Model: {model}\n")

    try:
        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers=headers,
            json=data,
            timeout=30
        )
        response.raise_for_status()
        result = response.json()

        print("=" * 70)
        print("AI PROMPT OPTIMIZER")
        print("=" * 70)
        print(result['choices'][0]['message']['content'])
        print("=" * 70)

        # Show cost
        tokens = result.get('usage', {}).get('total_tokens', 0)
        cost = tokens * 0.000001  # Rough estimate
        print(f"\nTokens used: {tokens} | Estimated cost: ~${cost:.6f}")
        print()

    except requests.exceptions.RequestException as e:
        print(f"\nAPI request failed!", file=sys.stderr)
        print(f"Error: {e}", file=sys.stderr)
        print("\nPossible issues:", file=sys.stderr)
        print("- Check your API key is valid", file=sys.stderr)
        print("- Ensure you have credits at https://openrouter.ai/credits", file=sys.stderr)
        print("- Check your internet connection\n", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Optimize Flux prompts using AI (No Local VRAM)")
    parser.add_argument("prompt", help="Your prompt idea")
    parser.add_argument("--style", default="photorealistic", help="Image style (default: photorealistic)")
    parser.add_argument("--model", default="anthropic/claude-3.5-sonnet", help="Model to use (default: claude-3.5-sonnet)")

    args = parser.parse_args()
    optimize_prompt(args.prompt, args.style, args.model)
