#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Safely removes conflicting and redundant custom nodes from ComfyUI

.DESCRIPTION
    This script performs the following tasks:
    1. Creates a backup directory for removed nodes
    2. Backs up all conflicting/redundant nodes
    3. Removes the conflicting nodes
    4. Logs all removed nodes
    5. Lists the final custom_nodes directory state

.NOTES
    - CORE NODES (never removed):
      * WAS Node Suite
      * ComfyUI-Impact-Pack
      * ComfyUI-Inspire-Pack
      * multi-lora-stack
      * x-flux-comfyui
      * ComfyUI_IPAdapter_plus
      * ComfyUI_UltimateSDUpscale
      * ComfyUI-RMBG
      * comfyui-dynamicprompts
      * ComfyUI-Manager

    - NODES TO REMOVE:
      * ComfyUI-GGUF (conflicts with Turbo LoRA workflows)
      * ComfyUI-IPAdapter-Flux (superseded by ComfyUI_IPAdapter_plus)
      * controlaltai-nodes (unmet dependencies, potential conflicts)
      * ComfyUI_InstantID (requires external APIs, authentication issues)
      * ComfyUI_Comfyroll_CustomNodes (deprecated, overlaps with core nodes)
      * efficiency-nodes-comfyui (deprecated, overlaps with essentials)
      * ComfyUI_essentials (has dependency conflicts with recent ComfyUI builds)
      * cg-use-everywhere (minimal usage, can be re-added if needed)
      * rgthree-comfy (overlaps with manager functionality)
      * ComfyUI-Custom-Scripts (low maintenance, overlaps with others)
      * comfyui_controlnet_aux (heavy dependencies, potential VRAM issues)

.PARAMETER SkipBackup
    If specified, skips creating backups (NOT RECOMMENDED)

.PARAMETER Force
    If specified, removes nodes without confirmation

.EXAMPLE
    PS> .\cleanup_custom_nodes.ps1
    # Runs with interactive confirmation

    PS> .\cleanup_custom_nodes.ps1 -Force
    # Removes without asking for confirmation
#>

param(
    [switch]$SkipBackup = $false,
    [switch]$Force = $false
)

# Color helper functions
function Write-Success {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Message)
    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Cyan
}

# Define paths
$rootPath = "D:\workspace\fluxdype"
$customNodesPath = "$rootPath\ComfyUI\custom_nodes"
$backupPath = "$rootPath\custom_nodes_removed_backup"
$logPath = "$rootPath\cleanup_custom_nodes_log.txt"

# Define nodes to keep (core nodes - NEVER remove)
$coreNodes = @(
    "was-node-suite-comfyui",
    "ComfyUI-Impact-Pack",
    "ComfyUI-Inspire-Pack",
    "multi-lora-stack",
    "x-flux-comfyui",
    "ComfyUI_IPAdapter_plus",
    "ComfyUI_UltimateSDUpscale",
    "ComfyUI-RMBG",
    "comfyui-dynamicprompts",
    "ComfyUI-Manager"
)

# Define nodes to remove
$nodesToRemove = @(
    @{
        Name = "ComfyUI-GGUF"
        Reason = "Conflicts with Turbo LoRA workflows, not needed for Flux"
        Priority = "HIGH"
    },
    @{
        Name = "ComfyUI-IPAdapter-Flux"
        Reason = "Superseded by ComfyUI_IPAdapter_plus"
        Priority = "HIGH"
    },
    @{
        Name = "controlaltai-nodes"
        Reason = "Unmet dependencies, potential conflicts with Flux workflow"
        Priority = "HIGH"
    },
    @{
        Name = "ComfyUI_InstantID"
        Reason = "Requires external APIs with authentication conflicts"
        Priority = "MEDIUM"
    },
    @{
        Name = "ComfyUI_Comfyroll_CustomNodes"
        Reason = "Deprecated, overlaps with core node functionality"
        Priority = "MEDIUM"
    },
    @{
        Name = "efficiency-nodes-comfyui"
        Reason = "Deprecated, overlaps with ComfyUI_essentials"
        Priority = "MEDIUM"
    },
    @{
        Name = "ComfyUI_essentials"
        Reason = "Dependency conflicts with recent ComfyUI builds"
        Priority = "MEDIUM"
    },
    @{
        Name = "cg-use-everywhere"
        Reason = "Minimal usage, can be re-added if needed"
        Priority = "LOW"
    },
    @{
        Name = "rgthree-comfy"
        Reason = "Overlaps with ComfyUI-Manager functionality"
        Priority = "LOW"
    },
    @{
        Name = "ComfyUI-Custom-Scripts"
        Reason = "Low maintenance, overlaps with other utilities"
        Priority = "LOW"
    },
    @{
        Name = "comfyui_controlnet_aux"
        Reason = "Heavy dependencies, potential VRAM issues with RTX 3090"
        Priority = "MEDIUM"
    }
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ComfyUI Custom Nodes Cleanup Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verify paths exist
if (-not (Test-Path $customNodesPath)) {
    Write-Error "Custom nodes path does not exist: $customNodesPath"
    exit 1
}

Write-Info "Custom nodes path: $customNodesPath"
Write-Info "Backup path: $backupPath"
Write-Info ""

# Initialize log
"ComfyUI Custom Nodes Cleanup Log - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Set-Content $logPath
"" | Add-Content $logPath

# Display nodes to be removed
Write-Host "Nodes to be REMOVED:" -ForegroundColor Yellow
Write-Host "-------------------" -ForegroundColor Yellow
$nodesToRemove | Group-Object -Property Priority | ForEach-Object {
    Write-Host ""
    Write-Host "$($_.Name) Priority:" -ForegroundColor Yellow
    $_.Group | ForEach-Object {
        Write-Host "  - $($_.Name)"
        Write-Host "    Reason: $($_.Reason)"
    }
}

Write-Host ""
Write-Host "CORE NODES (PROTECTED - will NOT be removed):" -ForegroundColor Green
$coreNodes | ForEach-Object { Write-Host "  - $_" -ForegroundColor Green }
Write-Host ""

# Ask for confirmation
if (-not $Force) {
    Write-Warning "This will backup and remove $($nodesToRemove.Count) custom node directories"
    $confirm = Read-Host "Continue? (yes/no)"
    if ($confirm -ne "yes") {
        Write-Info "Operation cancelled by user"
        exit 0
    }
}

# Create backup directory
if (-not $SkipBackup) {
    Write-Info "Creating backup directory..."
    if (-not (Test-Path $backupPath)) {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        Write-Success "Backup directory created: $backupPath"
    } else {
        Write-Info "Backup directory already exists: $backupPath"
    }

    "Backup directory created at: $backupPath" | Add-Content $logPath
}

# Process each node to remove
Write-Host ""
Write-Info "Processing node removals..."
$removedCount = 0
$skippedCount = 0

foreach ($node in $nodesToRemove) {
    $nodePath = Join-Path $customNodesPath $node.Name

    if (-not (Test-Path $nodePath)) {
        Write-Warning "Node directory not found (skipping): $($node.Name)"
        "SKIPPED: $($node.Name) - directory not found" | Add-Content $logPath
        $skippedCount++
        continue
    }

    # Check if it's a core node (safety check)
    if ($coreNodes -contains $node.Name) {
        Write-Error "CRITICAL: Attempted to remove core node: $($node.Name)"
        "ERROR: Attempted to remove protected core node: $($node.Name)" | Add-Content $logPath
        continue
    }

    Write-Info "Processing: $($node.Name) [$($node.Priority) priority]"

    # Backup if needed
    if (-not $SkipBackup) {
        $backupNodePath = Join-Path $backupPath $node.Name
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupNodePathTimestamped = "$backupNodePath`_$timestamp"

        try {
            Write-Host "  - Backing up to: $backupNodePathTimestamped" -ForegroundColor Gray
            Copy-Item -Path $nodePath -Destination $backupNodePathTimestamped -Recurse -Force
            Write-Success "  - Backup successful"
            "BACKED UP: $($node.Name) -> $backupNodePathTimestamped" | Add-Content $logPath
        } catch {
            Write-Error "Failed to backup $($node.Name): $_"
            "ERROR: Failed to backup $($node.Name): $_" | Add-Content $logPath
            continue
        }
    }

    # Remove the node directory
    try {
        Write-Host "  - Removing directory..." -ForegroundColor Gray
        Remove-Item -Path $nodePath -Recurse -Force
        Write-Success "  - Directory removed successfully"
        "REMOVED: $($node.Name) - Reason: $($node.Reason)" | Add-Content $logPath
        $removedCount++
    } catch {
        Write-Error "Failed to remove $($node.Name): $_"
        "ERROR: Failed to remove $($node.Name): $_" | Add-Content $logPath
    }
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Cleanup Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Success "Nodes removed: $removedCount"
Write-Warning "Nodes skipped: $skippedCount"

"" | Add-Content $logPath
"Cleanup Summary:" | Add-Content $logPath
"  - Nodes removed: $removedCount" | Add-Content $logPath
"  - Nodes skipped: $skippedCount" | Add-Content $logPath

# List remaining nodes
Write-Host ""
Write-Info "Final custom_nodes directory listing:"
Write-Host "------------------------------------" -ForegroundColor Cyan

$remainingNodes = @()
Get-ChildItem -Path $customNodesPath -Directory | ForEach-Object {
    $nodeName = $_.Name
    if ($nodeName -ne "__pycache__") {
        $remainingNodes += $nodeName
        $isCore = if ($coreNodes -contains $nodeName) { " [CORE]" } else { "" }
        Write-Host "  - $nodeName$isCore"
    }
}

"" | Add-Content $logPath
"Remaining nodes in $customNodesPath" + ":" | Add-Content $logPath
$remainingNodes | ForEach-Object { "  - $_" | Add-Content $logPath }

Write-Host ""
Write-Host "Total remaining nodes: $($remainingNodes.Count)" -ForegroundColor Cyan

"" | Add-Content $logPath
"Total remaining nodes: $($remainingNodes.Count)" | Add-Content $logPath
"" | Add-Content $logPath
"Cleanup completed at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Add-Content $logPath

# Display log file location
Write-Host ""
Write-Success "Cleanup log saved to: $logPath"
Write-Host ""

# Show backup location
if (-not $SkipBackup -and $removedCount -gt 0) {
    Write-Info "Backed up nodes can be found in: $backupPath"
    Write-Info "To restore a removed node:"
    Write-Host "  Copy-Item -Path '$backupPath\NodeName_timestamp' -Destination '$customNodesPath\NodeName' -Recurse"
    Write-Host ""
}

# Optional: Restart ComfyUI recommendation
Write-Warning "ComfyUI server should be restarted for changes to take effect:"
Write-Host "  1. Stop the ComfyUI server (Ctrl+C in its terminal)"
Write-Host "  2. Run: .\start-comfy.ps1"
Write-Host ""

Write-Success "Cleanup complete!"
