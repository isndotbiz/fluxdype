# LLM Prompt Helper Setup Guide

Complete guide to setting up a local LLM for AI prompt optimization and assistance.

---

## Recommended LLM: Ollama + Llama 3.2

**Why Ollama?**
- Runs locally (no API costs)
- Easy to install
- Fast inference
- Multiple model support
- Works on Windows with WSL or native

**Best Models for Prompt Engineering:**
1. **llama3.2:latest** (3B) - Fast, good for quick prompts ⭐ RECOMMENDED
2. **mistral:latest** (7B) - Excellent quality
3. **llama3.1:8b** - Best balance of quality/speed
4. **gemma2:9b** - Google's model, very capable

---

## Installation Options

### Option 1: Ollama (Recommended) ⭐

#### Step 1: Install Ollama

**Windows (Native):**
```powershell
# Download from https://ollama.com/download
# Or use winget
winget install Ollama.Ollama
```

**WSL/Linux:**
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

#### Step 2: Install a Model

```bash
# Fast model (3B parameters) - RECOMMENDED for daily use
ollama pull llama3.2

# Better quality (7B parameters)
ollama pull mistral

# Maximum quality (8B parameters)
ollama pull llama3.1:8b
```

#### Step 3: Test the Model

```bash
# Interactive chat
ollama run llama3.2

# Single prompt
ollama run llama3.2 "Optimize this prompt for Flux: a beautiful woman"
```

#### Step 4: Run as API Server

```bash
# Ollama runs on http://localhost:11434 by default
ollama serve
```

---

### Option 2: LM Studio (GUI Alternative)

**Download**: https://lmstudio.ai/

**Steps:**
1. Install LM Studio
2. Download model: "llama-3.2-3b-instruct" or "mistral-7b-instruct"
3. Start local server (port 1234)
4. Use API at http://localhost:1234

---

### Option 3: text-generation-webui (Advanced)

**For power users who want full control:**

```bash
git clone https://github.com/oobabooga/text-generation-webui
cd text-generation-webui
./start_windows.bat  # or start_linux.sh
```

Download models via the web UI at http://localhost:7860

---

## Using the LLM for Prompt Optimization

### Method 1: Command Line Script

Create `D:\workspace\fluxdype\optimize-prompt.ps1`:

```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$Prompt,

    [string]$Model = "llama3.2",
    [string]$Style = "photorealistic"
)

$systemPrompt = @"
You are an expert AI image prompt engineer specializing in Flux models.
Optimize prompts following these rules:

1. Keep prompts clear and descriptive
2. Use comma-separated keywords
3. Include technical terms: lighting, composition, quality markers
4. For photorealism: add camera settings, film type, lighting
5. For art: add artist style, medium, art movement
6. Always include quality boosters: masterpiece, best quality, highly detailed
7. Suggest negative prompts to avoid common issues
8. Output format:
   OPTIMIZED PROMPT: [prompt]
   NEGATIVE PROMPT: [negative]
   SETTINGS: [recommended sampler, steps, cfg]
"@

$request = @{
    model = $Model
    messages = @(
        @{
            role = "system"
            content = $systemPrompt
        },
        @{
            role = "user"
            content = "Style: $Style`nOriginal prompt: $Prompt`n`nOptimize this prompt for Flux image generation."
        }
    )
    stream = $false
} | ConvertTo-Json -Depth 10

$response = Invoke-RestMethod -Uri "http://localhost:11434/api/chat" -Method POST -ContentType "application/json" -Body $request

Write-Host "`n=== AI PROMPT OPTIMIZER ===" -ForegroundColor Cyan
Write-Host $response.message.content -ForegroundColor Green
```

**Usage:**
```powershell
.\optimize-prompt.ps1 -Prompt "a beautiful woman" -Style "photorealistic"
.\optimize-prompt.ps1 -Prompt "fantasy castle" -Style "fantasy art"
```

---

### Method 2: Python Script

Create `D:\workspace\fluxdype\prompt_optimizer.py`:

```python
#!/usr/bin/env python3
import requests
import json
import sys

def optimize_prompt(prompt, model="llama3.2", style="photorealistic"):
    system_prompt = """You are an expert AI image prompt engineer specializing in Flux models.

Optimize prompts following these rules:
1. Clear, descriptive language
2. Comma-separated keywords
3. Technical details: lighting, composition, quality
4. Include style markers and quality boosters
5. Suggest negative prompts

Output format:
OPTIMIZED PROMPT: [prompt]
NEGATIVE PROMPT: [negative]
RECOMMENDED SETTINGS:
- Sampler: [sampler]
- Steps: [steps]
- CFG: [cfg]
- Resolution: [resolution]
"""

    data = {
        "model": model,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": f"Style: {style}\nOriginal: {prompt}\n\nOptimize for Flux."}
        ],
        "stream": False
    }

    response = requests.post("http://localhost:11434/api/chat", json=data)
    result = response.json()

    print("\n" + "="*60)
    print("AI PROMPT OPTIMIZER")
    print("="*60)
    print(result['message']['content'])
    print("="*60 + "\n")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python prompt_optimizer.py 'your prompt' [style]")
        sys.exit(1)

    prompt = sys.argv[1]
    style = sys.argv[2] if len(sys.argv) > 2 else "photorealistic"

    optimize_prompt(prompt, style=style)
```

**Usage:**
```bash
cd D:\workspace\fluxdype
python prompt_optimizer.py "a beautiful woman" photorealistic
python prompt_optimizer.py "fantasy castle" "fantasy art"
```

---

### Method 3: Web Interface

Create `D:\workspace\fluxdype\prompt_helper.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Flux Prompt Optimizer</title>
    <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; }
        textarea { width: 100%; height: 100px; margin: 10px 0; padding: 10px; }
        button { background: #4CAF50; color: white; padding: 10px 20px; border: none; cursor: pointer; }
        .output { background: #f4f4f4; padding: 15px; margin: 20px 0; white-space: pre-wrap; }
    </style>
</head>
<body>
    <h1>🎨 Flux Prompt Optimizer</h1>

    <label>Original Prompt:</label>
    <textarea id="prompt" placeholder="Enter your prompt..."></textarea>

    <label>Style:</label>
    <select id="style">
        <option value="photorealistic">Photorealistic</option>
        <option value="fantasy art">Fantasy Art</option>
        <option value="anime">Anime</option>
        <option value="concept art">Concept Art</option>
        <option value="portrait">Portrait</option>
        <option value="landscape">Landscape</option>
    </select>

    <br><br>
    <button onclick="optimizePrompt()">Optimize Prompt</button>

    <div id="output" class="output" style="display:none;"></div>

    <script>
        async function optimizePrompt() {
            const prompt = document.getElementById('prompt').value;
            const style = document.getElementById('style').value;

            const systemPrompt = `You are an expert Flux prompt engineer. Optimize prompts with:
1. Clear descriptions
2. Technical details (lighting, composition)
3. Quality markers (masterpiece, highly detailed, 8k)
4. Style-appropriate keywords
5. Negative prompt suggestions

Format:
OPTIMIZED PROMPT: [prompt]
NEGATIVE PROMPT: [negative]
SETTINGS: sampler, steps, cfg`;

            const response = await fetch('http://localhost:11434/api/chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    model: 'llama3.2',
                    messages: [
                        { role: 'system', content: systemPrompt },
                        { role: 'user', content: `Style: ${style}\nPrompt: ${prompt}\n\nOptimize for Flux.` }
                    ],
                    stream: false
                })
            });

            const data = await response.json();
            document.getElementById('output').style.display = 'block';
            document.getElementById('output').textContent = data.message.content;
        }
    </script>
</body>
</html>
```

**Usage:** Open `prompt_helper.html` in your browser

---

## Pre-made Prompt Templates

### Template 1: Photorealistic Portrait
```
System: You optimize prompts for photorealistic portraits
User prompt: [description]

Output:
professional portrait photograph of [subject], [lighting] lighting,
detailed skin texture, sharp focus on eyes, shallow depth of field,
bokeh background, shot on [camera], [lens]mm lens, f/1.8,
photorealistic, 8k uhd, high quality, film grain, Fujifilm XT3

Negative: cartoon, anime, drawing, painting, blurry, low quality,
distorted, deformed, bad anatomy, extra limbs
```

### Template 2: Fantasy Art
```
epic fantasy [subject], highly detailed, intricate details,
magical atmosphere, dramatic lighting, volumetric fog,
by [artist style], trending on artstation, concept art,
digital painting, cinematic composition, 8k, masterpiece

Negative: blurry, low quality, simple, photograph, realistic,
modern, plain background
```

### Template 3: Landscape
```
breathtaking landscape of [location], [time of day],
dramatic sky, vibrant colors, sharp focus, highly detailed,
professional photography, wide angle shot, depth of field,
National Geographic style, award winning photo, 8k uhd

Negative: blurry, low quality, people, watermark, text,
cluttered, busy
```

---

## Model-Specific Prompt Engineering

### For flux_dev.safetensors
```
Focus: Natural language, descriptive
Quality terms: "high quality, detailed, sharp focus"
CFG: 3.0-3.5
Style: Works well with all styles
```

### For iniverseMixSFWNSFW models
```
Focus: Photorealism, portraits
Quality terms: "masterpiece, best quality, ultra detailed, 8k"
CFG: 3.5-4.5
Style: Realistic, cinematic
Add: Camera settings, lighting details
```

### For fluxedUpFluxNSFW
```
Focus: Character detail, composition
Quality terms: "highly detailed, professional, sharp"
CFG: 3.5-4.0
Style: Versatile
Add: Composition notes, pose descriptions
```

---

## Advanced: ComfyUI Custom Node for LLM

For direct integration, you can use existing custom nodes:

**ComfyUI-LLM-Node** (if available):
```bash
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/ModelFarm/ComfyUI-LLM-Node
# Restart ComfyUI
```

Or create your own custom node that calls Ollama API.

---

## Quick Start Guide

### 1. Install Ollama (5 minutes)
```bash
# Windows
winget install Ollama.Ollama

# Pull model
ollama pull llama3.2
```

### 2. Create Helper Script
Save the PowerShell or Python script above

### 3. Test It
```powershell
.\optimize-prompt.ps1 -Prompt "beautiful sunset" -Style "photorealistic"
```

### 4. Use with ComfyUI
1. Get optimized prompt from LLM
2. Paste into your workflow JSON
3. Run workflow

---

## Best Practices

### DO:
- ✅ Be specific and descriptive
- ✅ Include quality markers
- ✅ Mention lighting and composition
- ✅ Add style references
- ✅ Use negative prompts
- ✅ Test different phrasings

### DON'T:
- ❌ Write novels (keep prompts focused)
- ❌ Use contradictory terms
- ❌ Forget negative prompts
- ❌ Over-complicate simple concepts
- ❌ Use ALL CAPS or excessive punctuation

---

## Example Optimizations

### Before:
```
"a woman"
```

### After (LLM Optimized):
```
OPTIMIZED PROMPT: professional portrait photograph of a beautiful woman,
soft natural lighting, detailed skin texture, sharp focus on eyes,
subtle smile, flowing hair, elegant pose, shallow depth of field,
bokeh background, shot on Canon EOS R5, 85mm lens, f/1.4,
photorealistic, 8k uhd, high quality, film grain

NEGATIVE PROMPT: blurry, low quality, cartoon, anime, drawing,
distorted, deformed, bad anatomy, extra limbs, bad hands,
watermark, signature, text

RECOMMENDED SETTINGS:
- Sampler: dpmpp_2m
- Scheduler: karras
- Steps: 30
- CFG: 4.0
- Resolution: 1024x1536
```

---

## Troubleshooting

### Ollama not starting
```bash
# Check if running
curl http://localhost:11434

# Restart service
ollama serve
```

### Model too slow
- Use smaller model: `ollama pull llama3.2` (3B is faster)
- Reduce context length
- Use GPU acceleration (automatic if available)

### Bad suggestions
- Try different model
- Refine system prompt
- Provide more context in user prompt

---

## Workflow Integration

**File Locations:**
- Workflows: `D:\workspace\fluxdype/*.json`
- Scripts: `D:\workspace\fluxdype/*.ps1` or `*.py`
- Helper: `D:\workspace\fluxdype\prompt_helper.html`

**Process:**
1. Write basic idea → Run through LLM
2. Get optimized prompt → Copy to workflow JSON
3. Submit workflow → Generate image
4. Iterate based on results

---

For more information, see WORKFLOWS_GUIDE.md and FLUX_OPTIMAL_SETTINGS.md.
