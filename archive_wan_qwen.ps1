#Requires -Version 5.1
<#
.SYNOPSIS
    Archives Wan 2.2 and Qwen model files to a separate folder.

.DESCRIPTION
    Moves all Wan 2.2 and Qwen related models from ComfyUI/models/ to
    models_archive/wan_qwen/ while maintaining the folder structure.
    Creates a log file for restoration purposes.

.PARAMETER ArchivePath
    Root path for the archive folder. Default: D:\workspace\fluxdype\models_archive\wan_qwen

.PARAMETER LogPath
    Path for the log file. Default: D:\workspace\fluxdype\models_archive\wan_qwen\archive.log

.EXAMPLE
    .\archive_wan_qwen.ps1
    Runs archival with default paths

.EXAMPLE
    .\archive_wan_qwen.ps1 -Verbose
    Runs archival with verbose output

#>

[CmdletBinding()]
param(
    [string]$ArchivePath = "D:\workspace\fluxdype\models_archive\wan_qwen",
    [string]$LogPath = "D:\workspace\fluxdype\models_archive\wan_qwen\archive.log",
    [switch]$Force = $false
)

# Configuration
$ModelsSourceRoot = "D:\workspace\fluxdype\ComfyUI\models"
$ErrorActionPreference = "Stop"

# Model definitions: hashtable with source pattern and destination subfolder
$ModelsToArchive = @{
    # Diffusion models - Wan 2.2 variants
    "Wan2.2_Remix_NSFW_i2v_14b_high_lighting_v2.0.safetensors" = @{
        source = "diffusion_models"
        dest   = "diffusion_models"
    }
    "Wan2.2_Remix_NSFW_i2v_14b_low_lighting_v2.0.safetensors" = @{
        source = "diffusion_models"
        dest   = "diffusion_models"
    }
    # Diffusion models - Qwen variants
    "qwen-image-Q3_K_S.gguf" = @{
        source = "diffusion_models"
        dest   = "diffusion_models"
    }
    # CLIP models - Qwen
    "qwen_2.5_vl_7b_fp8_scaled.safetensors" = @{
        source = "clip"
        dest   = "clip"
    }
    # LoRAs - Qwen
    "Qwen-Image-Lightning-4steps-V1.0.safetensors" = @{
        source = "loras"
        dest   = "loras"
    }
    # LoRAs - Wan
    "Wan2.2-Lightning_I2V-A14B-4steps-lora_HIGH_fp16.safetensors" = @{
        source = "loras"
        dest   = "loras"
    }
    "Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors" = @{
        source = "loras"
        dest   = "loras"
    }
    # Text encoders - Wan
    "nsfw_wan_umt5-xxl_fp8_scaled.safetensors" = @{
        source = "text_encoders"
        dest   = "text_encoders"
    }
    # VAE models
    "qwen_image_vae.safetensors" = @{
        source = "vae"
        dest   = "vae"
    }
    "wan_2.1_vae.safetensors" = @{
        source = "vae"
        dest   = "vae"
    }
}

# Initialize log
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO", "SUCCESS", "WARNING", "ERROR")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    Add-Content -Path $LogPath -Value $logMessage -ErrorAction SilentlyContinue

    switch ($Level) {
        "SUCCESS" { Write-Host $Message -ForegroundColor Green }
        "WARNING" { Write-Host $Message -ForegroundColor Yellow }
        "ERROR"   { Write-Host $Message -ForegroundColor Red }
        default   { Write-Host $Message }
    }
}

# Function to get human-readable file size
function Format-FileSize {
    param([long]$Size)

    $units = @("B", "KB", "MB", "GB", "TB")
    $unitIndex = 0
    $sizeInUnits = [double]$Size

    while ($sizeInUnits -ge 1024 -and $unitIndex -lt $units.Count - 1) {
        $sizeInUnits /= 1024
        $unitIndex++
    }

    return "{0:N2} {1}" -f $sizeInUnits, $units[$unitIndex]
}

# Main archival process
function Start-Archive {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Wan 2.2 & Qwen Model Archival Script" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    # Verify source exists
    if (-not (Test-Path $ModelsSourceRoot)) {
        Write-Log "ERROR: Models source directory not found: $ModelsSourceRoot" "ERROR"
        exit 1
    }

    # Create archive directory structure
    Write-Host "Creating archive directory structure..." -ForegroundColor Yellow
    foreach ($folder in @("diffusion_models", "clip", "loras", "text_encoders", "vae")) {
        $folderPath = Join-Path $ArchivePath $folder
        if (-not (Test-Path $folderPath)) {
            New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
            Write-Verbose "Created: $folderPath"
        }
    }

    # Clear existing log
    if (Test-Path $LogPath) {
        Remove-Item $LogPath -Force
    }

    Write-Log "Archive started: $(Get-Date)" "INFO"
    Write-Log "Source root: $ModelsSourceRoot" "INFO"
    Write-Log "Archive root: $ArchivePath" "INFO"
    Write-Log "---" "INFO"

    [long]$totalSourceSize = 0
    [long]$totalArchivedSize = 0
    $movedCount = 0
    $skippedCount = 0
    $failedCount = 0

    Write-Host ""
    Write-Host "Processing models..." -ForegroundColor Yellow
    Write-Host ""

    # Process each model
    foreach ($modelName in $ModelsToArchive.Keys) {
        $sourceFolder = $ModelsToArchive[$modelName].source
        $destFolder = $ModelsToArchive[$modelName].dest

        $sourcePath = Join-Path $ModelsSourceRoot $sourceFolder $modelName
        $destPath = Join-Path $ArchivePath $destFolder $modelName

        if (Test-Path $sourcePath) {
            try {
                $fileInfo = Get-Item $sourcePath
                $fileSize = $fileInfo.Length
                $totalSourceSize += $fileSize

                Write-Host "Moving: $modelName" -ForegroundColor Cyan
                Write-Host "  From: $sourcePath" -ForegroundColor DarkGray
                Write-Host "  To:   $destPath" -ForegroundColor DarkGray
                Write-Host "  Size: $(Format-FileSize $fileSize)" -ForegroundColor DarkGray

                # Move file
                Move-Item -Path $sourcePath -Destination $destPath -Force

                $totalArchivedSize += $fileSize
                $movedCount++

                Write-Log "MOVED: $sourcePath -> $destPath ($(Format-FileSize $fileSize))" "SUCCESS"
                Write-Host "  ✓ Success" -ForegroundColor Green
            }
            catch {
                $failedCount++
                Write-Log "FAILED: $modelName - Error: $($_.Exception.Message)" "ERROR"
                Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        else {
            $skippedCount++
            Write-Log "SKIPPED: $modelName (not found at $sourcePath)" "WARNING"
            Write-Host "  ⊘ Skipped: File not found" -ForegroundColor Yellow
        }

        Write-Host ""
    }

    # Summary
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Archival Summary" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Moved:   $movedCount files" -ForegroundColor Green
    Write-Host "Skipped: $skippedCount files" -ForegroundColor Yellow
    Write-Host "Failed:  $failedCount files" -ForegroundColor $(if ($failedCount -gt 0) { "Red" } else { "Green" })
    Write-Host ""
    Write-Host "Total data archived: $(Format-FileSize $totalArchivedSize)" -ForegroundColor Cyan
    Write-Host "Archive location:    $ArchivePath" -ForegroundColor Cyan
    Write-Host "Log file:            $LogPath" -ForegroundColor Cyan
    Write-Host ""

    Write-Log "---" "INFO"
    Write-Log "Archive completed:" "INFO"
    Write-Log "  Moved:   $movedCount" "SUCCESS"
    Write-Log "  Skipped: $skippedCount" "WARNING"
    Write-Log "  Failed:  $failedCount" "ERROR"
    Write-Log "  Total archived: $(Format-FileSize $totalArchivedSize)" "INFO"
    Write-Log "---" "INFO"

    if ($failedCount -eq 0) {
        Write-Log "Archive operation completed successfully!" "SUCCESS"
        Write-Host "Archive operation completed successfully!" -ForegroundColor Green
        return 0
    }
    else {
        Write-Log "Archive operation completed with errors!" "ERROR"
        Write-Host "Archive operation completed with $failedCount errors!" -ForegroundColor Red
        return 1
    }
}

# Run archive
$exitCode = Start-Archive
exit $exitCode
