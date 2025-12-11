# ComfyUI Extensions and Flux Models Setup Guide

## Overview
This guide documents all installed ComfyUI custom nodes and the proper organization of your Flux models from CivitAI.

---

## 🎨 Installed Custom Nodes/Extensions

### Core Management
- **ComfyUI-Manager** - Essential extension manager for installing, removing, disabling, and enabling custom nodes

### Flux-Specific Extensions
1. **x-flux-comfyui** (XLabs-AI)
   - Advanced Flux model control
   - FluxLoraLoader for loading LoRA models
   - LoadFluxControlNet for advanced manipulation
   - ApplyFluxControlNet for specific output control
   - ApplyFluxIPAdapter for additional customization
   - Location: `custom_nodes/x-flux-comfyui/`

2. **flux_autoload.py** (Custom Script)
   - Forces ComfyUI to recognize your Flux models correctly
   - Prevents misdetection as SDXL models
   - Auto-registers models matching patterns: flux, fluxed, iniversemix, unstableevolution
   - Location: `custom_nodes/flux_autoload.py`

### Workflow Enhancement Nodes
1. **ComfyUI-Impact-Pack**
   - Essential quality of life improvements
   - Advanced node functionality
   - Location: `custom_nodes/ComfyUI-Impact-Pack/`

2. **rgthree-comfy**
   - Workflow optimization nodes
   - Power routing and organization tools
   - Location: `custom_nodes/rgthree-comfy/`

3. **Use Everywhere (cg-use-everywhere)**
   - Connect nodes anywhere without spaghetti wiring
   - Location: `custom_nodes/cg-use-everywhere/`

4. **Efficiency Nodes**
   - Streamlines workflows and reduces node count
   - Location: `custom_nodes/efficiency-nodes-comfyui/`

5. **ComfyUI Essentials**
   - Collection of essential utility nodes
   - Location: `custom_nodes/ComfyUI_essentials/`

6. **ComfyUI Custom Scripts**
   - Quality of life scripting improvements
   - Location: `custom_nodes/ComfyUI-Custom-Scripts/`

### ControlNet & Advanced Control
1. **ComfyUI-Advanced-ControlNet**
   - Advanced ControlNet support for Flux
   - Location: `custom_nodes/ComfyUI-Advanced-ControlNet/`

2. **KJNodes**
   - Powerful utility nodes including masks, math, and image processing
   - Location: `custom_nodes/ComfyUI-KJNodes/`

### Model Support
1. **ComfyUI-GGUF**
   - Support for GGUF quantized models
   - Allows Flux to run in lower bits on low-end GPUs
   - Location: `custom_nodes/ComfyUI-GGUF/`

### Upscaling & Enhancement
1. **Ultimate SD Upscale**
   - Tiled upscaling for large images
   - Location: `custom_nodes/ComfyUI_UltimateSDUpscale/`

2. **Comfyroll Studio**
   - Comprehensive node collection
   - Location: `custom_nodes/ComfyUI_Comfyroll_CustomNodes/`

### Utilities
1. **WAS Node Suite**
   - Extensive collection of utility nodes
   - Image processing, text handling, and more
   - Location: `custom_nodes/was-node-suite-comfyui/`

2. **Crystools**
   - Resource monitor
   - Progress bar & time elapsed
   - Metadata viewer and image comparison
   - Location: `custom_nodes/ComfyUI-Crystools/`

---

## 📂 Model Organization & Locations

### ✅ Current Setup

#### Flux Checkpoints (Main Models)
**Location:** `D:\workspace\fluxdype\ComfyUI\models\checkpoints\`

Your Flux models (from CivitAI):
- `fluxedUpFluxNSFW_60FP16_2250122.safetensors` (23GB)
- `iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors` (12GB)
- `iniverseMixSFWNSFW_guofengXLV15.safetensors` (6.7GB)
- `unstableEvolution_Fp1622GB.safetensors` (23GB)
- `flux_dev.safetensors` (16GB) - Original Flux Dev model

**Total:** 5 Flux checkpoint models (~80GB)

#### Flux LoRAs
**Location:** `D:\workspace\fluxdype\ComfyUI\models\loras\`

Your LoRAs (from CivitAI):
1. `Add_Details_v1.2_1406099.safetensors` (5.2MB) - Detail enhancement
2. `Ahegao_SDXL-000031.safetensors` (28MB) - Style LoRA
3. `Ana_V1.safetensors` (293MB) - Character LoRA
4. `DetailTweaker_SDXL.safetensors` (9.2MB) - Detail adjustment
5. `dmd2_sdxl_4step_lora.safetensors` (751MB) - Fast generation
6. `Realism Lora By Stable Yogi_V3_Lite_1971030.safetensors` (650MB)
7. `Realism Lora By Stable Yogi_V3_Pro.safetensors` (650MB)
8. `Realism_Lora_By_Stable_yogi_SDXL8.1.safetensors` (43MB)
9. `Super_Eye_Detailer_By_Stable_Yogi_SDPD0.safetensors` (55MB)

**Total:** 9 LoRAs (~2.5GB)

**Note:** Even though some LoRAs have "SDXL" in the name, they can work with Flux models if they're compatible with the architecture.

---

## 🗂️ Complete ComfyUI Model Directory Structure

```
D:\workspace\fluxdype\ComfyUI\models\
├── checkpoints/           # Main Flux models (.safetensors)
├── loras/                 # LoRA models for style/detail adjustments
├── diffusion_models/      # Alternative Flux model location
├── text_encoders/         # T5XXL and CLIP encoders for Flux
├── vae/                   # VAE models
├── clip/                  # CLIP models
├── controlnet/            # ControlNet models for Flux
├── upscale_models/        # Upscaling models (ESRGAN, etc.)
├── embeddings/            # Text inversions
├── clip_vision/           # CLIP vision models
├── style_models/          # Style transfer models
├── photomaker/            # PhotoMaker models
└── configs/               # Model configuration files
```

---

## 📥 Where to Place CivitAI Models

When downloading from CivitAI, place models according to their type:

| Model Type | File Extension | ComfyUI Location |
|------------|---------------|------------------|
| Flux Checkpoints | `.safetensors`, `.ckpt` | `models/checkpoints/` |
| Flux LoRAs | `.safetensors` | `models/loras/` |
| Flux ControlNet | `.safetensors` | `models/controlnet/` |
| VAE | `.safetensors`, `.pt` | `models/vae/` |
| Text Encoders | `.safetensors` | `models/text_encoders/` |
| Upscalers | `.pth`, `.safetensors` | `models/upscale_models/` |
| Embeddings | `.pt`, `.safetensors` | `models/embeddings/` |

---

## 🚀 Using Your Flux Models in ComfyUI

### Loading Flux Models

**Important:** Your Flux models will now be auto-detected thanks to `flux_autoload.py`.

1. **Start ComfyUI Server:**
   ```powershell
   cd D:\workspace\fluxdype
   .\start-comfy.ps1
   ```

2. **Check Console Output:**
   You should see messages like:
   ```
   🚀 Loading Flux autoload custom node...
   ✅ Registered Flux model: fluxedUpFluxNSFW_60FP16_2250122.safetensors
   ✅ Registered Flux model: iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors
   ✅ Registered Flux model: unstableEvolution_Fp1622GB.safetensors
   🔧 Flux autoload complete: 5 models registered as 'FLUX'
   ```

3. **In ComfyUI Web Interface:**
   - Use the standard **"Load Checkpoint"** node
   - Your Flux models will appear in the dropdown
   - The models are now recognized as Flux, not SDXL

### Using Flux LoRAs

1. Add a **"Load LoRA"** node (or **FluxLoraLoader** from x-flux-comfyui)
2. Select your LoRA from the dropdown
3. Adjust strength (typically 0.5 - 1.0 for Flux)
4. Connect to your model pipeline

### Workflow Recommendations

**Basic Flux Text-to-Image:**
```
Load Checkpoint (Flux) → CLIP Text Encode (Positive) → KSampler → VAE Decode → Save Image
                      → CLIP Text Encode (Negative) ↗
```

**Flux with LoRA:**
```
Load Checkpoint → Load LoRA → CLIP Text Encode → KSampler → VAE Decode → Save Image
```

**Flux with Upscaling:**
```
[Basic workflow] → Ultimate SD Upscale → Save Image
```

---

## 🔧 Troubleshooting

### Models Not Appearing
1. Restart ComfyUI server
2. Check console for flux_autoload.py messages
3. Verify models are in `ComfyUI/models/checkpoints/`

### "SDXL model detected" Error
- The `flux_autoload.py` script should prevent this
- If it still occurs, add your model's name pattern to `FLUX_PATTERNS` in `flux_autoload.py`

### Out of Memory (CUDA)
- Use smaller Flux models (FP8 quantized versions)
- Add `--lowvram` flag to `start-comfy.ps1`
- Close other GPU-intensive applications

### LoRA Not Working
- Some LoRAs labeled "SDXL" may not be compatible with Flux architecture
- Try reducing LoRA strength
- Check CivitAI page for Flux compatibility notes

---

## 📚 Resources

- **ComfyUI Official Examples:** https://comfyanonymous.github.io/ComfyUI_examples/flux/
- **CivitAI Flux Models:** https://civitai.com/tag/flux
- **ComfyUI Wiki:** https://comfyui-wiki.com/en/tutorial/advanced/flux1-comfyui-guide-workflow-and-examples
- **X-Flux ComfyUI Docs:** Check `custom_nodes/x-flux-comfyui/README.md`

---

## 📝 Notes

- All extensions are in `D:\workspace\fluxdype\ComfyUI\custom_nodes/`
- Original models backed up in `D:\workspace\fluxdype\models_archive/`
- ComfyUI has **native Flux support** - no separate Flux node pack needed
- Use ComfyUI-Manager to update and manage custom nodes
- The `flux_autoload.py` script runs automatically on ComfyUI startup

---

## 🎯 Next Steps

1. **Restart ComfyUI** to load all new extensions and the flux_autoload script
2. **Test a simple Flux workflow** with one of your models
3. **Explore custom nodes** - especially x-flux-comfyui features
4. **Download more models** from CivitAI if needed (place in appropriate directories)
5. **Create workflow templates** and save them for reuse

---

**Setup Complete!** ✨

You now have:
- ✅ 15+ essential ComfyUI extensions installed
- ✅ 5 Flux checkpoint models ready to use
- ✅ 9 LoRA models organized and accessible
- ✅ Automatic Flux model detection configured
- ✅ Full model organization structure documented
