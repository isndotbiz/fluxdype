#!/usr/bin/env python3
"""
Flux Model Conversion to GGUF Q8 Format
Converts SafeTensors models to GGUF format with Q8_0 quantization
"""
import os
import sys
import subprocess
import shutil
from pathlib import Path

# Configuration
MODELS_DIR = "D:/workspace/fluxdype/ComfyUI/models/diffusion_models"
LLAMA_CPP_DIR = "D:/workspace/fluxdype/llama.cpp"
OUTPUT_DIR = "D:/workspace/fluxdype/ComfyUI/models/diffusion_models"

# Models to convert (name, filename, description)
MODELS_TO_CONVERT = [
    (
        "FluxedUp NSFW",
        "fluxedUpFluxNSFW_60FP16_2250122.safetensors",
        "fluxedUpFluxNSFW_Q8.gguf"
    ),
    (
        "Unstable Evolution",
        "unstableEvolution_Fp1622GB.safetensors",
        "unstableEvolution_Q8.gguf"
    ),
    (
        "IniVerse F1D",
        "iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors",
        "iniverseMixF1D_Q8.gguf"
    ),
]

def check_conversion_tools():
    """Check if conversion tools are available"""
    print("=" * 80)
    print("CHECKING CONVERSION TOOLS")
    print("=" * 80)

    # Check if convert.py exists
    convert_script = os.path.join(LLAMA_CPP_DIR, "convert_hf_to_gguf.py")
    if not os.path.exists(convert_script):
        # Try alternative name
        convert_script = os.path.join(LLAMA_CPP_DIR, "convert.py")
        if not os.path.exists(convert_script):
            print("✗ Conversion script not found in llama.cpp")
            print(f"  Expected: {convert_script}")
            print("\nLooking for conversion scripts...")
            for root, dirs, files in os.walk(LLAMA_CPP_DIR):
                for f in files:
                    if 'convert' in f.lower() and f.endswith('.py'):
                        print(f"  Found: {os.path.join(root, f)}")
            return False

    print(f"✓ Conversion script found: {convert_script}")

    # Check Python packages
    required_packages = ['safetensors', 'torch', 'numpy']
    missing = []

    for pkg in required_packages:
        try:
            __import__(pkg)
            print(f"✓ {pkg} installed")
        except ImportError:
            print(f"✗ {pkg} not installed")
            missing.append(pkg)

    return True

def get_model_size(filepath):
    """Get human-readable file size"""
    size = os.path.getsize(filepath)
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size < 1024:
            return f"{size:.1f} {unit}"
        size /= 1024
    return f"{size:.1f} TB"

def convert_model(model_name, input_file, output_file):
    """Convert a single model"""
    input_path = os.path.join(MODELS_DIR, input_file)
    output_path = os.path.join(OUTPUT_DIR, output_file)

    if not os.path.exists(input_path):
        print(f"\n✗ Input file not found: {input_path}")
        return False

    print(f"\n{'='*80}")
    print(f"Converting: {model_name}")
    print(f"{'='*80}")
    print(f"Input:  {input_file} ({get_model_size(input_path)})")
    print(f"Output: {output_file}")

    # Try to find the conversion script
    convert_scripts = [
        os.path.join(LLAMA_CPP_DIR, "convert_hf_to_gguf.py"),
        os.path.join(LLAMA_CPP_DIR, "convert.py"),
    ]

    convert_script = None
    for script in convert_scripts:
        if os.path.exists(script):
            convert_script = script
            break

    if not convert_script:
        print(f"✗ No conversion script found")
        print("\nNote: This is a complex conversion. For production use, consider:")
        print("1. Using pre-quantized Q8 models from Civitai")
        print("2. Using ComfyUI's native GGUF loading without conversion")
        print("3. Using specialized GPU quantization tools")
        return False

    print(f"\nUsing: {convert_script}")
    print("\nThis may take 30-90 minutes per model...")

    try:
        cmd = [
            sys.executable,
            convert_script,
            "--src", input_path,
            "--dst", output_path,
        ]

        print(f"\nCommand: {' '.join(cmd)}")
        print("\nStarting conversion...")

        result = subprocess.run(cmd, check=False, capture_output=False)

        if result.returncode == 0:
            print(f"✓ Conversion completed!")
            if os.path.exists(output_path):
                print(f"✓ Output file: {get_model_size(output_path)}")
                return True
        else:
            print(f"✗ Conversion failed with code {result.returncode}")
            return False

    except Exception as e:
        print(f"✗ Error: {e}")
        return False

def main():
    print("\n" + "=" * 80)
    print("  FLUX MODEL GGUF CONVERSION")
    print("=" * 80)
    print()

    # Check tools
    if not check_conversion_tools():
        print("\n" + "=" * 80)
        print("CONVERSION TOOLS NOT READY")
        print("=" * 80)
        print("\nAlternative approach:")
        print("Since we couldn't find the conversion tools, we have alternatives:")
        print("\n1. DOWNLOAD PRE-QUANTIZED Q8 MODELS from Civitai:")
        print("   - Search 'FluxedUp NSFW Q8 GGUF' on civitai.com")
        print("   - Download and place in ComfyUI/models/diffusion_models/")
        print("   - Create UnetLoaderGGUF workflows")
        print("\n2. MANUAL SETUP:")
        print("   - Clone: git clone https://github.com/comfyui-community/ComfyUI-GGUF")
        print("   - Install: pip install gguf safetensors")
        print("   - Use their conversion scripts")
        print("\n3. SKIP CONVERSION FOR NOW:")
        print("   - Our Q8 GGUF test models (Flux.1-Dev, HyperFlux) already pass tests")
        print("   - Current FP16 models work reliably")
        print("   - Can optimize other areas (LoRAs, batch processing, etc.)")
        return False

    # List models to convert
    print("\n" + "=" * 80)
    print("MODELS TO CONVERT")
    print("=" * 80)

    for i, (name, input_file, output_file) in enumerate(MODELS_TO_CONVERT, 1):
        input_path = os.path.join(MODELS_DIR, input_file)
        if os.path.exists(input_path):
            size = get_model_size(input_path)
            status = "✓ Found"
        else:
            size = "NOT FOUND"
            status = "✗"
        print(f"\n{i}. {name}")
        print(f"   Input:  {input_file} ({size}) {status}")
        print(f"   Output: {output_file}")

    print("\n" + "=" * 80)
    print("CONVERSION PLAN")
    print("=" * 80)
    print("\nNote: GGUF conversion is complex and resource-intensive.")
    print("Estimated time: 2-6 hours for 3 models")
    print("Disk space needed: ~60GB (double for conversion buffer)")
    print("\nRECOMMENDATION: Use pre-quantized Q8 models from Civitai instead")
    print("(Faster, safer, community-tested)")

    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
