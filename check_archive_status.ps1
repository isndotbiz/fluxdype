#Requires -Version 5.1
<#
.SYNOPSIS
    Checks the status of Wan/Qwen model archives.

.DESCRIPTION
    Provides detailed information about:
    - What models are currently archived vs. active
    - Total storage consumed by each location
    - Archive integrity (log file verification)
    - Potential restorations available

.EXAMPLE
    .\check_archive_status.ps1
    Shows full archive status

.EXAMPLE
    .\check_archive_status.ps1 -Summary
    Shows only summary (no details)

#>

[CmdletBinding()]
param(
    [switch]$Summary = $false,
    [switch]$DetailedLogs = $false
)

# Configuration
$ModelsRoot = "D:\workspace\fluxdype\ComfyUI\models"
$ArchiveRoot = "D:\workspace\fluxdype\models_archive\wan_qwen"
$ArchiveLog = Join-Path $ArchiveRoot "archive.log"
$RestoreLog = Join-Path $ArchiveRoot "restore.log"

function Format-FileSize {
    param([long]$Size)

    if ($Size -eq 0) { return "0 B" }

    $units = @("B", "KB", "MB", "GB", "TB")
    $unitIndex = 0
    $sizeInUnits = [double]$Size

    while ($sizeInUnits -ge 1024 -and $unitIndex -lt $units.Count - 1) {
        $sizeInUnits /= 1024
        $unitIndex++
    }

    return "{0:N2} {1}" -f $sizeInUnits, $units[$unitIndex]
}

function Get-DirectorySize {
    param(
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        return 0
    }

    try {
        $items = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue
        if ($items) {
            return ($items | Measure-Object -Sum Length).Sum
        }
        return 0
    }
    catch {
        return 0
    }
}

# Header
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Wan & Qwen Archive Status Check" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check archive existence
$archiveExists = Test-Path $ArchiveRoot

if (-not $archiveExists) {
    Write-Host "Status: NO ARCHIVE FOUND" -ForegroundColor Yellow
    Write-Host "Archive location: $ArchiveRoot" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "To create an archive, run:" -ForegroundColor Yellow
    Write-Host "  .\archive_wan_qwen.ps1" -ForegroundColor Cyan
    Write-Host ""
    exit 0
}

# Calculate sizes
Write-Host "Calculating archive sizes..." -ForegroundColor Yellow

$archiveSize = Get-DirectorySize -Path $ArchiveRoot

# Check for active models in ComfyUI
$activeModels = @{
    wan_high = if (Test-Path "$ModelsRoot\diffusion_models\Wan2.2_Remix_NSFW_i2v_14b_high_lighting_v2.0.safetensors") { $true } else { $false }
    wan_low = if (Test-Path "$ModelsRoot\diffusion_models\Wan2.2_Remix_NSFW_i2v_14b_low_lighting_v2.0.safetensors") { $true } else { $false }
    qwen_gguf = if (Test-Path "$ModelsRoot\diffusion_models\qwen-image-Q3_K_S.gguf") { $true } else { $false }
    qwen_clip = if (Test-Path "$ModelsRoot\clip\qwen_2.5_vl_7b_fp8_scaled.safetensors") { $true } else { $false }
}

$archivedModels = @{
    wan_high = if (Test-Path "$ArchiveRoot\diffusion_models\Wan2.2_Remix_NSFW_i2v_14b_high_lighting_v2.0.safetensors") { $true } else { $false }
    wan_low = if (Test-Path "$ArchiveRoot\diffusion_models\Wan2.2_Remix_NSFW_i2v_14b_low_lighting_v2.0.safetensors") { $true } else { $false }
    qwen_gguf = if (Test-Path "$ArchiveRoot\diffusion_models\qwen-image-Q3_K_S.gguf") { $true } else { $false }
    qwen_clip = if (Test-Path "$ArchiveRoot\clip\qwen_2.5_vl_7b_fp8_scaled.safetensors") { $true } else { $false }
}

Write-Host ""

# Archive Status
Write-Host "ARCHIVE STATUS" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host "Archive exists:     Yes" -ForegroundColor Green
Write-Host "Archive location:   $ArchiveRoot" -ForegroundColor DarkGray
Write-Host "Total size:         $(Format-FileSize $archiveSize)" -ForegroundColor Cyan
Write-Host ""

# Check log files
$hasArchiveLog = Test-Path $ArchiveLog
$hasRestoreLog = Test-Path $RestoreLog

Write-Host "Log Files:" -ForegroundColor Yellow
Write-Host "  archive.log:      $(if ($hasArchiveLog) { 'Present' } else { 'Missing' })" -ForegroundColor $(if ($hasArchiveLog) { 'Green' } else { 'Red' })
Write-Host "  restore.log:      $(if ($hasRestoreLog) { 'Present' } else { 'Missing' })" -ForegroundColor $(if ($hasRestoreLog) { 'Green' } else { 'Red' })

Write-Host ""

# Model Status
Write-Host "MODEL STATUS" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Wan 2.2 - High Lighting:" -ForegroundColor White
Write-Host "  Archive:  $(if ($archivedModels.wan_high) { '[✓] Present' } else { '[✗] Missing' })" -ForegroundColor $(if ($archivedModels.wan_high) { 'Green' } else { 'Yellow' })
Write-Host "  Active:   $(if ($activeModels.wan_high) { '[✓] Present' } else { '[✗] Archived' })" -ForegroundColor $(if ($activeModels.wan_high) { 'Red' } else { 'Green' })
Write-Host ""

Write-Host "Wan 2.2 - Low Lighting:" -ForegroundColor White
Write-Host "  Archive:  $(if ($archivedModels.wan_low) { '[✓] Present' } else { '[✗] Missing' })" -ForegroundColor $(if ($archivedModels.wan_low) { 'Green' } else { 'Yellow' })
Write-Host "  Active:   $(if ($activeModels.wan_low) { '[✓] Present' } else { '[✗] Archived' })" -ForegroundColor $(if ($activeModels.wan_low) { 'Red' } else { 'Green' })
Write-Host ""

Write-Host "Qwen Image GGUF:" -ForegroundColor White
Write-Host "  Archive:  $(if ($archivedModels.qwen_gguf) { '[✓] Present' } else { '[✗] Missing' })" -ForegroundColor $(if ($archivedModels.qwen_gguf) { 'Green' } else { 'Yellow' })
Write-Host "  Active:   $(if ($activeModels.qwen_gguf) { '[✓] Present' } else { '[✗] Archived' })" -ForegroundColor $(if ($activeModels.qwen_gguf) { 'Red' } else { 'Green' })
Write-Host ""

Write-Host "Qwen CLIP Vision:" -ForegroundColor White
Write-Host "  Archive:  $(if ($archivedModels.qwen_clip) { '[✓] Present' } else { '[✗] Missing' })" -ForegroundColor $(if ($archivedModels.qwen_clip) { 'Green' } else { 'Yellow' })
Write-Host "  Active:   $(if ($activeModels.qwen_clip) { '[✓] Present' } else { '[✗] Archived' })" -ForegroundColor $(if ($activeModels.qwen_clip) { 'Red' } else { 'Green' })
Write-Host ""

# Summary counts
$totalArchived = @($archivedModels.Values | Where-Object { $_ -eq $true }).Count
$totalActive = @($activeModels.Values | Where-Object { $_ -eq $true }).Count

Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Models archived:      $totalArchived / 4 core models" -ForegroundColor Green
Write-Host "Models active:        $totalActive / 4 core models" -ForegroundColor Yellow
Write-Host "Archive size:         $(Format-FileSize $archiveSize)" -ForegroundColor Cyan
Write-Host ""

# Recommendations
Write-Host "RECOMMENDATIONS" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Yellow

if ($totalArchived -eq 4) {
    Write-Host "✓ All models properly archived" -ForegroundColor Green
    Write-Host ""
    Write-Host "To restore when needed:" -ForegroundColor Yellow
    Write-Host "  .\restore_wan_qwen.ps1" -ForegroundColor Cyan
}
elseif ($totalActive -eq 4) {
    Write-Host "⚠ All models are active (not archived)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To archive and free 46GB:" -ForegroundColor Yellow
    Write-Host "  .\archive_wan_qwen.ps1" -ForegroundColor Cyan
}
else {
    Write-Host "⚠ Mixed state detected" -ForegroundColor Yellow
    Write-Host ""
    if ($totalActive -gt 0) {
        Write-Host "To archive remaining active models:" -ForegroundColor Yellow
        Write-Host "  .\archive_wan_qwen.ps1" -ForegroundColor Cyan
    }
    if ($totalArchived -gt 0) {
        Write-Host "To restore archived models:" -ForegroundColor Yellow
        Write-Host "  .\restore_wan_qwen.ps1" -ForegroundColor Cyan
    }
}

Write-Host ""

# Show log details if requested
if ($DetailedLogs -and $hasArchiveLog) {
    Write-Host "ARCHIVE LOG (Last 10 entries)" -ForegroundColor Yellow
    Write-Host "================================================" -ForegroundColor Yellow
    $logLines = Get-Content $ArchiveLog | Select-Object -Last 10
    foreach ($line in $logLines) {
        if ($line -match "SUCCESS") {
            Write-Host $line -ForegroundColor Green
        }
        elseif ($line -match "ERROR") {
            Write-Host $line -ForegroundColor Red
        }
        elseif ($line -match "WARNING") {
            Write-Host $line -ForegroundColor Yellow
        }
        else {
            Write-Host $line
        }
    }
    Write-Host ""
}

if ($DetailedLogs -and $hasRestoreLog) {
    Write-Host "RESTORE LOG (Last 10 entries)" -ForegroundColor Yellow
    Write-Host "================================================" -ForegroundColor Yellow
    $logLines = Get-Content $RestoreLog | Select-Object -Last 10
    foreach ($line in $logLines) {
        if ($line -match "SUCCESS") {
            Write-Host $line -ForegroundColor Green
        }
        elseif ($line -match "ERROR") {
            Write-Host $line -ForegroundColor Red
        }
        elseif ($line -match "WARNING") {
            Write-Host $line -ForegroundColor Yellow
        }
        else {
            Write-Host $line
        }
    }
    Write-Host ""
}

Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# More info
Write-Host "For detailed information, see:" -ForegroundColor DarkGray
Write-Host "  models_archive/wan_qwen/README.md" -ForegroundColor Cyan
Write-Host "  WAN_QWEN_ARCHIVE_QUICKSTART.md" -ForegroundColor Cyan
Write-Host ""
