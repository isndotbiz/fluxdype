# FluxedUp NSFW Model - Complete Stats & Best Settings

## Model Info

| Property | Value |
|----------|-------|
| **Model Name** | fluxedUpFluxNSFW_60FP16_2250122 |
| **Base Model** | Flux Dev |
| **File Size** | 23.8 GB (FP16) |
| **Format** | SafeTensors |
| **Specialization** | Female subjects, NSFW capability |
| **Source** | CivitAI (Model ID: 847101) |
| **SHA256** | 050426241364305475C59436A65F8CBC3A8A6A9EC559A040D80B0DE85781D266 |

---

## Model Characteristics

### What It Does Best:
- **Female-focused generation**: Heavily biased towards female subjects
- **NSFW/Nude images**: Specifically trained for adult content
- **High detail**: Good at skin texture, facial features, body details
- **Professional quality**: Instagram model, fashion, portrait style

### What To Use It For:
- Female portraits and full-body shots
- Fashion and modeling photography
- Stylized female art
- Adult/NSFW content generation

---

## Recommended Core Settings

### **Quality Mode (Recommended)**
```
Sampler:        DPM++ 2M (dpmpp_2m)
Scheduler:      Beta
Steps:          25-30
CFG Scale:      3.5-4.0
Denoise:        1.0
Seed:           Random (change for variety)
Resolution:     1024x1536 or 1024x1024
```

### **Fast Mode (Turbo)**
```
Sampler:        Euler
Scheduler:      Simple
Steps:          15-20
CFG Scale:      3.0-3.5
Denoise:        1.0
Resolution:     512x768 or 768x1024
```

### **Ultra Quality Mode**
```
Sampler:        DPM++ 2M
Scheduler:      Beta
Steps:          35-40
CFG Scale:      4.0-4.5
Denoise:        1.0
Resolution:     1024x1536 (portrait) or 1536x1024 (landscape)
```

---

## Current Working Configuration

From your `2_fluxedUp_NSFW_FIXED.json` workflow:

### Model & Encoders:
```
UNET:           fluxedUpFluxNSFW_60FP16_2250122.safetensors
CLIP 1:         clip_l.safetensors
CLIP 2:         t5xxl_fp16.safetensors
VAE:            ae.safetensors (Flux VAE)
```

### LoRA Stack:
```
LoRA 1:         ultrafluxV1.aWjp.safetensors
                - Model Strength:  0.7
                - CLIP Strength:   0.7

LoRA 2:         fluxInstaGirlsV2.dbl2.safetensors
                - Model Strength:  0.6
                - CLIP Strength:   0.6
```

### Sampling Parameters:
```
Sampler:        Euler
Scheduler:      Simple
Steps:          25
CFG Scale:      3.5
Denoise:        1.0
Resolution:     1024x1536
Seed:           54321
Batch:          1
```

### Prompts:
**Positive:**
```
"instagram model portrait, beautiful young woman with long flowing hair,
natural makeup, fashionable clothing, soft natural lighting, detailed skin
texture, professional photography, photorealistic, 8k uhd, high quality,
masterpiece"
```

**Negative:**
```
"blurry, low quality, distorted, bad anatomy, watermark, text, signature"
```

---

## Performance Metrics

### VRAM Requirements (RTX 3090):
| Mode | VRAM | Speed | Quality |
|------|------|-------|---------|
| Standard FP16 | 20-24 GB | Baseline | High |
| Fast Mode | 18-20 GB | +20% | Good |
| Ultra Quality | 22-24 GB | -30% | Excellent |

### Generation Times (on RTX 3090):
```
Fast Mode (15 steps):       25-35 seconds
Quality Mode (25 steps):    45-60 seconds
Ultra Quality (40 steps):   70-90 seconds
```

---

## LoRA Optimization Guide

### Best LoRA Combinations for FluxedUp:

#### 🎨 **Instagram Model Look** (Current Setup)
```
ultrafluxV1:        0.7 (enhances detail, sharpness)
fluxInstaGirlsV2:   0.6 (Instagram aesthetic, makeup, styling)
Combined Effect:    Instagram model quality with excellent detail
```

#### 📸 **Professional Portrait**
```
ultrafluxV1:        0.8
fluxInstaGirlsV2:   0.4
Combined Effect:    Sharp, detailed portraits with professional lighting
```

#### 🎭 **Artistic/Stylized**
```
ultrafluxV1:        0.6
fluxInstaGirlsV2:   0.5
Combined Effect:    Balanced stylized appearance
```

#### 💄 **High Makeup Detail**
```
fluxInstaGirlsV2:   0.8
ultrafluxV1:        0.5
Combined Effect:    Enhanced facial features, makeup detail
```

### LoRA Strength Guidelines:
```
0.3-0.4  → Subtle influence, maintains model's base style
0.5-0.7  → Noticeable effect, strong influence
0.8-1.0  → Dominant effect, may override base model characteristics
```

---

## Prompt Engineering Tips

### Best Prompt Structure:
```
[Subject] + [Appearance] + [Setting] + [Style] + [Quality Terms]
```

### Example Prompts:

**Professional Portrait:**
```
professional portrait of a beautiful woman, detailed face, soft studio lighting,
natural skin texture, professional photography, 8k, photorealistic, masterpiece
```

**Fashion/Lifestyle:**
```
fashion model in stylish outfit, vibrant colors, dynamic pose, natural background,
professional photography, editorial style, detailed, 8k, high quality
```

**Artistic:**
```
artistic portrait of elegant woman, painterly style, soft colors, dramatic lighting,
detailed features, character art, fantasy aesthetic, masterpiece
```

### Strong Keywords for FluxedUp:
- `detailed face`
- `professional photography`
- `photorealistic`
- `8k uhd`
- `natural skin texture`
- `soft lighting`
- `professional makeup`
- `fashion`
- `instagram model`

### Negative Keywords to Avoid Quality Loss:
```
blurry, low quality, distorted, bad anatomy, watermark, text, signature,
ugly, poorly drawn, mutation, deformed, disfigured, extra limbs,
cloned face, twisted, distorted
```

---

## Sampler & Scheduler Comparison

### Best Samplers for FluxedUp:
| Sampler | Quality | Speed | Notes |
|---------|---------|-------|-------|
| **DPM++ 2M** | Excellent | Good | Official recommendation - Best quality |
| **Euler** | Very Good | Excellent | Fast, good for testing |
| **DPM++ SDE** | Excellent | Good | Alternative high-quality |
| **Heun** | Excellent | Slower | Best quality but slow |

### Best Schedulers:
| Scheduler | Best For |
|-----------|----------|
| **Beta** | Default, best quality (use with DPM++) |
| **Simple** | Fast generation (use with Euler) |
| **Karras** | Alternative for DPM++ |
| **Exponential** | Fine detail work |

---

## Resolution Recommendations

### Best Aspect Ratios for Female Subjects:
```
Portrait (Vertical):
  1024 x 1536  → Full body, vertical composition
  768 x 1024   → Head-to-mid-thigh, focused portrait
  512 x 768    → Quick generation, head/shoulders

Square:
  1024 x 1024  → Balanced, versatile
  768 x 768    → Faster generation

Landscape:
  1536 x 1024  → Full body horizontal
  1024 x 768   → Standard landscape portrait
```

### VRAM vs Resolution:
```
512x512   → 16 GB minimum
768x768   → 18 GB minimum
1024x1024 → 20 GB minimum
1024x1536 → 22-24 GB (RTX 3090 optimal)
```

---

## CFG Scale Impact

### How CFG Affects Output:
```
CFG 2.0-3.0   → Less prompt adherence, more creative freedom
CFG 3.5-4.0   → Balanced (RECOMMENDED)
CFG 4.5-5.0   → Stronger prompt adherence, more rigid
CFG 5.5+      → Very strict to prompt, may lose quality
```

### For FluxedUp Specifically:
```
Low CFG (2.0-3.0):  Better for creative NSFW, less constrained
Mid CFG (3.5-4.0):  RECOMMENDED - balanced quality and adherence
High CFG (5.0+):    Use for specific details, may reduce quality
```

---

## GGUF Conversion Info

### Available Quantizations:
The model can be converted to GGUF format for efficiency:

```
Original FP16:     23.8 GB
Converted Q8:      21.4 GB (10% smaller)
Converted Q4:      12.9 GB (46% smaller)
```

### Conversion Command:
```powsh
.\convert_model_to_gguf.ps1 `
  -ModelPath "ComfyUI\models\diffusion_models\fluxedUpFluxNSFW_60FP16_2250122.safetensors" `
  -ModelName "fluxedUp-NSFW" `
  -Quantization "Q8_0"
```

---

## Typical Generation Stats

### From Current Workflow:
```
Model:          fluxedUpFluxNSFW
Resolution:     1024x1536 (1.5M pixels)
Steps:          25
CFG:            3.5
Sampler:        Euler + Simple
LoRAs:          2 stacked
Time:           ~50 seconds (RTX 3090)
VRAM Used:      ~20 GB
Quality:        Excellent
Output Style:   Instagram model aesthetic
```

---

## What Makes This Model Special

1. **Female Subject Optimization**: Fine-tuned specifically for female generation
2. **NSFW Capability**: Trained on adult content (with safeguards)
3. **Detail Level**: Exceptional skin texture and facial detail
4. **Consistency**: Reliable output quality across prompts
5. **Aesthetic**: Instagram/fashion photography style by default

---

## Common Issues & Fixes

### Issue: "Output looks too cartoony"
**Fix**:
- Increase steps to 30-35
- Use DPM++ 2M sampler
- Reduce CFG to 3.0-3.5
- Add `photorealistic, detailed` to prompt

### Issue: "Too much prompt influence, ignoring creativity"
**Fix**:
- Reduce CFG to 2.5-3.0
- Use Euler sampler
- Increase denoise to 1.0

### Issue: "Output quality is low"
**Fix**:
- Increase steps to 30+
- Use DPM++ 2M sampler
- Use Beta scheduler
- Check VRAM isn't maxed out

### Issue: "LoRAs not showing effect"
**Fix**:
- Check LoRA strength: 0.5-0.8 is usually visible
- Use Power LoRA Loader (rgthree) for better control
- Stack LoRAs properly (UltraFlux first, then InstaGirls)

---

## Comparison: Standard Flux vs FluxedUp

| Aspect | Flux Dev | FluxedUp NSFW |
|--------|----------|---------------|
| Best For | All subjects | Female subjects |
| NSFW | Limited | Optimized |
| Skin Detail | Good | Excellent |
| Fashion/Style | General | Instagram aesthetic |
| File Size | 12 GB | 23.8 GB |
| VRAM | 14-18 GB | 20-24 GB |
| Flexibility | Higher | Specialized |
| Quality | Excellent | Excellent (females) |

---

## Recommended Starting Prompt Template

```
[QUALITY PREFIX] portrait of [SUBJECT DESCRIPTION],
[APPEARANCE DETAILS], [CLOTHING/STYLING], [SETTING],
[LIGHTING], [PHOTOGRAPHY STYLE], [QUALITY BOOSTERS]
```

### Example:
```
professional portrait of a stunning woman with long dark hair and piercing eyes,
natural makeup, wearing a stylish black dress, sitting in a luxury minimalist room,
soft golden hour lighting, professional photography, photorealistic, detailed,
8k uhd, high quality, masterpiece
```

---

## Summary: Quick Reference

**Model:** FluxedUp NSFW (23.8 GB)
**Best Sampler:** DPM++ 2M
**Best Scheduler:** Beta
**Recommended Steps:** 25-30
**Recommended CFG:** 3.5-4.0
**Recommended Resolution:** 1024x1536
**Best LoRA Combo:** UltraFlux (0.7) + InstaGirls (0.6)
**VRAM for RTX 3090:** 20-24 GB
**Generation Time:** 45-60 seconds

---

**Last Updated:** 2025-01-24
**Model Version:** 60FP16 (v2359335)
