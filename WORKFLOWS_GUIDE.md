# Flux Workflow Guide

This guide explains the ready-to-use Flux workflows and how to test them.

## Available Workflows

### 1. flux_basic.json
**Purpose**: Basic Flux text-to-image generation
**Model**: flux_dev.safetensors
**Resolution**: 1024x1024
**Steps**: 20
**Sampler**: euler / simple
**CFG**: 3.5

**Prompt**: "a beautiful landscape with mountains and a lake at sunset, highly detailed, photorealistic, 8k"

**Use Case**: Quick testing, landscape images, general purpose generation

---

### 2. flux_highquality.json
**Purpose**: High-quality portrait generation
**Model**: iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors
**Resolution**: 1024x1536 (portrait)
**Steps**: 30
**Sampler**: dpmpp_2m / karras
**CFG**: 4.0

**Prompt**: "masterpiece, best quality, ultra detailed, 8k, photorealistic portrait of a beautiful woman with long flowing hair, dramatic lighting, cinematic composition, sharp focus, professional photography"

**Use Case**: High-quality portraits, detailed character generation, professional results

---

### 3. flux_with_lora.json
**Purpose**: Detailed fantasy images with LoRA enhancement
**Model**: flux_dev.safetensors
**LoRA**: Add_Details_v1.2 (strength: 0.7)
**Resolution**: 1344x768 (landscape)
**Steps**: 25
**Sampler**: euler / simple
**CFG**: 3.5

**Prompt**: "highly detailed fantasy castle on a mountain peak, intricate architecture, mystical atmosphere, vibrant colors, dramatic sky, epic composition, concept art"

**Use Case**: Fantasy art, concept art, highly detailed images, landscape compositions

---

## How to Run Workflows

### Method 1: Using the Test Script (Recommended)

```powershell
cd D:\workspace\fluxdype

# Test basic workflow
.\test-workflow.ps1 -WorkflowFile "flux_basic.json"

# Test high quality workflow
.\test-workflow.ps1 -WorkflowFile "flux_highquality.json"

# Test LoRA workflow
.\test-workflow.ps1 -WorkflowFile "flux_with_lora.json"
```

The script will:
- Submit the workflow to ComfyUI
- Wait for generation to complete
- Report the output location

### Method 2: Using Python

```python
import json
import requests

# Load workflow
with open('flux_basic.json', 'r') as f:
    workflow = json.load(f)

# Submit to ComfyUI API
api_request = {'prompt': workflow}
response = requests.post('http://localhost:8188/prompt', json=api_request)

print(f"Job ID: {response.json()['prompt_id']}")
```

### Method 3: Using curl (Command Line)

```bash
# Wrap workflow in API format
cat flux_basic.json | python -c "import sys, json; print(json.dumps({'prompt': json.load(sys.stdin)}))" | \
  curl -X POST http://localhost:8188/prompt -H "Content-Type: application/json" -d @-
```

### Method 4: Using ComfyUI Web Interface

1. Open http://localhost:8188 in your browser
2. Load workflow: **Menu → Load** → Select JSON file
3. Click **Queue Prompt** to generate

---

## Generated Images Location

All generated images are saved to:
```
D:\workspace\fluxdype\ComfyUI\output\
```

File naming pattern:
- `flux_basic_00001_.png`
- `flux_highquality_00001_.png`
- `flux_with_lora_00001_.png`

---

## Customizing Workflows

### Change the Prompt

Edit the JSON file and modify the `text` field in the `CLIPTextEncode` node:

```json
{
  "2": {
    "inputs": {
      "text": "YOUR NEW PROMPT HERE",
      "clip": ["1", 1]
    },
    "class_type": "CLIPTextEncode"
  }
}
```

### Change the Model

Modify the `ckpt_name` in the checkpoint loader:

```json
{
  "1": {
    "inputs": {
      "ckpt_name": "unstableEvolution_Fp1622GB.safetensors"
    },
    "class_type": "CheckpointLoaderSimple"
  }
}
```

**Available Models:**
- flux_dev.safetensors
- fluxedUpFluxNSFW_60FP16_2250122.safetensors
- iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors
- iniverseMixSFWNSFW_guofengXLV15.safetensors
- unstableEvolution_Fp1622GB.safetensors

### Change Resolution

Modify the `width` and `height` in EmptyLatentImage node:

```json
{
  "4": {
    "inputs": {
      "width": 1024,
      "height": 1024,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage"
  }
}
```

**Recommended Resolutions:**
- Square: 1024x1024
- Portrait: 896x1152, 1024x1536
- Landscape: 1344x768, 1536x1024

### Change Generation Settings

Modify KSampler parameters:

```json
{
  "5": {
    "inputs": {
      "seed": 42,           // Random seed (-1 for random)
      "steps": 20,          // 15-40 recommended
      "cfg": 3.5,          // 2.5-5.0 for Flux
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 1
    }
  }
}
```

**Sampler Options:**
- `euler` - Fast, good quality (recommended)
- `dpmpp_2m` - Slower, higher quality
- `dpmpp_sde` - Detailed, experimental

**Scheduler Options:**
- `simple` - Standard (recommended)
- `karras` - Better detail preservation
- `exponential` - Experimental

---

## Performance Metrics

Based on RTX 3090 (24GB VRAM):

**Basic Workflow (flux_basic.json)**
- Model Load: ~5 seconds (first run)
- Generation: ~50 seconds (20 steps @ 2.5s/step)
- Total: ~55 seconds (first run), ~50 seconds (cached)

**High Quality Workflow (flux_highquality.json)**
- Generation: ~75 seconds (30 steps @ 2.5s/step)
- Higher resolution: May use more VRAM

**LoRA Workflow (flux_with_lora.json)**
- LoRA Load: +2-3 seconds
- Generation: ~63 seconds (25 steps @ 2.5s/step)

---

## Troubleshooting

### "Out of memory" error
- Reduce resolution (try 896x896 or 768x768)
- Use fewer steps (15-20 instead of 30)
- Close other GPU applications

### Workflow fails to submit
- Ensure ComfyUI server is running (http://localhost:8188)
- Check JSON syntax (use jsonlint.com)
- Verify model files exist in ComfyUI/models/checkpoints/

### Generation too slow
- Use `euler` sampler instead of `dpmpp_2m`
- Reduce steps to 15-20
- Use smaller resolution

### Images look bad
- Increase steps (25-30)
- Adjust CFG (try 3.0-4.5)
- Try different models
- Improve prompt quality

---

## Example Prompts

### Photorealistic
```
professional photograph of a cityscape at night, neon lights, rainy streets, reflections,
cinematic lighting, sharp focus, 8k, high detail, award winning photography
```

### Fantasy Art
```
epic fantasy landscape, ancient ruins, glowing magical crystals, mystical fog,
dramatic sky, volumetric lighting, concept art, highly detailed, artstation quality
```

### Portrait
```
portrait of a elegant woman, soft natural lighting, professional photography,
shallow depth of field, bokeh background, 50mm lens, high resolution, detailed skin texture
```

### Anime Style
```
anime style illustration, beautiful character design, vibrant colors, detailed eyes,
flowing hair, dynamic pose, professional digital art, trending on pixiv
```

---

## Next Steps

1. **Experiment with prompts** - Modify the text in the workflows
2. **Try different models** - Test all 5 Flux checkpoints
3. **Combine LoRAs** - Stack multiple LoRAs for unique styles
4. **Create variations** - Change seed values for different results
5. **Build custom workflows** - Use the web UI to create complex pipelines

For more information, see CLAUDE.md and COMPLETE_SETUP_SUMMARY.md.
