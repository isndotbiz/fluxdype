#Requires -Version 5.1
<#
.SYNOPSIS
    Restores Wan 2.2 and Qwen models from archive to ComfyUI models directory.

.DESCRIPTION
    Reads the archive log file and moves all archived models back to their
    original locations in ComfyUI/models/. Verifies file integrity using
    file hashes to ensure complete transfer.

.PARAMETER ArchivePath
    Root path of the archive folder. Default: D:\workspace\fluxdype\models_archive\wan_qwen

.PARAMETER LogPath
    Path to the log file. Default: D:\workspace\fluxdype\models_archive\wan_qwen\archive.log

.PARAMETER SkipVerification
    Skip file hash verification during restoration.

.EXAMPLE
    .\restore_wan_qwen.ps1
    Restores models with full verification

.EXAMPLE
    .\restore_wan_qwen.ps1 -SkipVerification
    Restores models without hash verification

#>

[CmdletBinding()]
param(
    [string]$ArchivePath = "D:\workspace\fluxdype\models_archive\wan_qwen",
    [string]$LogPath = "D:\workspace\fluxdype\models_archive\wan_qwen\archive.log",
    [switch]$SkipVerification = $false
)

# Configuration
$ModelsTargetRoot = "D:\workspace\fluxdype\ComfyUI\models"
$RestoreLogPath = "D:\workspace\fluxdype\models_archive\wan_qwen\restore.log"
$ErrorActionPreference = "Stop"

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

# Function to calculate file hash
function Get-FileHashSafe {
    param(
        [string]$Path
    )

    try {
        return (Get-FileHash -Path $Path -Algorithm SHA256 -ErrorAction Stop).Hash
    }
    catch {
        return $null
    }
}

# Initialize restore log
function Write-RestoreLog {
    param(
        [string]$Message,
        [ValidateSet("INFO", "SUCCESS", "WARNING", "ERROR")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    Add-Content -Path $RestoreLogPath -Value $logMessage -ErrorAction SilentlyContinue

    switch ($Level) {
        "SUCCESS" { Write-Host $Message -ForegroundColor Green }
        "WARNING" { Write-Host $Message -ForegroundColor Yellow }
        "ERROR"   { Write-Host $Message -ForegroundColor Red }
        default   { Write-Host $Message }
    }
}

# Parse archive log to extract source -> destination mappings
function Get-ArchiveEntries {
    param(
        [string]$LogFilePath
    )

    if (-not (Test-Path $LogFilePath)) {
        Write-RestoreLog "Log file not found: $LogFilePath" "ERROR"
        return @()
    }

    $entries = @()
    $logContent = Get-Content -Path $LogFilePath

    foreach ($line in $logContent) {
        if ($line -match "\[INFO\] MOVED: (.+?) -> (.+?) \((.+?)\)") {
            $entries += @{
                source = $matches[1]
                destination = $matches[2]
                size = $matches[3]
            }
        }
    }

    return $entries
}

# Main restoration process
function Start-Restore {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Wan 2.2 & Qwen Model Restoration Script" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    # Verify prerequisites
    if (-not (Test-Path $ArchivePath)) {
        Write-RestoreLog "ERROR: Archive directory not found: $ArchivePath" "ERROR"
        Write-Host "Archive directory not found: $ArchivePath" -ForegroundColor Red
        exit 1
    }

    if (-not (Test-Path $ModelsTargetRoot)) {
        Write-RestoreLog "ERROR: ComfyUI models directory not found: $ModelsTargetRoot" "ERROR"
        Write-Host "ComfyUI models directory not found: $ModelsTargetRoot" -ForegroundColor Red
        exit 1
    }

    # Clear existing restore log
    if (Test-Path $RestoreLogPath) {
        Remove-Item $RestoreLogPath -Force
    }

    Write-RestoreLog "Restoration started: $(Get-Date)" "INFO"
    Write-RestoreLog "Archive root: $ArchivePath" "INFO"
    Write-RestoreLog "Target root: $ModelsTargetRoot" "INFO"
    Write-RestoreLog "Skip verification: $SkipVerification" "INFO"
    Write-RestoreLog "---" "INFO"

    # Get archive entries
    $archiveEntries = Get-ArchiveEntries -LogFilePath $LogPath

    if ($archiveEntries.Count -eq 0) {
        Write-RestoreLog "No archive entries found in log file" "WARNING"
        Write-Host "No archive entries found in log file" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "Found $($archiveEntries.Count) models to restore" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Processing models..." -ForegroundColor Yellow
    Write-Host ""

    [long]$totalRestoredSize = 0
    $restoredCount = 0
    $skippedCount = 0
    $failedCount = 0
    $verificationFailedCount = 0

    # Process each entry in reverse (destination back to source)
    foreach ($entry in $archiveEntries) {
        # The entries are already in format: archive -> original
        # So we need to reverse: original <- archive
        $archiveFile = $entry.destination  # This is where the file was moved TO
        $originalLocation = $entry.source  # This is where it came FROM

        # Since we're restoring, the file is now in the archive
        $currentPath = Join-Path $ArchivePath ((Split-Path $archiveFile -Leaf))

        # Find the actual file in archive subdirectories
        $archiveFilePath = $null
        foreach ($category in @("diffusion_models", "clip", "loras", "text_encoders", "vae")) {
            $testPath = Join-Path $ArchivePath $category (Split-Path $archiveFile -Leaf)
            if (Test-Path $testPath) {
                $archiveFilePath = $testPath
                break
            }
        }

        if (-not $archiveFilePath -or -not (Test-Path $archiveFilePath)) {
            Write-RestoreLog "SKIPPED: $(Split-Path $originalLocation -Leaf) (not found in archive)" "WARNING"
            Write-Host "Skipped: $(Split-Path $originalLocation -Leaf)" -ForegroundColor Yellow
            Write-Host "  File not found in archive" -ForegroundColor DarkGray
            $skippedCount++
            continue
        }

        try {
            $fileInfo = Get-Item $archiveFilePath
            $fileSize = $fileInfo.Length
            $fileName = Split-Path $originalLocation -Leaf

            Write-Host "Restoring: $fileName" -ForegroundColor Cyan
            Write-Host "  From: $archiveFilePath" -ForegroundColor DarkGray
            Write-Host "  To:   $originalLocation" -ForegroundColor DarkGray
            Write-Host "  Size: $(Format-FileSize $fileSize)" -ForegroundColor DarkGray

            # Ensure target directory exists
            $targetDir = Split-Path $originalLocation
            if (-not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                Write-Verbose "Created target directory: $targetDir"
            }

            # Calculate hash before move (if verification enabled)
            $archiveHash = $null
            if (-not $SkipVerification) {
                Write-Host "  Computing source hash..." -ForegroundColor DarkGray
                $archiveHash = Get-FileHashSafe -Path $archiveFilePath
                if ($null -eq $archiveHash) {
                    Write-RestoreLog "WARNING: Could not compute hash for $fileName" "WARNING"
                }
            }

            # Move file back
            Move-Item -Path $archiveFilePath -Destination $originalLocation -Force

            # Verify (if enabled and hash available)
            if (-not $SkipVerification -and $archiveHash) {
                $restoredHash = Get-FileHashSafe -Path $originalLocation
                if ($restoredHash -eq $archiveHash) {
                    Write-Host "  ✓ Verification passed" -ForegroundColor Green
                    Write-RestoreLog "RESTORED: $originalLocation ($(Format-FileSize $fileSize)) - Hash verified" "SUCCESS"
                }
                else {
                    $verificationFailedCount++
                    Write-Host "  ✗ Verification failed! Hashes don't match!" -ForegroundColor Red
                    Write-RestoreLog "ERROR: $fileName - Hash mismatch after restoration" "ERROR"
                    $failedCount++
                    continue
                }
            }
            else {
                Write-Host "  ✓ Restored" -ForegroundColor Green
                Write-RestoreLog "RESTORED: $originalLocation ($(Format-FileSize $fileSize))" "SUCCESS"
            }

            $totalRestoredSize += $fileSize
            $restoredCount++
        }
        catch {
            $failedCount++
            Write-RestoreLog "ERROR: $fileName - Error: $($_.Exception.Message)" "ERROR"
            Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
        }

        Write-Host ""
    }

    # Clean up empty archive directories
    Write-Host "Cleaning up empty directories..." -ForegroundColor Yellow
    foreach ($category in @("diffusion_models", "clip", "loras", "text_encoders", "vae")) {
        $categoryPath = Join-Path $ArchivePath $category
        if ((Test-Path $categoryPath) -and -not (Get-ChildItem -Path $categoryPath -ErrorAction SilentlyContinue)) {
            Write-Verbose "Removing empty directory: $categoryPath"
        }
    }

    # Summary
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Restoration Summary" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Restored:         $restoredCount files" -ForegroundColor Green
    Write-Host "Skipped:          $skippedCount files" -ForegroundColor Yellow
    Write-Host "Failed:           $failedCount files" -ForegroundColor $(if ($failedCount -gt 0) { "Red" } else { "Green" })
    if (-not $SkipVerification) {
        Write-Host "Verification:     $(if ($verificationFailedCount -eq 0) { 'Passed' } else { "$verificationFailedCount failed" })" -ForegroundColor $(if ($verificationFailedCount -eq 0) { "Green" } else { "Red" })
    }
    else {
        Write-Host "Verification:     Skipped" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "Total data restored: $(Format-FileSize $totalRestoredSize)" -ForegroundColor Cyan
    Write-Host "Archive location:    $ArchivePath" -ForegroundColor Cyan
    Write-Host "Restore log:         $RestoreLogPath" -ForegroundColor Cyan
    Write-Host ""

    Write-RestoreLog "---" "INFO"
    Write-RestoreLog "Restoration completed:" "INFO"
    Write-RestoreLog "  Restored: $restoredCount" "SUCCESS"
    Write-RestoreLog "  Skipped:  $skippedCount" "WARNING"
    Write-RestoreLog "  Failed:   $failedCount" "ERROR"
    Write-RestoreLog "  Total restored: $(Format-FileSize $totalRestoredSize)" "INFO"
    Write-RestoreLog "---" "INFO"

    if ($failedCount -eq 0) {
        Write-RestoreLog "Restoration operation completed successfully!" "SUCCESS"
        Write-Host "Restoration operation completed successfully!" -ForegroundColor Green
        return 0
    }
    else {
        Write-RestoreLog "Restoration operation completed with errors!" "ERROR"
        Write-Host "Restoration operation completed with $failedCount errors!" -ForegroundColor Red
        return 1
    }
}

# Run restoration
$exitCode = Start-Restore
exit $exitCode
