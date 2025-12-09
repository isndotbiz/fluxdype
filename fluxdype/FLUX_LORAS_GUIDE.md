# Flux-Only LoRAs Guide

**Updated**: All SDXL LoRAs have been archived. Only Flux-compatible LoRAs remain!

---

## ✅ Your 8 Flux-Compatible LoRAs

Located in: `D:\workspace\fluxdype\ComfyUI\models\loras\`

### Quality Enhancement LoRAs

#### 1. ultrafluxV1.aWjp.safetensors (152 MB)
**Type**: Quality booster specifically for Flux
**Best Use**: Enhances overall quality and detail
**Recommended Strength**: 0.7-0.9
**Works Best With**: flux_dev.safetensors
**Pair With**: facebookQuality for maximum quality
**Effect**: Sharpens details, improves composition, enhances colors

#### 2. facebookQuality.3t4R.safetensors (293 MB)
**Type**: General quality enhancement
**Best Use**: Professional quality output
**Recommended Strength**: 0.6-0.7
**Works Best With**: All Flux models
**Pair With**: ultrafluxV1 for stacked quality
**Effect**: Improves overall image quality, reduces artifacts

---

### Character/Portrait LoRAs

#### 3. fluxInstaGirlsV2.dbl2.safetensors (38 MB)
**Type**: Instagram-style female portraits
**Best Use**: Modern, trendy portrait photography
**Recommended Strength**: 0.6-0.8
**Works Best With**: fluxedUpFluxNSFW, flux_dev
**Style**: Natural lighting, soft focus, Instagram aesthetic
**Effect**: Creates influencer-style portraits

#### 4. FluXXXv2.safetensors (136 MB)
**Type**: Artistic/stylized enhancement
**Best Use**: Creative, artistic images
**Recommended Strength**: 0.6-0.8
**Works Best With**: All Flux models
**Effect**: Adds artistic flair, unique aesthetic

---

### NSFW LoRAs (5 models)

#### 5. NSFW_Flux_Petite-000002.safetensors (20 MB)
**Type**: Character-specific NSFW
**Best Use**: Petite character generation
**Recommended Strength**: 0.7-0.9
**Works Best With**: NSFW-focused Flux models
**Note**: Lightweight, fast

#### 6. KREAnsfwv2.safetensors (131 MB)
**Type**: General NSFW enhancement
**Best Use**: Adult content generation
**Recommended Strength**: 0.6-0.8
**Works Best With**: All Flux models
**Effect**: Enhances adult content quality

#### 7. NSFW_master.safetensors (165 MB)
**Type**: Master NSFW LoRA
**Best Use**: High-quality adult content
**Recommended Strength**: 0.7-0.9
**Works Best With**: NSFW-focused Flux models
**Effect**: Professional NSFW generation

#### 8. NSFW_UNLOCKED.safetensors (293 MB)
**Type**: Unrestricted NSFW
**Best Use**: Maximum freedom in adult content
**Recommended Strength**: 0.6-0.8
**Works Best With**: All Flux models
**Effect**: Removes restrictions, enhances flexibility

---

## 📦 Archived SDXL LoRAs (2.5 GB)

**Location**: `D:\workspace\fluxdype\ComfyUI\models\loras_sdxl_archive\`

These LoRAs are NOT compatible with Flux and have been archived:

```
❌ Add_Details_v1.2_1406099.safetensors (SDXL)
❌ Ahegao_SDXL-000031.safetensors (SDXL)
❌ Ana_V1.safetensors (SDXL)
❌ DetailTweaker_SDXL.safetensors (SDXL)
❌ dmd2_sdxl_4step_lora.safetensors (SDXL)
❌ Realism Lora By Stable Yogi_V3_Lite_1971030.safetensors (SDXL)
❌ Realism Lora By Stable Yogi_V3_Pro.safetensors (SDXL)
❌ Realism_Lora_By_Stable_yogi_SDXL8.1.safetensors (SDXL)
❌ Super_Eye_Detailer_By_Stable_Yogi_SDPD0.safetensors (SDXL)
```

**Note**: These can be restored if you add SDXL models later.

---

## 🎨 Updated Flux Workflows

### 1. flux_basic.json ✅ TESTED
**LoRAs**: None
**Purpose**: Fast testing
**Time**: ~50s

### 2. flux_highquality.json
**LoRAs**: None
**Purpose**: High-quality base
**Time**: ~95s

### 3. flux_with_lora.json
**LoRAs**: None (updated - removed SDXL LoRA)
**Purpose**: Fantasy/detailed images
**Time**: ~65s

### 4. flux_quality_stack.json ⭐ NEW
**LoRAs**:
- ultrafluxV1 (0.8)
- facebookQuality (0.6)
**Purpose**: Maximum quality with Flux-only LoRAs
**Time**: ~95s
**Best For**: Production-quality output

### 5. flux_character.json ⭐ NEW
**LoRAs**:
- fluxInstaGirlsV2 (0.7)
**Purpose**: Instagram-style portraits
**Time**: ~70s
**Best For**: Modern portrait photography

---

## 🚀 How to Use Flux LoRAs

### Single LoRA Workflow

```json
{
  "1": {
    "inputs": {
      "ckpt_name": "flux_dev.safetensors"
    },
    "class_type": "CheckpointLoaderSimple"
  },
  "2": {
    "inputs": {
      "lora_name": "ultrafluxV1.aWjp.safetensors",
      "strength_model": 0.8,
      "strength_clip": 0.8,
      "model": ["1", 0],
      "clip": ["1", 1]
    },
    "class_type": "LoraLoader"
  }
}
```

### Stacked LoRAs (Quality Stack Example)

```json
{
  "2": {
    "inputs": {
      "lora_name": "ultrafluxV1.aWjp.safetensors",
      "strength_model": 0.8,
      "strength_clip": 0.8,
      "model": ["1", 0],
      "clip": ["1", 1]
    },
    "class_type": "LoraLoader"
  },
  "3": {
    "inputs": {
      "lora_name": "facebookQuality.3t4R.safetensors",
      "strength_model": 0.6,
      "strength_clip": 0.6,
      "model": ["2", 0],  // Chain from previous LoRA
      "clip": ["2", 1]
    },
    "class_type": "LoraLoader"
  }
}
```

---

## 💡 Best Practices for Flux LoRAs

### LoRA Strength Guidelines
```
0.3-0.5  = Subtle effect
0.5-0.7  = Moderate effect ⭐ RECOMMENDED
0.7-0.9  = Strong effect
0.9-1.2  = Very strong (may overpower base model)
1.2+     = Experimental (can cause artifacts)
```

### Stacking Rules
1. **Order**: Quality LoRAs first, style LoRAs second
2. **Strength decay**: First LoRA strongest (0.7-0.9), next lighter (0.5-0.7)
3. **Maximum**: 2-3 LoRAs recommended (4+ may conflict)
4. **Test individually**: Add one at a time to understand effects

### Recommended Combinations

**Maximum Quality (Any Subject)**
```
ultrafluxV1 (0.8) + facebookQuality (0.6)
Model: flux_dev or iniverseMix
```

**Character Portraits**
```
fluxInstaGirlsV2 (0.7) + facebookQuality (0.5)
Model: fluxedUpFluxNSFW
```

**Artistic/Creative**
```
FluXXXv2 (0.8)
Model: flux_dev or unstableEvolution
```

**NSFW High Quality**
```
NSFW_master (0.8) + ultrafluxV1 (0.5)
Model: fluxedUpFluxNSFW or iniverseMix
```

---

## 🔧 Troubleshooting

### Problem: Weird/Distorted Results
**Solution**: Reduce LoRA strength to 0.5 or lower

### Problem: LoRA Not Working
**Solution**:
- Verify it's in `ComfyUI/models/loras/` (not archived)
- Check filename spelling in JSON
- Restart ComfyUI server

### Problem: Conflicts When Stacking
**Solution**:
- Use only 2 LoRAs max
- Reduce strength of second LoRA to 0.4-0.5
- Test LoRAs individually first

### Problem: Images Too Stylized
**Solution**:
- Reduce LoRA strength to 0.3-0.5
- Use only quality LoRAs (ultrafluxV1, facebookQuality)
- Avoid stacking multiple style LoRAs

---

## 📊 LoRA Performance Impact

| LoRAs | Steps | Time (1024x1024) | Quality |
|-------|-------|------------------|---------|
| 0 | 25 | ~60s | Good |
| 1 | 25 | ~65s | Excellent |
| 2 | 25 | ~70s | Maximum |
| 3+ | 25 | ~75s+ | Diminishing returns |

**Recommendation**: Use 1-2 LoRAs for best quality/speed balance

---

## 🎯 Quick Reference by Use Case

### Fast Testing
→ No LoRAs (flux_basic.json)

### Best Overall Quality
→ ultrafluxV1 + facebookQuality (flux_quality_stack.json)

### Modern Portraits
→ fluxInstaGirlsV2 (flux_character.json)

### Artistic Images
→ FluXXXv2

### NSFW Content
→ NSFW_master or NSFW_UNLOCKED

---

## 📝 Next Steps

1. **Test flux_quality_stack.json** - See the quality improvement
2. **Try flux_character.json** - Test portrait generation
3. **Experiment with strengths** - Adjust 0.5-0.9 to find sweet spot
4. **Create custom combinations** - Mix LoRAs for unique styles
5. **Use LLM helper** for optimized prompts (see LLM_PROMPT_HELPER_SETUP.md)

---

**Space Saved**: 2.5 GB by archiving SDXL LoRAs!

For more information:
- **All Workflows**: WORKFLOWS_INDEX.md
- **Optimal Settings**: FLUX_OPTIMAL_SETTINGS.md
- **LLM Setup**: LLM_PROMPT_HELPER_SETUP.md
