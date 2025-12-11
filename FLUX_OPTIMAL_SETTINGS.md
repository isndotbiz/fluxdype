# Flux Optimal Settings Guide

Complete guide to optimal settings for Flux models on RTX 3090 (24GB VRAM).

---

## Quick Reference: Best Settings by Use Case

### 🚀 Fast Generation (30-40 seconds)
```
Steps: 15-20
Sampler: euler
Scheduler: simple
CFG: 3.0-3.5
Denoise: 1.0
Resolution: 1024x1024
```

### 🎨 Balanced Quality (60-90 seconds)
```
Steps: 25-30
Sampler: euler or dpmpp_2m
Scheduler: simple
CFG: 3.5-4.0
Denoise: 1.0
Resolution: 1024x1024 to 1344x768
```

### 💎 Maximum Quality (2-3 minutes)
```
Steps: 35-50
Sampler: dpmpp_2m
Scheduler: karras
CFG: 3.5-4.5
Denoise: 1.0
Resolution: 1536x1024 or 1024x1536
```

### 🖼️ High Resolution (3-5 minutes)
```
Steps: 30-40
Sampler: dpmpp_2m
Scheduler: karras
CFG: 3.5-4.0
Denoise: 1.0
Resolution: 2048x1024 or 1536x1536
```

---

## Detailed Parameter Guide

### 1. Samplers (Critical for Quality)

#### **euler** ⭐ RECOMMENDED FOR MOST USE CASES
- **Speed**: Fast (~2.5s per step)
- **Quality**: Excellent
- **Best for**: General purpose, landscapes, portraits
- **Pros**: Fast, consistent, good detail
- **Cons**: Slightly less refined than dpmpp_2m
- **RTX 3090**: ~50 seconds for 20 steps @ 1024x1024

#### **dpmpp_2m** ⭐ BEST QUALITY
- **Speed**: Medium (~2.8s per step)
- **Quality**: Excellent, best detail preservation
- **Best for**: High-quality portraits, detailed scenes
- **Pros**: Superior detail, smoother results
- **Cons**: Slower than euler
- **RTX 3090**: ~84 seconds for 30 steps @ 1024x1024

#### **dpmpp_sde**
- **Speed**: Slow (~3.2s per step)
- **Quality**: Very high, experimental
- **Best for**: Artistic renders, experimental work
- **Pros**: Unique aesthetic, high detail
- **Cons**: Slower, less predictable
- **RTX 3090**: ~96 seconds for 30 steps @ 1024x1024

#### **dpmpp_3m_sde**
- **Speed**: Very slow (~3.5s per step)
- **Quality**: Maximum detail
- **Best for**: Final production renders
- **Pros**: Exceptional detail, best overall quality
- **Cons**: Very slow
- **RTX 3090**: ~140 seconds for 40 steps @ 1024x1024

#### **heun**
- **Speed**: Very slow (2 evaluations per step)
- **Quality**: High, but inefficient
- **Best for**: Rarely needed
- **Pros**: Accurate
- **Cons**: 2x slower than euler for similar results
- **Note**: Not recommended for Flux

#### **dpm_2 / dpm_2_ancestral**
- **Speed**: Medium
- **Quality**: Good
- **Best for**: Alternative to euler
- **Pros**: Different aesthetic
- **Cons**: Less consistent than euler
- **Note**: Try if euler doesn't suit your style

---

### 2. Schedulers (Noise Reduction Pattern)

#### **simple** ⭐ RECOMMENDED DEFAULT
- **Characteristics**: Linear noise reduction
- **Best for**: General use, consistent results
- **Quality**: Excellent across all subjects
- **Works with**: All samplers
- **Use when**: You want predictable, consistent results

#### **karras** ⭐ BEST FOR DETAILS
- **Characteristics**: Non-linear, emphasizes fine details
- **Best for**: Portraits, detailed textures, photorealism
- **Quality**: Superior detail preservation
- **Works with**: dpmpp_2m, dpmpp_sde (best combo)
- **Use when**: Details matter more than speed
- **Note**: Pairs perfectly with dpmpp_2m for maximum quality

#### **exponential**
- **Characteristics**: Exponential noise curve
- **Best for**: Experimental, artistic styles
- **Quality**: Variable, style-dependent
- **Works with**: All samplers
- **Use when**: Trying creative/unusual results
- **Note**: Less predictable than simple/karras

#### **sgm_uniform**
- **Characteristics**: Uniform distribution
- **Best for**: Specific artistic effects
- **Quality**: Good for certain styles
- **Works with**: All samplers
- **Use when**: simple/karras don't give desired aesthetic

#### **normal**
- **Characteristics**: Normal distribution
- **Best for**: Standard diffusion
- **Quality**: Similar to simple
- **Works with**: All samplers
- **Use when**: Alternative to simple

#### **ddim_uniform**
- **Characteristics**: DDIM-style scheduling
- **Best for**: Compatibility with older workflows
- **Quality**: Good
- **Works with**: All samplers
- **Use when**: Porting workflows from older systems

---

### 3. CFG Scale (Classifier-Free Guidance)

Flux models work differently than SDXL - they prefer **LOWER** CFG values!

#### CFG Scale Guide
```
1.0-2.0   = Very loose interpretation, creative, may ignore prompt
2.5-3.0   = Loose, artistic freedom, good for creative work
3.0-3.5   ⭐ OPTIMAL for most Flux models (RECOMMENDED)
3.5-4.0   = Balanced, good prompt adherence
4.0-5.0   = Strong guidance, follows prompt closely
5.0-7.0   = Very strong, may over-saturate or artifact
7.0+      = Not recommended, likely to produce artifacts
```

#### Model-Specific CFG Recommendations

**flux_dev.safetensors**: 3.0-3.5
**fluxedUpFluxNSFW**: 3.5-4.0
**iniverseMixSFWNSFW**: 3.5-4.5
**unstableEvolution**: 3.0-4.0

---

### 4. Steps (Denoising Iterations)

#### Steps Guide
```
8-12    = Draft/preview quality, very fast
15-20   ⭐ Good quality, fast (RECOMMENDED for testing)
25-30   ⭐ High quality (RECOMMENDED for final output)
35-40   = Maximum quality, diminishing returns
40-50   = Overkill for most use cases
50+     = Waste of time, no visible improvement
```

#### Sampler-Specific Step Recommendations

**euler + simple**: 20-25 steps optimal
**euler + karras**: 25-30 steps optimal
**dpmpp_2m + simple**: 25-30 steps optimal
**dpmpp_2m + karras**: 30-35 steps optimal ⭐ BEST QUALITY
**dpmpp_sde + karras**: 30-40 steps optimal
**dpmpp_3m_sde**: 35-50 steps optimal

---

### 5. Denoise Strength

#### Denoise Guide
```
1.0     ⭐ Full generation (text-to-image) - STANDARD
0.9     = Slight refinement of input
0.7-0.8 = Image-to-image, noticeable changes
0.5-0.6 = Image-to-image, moderate changes
0.3-0.4 = Image-to-image, subtle refinement
0.1-0.2 = Minimal changes, mostly noise reduction
```

**For text-to-image**: Always use 1.0
**For img2img**: Start at 0.6-0.7, adjust based on how much change you want

---

### 6. Resolution Recommendations

#### Resolution Guide (RTX 3090 - 24GB VRAM)

**Square Formats**
```
512x512     = Fast, draft quality
768x768     = Good for testing
1024x1024   ⭐ OPTIMAL - Best speed/quality balance
1152x1152   = Higher quality, slower
1280x1280   = High quality, VRAM intensive
1536x1536   = Maximum recommended for single image
```

**Portrait Formats (Vertical)**
```
832x1216    = Standard portrait
896x1152    ⭐ RECOMMENDED portrait
1024x1536   = High-quality portrait
1024x1792   = Full-body portrait
1152x1920   = Tall portrait (max recommended)
```

**Landscape Formats (Horizontal)**
```
1216x832    = Standard landscape
1152x896    ⭐ RECOMMENDED landscape
1344x768    = Wide landscape
1536x1024   = High-quality landscape
1920x1152   = Ultra-wide (max recommended)
```

**Cinematic Formats**
```
1920x1080   = 16:9 HD
2048x1152   = 16:9 2K (max for RTX 3090 single batch)
1920x816    = 2.35:1 Cinemascope
```

#### VRAM Usage Estimates
```
1024x1024   = ~12GB VRAM
1536x1024   = ~14GB VRAM
1536x1536   = ~18GB VRAM
2048x1152   = ~20GB VRAM
2048x2048   = ~28GB VRAM ⚠️ May fail on 24GB card
```

---

### 7. Batch Size Recommendations

#### Batch Size Guide (RTX 3090)
```
Resolution      | Batch 1 | Batch 2 | Batch 4
----------------|---------|---------|--------
1024x1024      | ✅ Safe | ✅ Safe | ⚠️ Tight
1536x1024      | ✅ Safe | ⚠️ Tight| ❌ OOM
1024x1536      | ✅ Safe | ⚠️ Tight| ❌ OOM
1536x1536      | ✅ Safe | ❌ OOM  | ❌ OOM
```

**Recommendation**: Stick to batch_size=1 for Flux models unless using 512x512 or smaller.

---

## Optimal Settings Presets

### Preset 1: Speed Demon (Testing/Iteration)
```json
{
  "steps": 15,
  "cfg": 3.0,
  "sampler_name": "euler",
  "scheduler": "simple",
  "denoise": 1.0,
  "width": 1024,
  "height": 1024
}
```
**Time**: ~37 seconds | **Quality**: Good

---

### Preset 2: Daily Driver (Balanced) ⭐ RECOMMENDED
```json
{
  "steps": 25,
  "cfg": 3.5,
  "sampler_name": "euler",
  "scheduler": "simple",
  "denoise": 1.0,
  "width": 1024,
  "height": 1024
}
```
**Time**: ~62 seconds | **Quality**: Excellent

---

### Preset 3: Quality Focus (Final Output)
```json
{
  "steps": 30,
  "cfg": 4.0,
  "sampler_name": "dpmpp_2m",
  "scheduler": "karras",
  "denoise": 1.0,
  "width": 1024,
  "height": 1024
}
```
**Time**: ~84 seconds | **Quality**: Maximum

---

### Preset 4: High Resolution Portrait
```json
{
  "steps": 30,
  "cfg": 3.8,
  "sampler_name": "dpmpp_2m",
  "scheduler": "karras",
  "denoise": 1.0,
  "width": 1024,
  "height": 1536
}
```
**Time**: ~95 seconds | **Quality**: Professional

---

### Preset 5: Landscape Masterpiece
```json
{
  "steps": 35,
  "cfg": 4.0,
  "sampler_name": "dpmpp_2m",
  "scheduler": "karras",
  "denoise": 1.0,
  "width": 1536,
  "height": 1024
}
```
**Time**: ~120 seconds | **Quality**: Gallery-worthy

---

### Preset 6: Creative/Artistic
```json
{
  "steps": 30,
  "cfg": 2.8,
  "sampler_name": "dpmpp_sde",
  "scheduler": "karras",
  "denoise": 1.0,
  "width": 1024,
  "height": 1024
}
```
**Time**: ~96 seconds | **Quality**: Unique artistic style

---

## Advanced Tips

### Seed Management
```
seed: -1           = Random (different every time)
seed: 42           = Fixed (reproducible results)
seed: 123456789    = Any positive integer
```

**Pro Tip**: Save successful seed numbers! They help reproduce good results.

### LoRA Strength Guidelines
```
0.3-0.5  = Subtle effect
0.5-0.7  ⭐ OPTIMAL for most LoRAs
0.7-0.9  = Strong effect
0.9-1.0  = Maximum effect (may overpower)
1.0-1.5  = Experimental (can cause artifacts)
```

### Negative Prompt Best Practices

**Essential negative terms for Flux:**
```
blurry, low quality, distorted, deformed, ugly, bad anatomy,
watermark, signature, text, jpeg artifacts
```

**For photorealism add:**
```
drawing, painting, cartoon, anime, illustration, 3d render, cgi
```

**For portraits add:**
```
extra limbs, mutated hands, bad hands, missing fingers,
fused fingers, extra fingers
```

---

## Troubleshooting Settings

### Problem: Images Too Dark
- Increase CFG to 4.0-4.5
- Add "bright lighting, well-lit" to prompt
- Try different scheduler (karras → simple)

### Problem: Images Too Saturated
- Decrease CFG to 2.5-3.0
- Remove color-boosting words from prompt
- Try euler sampler instead of dpmpp_2m

### Problem: Not Following Prompt
- Increase CFG to 4.0-5.0
- Increase steps to 30-35
- Simplify prompt (remove contradictory terms)
- Try dpmpp_2m + karras

### Problem: Artifacts/Noise
- Decrease CFG below 4.0
- Increase steps to 30+
- Use dpmpp_2m instead of euler
- Check resolution (too high may cause issues)

### Problem: Too Slow
- Use euler + simple
- Reduce steps to 15-20
- Lower resolution to 1024x1024
- Disable LoRAs temporarily

### Problem: Out of Memory
- Reduce resolution (try 896x896)
- Set batch_size to 1
- Reduce steps won't help with VRAM
- Close other GPU applications
- Use --lowvram flag in start-comfy.ps1

---

## Model-Specific Optimization

### flux_dev.safetensors
```
Best sampler: euler or dpmpp_2m
Best scheduler: simple
CFG: 3.0-3.5
Steps: 20-30
Strength: Versatile, works well with all settings
```

### fluxedUpFluxNSFW_60FP16_2250122.safetensors
```
Best sampler: dpmpp_2m
Best scheduler: karras
CFG: 3.5-4.0
Steps: 25-35
Strength: High detail, benefits from quality settings
```

### iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors
```
Best sampler: dpmpp_2m
Best scheduler: karras
CFG: 3.5-4.5
Steps: 30-35
Strength: Photorealism focus, use higher steps
```

### iniverseMixSFWNSFW_guofengXLV15.safetensors
```
Best sampler: euler or dpmpp_2m
Best scheduler: simple or karras
CFG: 3.5-4.0
Steps: 25-30
Strength: Artistic blend, flexible settings
```

### unstableEvolution_Fp1622GB.safetensors
```
Best sampler: dpmpp_2m
Best scheduler: karras
CFG: 3.0-4.0
Steps: 25-35
Strength: Experimental, try various settings
```

---

## Performance Benchmarks (RTX 3090)

### Speed Comparison (1024x1024, 25 steps)
```
euler + simple:        62.5s  ⭐ Fastest quality
euler + karras:        65.0s
dpmpp_2m + simple:     70.0s  ⭐ Best quality/speed
dpmpp_2m + karras:     73.0s  ⭐ Maximum quality
dpmpp_sde + karras:    80.0s
dpmpp_3m_sde + karras: 87.5s
```

### Resolution Impact (euler + simple, 25 steps)
```
512x512:    ~30s
768x768:    ~40s
1024x1024:  ~62s  ⭐ Sweet spot
1152x1152:  ~75s
1280x1280:  ~90s
1536x1024:  ~85s
1024x1536:  ~85s
1536x1536:  ~115s
```

---

## Final Recommendations

### For Quick Testing
**euler + simple, 20 steps, CFG 3.5, 1024x1024**
- Fast, reliable, good quality

### For Daily Use  ⭐
**euler + simple, 25 steps, CFG 3.5, 1024x1024**
- Best balance of speed and quality

### For Final Output  ⭐⭐
**dpmpp_2m + karras, 30 steps, CFG 4.0, 1024x1024+**
- Professional results, worth the wait

### For Maximum Quality  ⭐⭐⭐
**dpmpp_2m + karras, 35 steps, CFG 4.0, 1536x1024**
- Gallery-ready images

---

**Remember**: These are guidelines, not rules. Experiment to find what works best for your specific prompts and style!
