import urllib.request
import os
from pathlib import Path

def download_file(url, destination):
    """Download file with progress indicator"""
    print(f"Downloading {os.path.basename(destination)}...")
    try:
        urllib.request.urlretrieve(url, destination)
        print(f"✓ Downloaded to {destination}")
        return True
    except Exception as e:
        print(f"✗ Error downloading: {e}")
        return False

# Model URLs and destinations
models = [
    {
        "url": "https://huggingface.co/InstantX/InstantID/resolve/main/ip-adapter.bin",
        "dest": "D:/workspace/fluxdype/ComfyUI/models/instantid/ip-adapter.bin"
    },
    {
        "url": "https://huggingface.co/InstantX/InstantID/resolve/main/ControlNetModel/diffusion_pytorch_model.safetensors",
        "dest": "D:/workspace/fluxdype/ComfyUI/models/controlnet/instantid_controlnet.safetensors"
    }
]

print("=" * 60)
print("InstantID Model Downloader")
print("=" * 60)

for model in models:
    dest_path = Path(model["dest"])
    
    # Check if already exists
    if dest_path.exists():
        print(f"⊗ {dest_path.name} already exists, skipping...")
        continue
    
    # Create directory if needed
    dest_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Download
    download_file(model["url"], str(dest_path))

print("\n" + "=" * 60)
print("Note: You still need to download antelopev2 models manually:")
print("https://huggingface.co/MonsterMMORPG/tools/resolve/main/antelopev2.zip")
print("Extract to: D:/workspace/fluxdype/ComfyUI/models/insightface/models/antelopev2/")
print("=" * 60)
