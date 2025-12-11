#Requires -Version 5.1
<#
.SYNOPSIS
    Interactive archive management utility for Wan/Qwen models.

.DESCRIPTION
    Provides a menu-driven interface for common archive operations:
    - View archive status
    - Archive models
    - Restore models
    - View logs
    - Verify archive integrity

.EXAMPLE
    .\manage_archives.ps1
    Shows interactive menu

#>

[CmdletBinding()]
param()

# Configuration
$ArchiveRoot = "D:\workspace\fluxdype\models_archive\wan_qwen"
$ArchiveScript = "D:\workspace\fluxdype\archive_wan_qwen.ps1"
$RestoreScript = "D:\workspace\fluxdype\restore_wan_qwen.ps1"
$StatusScript = "D:\workspace\fluxdype\check_archive_status.ps1"
$ArchiveLog = Join-Path $ArchiveRoot "archive.log"
$RestoreLog = Join-Path $ArchiveRoot "restore.log"

# Colors
$colorMenu = [System.ConsoleColor]::Cyan
$colorSuccess = [System.ConsoleColor]::Green
$colorWarning = [System.ConsoleColor]::Yellow
$colorError = [System.ConsoleColor]::Red

function Show-Menu {
    Clear-Host
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor $colorMenu
    Write-Host "Wan & Qwen Archive Management" -ForegroundColor $colorMenu
    Write-Host "=============================================" -ForegroundColor $colorMenu
    Write-Host ""
    Write-Host "1. View Archive Status" -ForegroundColor $colorMenu
    Write-Host "2. Archive Models (Move to archive)" -ForegroundColor $colorMenu
    Write-Host "3. Restore Models (Move from archive)" -ForegroundColor $colorMenu
    Write-Host "4. View Archive Log" -ForegroundColor $colorMenu
    Write-Host "5. View Restore Log" -ForegroundColor $colorMenu
    Write-Host "6. Verify Archive Integrity" -ForegroundColor $colorMenu
    Write-Host "7. Open Archive Folder" -ForegroundColor $colorMenu
    Write-Host "8. View Quick Start Guide" -ForegroundColor $colorMenu
    Write-Host "9. View Full Documentation" -ForegroundColor $colorMenu
    Write-Host "0. Exit" -ForegroundColor $colorMenu
    Write-Host ""
}

function Select-Option {
    Write-Host "Enter your choice (0-9): " -ForegroundColor $colorMenu -NoNewline
    return Read-Host
}

function Wait-ForKey {
    Write-Host ""
    Write-Host "Press any key to continue..." -ForegroundColor $colorWarning
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Menu Actions
function Show-Status {
    Write-Host "Running archive status check..." -ForegroundColor $colorWarning
    Write-Host ""
    & $StatusScript -DetailedLogs
}

function Start-Archive {
    Write-Host ""
    Write-Host "This will move Wan/Qwen models (46GB) to the archive folder." -ForegroundColor $colorWarning
    Write-Host "ComfyUI should be stopped before proceeding." -ForegroundColor $colorWarning
    Write-Host ""
    Write-Host "Continue? (Y/N): " -ForegroundColor $colorMenu -NoNewline
    $confirm = Read-Host

    if ($confirm -eq 'Y' -or $confirm -eq 'y') {
        Write-Host ""
        Write-Host "Starting archival..." -ForegroundColor $colorSuccess
        Write-Host ""
        & $ArchiveScript
    }
    else {
        Write-Host "Archival cancelled." -ForegroundColor $colorWarning
    }
}

function Start-Restore {
    Write-Host ""
    Write-Host "This will restore Wan/Qwen models (46GB) from the archive." -ForegroundColor $colorWarning
    Write-Host "Approximately 5-15 minutes required." -ForegroundColor $colorWarning
    Write-Host "ComfyUI should be stopped before proceeding." -ForegroundColor $colorWarning
    Write-Host ""
    Write-Host "Options:" -ForegroundColor $colorMenu
    Write-Host "1. Restore with verification (recommended)" -ForegroundColor $colorMenu
    Write-Host "2. Restore without verification (faster)" -ForegroundColor $colorMenu
    Write-Host "3. Cancel" -ForegroundColor $colorMenu
    Write-Host ""
    Write-Host "Choose option (1-3): " -ForegroundColor $colorMenu -NoNewline
    $choice = Read-Host

    switch ($choice) {
        "1" {
            Write-Host ""
            Write-Host "Starting restoration with verification..." -ForegroundColor $colorSuccess
            Write-Host ""
            & $RestoreScript
        }
        "2" {
            Write-Host ""
            Write-Host "Starting restoration without verification..." -ForegroundColor $colorSuccess
            Write-Host ""
            & $RestoreScript -SkipVerification
        }
        default {
            Write-Host "Restoration cancelled." -ForegroundColor $colorWarning
        }
    }
}

function Show-Log {
    param([string]$LogFile, [string]$Title)

    if (-not (Test-Path $LogFile)) {
        Write-Host ""
        Write-Host "$Title not found." -ForegroundColor $colorWarning
        Wait-ForKey
        return
    }

    Clear-Host
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor $colorMenu
    Write-Host $Title -ForegroundColor $colorMenu
    Write-Host "=============================================" -ForegroundColor $colorMenu
    Write-Host ""

    Get-Content $LogFile | ForEach-Object {
        if ($_ -match "SUCCESS") {
            Write-Host $_ -ForegroundColor $colorSuccess
        }
        elseif ($_ -match "ERROR") {
            Write-Host $_ -ForegroundColor $colorError
        }
        elseif ($_ -match "WARNING") {
            Write-Host $_ -ForegroundColor $colorWarning
        }
        else {
            Write-Host $_
        }
    }
    Write-Host ""
    Wait-ForKey
}

function Verify-Archive {
    Clear-Host
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor $colorMenu
    Write-Host "Archive Integrity Verification" -ForegroundColor $colorMenu
    Write-Host "=============================================" -ForegroundColor $colorMenu
    Write-Host ""

    if (-not (Test-Path $ArchiveRoot)) {
        Write-Host "Archive directory not found." -ForegroundColor $colorError
        Wait-ForKey
        return
    }

    Write-Host "Checking archive structure..." -ForegroundColor $colorWarning
    Write-Host ""

    $requiredFolders = @("diffusion_models", "clip", "loras", "text_encoders", "vae")
    $allPresent = $true

    foreach ($folder in $requiredFolders) {
        $folderPath = Join-Path $ArchiveRoot $folder
        if (Test-Path $folderPath) {
            $fileCount = @(Get-ChildItem -Path $folderPath -File -ErrorAction SilentlyContinue).Count
            Write-Host "✓ $folder" -ForegroundColor $colorSuccess
            if ($fileCount -gt 0) {
                Write-Host "  $fileCount files found" -ForegroundColor DarkGray
            }
        }
        else {
            Write-Host "✗ $folder (missing)" -ForegroundColor $colorWarning
            $allPresent = $false
        }
    }

    Write-Host ""

    # Calculate total size
    $totalSize = 0
    $fileCount = 0
    $items = Get-ChildItem -Path $ArchiveRoot -Recurse -File -ErrorAction SilentlyContinue
    if ($items) {
        $totalSize = ($items | Measure-Object -Sum Length).Sum
        $fileCount = $items.Count
    }

    function Format-Size([long]$bytes) {
        $sizes = "B", "KB", "MB", "GB"
        $order = 0
        while ($bytes -ge 1KB -and $order -lt $sizes.Count - 1) {
            $order++
            $bytes = $bytes / 1KB
        }
        return "{0:N2} {1}" -f $bytes, $sizes[$order]
    }

    Write-Host "Archive Statistics:" -ForegroundColor $colorMenu
    Write-Host "  Total files:   $fileCount" -ForegroundColor DarkGray
    Write-Host "  Total size:    $(Format-Size $totalSize)" -ForegroundColor DarkGray
    Write-Host ""

    if ($allPresent) {
        Write-Host "Archive structure: VALID" -ForegroundColor $colorSuccess
    }
    else {
        Write-Host "Archive structure: INCOMPLETE" -ForegroundColor $colorWarning
    }

    Write-Host ""
    Wait-ForKey
}

function Open-Folder {
    if (Test-Path $ArchiveRoot) {
        Start-Process explorer.exe -ArgumentList $ArchiveRoot
        Write-Host "Opening archive folder..." -ForegroundColor $colorSuccess
    }
    else {
        Write-Host "Archive folder not found." -ForegroundColor $colorWarning
    }
    Start-Sleep -Seconds 1
}

function Show-QuickStart {
    $quickStartPath = "D:\workspace\fluxdype\WAN_QWEN_ARCHIVE_QUICKSTART.md"
    if (Test-Path $quickStartPath) {
        & notepad.exe $quickStartPath
    }
    else {
        Write-Host "Quick start guide not found." -ForegroundColor $colorError
        Wait-ForKey
    }
}

function Show-Documentation {
    $docPath = "D:\workspace\fluxdype\models_archive\wan_qwen\README.md"
    if (Test-Path $docPath) {
        & notepad.exe $docPath
    }
    else {
        Write-Host "Documentation not found." -ForegroundColor $colorError
        Wait-ForKey
    }
}

# Main loop
do {
    Show-Menu
    $choice = Select-Option

    switch ($choice) {
        "1" { Show-Status; Wait-ForKey }
        "2" { Start-Archive; Wait-ForKey }
        "3" { Start-Restore; Wait-ForKey }
        "4" { Show-Log -LogFile $ArchiveLog -Title "Archive Log" }
        "5" { Show-Log -LogFile $RestoreLog -Title "Restore Log" }
        "6" { Verify-Archive }
        "7" { Open-Folder }
        "8" { Show-QuickStart }
        "9" { Show-Documentation }
        "0" {
            Write-Host "Exiting..." -ForegroundColor $colorSuccess
            exit 0
        }
        default {
            Write-Host "Invalid choice. Please try again." -ForegroundColor $colorError
            Start-Sleep -Seconds 1
        }
    }
} while ($true)
