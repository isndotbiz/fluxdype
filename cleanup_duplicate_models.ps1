#Requires -Version 5.0
<#
.SYNOPSIS
    Cleanup duplicate and incompatible models from ComfyUI models directory.

.DESCRIPTION
    Safely removes duplicate and incompatible models, moving them to a backup
    folder instead of permanently deleting them.

.PARAMETER WhatIf
    Preview changes without actually moving files.

.PARAMETER BackupPath
    Path where removed files will be moved. Default: D:\workspace\fluxdype\models_removed_backup\

.EXAMPLE
    # Preview what will be removed
    .\cleanup_duplicate_models.ps1 -WhatIf

    # Actually execute the cleanup
    .\cleanup_duplicate_models.ps1
#>

param(
    [switch]$WhatIf = $false,
    [switch]$Confirm = $false,
    [string]$BackupPath = "D:\workspace\fluxdype\models_removed_backup"
)

# Configuration
$ModelsRoot = "D:\workspace\fluxdype\ComfyUI\models"
$LogPath = "D:\workspace\fluxdype\cleanup_models.log"

# Files to remove - organized by category
$FilesToRemove = @(
    # Diffusion Models
    @{
        Path = "$ModelsRoot\diffusion_models\unstableEvolution_Fp1622GB.safetensors"
        Category = "Diffusion Models"
        Reason = "Duplicate NSFW (22.17 GB)"
    },
    @{
        Path = "$ModelsRoot\diffusion_models\fluxNSFWUNLOCKED_v20FP16.safetensors"
        Category = "Diffusion Models"
        Reason = "Duplicate NSFW (22.17 GB)"
    },
    @{
        Path = "$ModelsRoot\diffusion_models\fluxMoja_v6Krea.safetensors"
        Category = "Diffusion Models"
        Reason = "Duplicate NSFW (22.17 GB)"
    },
    @{
        Path = "$ModelsRoot\diffusion_models\flux1-dev-Q8_0.gguf"
        Category = "Diffusion Models"
        Reason = "CPU quantized, not needed on RTX 3090 (11.84 GB)"
    },
    @{
        Path = "$ModelsRoot\diffusion_models\hyperfluxDiversity_q80.gguf"
        Category = "Diffusion Models"
        Reason = "CPU quantized (11.84 GB)"
    },
    @{
        Path = "$ModelsRoot\diffusion_models\iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors"
        Category = "Diffusion Models"
        Reason = "SDXL incompatible (11.08 GB)"
    },
    # LoRAs
    @{
        Path = "$ModelsRoot\loras\NSFW_master.safetensors"
        Category = "LoRAs"
        Reason = "Redundant (0.16 GB)"
    },
    @{
        Path = "$ModelsRoot\loras\FluXXXv2.safetensors"
        Category = "LoRAs"
        Reason = "Redundant (0.13 GB)"
    },
    @{
        Path = "$ModelsRoot\loras\KREAnsfwv2.safetensors"
        Category = "LoRAs"
        Reason = "Redundant (0.13 GB)"
    },
    @{
        Path = "$ModelsRoot\loras\NSFW_Flux_Petite-000002.safetensors"
        Category = "LoRAs"
        Reason = "Redundant (0.02 GB)"
    },
    @{
        Path = "$ModelsRoot\loras\FLUX Female Anatomy.safetensors"
        Category = "LoRAs"
        Reason = "Redundant (0.02 GB)"
    }
)

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Write-Host $logEntry
    Add-Content -Path $LogPath -Value $logEntry
}

function Format-FileSize {
    param([long]$Bytes)
    if ($Bytes -ge 1GB) {
        return "{0:N2} GB" -f ($Bytes / 1GB)
    }
    elseif ($Bytes -ge 1MB) {
        return "{0:N2} MB" -f ($Bytes / 1MB)
    }
    else {
        return "{0:N2} KB" -f ($Bytes / 1KB)
    }
}

# Initialize log
if (Test-Path $LogPath) {
    Remove-Item $LogPath -Force
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ComfyUI Models Cleanup Utility" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if models directory exists
if (-not (Test-Path $ModelsRoot)) {
    Write-Log "ERROR: Models directory not found: $ModelsRoot" "ERROR"
    exit 1
}

Write-Log "Models root: $ModelsRoot"
Write-Log "Backup path: $BackupPath"
Write-Log "WhatIf mode: $WhatIf"

# Calculate before storage usage
Write-Host ""
Write-Host "Calculating current storage usage..." -ForegroundColor Yellow
$beforeUsage = (Get-ChildItem -Path $ModelsRoot -Recurse -File | Measure-Object -Property Length -Sum).Sum

Write-Host "Current models directory size: $(Format-FileSize $beforeUsage)" -ForegroundColor Cyan
Write-Log "Before cleanup - Total size: $(Format-FileSize $beforeUsage)"

# Analyze files to remove
Write-Host ""
Write-Host "Files to be removed:" -ForegroundColor Yellow
Write-Log "========== FILES TO REMOVE =========="

$filesToRemoveFound = @()
$totalSizeToRemove = 0
$removedByCategory = @{}

foreach ($file in $FilesToRemove) {
    if (Test-Path $file.Path) {
        $fileInfo = Get-Item $file.Path
        $fileSize = $fileInfo.Length
        $fileSizeFormatted = Format-FileSize $fileSize

        Write-Host "  - $(Split-Path $file.Path -Leaf)" -ForegroundColor Red
        Write-Host "    Size: $fileSizeFormatted | Reason: $($file.Reason)" -ForegroundColor Gray

        Write-Log "$($file.Path) | Size: $fileSizeFormatted | Reason: $($file.Reason)"

        $filesToRemoveFound += @{
            FullPath = $file.Path
            FileName = Split-Path $file.Path -Leaf
            Size = $fileSize
            SizeFormatted = $fileSizeFormatted
            Category = $file.Category
            Reason = $file.Reason
        }

        $totalSizeToRemove += $fileSize

        if (-not $removedByCategory.ContainsKey($file.Category)) {
            $removedByCategory[$file.Category] = @()
        }
        $removedByCategory[$file.Category] += @{
            FileName = Split-Path $file.Path -Leaf
            Size = $fileSize
            SizeFormatted = $fileSizeFormatted
        }
    }
    else {
        Write-Host "  - $(Split-Path $file.Path -Leaf) [NOT FOUND]" -ForegroundColor Gray
        Write-Log "FILE NOT FOUND: $($file.Path)"
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Files found: $($filesToRemoveFound.Count) / $($FilesToRemove.Count)" -ForegroundColor White
Write-Host "  Total space to free: $(Format-FileSize $totalSizeToRemove)" -ForegroundColor Cyan

Write-Log "Files found: $($filesToRemoveFound.Count) / $($FilesToRemove.Count)"
Write-Log "Total space to free: $(Format-FileSize $totalSizeToRemove)"
Write-Log "Breakdown by category:"
foreach ($category in $removedByCategory.Keys) {
    $categoryFiles = $removedByCategory[$category]
    $categorySize = 0
    foreach ($f in $categoryFiles) {
        $categorySize += $f.Size
    }
    Write-Log "  $category : $($categoryFiles.Count) files, $(Format-FileSize $categorySize)"
}

# WhatIf mode - just preview
if ($WhatIf) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "WHATIF MODE - No changes will be made" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To execute cleanup, run:" -ForegroundColor Yellow
    Write-Host "  .\cleanup_duplicate_models.ps1" -ForegroundColor Cyan
    Write-Log "WhatIf execution completed - no changes made"
    exit 0
}

# Confirmation before actual cleanup
Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "CONFIRMATION REQUIRED" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "This will move $($filesToRemoveFound.Count) files to backup:" -ForegroundColor White
Write-Host "  Space to free: $(Format-FileSize $totalSizeToRemove)" -ForegroundColor Cyan
Write-Host "  Backup location: $BackupPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Files will NOT be deleted, only moved to backup for recovery." -ForegroundColor Green
Write-Host ""

if (-not $Confirm) {
    $response = Read-Host "Continue with cleanup? (yes/no)"

    if ($response -ne "yes" -and $response -ne "y") {
        Write-Host "Cleanup cancelled by user." -ForegroundColor Yellow
        Write-Log "Cleanup cancelled by user"
        exit 0
    }
}

Write-Log "User confirmed - proceeding with cleanup"

# Create backup directory
Write-Host ""
Write-Host "Creating backup structure..." -ForegroundColor Yellow

if (-not (Test-Path $BackupPath)) {
    New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
    Write-Log "Created backup directory: $BackupPath"
}

# Create subdirectories in backup
foreach ($category in $removedByCategory.Keys) {
    $backupCategory = Join-Path $BackupPath $category
    if (-not (Test-Path $backupCategory)) {
        New-Item -ItemType Directory -Path $backupCategory -Force | Out-Null
        Write-Log "Created backup subdirectory: $backupCategory"
    }
}

# Move files to backup
Write-Host ""
Write-Host "Moving files to backup..." -ForegroundColor Yellow
$movedCount = 0
$movedSize = 0
$failedCount = 0

foreach ($file in $filesToRemoveFound) {
    try {
        $category = $file.Category
        $backupDir = Join-Path $BackupPath $category
        $targetPath = Join-Path $backupDir $file.FileName

        Write-Host "  Moving: $($file.FileName)" -ForegroundColor White
        Move-Item -Path $file.FullPath -Destination $targetPath -Force -ErrorAction Stop

        $movedCount += 1
        $movedSize += $file.Size
        Write-Log "Moved: $($file.FileName) ($($file.SizeFormatted))"
    }
    catch {
        $failedCount += 1
        Write-Host "    FAILED: $_" -ForegroundColor Red
        Write-Log "FAILED to move $($file.FileName): $_" "ERROR"
    }
}

# Calculate after storage usage
Write-Host ""
Write-Host "Calculating new storage usage..." -ForegroundColor Yellow
$afterUsage = (Get-ChildItem -Path $ModelsRoot -Recurse -File | Measure-Object -Property Length -Sum).Sum
$spaceSaved = $beforeUsage - $afterUsage

# Final summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Cleanup Complete" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Files moved: $movedCount (Failed: $failedCount)" -ForegroundColor White
Write-Host "Space freed: $(Format-FileSize $spaceSaved)" -ForegroundColor Green
Write-Host "Before: $(Format-FileSize $beforeUsage)" -ForegroundColor White
Write-Host "After:  $(Format-FileSize $afterUsage)" -ForegroundColor White
Write-Host ""
Write-Host "Backup location: $BackupPath" -ForegroundColor Cyan
Write-Host "Backup size: $(Format-FileSize $movedSize)" -ForegroundColor Cyan
Write-Host "Log file: $LogPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "To restore files, copy them back from: $BackupPath" -ForegroundColor Yellow
Write-Host ""

Write-Log "========== CLEANUP COMPLETE =========="
Write-Log "Files moved: $movedCount (Failed: $failedCount)"
Write-Log "Space freed: $(Format-FileSize $spaceSaved)"
Write-Log "Before size: $(Format-FileSize $beforeUsage)"
Write-Log "After size: $(Format-FileSize $afterUsage)"
Write-Log "Backup location: $BackupPath"
Write-Log "Backup size: $(Format-FileSize $movedSize)"
