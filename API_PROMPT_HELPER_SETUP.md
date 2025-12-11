# API-Based Prompt Helper (No Local VRAM)

Use cloud-based LLMs for prompt optimization without using your GPU!

---

## 🌐 Recommended: OpenRouter (Best Option)

**Why OpenRouter?**
- ✅ Access 200+ models (Claude, GPT-4, Llama, Mistral, etc.)
- ✅ No local VRAM usage
- ✅ Pay only for what you use ($0.001-$0.10 per request)
- ✅ Free tier available
- ✅ One API key for all models
- ✅ Simple setup

**Website**: https://openrouter.ai/

---

## Quick Setup Guide

### Step 1: Get API Key (2 minutes)

1. Go to https://openrouter.ai/
2. Click "Sign In" (use Google/GitHub)
3. Go to "Keys" → "Create Key"
4. Copy your API key: `sk-or-v1-...`
5. Add $5 credit (or use free tier)

### Step 2: Save API Key

Create `.env` file:
```bash
cd D:\workspace\fluxdype
echo OPENROUTER_API_KEY=sk-or-v1-your-key-here >> .env
```

Or add to existing `.env`:
```bash
OPENROUTER_API_KEY=sk-or-v1-your-actual-key-here
```

---

## 🚀 Ready-to-Use Scripts

### PowerShell Script (Windows)

Create `D:\workspace\fluxdype\optimize-prompt-api.ps1`:

```powershell
# API-Based Prompt Optimizer (No Local VRAM)
# Usage: .\optimize-prompt-api.ps1 -Prompt "your idea" -Style "photorealistic"

param(
    [Parameter(Mandatory=$true)]
    [string]$Prompt,

    [string]$Style = "photorealistic",
    [string]$Model = "anthropic/claude-3.5-sonnet"  # Fast and cheap
)

# Load API key from .env
$envFile = Join-Path $PSScriptRoot ".env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^OPENROUTER_API_KEY=(.+)$') {
            $apiKey = $matches[1]
        }
    }
}

if (-not $apiKey) {
    Write-Error "OPENROUTER_API_KEY not found in .env file"
    exit 1
}

$systemPrompt = @"
You are an expert Flux image prompt engineer. Optimize prompts following these rules:

1. Use clear, descriptive language
2. Include technical details (lighting, composition, camera settings)
3. Add quality markers: masterpiece, best quality, highly detailed, 8k
4. Match the requested style
5. Suggest optimal negative prompt
6. Recommend settings (sampler, steps, CFG)

Output format:
OPTIMIZED PROMPT: [comma-separated keywords and descriptions]

NEGATIVE PROMPT: [things to avoid]

RECOMMENDED SETTINGS:
- Model: [best Flux model for this]
- Sampler: [sampler name]
- Steps: [number]
- CFG: [value]
- Resolution: [width x height]
- LoRAs: [suggested LoRAs if applicable]
"@

$requestBody = @{
    model = $Model
    messages = @(
        @{
            role = "system"
            content = $systemPrompt
        },
        @{
            role = "user"
            content = "Style: $Style`nOriginal idea: $Prompt`n`nOptimize this for Flux image generation."
        }
    )
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod `
        -Uri "https://openrouter.ai/api/v1/chat/completions" `
        -Method POST `
        -Headers @{
            "Authorization" = "Bearer $apiKey"
            "Content-Type" = "application/json"
            "HTTP-Referer" = "https://github.com/fluxdype"
            "X-Title" = "Flux Prompt Optimizer"
        } `
        -Body $requestBody

    Write-Host "`n" -NoNewline
    Write-Host "="*70 -ForegroundColor Cyan
    Write-Host "AI PROMPT OPTIMIZER (via $Model)" -ForegroundColor Cyan
    Write-Host "="*70 -ForegroundColor Cyan
    Write-Host $response.choices[0].message.content -ForegroundColor Green
    Write-Host "="*70 -ForegroundColor Cyan
    Write-Host "`nCost: ~`$$($response.usage.total_tokens * 0.000001)" -ForegroundColor Yellow
    Write-Host ""

} catch {
    Write-Error "API request failed: $_"
    exit 1
}
```

**Usage:**
```powershell
cd D:\workspace\fluxdype

# Basic usage
.\optimize-prompt-api.ps1 -Prompt "beautiful sunset over mountains"

# With style
.\optimize-prompt-api.ps1 -Prompt "woman portrait" -Style "photorealistic"

# Different model (cheaper)
.\optimize-prompt-api.ps1 -Prompt "fantasy castle" -Model "meta-llama/llama-3.1-8b-instruct:free"
```

---

### Python Script (Cross-Platform)

Create `D:\workspace\fluxdype\optimize_prompt_api.py`:

```python
#!/usr/bin/env python3
"""
API-Based Prompt Optimizer (No Local VRAM)
Usage: python optimize_prompt_api.py "your idea" --style photorealistic
"""

import requests
import os
import sys
import argparse
from dotenv import load_dotenv

# Load .env file
load_dotenv()

SYSTEM_PROMPT = """You are an expert Flux image prompt engineer. Optimize prompts following these rules:

1. Use clear, descriptive language
2. Include technical details (lighting, composition, camera settings)
3. Add quality markers: masterpiece, best quality, highly detailed, 8k
4. Match the requested style
5. Suggest optimal negative prompt
6. Recommend settings (sampler, steps, CFG)

Output format:
OPTIMIZED PROMPT: [comma-separated keywords and descriptions]

NEGATIVE PROMPT: [things to avoid]

RECOMMENDED SETTINGS:
- Model: [best Flux model for this]
- Sampler: [sampler name]
- Steps: [number]
- CFG: [value]
- Resolution: [width x height]
- LoRAs: [suggested LoRAs if applicable]
"""

def optimize_prompt(prompt, style="photorealistic", model="anthropic/claude-3.5-sonnet"):
    api_key = os.getenv("OPENROUTER_API_KEY")

    if not api_key:
        print("Error: OPENROUTER_API_KEY not found in .env file")
        sys.exit(1)

    data = {
        "model": model,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": f"Style: {style}\nOriginal idea: {prompt}\n\nOptimize this for Flux image generation."}
        ]
    }

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/fluxdype",
        "X-Title": "Flux Prompt Optimizer"
    }

    try:
        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers=headers,
            json=data
        )
        response.raise_for_status()
        result = response.json()

        print("\n" + "="*70)
        print(f"AI PROMPT OPTIMIZER (via {model})")
        print("="*70)
        print(result['choices'][0]['message']['content'])
        print("="*70)

        # Show cost
        tokens = result.get('usage', {}).get('total_tokens', 0)
        cost = tokens * 0.000001  # Rough estimate
        print(f"\nCost: ~${cost:.6f}")
        print()

    except requests.exceptions.RequestException as e:
        print(f"API request failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Optimize Flux prompts using AI")
    parser.add_argument("prompt", help="Your prompt idea")
    parser.add_argument("--style", default="photorealistic", help="Image style")
    parser.add_argument("--model", default="anthropic/claude-3.5-sonnet", help="Model to use")

    args = parser.parse_args()
    optimize_prompt(args.prompt, args.style, args.model)
```

**Usage:**
```bash
cd D:\workspace\fluxdype

# Basic usage
python optimize_prompt_api.py "beautiful sunset"

# With options
python optimize_prompt_api.py "fantasy castle" --style "fantasy art"

# Free model
python optimize_prompt_api.py "portrait" --model "meta-llama/llama-3.1-8b-instruct:free"
```

---

## 🤖 Recommended Models

### Best Quality (Paid)
```
anthropic/claude-3.5-sonnet        ~$0.003/request  ⭐ RECOMMENDED
openai/gpt-4-turbo                 ~$0.010/request
google/gemini-pro-1.5              ~$0.002/request
```

### Good Quality (Cheap)
```
anthropic/claude-3-haiku           ~$0.0005/request ⭐ BEST VALUE
meta-llama/llama-3.1-8b-instruct   ~$0.0001/request
mistralai/mistral-7b-instruct      ~$0.0001/request
```

### Free Models
```
meta-llama/llama-3.1-8b-instruct:free  FREE ⭐ START HERE
google/gemma-2-9b-it:free              FREE
mistralai/mistral-7b-instruct:free     FREE
```

---

## Alternative API Services

### Option 2: OpenAI (GPT-4)

**Setup:**
```bash
# Get key from https://platform.openai.com/api-keys
echo OPENAI_API_KEY=sk-... >> .env
```

**PowerShell:**
```powershell
$response = Invoke-RestMethod `
    -Uri "https://api.openai.com/v1/chat/completions" `
    -Method POST `
    -Headers @{
        "Authorization" = "Bearer $env:OPENAI_API_KEY"
        "Content-Type" = "application/json"
    } `
    -Body (@{
        model = "gpt-4o-mini"  # Cheaper than GPT-4
        messages = @(
            @{role = "system"; content = $systemPrompt},
            @{role = "user"; content = $userPrompt}
        )
    } | ConvertTo-Json -Depth 10)
```

**Cost**: ~$0.0001-0.001 per request (GPT-4o-mini)

---

### Option 3: Anthropic Claude (Direct)

**Setup:**
```bash
# Get key from https://console.anthropic.com/
echo ANTHROPIC_API_KEY=sk-ant-... >> .env
```

**PowerShell:**
```powershell
$response = Invoke-RestMethod `
    -Uri "https://api.anthropic.com/v1/messages" `
    -Method POST `
    -Headers @{
        "x-api-key" = $env:ANTHROPIC_API_KEY
        "anthropic-version" = "2023-06-01"
        "Content-Type" = "application/json"
    } `
    -Body (@{
        model = "claude-3-haiku-20240307"
        max_tokens = 1024
        messages = @(@{role = "user"; content = $userPrompt})
    } | ConvertTo-Json -Depth 10)
```

**Cost**: ~$0.00025 per request (Haiku)

---

### Option 4: Google AI (Gemini)

**Setup:**
```bash
# Get key from https://makersuite.google.com/app/apikey
echo GOOGLE_API_KEY=... >> .env
```

**PowerShell:**
```powershell
$response = Invoke-RestMethod `
    -Uri "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$env:GOOGLE_API_KEY" `
    -Method POST `
    -Headers @{"Content-Type" = "application/json"} `
    -Body (@{
        contents = @(@{parts = @(@{text = $userPrompt})})
    } | ConvertTo-Json -Depth 10)
```

**Cost**: FREE (generous quota)

---

## 💰 Cost Comparison

| Service | Model | Cost/Request | Quality |
|---------|-------|--------------|---------|
| **OpenRouter** | Llama 3.1 8B (free) | $0 | Good |
| **OpenRouter** | Claude Haiku | ~$0.0005 | Excellent ⭐ |
| **OpenRouter** | Claude Sonnet | ~$0.003 | Best |
| **OpenAI** | GPT-4o-mini | ~$0.001 | Excellent |
| **Google** | Gemini Pro | FREE | Good |
| **Anthropic** | Claude Haiku | ~$0.00025 | Excellent |

**Recommendation**: Start with **OpenRouter + free Llama model**, upgrade to Claude Haiku if needed.

---

## 📦 Install Dependencies

```powershell
cd D:\workspace\fluxdype
.\venv\Scripts\Activate.ps1

# Python script dependencies
pip install requests python-dotenv

# Or install all at once
pip install requests python-dotenv openai anthropic
```

---

## 🎯 Quick Start (5 Minutes)

### 1. Get OpenRouter API Key
```
1. Visit https://openrouter.ai/
2. Sign in with Google/GitHub
3. Go to "Keys" → Create key
4. Copy key: sk-or-v1-...
```

### 2. Save API Key
```powershell
cd D:\workspace\fluxdype
echo OPENROUTER_API_KEY=sk-or-v1-your-key >> .env
```

### 3. Create Script
Save the PowerShell or Python script above

### 4. Test It
```powershell
# PowerShell
.\optimize-prompt-api.ps1 -Prompt "beautiful landscape"

# Python
python optimize_prompt_api.py "beautiful landscape"
```

### 5. Use with ComfyUI
```powershell
# Get optimized prompt
.\optimize-prompt-api.ps1 -Prompt "fantasy castle"

# Copy the OPTIMIZED PROMPT output
# Paste into your workflow JSON
# Run workflow
.\test-workflow.ps1 -WorkflowFile "flux_quality_stack.json"
```

---

## 🔧 Advanced Usage

### Batch Optimize Multiple Prompts

```powershell
# Create batch-optimize.ps1
$prompts = @(
    "beautiful woman portrait",
    "fantasy castle landscape",
    "cyberpunk city night",
    "serene mountain lake"
)

foreach ($prompt in $prompts) {
    Write-Host "`n### Optimizing: $prompt" -ForegroundColor Yellow
    .\optimize-prompt-api.ps1 -Prompt $prompt
    Start-Sleep -Seconds 1  # Rate limiting
}
```

### Save Optimized Prompts to File

```powershell
.\optimize-prompt-api.ps1 -Prompt "your idea" | Out-File -Append optimized_prompts.txt
```

### Integration with Workflow

```python
# auto_generate.py
import json
import subprocess

# Get optimized prompt
result = subprocess.run(
    ['python', 'optimize_prompt_api.py', 'beautiful sunset'],
    capture_output=True, text=True
)

# Parse output and extract OPTIMIZED PROMPT
optimized = result.stdout.split('OPTIMIZED PROMPT:')[1].split('NEGATIVE')[0].strip()

# Update workflow
with open('flux_quality_stack.json', 'r') as f:
    workflow = json.load(f)

# Update prompt in workflow
workflow['4']['inputs']['text'] = optimized

# Save and run
with open('auto_workflow.json', 'w') as f:
    json.dump(workflow, f, indent=2)

# Submit to ComfyUI
import requests
requests.post('http://localhost:8188/prompt', json={'prompt': workflow})
```

---

## 🛡️ Security Best Practices

1. **Never commit .env to git** (already in .gitignore)
2. **Use separate API keys** for different projects
3. **Set spending limits** on API dashboards
4. **Monitor usage** regularly
5. **Rotate keys** if compromised

---

## 📊 Expected Performance

**Request Time**: 1-3 seconds
**VRAM Usage**: 0 MB (all cloud-based)
**Cost per day** (100 prompts): ~$0.05-0.50
**Quality**: Excellent, often better than local models

---

## ❓ Troubleshooting

### "API key not found"
→ Check .env file exists and contains `OPENROUTER_API_KEY=sk-or-v1-...`

### "Insufficient credits"
→ Add credits at https://openrouter.ai/credits

### "Rate limit exceeded"
→ Add delays between requests (`Start-Sleep -Seconds 1`)

### "Model not found"
→ Check model name at https://openrouter.ai/models

---

## 🎉 Ready to Use!

You now have:
- ✅ No local VRAM usage
- ✅ Access to best AI models
- ✅ Pay only for what you use
- ✅ Easy PowerShell + Python scripts
- ✅ Integration with ComfyUI workflows

**Next Steps:**
1. Get OpenRouter API key
2. Save to .env
3. Run: `.\optimize-prompt-api.ps1 -Prompt "your idea"`
4. Copy optimized prompt to workflow
5. Generate amazing images!

For more information:
- **OpenRouter Docs**: https://openrouter.ai/docs
- **Model Pricing**: https://openrouter.ai/models
- **Flux Workflows**: WORKFLOWS_INDEX.md
