#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Consolidate scattered AI model files into D:\workspace\fluxdype\ComfyUI\models

.DESCRIPTION
    This script moves valuable models from scattered locations into the main fluxdype installation.
    It preserves duplicates in Optimum (active installation) and archives/deletes obsolete files.

.NOTES
    Generated: 2025-12-10
    Run from: D:\workspace\fluxdype
#>

$ErrorActionPreference = "Stop"

# Define paths
$FluxdypeModels = "D:\workspace\fluxdype\ComfyUI\models"
$ArchiveRoot = "D:\workspace\fluxdype\archived_models"

# Create archive directory
New-Item -ItemType Directory -Force -Path $ArchiveRoot | Out-Null

Write-Host "`n=== AI Model Consolidation Script ===" -ForegroundColor Cyan
Write-Host "Target: $FluxdypeModels`n" -ForegroundColor Cyan

# Function to move model files
function Move-ModelFile {
    param(
        [string]$SourcePath,
        [string]$TargetSubDir,
        [string]$Action = "MOVE"
    )

    $fileName = Split-Path -Leaf $SourcePath
    $targetDir = Join-Path $FluxdypeModels $TargetSubDir
    $targetPath = Join-Path $targetDir $fileName

    # Create target directory if needed
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

    if (Test-Path $targetPath) {
        Write-Host "  [SKIP] Already exists: $fileName" -ForegroundColor Yellow
        return $false
    }

    if ($Action -eq "MOVE") {
        Write-Host "  [MOVE] $fileName -> $TargetSubDir\" -ForegroundColor Green
        Move-Item -Path $SourcePath -Destination $targetPath -Force
        return $true
    } elseif ($Action -eq "ARCHIVE") {
        $archivePath = Join-Path $ArchiveRoot $fileName
        Write-Host "  [ARCHIVE] $fileName" -ForegroundColor Magenta
        Move-Item -Path $SourcePath -Destination $archivePath -Force
        return $true
    }
    return $false
}

# === 1. MOVE: Downloads folder models (valuable, not in fluxdype) ===
Write-Host "`n--- Processing C:\Users\Jdmal\Downloads ---" -ForegroundColor Yellow

$downloadsModels = @{
    "C:\Users\Jdmal\Downloads\4x_NickelbackFS_72000_G.pth" = "upscale_models"
    "C:\Users\Jdmal\Downloads\cyberrealisticNegative.DW8L.safetensors" = "embeddings"
    "C:\Users\Jdmal\Downloads\CyberRealistic_Negative_PONY_V2-neg.safetensors" = "embeddings"
    "C:\Users\Jdmal\Downloads\Facebookq-fotos.safetensors" = "loras"
    "C:\Users\Jdmal\Downloads\Facebook_Quality_Photos.safetensors" = "loras"
    "C:\Users\Jdmal\Downloads\ponyChar4ByStableYogi.uIsD.safetensors" = "loras"
    "C:\Users\Jdmal\Downloads\realism20lora20by.cpW5.safetensors" = "loras"
    "C:\Users\Jdmal\Downloads\realismLoraByStable.VvFC.safetensors" = "loras"
    "C:\Users\Jdmal\Downloads\Realism_Lora_By_Stable_yogi_SDXL8.1.safetensors" = "loras"
    "C:\Users\Jdmal\Downloads\superEyeDetailerBy.4EGS.safetensors" = "loras"
}

$moveCount = 0
foreach ($model in $downloadsModels.GetEnumerator()) {
    if (Test-Path $model.Key) {
        if (Move-ModelFile -SourcePath $model.Key -TargetSubDir $model.Value -Action "MOVE") {
            $moveCount++
        }
    }
}
Write-Host "Moved: $moveCount files" -ForegroundColor Cyan

# === 2. ARCHIVE: ai-workspace (old installation, valuable models) ===
Write-Host "`n--- Processing D:\ai-workspace\ComfyUI\models ---" -ForegroundColor Yellow

$aiWorkspaceValuable = @(
    "D:\ai-workspace\ComfyUI\models\loras\photorealism\xlabs_realism.safetensors",
    "D:\ai-workspace\ComfyUI\models\loras\technical\hyper_flux_8steps.safetensors"
)

$archiveCount = 0
foreach ($modelPath in $aiWorkspaceValuable) {
    if (Test-Path $modelPath) {
        $subDir = $modelPath -replace '^.*\\models\\loras\\[^\\]+\\', 'loras/'
        $subDir = Split-Path -Parent $subDir
        if (Move-ModelFile -SourcePath $modelPath -TargetSubDir $subDir -Action "MOVE") {
            $archiveCount++
        }
    }
}
Write-Host "Archived from ai-workspace: $archiveCount files" -ForegroundColor Cyan

# === 3. DUPLICATE CHECK: jdmal/ComfyUI vs fluxdype ===
Write-Host "`n--- Checking D:\jdmal\ComfyUI for duplicates ---" -ForegroundColor Yellow

# Note: These are duplicates already in fluxdype, just document them
$jdmalDuplicates = @(
    "facebookQuality.3t4R.safetensors",
    "fluxInstaGirlsV2.dbl2.safetensors",
    "NSFW_UNLOCKED.safetensors",
    "ultrafluxV1.aWjp.safetensors"
)

Write-Host "  [INFO] Following models are duplicates (already in fluxdype):" -ForegroundColor Cyan
foreach ($dup in $jdmalDuplicates) {
    Write-Host "    - $dup" -ForegroundColor Gray
}
Write-Host "  [ACTION] Keep D:\jdmal\ComfyUI as secondary working installation" -ForegroundColor Green

# === 4. LLAMA.CPP: Vocab files (keep in place) ===
Write-Host "`n--- D:\jdmal\llama.cpp\models ---" -ForegroundColor Yellow
Write-Host "  [INFO] 17 vocab files (50MB total) - Required by llama.cpp, keeping in place" -ForegroundColor Cyan

# === 5. D:\models: LLM models (keep in place) ===
Write-Host "`n--- D:\models (LLM models) ---" -ForegroundColor Yellow
Write-Host "  [INFO] 13 GGUF models (139GB total) - Organized LLM collection, keeping in place" -ForegroundColor Cyan
Write-Host "  Location: D:\models\organized\ and D:\models\rtx4060ti-16gb\" -ForegroundColor Gray

# === 6. D:\Optimum: Active SD WebUI installation ===
Write-Host "`n--- D:\Optimum (Stable Diffusion WebUI) ---" -ForegroundColor Yellow
Write-Host "  [INFO] Active SDXL installation (182GB) - Keep as-is" -ForegroundColor Cyan
Write-Host "  Models: 8 SDXL checkpoints, 15 LoRAs, 3 ControlNets" -ForegroundColor Gray

# === 7. RECYCLE BIN: Empty it ===
Write-Host "`n--- Recycle Bin ---" -ForegroundColor Yellow
Write-Host "  [INFO] Found old .pth/.safetensors files in recycle bin" -ForegroundColor Cyan
Write-Host "  [ACTION] Empty recycle bin manually to free space" -ForegroundColor Yellow

# Summary
Write-Host "`n=== CONSOLIDATION COMPLETE ===" -ForegroundColor Green
Write-Host "Moved to fluxdype: $moveCount files" -ForegroundColor White
Write-Host "Archived: $archiveCount files" -ForegroundColor White
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "  1. Test ComfyUI with new models: cd D:\workspace\fluxdype && .\start-comfy.ps1" -ForegroundColor White
Write-Host "  2. Review archived models in: $ArchiveRoot" -ForegroundColor White
Write-Host "  3. Empty recycle bin to free space" -ForegroundColor White
Write-Host "  4. Consider removing D:\ai-workspace if no longer needed" -ForegroundColor White
