# Model Restoration Guide

## Backup Location
All removed models are safely stored in: **D:\workspace\fluxdype\models_removed_backup\**

## Quick Statistics
- **Backup Size**: 101.72 GB
- **Files in Backup**: 11 files
- **Current Models Directory**: 200.68 GB
- **Space Freed**: 101.72 GB (33.65% reduction)

## Backup Contents

### Diffusion Models (6 files, 101.27 GB)
Located in: `models_removed_backup\Diffusion Models\`

- `flux1-dev-Q8_0.gguf` - 11.84 GB (CPU quantized model)
- `fluxMoja_v6Krea.safetensors` - 22.17 GB (Duplicate NSFW)
- `fluxNSFWUNLOCKED_v20FP16.safetensors` - 22.17 GB (Duplicate NSFW)
- `hyperfluxDiversity_q80.gguf` - 11.84 GB (CPU quantized model)
- `iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors` - 11.08 GB (SDXL incompatible)
- `unstableEvolution_Fp1622GB.safetensors` - 22.17 GB (Duplicate NSFW)

### LoRAs (5 files, 467.42 MB)
Located in: `models_removed_backup\LoRAs\`

- `FLUX Female Anatomy.safetensors` - 18.37 MB
- `FluXXXv2.safetensors` - 135.44 MB
- `KREAnsfwv2.safetensors` - 130.42 MB
- `NSFW_Flux_Petite-000002.safetensors` - 19.19 MB
- `NSFW_master.safetensors` - 164.00 MB

## Restoration Methods

### Method 1: Manual File Restoration (Recommended for selective restore)

Copy individual files back from backup:

```powershell
# Example: Restore a specific diffusion model
Copy-Item -Path 'D:\workspace\fluxdype\models_removed_backup\Diffusion Models\flux1-dev-Q8_0.gguf' `
          -Destination 'D:\workspace\fluxdype\ComfyUI\models\diffusion_models\' -Force

# Example: Restore a specific LoRA
Copy-Item -Path 'D:\workspace\fluxdype\models_removed_backup\LoRAs\NSFW_master.safetensors' `
          -Destination 'D:\workspace\fluxdype\ComfyUI\models\loras\' -Force
```

### Method 2: Bulk Restore by Category

Restore all diffusion models:
```powershell
Copy-Item -Path 'D:\workspace\fluxdype\models_removed_backup\Diffusion Models\*' `
          -Destination 'D:\workspace\fluxdype\ComfyUI\models\diffusion_models\' -Recurse -Force
```

Restore all LoRAs:
```powershell
Copy-Item -Path 'D:\workspace\fluxdype\models_removed_backup\LoRAs\*' `
          -Destination 'D:\workspace\fluxdype\ComfyUI\models\loras\' -Recurse -Force
```

### Method 3: Restore Everything

Restore all removed models at once:
```powershell
Copy-Item -Path 'D:\workspace\fluxdype\models_removed_backup\*' `
          -Destination 'D:\workspace\fluxdype\ComfyUI\models\' -Recurse -Force
```

### Method 4: Using Windows Explorer

1. Open Windows Explorer
2. Navigate to: `D:\workspace\fluxdype\models_removed_backup\`
3. Select the files/folders you want to restore
4. Right-click and choose "Copy"
5. Navigate to: `D:\workspace\fluxdype\ComfyUI\models\`
6. Right-click and choose "Paste"

## After Restoration

After restoring any models, you must restart the ComfyUI server:

```powershell
# Stop any running ComfyUI processes, then:
cd D:\workspace\fluxdype
.\start-comfy.ps1
```

Or manually:
```powershell
cd D:\workspace\fluxdype
.\venv\Scripts\Activate.ps1
cd ComfyUI
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --normalvram
```

## Checking Restoration

After restoring models, you can verify they're accessible:

```powershell
# List diffusion models
Get-ChildItem -Path 'D:\workspace\fluxdype\ComfyUI\models\diffusion_models\' |
  Select-Object Name, @{N='Size(GB)';E={[math]::Round($_.Length/1GB, 2)}}

# List LoRAs
Get-ChildItem -Path 'D:\workspace\fluxdype\ComfyUI\models\loras\' |
  Select-Object Name, @{N='Size(GB)';E={[math]::Round($_.Length/1GB, 2)}}
```

## Why These Models Were Removed

### CPU Quantized Models (Not Suitable for RTX 3090)
- `flux1-dev-Q8_0.gguf` - Designed for CPU inference, wastes VRAM on GPU
- `hyperfluxDiversity_q80.gguf` - CPU quantized format (.gguf), redundant with GPU models

### Duplicate/Redundant Models
- `unstableEvolution_Fp1622GB.safetensors` - Duplicate of better models already present
- `fluxNSFWUNLOCKED_v20FP16.safetensors` - Duplicate NSFW variant
- `fluxMoja_v6Krea.safetensors` - Duplicate NSFW variant

### Incompatible Models
- `iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors` - SDXL model incompatible with Flux

### Redundant LoRAs
All removed LoRAs were duplicates or superseded by better alternatives:
- NSFW LoRAs consolidated into single library
- Legacy versions replaced by improved versions

## Permanent Deletion

Once you're confident the cleanup is correct and ComfyUI works properly:

```powershell
# Permanently delete the entire backup folder
Remove-Item -Path 'D:\workspace\fluxdype\models_removed_backup' -Recurse -Force
```

This will free up an additional 101.72 GB of disk space.

## Troubleshooting

### Model not appearing in ComfyUI Web UI
1. Verify the file is in the correct subdirectory
2. Check file permissions (should be readable)
3. Restart ComfyUI server
4. Clear browser cache and reload

### File copy fails with "Access Denied"
1. Ensure ComfyUI server is not running
2. Check disk permissions on destination folder
3. Try running PowerShell as Administrator

### Need to check what was removed?
See the detailed log: `D:\workspace\fluxdype\cleanup_models.log`

## Support

For more information about specific models or questions about restoration:
- Check the cleanup log: `D:\workspace\fluxdype\cleanup_models.log`
- Review the summary: `D:\workspace\fluxdype\CLEANUP_SUMMARY.txt`
- ComfyUI documentation: https://github.com/comfyanonymous/ComfyUI

---

Last Updated: 2025-12-10
Backup Size: 101.72 GB
All files can be restored individually or in bulk at any time.
