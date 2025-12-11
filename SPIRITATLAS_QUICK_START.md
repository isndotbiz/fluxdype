# SpiritAtlas - Quick Start

## 🚀 Generate All Assets in 3 Steps

### Step 1: Start Server (2 minutes)

```powershell
cd D:\workspace\fluxdype
.\start-comfy.ps1
```

Wait for: `To see the GUI go to: http://127.0.0.1:8188`

---

### Step 2: Test System (30 seconds)

```powershell
.\test_batch_quick.ps1
```

Verifies server + LoRAs are ready.

---

### Step 3: Generate All Assets (~60-75 minutes)

**Option A: Generate Everything**
```powershell
# Batch 1: Icons & Sacred Geometry (5 assets, ~8 min)
.\batch-generate.ps1 -File prompts_spiritatlas_square_1024.txt -Resolution square -Quality ultra -Variations 2

# Batch 2: Avatars, Chakras, Elements (15 assets, ~15 min)
.\batch-generate.ps1 -File prompts_spiritatlas_square_512.txt -Resolution square -Quality high

# Batch 3: Backgrounds (7 assets, ~8 min)
.\batch-generate.ps1 -File prompts_spiritatlas_portrait_backgrounds.txt -Resolution portrait_hd -Quality high

# Batch 4: Zodiac (12 assets, ~12 min)
.\batch-generate.ps1 -File prompts_spiritatlas_zodiac.txt -Resolution square -Quality high

# Batch 5: Moon Phases (8 assets, ~8 min)
.\batch-generate.ps1 -File prompts_spiritatlas_moon_phases.txt -Resolution square -Quality high

# Batch 6: UI Elements (14 assets, ~14 min)
.\batch-generate.ps1 -File prompts_spiritatlas_ui_elements.txt -Resolution square -Quality high

# Batch 7: Special Items (3 assets, ~5 min)
.\batch-generate.ps1 -File prompts_spiritatlas_special.txt -Resolution landscape -Quality ultra -Variations 2
```

**Option B: Just Test First (8 minutes)**
```powershell
# Generate 5 high-priority assets to verify quality
.\batch-generate.ps1 -File prompts_spiritatlas_square_1024.txt -Resolution square -Quality ultra -Variations 2
```

---

## 📁 Output Location

All images saved to:
```
D:\workspace\fluxdype\ComfyUI\output\batch_*.png
```

Open folder:
```powershell
explorer D:\workspace\fluxdype\ComfyUI\output\
```

---

## 📊 Asset Summary

| Batch | File | Assets | Time |
|-------|------|--------|------|
| 1 | `prompts_spiritatlas_square_1024.txt` | 5 | ~8 min |
| 2 | `prompts_spiritatlas_square_512.txt` | 15 | ~15 min |
| 3 | `prompts_spiritatlas_portrait_backgrounds.txt` | 7 | ~8 min |
| 4 | `prompts_spiritatlas_zodiac.txt` | 12 | ~12 min |
| 5 | `prompts_spiritatlas_moon_phases.txt` | 8 | ~8 min |
| 6 | `prompts_spiritatlas_ui_elements.txt` | 14 | ~14 min |
| 7 | `prompts_spiritatlas_special.txt` | 3 | ~5 min |
| **TOTAL** | | **64 prompts** | **~70 min** |

---

## ⚙️ Quality Settings

- **ultra** - Best quality (app icon, logo) - 30 steps
- **high** - Standard production (most assets) - 25 steps
- **balanced** - Quick iterations - 20 steps
- **fast** - Rapid previews - 15 steps

---

## 🎨 What Gets Generated

### Icons & Branding
- ✨ Primary App Icon (1024×1024)
- ✨ Splash Screen (1080×1920)
- ✨ Sacred Geometry Logo
- ✨ "SpiritAtlas" Wordmark

### Backgrounds (1080×1920)
- 🌌 Home Screen Cosmic
- 🌌 Profile Screen
- 🌌 Compatibility Analysis
- 🌌 Meditation/Loading
- 🌌 Chakra Energy
- 🌌 Settings (minimal)

### Spiritual Symbols
- 🕉️ 7 Chakras (root to crown)
- 🕉️ Flower of Life
- 🕉️ Metatron's Cube
- 🕉️ Yin Yang (cosmic)
- 🕉️ Om Symbol

### Astrology
- ♈ 12 Zodiac Constellations
- 🌙 8 Moon Phases
- 🔥 4 Elements (fire, earth, air, water)

### Avatars
- 👤 Masculine (cosmic silhouette)
- 👤 Feminine (aurora)
- 👤 Non-Binary (balanced)
- 💍 Avatar Frames & Rings

### UI Elements
- 🔘 Buttons (primary, secondary, FAB)
- 🎴 Cards (glassmorphic)
- ✔️ Status Icons (success, error)
- ⏳ Loading Spinner
- ➖ Dividers

---

## 🚨 Troubleshooting

**Server not running?**
```powershell
.\start-comfy.ps1
```

**Out of memory?**
- Use `-Quality balanced` instead of `high`
- Restart server between batches
- Close other GPU apps

**Need help?**
- See `SPIRITATLAS_GENERATION_GUIDE.md` for full details
- See `BATCH_GENERATION_GUIDE.md` for batch system docs

---

## 📋 After Generation

1. Review images in output folder
2. Resize to exact dimensions (see guide)
3. Compress with TinyPNG
4. Create Android density variants (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
5. Rename following `spiritatlas_[type]_[name]_[size].png`
6. Organize into Android `res/` folders

---

**Ready to create cosmic spiritual magic?** ✨

```powershell
.\start-comfy.ps1
.\batch-generate.ps1 -File prompts_spiritatlas_square_1024.txt -Resolution square -Quality ultra -Variations 2
```
