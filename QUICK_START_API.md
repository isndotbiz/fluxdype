# Quick Start: API Prompt Helper (5 Minutes)

**No local VRAM needed!** Use cloud AI to optimize your prompts.

---

## 🚀 Setup (2 minutes)

### Step 1: Get Free API Key
1. Visit **https://openrouter.ai/**
2. Click "Sign In" (Google/GitHub)
3. Go to **Keys** → **Create Key**
4. Copy your key: `sk-or-v1-...`

### Step 2: Add to .env File
```powershell
cd D:\workspace\fluxdype
notepad .env
```

Add this line:
```
OPENROUTER_API_KEY=sk-or-v1-paste-your-actual-key-here
```

Save and close.

---

## 💡 Usage (30 seconds)

### PowerShell (Recommended)
```powershell
cd D:\workspace\fluxdype

# Basic usage
.\optimize-prompt-api.ps1 -Prompt "beautiful sunset over mountains"

# With style
.\optimize-prompt-api.ps1 -Prompt "woman portrait" -Style "photorealistic"

# Fantasy art
.\optimize-prompt-api.ps1 -Prompt "magical castle" -Style "fantasy art"
```

### Python
```bash
cd D:\workspace\fluxdype

# Basic usage
python optimize_prompt_api.py "beautiful sunset"

# With style
python optimize_prompt_api.py "woman portrait" --style photorealistic

# Different model (free!)
python optimize_prompt_api.py "castle" --model "meta-llama/llama-3.1-8b-instruct:free"
```

---

## 📋 Complete Workflow

```powershell
# 1. Optimize your prompt
.\optimize-prompt-api.ps1 -Prompt "cyberpunk street scene at night"

# 2. Copy the OPTIMIZED PROMPT from output

# 3. Edit workflow (or use as-is)
notepad flux_quality_stack.json
# Paste optimized prompt into the "text" field

# 4. Generate image
.\test-workflow.ps1 -WorkflowFile "flux_quality_stack.json"

# 5. Check output
# Images in: D:\workspace\fluxdype\ComfyUI\output\
```

---

## 💰 Cost

**FREE Models** (Start here):
```powershell
# Use completely free models
.\optimize-prompt-api.ps1 -Prompt "idea" -Model "meta-llama/llama-3.1-8b-instruct:free"
```

**Paid Models** (Better quality):
- Claude Haiku: ~$0.0005/request (excellent, cheap) ⭐
- Claude Sonnet: ~$0.003/request (best quality)
- GPT-4o-mini: ~$0.001/request

**Daily cost** (100 prompts with free model): **$0**
**Daily cost** (100 prompts with Claude Haiku): **~$0.05**

---

## 🎯 Example Output

### Input:
```powershell
.\optimize-prompt-api.ps1 -Prompt "woman in red dress"
```

### Output:
```
======================================================================
AI PROMPT OPTIMIZER
======================================================================
OPTIMIZED PROMPT: professional portrait photograph of an elegant woman
wearing a flowing red dress, soft natural lighting, detailed fabric
texture, sharp focus on face, shallow depth of field, bokeh background,
photorealistic, 8k uhd, high quality, cinematic composition, shot on
Canon EOS R5, 85mm lens, f/1.4

NEGATIVE PROMPT: blurry, low quality, cartoon, anime, distorted,
deformed, bad anatomy, extra limbs, watermark, signature, text,
bad hands, poorly drawn

RECOMMENDED SETTINGS:
- Model: iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369
- Sampler: dpmpp_2m
- Scheduler: karras
- Steps: 30
- CFG: 4.0
- Resolution: 1024x1536
- LoRAs: ultrafluxV1 (0.7), facebookQuality (0.5)
======================================================================

Tokens used: 234 | Estimated cost: ~$0.000234
```

---

## 🔧 Alternative API Services

### Use OpenAI GPT-4
```powershell
# Get key from https://platform.openai.com/api-keys
# Add to .env: OPENAI_API_KEY=sk-...

# Edit optimize-prompt-api.ps1, change:
# -Model "openai/gpt-4o-mini"
```

### Use Google Gemini (FREE)
```powershell
# Get key from https://makersuite.google.com/app/apikey
# Add to .env: GOOGLE_API_KEY=...

# Edit script to use Google API
# See API_PROMPT_HELPER_SETUP.md for details
```

### Use Anthropic Claude Direct
```powershell
# Get key from https://console.anthropic.com/
# Add to .env: ANTHROPIC_API_KEY=sk-ant-...

# More expensive but excellent quality
```

---

## ❓ Troubleshooting

### "API key not found"
→ Check `.env` file contains `OPENROUTER_API_KEY=sk-or-v1-...`

### "Insufficient credits"
→ Add $5 at https://openrouter.ai/credits (lasts a long time)

### "Request failed"
→ Check internet connection and API key validity

### Want to use FREE models?
```powershell
.\optimize-prompt-api.ps1 -Prompt "idea" -Model "meta-llama/llama-3.1-8b-instruct:free"
```

---

## 📊 Model Comparison

| Model | Cost | Speed | Quality | Recommended |
|-------|------|-------|---------|-------------|
| Llama 3.1 (free) | $0 | 2s | Good | ✅ Start |
| Claude Haiku | $0.0005 | 1s | Excellent | ⭐ Best |
| Claude Sonnet | $0.003 | 2s | Best | 💎 Premium |
| GPT-4o-mini | $0.001 | 1s | Excellent | ✅ Good |

---

## 🎉 You're Ready!

**Everything is set up!** Just:
1. Get OpenRouter API key
2. Add to `.env`
3. Run: `.\optimize-prompt-api.ps1 -Prompt "your idea"`
4. Copy optimized prompt
5. Generate amazing images!

**Files Created:**
- `optimize-prompt-api.ps1` - PowerShell script
- `optimize_prompt_api.py` - Python script
- `API_PROMPT_HELPER_SETUP.md` - Complete guide
- `.env` - API key storage (add your key here!)

**Get Started:**
https://openrouter.ai/ → Get API key → Save to .env → Done!

---

For complete details, see **API_PROMPT_HELPER_SETUP.md**
