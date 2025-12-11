# Fast Iteration Workflow - Turbo Setup

**Generate test prompts in 5-10 seconds, then upscale winners later!**

---

## 🚀 Speed Improvements

### Before (Quality Workflow)
- 30 steps, 1024x1024 = **25-35 seconds per image**
- Heavy resource usage
- Waiting between prompts

### After (Turbo Workflow)
- 4 steps, 512x512 = **5-10 seconds per image**
- 3-5x faster generation
- Generate 10 prompts in ~1 minute
- Use LLM to auto-generate prompts (no waiting on VRAM)

---

## 📋 Two-Workflow Strategy

### Workflow 1: TURBO (Rapid Iteration)
**File**: `flux_portrait_turbo_fast.json`
- **Speed**: 5-10 seconds per image
- **Steps**: 4
- **Size**: 512x512
- **LoRA**: DMD2 4-Step (turbo)
- **Use For**: Testing prompts, exploring variations, quick previews

### Workflow 2: QUALITY (Final Renders)
**File**: `flux_portrait_studio_enhanced.json`
- **Speed**: 25-35 seconds per image
- **Steps**: 30
- **Size**: 1024x1024
- **LoRAs**: Triple stack (quality + style + social)
- **Use For**: Final images, portfolio, highest quality

---

## 🎯 Fast Workflow Instructions

### Step 1: Load Turbo Workflow
1. Open http://localhost:8188
2. Click **Load**
3. Select **flux_portrait_turbo_fast.json**

### Step 2: Generate Fast Preview
**Option A - Use Sample Prompt:**
1. Copy a short prompt from PROMPT_LIBRARY.md
2. Paste into "Positive Prompt" node
3. Change seed if you want variations
4. Click **Queue Prompt**
5. **Result in 5-10 seconds!** ⚡

**Option B - Generate with LLM (No Local VRAM!):**
1. Use the LLM Prompt Enhancer (instructions below)
2. It will auto-enhance your prompt via API
3. Paste result into "Positive Prompt" node
4. Generate

### Step 3: When You Like It
Once you like a turbo preview:
1. **Switch to quality workflow** (flux_portrait_studio_enhanced.json)
2. Copy the same prompt
3. Generate at full quality (1024x1024, 30 steps)
4. Perfect final image!

---

## 🧠 LLM Prompt Generator Setup (OpenRouter API)

This lets you generate prompts without using your GPU VRAM!

### Step 1: Get OpenRouter API Key
1. Go to: https://openrouter.ai
2. Sign up (free tier available)
3. Click **Keys** in sidebar
4. Copy your API key

### Step 2: Configure .env File
1. Open `D:\workspace\fluxdype\.env` (create if doesn't exist)
2. Add this line:
```
OPENROUTER_API_KEY=sk-or-your-api-key-here
```
3. Replace `sk-or-your-api-key-here` with your actual key
4. Save and close

### Step 3: Add LLM Node to Workflow (Optional)
In ComfyUI, you can add the LLM Prompt Enhancer node:

1. Right-click on canvas
2. **Add Node** → Search for "LLM"
3. Select **LLM Prompt Enhancer**
4. Configure:
   - **Input**: Your short prompt (e.g., "young woman portrait")
   - **Style**: `portrait_photography`
   - **Provider**: `openrouter`
   - **Model**: `anthropic/claude-3.5-sonnet` (recommended)
5. Run it - it creates a full detailed prompt
6. Copy the output to "Positive Prompt" node

### Step 4: Use LLM-Generated Prompts
```
Your input: "a young woman in casual style"
          ↓ (LLM processes via OpenRouter)
LLM output: "A striking young woman in her early twenties with warm
brown eyes, natural sun-kissed complexion, wearing a trendy oversized
sweater and gold chain jewelry. Shot in natural window light with soft
directional sunlight creating flattering shadows. Modern lifestyle
photography, warm color grading, shallow depth of field, Instagram
aesthetic, professional quality, detailed facial features, authentic
moment, beautiful natural lighting."
          ↓ (Paste into workflow)
Generate with turbo (5-10 sec) → See if you like it
```

---

## ⚡ Workflow Speed Comparison

| Setting | Speed | Quality | Use Case |
|---------|-------|---------|----------|
| **Turbo (4 steps, 512x512)** | 5-10s | 60% | Testing prompts |
| **Balanced (20 steps, 1024x1024)** | 20-25s | 85% | Experimenting |
| **Quality (30 steps, 1024x1024)** | 25-35s | 95%+ | Final render |

---

## 💡 Pro Tips for Fast Iteration

### Prompt Engineering Fast
1. Start with **1-3 word concept**: "professional headshot"
2. Let LLM expand it (30 seconds, free)
3. Generate with turbo (5 seconds)
4. Like it? → Generate with quality (30 seconds)
5. Done! Total: 1-2 minutes per final image

### Batch Testing
```
Generate 20 turbo previews (15-20 minutes) →
Review and pick 3 winners →
Generate each at quality (1-2 minutes total) →
3 professional images in ~25 minutes!
```

### Change Only Prompt
- Turbo workflow pre-configured
- Just edit "Positive Prompt" node text
- Keep seed, LoRA, settings same for consistency
- Queue multiple times for variations

---

## 🔧 Turbo Workflow Settings

**Optimized for Speed:**
```
Model: FluxedUp NSFW (FP16)
LoRA: DMD2 4-Step Turbo (1.0 weight)
Image Size: 512x512 (small = fast)
Steps: 4 (minimum for Flux)
CFG: 2.5 (lower = faster, creative)
Sampler: euler
Scheduler: simple
Denoise: 1.0
```

**Why these settings?**
- **4 steps**: Minimum for Flux quality, with turbo LoRA
- **512x512**: 1/4 pixels = 1/4 time
- **CFG 2.5**: Lower = faster, still respects prompts
- **simple scheduler**: Fastest scheduling option
- **DMD2 4-step LoRA**: Specialized for 4-step generation

---

## 📊 Real-World Workflow

**Scenario: Create 5 professional portraits in 30 minutes**

```
Time | Action | Duration
-----|--------|----------
0m   | Open turbo workflow | -
0m   | Use LLM to generate prompt 1 | 1m
1m   | Turbo generate image 1 | 10s
2m   | Review + use LLM for prompt 2 | 1m
3m   | Turbo generate images 2-3 (queue 2) | 20s
4m   | Review + use LLM for prompt 3 | 1m
5m   | Turbo generate images 4-5 (queue 2) | 20s
6m   | Review all 5, pick best 3 | 2m
8m   | Switch to quality workflow | -
8m   | Generate best 3 at full quality | 3m
11m  | DONE! 3 professional portraits | -
```

**Total: 11 minutes for 3 portfolio-ready images!**

---

## 🎨 Quality Upscaling (Optional)

For final images, you can upscale 512x512 → 1024x1024:

1. Take best turbo preview
2. Add **Upscaler node** to workflow
3. Use ESRGAN or RealESRGAN
4. Results: Sharp 1024x1024 from fast 512x512

---

## 📝 Example Workflow

### Fast Iteration Session:
```
Prompt idea: "woman in business casual"
             ↓
Use LLM via OpenRouter (no local VRAM!)
↓
Generate with turbo (5-10 seconds)
↓
Like it? YES → Generate at quality (30 seconds)
           NO → Change prompt, try again (5 seconds)
```

### Key Advantage:
- **LLM runs on OpenRouter servers** (not your GPU)
- **Turbo generation uses your GPU optimally**
- **You spend <1 minute waiting per final image**

---

## ⚙️ If LLM Node Doesn't Work

The LLM Prompt Enhancer may need configuration. Alternative:
1. Use **PROMPT_LIBRARY.md** for ready-made prompts
2. Modify them manually (still faster than waiting 30s)
3. LLM is optional - turbo workflow works without it!

---

## 🚀 Next Steps

1. **Load turbo workflow**: `flux_portrait_turbo_fast.json`
2. **Test 5-10 prompts** from PROMPT_LIBRARY.md
3. **Pick best one**
4. **Switch to quality workflow** for final render
5. **Done in 2-3 minutes!**

---

**Remember**:
- Turbo = Fast testing (5-10 sec)
- Quality = Final image (25-35 sec)
- LLM = Unlimited prompts without GPU cost

Let's generate! ⚡
