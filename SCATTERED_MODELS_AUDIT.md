# Scattered AI Models Audit Report

**Generated:** 2025-12-10
**Scope:** C: and D: drives (excluding D:\workspace\fluxdype\ComfyUI\models\ and D:\optimum\)

## Executive Summary

- **Total Scattered Locations:** 5 major installations + Downloads folder
- **Total Models Found:** 150+ model files
- **Total Size:** ~400GB across all locations
- **Duplicates Identified:** 8 files (~1.5GB)
- **Models to Move:** 10 files (1.4GB)
- **Action Required:** Consolidation + cleanup recommended

---

## 1. C:\Users\Jdmal\Downloads (MOVE TO FLUXDYPE)

### Files Found (10 models, 1.4GB total)

| File | Size | Type | Status |
|------|------|------|--------|
| 4x_NickelbackFS_72000_G.pth | 64MB | Upscaler (4x) | MOVE to upscale_models/ |
| cyberrealisticNegative.DW8L.safetensors | 569KB | Negative embedding | MOVE to embeddings/ |
| CyberRealistic_Negative_PONY_V2-neg.safetensors | 569KB | Negative embedding | MOVE to embeddings/ |
| Facebookq-fotos.safetensors | 220MB | LoRA | MOVE to loras/ |
| Facebook_Quality_Photos.safetensors | 293MB | LoRA (DUPLICATE in Optimum) | MOVE to loras/ |
| ponyChar4ByStableYogi.uIsD.safetensors | 55MB | LoRA | MOVE to loras/ |
| realism20lora20by.cpW5.safetensors | 650MB | LoRA | MOVE to loras/ |
| realismLoraByStable.VvFC.safetensors | 43MB | LoRA | MOVE to loras/ |
| Realism_Lora_By_Stable_yogi_SDXL8.1.safetensors | 43MB | LoRA (DUPLICATE in Optimum) | MOVE to loras/ |
| superEyeDetailerBy.4EGS.safetensors | 55MB | LoRA (DUPLICATE in Optimum) | MOVE to loras/ |

**Modified:** October 26-27, 2024

**Action:** Run consolidation script to move all to fluxdype

---

## 2. D:\ai-workspace\ComfyUI\models (DUPLICATE INSTALLATION - 31GB)

### Overview
- Old/abandoned ComfyUI installation
- Contains duplicates of fluxdype models
- Some unique LoRAs in organized subdirectories

### Key Models

**Diffusion Models (24GB):**
- flux1-dev-fp8.safetensors (12GB) - DUPLICATE
- flux1-dev-kontext_fp8_scaled.safetensors (12GB) - DUPLICATE

**Text Encoders (352MB):**
- clip_l.safetensors (235MB) - DUPLICATE
- t5xxl_fp16.safetensors (117MB) - DUPLICATE

**LoRAs (413MB):**
- flux_portrait_enhancer.safetensors (165MB) - DUPLICATE
- flux_realism_lora.safetensors (22MB) - DUPLICATE
- lora_2300332.safetensors (226MB) - DUPLICATE
- photorealism/xlabs_realism.safetensors - UNIQUE (move to fluxdype)
- technical/hyper_flux_8steps.safetensors - UNIQUE (move to fluxdype)

**Upscalers (757MB):**
- codeformer.pth (360MB) - DUPLICATE
- GFPGANv1.4.pth (333MB) - DUPLICATE
- RealESRGAN_x4plus.pth (64MB) - DUPLICATE

**VAE (480MB):**
- ae.safetensors (320MB) - DUPLICATE
- flux-vae-bf16.safetensors (160MB) - DUPLICATE

**Recommendation:** Archive unique LoRAs, DELETE entire directory after verification (saves 31GB)

---

## 3. D:\jdmal\ComfyUI\models (SECONDARY INSTALLATION - 44GB)

### Overview
- Secondary working ComfyUI installation
- Mix of Flux and SDXL models
- Many duplicates with fluxdype
- Some unique workflow-specific LoRAs

### Key Models

**Checkpoints (12GB):**
- flux1-dev-fp8.safetensors (12GB) - DUPLICATE with fluxdype

**Diffusion Models (24GB):**
- flux1-dev-fp8.safetensors (12GB) - DUPLICATE
- flux1-kontext-dev-fp8.safetensors (12GB) - Same as fluxdype's flux1-dev-kontext_fp8_scaled

**Text Encoders (5.2GB):**
- clip_l.safetensors (235MB) - DUPLICATE
- t5xxl_fp16.safetensors (117MB) - DUPLICATE
- t5xxl_fp8_e4m3fn_scaled.safetensors (4.9GB) - DUPLICATE with fluxdype

**LoRAs (5.5GB):**
- facebookQuality.3t4R.safetensors (293MB) - DUPLICATE (in fluxdype)
- fluxInstaGirlsV2.dbl2.safetensors (38MB) - DUPLICATE (in fluxdype)
- NSFW_UNLOCKED.safetensors (293MB) - DUPLICATE (in fluxdype)
- ultrafluxV1.aWjp.safetensors (152MB) - DUPLICATE (in fluxdype)
- hyper_flux_8steps.safetensors (1.3GB) - UNIQUE to this install
- flux-realism-lora.safetensors (226MB) - Similar to flux_realism_lora
- facebook.safetensors (293MB) - UNIQUE
- fbphoto.safetensors (293MB) - UNIQUE
- fbquality.safetensors (220MB) - UNIQUE
- instagram.safetensors (38MB) - Variant of fluxInstaGirlsV2
- Ins4gr4am_girls.safetensors (38MB) - Variant
- realism.safetensors (293MB) - UNIQUE
- realism_cinema.safetensors (293MB) - UNIQUE
- realistic_breast.safetensors (165MB) - UNIQUE
- SOAP.safetensors (328MB) - UNIQUE
- aidmansfwunlockfluxponystyle.safetensors (19MB) - UNIQUE
- aidmaRealisticPeoplePhotograph.safetensors (19MB) - UNIQUE
- natural.safetensors (19MB) - UNIQUE
- pony.safetensors (19MB) - UNIQUE

**Upscalers (757MB):** Same as ai-workspace (duplicates)

**VAE (480MB):** Same as ai-workspace (duplicates)

**Recommendation:** KEEP as secondary working installation. Contains many unique LoRAs for specific workflows.

---

## 4. D:\jdmal\llama.cpp\models (KEEP IN PLACE - 50MB)

### Vocab Files (17 files)
Small vocabulary files required by llama.cpp for different model architectures:
- ggml-vocab-aquila.gguf (4.7MB)
- ggml-vocab-command-r.gguf (11MB)
- ggml-vocab-llama-bpe.gguf (7.5MB)
- ggml-vocab-qwen2.gguf (5.7MB)
- + 13 more vocab files

**Modified:** October 11, 2024

**Recommendation:** KEEP in place - required by llama.cpp installation

---

## 5. D:\models (LLM MODELS - KEEP IN PLACE - 139GB)

### Organized GGUF Models

**D:\models\organized\ (9 models, 107GB):**
- cognitivecomputations_Dolphin-Mistral-24B-Venice-Edition-Q4_K_M.gguf (14GB)
- DeepSeek-R1-Distill-Qwen-14B-Q5_K_M.gguf (9.8GB)
- Dolphin3.0-Llama3.1-8B-Q6_K.gguf (6.2GB)
- Llama-3.3-70B-Instruct-abliterated-IQ2_S.gguf (21GB)
- microsoft_Phi-4-reasoning-plus-Q6_K.gguf (12GB)
- Ministral-3-14B-Reasoning-2512-Q5_K_M.gguf (9.0GB)
- mlabonne_gemma-3-27b-it-abliterated-Q2_K.gguf (9.8GB)
- Qwen3-Coder-30B-A3B-Instruct-Q4_K_M.gguf (18GB)
- Wizard-Vicuna-13B-Uncensored-Q4_0.gguf (6.9GB)

**D:\models\rtx4060ti-16gb\ (4 models, 28GB):**
- Dolphin3.0-Llama3.1-8B-Q6_K.gguf (6.2GB) - DUPLICATE
- Meta-Llama-3.1-8B-Instruct-Q6_K.gguf (6.2GB)
- Qwen2.5-14B-Instruct-Q4_K_M.gguf (8.4GB)
- Qwen2.5-14B_Uncensored_Instruct-Q4_K_M.gguf (8.4GB)
- qwen2.5-coder-7b-instruct-q5_k_m.gguf (5.1GB)

**Modified:** December 7-8, 2025

**Recommendation:** KEEP in place - well-organized LLM collection for text generation

---

## 6. D:\Optimum\stable-diffusion-webui (ACTIVE SDXL - KEEP - 182GB)

### Overview
Active Stable Diffusion WebUI installation focused on SDXL models. This is a separate working installation and should be preserved.

### Key Models

**Stable-diffusion Checkpoints (74GB):**
- bigLust_v16.safetensors (6.5GB) - SDXL NSFW model
- eventHorizonXL_v30.safetensors (6.7GB) - SDXL artistic model
- fluxedUpFluxNSFW_60FP16_2250122.safetensors (23GB) - Flux NSFW FP16
- iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors (12GB) - Flux mix
- iniverseMixSFWNSFW_guofengXLV15.safetensors (6.7GB) - SDXL mix
- JuggernautXL_v9_PRUNED_FP16.safetensors (6.7GB) - SDXL popular model
- Realism_BSY_XL_V8_PRO_DMD2_C48.safetensors (6.5GB) - SDXL realism
- realismSDXLByStable_v80FP16_2231467.safetensors (6.5GB) - SDXL realism

**ControlNet (7.2GB):**
- control_xl_canny.safetensors (2.4GB)
- control_xl_depth.safetensors (2.4GB)
- control_xl_tile_realistic.safetensors (2.4GB)

**LoRAs (3.3GB):**
- facebookQuality.3t4R.safetensors (293MB)
- fluxInstaGirlsV2.dbl2.safetensors (38MB)
- ultrafluxV1.aWjp.safetensors (152MB)
- FluXXXv2.safetensors (136MB)
- KREAnsfwv2.safetensors (131MB)
- NSFW_UNLOCKED.safetensors (293MB)
- Ana_V1.safetensors (293MB)
- dmd2_sdxl_4step_lora.safetensors (751MB)
- Realism Lora variants (650MB, 43MB)
- + more specialized LoRAs

**Embeddings (5.4MB):**
- BSY_* series (6 embeddings for anatomy/realism/general)
- Stable_Yogis_* series (4 embeddings)
- EasyNegative.safetensors (25KB)
- bad_prompt_version2.pt (208KB)
- + 5 more embeddings

**Upscalers (192MB):**
- 4x_NickelbackFS_72000_G.pth (64MB) - DUPLICATE (in Downloads)
- 4x-UltraSharp.pth (64MB)
- RealESRGAN_x4plus.pth (64MB) - DUPLICATE

**Temp Folders:**
- D:\Optimum\bsy_fp16\Realism_BSY_XL_V8_PRO_FP16_C47.safetensors (6.5GB) - DUPLICATE of checkpoint
- D:\Optimum\lora_temp\ (2.5GB) - Various LoRAs, mostly duplicates

**Modified:** October-November 2024

**Recommendation:** KEEP entire installation - active SDXL workflow with unique models

---

## 7. Recycle Bin (OLD DELETED FILES)

### C:\$Recycle.Bin
- 2 .pth files (likely old upscalers)

### D:\$RECYCLE.BIN
- 6 .safetensors files (3 originals + 3 recycle metadata)

**Recommendation:** Empty recycle bin to free space (likely ~500MB-1GB)

---

## Categorized Summary

### MOVE TO FLUXDYPE (Total: ~1.4GB)
**From C:\Users\Jdmal\Downloads:**
1. 4x_NickelbackFS_72000_G.pth (64MB) - upscale_models/
2. cyberrealisticNegative.DW8L.safetensors (569KB) - embeddings/
3. CyberRealistic_Negative_PONY_V2-neg.safetensors (569KB) - embeddings/
4. Facebookq-fotos.safetensors (220MB) - loras/
5. Facebook_Quality_Photos.safetensors (293MB) - loras/
6. ponyChar4ByStableYogi.uIsD.safetensors (55MB) - loras/
7. realism20lora20by.cpW5.safetensors (650MB) - loras/
8. realismLoraByStable.VvFC.safetensors (43MB) - loras/
9. Realism_Lora_By_Stable_yogi_SDXL8.1.safetensors (43MB) - loras/
10. superEyeDetailerBy.4EGS.safetensors (55MB) - loras/

**From D:\ai-workspace\ComfyUI\models:**
11. loras/photorealism/xlabs_realism.safetensors
12. loras/technical/hyper_flux_8steps.safetensors

### DUPLICATES (Keep secondary copies, no action needed)
**In D:\jdmal\ComfyUI\models\loras:**
- facebookQuality.3t4R.safetensors (also in fluxdype)
- fluxInstaGirlsV2.dbl2.safetensors (also in fluxdype)
- NSFW_UNLOCKED.safetensors (also in fluxdype)
- ultrafluxV1.aWjp.safetensors (also in fluxdype)

**In D:\Optimum:**
- Multiple duplicates with D:\jdmal\ComfyUI (different workflows, keep both)

### KEEP IN PLACE (No action)
**D:\jdmal\ComfyUI\models** (44GB):
- Secondary working ComfyUI installation
- Contains unique LoRAs not in fluxdype
- Used for different workflows

**D:\jdmal\llama.cpp\models** (50MB):
- Required vocab files for llama.cpp

**D:\models** (139GB):
- Well-organized LLM model collection
- Used for text generation, not image generation

**D:\Optimum\stable-diffusion-webui** (182GB):
- Active SDXL installation
- Separate workflow from Flux-based fluxdype
- Contains unique SDXL checkpoints and ControlNets

### DELETE/ARCHIVE (Space savings: ~32GB)
**D:\ai-workspace\ComfyUI** (31GB):
- Old abandoned installation
- All unique files moved to fluxdype
- DELETE entire directory after verification

**D:\Optimum\bsy_fp16** (6.5GB):
- Realism_BSY_XL_V8_PRO_FP16_C47.safetensors
- DUPLICATE of model in stable-diffusion\models\Stable-diffusion\
- DELETE after verification

**D:\Optimum\lora_temp** (2.5GB):
- Temp download folder with duplicates
- Most files already in stable-diffusion\models\LoRA\
- DELETE after verification

**Recycle Bin** (~1GB):
- Empty both C: and D: recycle bins

---

## Space Analysis

### Current Distribution
```
D:\workspace\fluxdype\ComfyUI\models:  ~15GB (main installation)
D:\jdmal\ComfyUI\models:               44GB (secondary working)
D:\ai-workspace\ComfyUI\models:        31GB (OLD - DELETE)
D:\models:                            139GB (LLMs - KEEP)
D:\Optimum\stable-diffusion-webui:    182GB (SDXL - KEEP)
Downloads + temp folders:              ~10GB (MOVE/DELETE)
---------------------------------------------------------------
Total:                                ~421GB
```

### After Consolidation
```
D:\workspace\fluxdype\ComfyUI\models:  ~16.4GB (+1.4GB moved)
D:\jdmal\ComfyUI\models:               44GB (keep)
D:\models:                            139GB (keep)
D:\Optimum\stable-diffusion-webui:    173GB (-9GB cleaned temp)
Downloads:                             0GB (cleared)
Recycle Bin:                           0GB (emptied)
---------------------------------------------------------------
Total:                                ~372GB (-49GB freed)
```

---

## Recommended Actions

### Immediate (Run consolidation script)
1. **Run:** `D:\workspace\fluxdype\consolidate_scattered_models.ps1`
   - Moves 10 models from Downloads to fluxdype (~1.4GB)
   - Archives unique models from ai-workspace
   - Documents duplicates

2. **Test ComfyUI:**
   ```powershell
   cd D:\workspace\fluxdype
   .\start-comfy.ps1
   ```
   - Verify new models load correctly
   - Check web UI at http://localhost:8188

3. **Empty Recycle Bin**
   - C:\$Recycle.Bin
   - D:\$RECYCLE.BIN
   - Frees ~1GB

### Short-term (After verification)
4. **Delete ai-workspace installation:**
   ```powershell
   Remove-Item -Recurse -Force "D:\ai-workspace\ComfyUI"
   ```
   - Saves 31GB
   - All unique models already moved

5. **Clean Optimum temp folders:**
   ```powershell
   Remove-Item "D:\Optimum\bsy_fp16\*.safetensors"
   Remove-Item -Recurse "D:\Optimum\lora_temp"
   ```
   - Saves 9GB
   - Duplicates of existing models

### Long-term (Organization)
6. **Consider consolidating D:\jdmal\ComfyUI into fluxdype**
   - Move unique LoRAs to fluxdype
   - Would save 44GB by eliminating duplicate installation
   - Keep only if actively using different workflows

7. **Standardize on fluxdype as primary ComfyUI installation**
   - All new models go to D:\workspace\fluxdype\ComfyUI\models\
   - Maintain D:\Optimum for SDXL-specific work

---

## Files Generated

1. **D:\workspace\fluxdype\consolidate_scattered_models.ps1**
   - Automated consolidation script
   - Moves Downloads models to fluxdype
   - Archives ai-workspace unique models
   - Safe operation (no deletions)

2. **D:\workspace\fluxdype\SCATTERED_MODELS_AUDIT.md**
   - This comprehensive audit report
   - Full inventory and recommendations

---

## Conclusion

Found **150+ AI model files** scattered across **5 major installations** totaling **~421GB**.

**Key Findings:**
- **1.4GB** in Downloads folder ready to move
- **31GB** in abandoned ai-workspace installation (can delete)
- **44GB** in secondary jdmal\ComfyUI (keep for now)
- **182GB** in active Optimum\stable-diffusion-webui (keep)
- **139GB** in organized LLM models (keep)
- **~9GB** in temp/duplicate folders (can delete)

**Space Savings Potential:** Up to **49GB** through cleanup and consolidation.

**Next Step:** Run `.\consolidate_scattered_models.ps1` from `D:\workspace\fluxdype\`
