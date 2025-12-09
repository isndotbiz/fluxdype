# Workflow Quick Start Guide

Your workflows are ready with all LoRAs preinstalled! Here's how to use them with PROMPT_LIBRARY.md

---

## 3 Workflows Available

| Workflow | Speed | Quality | Use For |
|----------|-------|---------|---------|
| **flux_prompt_library_fast.json** | 15-20 sec | Good | Testing ideas, quick iterations |
| **flux_prompt_library_quality.json** | 30-40 sec | Excellent | Final images, portfolio |
| **flux_portrait_turbo_fast.json** | 10-15 sec | Medium | Ultra-fast testing |

---

## How to Use

### Step 1: Load Workflow
1. Open http://localhost:8188
2. Click **Load**
3. Select your workflow

### Step 2: Copy Prompt from Library
1. Open `PROMPT_LIBRARY.md`
2. Copy entire prompt text (e.g., "A fresh-faced young woman in her mid-twenties...")
3. Click the ✏️ **EDIT YOUR PROMPT HERE** node in the workflow
4. Paste prompt

### Step 3: Generate
1. Click **Queue Prompt**
2. Wait for image
3. Result appears in preview

---

## Recommended Workflow Selection

**Fresh Start?**
→ Use `flux_prompt_library_fast.json`

**Testing Prompt Ideas?**
→ Use `flux_prompt_library_fast.json` (12 steps, 768x768)

**Want Magazine Quality?**
→ Use `flux_prompt_library_quality.json` (20 steps, 1024x1024, triple LoRA)

**Just Want Super Fast?**
→ Use `flux_portrait_turbo_fast.json` (8 steps, 768x768)

---

## LoRAs Installed & Ready

✓ **ultrafluxV1.aWjp.safetensors** - General quality booster
✓ **fluxInstaGirlsV2.dbl2.safetensors** - Natural, lifestyle style
✓ **facebookQuality.3t4R.safetensors** - Crisp, detailed look

All workflows have these preloaded!

---

## Tips

- **Seed**: Change number in "GENERATE" node for variations of same prompt
- **Steps**: More steps = better quality but slower
  - 8 steps = 10-15 sec (fast)
  - 12 steps = 15-20 sec (balanced)
  - 20 steps = 30-40 sec (quality)
- **Resolution**: Larger = better quality but slower
  - 768x768 = standard
  - 1024x1024 = high quality

---

## Example Workflow

```
1. Load flux_prompt_library_fast.json
2. Find "Prompt 1 - Fresh Natural Headshot" in PROMPT_LIBRARY.md
3. Copy the whole prompt text
4. Paste into ✏️ node
5. Click "Queue Prompt"
6. Result in ~15-20 seconds!
```

---

Done! Your workflows are ready to use with PROMPT_LIBRARY.md
