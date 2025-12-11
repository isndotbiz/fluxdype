# Wan & Qwen Archive - Quick Start Guide

## TL;DR

**Archive these models to free up 46 GB:**
```powershell
cd D:\workspace\fluxdype
.\archive_wan_qwen.ps1
```

**Restore them later:**
```powershell
.\restore_wan_qwen.ps1
```

---

## Models Being Archived

| Model | Size | Purpose |
|-------|------|---------|
| Wan2.2_Remix (high/low) | 26.62 GB | Video generation |
| Qwen multimodal models | 17.72 GB | Image understanding |
| Qwen + Wan VAEs & LoRAs | 1.57 GB | Supporting models |

**Total**: ~46 GB (freed to D: drive)

---

## Before Archiving

1. **Backup**: Optional - models are recoverable from archive logs
2. **Stop ComfyUI**: Close the server if running
3. **Verify Space**: Ensure 2 GB free for log files

```powershell
# Check available space
(Get-Volume D).SizeRemaining / 1GB
```

---

## Archive Process

### Step 1: Run Archive Script
```powershell
cd D:\workspace\fluxdype
.\archive_wan_qwen.ps1
```

### Step 2: Monitor Progress
- Shows each file being moved
- Displays file size and status
- Summary at end showing total archived

### Step 3: Verify Success
```powershell
# Check archive log
Get-Content models_archive\wan_qwen\archive.log | tail -20
```

**Expected output**: All files marked SUCCESS

---

## After Archiving

✓ **D: drive**: 46 GB freed
✓ **Archive location**: `D:\workspace\fluxdype\models_archive\wan_qwen\`
✓ **Log created**: `archive.log` with timestamps
✓ **Files organized**: By category (diffusion_models, clip, loras, etc.)

### Verify Archive Structure
```powershell
ls -Recurse D:\workspace\fluxdype\models_archive\wan_qwen | measure-object -Sum Length
```

Should show ~46 GB total

---

## Restoration Process

### Step 1: Run Restore Script
```powershell
cd D:\workspace\fluxdype
.\restore_wan_qwen.ps1
```

Script will:
- Read archive.log
- Move files back to original locations
- Verify file integrity (SHA256 hash check)
- Log all actions to restore.log

### Step 2: Wait for Completion
- ~5-15 minutes depending on disk speed
- No user interaction needed
- Shows progress in console

### Step 3: Verify Restoration
```powershell
# Check restore log
Get-Content models_archive\wan_qwen\restore.log | grep SUCCESS
```

All files should show hash verification passed

### Restart ComfyUI
```powershell
.\start-comfy.ps1
```

Models will be automatically detected by ComfyUI

---

## Fast Restore (Skip Verification)

If you trust the archive and want faster restoration:

```powershell
.\restore_wan_qwen.ps1 -SkipVerification
```

Saves ~30% time but doesn't verify file integrity

---

## Manual Verification

### Check Archive Contents
```powershell
# List all archived models
ls -Recurse D:\workspace\fluxdype\models_archive\wan_qwen\*.safetensors -ErrorAction SilentlyContinue
ls -Recurse D:\workspace\fluxdype\models_archive\wan_qwen\*.gguf -ErrorAction SilentlyContinue
```

### Check Original Locations
```powershell
# Should be empty after archiving
ls D:\workspace\fluxdype\ComfyUI\models\diffusion_models | grep -i "wan\|qwen"
```

### Verify File Sizes
```powershell
# Archive total size
(dir -Recurse D:\workspace\fluxdype\models_archive\wan_qwen | measure -Sum Length).Sum / 1GB
```

Should show ~46 GB

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Script won't run | Run PowerShell as Administrator |
| "Permission denied" | Close ComfyUI, try again |
| Slow progress | Normal on slower disks, takes 5-15 min |
| Hash verification failed | Re-archive, or skip verification |
| Archive log not found | Ensure scripts run from D:\workspace\fluxdype\ |

---

## What Gets Archived?

### Diffusion Models (Video)
- `Wan2.2_Remix_NSFW_i2v_14b_high_lighting_v2.0.safetensors` (13.31 GB)
- `Wan2.2_Remix_NSFW_i2v_14b_low_lighting_v2.0.safetensors` (13.31 GB)

### Vision Models (Multimodal)
- `qwen-image-Q3_K_S.gguf` (8.34 GB)
- `qwen_2.5_vl_7b_fp8_scaled.safetensors` (8.8 GB)

### Supporting Models
- VAEs: `qwen_image_vae.safetensors`, `wan_2.1_vae.safetensors`
- LoRAs: Lightning optimization models (3x files, ~0.57-1.58 GB)
- Text encoder: `nsfw_wan_umt5-xxl_fp8_scaled.safetensors`

---

## Why Archive These?

1. **GPU Memory**: RTX 3090 (24GB) struggles with Flux + Qwen + Wan
2. **Not in current pipeline**: Flux text-to-image is primary workflow
3. **Easy recovery**: Full log-based restoration with verification
4. **Modular design**: Archive only when not needed, restore when starting video/multimodal work

---

## Archive vs. Delete

- **Archive**: Files stored safely, can restore anytime ✓
- **Delete**: Lost forever ✗

**Choose Archive** for these expensive models!

---

## Common Commands

```powershell
# Full archive with logs
.\archive_wan_qwen.ps1

# Full restore with verification
.\restore_wan_qwen.ps1

# Restore without verification (faster)
.\restore_wan_qwen.ps1 -SkipVerification

# Check what's archived
ls -Recurse D:\workspace\fluxdype\models_archive\wan_qwen

# Check archive log
cat D:\workspace\fluxdype\models_archive\wan_qwen\archive.log

# Check restore log
cat D:\workspace\fluxdype\models_archive\wan_qwen\restore.log
```

---

## Pro Tips

✓ **Schedule archiving**: Run monthly if not using Wan/Qwen
✓ **Separate ComfyUI**: Run Wan on port 8189 if needed
✓ **Monitor logs**: Archive.log + Restore.log track everything
✓ **Backup critical**: Optional manual backup of archive folder before archiving
✓ **Use Lightning**: LoRA models cut inference time 4x after restore

---

## Next Steps

1. Run `.\archive_wan_qwen.ps1` when ready
2. Check `models_archive\wan_qwen\archive.log` for confirmation
3. Verify disk space freed on D: drive
4. When needed, run `.\restore_wan_qwen.ps1` to bring models back

---

**Questions?** See `models_archive/wan_qwen/README.md` for detailed documentation
