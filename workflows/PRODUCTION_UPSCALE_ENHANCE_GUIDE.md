# Production Upscale & Refinement Workflow

**File:** `production_upscale_enhance.json`

**Purpose:** High-quality image upscaling from 1024x1024 to 2048x2048 with subtle AI refinement for professional results.

## Workflow Overview

This is a **two-stage pipeline** designed for reliability and predictable quality:

### Stage 1: Upscaling (Node 2)
- **Ultimate SD Upscale** with NMKD-Siax model
- 2x upscaling via tiled processing (512px tiles, 32px overlap)
- Transforms 1024x1024 → 2048x2048
- Tile-based approach ensures consistent quality without memory strain on RTX 3090

### Stage 2: Refinement (Node 9)
- **Flux Krea Dev FP8** model for subtle enhancement
- Turbo LoRA @ 0.5 strength for balanced refinement
- **Key Parameters:**
  - Steps: 12 (efficient, quality-focused refinement)
  - CFG Scale: 2.2 (minimal guidance, preserves original image)
  - Denoise: 0.3 (subtle enhancement only, 70% image retention)
  - Sampler: Euler (stable, consistent results)

## Node Breakdown

| Node | Type | Purpose | Details |
|------|------|---------|---------|
| 1 | LoadImage | User input | Load PNG/JPG from ComfyUI input directory |
| 2 | UltimateSDUpscale | Upscaler | 2x scale with NMKD-Siax, tiled processing |
| 3 | UNETLoader | Model | Flux Krea Dev FP8 (quantized for RTX 3090) |
| 4 | DualCLIPLoader | Encoders | CLIP-L + T5XXL for Flux text conditioning |
| 5 | CLIPTextEncode | Positive | Enhancement prompt (leave empty for none) |
| 6 | CLIPTextEncode | Negative | Rejection terms to avoid artifacts |
| 7 | LoraLoader | LoRA | Turbo LoRA @ 0.5 strength |
| 8 | ImageToLatent | Encoding | Convert upscaled image to latent space |
| 9 | KSampler | Sampler | Refinement with low denoise (0.3) |
| 10 | VAELoader | Decoder | Standard Flux VAE (ae.safetensors) |
| 11 | VAEDecode | Decoder | Convert latent back to image |
| 12 | SaveImage | Output | Save final result to disk |
| 13 | PreviewImage | Preview | Display in ComfyUI |

## Usage

### Quick Start

1. **Load workflow in ComfyUI:**
   ```powershell
   # Copy workflow to ComfyUI
   cp D:\workspace\fluxdype\workflows\production_upscale_enhance.json D:\workspace\fluxdype\ComfyUI\workflows\
   ```

2. **Place input image:**
   - ComfyUI input directory: `D:\workspace\fluxdype\ComfyUI\input\`
   - Supported formats: PNG, JPG, JPEG
   - Recommended resolution: 1024x1024 (workflow designed for this)

3. **Load in ComfyUI Web UI:**
   - Open `http://localhost:8188`
   - Click "Load" → Select `production_upscale_enhance.json`
   - Node 1 (LoadImage): Select your input image from dropdown
   - Click **Queue Prompt** to start

4. **Monitor progress:**
   - Stage 1 (upscaling): ~5-10 seconds
   - Stage 2 (refinement): ~30-45 seconds
   - Output saved to: `D:\workspace\fluxdype\ComfyUI\output\`

### Customization

#### Edit Refinement Prompt (Optional)

Node 5 (Positive Prompt) is empty by default. To enhance results with specific directions:

**Example - Increase Detail:**
```
enhance details, sharper, high quality, professional
```

**Example - Color Enhancement:**
```
vibrant colors, enhanced saturation, vivid tones
```

**Example - Texture Improvement:**
```
smooth skin, fine details, crisp textures
```

#### Change Upscale Factor

Currently 2x (1024→2048). To adjust:

**Node 2 (UltimateSDUpscale):**
- `tile_size`: Keep at 512 (RTX 3090 optimal)
- `tile_overlap`: Keep at 32 (prevents seams)
- For 4x upscale: Use different model or run workflow twice sequentially

#### Adjust Refinement Strength

**Node 9 (KSampler):**
- **More refinement:** Increase `denoise` (0.3 → 0.5)
  - Risk: May over-process, change original colors
- **Less refinement:** Decrease `denoise` (0.3 → 0.1)
  - Result: Nearly pure upscaling with minimal enhancement
- **CFG adjustment:** 2.2 is optimal for this model
  - Too high (>3.0): Introduces artifacts
  - Too low (<1.5): Loses enhancement effect

#### Change LoRA Strength

**Node 7 (LoraLoader):**
```json
"strength_model": 0.5,      // Model influence (0.0-1.0)
"strength_clip": 0.5        // Text encoding influence (0.0-1.0)
```

**Recommended ranges:**
- 0.3: Very subtle refinement
- 0.5: Balanced (current, recommended)
- 0.7: Strong enhancement
- 1.0: Maximum LoRA effect

## Performance Expectations

### RTX 3090 (12GB VRAM)

| Stage | Time | VRAM Used |
|-------|------|-----------|
| Upscale (2x, 512px tiles) | 5-10s | 4-6 GB |
| Refinement (12 steps) | 30-45s | 8-10 GB |
| **Total** | **40-60s** | **Peak 10 GB** |

### Quality Metrics

| Metric | Value | Notes |
|--------|-------|-------|
| Output Resolution | 2048x2048 | Fixed |
| Aspect Ratio | Preserves input | If square → square output |
| Denoise Level | 0.3 (subtle) | 70% of original retained |
| Artifact Risk | Very low | Conservative parameters |
| Color Shift | Minimal | CFG 2.2 preserves colors |

## Troubleshooting

### Issue: "Out of memory" error

**Solution:**
- Ensure no other GPU tasks running
- Check ComfyUI system stats: `http://localhost:8188/system_stats`
- Reduce tile size in Node 2: 512 → 384
- Reduce refinement steps in Node 9: 12 → 8

### Issue: Upscaled image looks blurry

**Solution:**
- Upscaler models vary in sharpness
- Available alternatives in `models/upscale_models/`:
  - 4x_NMKD-Siax_200k.pth (current, balanced)
  - Try other ESRGAN variants if installed
- Increase refinement: Set denoise to 0.5 in Node 9

### Issue: Refinement introduces unwanted changes

**Solution:**
- Reduce LoRA strength: Node 7 → 0.3
- Reduce denoise: Node 9 → 0.1
- Clear positive prompt: Node 5 → empty text

### Issue: Slow performance (>90s)

**Solution:**
- Close other applications
- Check disk I/O: ComfyUI output directory may be slow
- Monitor GPU: Install GPU-Z to check clock throttling
- Verify CUDA 12.1 is installed correctly

## Model Information

### UNETLoader (Node 3)
- **Model:** `flux1-krea-dev_fp8_scaled.safetensors`
- **Size:** ~12 GB (quantized to FP8)
- **Quality:** High quality refinement
- **Alternatives:** `flux1-dev-Q8_0.safetensors` (slightly faster)

### LoraLoader (Node 7)
- **LoRA:** `FLUX.1-Turbo-Alpha.safetensors`
- **Purpose:** Fast, efficient refinement
- **Strength:** 0.5 (balanced)
- **Alternatives:** Remove for pure upscale, or use other LoRAs

### VAELoader (Node 10)
- **VAE:** `ae.safetensors` (standard Flux VAE)
- **Size:** ~850 MB
- **Quality:** Standard Flux color accuracy

### UltimateSDUpscale Upscaler (Node 2)
- **Model:** `4x_NMKD-Siax_200k.pth`
- **Size:** ~160 MB
- **Type:** ESRGAN-based 2x upscaler
- **Quality:** Balanced detail/smoothness

## Advanced Configurations

### Production Batch Processing

```powershell
# Use run-workflow.ps1 with loop
foreach ($image in Get-ChildItem "input\*.png") {
    .\run-workflow.ps1 -WorkflowPath "workflows\production_upscale_enhance.json" -Wait
}
```

### Custom Quality Tiers

**Conservative (Minimal Changes)**
```json
Node 7: strength_model: 0.3, strength_clip: 0.3
Node 9: denoise: 0.15, steps: 8
```

**Balanced (Current)**
```json
Node 7: strength_model: 0.5, strength_clip: 0.5
Node 9: denoise: 0.3, steps: 12
```

**Aggressive (Maximum Enhancement)**
```json
Node 7: strength_model: 0.8, strength_clip: 0.8
Node 9: denoise: 0.5, steps: 20
```

## Best Practices

1. **Input Quality:** Start with 1024x1024 or higher for best results
2. **Batch Processing:** Process similar images together for consistency
3. **Monitoring:** Watch first output to verify parameters before batch
4. **Backup:** Save original images before upscaling
5. **Color Space:** PNG is recommended (lossless)
6. **Verification:** Always preview before mass production

## Output Location

**Default:** `D:\workspace\fluxdype\ComfyUI\output\upscale_enhanced_*.png`

All images prefixed with `upscale_enhanced_` with timestamp.

## Workflow Architecture Benefits

✓ **Reliability:** Only tested, core nodes
✓ **Efficiency:** 12 steps for quality vs. speed
✓ **Predictability:** Conservative parameters minimize surprises
✓ **RTX 3090 Optimized:** Tiled upscaling respects VRAM limits
✓ **Flexibility:** Easy parameter tweaking without reloading
✓ **Quality:** 2048x2048 final output with subtle refinement

---

**Version:** 1.0
**Last Updated:** December 10, 2024
**ComfyUI Version:** Latest
**GPU:** RTX 3090 (CUDA 12.1)
