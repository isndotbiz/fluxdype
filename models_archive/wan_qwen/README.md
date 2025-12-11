# Wan 2.2 & Qwen Model Archive

## Overview

This archive contains Wan 2.2 and Qwen multimodal models that have been archived from the active ComfyUI models directory. These models are specialized for video generation and multimodal image understanding tasks, separate from the primary Flux text-to-image pipeline.

### Archive Contents

Total Size: ~46 GB across 10 models

#### Diffusion Models (Wan 2.2 - Video Generation)
- **Wan2.2_Remix_NSFW_i2v_14b_high_lighting_v2.0.safetensors** (13.31 GB)
  - High-light setting variant for video generation
  - Input-to-video model with 14B parameters
  - Supports NSFW content generation

- **Wan2.2_Remix_NSFW_i2v_14b_low_lighting_v2.0.safetensors** (13.31 GB)
  - Low-light setting variant for video generation
  - Input-to-video model with 14B parameters
  - Supports NSFW content generation

#### Diffusion Models (Qwen - Multimodal Understanding)
- **qwen-image-Q3_K_S.gguf** (8.34 GB)
  - Qwen vision-language model in GGUF quantized format
  - Q3_K_S quantization (3-bit compression)
  - Efficient multimodal image analysis

#### CLIP/Vision Models (Qwen)
- **qwen_2.5_vl_7b_fp8_scaled.safetensors** (8.8 GB)
  - Qwen 2.5 vision-language model
  - FP8 quantization for reduced memory usage
  - 7B parameter model

#### Text Encoders (Wan)
- **nsfw_wan_umt5-xxl_fp8_scaled.safetensors** (size varies)
  - Universal Multilingual T5 XXL encoder
  - FP8 precision for efficiency
  - Supports NSFW content understanding

#### VAE Models (Variational Autoencoders)
- **qwen_image_vae.safetensors** (243 MB)
  - Qwen-specific VAE for image encoding/decoding

- **wan_2.1_vae.safetensors** (243 MB)
  - Wan 2.1 VAE for video frame encoding/decoding

#### LoRA Models (Fine-tuning Adapters)
- **Qwen-Image-Lightning-4steps-V1.0.safetensors** (1.58 GB)
  - Qwen Lightning optimizer (4-step inference)
  - Significantly speeds up generation

- **Wan2.2-Lightning_I2V-A14B-4steps-lora_HIGH_fp16.safetensors** (0.57 GB)
  - Wan 2.2 Lightning optimizer for high-light scenarios
  - 4-step generation
  - FP16 precision

- **Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors** (0.57 GB)
  - Wan 2.2 Lightning optimizer for low-light scenarios
  - 4-step generation
  - FP16 precision

---

## Why Were These Models Archived?

### Compatibility & Workflow Focus
The primary FluxDype workflow is optimized for **Flux text-to-image generation** on NVIDIA RTX 3090 GPUs. The Wan and Qwen models serve different purposes:

1. **Wan 2.2**: Video generation (input-to-video)
   - Requires different workflow architecture
   - Video output handling differs from image generation
   - Separate inference optimization

2. **Qwen**: Multimodal image understanding
   - Vision-language tasks (captioning, VQA, image understanding)
   - Not used in current Flux text-to-image pipeline
   - Can be integrated separately for specific workflows

### Storage Optimization
- **Total size**: ~46 GB
- **GPU compatibility**: RTX 3090 (24GB VRAM) reaches limits with both Flux + Qwen/Wan models simultaneously
- **Archival frees up space**: Allows primary Flux models to remain quickly accessible
- **Flexible activation**: Restore only when needed for specific tasks

### Workflow Architecture
- Current pipeline uses: Flux diffusion models + T5XXL/CLIP encoders
- Wan/Qwen models require: Separate custom node implementations
- Recommended approach: Run Wan/Qwen in separate ComfyUI instance if needed

---

## File Organization

```
models_archive/wan_qwen/
├── README.md                              # This file
├── archive.log                            # Original archival log with timestamps
├── restore.log                            # Restoration log (created after restore)
├── diffusion_models/
│   ├── Wan2.2_Remix_NSFW_i2v_14b_high_lighting_v2.0.safetensors
│   ├── Wan2.2_Remix_NSFW_i2v_14b_low_lighting_v2.0.safetensors
│   └── qwen-image-Q3_K_S.gguf
├── clip/
│   └── qwen_2.5_vl_7b_fp8_scaled.safetensors
├── loras/
│   ├── Qwen-Image-Lightning-4steps-V1.0.safetensors
│   ├── Wan2.2-Lightning_I2V-A14B-4steps-lora_HIGH_fp16.safetensors
│   └── Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors
├── text_encoders/
│   └── nsfw_wan_umt5-xxl_fp8_scaled.safetensors
└── vae/
    ├── qwen_image_vae.safetensors
    └── wan_2.1_vae.safetensors
```

---

## How to Restore Models

### Quick Restore (All Models)
```powershell
# From D:\workspace\fluxdype\
.\restore_wan_qwen.ps1
```

### Restore with Verification (Default)
By default, the restore script verifies file integrity using SHA256 hashes:

```powershell
# Includes automatic hash verification
.\restore_wan_qwen.ps1
```

### Restore Without Verification
Skip hash verification for faster restoration (if you trust the archive integrity):

```powershell
.\restore_wan_qwen.ps1 -SkipVerification
```

### Restore to Custom Location
```powershell
.\restore_wan_qwen.ps1 -ArchivePath "D:\custom\archive\path\wan_qwen"
```

### Verify Restoration Success
Check the restore log:

```powershell
Get-Content D:\workspace\fluxdype\models_archive\wan_qwen\restore.log | Select-String SUCCESS
```

---

## Restoration Requirements

### System Requirements
- **Disk Space**: Ensure 50 GB free space on D: drive (for temporary operations)
- **Time Required**: ~5-15 minutes (depends on disk speed)
- **No GPU Required**: File operations only, no computation needed
- **PowerShell**: Version 5.1+ (Windows 7+)

### Verification Details
When restoration runs with verification enabled:
1. Calculates SHA256 hash of archived file
2. Moves file to original location
3. Recalculates hash at destination
4. Compares hashes (must match exactly)
5. Logs any mismatches for investigation

---

## Using Wan 2.2 Models

### Prerequisites
- ComfyUI with custom nodes supporting Wan architecture
- VRAM requirements:
  - High-end: 16GB+ VRAM (FP16 inference)
  - RTX 3090: 24GB, suitable for single Wan model with CPU offloading
  - CPU mode: Very slow (not recommended for video generation)

### Workflow Setup
1. Restore models using `restore_wan_qwen.ps1`
2. Ensure required custom nodes are installed:
   - Wan model loader node
   - Video output nodes (for .mp4/.webm generation)
3. Create workflow using the Wan model nodes
4. Configure parameters:
   - High/Low lighting variant selection
   - Video length (frames)
   - Resolution
   - Inference steps

### Typical Generation Parameters
- **Steps**: 25-50 (Lightning LoRA reduces to 4 steps)
- **CFG Scale**: 7.5-15
- **Sampler**: DPM++ or Euler
- **Seed**: For reproducibility
- **Video Length**: 8-24 frames typical

### Separate ComfyUI Instance (Recommended)
For production use with both Flux and Wan:
```bash
# Run Flux on port 8188 (default)
# Run Wan on port 8189 (separate instance)
python ComfyUI/main.py --listen 0.0.0.0 --port 8189
```

---

## Using Qwen Models

### Capabilities
1. **Image Captioning**: Generate descriptions from images
2. **Visual Question Answering (VQA)**: Answer questions about image content
3. **Image Classification**: Categorize images
4. **OCR**: Extract text from images
5. **Scene Understanding**: Describe objects and relationships

### Prerequisites
- Qwen custom nodes for ComfyUI
- VRAM requirements:
  - RTX 3090: 24GB suitable for single Qwen model
  - Q3_K_S GGUF variant: Highly quantized, lighter weight
  - FP8 variant: Good balance of quality and memory

### Typical Workflow
```
Image Input → Qwen VLM → Text Output (caption/answer)
```

### Performance Notes
- **FP8 Model** (qwen_2.5_vl_7b_fp8_scaled.safetensors):
  - Faster inference
  - Slightly reduced quality
  - 40-60% memory reduction

- **GGUF Model** (qwen-image-Q3_K_S.gguf):
  - Most memory efficient
  - CPU-capable inference
  - Best for resource-constrained setups

---

## Troubleshooting

### Issue: "Archive directory not found"
**Solution**: Ensure you're running the script from `D:\workspace\fluxdype\` directory:
```powershell
cd D:\workspace\fluxdype
.\restore_wan_qwen.ps1
```

### Issue: "Permission denied" during restoration
**Solution**: Run PowerShell as Administrator:
1. Right-click PowerShell
2. Select "Run as Administrator"
3. Navigate to D:\workspace\fluxdype\
4. Run the restore script

### Issue: "Hash verification failed"
**Possible causes**:
- Disk error during archival
- Corrupted archive file
- File system issue

**Solution**:
```powershell
# Re-archive the affected file manually
# Or skip verification and restore with:
.\restore_wan_qwen.ps1 -SkipVerification
```

### Issue: Restore runs out of disk space
**Solution**:
1. Restore models in batches
2. Ensure 50GB free space minimum
3. Close ComfyUI server before restoring

### Issue: Models not found after restoration
**Verification steps**:
1. Check restore.log for SUCCESS entries
2. Verify files exist in ComfyUI/models/ subdirectories:
   ```powershell
   ls D:\workspace\fluxdype\ComfyUI\models\diffusion_models | grep -i "wan\|qwen"
   ```
3. Restart ComfyUI server to reload model cache

---

## Archive Metadata

**Archive Date**: Generated with `archive_wan_qwen.ps1`
**Original Location**: `D:\workspace\fluxdype\ComfyUI/models/`
**Archive Location**: `D:\workspace\fluxdype\models_archive\wan_qwen\`

### Log Files
- **archive.log**: Records of initial archival with timestamps and file sizes
- **restore.log**: Records of each restoration attempt with verification results

### Recommended Schedule
- **Monthly**: If not using Wan/Qwen, archive can remain
- **When needed**: Restore only when setting up Wan/Qwen workflows
- **After use**: Can re-archive if storage is critical

---

## Integration with Primary Flux Workflow

### GPU Memory Strategy (RTX 3090 - 24GB)

**Flux Only** (Current):
- Flux diffusion model: ~8-10 GB
- T5XXL text encoder: ~9 GB
- CLIP encoder: ~1 GB
- VAE: ~2 GB
- ComfyUI runtime: ~2 GB
- **Total**: ~22-24 GB (optimal)

**Flux + Qwen** (if not archived):
- Flux models: ~20 GB
- Qwen VLM: ~8-10 GB
- **Total**: ~28-30 GB (exceeds VRAM, requires offloading)

**Wan (if not archived)**:
- Wan video model: ~14 GB
- Supports less concurrent VRAM for preprocessing

### Recommended Approach
1. Keep Flux models active (primary workflow)
2. Archive Wan/Qwen (reduces clutter and VRAM pressure)
3. Restore only when specifically needed
4. Run separate ComfyUI instance on alternate port if needed

---

## Related Documentation

- **ComfyUI Setup**: `CLAUDE.md` in root directory
- **Model Management**: See `COMFYUI_EXTENSIONS_AND_MODELS_GUIDE.md`
- **Optimization Guide**: Check `10_OPTIMIZATION_PROPOSALS.md`
- **Batch Generation**: See `BATCH_GENERATION_GUIDE.md`

---

## Support & Notes

This archive was created to optimize storage and GPU memory for the primary Flux text-to-image workflow on an NVIDIA RTX 3090. The models can be restored anytime without loss of quality, as they are archived in their original formats.

**Questions or Issues?**
- Check the relevant log files (archive.log, restore.log)
- Verify file system has adequate space
- Ensure ComfyUI server is stopped during restoration
- Run PowerShell as Administrator if permission errors occur

---

*Archive managed by PowerShell automation scripts*
*Last updated: 2025-12-10*
