#!/usr/bin/env python3
"""Download Flux 2.0 Dev FP8 after license acceptance"""

from huggingface_hub import hf_hub_download
from dotenv import load_dotenv
import os
from pathlib import Path

load_dotenv()
token = os.getenv('HUGGINGFACE_TOKEN')

if not token:
    print('ERROR: HUGGINGFACE_TOKEN not found in .env file!')
    print('Please add your HuggingFace token to the .env file')
    exit(1)

print("="*80)
print("Downloading Flux 2.0 Dev FP8 Model")
print("="*80)
print()

target_dir = Path('D:/workspace/fluxdype/ComfyUI/models/diffusion_models')
target_dir.mkdir(parents=True, exist_ok=True)

print(f'Target directory: {target_dir}')
print(f'Using HuggingFace token: {token[:10]}...{token[-4:]}')
print()

print('[1/1] Downloading Flux 2.0 Dev FP8 model...')
print('      Repository: black-forest-labs/FLUX.2-dev')
print('      File: flux2-dev-fp8.safetensors')
print('      Size: ~14.8 GB')
print('      This may take 10-30 minutes depending on your connection')
print()

try:
    model_path = hf_hub_download(
        repo_id='black-forest-labs/FLUX.2-dev',
        filename='flux2-dev-fp8.safetensors',
        local_dir=target_dir,
        token=token,
        resume_download=True
    )

    print()
    print("="*80)
    print("SUCCESS!")
    print("="*80)
    print()
    print(f'Downloaded to: {model_path}')

    # Check file size
    file_size = Path(model_path).stat().st_size / 1024**3
    print(f'File size: {file_size:.2f} GB')
    print()
    print('Model is ready to use in ComfyUI!')
    print('Restart ComfyUI to see the new model in the checkpoint dropdown.')
    print()

except Exception as e:
    print()
    print("="*80)
    print("ERROR!")
    print("="*80)
    print()
    print(f'Error: {str(e)}')
    print()
    print('TROUBLESHOOTING:')
    print('1. Make sure you accepted the license at:')
    print('   https://huggingface.co/black-forest-labs/FLUX.2-dev')
    print('2. Check your HuggingFace token in .env file')
    print('3. Try generating a new token with "Read gated repos" permission')
    print('4. Run this script again')
    print()
    exit(1)
