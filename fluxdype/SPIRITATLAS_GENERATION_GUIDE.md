# SpiritAtlas Image Generation Guide

## Overview

This guide explains how to generate all 59 unique SpiritAtlas app assets using the ComfyUI batch generation system. The prompts have been organized into 8 files by resolution and asset type for efficient batch generation.

## Prompt Files Created

| File | Assets | Resolution | Count |
|------|--------|------------|-------|
| `prompts_spiritatlas_square_1024.txt` | Primary icon, sacred geometry symbols | 1024×1024 | 5 |
| `prompts_spiritatlas_square_512.txt` | Logo, avatars, chakras, elements | 512×512 | 15 |
| `prompts_spiritatlas_portrait_backgrounds.txt` | Full-screen backgrounds | 1080×1920 | 7 |
| `prompts_spiritatlas_zodiac.txt` | Zodiac constellations | 400×400 (square) | 12 |
| `prompts_spiritatlas_moon_phases.txt` | Moon phase cycle | 200×200 (square) | 8 |
| `prompts_spiritatlas_ui_elements.txt` | Buttons, cards, badges | Various (square base) | 14 |
| `prompts_spiritatlas_special.txt` | Wordmark, toggle, frames | Landscape | 3 |
| **TOTAL** | | | **64 prompts** |

## Prerequisites

### 1. Start ComfyUI Server

```powershell
cd D:\workspace\fluxdype
.\start-comfy.ps1
```

Wait for server to start on `http://localhost:8188`

### 2. Verify Setup

```powershell
.\test_batch_quick.ps1
```

This checks:
- ✓ ComfyUI server running
- ✓ LoRA files present
- ✓ Python environment configured

## Generation Instructions

### Batch 1: High-Resolution Square Assets (1024×1024)

**Assets:** Primary app icon, Flower of Life, Metatron's Cube, Yin Yang, Om Symbol

```powershell
.\batch-generate.ps1 -File prompts_spiritatlas_square_1024.txt -Resolution square -Quality ultra -Variations 2
```

**Settings:**
- Resolution: `square` (1024×1024)
- Quality: `ultra` (30 steps, best quality)
- Variations: 2 per prompt (pick best)
- Time: ~6-8 minutes (5 prompts × 2 variations)

**Output:** 10 images (5 prompts × 2 variations)

---

### Batch 2: Medium Square Assets (512×512)

**Assets:** Logo, 3 avatars, 7 chakras, 4 elements

```powershell
.\batch-generate.ps1 -File prompts_spiritatlas_square_512.txt -Resolution square -Quality high
```

**Settings:**
- Resolution: `square` (1024×1024, scale down to 512×512 later)
- Quality: `high` (25 steps)
- Variations: 1 (can increase to 2 if desired)
- Time: ~13-15 minutes (15 prompts)

**Output:** 15 images (or 30 with 2 variations)

---

### Batch 3: Portrait Backgrounds (1080×1920)

**Assets:** Splash screen, home, profile, settings, compatibility, meditation, chakra backgrounds

```powershell
.\batch-generate.ps1 -File prompts_spiritatlas_portrait_backgrounds.txt -Resolution portrait_hd -Quality high
```

**Settings:**
- Resolution: `portrait_hd` (1080×1920)
- Quality: `high` (25 steps)
- Variations: 1
- Time: ~6-8 minutes (7 prompts)

**Output:** 7 high-resolution portrait backgrounds

---

### Batch 4: Zodiac Constellations (400×400)

**Assets:** 12 zodiac constellation artworks

```powershell
.\batch-generate.ps1 -File prompts_spiritatlas_zodiac.txt -Resolution square -Quality high
```

**Settings:**
- Resolution: `square` (1024×1024, scale down to 400×400)
- Quality: `high` (25 steps)
- Variations: 1
- Time: ~10-12 minutes (12 prompts)

**Output:** 12 zodiac constellation images

---

### Batch 5: Moon Phases (200×200)

**Assets:** 8 moon phase cycle illustrations

```powershell
.\batch-generate.ps1 -File prompts_spiritatlas_moon_phases.txt -Resolution square -Quality high
```

**Settings:**
- Resolution: `square` (1024×1024, scale down to 200×200)
- Quality: `high` (25 steps)
- Variations: 1
- Time: ~7-8 minutes (8 prompts)

**Output:** 8 moon phase images

---

### Batch 6: UI Elements & Buttons

**Assets:** Buttons, cards, badges, loading spinner, status icons

```powershell
.\batch-generate.ps1 -File prompts_spiritatlas_ui_elements.txt -Resolution square -Quality high
```

**Settings:**
- Resolution: `square` (1024×1024)
- Quality: `high` (25 steps)
- Variations: 1
- Time: ~12-14 minutes (14 prompts)

**Output:** 14 UI element images

**Note:** These will need manual resizing/cropping for specific button dimensions

---

### Batch 7: Special Resolution Assets

**Assets:** Wordmark logo, toggle switch, avatar frames

```powershell
.\batch-generate.ps1 -File prompts_spiritatlas_special.txt -Resolution landscape -Quality ultra -Variations 2
```

**Settings:**
- Resolution: `landscape` (1536×1024)
- Quality: `ultra` (30 steps)
- Variations: 2 (pick best)
- Time: ~4-5 minutes (3 prompts × 2 variations)

**Output:** 6 images (3 prompts × 2 variations)

**Note:** These need manual cropping to final dimensions

---

## Complete Generation - All Batches

If you want to generate everything at once (recommended if you have time):

```powershell
# Total time estimate: ~60-75 minutes
# Total images: ~72 (depending on variations)

# Batch 1 (6-8 min)
.\batch-generate.ps1 -File prompts_spiritatlas_square_1024.txt -Resolution square -Quality ultra -Variations 2

# Batch 2 (13-15 min)
.\batch-generate.ps1 -File prompts_spiritatlas_square_512.txt -Resolution square -Quality high

# Batch 3 (6-8 min)
.\batch-generate.ps1 -File prompts_spiritatlas_portrait_backgrounds.txt -Resolution portrait_hd -Quality high

# Batch 4 (10-12 min)
.\batch-generate.ps1 -File prompts_spiritatlas_zodiac.txt -Resolution square -Quality high

# Batch 5 (7-8 min)
.\batch-generate.ps1 -File prompts_spiritatlas_moon_phases.txt -Resolution square -Quality high

# Batch 6 (12-14 min)
.\batch-generate.ps1 -File prompts_spiritatlas_ui_elements.txt -Resolution square -Quality high

# Batch 7 (4-5 min)
.\batch-generate.ps1 -File prompts_spiritatlas_special.txt -Resolution landscape -Quality ultra -Variations 2
```

---

## Output Organization

### Default Output Location

All generated images are saved to:
```
D:\workspace\fluxdype\ComfyUI\output\
```

### Recommended Organization

After generation, organize by category:

```powershell
# Create organized folders
mkdir D:\workspace\fluxdype\ComfyUI\output\spiritatlas
mkdir D:\workspace\fluxdype\ComfyUI\output\spiritatlas\icons
mkdir D:\workspace\fluxdype\ComfyUI\output\spiritatlas\backgrounds
mkdir D:\workspace\fluxdype\ComfyUI\output\spiritatlas\avatars
mkdir D:\workspace\fluxdype\ComfyUI\output\spiritatlas\symbols
mkdir D:\workspace\fluxdype\ComfyUI\output\spiritatlas\ui_elements
mkdir D:\workspace\fluxdype\ComfyUI\output\spiritatlas\zodiac
mkdir D:\workspace\fluxdype\ComfyUI\output\spiritatlas\moon_phases

# Move files (do this after each batch or all at once)
# You'll need to manually sort by creation time or file name patterns
```

### Filename Format

Generated images follow this pattern:
```
batch_YYYYMMDD_HHMMSS_00001_.png
batch_YYYYMMDD_HHMMSS_00002_.png
...
```

**Tip:** The files are created in order of the prompts in the file, so you can identify them by the sequence.

---

## Post-Processing Checklist

After generation, you'll need to:

### 1. Quality Check
- [ ] Review all generated images
- [ ] Verify colors match SpiritAtlas palette
- [ ] Check sacred geometry accuracy
- [ ] Ensure spiritual symbols are authentic

### 2. Resize/Scale
- [ ] Scale 1024×1024 to required sizes (512×512, etc.)
- [ ] Scale zodiac from 1024×1024 to 400×400
- [ ] Scale moon phases from 1024×1024 to 200×200
- [ ] Crop special items to exact dimensions

### 3. Optimization
- [ ] Run through TinyPNG or similar compressor
- [ ] Target: <100KB for icons, <500KB for backgrounds
- [ ] Consider WebP format for Android

### 4. Android Density Variants

For each icon/UI element, create density variants:

| Density | Multiplier | Example (48dp icon) |
|---------|-----------|---------------------|
| mdpi | 1x | 48×48 |
| hdpi | 1.5x | 72×72 |
| xhdpi | 2x | 96×96 |
| xxhdpi | 3x | 144×144 |
| xxxhdpi | 4x | 192×192 |

### 5. Naming Convention

Rename files to follow Android conventions:

```
spiritatlas_icon_app_primary_xxxhdpi.png
spiritatlas_bg_home_cosmic_1080x1920.png
spiritatlas_avatar_masculine_default_512.png
spiritatlas_symbol_chakra_root_512.png
spiritatlas_button_primary_gradient_360x120.png
```

---

## Troubleshooting

### Issue: Server Not Running

```
✗ ComfyUI server is not running!
```

**Solution:**
```powershell
# Open new terminal
cd D:\workspace\fluxdype
.\start-comfy.ps1
```

### Issue: Out of Memory

```
CUDA out of memory
```

**Solutions:**
1. Reduce quality: Use `balanced` instead of `ultra` or `high`
2. Reduce resolution temporarily
3. Restart ComfyUI server between batches
4. Close other GPU applications

### Issue: Colors Don't Match Palette

**Solutions:**
1. Regenerate with variations: `-Variations 3`
2. Edit prompt file to emphasize hex codes
3. Use post-processing to adjust colors in Photoshop/GIMP

### Issue: Sacred Geometry Inaccurate

**Solutions:**
1. Increase quality to `ultra`
2. Generate multiple variations and pick best
3. Consider manual touch-up in vector editor

### Issue: Generation Too Slow

**Solutions:**
1. Use `balanced` quality (20 steps) instead of `high` (25 steps)
2. Generate in smaller batches
3. Run overnight for large batches
4. Use `-NoWait` flag and check output later

---

## Quality Settings Guide

| Quality | Steps | Time/Image | Best For | Use When |
|---------|-------|------------|----------|----------|
| **ultra** | 30 | ~70s | Final production, icons, logos | Quality is paramount |
| **high** | 25 | ~50s | Most assets, backgrounds | Balanced quality/speed |
| **balanced** | 20 | ~35s | Testing, iterations | Quick previews needed |
| **fast** | 15 | ~25s | Quick concepts | Speed is priority |

---

## Recommended Generation Order

1. **Start with Batch 1 (1024×1024)** - Test quality and settings with 5 high-priority assets
2. **Review results** - Ensure quality meets expectations before generating 50+ more images
3. **Continue with Batches 2-7** - Generate remaining assets
4. **Organize immediately** - Move files to folders after each batch (easier to track)

---

## Asset Tracking

Use this checklist to track generation progress:

### Icons & Branding (6 assets)
- [ ] Primary App Icon (1024×1024)
- [ ] Splash Screen Background (1080×1920)
- [ ] Logo - Sacred Geometry Symbol (512×512)
- [ ] Logo Wordmark - "SpiritAtlas" (1200×300)
- [ ] Icon Badge - Notification (96×96)
- [ ] Foreground Adaptive Icon (432×432)

### Buttons & Interactive (5 assets)
- [ ] Primary Action Button Background
- [ ] Secondary Button Border
- [ ] Floating Action Button (FAB)
- [ ] Icon Button - Gradient Circle
- [ ] Toggle Switch Track

### Backgrounds (7 assets)
- [ ] Home Screen Cosmic Background
- [ ] Profile Screen Background
- [ ] Settings Background
- [ ] Compatibility Analysis Background
- [ ] Meditation/Loading State Background
- [ ] Chakra Energy Background
- [ ] (+ Splash Screen from Icons section)

### Avatars (6 assets)
- [ ] Default Avatar - Masculine
- [ ] Default Avatar - Feminine
- [ ] Default Avatar - Non-Binary
- [ ] Avatar Frame - Sacred Circle
- [ ] Avatar Ring - Energy Aura
- [ ] Avatar Overlay - Compatibility Heart

### Spiritual Symbols (31 assets)
- [ ] Chakra 1-7 (7 images)
- [ ] Flower of Life
- [ ] Metatron's Cube
- [ ] Zodiac Signs 1-12 (12 images)
- [ ] Elements: Fire, Earth, Air, Water (4 images)
- [ ] Moon Phases 1-8 (8 images)
- [ ] Yin Yang - Cosmic
- [ ] Om Symbol - Glowing Sacred

### Bonus UI Elements (5 assets)
- [ ] Card Background - Glassmorphic
- [ ] Divider Line - Cosmic Gradient
- [ ] Loading Spinner - Sacred Geometry
- [ ] Success Checkmark - Cosmic
- [ ] Error State - Gentle Cosmic

**Total: 59 unique assets** (some prompts generate multiple variations)

---

## Tips for Best Results

### Prompt Quality
- All prompts include exact hex color codes - ComfyUI will interpret these
- Sacred geometry terms help guide geometric accuracy
- "4K quality", "professional", "sharp details" improve output quality

### Color Accuracy
- Generated images should be close to target colors
- Minor color correction in post-processing is normal
- Use color picker to verify hex codes after generation

### Variations Strategy
- Use 2-3 variations for critical assets (app icon, logo, key backgrounds)
- Use 1 variation for bulk assets (zodiac, moon phases) to save time
- Always keep variations of final production assets

### Batch Strategy
- Test with Batch 1 first (5 images, ~8 minutes)
- Verify quality before committing to 50+ image batches
- Generate overnight if generating all 64+ images at once

---

## Next Steps After Generation

1. **Review & Select** - Pick best variations
2. **Scale & Crop** - Resize to exact dimensions
3. **Optimize** - Compress file sizes
4. **Create Density Variants** - Generate mdpi/hdpi/xhdpi/xxhdpi/xxxhdpi versions
5. **Rename** - Follow Android naming conventions
6. **Organize** - Place in `res/` folder structure
7. **Test** - Verify in Android app
8. **Iterate** - Regenerate any assets that need improvement

---

## Support & Resources

- **Batch Generation Guide:** `BATCH_GENERATION_GUIDE.md`
- **LoRA Registry:** `LORA_REGISTRY.json`
- **Project Setup:** `CLAUDE.md`
- **Quick Test:** `.\test_batch_quick.ps1`

---

**Ready to generate?**

```powershell
# Start server
.\start-comfy.ps1

# Test system
.\test_batch_quick.ps1

# Generate first batch (test)
.\batch-generate.ps1 -File prompts_spiritatlas_square_1024.txt -Resolution square -Quality ultra -Variations 2

# Check output
explorer D:\workspace\fluxdype\ComfyUI\output\
```

---

**FluxDype x SpiritAtlas** - Professional spiritual app asset generation
