# Complete Workflows Index

All workflows are located in: **D:\workspace\fluxdype\**

---

## 📁 Available Workflows

### 1. flux_basic.json ✅ TESTED
**Location**: `D:\workspace\fluxdype\flux_basic.json`
**Purpose**: Basic Flux text-to-image generation
**LoRAs**: None
**Settings**:
- Model: flux_dev.safetensors
- Resolution: 1024x1024
- Steps: 20
- Sampler: euler / simple
- CFG: 3.5

**Use For**: Quick testing, general purpose images
**Generation Time**: ~50 seconds

---

### 2. flux_highquality.json
**Location**: `D:\workspace\fluxdype\flux_highquality.json`
**Purpose**: High-quality portrait generation
**LoRAs**: None
**Settings**:
- Model: iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors
- Resolution: 1024x1536 (portrait)
- Steps: 30
- Sampler: dpmpp_2m / karras
- CFG: 4.0

**Use For**: Professional portraits, character images
**Generation Time**: ~95 seconds

---

### 3. flux_with_lora.json
**Location**: `D:\workspace\fluxdype\flux_with_lora.json`
**Purpose**: Fantasy/detailed images with LoRA
**LoRAs**:
- Add_Details_v1.2 (strength: 0.7)

**Settings**:
- Model: flux_dev.safetensors
- Resolution: 1344x768 (landscape)
- Steps: 25
- Sampler: euler / simple
- CFG: 3.5

**Use For**: Fantasy art, detailed landscapes, concept art
**Generation Time**: ~65 seconds

---

### 4. flux_realism_stacked_loras.json ⭐ NEW
**Location**: `D:\workspace\fluxdype\flux_realism_stacked_loras.json`
**Purpose**: Maximum realism with stacked LoRAs
**LoRAs (Stacked)**:
- Realism Lora By Stable Yogi V3 Pro (strength: 0.8)
- Add_Details_v1.2 (strength: 0.6)
- Super_Eye_Detailer (strength: 0.5)

**Settings**:
- Model: flux_dev.safetensors
- Resolution: 1024x1536 (portrait)
- Steps: 30
- Sampler: dpmpp_2m / karras
- CFG: 4.0

**Use For**: Photorealistic portraits, detailed faces, professional photography style
**Generation Time**: ~95 seconds
**Best For**: Human subjects, portraits, close-ups

---

### 5. flux_ultra_quality.json ⭐ NEW
**Location**: `D:\workspace\fluxdype\flux_ultra_quality.json`
**Purpose**: Maximum quality output with quality-focused LoRAs
**LoRAs (Stacked)**:
- ultrafluxV1 (strength: 0.7)
- facebookQuality (strength: 0.6)

**Settings**:
- Model: iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors
- Resolution: 1344x768 (landscape)
- Steps: 35
- Sampler: dpmpp_2m / karras
- CFG: 4.5

**Use For**: Final production images, gallery-worthy outputs, maximum detail
**Generation Time**: ~120 seconds
**Best For**: Landscapes, scenes, complex compositions

---

## 🎨 Available LoRAs (17 total)

### Quality Enhancement LoRAs
```
✅ Add_Details_v1.2_1406099.safetensors
   - Use: Add fine details to any image
   - Strength: 0.6-0.7
   - Best with: All models

✅ DetailTweaker_SDXL.safetensors
   - Use: Adjust detail level
   - Strength: 0.5-0.6
   - Best with: SDXL-based models

✅ ultrafluxV1.aWjp.safetensors
   - Use: Ultra quality boost for Flux
   - Strength: 0.7-0.8
   - Best with: flux_dev

✅ facebookQuality.3t4R.safetensors
   - Use: Quality enhancement
   - Strength: 0.6-0.7
   - Best with: All models
```

### Realism LoRAs
```
✅ Realism Lora By Stable Yogi_V3_Pro.safetensors
   - Use: Maximum photorealism
   - Strength: 0.7-0.9
   - Best with: flux_dev, iniverseMix

✅ Realism Lora By Stable Yogi_V3_Lite_1971030.safetensors
   - Use: Lighter realism enhancement
   - Strength: 0.6-0.8
   - Best with: All models

✅ Realism_Lora_By_Stable_yogi_SDXL8.1.safetensors
   - Use: SDXL realism
   - Strength: 0.7-0.8
   - Best with: SDXL models
```

### Detail Specific LoRAs
```
✅ Super_Eye_Detailer_By_Stable_Yogi_SDPD0.safetensors
   - Use: Enhance eye details in portraits
   - Strength: 0.4-0.6
   - Best with: Portrait workflows
```

### Style-Specific LoRAs
```
✅ fluxInstaGirlsV2.dbl2.safetensors
   - Use: Instagram-style portraits
   - Strength: 0.6-0.8
   - Best with: flux_dev, fluxedUp

✅ Ana_V1.safetensors
   - Use: Specific character style
   - Strength: 0.7-0.9
   - Best with: Character generation

✅ FluXXXv2.safetensors
   - Use: Artistic style enhancement
   - Strength: 0.6-0.8
   - Best with: flux_dev
```

### Speed Enhancement LoRAs
```
✅ dmd2_sdxl_4step_lora.safetensors
   - Use: Fast 4-step generation
   - Strength: 1.0
   - Best with: SDXL models
   - Note: Reduces steps to 4 for fast previews
```

### NSFW LoRAs
```
✅ KREAnsfwv2.safetensors
✅ NSFW_Flux_Petite-000002.safetensors
✅ NSFW_master.safetensors
✅ NSFW_UNLOCKED.safetensors
✅ Ahegao_SDXL-000031.safetensors
   - Use: Adult content generation
   - Strength: 0.6-0.9
   - Best with: NSFW-focused models
```

---

## 🚀 How to Use Workflows

### Method 1: PowerShell Script
```powershell
cd D:\workspace\fluxdype

# Run basic workflow
.\test-workflow.ps1 -WorkflowFile "flux_basic.json"

# Run realism workflow
.\test-workflow.ps1 -WorkflowFile "flux_realism_stacked_loras.json"

# Run ultra quality workflow
.\test-workflow.ps1 -WorkflowFile "flux_ultra_quality.json"
```

### Method 2: Python
```python
import json, requests

# Load workflow
with open('D:/workspace/fluxdype/flux_realism_stacked_loras.json') as f:
    workflow = json.load(f)

# Submit
response = requests.post('http://localhost:8188/prompt', json={'prompt': workflow})
print(f"Job ID: {response.json()['prompt_id']}")
```

### Method 3: Web UI
1. Open http://localhost:8188
2. Menu → Load → Select workflow JSON
3. Queue Prompt

---

## 🔧 Customizing Workflows

### Change the Prompt
Find the `CLIPTextEncode` node and edit the `text` field:
```json
"inputs": {
  "text": "YOUR PROMPT HERE",
  "clip": ["X", 1]
}
```

### Change LoRA Strength
Find the `LoraLoader` node and adjust `strength_model` and `strength_clip`:
```json
"inputs": {
  "lora_name": "Add_Details_v1.2_1406099.safetensors",
  "strength_model": 0.7,  // 0.0-1.5, typical: 0.5-0.8
  "strength_clip": 0.7,   // Same as model usually
  "model": ["X", 0],
  "clip": ["X", 1]
}
```

### Add More LoRAs
To stack LoRAs, add new LoraLoader nodes:
```json
"3": {
  "inputs": {
    "lora_name": "DetailTweaker_SDXL.safetensors",
    "strength_model": 0.5,
    "strength_clip": 0.5,
    "model": ["2", 0],  // Chain from previous LoRA
    "clip": ["2", 1]
  },
  "class_type": "LoraLoader"
}
```

### Change Model
Edit the checkpoint name in `CheckpointLoaderSimple`:
```json
"1": {
  "inputs": {
    "ckpt_name": "unstableEvolution_Fp1622GB.safetensors"
  },
  "class_type": "CheckpointLoaderSimple"
}
```

**Available Models:**
- flux_dev.safetensors
- fluxedUpFluxNSFW_60FP16_2250122.safetensors
- iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors
- iniverseMixSFWNSFW_guofengXLV15.safetensors
- unstableEvolution_Fp1622GB.safetensors

---

## 📊 Workflow Comparison

| Workflow | LoRAs | Steps | Time | Quality | Best For |
|----------|-------|-------|------|---------|----------|
| flux_basic | 0 | 20 | ~50s | Good | Testing |
| flux_highquality | 0 | 30 | ~95s | Excellent | Portraits |
| flux_with_lora | 1 | 25 | ~65s | High | Fantasy |
| flux_realism_stacked | 3 | 30 | ~95s | Maximum | Photorealism |
| flux_ultra_quality | 2 | 35 | ~120s | Maximum | Production |

---

## 🎯 Recommended Workflow by Use Case

### Quick Test / Iteration
→ **flux_basic.json**
- Fast, reliable, good quality

### Professional Portrait
→ **flux_realism_stacked_loras.json**
- 3 stacked LoRAs for maximum realism
- Excellent face and eye details

### Landscape / Scene
→ **flux_ultra_quality.json**
- Quality-focused LoRAs
- Best for complex compositions

### Fantasy / Concept Art
→ **flux_with_lora.json**
- Detail enhancement
- Artistic flexibility

### Maximum Quality (Any Subject)
→ **flux_ultra_quality.json** or **flux_realism_stacked_loras.json**
- Choose based on subject (realism vs. artistic)

---

## 💡 Pro Tips

### LoRA Stacking Rules
1. **Order matters**: Quality LoRAs → Style LoRAs → Detail LoRAs
2. **Strength balance**: First LoRA strongest (0.7-0.9), others lighter (0.5-0.7)
3. **Max 3-4 LoRAs**: More causes conflicts
4. **Test individually**: Add LoRAs one at a time to see effects

### Workflow Optimization
1. Start with basic workflow to test prompt
2. Add LoRAs if needed
3. Increase steps for final output
4. Use highest quality settings last

### Troubleshooting
- **Weird results**: Reduce LoRA strength to 0.5
- **Slow generation**: Use flux_basic.json for testing
- **Out of memory**: Lower resolution or remove LoRAs

---

## 📝 Next Steps

1. **Try each workflow** to understand differences
2. **Customize prompts** in JSON files
3. **Experiment with LoRA strengths** (0.5-0.9)
4. **Stack LoRAs** for unique styles
5. **Use LLM helper** for prompt optimization (see LLM_PROMPT_HELPER_SETUP.md)

---

For more information:
- **Workflow Guide**: WORKFLOWS_GUIDE.md
- **Optimal Settings**: FLUX_OPTIMAL_SETTINGS.md
- **LLM Setup**: LLM_PROMPT_HELPER_SETUP.md
- **Project Overview**: CLAUDE.md
