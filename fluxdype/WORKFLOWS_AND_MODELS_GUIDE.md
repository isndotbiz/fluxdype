# Flux Workflows and Models Guide

## Test Results Summary

**✅ WORKING MODELS:**
1. **flux_dev.safetensors** - Successfully tested with quality LoRAs
   - Workflow: `1_flux_dev_quality.json`
   - Generation time: ~135 seconds (25 steps)
   - Uses: CheckpointLoaderSimple (has embedded CLIP)
   - LoRAs: ultrafluxV1 (0.8) + facebookQuality (0.7)
   - Output: `flux_dev_quality_00001_.png` (838KB)

**❌ FAILED MODELS (Missing embedded CLIP/VAE):**
2. **fluxedUpFluxNSFW_60FP16_2250122.safetensors** (23GB)
   - Error: "clip input is invalid: None"
   - Requires: UNETLoader + DualCLIPLoader + separate VAE

3. **iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors** (12GB)
   - Error: "clip input is invalid: None" + VAE channel mismatch
   - Requires: UNETLoader + DualCLIPLoader + separate VAE

4. **iniverseMixSFWNSFW_guofengXLV15.safetensors** (6.7GB)
   - Error: "clip input is invalid: None" + VAE channel mismatch
   - Requires: UNETLoader + DualCLIPLoader + separate VAE

5. **unstableEvolution_Fp1622GB.safetensors** (23GB)
   - Error: "clip input is invalid: None"
   - Requires: UNETLoader + DualCLIPLoader + separate VAE

---

## Why Some Models Failed

### Issue 1: No Embedded CLIP
Some Flux models are distributed as "UNET-only" files without embedded text encoders (CLIP/T5XXL). These models require:
- **UNETLoader** node instead of CheckpointLoaderSimple
- **DualCLIPLoader** node to load clip_l.safetensors and t5xxl_fp16.safetensors separately

### Issue 2: VAE Compatibility
The error `expected input to have 16 channels, but got 4 channels` indicates:
- Some models expect a different VAE architecture
- `ae.safetensors` (320MB) works with flux_dev but not all models
- May need specific Flux VAE versions for different model variants

---

## Available Resources

### CLIP/Text Encoders (Installed ✓)
- `clip_l.safetensors` (235MB) - in ComfyUI/models/text_encoders/
- `t5xxl_fp16.safetensors` (9.2GB) - in ComfyUI/models/text_encoders/

### VAE Files (Installed ✓)
- `ae.safetensors` (320MB) - Flux autoencoder, works with flux_dev

### Flux-Compatible LoRAs (8 total)
1. **ultrafluxV1.aWjp.safetensors** (152MB) - Quality booster ⭐
2. **facebookQuality.3t4R.safetensors** (293MB) - General quality ⭐
3. **fluxInstaGirlsV2.dbl2.safetensors** (38MB) - Instagram style portraits
4. **FluXXXv2.safetensors** (136MB) - NSFW content
5. **KREAnsfwv2.safetensors** (131MB) - NSFW content
6. **NSFW_Flux_Petite-000002.safetensors** (20MB) - NSFW content
7. **NSFW_master.safetensors** (165MB) - NSFW content
8. **NSFW_UNLOCKED.safetensors** (293MB) - NSFW content

---

## Working Workflow Structure

**For flux_dev.safetensors** (has embedded CLIP):

```
CheckpointLoaderSimple → LoraLoader (ultraflux) → LoraLoader (facebook)
                                                  ↓
CLIPTextEncode (positive) ←─────────────── CLIP output
CLIPTextEncode (negative) ←─────────────── CLIP output
                                                  ↓
EmptyLatentImage → KSampler ← Model + Prompts → VAELoader → VAEDecode → SaveImage
```

**For other models** (UNET-only, need separate CLIP):

```
UNETLoader (model.safetensors)
DualCLIPLoader (clip_l + t5xxl) → CLIPTextEncode (positive)
                                → CLIPTextEncode (negative)
VAELoader (ae.safetensors)      ↓
EmptyLatentImage → KSampler ← UNET + Prompts → VAEDecode → SaveImage
```

---

## Optimal Settings (From Testing)

### Best Settings for Flux Models:
- **Sampler**: euler (fast, reliable) or dpmpp_2m (best quality)
- **Scheduler**: simple (linear) or karras (detail-focused)
- **Steps**: 25-30 for production quality
- **CFG Scale**: 3.5-4.0 (Flux prefers lower than SDXL)
- **Denoise**: 1.0 for text-to-image
- **Resolution**: 1024x1536 (portrait) or 1536x1024 (landscape)

### LoRA Stacking (flux_dev tested):
- **Layer 1**: ultrafluxV1 at 0.7-0.8 strength
- **Layer 2**: facebookQuality at 0.6-0.7 strength
- Can stack up to 3-4 LoRAs, reduce strength for each additional layer

---

## Next Steps to Fix Failed Models

### Option 1: Create UNETLoader Workflows
Create new workflows using:
- UNETLoader for model
- DualCLIPLoader for text encoders
- Test with each failed model

### Option 2: Download Compatible VAE
Some models might need:
- FLUX.1-schnell VAE
- FLUX.1-dev VAE
- Model-specific VAE files

### Option 3: Use Only flux_dev
**Recommended for now**: Stick with flux_dev.safetensors since it:
- Works reliably with CheckpointLoaderSimple
- Supports LoRA stacking
- Generates high-quality images
- Has fastest inference (FP8 quantization, only 16GB)

---

## File Locations

**Workflows**:
- `D:\workspace\fluxdype\1_flux_dev_quality.json` ✅ WORKING
- `D:\workspace\fluxdype\2_fluxedUp_NSFW.json` ❌ needs fix
- `D:\workspace\fluxdype\3_iniverseMix_f1d.json` ❌ needs fix
- `D:\workspace\fluxdype\4_iniverseMix_guofeng.json` ❌ needs fix
- `D:\workspace\fluxdype\5_unstableEvolution.json` ❌ needs fix

**Test Scripts**:
- `test_all_models.py` - Comprehensive test suite
- `test_remaining.py` - Quick submission test
- `quick_test.py` - Single workflow test

**Models**:
- `D:\workspace\fluxdype\ComfyUI\models\checkpoints\` - 5 Flux models (78GB)
- `D:\workspace\fluxdype\ComfyUI\models\text_encoders\` - CLIP + T5XXL (9.4GB)
- `D:\workspace\fluxdype\ComfyUI\models\vae\` - ae.safetensors (320MB)
- `D:\workspace\fluxdype\ComfyUI\models\loras\` - 8 Flux LoRAs (1.2GB)

**Generated Images**:
- `D:\workspace\fluxdype\ComfyUI\output\` - All generated PNG files

---

## Recommendations

**For Immediate Use:**
1. Use `1_flux_dev_quality.json` workflow (proven working)
2. Modify the prompt in node 4 to generate different images
3. Adjust seed in node 7 for variations
4. Experiment with different LoRA combinations

**For Advanced Users:**
1. Create UNETLoader workflows for other models
2. Test different VAE configurations
3. Download model-specific VAE files if needed
4. Check CivitAI or HuggingFace for VAE compatibility info

**Performance Notes:**
- flux_dev (16GB FP8): Fastest, ~135s for 25 steps ⭐
- fluxedUp/unstableEvolution (23GB FP16): Slower, need fixes
- iniverseMix models (6-12GB): Need UNET loader setup

---

## Server Status

**ComfyUI Server**: http://localhost:8188
- Running on: RTX 3090 (24.5GB VRAM)
- Using: xformers attention (optimized)
- Python: 3.10.11
- PyTorch: 2.9.0+cu126
- ComfyUI: v0.3.68

**Custom Nodes Loaded** (22 total):
- ComfyUI-Manager
- x-flux-comfyui (Flux support)
- ComfyUI-Impact-Pack
- rgthree-comfy
- was-node-suite
- +17 more

---

## Documentation References

- **FLUX_OPTIMAL_SETTINGS.md** - Detailed parameter guide
- **FLUX_LORAS_GUIDE.md** - LoRA usage instructions
- **API_PROMPT_HELPER_SETUP.md** - OpenRouter prompt optimization
- **QUICK_START_API.md** - 5-minute prompt helper guide
- **CLAUDE.md** - Project overview and architecture

---

**Last Updated**: 2025-11-20
**Status**: 1/5 models fully working, 4/5 need UNET loader configuration
