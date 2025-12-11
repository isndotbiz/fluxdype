# Ultimate Guide: Ultra-Realistic Photorealistic Images with Flux in ComfyUI (2025)

**Last Updated**: December 2025
**Target GPU**: NVIDIA RTX 3090 (24GB VRAM)
**Focus**: Production-grade photorealistic image generation

---

## Table of Contents

1. [Model Selection](#model-selection)
2. [Optimal Settings](#optimal-settings)
3. [Essential LoRAs for Realism](#essential-loras-for-realism)
4. [VAE and Text Encoder Configuration](#vae-and-text-encoder-configuration)
5. [Post-Processing Techniques](#post-processing-techniques)
6. [RTX 3090 Optimization](#rtx-3090-optimization)
7. [Resolution and Aspect Ratios](#resolution-and-aspect-ratios)
8. [Prompting Best Practices](#prompting-best-practices)
9. [Essential Custom Nodes](#essential-custom-nodes)
10. [Complete Workflow Recommendations](#complete-workflow-recommendations)

---

## Model Selection

### Best Flux Models for Photorealism (Ranked)

#### 1. FLUX.1 Krea [dev] - RECOMMENDED FOR NATURAL PHOTOREALISM
- **Best For**: Breaking the "AI look" with natural, unsaturated photorealism
- **Strengths**:
  - Most natural aesthetic, avoiding oversaturated 'AI look'
  - Trained for realistic, diverse images without excessive sharpening
  - Best overall aesthetics with natural color tones
  - Noticeably more natural than FLUX.1 Dev
- **Use Case**: Portraits, lifestyle photography, documentary-style images
- **Download**: HuggingFace - black-forest-labs/FLUX.1-krea-dev

#### 2. FLUX 1.1 Pro - BEST FOR HIGH-END PRODUCTION
- **Best For**: Professional, high-end production work requiring maximum detail
- **Strengths**:
  - Unparalleled image quality and detail clarity
  - Exceptional text rendering
  - Precise hand anatomy and intricate shadowing
  - Rich color depth and seamless gradient transitions
  - Handles light beams and sunlight filtering exceptionally well
- **Trade-off**: Sometimes produces overly polished effects with high saturation
- **Use Case**: Commercial photography, advertising, fashion
- **Note**: API-only, requires subscription

#### 3. FLUX.2 Dev - NEXT-GENERATION 4MP OUTPUT
- **Best For**: Cutting-edge photorealism with 4MP resolution
- **Strengths**:
  - Up to 4MP (2048x2048) photorealistic output
  - Improved lighting, skin, fabric, and hand detail
  - Better editing precision and visual understanding
  - Professional-class text rendering
  - 40% faster with FP8 quantization
- **Use Case**: High-resolution professional work, commercial projects
- **Download**: HuggingFace - black-forest-labs/FLUX.2-dev (FP8 recommended)

#### 4. FLUX.1 Dev - SOLID BASELINE
- **Best For**: Non-commercial projects, experimentation
- **Strengths**:
  - Open weights, free to use
  - Good balance of performance and quality
  - Clean text rendering, reasonable hand accuracy
- **Weaknesses**:
  - Can appear artificial and flat
  - Excessive sharpening leading to distortion
  - Overly high color saturation
- **Use Case**: Personal projects, learning, development
- **Download**: HuggingFace - black-forest-labs/FLUX.1-dev

### Model Comparison Summary

| Model | Photorealism | Detail | Natural Look | Speed | VRAM (FP8) | Best For |
|-------|-------------|---------|--------------|-------|-----------|----------|
| **FLUX.1 Krea** | 9/10 | 8/10 | 10/10 | Normal | ~12GB | Natural portraits |
| **FLUX 1.1 Pro** | 10/10 | 10/10 | 7/10 | Fast | API | Professional work |
| **FLUX.2 Dev** | 10/10 | 9/10 | 8/10 | Fast | ~14GB | 4MP high-res |
| **FLUX.1 Dev** | 6/10 | 7/10 | 5/10 | Normal | ~12GB | Learning/Dev |

---

## Optimal Settings

### For FLUX.1 Krea [dev] and FLUX.2 Dev

**RECOMMENDED SETTINGS FOR PHOTOREALISM:**

```
Model: flux1-krea-dev-fp8.safetensors (or flux2-dev-fp8.safetensors)
Sampler: Euler
Scheduler: Beta (default) or Simple
CFG (Guidance Scale): 2.0
Steps: 40-60
Resolution: 1024x1024 to 1920x1080 (for Krea/1.x), up to 2048x2048 (for 2.0)
Denoise: 1.0 (for txt2img)
Seed: -1 (random) or fixed for consistency
```

**Key Insights**:
- **CFG 2.0** produces more natural-looking images with better contrast balance
- Higher steps (40-60) at CFG 2.0 deliver very good results
- CFG 3.5 only if you need stronger prompt adherence (especially for text)
- Balance CFG with steps: lower CFG = higher steps for quality

### For FLUX 1.1 Pro (API)

```
Steps: 20-30 (faster generation)
Guidance: 2.5-3.5
Resolution: Up to 4MP (2048x2048)
Mode: "Ultra" for 4x higher resolution
```

### For FLUX.1 Dev

```
Sampler: DPM++ 2M (fixes blurred images) or Euler
Scheduler: sgm_uniform (with DPM++) or Beta (with Euler)
CFG: 2.0-3.5
Steps: 30-50
```

### Alternative Sampler Configurations

| Sampler | Scheduler | CFG | Steps | Best For |
|---------|-----------|-----|-------|----------|
| Euler | Simple | 1.0 | 20-30 | Schnell version |
| Euler | Beta | 2.0 | 40-60 | Natural realism |
| Flux Realistic | Beta | 2.0-3.5 | 30-50 | Enhanced details |
| DPM++ 2M | sgm_uniform | 2.0 | 30-40 | Fixing blur issues |
| DetailDaemon | Beta | 2.0 | 40-60 | Maximum detail |

---

## Essential LoRAs for Realism

### Top Photorealistic LoRAs (2025)

#### 1. **FLUX UltraRealistic LoRA V2** - HIGHLY RECOMMENDED
- **Source**: HuggingFace - prithivMLmods/Canopus-LoRA-Flux-UltraRealism-2.0
- **Strengths**:
  - Enhanced stability and improved anatomy
  - Refined hands and body anatomy
  - Flexible quality control
  - V2 brings significantly more realism and versatility
- **Trigger**: "Ultra realistic" (optional with descriptive prompts)
- **Weight**: 0.6-1.0
- **Best Sampler**: dpmpp_2m

#### 2. **FLUX-RealismLoRA (XLabs AI)**
- **Source**: HuggingFace - XLabs-AI/flux-RealismLora
- **Strengths**:
  - Trained on curated high-resolution photographs
  - Eliminates need for quality tokens ("8k ultra HD photorealistic")
  - Exceptional detail, texture, and photorealism
  - Wide range of ultra-realistic image types
- **Weight**: 0.7-1.0
- **Use Case**: General photorealism without prompt bloat

#### 3. **Flux Super Realism LoRA**
- **Source**: HuggingFace - strangerzonehf/Flux-Super-Realism-LoRA
- **Strengths**:
  - Superior face realism
  - Better overall ultra-realism than previous versions
- **Trigger**: "Super Realism" (optional if "realistic" in prompt)
- **Weight**: 0.8-1.0

#### 4. **RealSkin Flux Enhancer**
- **Source**: OpenArt workflow
- **Strengths**:
  - Specialized for skin texture enhancement
  - Improves faces and full-body skin realism
  - Addresses overly smooth Flux outputs
- **Use Case**: Portrait and fashion photography
- **Weight**: 0.5-0.8

### LoRA Stacking Strategy

For maximum photorealism, stack multiple LoRAs:

```
Base Model: FLUX.1 Krea [dev] (FP8)
LoRA 1: FLUX-RealismLoRA (weight: 0.8)
LoRA 2: UltraRealistic LoRA V2 (weight: 0.7)
LoRA 3: RealSkin Enhancer (weight: 0.6)
```

**Note**: Watch VRAM usage when stacking multiple LoRAs. RTX 3090 can handle 2-3 LoRAs comfortably with FP8 models.

### Additional Enhancement LoRAs

- **Skin Details**: Find specialized LoRAs for skin pore detail
- **Hand Fixes**: LoRAs specifically trained for hand anatomy
- **Eye Fixes**: Enhanced eye detail and reflection
- **Post Effects**: Layering LoRAs for color grading and lighting

---

## VAE and Text Encoder Configuration

### Required Components for Flux

Flux models require three encoder components:

1. **ae.safetensors** - VAE (Autoencoder)
2. **clip_l.safetensors** - CLIP text encoder (openai/clip-vit-large-patch14)
3. **t5xxl_fp16.safetensors** or **t5xxl_fp8_e4m3fn.safetensors** - T5 text encoder (google/t5-v1_1-xxl)

### VAE Settings

```
VAE Model: ae.safetensors (FLUX default VAE)
Precision: Full precision (no half-VAE)
```

**Important**: Keep VAE in full precision for photorealistic work. Use `--no-half-vae` flag when launching ComfyUI.

### Text Encoder Configuration

#### T5XXL - Main Text Understanding

**FP16 vs FP8 Comparison:**

| Version | VRAM | Quality | Speed | Recommendation |
|---------|------|---------|-------|----------------|
| t5xxl_fp16.safetensors | ~19GB | Best | Slower | RTX 3090 (if space permits) |
| t5xxl_fp8_e4m3fn.safetensors | ~10GB | Excellent | Faster | **RECOMMENDED for RTX 3090** |

**Download**: HuggingFace - comfyanonymous/flux_text_encoders

**Key Insight**: T5XXL can follow detailed descriptions and instructions, unlike CLIP which favors keywords.

#### CLIP-L - Keyword Understanding

```
Model: clip_l.safetensors
Use: Keyword-style prompts
```

### Advanced Prompting Strategy

**Dual-Encoder Prompting** (for advanced users):

- **CLIP Prompt**: Short keywords (e.g., "portrait, natural light, bokeh")
- **T5 Prompt**: Detailed sentences (e.g., "A photorealistic portrait of a woman in her 30s with natural makeup, soft window light illuminating her face from the left, shallow depth of field with creamy bokeh")

**Simple Method** (recommended): Feed the same detailed prompt to both encoders for convenience.

### ComfyUI Launch Flags for Text Encoders

```powershell
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --fp16-unet --bf16-vae --no-half-vae --fp8-e4m3fn-text-enc
```

---

## Post-Processing Techniques

### DetailDaemon - ESSENTIAL FOR PHOTOREALISM

**GitHub**: Jonseed/ComfyUI-Detail-Daemon

**What It Does**: Adjusts sigmas (noise levels) during generation to enhance details and remove unwanted bokeh/background blurring.

#### DetailDaemon Settings for Flux

```
Node: Detail Daemon Sampler
detail_amount: 0.1-1.0 (for Flux), higher for more detail
sampler_name: euler or dpmpp_2m
scheduler: beta
steps: 40-60
cfg: 2.0
```

**Warning**: Values too high result in oversharpened/HDR effect. Start with 0.3 and adjust.

#### Recommended Workflow Position

```
Text Encode (CLIP + T5) →
Load LoRAs →
Detail Daemon Sampler →
VAE Decode →
Post-Processing Nodes
```

### ComfyUI-post-processing-nodes

**GitHub**: EllangoK/ComfyUI-post-processing-nodes

Essential nodes for final image enhancement:

#### Key Nodes for Photorealism

1. **Sharpen Node**
   - Enhances details by applying sharpening filter
   - Makes edges and textures more pronounced
   - Settings: sharpen_radius: 1.0-2.0, sharpen_sigma: 1.0, sharpen_alpha: 1.0-3.0

2. **ColorCorrect Node**
   - Fine-tune color balance, saturation, brightness
   - Essential for natural color grading
   - Settings: temperature: -0.1 to 0.1, tint: -0.1 to 0.1, saturation: 0.9-1.1

3. **Vignette Node**
   - Adds subtle vignetting for professional look
   - Settings: vignette_intensity: 0.2-0.5

4. **Film Grain Node**
   - Adds subtle grain for natural photography feel
   - Settings: grain_amount: 0.01-0.05, grain_size: 1-2

### Post-Processing Workflow Chain

```
VAE Decode →
Detail Daemon (if not used in generation) →
Color Correct (temperature, tint, saturation) →
Sharpen (subtle, sharpen_alpha: 1.5-2.0) →
Film Grain (grain_amount: 0.02) →
Vignette (intensity: 0.3) →
Save Image
```

---

## RTX 3090 Optimization

### Hardware Specifications

- **VRAM**: 24GB GDDR6X
- **CUDA Cores**: 10496
- **Tensor Cores**: 328 (3rd Gen)
- **Memory Bandwidth**: 936.2 GB/s
- **Recommended for**: FLUX.1 Dev research, FP8 models

### FP8 Quantization - PRIMARY OPTIMIZATION

**Why FP8?**
- Reduces VRAM usage by 40% (from ~23GB to ~14GB)
- Maintains comparable quality to FP16
- Essential for RTX 3090 to run Flux models comfortably
- Enables multi-LoRA workflows

**Performance Impact**:
- FLUX Dev FP16: ~23GB VRAM (barely fits on 3090)
- FLUX Dev FP8: ~14GB VRAM (comfortable fit with headroom)
- Speed improvement: ~40% faster generation

**Recommended Models for RTX 3090**:
```
flux1-krea-dev-fp8.safetensors (~12GB loaded)
flux2-dev-fp8.safetensors (~14GB loaded)
t5xxl_fp8_e4m3fn.safetensors (~10GB loaded)
```

### ComfyUI Launch Command for RTX 3090

**Optimized Start Command**:

```powershell
cd D:\workspace\fluxdype\ComfyUI
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --normalvram --precision bf16 --fp8-e4m3fn-text-enc --force-fp16 --use-sage-attention
```

**Flag Breakdown**:

| Flag | Purpose | Impact |
|------|---------|--------|
| `--normalvram` | Standard VRAM mode for 16-24GB cards | Recommended for 3090 |
| `--precision bf16` | BF16 precision for compute | Quality + speed balance |
| `--fp8-e4m3fn-text-enc` | FP8 text encoders | 40% VRAM reduction |
| `--force-fp16` | Force FP16 where possible | Memory efficiency |
| `--use-sage-attention` | Memory-efficient attention | Lower peak VRAM usage |
| `--disable-auto-launch` | Headless operation | Server mode |

### Alternative Launch Modes

**High-Performance Mode** (if only using 1 LoRA):
```powershell
python main.py --gpu-only --precision bf16 --fp8-e4m3fn-text-enc
```

**Memory-Constrained Mode** (for stacking many LoRAs):
```powershell
python main.py --lowvram --precision bf16 --fp8-e4m3fn-text-enc
```

### VRAM Management Best Practices

1. **Empty Cache Regularly**
   - Add `torch.cuda.empty_cache()` before generation
   - Or restart ComfyUI every 10-15 generations
   - Prevents VRAM fragmentation

2. **Monitor VRAM Usage**
   ```powershell
   # Check VRAM usage
   nvidia-smi
   ```

3. **Batch Size Optimization**
   - Batch size: 1 for 2048x2048 images
   - Batch size: 2-4 for 1024x1024 images

4. **Model Offloading**
   - Use `--lowvram` flag to offload models to RAM when not in use
   - Slower but enables more complex workflows

### CUDA Optimization

**Ensure CUDA 12.1+ with PyTorch 2.0+**:

```powershell
cd D:\workspace\fluxdype
.\venv\Scripts\Activate.ps1
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA: {torch.version.cuda}'); print(f'cuDNN: {torch.backends.cudnn.version()}')"
```

**Expected Output**:
```
PyTorch: 2.1.0+cu121
CUDA: 12.1
cuDNN: 8902
```

### Platform-Specific Notes

**Windows (Your Setup)**:
- FP16 works well on Windows with RTX 3090
- FP8 recommended for multi-LoRA workflows
- Use PowerShell scripts for launching

**Ubuntu/Linux**:
- Flux Dev may require FP8 only (FP16 issues reported)
- Better VRAM management on Linux
- Consider dual-boot for production work

### Troubleshooting OOM (Out of Memory)

If you encounter "CUDA out of memory" errors:

1. **Switch to FP8 models** (primary solution)
2. **Use `--lowvram` flag**
3. **Reduce resolution** (1024x1024 instead of 1920x1080)
4. **Reduce LoRA count** (max 2 LoRAs)
5. **Restart ComfyUI** (clear fragmented VRAM)
6. **Close other GPU applications** (browsers, games)

---

## Resolution and Aspect Ratios

### FLUX Model Resolution Capabilities

| Model | Max Native | Recommended | Minimum | Upscale Capable |
|-------|-----------|-------------|---------|-----------------|
| FLUX.1 Krea | 1.6MP | 1024x1024 to 1920x1080 | 512x512 | Yes |
| FLUX.1 Dev | 1.6MP | 1024x1024 to 1536x1536 | 512x512 | Yes |
| FLUX.2 Dev | 4MP | 2048x2048 | 512x512 | Yes |
| FLUX 1.1 Pro | 4MP | 2048x2048 | 1024x1024 | Yes |

### Optimal Resolution Settings for Photorealism

#### Standard Resolutions (FLUX.1 Krea/Dev)

**Portrait**:
```
768x1024   (3:4 aspect ratio)
832x1216   (2:3 aspect ratio, Instagram-friendly)
1024x1536  (2:3 high-res)
```

**Landscape**:
```
1024x768   (4:3 aspect ratio)
1216x832   (3:2 aspect ratio)
1920x1080  (16:9, cinematic)
```

**Square**:
```
1024x1024  (1:1, ideal for training/consistency)
```

#### High-Resolution (FLUX.2/1.1 Pro)

```
2048x2048  (1:1, maximum quality)
2048x1536  (4:3 landscape)
1536x2048  (3:4 portrait)
2560x1440  (16:9 wide, via upscaling)
```

### Resolution Best Practices

**For FLUX.1 Krea/Dev**:
- **Stick to 1920x1080 or lower** to avoid white halos
- Images above 2MP can show artifacts
- Divisibility by 32 or 64 recommended
- **30+ steps minimum** for clean results (avoid grid patterns)

**For FLUX.2 Dev**:
- Native 4MP support (2048x2048)
- Cleaner at higher resolutions than FLUX.1
- Better detail preservation at scale

**For Upscaling Workflow**:
- Generate at 1024x1024 for speed
- Upscale to 4096x4096 using Ultimate SD Upscale
- Best quality/time ratio

### Aspect Ratio Recommendations

**Photography Standards**:
- **1:1** (Square): Social media, consistent training
- **3:2** (1.5:1): Classic photography ratio (DSLR standard)
- **4:3** (1.33:1): Medium format, versatile
- **16:9** (1.78:1): Cinematic, widescreen
- **2:3** (0.67:1): Portrait photography, Instagram stories
- **9:16** (0.56:1): Vertical video format

**Computational Cost**:
- **1:1** (1024x1024): Baseline (1.0x)
- **3:2** (1216x832): ~1.0x (same pixel count)
- **16:9** (1920x1080): ~2.0x (double pixel count)
- **21:9** (2560x1080): ~2.5x (ultra-wide requires more power)

---

## Prompting Best Practices

### Prompt Structure for Photorealism

**Optimal Prompt Format**:

```
[SUBJECT] + [ENVIRONMENT/SETTING] + [LIGHTING] + [CAMERA/TECHNICAL] + [STYLE/MOOD] + [QUALITY TERMS]
```

**Example Prompt**:
```
A portrait of a woman in her early 30s with natural wavy brown hair and subtle makeup, standing in a sunlit apartment with large windows, soft golden hour light illuminating her face from the left side creating gentle shadows, shot with a 85mm lens at f/1.8 with creamy bokeh background, shallow depth of field, warm color grading, photorealistic, natural skin texture, film photography aesthetic
```

### Photography-Specific Terminology

**Lighting Terms**:
- "natural light", "golden hour", "soft window light"
- "rim lighting", "backlit", "side lighting"
- "overcast daylight", "studio lighting", "diffused light"
- "harsh shadows", "gentle shadows", "dramatic lighting"

**Camera/Lens Terms**:
- "85mm portrait lens", "50mm f/1.4", "35mm wide angle"
- "shallow depth of field", "bokeh", "f/1.8 aperture"
- "tack sharp focus", "soft focus background"
- "shot on Fujifilm", "Canon 5D Mark IV", "Hasselblad"

**Skin/Texture Terms**:
- "natural skin texture", "visible skin pores", "skin detail"
- "subtle freckles", "fine lines", "realistic skin"
- "fabric texture", "material detail", "surface imperfections"

**Mood/Style Terms**:
- "cinematic", "editorial photography", "fashion photography"
- "documentary style", "candid moment", "lifestyle photography"
- "warm color grading", "muted tones", "high contrast"
- "film grain", "analog photography aesthetic"

### Quality Terms Strategy

**With FLUX-RealismLoRA**: Skip quality tokens entirely
```
# AVOID this with RealismLoRA:
"8k, ultra HD, photorealistic, masterpiece, best quality, RAW photo"

# Instead, use descriptive photography terms:
"photorealistic, natural skin texture, shot on film"
```

**Without RealismLoRA**: Add selective quality terms
```
"photorealistic, high detail, sharp focus, professional photography, natural lighting"
```

**Important**: Quality tags can "overwhelm subject description" - focus on describing the scene, not declaring quality.

### Negative Prompts for Photorealism

**Essential Negative Prompt Template**:

```
worst quality, low quality, normal quality, low res, blurry, jpeg artifacts, grainy, bad anatomy, poorly drawn hands, extra limbs, missing limbs, fused fingers, poorly drawn face, fused face, cloned face, extra eyes, oversized eyes, bad photography, bad photo, aberrations, black and white, collapsed, conjoined, creative, drawing, harsh lighting, low saturation, monochrome, multiple levels, overexposed, oversaturated, photoshop, rotten, surreal, twisted, underexposed, unnatural, unrealistic, video game, 3d render, cartoon, anime, artificial, plastic skin, doll-like, overly smooth skin
```

**Portrait-Specific Negative Prompts**:
```
young appearance (if targeting mature subject), long hair (if short hair desired), accessories, hats, glasses (unless wanted), multiple people (for solo portrait), indoor setting (for outdoor), harsh lighting, blurry focus
```

**Skin/Anatomy Negative Prompts**:
```
plastic skin, overly smooth skin, airbrushed, fake skin, porcelain skin, doll-like skin, bad hands, mutated hands, poorly drawn hands, fused fingers, extra fingers, missing fingers, bad anatomy, poorly drawn body
```

### JSON Prompting (FLUX.2)

FLUX.2 supports structured JSON prompting for better control:

```json
{
  "subject": "A woman in her 30s with natural wavy brown hair",
  "environment": "sunlit apartment with large windows",
  "lighting": "soft golden hour light from the left",
  "camera": "85mm lens, f/1.8, shallow depth of field",
  "style": "photorealistic, film photography aesthetic",
  "quality": "8k, high detail, sharp focus",
  "negative_prompt": "blurry, low quality, artificial"
}
```

This separates quality parameters from subject description for better prompt adherence.

### Prompt Length and Detail

**T5XXL Advantage**: Can handle long, detailed prompts (up to 512 tokens)

**Optimal Length**: 50-150 words for detailed scenes

**Example - Short vs Long**:

**Short** (less effective):
```
beautiful woman portrait, natural light, photorealistic
```

**Long** (more effective):
```
A photorealistic portrait of a woman in her early 30s with shoulder-length auburn hair and hazel eyes, wearing a simple cream-colored linen shirt, standing near a large window in a minimalist apartment, bathed in soft afternoon sunlight that creates a gentle glow on her face, shot with an 85mm f/1.4 lens creating a shallow depth of field with a creamy bokeh background, natural skin texture with subtle freckles visible, warm color grading with slightly muted tones, editorial photography style
```

---

## Essential Custom Nodes

### ComfyUI Manager Installation

```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
# Restart ComfyUI server
```

### Must-Have Custom Nodes for Photorealism

#### 1. ComfyUI-Detail-Daemon
```
GitHub: Jonseed/ComfyUI-Detail-Daemon
Purpose: Enhance details, remove unwanted blur
Install: Via ComfyUI Manager or git clone
```

#### 2. ComfyUI-post-processing-nodes
```
GitHub: EllangoK/ComfyUI-post-processing-nodes
Purpose: Sharpen, color correction, vignette, film grain
Install: Via ComfyUI Manager or git clone
```

#### 3. ComfyUI-GGUF
```
Purpose: Load GGUF quantized models for lower VRAM
Install: Via ComfyUI Manager
Use Case: Alternative to FP8 for extreme VRAM saving
```

#### 4. ComfyUI-FluxRegionAttention
```
Purpose: Region-specific attention control in Flux
Install: Via ComfyUI Manager
Use Case: Control different areas of image independently
```

#### 5. ControlAltAI-Nodes
```
GitHub: gseth/ControlAltAI-Nodes
Purpose: Quality of life nodes including Flux Resolution Calc
Install: Via ComfyUI Manager or git clone
```

#### 6. ComfyUI-portrait-master
```
GitHub: florestefano1975/comfyui-portrait-master
Purpose: Generate detailed portrait prompts
Modules: Base Character, Skin Details, Style & Pose, Make-up
Install: Via ComfyUI Manager or git clone
```

#### 7. Ultimate SD Upscale
```
Purpose: Tiled upscaling for high-resolution outputs
Install: Built-in or via ComfyUI Manager
Use Case: Upscale 1024x1024 to 4096x4096
```

#### 8. BilboX's PromptGeek Photo Prompt
```
Purpose: Convenient photorealistic prompt composition
Install: Via ComfyUI Manager
Use Case: Quick photorealistic prompt building
```

### Installation Commands

```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes

# Detail Daemon
git clone https://github.com/Jonseed/ComfyUI-Detail-Daemon.git

# Post-processing nodes
git clone https://github.com/EllangoK/ComfyUI-post-processing-nodes.git

# ControlAltAI Nodes
git clone https://github.com/gseth/ControlAltAI-Nodes.git

# Portrait Master
git clone https://github.com/florestefano1975/comfyui-portrait-master.git

# Restart ComfyUI server
```

---

## Complete Workflow Recommendations

### Workflow 1: Basic Photorealistic Portrait (FLUX.1 Krea)

**Recommended for**: Natural portraits, lifestyle photography

```
[Load Checkpoint: flux1-krea-dev-fp8.safetensors]
         ↓
[Load LoRA: FLUX-RealismLoRA, weight: 0.8]
         ↓
[CLIP Text Encode (L): "portrait, natural light, bokeh"]
         ↓
[T5 Text Encode: "A photorealistic portrait of a woman in her 30s..."]
         ↓
[Empty Latent Image: 832x1216]
         ↓
[KSampler: euler, beta, steps: 50, cfg: 2.0]
         ↓
[VAE Decode]
         ↓
[Save Image]
```

**Settings**:
- Resolution: 832x1216 (2:3 portrait)
- CFG: 2.0
- Steps: 50
- Sampler: euler
- Scheduler: beta

**Expected VRAM**: ~13-15GB

### Workflow 2: Ultra-Detailed Portrait (FLUX.2 + Multi-LoRA)

**Recommended for**: Professional portraits, commercial work

```
[Load Checkpoint: flux2-dev-fp8.safetensors]
         ↓
[Load LoRA: FLUX-RealismLoRA, weight: 0.8]
         ↓
[Load LoRA: UltraRealistic V2, weight: 0.7]
         ↓
[Load LoRA: RealSkin Enhancer, weight: 0.6]
         ↓
[CLIP + T5 Text Encode]
         ↓
[Empty Latent Image: 1024x1024]
         ↓
[Detail Daemon Sampler: euler, beta, steps: 60, cfg: 2.0, detail: 0.4]
         ↓
[VAE Decode]
         ↓
[Color Correct: temp: 0.05, saturation: 1.05]
         ↓
[Sharpen: alpha: 1.8]
         ↓
[Film Grain: amount: 0.02]
         ↓
[Vignette: intensity: 0.3]
         ↓
[Save Image]
```

**Settings**:
- Resolution: 1024x1024 (for speed), upscale later
- CFG: 2.0
- Steps: 60
- Detail Amount: 0.4
- Multiple LoRAs stacked

**Expected VRAM**: ~16-18GB

### Workflow 3: High-Resolution + Upscaling (4K Output)

**Recommended for**: Print-quality, large format, commercial use

```
[Base Generation at 1024x1024]
         ↓ (use Workflow 1 or 2)
[Initial Image Output]
         ↓
[Load Upscale Model: 4x-UltraSharp or RealESRGAN_x4plus]
         ↓
[Ultimate SD Upscale]
   - Tile Size: 512
   - Denoise: 0.30
   - Sampler: euler, steps: 30
   - Upscale by: 4x
         ↓
[Output: 4096x4096]
         ↓
[Post-Processing: Sharpen + Color Correct]
         ↓
[Save Image]
```

**Ultimate SD Upscale Settings**:
```
Upscale Model: 4x-UltraSharp (photorealistic) or 4x-ClearRealityV1
Tile Size: 512 (for 24GB VRAM)
Tile Overlap: 64
Denoise: 0.30 (good starting point)
Steps: 30
CFG: 2.0
Sampler: euler
Scheduler: beta
```

**Expected VRAM**: ~18-22GB (tiling keeps it manageable)

**Speed**: ~5-10 minutes for 4K output on RTX 3090

### Workflow 4: ControlNet Pose + Photorealism

**Recommended for**: Fashion photography, full-body shots, pose control

```
[Load Checkpoint: flux1-krea-dev-fp8.safetensors]
         ↓
[Load ControlNet: FLUX.1-dev-ControlNet-Union-Pro]
         ↓
[Input Pose Image or OpenPose]
         ↓
[ControlNet Preprocessor: OpenPose or DWPose]
         ↓
[Load LoRA: FLUX-RealismLoRA + UltraRealistic V2]
         ↓
[CLIP + T5 Text Encode with fashion/body prompts]
         ↓
[Empty Latent Image: 832x1216 or 1024x1536]
         ↓
[ControlNet Apply with Pose Conditioning]
         ↓
[Detail Daemon Sampler: steps: 50, cfg: 2.5, detail: 0.3]
         ↓
[VAE Decode]
         ↓
[Post-Processing]
         ↓
[Save Image]
```

**Settings**:
- ControlNet Strength: 0.7-0.9
- CFG: 2.5 (slightly higher for pose adherence)
- Steps: 50-60
- Resolution: 832x1216 or 1024x1536 (portrait)

**Use Case**: Creating fashion editorial shots with specific poses

### Workflow 5: Batch Photorealistic Generation

**Recommended for**: Creating multiple variations, dataset generation

```
[Load Checkpoint: flux1-krea-dev-fp8.safetensors]
         ↓
[Load LoRA: FLUX-RealismLoRA]
         ↓
[Portrait Master Node: Set character parameters]
         ↓
[CLIP + T5 Text Encode]
         ↓
[Empty Latent Image: 1024x1024]
         ↓
[KSampler: euler, beta, steps: 40, cfg: 2.0, batch_size: 4]
         ↓
[VAE Decode]
         ↓
[Save Image (batch)]
```

**Settings**:
- Batch Size: 2-4 (depending on VRAM)
- Seed: Random (-1) for variations
- Fixed prompt with variable seeds

**Expected VRAM**: ~20-24GB for batch of 4

---

## Quick Start Checklist

### Initial Setup (One-Time)

- [ ] Install ComfyUI (already done at `D:\workspace\fluxdype\ComfyUI`)
- [ ] Download FLUX.1 Krea FP8 model
- [ ] Download text encoders (t5xxl_fp8, clip_l)
- [ ] Download VAE (ae.safetensors)
- [ ] Install ComfyUI Manager
- [ ] Install custom nodes: Detail-Daemon, post-processing-nodes
- [ ] Download essential LoRAs: RealismLoRA, UltraRealistic V2
- [ ] Download upscale models: 4x-UltraSharp, RealESRGAN_x4plus

### Before Each Session

- [ ] Activate venv: `.\venv\Scripts\Activate.ps1`
- [ ] Start ComfyUI with optimized flags
- [ ] Monitor VRAM: `nvidia-smi` in separate terminal
- [ ] Load workflow template or build from scratch

### Generation Checklist

- [ ] Load FP8 model (flux1-krea-dev-fp8 or flux2-dev-fp8)
- [ ] Load 1-2 LoRAs (max 3 if VRAM permits)
- [ ] Set resolution (1024x1024 or 832x1216)
- [ ] Configure sampler: euler, beta, CFG 2.0, steps 40-60
- [ ] Write detailed prompt with photography terms
- [ ] Add negative prompt for quality control
- [ ] Enable Detail Daemon if desired (detail: 0.3-0.5)
- [ ] Generate and review
- [ ] Apply post-processing (color correct, sharpen, grain)
- [ ] Upscale if needed (Ultimate SD Upscale to 4K)

---

## Troubleshooting Guide

### Issue: Images look "AI-like" or oversaturated

**Solution**:
- Use FLUX.1 Krea instead of FLUX.1 Dev
- Lower CFG to 2.0 or below
- Add to negative prompt: "oversaturated, plastic skin, artificial"
- Use FLUX-RealismLoRA
- Adjust color correction: saturation: 0.95-1.0

### Issue: Blurry or soft images

**Solution**:
- Switch sampler to DPM++ 2M with sgm_uniform scheduler
- Increase steps to 50-60
- Use Detail Daemon with detail_amount: 0.3-0.5
- Apply post-processing sharpen node
- Ensure text encoders are FP8 or FP16 (not quantized lower)

### Issue: Bad hands/anatomy

**Solution**:
- Use UltraRealistic LoRA V2 (improved anatomy)
- Add to negative prompt: "bad hands, poorly drawn hands, fused fingers, extra fingers, mutated hands"
- Increase CFG to 3.0 for better prompt adherence
- Use Portrait Master node for better character definition
- Consider hand-specific LoRA fix

### Issue: Out of memory (OOM) errors

**Solution**:
- Switch to FP8 models (primary fix)
- Use `--lowvram` flag in launch command
- Reduce resolution (1024x1024 instead of 1920x1080)
- Limit LoRAs to 1-2 maximum
- Restart ComfyUI to clear VRAM fragmentation
- Close other GPU applications (browsers, Discord, etc.)

### Issue: Slow generation times

**Solution**:
- Ensure CUDA 12.1+ is installed
- Use `--gpu-only` flag for faster processing
- Reduce steps to 30-40 (quality vs speed trade-off)
- Use FLUX.2 or 1.1 Pro (faster than FLUX.1)
- Generate at lower resolution and upscale later
- Check for background processes hogging GPU

### Issue: Prompt not followed accurately

**Solution**:
- Increase CFG to 3.0-3.5
- Use T5 FP8 or FP16 (not lower quantization)
- Write more detailed, specific prompts
- Use keyword emphasis (e.g., "(natural lighting:1.3)")
- Reduce LoRA weights if they're overpowering
- Try different seed values

---

## Additional Resources

### Official Documentation
- [ComfyUI Official Docs](https://docs.comfy.org/)
- [FLUX Official Documentation](https://blackforestlabs.ai/)
- [ComfyUI Wiki](https://comfyui-wiki.com/)

### Community Resources
- Reddit: r/comfyui, r/StableDiffusion
- Discord: ComfyUI Official Discord
- GitHub: ComfyUI Discussions, Issues, Custom Nodes

### Model Sources
- HuggingFace: Black Forest Labs, XLabs-AI, comfyanonymous
- CivitAI: Community LoRAs and models
- OpenArt: Workflow sharing and templates

### Workflow Repositories
- [OpenArt Workflows](https://openart.ai/workflows)
- [RunComfy Workflows](https://www.runcomfy.com/workflows)
- [ComfyUI Examples GitHub](https://github.com/comfyanonymous/ComfyUI_examples)

---

## Conclusion

Achieving ultra-realistic photorealistic images with Flux in ComfyUI on RTX 3090 requires:

1. **Right Model**: FLUX.1 Kria for natural realism, FLUX.2/1.1 Pro for maximum detail
2. **FP8 Quantization**: Essential for RTX 3090 to handle Flux models comfortably
3. **Optimal Settings**: CFG 2.0, 40-60 steps, euler sampler, beta scheduler
4. **Quality LoRAs**: RealismLoRA + UltraRealistic V2 for best results
5. **DetailDaemon**: Enhance details without oversharpenin
6. **Post-Processing**: Color correction, sharpening, film grain for professional finish
7. **Upscaling**: Generate at 1024x1024, upscale to 4K with Ultimate SD Upscale
8. **Detailed Prompts**: Use photography terminology, lighting descriptions, camera specs
9. **Negative Prompts**: Comprehensive quality and anatomy exclusions
10. **VRAM Management**: Monitor usage, clear cache, restart periodically

**Recommended Starting Workflow**:
- Model: FLUX.1 Kria FP8
- LoRA: FLUX-RealismLoRA (0.8)
- Resolution: 1024x1024
- Sampler: euler, beta, CFG 2.0, steps 50
- Post-process: Color correct + sharpen
- Upscale: 4x-UltraSharp to 4K

This setup delivers production-grade photorealistic images that avoid the "AI look" while running comfortably on RTX 3090 hardware.

---

## Sources

- [ComfyUI Flux.2 Dev Example](https://docs.comfy.org/tutorials/flux/flux-2-dev)
- [FLUX.2 Day-0 Support in ComfyUI](https://blog.comfy.org/p/flux2-state-of-the-art-visual-intelligence)
- [NVIDIA RTX FLUX.2 Optimization](https://blogs.nvidia.com/blog/rtx-ai-garage-flux-2-comfyui/)
- [Flux 2 Dev High-Fidelity Generation](https://www.runcomfy.com/comfyui-workflows/flux-2-dev-in-comfyui-high-fidelity-visual-generation)
- [FLUX LoRA RealismLoRA Workflow](https://www.runcomfy.com/comfyui-workflows/comfyui-flux-realismlora-workflow-photorealistic-ai-images)
- [Flux UltraRealistic LoRA V2](https://www.runcomfy.com/comfyui-workflows/flux-ultrarealistic-lora-v2-lifelike-ai-images)
- [Fast Hyperrealism with FLUX.1](https://sandner.art/fast-hyperrealism-with-flux1-local-generation-guide/)
- [XLabs-AI flux-RealismLora](https://huggingface.co/XLabs-AI/flux-RealismLora)
- [Flux Krea Dev Guide](https://learn.thinkdiffusion.com/flux-krea-dev-photorealistic-portraits-without-the-ai-look-workflow-guide/)
- [Realistic Flux Workflow](https://mickmumpitz.ai/guides/realistic-flux-workflow)
- [Optimizing Sampler Settings](https://huawafa.be/comfyui-sampler-settings-report.html)
- [Flux Super Realism LoRA](https://huggingface.co/strangerzonehf/Flux-Super-Realism-LoRA)
- [Canopus LoRA Flux UltraRealism 2.0](https://huggingface.co/prithivMLmods/Canopus-LoRA-Flux-UltraRealism-2.0)
- [ComfyUI Upscale Guide](https://docs.comfy.org/tutorials/basic/upscale)
- [Flux Upscaler 4k-32k](https://www.runcomfy.com/comfyui-workflows/flux-upscaler-4k-8k-16k-32k-image-upscaler)
- [Ultimate SD Upscale Tutorial](https://learn.rundiffusion.com/ultimate-sd-upscaler-tutorial/)
- [Flux Text Encoders](https://huggingface.co/comfyanonymous/flux_text_encoders)
- [T5XXL Discussion](https://github.com/comfyanonymous/ComfyUI/discussions/4222)
- [ComfyUI-Detail-Daemon](https://github.com/Jonseed/ComfyUI-Detail-Daemon)
- [ComfyUI-post-processing-nodes](https://github.com/EllangoK/ComfyUI-post-processing-nodes)
- [GPU Buying Guide ComfyUI](https://comfyui-wiki.com/en/install/install-comfyui/gpu-buying-guide)
- [VRAM Optimization Guide 2025](https://apatero.com/blog/vram-optimization-flags-comfyui-explained-guide-2025)
- [RTX 3090 WAN Animate Optimization](https://apatero.com/blog/wan-animate-rtx-3090-complete-optimization-guide-2025)
- [GPU Benchmark Discussion](https://github.com/comfyanonymous/ComfyUI/discussions/9002)
- [ComfyUI Low-VRAM Guide](https://apatero.com/blog/complete-comfyui-low-vram-survival-guide-2025)
- [Image Resolutions with Flux.1 Dev](https://blog.segmind.com/image-resolutions-with-flux-1-dev-model-compared/)
- [FLUX Models Overview](https://help.bfl.ai/articles/9364115800-flux-models-overview)
- [Flux 1.1 Ultra & Raw Modes](https://www.mimicpc.com/learn/flux-ultra-raw-modes)
- [Flux 2 JSON Prompting Guide](https://apatero.com/blog/flux-2-json-prompting-structured-prompts-guide-2025)
- [Improved Flux Prompts Dataset](https://huggingface.co/datasets/k-mktr/improved-flux-prompts-photoreal-portrait)
- [Mastering FLUX.1 Portrait Prompts](https://www.nextdiffusion.ai/blogs/mastering-ai-portrait-prompts-with-flux1-for-realistic-images)
- [Best Realistic FLUX Prompts](https://anakin.ai/blog/realistic-flux-prompts/)
- [Master Negative Prompts in FLUX](https://merlio.app/blog/negative-prompts-in-flux-guide)
- [Awesome ComfyUI Custom Nodes](https://github.com/ComfyUI-Workflow/awesome-comfyui)
- [Ultra-Real LoRAs Collection 2025](https://apatero.com/blog/ultra-real-flux-loras-collection-guide-2025)
- [Comparison of All Flux Models](https://www.mimicpc.com/learn/an-in-depth-comparison-of-all-flux-models)
- [Flux.1 Krea in ComfyUI](https://www.mimicpc.com/learn/how-to-use-flux-krea-in-comfyui)
- [Photorealism: FLUX.1 Krea vs Dev](https://medium.com/@maxim.clouser/photorealism-in-ai-comparing-the-ai-look-of-flux-1-krea-vs-dev-829c13f1a1ed)
- [FLUX.1 Krea Official](https://bfl.ai/blog/flux-1-krea-dev)
- [Comprehensive Flux Models Review](https://blog.segmind.com/comprehensive-review-of-flux-models-which-one-is-the-best/)
- [Flux Models Comparison](https://stockimg.ai/blog/ai-and-technology/what-is-flux-and-models-comparison)
- [ComfyUI Photorealistic Workflow](https://openart.ai/workflows/cgtips/comfyui---generate-photorealistic-images-by-flux-bilbox/DPdcUGh1gB99gMkR1jF1)
- [Boost Texture and Skin Realism](https://comfyui.org/en/boost-texture-and-skin-realism-with-comfyui)
- [RealSkin Flux Enhancer](https://openart.ai/workflows/myaiforce/realskin-flux-enhancer-v1---boost-full-body-skin-realism-with-tutorial/hRD5i3MiCrJKJqylQdKP)
- [ComfyUI Portrait Master](https://github.com/florestefano1975/comfyui-portrait-master)
- [Photorealistic Fashion Photography with FLUX.1](https://comfyui.org/en/photorealistic-fashion-photography-with-flux1-and-controlnet)
