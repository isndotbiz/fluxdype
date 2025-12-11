# Ultra-Realistic Batch Image Generation for Phone Apps

## Overview

FluxDype now includes a complete batch generation system for creating ultra-realistic, high-quality HD images optimized for phone apps. The system uses Flux Kria FP8 models with quality-enhancement LoRAs to produce professional-grade images.

## Features

✨ **Ultra-Realistic Quality**
- Professional photography-grade output
- Multiple quality presets (ultra, high, balanced, fast)
- Advanced LoRA stacking for maximum quality

📱 **Phone-Optimized Resolutions**
- Portrait: 1024×1536, 1080×1920 (Instagram, wallpapers)
- Square: 1024×1024 (social media posts)
- Story: 1080×1920 (Instagram/TikTok Stories)
- Landscape: 1536×1024, 1920×1080 (headers, banners)

⚡ **Batch Processing**
- Generate dozens or hundreds of images from command line
- Prompt files support (one prompt per line)
- Multiple variations per prompt
- Progress tracking and error handling

🎨 **Quality Enhancement Stack**
- ultrafluxV1: General quality boost
- facebookQuality: Social media optimization
- Realism LoRAs: Photorealistic enhancement
- Detail LoRAs: Fine detail enhancement

## Quick Start (30 seconds)

### 1. Start ComfyUI Server
```powershell
cd D:\workspace\fluxdype
.\start-comfy.ps1
```

### 2. Generate Your First Batch
```powershell
# Single image test
.\batch-generate.ps1 -Prompt "professional portrait, natural lighting" -Quality fast

# Batch from file
.\batch-generate.ps1 -File prompts_phone_app.txt -Quality high

# Multiple variations
.\batch-generate.ps1 -Prompt "fashion model portrait" -Variations 5 -Quality ultra
```

### 3. Check Output
```
D:\workspace\fluxdype\ComfyUI\output\batch_*.png
```

## Files Created

| File | Purpose |
|------|---------|
| `batch_generate.py` | Core batch generation engine (Python) |
| `batch-generate.ps1` | PowerShell convenience wrapper |
| `prompts_phone_app.txt` | Sample prompts for phone app content |
| `BATCH_GENERATION_GUIDE.md` | Comprehensive usage guide |
| `test_batch_quick.ps1` | Quick system test script |
| `workflows/ultra_realistic_batch.json` | Workflow template |

## Usage Examples

### Example 1: Quick Test
```powershell
# Test with single fast image
.\test_batch_quick.ps1
```

### Example 2: Social Media Content Pack
```powershell
# Generate 30 Instagram portraits (10 prompts × 3 variations)
.\batch-generate.ps1 -File prompts_phone_app.txt -Resolution portrait -Variations 3 -Quality high
```

### Example 3: High-Quality Hero Images
```powershell
# Generate 5 ultra-quality variations of a hero image
.\batch-generate.ps1 -Prompt "stunning portrait, golden hour lighting, professional" -Variations 5 -Quality ultra -Resolution portrait_hd
```

### Example 4: Story Content Batch
```powershell
# Generate 50 Instagram Story images quickly
.\batch-generate.ps1 -File story_prompts.txt -Resolution story -Quality balanced -Variations 2
```

## Quality Presets

| Preset | Steps | Time | Best For |
|--------|-------|------|----------|
| **Ultra** | 30 | 60-90s | Final production, hero images |
| **High** | 25 | 45-60s | Standard production (default) |
| **Balanced** | 20 | 30-45s | Quick iterations, testing |
| **Fast** | 15 | 20-30s | Previews, rapid prototyping |

## Resolution Guide

### Portrait Modes
- **portrait** (1024×1536): Instagram feed, general use
- **portrait_hd** (1080×1920): Full HD, phone wallpapers
- **story** (1080×1920): Instagram/TikTok Stories

### Other Modes
- **square** (1024×1024): Instagram posts, avatars
- **landscape** (1536×1024): Headers, banners
- **landscape_hd** (1920×1080): Full HD landscape

## Command Reference

### PowerShell (Recommended)
```powershell
.\batch-generate.ps1 [options]

Options:
  -Prompt <string>        Single prompt
  -File <path>           Prompt file path
  -Resolution <preset>   portrait|portrait_hd|square|landscape|landscape_hd|story
  -Quality <preset>      ultra|high|balanced|fast
  -Variations <int>      Number per prompt (default: 1)
  -Negative <string>     Additional negative prompt
  -NoWait                Submit without waiting
```

### Python (Advanced)
```powershell
python batch_generate.py [options]

Options:
  -p, --prompt          Single prompt
  -f, --file           Prompt file
  -r, --resolution     Resolution preset
  -q, --quality        Quality preset
  -v, --variations     Variations per prompt
  -n, --negative       Additional negative prompt
  --no-wait            Submit without waiting
  --host               ComfyUI host (default: localhost)
  --port               ComfyUI port (default: 8188)
```

## Creating Prompt Files

Create a text file with one prompt per line:

```text
# prompts.txt - Lines starting with # are comments

professional headshot, natural lighting, corporate elegance
lifestyle portrait, outdoor park, golden hour, candid smile
fashion model, urban street, trendy outfit, confident pose
beauty portrait, studio lighting, flawless skin, soft focus
```

**Sample prompt file included:** `prompts_phone_app.txt`

## LoRA Configuration

The system uses a quality-enhancement LoRA stack:

### Default Stack (High Quality)
1. **ultrafluxV1** (0.85 strength): General quality enhancement
2. **facebookQuality** (0.65 strength): Social media optimization

### Ultra Quality Stack
1. **ultrafluxV1** (0.9 strength): Maximum quality boost
2. **facebookQuality** (0.7 strength): Enhanced social optimization

### Fast Stack
1. **FLUX.1-Turbo-Alpha** (1.0 strength): Speed optimization

## Automatic Quality Enhancements

Every prompt automatically includes:

**Positive Additions:**
- `ultra realistic, high resolution, 8k uhd`
- `professional photography, detailed, sharp focus`
- `perfect composition, masterpiece, best quality`

**Negative Terms:**
- `low quality, blurry, pixelated, compressed`
- `watermark, text, logo, oversaturated`
- `cartoon, anime, unrealistic, distorted`

## Performance (RTX 3090)

| Batch Size | Quality | Total Time |
|------------|---------|------------|
| 10 images | Ultra | ~12 minutes |
| 10 images | High | ~8 minutes |
| 50 images | High | ~43 minutes |
| 50 images | Balanced | ~31 minutes |
| 100 images | Balanced | ~63 minutes |
| 100 images | Fast | ~41 minutes |

## Best Practices

### Prompt Writing
✓ Be specific about lighting and mood
✓ Include subject details when relevant
✓ Mention technical aspects (sharp, bokeh, etc.)
✓ Keep prompts under 150 characters
✗ Don't over-complicate prompts
✗ Avoid contradictory instructions

### Batch Strategy
- Test with 1-2 images first
- Use `balanced` or `fast` for large batches
- Reserve `ultra` for final production
- Generate variations for A/B testing
- Organize output into project folders

### Quality Optimization
- Use `portrait_hd` or `landscape_hd` for maximum resolution
- Stack multiple LoRAs for enhanced quality
- Adjust CFG scale (2.5-4.0) for style control
- Use custom negative prompts for specific issues

## Troubleshooting

### Server Not Running
```
✗ ComfyUI server is not running!
```
**Solution:** Open new terminal, run `.\start-comfy.ps1`

### CUDA Out of Memory
```
CUDA out of memory
```
**Solutions:**
- Use lower resolution
- Use `balanced` or `fast` quality
- Reduce variations count
- Restart ComfyUI server

### LoRA Files Missing
```
✗ LoRA not found
```
**Solution:** Check `ComfyUI/models/loras/` directory. Re-download if needed.

### Slow Generation
**Solutions:**
- Use `balanced` or `fast` quality
- Check GPU temperature
- Close other GPU applications
- Verify no CPU bottleneck

## Output Management

**Default Location:**
```
D:\workspace\fluxdype\ComfyUI\output\
```

**Organize by Project:**
```powershell
# Create project folders
mkdir D:\workspace\fluxdype\ComfyUI\output\project_name

# Move generated images
mv D:\workspace\fluxdype\ComfyUI\output\batch_* .\ComfyUI\output\project_name\
```

**Filename Format:**
```
batch_YYYYMMDD_HHMMSS_00001_.png
batch_YYYYMMDD_HHMMSS_00002_.png
```

## Integration Examples

### PowerShell Pipeline
```powershell
# Generate and auto-organize
.\batch-generate.ps1 -File prompts.txt -Quality high
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
mkdir ".\output\batch_$timestamp"
mv .\ComfyUI\output\batch_*.png ".\output\batch_$timestamp\"
```

### Scheduled Batches
```powershell
# Windows Task Scheduler
schtasks /create /tn "NightlyBatch" /tr "powershell D:\workspace\fluxdype\batch-generate.ps1 -File daily.txt" /sc daily /st 02:00
```

### Python API
```python
from batch_generate import BatchImageGenerator

gen = BatchImageGenerator()
prompts = ["portrait 1", "portrait 2", "portrait 3"]
gen.generate_batch(prompts, resolution="portrait_hd", quality="ultra", variations=3)
```

## System Requirements

- **GPU:** NVIDIA RTX 3090 (24GB VRAM) or equivalent
- **RAM:** 16GB+ recommended
- **Storage:** 10GB+ for models, ~5MB per generated image
- **OS:** Windows with PowerShell 5.1+
- **Python:** 3.12+ with virtual environment
- **ComfyUI:** Running on port 8188

## Documentation

- **Comprehensive Guide:** `BATCH_GENERATION_GUIDE.md`
- **LoRA Registry:** `LORA_REGISTRY.json`
- **Project Setup:** `CLAUDE.md`
- **Workflow Template:** `workflows/ultra_realistic_batch.json`

## Support

For issues or questions:
1. Check `BATCH_GENERATION_GUIDE.md` for detailed troubleshooting
2. Review `LORA_REGISTRY.json` for LoRA configuration
3. Verify ComfyUI server status: `http://localhost:8188`
4. Test with `.\test_batch_quick.ps1`

---

**Ready to generate?**

```powershell
# Start server
.\start-comfy.ps1

# Test system
.\test_batch_quick.ps1

# Generate batch
.\batch-generate.ps1 -File prompts_phone_app.txt -Quality high

# Check output
explorer D:\workspace\fluxdype\ComfyUI\output\
```

---

**FluxDype Batch Generator** - Professional-grade image generation for phone apps
