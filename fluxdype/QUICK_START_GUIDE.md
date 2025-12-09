# FluxDype Portrait Studio - Quick Start Guide

**Get generating professional portraits in 5 minutes!**

---

## ⚡ 5-Minute Quick Start

### Step 1: Start ComfyUI (1 min)
```powershell
cd D:\workspace\fluxdype
.\start-comfy.ps1
# Wait for: "listening on 0.0.0.0:8188"
```

### Step 2: Open Interface (30 seconds)
- Open browser: http://localhost:8188
- You should see the ComfyUI canvas

### Step 3: Load Workflow (1 min)
1. Click **Load** button (top left)
2. Select: `flux_portrait_studio_enhanced.json`
3. Workflow appears with nodes

### Step 4: Configure Settings (1.5 min)
**Select Model:**
- Change dropdown from default to: `flux_dev.safetensors` OR `flux1-krea-dev_fp8_scaled.safetensors`

**Choose LoRA Preset:**
- Click **"Portrait Professional"** button
  - (Applies: ultrafluxV1 + fluxInstaGirlsV2 + facebookQuality)

**Set Size:**
- Width: 1024
- Height: 1024

### Step 5: Enter Prompt (1 min)
**Option A - Use Sample Prompt:**
Copy from PROMPT_LIBRARY.md, Prompt #1:
```
A fresh-faced young woman in her mid-twenties with warm brown eyes
and natural skin, blonde waves framing her face, subtle makeup with
peachy tones. Wearing a soft cream linen blouse. Shot during golden hour
with warm sunlight illuminating her face, creating soft shadows on her
neck. Professional portrait photography, shot with 85mm lens, f/2.8 aperture,
shallow depth of field. Sharp focus on eyes, soft bokeh background with
warm golden tones. Skin texture visible but flattering, natural beauty
enhancing, studio quality, high resolution detailed face, professional
lighting, magazine cover worthy.
```

**Option B - Use LLM Enhancement:**
1. Click **LLM Prompt Enhancer** node
2. Type: `a young woman portrait`
3. Select style: `portrait_photography`
4. LLM automatically creates detailed prompt

### Step 6: Generate! (20-30 seconds)
1. Click **"Queue Prompt"** (bottom left, red button)
2. Progress appears in console
3. Image generates and appears in preview panel
4. **That's it! Your first portrait is done!**

---

## 🎯 Common Tasks

### Generate Multiple Images Quickly
1. Keep everything same
2. Change **seed** number in KSampler node
3. Click Queue Prompt again
4. Each image: 20-30 seconds

### Try Different LoRA Stacks
**Button Presets:**
- **Portrait Professional** - Best for clean, magazine-quality portraits
- **Style Enhancement** - Instagram aesthetic, more stylized
- **Quality Maximum** - Highest quality output
- **Realism Focus** - Maximum photorealism

Or manually adjust weights in LoRA Stacker node (0.0-1.0 each)

### Adjust Image Size
- **768x768** - Faster (15 seconds), good quality
- **1024x1024** - Balanced (20 seconds), excellent quality
- **1536x1536** - Highest quality (30 seconds), slow

### Increase Quality
**Option 1: More Steps**
- Change Steps: 20 → 30
- Adds ~10 seconds but better detail

**Option 2: Change CFG**
- Default: 3.5 (perfect for Flux)
- Higher (4.0) = more prompt adherence
- Lower (3.0) = more creativity

### Try NSFW Content
1. In LoRA Stacker, add: `KREAnsfwv2` or `FluXXXv2`
2. Set weight: 0.7-0.9
3. Include "nsfw" or "explicit" in prompt
4. Generate normally

---

## 📚 Using the Prompt Library

### Available Prompts
All 10 in **PROMPT_LIBRARY.md**:

1. **Fresh Natural Headshot** - Golden hour, professional
2. **Candid Outdoor Portrait** - Garden, lifestyle
3. **Studio Minimalist** - Clean, high-fashion
4. **Editorial Beauty Shot** - Dramatic, bold makeup
5. **Casual Modern Style** - Instagram-ready
6. **Moody Art Direction** - Artistic, atmospheric
7. **Romantic Soft Focus** - Dreamy, soft
8. **Bold Makeup & Expression** - Confident, colorful
9. **Minimalist & Serene** - Peaceful, zen
10. **Joyful Candid Movement** - Dynamic, happy

### How to Use Them
1. Open **PROMPT_LIBRARY.md**
2. Copy entire prompt text
3. Paste into **"Positive Prompt"** node
4. Use recommended LoRA stack for that prompt
5. Generate!

### Customize Prompts
- Replace "young woman" with specific description
- Change clothing/styling
- Swap lighting (golden hour → studio, etc.)
- Modify mood/expression
- Mix and match elements from different prompts

---

## LoRA Guide

### Quick Reference
**Quality Boosters:**
- `ultrafluxV1` (0.7-0.9) - General quality
- `facebookQuality` (0.5-0.7) - Social media optimization

**Style Enhancers:**
- `fluxInstaGirlsV2` (0.6-0.8) - Instagram portraits

**Detail Enhancers:**
- `DetailTweaker_SDXL` (0.5-0.7) - Fine details
- `SuperEyeDetailer` (0.4-0.6) - Eye details

**Realism:**
- `Realism_Lora_By_Stable_Yogi_V2` (0.6-0.8) - Photorealism

### How to Use Multiple LoRAs
1. Open **LoRA Stacker** node
2. Each row = one LoRA
3. First dropdown = LoRA filename
4. Slider = weight (0.0-1.0)
5. Higher weight = stronger effect

**Example Stack:**
- Row 1: ultrafluxV1 → 0.7
- Row 2: fluxInstaGirlsV2 → 0.6
- Row 3: facebookQuality → 0.5

### Total Influence
Adding weights: 0.7 + 0.6 + 0.5 = 1.8 (good for Flux)
- 1.0-1.5 = moderate
- 1.5-2.0 = strong but safe
- 2.0+ = very strong, may cause artifacts

---

## 🚀 Advanced Features

### Enable LLM Prompt Enhancement
**Free Option (Ollama):**
1. Download Ollama: https://ollama.ai
2. Open terminal: `ollama serve`
3. In another terminal: `ollama pull mistral`
4. In ComfyUI, LLM node auto-connects

**Paid Option (Better Quality):**
1. Get OpenRouter API key: https://openrouter.ai
2. Add to `.env` file:
   ```
   OPENROUTER_API_KEY=sk-or-your-key
   ```
3. Restart ComfyUI
4. Select model: "anthropic/claude-3.5-sonnet" (recommended)

### Using LLM Node
1. Type basic prompt: `a young woman portrait`
2. Select style: `portrait_photography`
3. Click node title to execute
4. LLM expands to full detailed prompt
5. Copy expanded prompt to Positive Prompt node
6. Generate normally

---

## Troubleshooting

### "Model not found" error
- Check: `D:\workspace\fluxdype\ComfyUI\models\diffusion_models\`
- Verify filename matches exactly in node

### "CLIP not found"
- Ensure `clip_l.safetensors` and `t5xxl_fp16.safetensors` exist
- They should be in `models\text_encoders\`

### "VAE not found"
- Ensure `ae.safetensors` exists in `models\vae\`

### Generation is very slow (>1 minute)
- Check GPU usage: Task Manager → Performance
- Try smaller size (768x768)
- Reduce steps (20 instead of 30)
- Check if other apps using GPU

### Image quality is bad
- Increase steps (20 → 30)
- Use better LoRA stack
- Use longer, more detailed prompt
- Try different sampler (euler, dpmpp, heun)

### LLM node returns error
- Check API key in `.env`
- Verify Ollama is running if using local
- Test with simple prompt: "test"

---

## Performance Tips

### Generate Faster
- Use 768x768 size (instead of 1024)
- Use 20 steps (instead of 30)
- Use simpler prompts (100 tokens instead of 150)
- Use fewer/lighter LoRAs

### Generate Better
- Use 1024x1024 or 1536x1536
- Use 30 steps
- Use detailed prompts with photographic terms
- Stack 2-3 quality LoRAs
- Use LLM enhancement

### Batch Generate
1. Queue multiple prompts by:
   - Changing seed, then Queue
   - Changing LoRA weights, then Queue
   - Changing prompt, then Queue
2. All queue in sequence
3. Check output folder for all images

---

## File Locations

```
D:\workspace\fluxdype\
├── PROMPT_LIBRARY.md (read this for sample prompts)
├── LORA_REGISTRY.json (reference for all LoRAs)
├── QUICK_START_GUIDE.md (this file)
├── ComfyUI/
│   ├── workflows/
│   │   └── flux_portrait_studio_enhanced.json (main workflow)
│   ├── models/
│   │   ├── diffusion_models/ (Flux models)
│   │   ├── text_encoders/ (CLIP models)
│   │   └── vae/ (VAE models)
│   └── output/ (generated images save here)
└── .env (API keys - not in git)
```

---

## Next Steps After Your First Generation

### If Image Quality is Good:
1. Try other prompts from PROMPT_LIBRARY.md
2. Experiment with different LoRA stacks
3. Adjust CFG and steps
4. Save your best settings

### If You Want Better Quality:
1. Use 30 steps instead of 20
2. Stack multiple quality LoRAs
3. Use longer, more detailed prompts
4. Try different image sizes

### If You Want to Explore More:
1. Read **PROMPT_LIBRARY.md** for prompt engineering
2. Check **LORA_REGISTRY.json** for all available LoRAs
3. Try NSFW LoRAs if desired
4. Download Q8 GGUF models for 50% smaller files

---

## FAQ

**Q: How long does generation take?**
A: 20-30 seconds total on RTX 3090. Slower on older GPUs.

**Q: Can I generate multiple images at once?**
A: Yes, queue multiple times with different settings.

**Q: Can I use NSFW LoRAs?**
A: Yes, add KREAnsfwv2 or FluXXXv2 to LoRA stack.

**Q: Can I download the images?**
A: Yes, check `ComfyUI/output/` folder after generation.

**Q: Can I save my custom settings?**
A: Yes, use Save Workflow button to save .json file.

**Q: Is there an LLM to help with prompts?**
A: Yes, use LLM Prompt Enhancer node or set up Ollama.

**Q: What's the difference between models?**
A: All work well. Flux Dev = quality, Flux Kria FP8 = faster.

**Q: Can I batch generate 100 images?**
A: Yes, queue 100 times. Will take ~50 minutes on RTX 3090.

---

## Getting Help

**If something breaks:**
1. Check file paths (copy from this guide)
2. Restart ComfyUI: `.\start-comfy.ps1`
3. Check .env file for typos
4. Look in console for error messages

**For prompts:**
- Read PROMPT_LIBRARY.md for guidelines
- Try simpler prompts first
- Add photographic terms (lens, lighting, aperture)

**For LoRAs:**
- Check LORA_REGISTRY.json for recommendations
- Start with single LoRA at 0.7 weight
- Add more LoRAs if desired

---

## You're All Set! 🎉

**You can now:**
- ✅ Generate professional portraits in 20-30 seconds
- ✅ Use 10 sample prompts optimized for young women
- ✅ Stack multiple LoRAs with one click
- ✅ Enhance prompts with AI (optional)
- ✅ Save and reuse your favorite settings

**Start generating now:**
1. Run `.\start-comfy.ps1`
2. Open http://localhost:8188
3. Load `flux_portrait_studio_enhanced.json`
4. Pick a prompt from PROMPT_LIBRARY.md
5. Click "Queue Prompt"
6. **Enjoy your first AI portrait!**

---

**Last Updated:** November 2025
**For:** FluxDype ComfyUI Setup with RTX 3090
**Models:** Flux.1-dev, Flux Kria, GGUF Q8 variants
