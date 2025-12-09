# Batch Generation Guide for Ultra-Realistic Phone App Images

## Quick Start

### 1. Start ComfyUI Server
```powershell
cd D:\workspace\fluxdype
.\start-comfy.ps1
```
Wait for server to start on `http://localhost:8188`

### 2. Generate Images

**Single Prompt (3 variations):**
```powershell
.\batch-generate.ps1 -Prompt "professional headshot, natural lighting" -Variations 3
```

**From Prompt File:**
```powershell
.\batch-generate.ps1 -File prompts_phone_app.txt -Quality high
```

**Ultra Quality for Important Content:**
```powershell
.\batch-generate.ps1 -File prompts_phone_app.txt -Quality ultra -Resolution portrait_hd
```

**Fast Preview Generation:**
```powershell
.\batch-generate.ps1 -File prompts_phone_app.txt -Quality fast -Variations 2
```

## Resolution Options

| Resolution | Size | Aspect | Best For |
|-----------|------|--------|----------|
| `portrait` | 1024x1536 | 2:3 | Instagram feed, general portraits |
| `portrait_hd` | 1080x1920 | 9:16 | Full HD portraits, phone wallpapers |
| `square` | 1024x1024 | 1:1 | Instagram square posts, avatars |
| `landscape` | 1536x1024 | 3:2 | Landscape photos, headers |
| `landscape_hd` | 1920x1080 | 16:9 | Full HD landscape, banners |
| `story` | 1080x1920 | 9:16 | Instagram/TikTok Stories |

## Quality Presets

### Ultra (30 steps)
- **Best for:** Final production images, hero content
- **LoRAs:** ultrafluxV1 (0.9) + facebookQuality (0.7)
- **Time:** ~60-90 seconds per image
- **Use when:** Quality is paramount

### High (25 steps) - **DEFAULT**
- **Best for:** Most use cases, balanced quality/speed
- **LoRAs:** ultrafluxV1 (0.85) + facebookQuality (0.65)
- **Time:** ~45-60 seconds per image
- **Use when:** Standard production work

### Balanced (20 steps)
- **Best for:** Quick iterations, testing prompts
- **LoRAs:** ultrafluxV1 (0.75)
- **Time:** ~30-45 seconds per image
- **Use when:** Rapid prototyping

### Fast (15 steps)
- **Best for:** Previews, quick concepts
- **LoRAs:** FLUX.1-Turbo-Alpha (1.0)
- **Time:** ~20-30 seconds per image
- **Use when:** Speed matters most

## Workflow Examples

### Example 1: Product Photoshoot (10 images, 3 variations each)

```powershell
# 1. Start server
.\start-comfy.ps1

# 2. Create prompts file
@"
professional product photography, smartphone on white background
luxury watch on marble surface, elegant lighting
cosmetics bottle with soft shadows, beauty aesthetic
coffee cup on wooden table, morning light
"@ | Out-File -FilePath product_prompts.txt

# 3. Generate with ultra quality
.\batch-generate.ps1 -File product_prompts.txt -Quality ultra -Resolution square -Variations 3
```

**Result:** 12 images (4 prompts × 3 variations), ultra quality, square format

### Example 2: Social Media Content Batch

```powershell
# Generate 50 Instagram story images quickly
.\batch-generate.ps1 -File social_prompts.txt -Quality high -Resolution story -Variations 2
```

### Example 3: Portrait Portfolio

```powershell
# High-quality portrait variations
.\batch-generate.ps1 -Prompt "professional headshot, executive portrait, studio lighting" -Quality ultra -Resolution portrait_hd -Variations 10
```

### Example 4: A/B Testing Assets

```powershell
# Generate multiple versions for testing
.\batch-generate.ps1 -File ab_test_prompts.txt -Quality high -Resolution portrait -Variations 5
```

## Creating Prompt Files

### Format
```text
# Comments start with #
# One prompt per line
# Blank lines are ignored

professional portrait, natural lighting, confident expression
lifestyle photo, outdoor setting, golden hour
fashion model, urban background, trendy outfit
```

### Best Practices

**DO:**
- ✓ Be specific about lighting (natural, studio, golden hour)
- ✓ Include subject details (age, gender, ethnicity if relevant)
- ✓ Specify mood/emotion (confident, happy, serene)
- ✓ Add technical details (sharp focus, bokeh, shallow depth of field)
- ✓ Use quality keywords (professional, high resolution, detailed)

**DON'T:**
- ✗ Use overly complex prompts (keep under 150 chars)
- ✗ Include contradictory instructions
- ✗ Overuse negative prompts (handled automatically)
- ✗ Request impossible compositions

### Auto-Enhanced Prompts

The system automatically adds quality enhancers:
- ✓ `ultra realistic, high resolution, 8k uhd`
- ✓ `professional photography, detailed, sharp focus`
- ✓ `perfect composition, masterpiece, best quality`

And negative terms:
- ✓ `low quality, blurry, pixelated, compressed`
- ✓ `watermark, text, logo, oversaturated`
- ✓ `cartoon, anime, unrealistic, distorted`

## Advanced Usage

### Custom Negative Prompts
```powershell
.\batch-generate.ps1 -Prompt "beach portrait" -Negative "sunglasses, hats, accessories" -Variations 3
```

### Submit and Exit (for long batches)
```powershell
.\batch-generate.ps1 -File large_batch.txt -NoWait
# Check output folder later
```

### Different Server
```powershell
python batch_generate.py -f prompts.txt --host 192.168.1.100 --port 8189
```

## Output Management

**Output Location:**
```
D:\workspace\fluxdype\ComfyUI\output\
```

**Filename Format:**
```
batch_YYYYMMDD_HHMMSS_00001_.png
batch_YYYYMMDD_HHMMSS_00002_.png
...
```

**Organizing Output:**
```powershell
# Create project-specific folders
mkdir D:\workspace\fluxdype\ComfyUI\output\project_name

# Move after generation
mv D:\workspace\fluxdype\ComfyUI\output\batch_* D:\workspace\fluxdype\ComfyUI\output\project_name\
```

## Performance Tips

### GPU Optimization (RTX 3090)
- Use `high` or `balanced` quality for batch work
- Avoid running other GPU-intensive tasks
- Monitor VRAM usage (24GB available)

### Batch Size Strategy
- **Small batches (1-10 images):** Use `ultra` quality
- **Medium batches (10-50 images):** Use `high` quality
- **Large batches (50+ images):** Use `balanced` or `fast`

### Time Estimates (RTX 3090)

| Quality | Steps | Time/Image | 100 Images |
|---------|-------|------------|------------|
| Ultra | 30 | ~75s | ~2 hours |
| High | 25 | ~52s | ~1.5 hours |
| Balanced | 20 | ~38s | ~1 hour |
| Fast | 15 | ~25s | ~40 min |

## Troubleshooting

### Server Not Running
```
✗ ComfyUI server is not running!
  Start server: .\start-comfy.ps1
```
**Solution:** Open new terminal, run `.\start-comfy.ps1`

### Out of Memory
```
CUDA out of memory
```
**Solution:**
- Reduce resolution
- Use `balanced` or `fast` quality
- Restart server

### Slow Generation
**Solutions:**
- Use `balanced` or `fast` quality
- Check GPU temperature (thermal throttling)
- Close other GPU applications

### Poor Quality Results
**Solutions:**
- Use `high` or `ultra` quality
- Improve prompt specificity
- Add negative prompts
- Check LoRA files are present

## Python API Usage

```python
from batch_generate import BatchImageGenerator

# Create generator
gen = BatchImageGenerator()

# Generate batch
prompts = [
    "professional headshot, natural lighting",
    "lifestyle portrait, outdoor setting",
    "fashion model, urban background"
]

gen.generate_batch(
    prompts=prompts,
    resolution="portrait_hd",
    quality="ultra",
    variations=3,
    wait=True
)
```

## Integration with External Tools

### PowerShell Pipeline
```powershell
# Generate and count
.\batch-generate.ps1 -File prompts.txt -Quality high
$count = (Get-ChildItem D:\workspace\fluxdype\ComfyUI\output\batch_*.png).Count
Write-Host "Generated $count images"
```

### Scheduled Batch Generation
```powershell
# Windows Task Scheduler
schtasks /create /tn "DailyBatchGen" /tr "powershell -File D:\workspace\fluxdype\batch-generate.ps1 -File daily_prompts.txt" /sc daily /st 02:00
```

## Quality Checklist

Before running large batches:

- [ ] Test with 1-2 images first
- [ ] Verify prompts produce desired results
- [ ] Check output resolution matches requirements
- [ ] Ensure sufficient disk space (1-5MB per image)
- [ ] Confirm LoRA files are loaded correctly
- [ ] Review generated samples before scaling up

## Support & Resources

- **ComfyUI Documentation:** https://github.com/comfyanonymous/ComfyUI
- **Flux Model Info:** https://huggingface.co/black-forest-labs
- **LoRA Registry:** `D:\workspace\fluxdype\LORA_REGISTRY.json`
- **Project Docs:** `D:\workspace\fluxdype\CLAUDE.md`

---

**FluxDype** - Ultra-realistic image generation optimized for phone apps
