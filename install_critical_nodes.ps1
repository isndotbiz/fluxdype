# ============================================================================
# ComfyUI Critical Custom Nodes Installation Script
# ============================================================================
# This script installs 7 priority custom nodes for ComfyUI
# Location: D:\workspace\fluxdype\ComfyUI\custom_nodes\
#
# USAGE:
#   .\install_critical_nodes.ps1           # Install all nodes
#   .\install_critical_nodes.ps1 -DepsOnly # Only install Python dependencies
# ============================================================================

param(
    [switch]$DepsOnly = $false
)

$ErrorActionPreference = "Stop"

# Configuration
$COMFY_ROOT = "D:\workspace\fluxdype"
$CUSTOM_NODES_DIR = "$COMFY_ROOT\ComfyUI\custom_nodes"
$VENV_PYTHON = "$COMFY_ROOT\venv\Scripts\python.exe"

# Node definitions: [Name, GitHub URL, HasRequirements]
$nodes = @(
    @{
        Name = "was-node-suite-comfyui"
        Url = "https://github.com/ltdrdata/was-node-suite-comfyui"
        Description = "210+ utility nodes (industry standard)"
        HasRequirements = $true
    },
    @{
        Name = "ComfyUI_UltimateSDUpscale"
        Url = "https://github.com/ssitu/ComfyUI_UltimateSDUpscale"
        Description = "Professional 4K/8K upscaling"
        HasRequirements = $false
    },
    @{
        Name = "ComfyUI-Inspire-Pack"
        Url = "https://github.com/ltdrdata/ComfyUI-Inspire-Pack"
        Description = "Advanced sampling and prompts"
        HasRequirements = $true
    },
    @{
        Name = "ComfyUI-RMBG"
        Url = "https://github.com/1038lab/ComfyUI-RMBG"
        Description = "BiRefNet background removal"
        HasRequirements = $true
    },
    @{
        Name = "ComfyUI_IPAdapter_plus"
        Url = "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
        Description = "Style consistency with IP-Adapter"
        HasRequirements = $false
    },
    @{
        Name = "multi-lora-stack"
        Url = "https://github.com/ShmuelRonen/multi-lora-stack"
        Description = "Clean LoRA organization"
        HasRequirements = $false
    },
    @{
        Name = "comfyui-dynamicprompts"
        Url = "https://github.com/adieyal/comfyui-dynamicprompts"
        Description = "Batch prompt variations"
        HasRequirements = $true
        HasInstallScript = $true
    }
)

Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "ComfyUI Critical Custom Nodes Installation" -ForegroundColor Cyan
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host ""

# Check if venv exists
if (-not (Test-Path $VENV_PYTHON)) {
    Write-Host "[ERROR] Virtual environment not found at: $VENV_PYTHON" -ForegroundColor Red
    Write-Host "Please run setup_flux_kria_secure.ps1 first to create the venv." -ForegroundColor Yellow
    exit 1
}

Write-Host "[INFO] Using Python: $VENV_PYTHON" -ForegroundColor Green
Write-Host ""

# Create custom_nodes directory if it doesn't exist
if (-not (Test-Path $CUSTOM_NODES_DIR)) {
    Write-Host "[INFO] Creating custom_nodes directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $CUSTOM_NODES_DIR -Force | Out-Null
}

Set-Location $CUSTOM_NODES_DIR

# ============================================================================
# Step 1: Clone repositories (skip if -DepsOnly)
# ============================================================================
if (-not $DepsOnly) {
    Write-Host "Step 1: Cloning custom node repositories..." -ForegroundColor Cyan
    Write-Host "------------------------------------------------------------" -ForegroundColor Cyan

    foreach ($node in $nodes) {
        $nodePath = Join-Path $CUSTOM_NODES_DIR $node.Name

        if (Test-Path $nodePath) {
            Write-Host "[SKIP] $($node.Name) already exists" -ForegroundColor Yellow
        } else {
            Write-Host "[CLONE] $($node.Name) - $($node.Description)" -ForegroundColor Green
            git clone $node.Url 2>&1 | Out-Null

            if ($LASTEXITCODE -eq 0) {
                Write-Host "        Success!" -ForegroundColor Green
            } else {
                Write-Host "        [ERROR] Failed to clone $($node.Name)" -ForegroundColor Red
            }
        }
    }
    Write-Host ""
}

# ============================================================================
# Step 2: Install Python dependencies
# ============================================================================
Write-Host "Step 2: Installing Python dependencies..." -ForegroundColor Cyan
Write-Host "------------------------------------------------------------" -ForegroundColor Cyan

foreach ($node in $nodes) {
    $nodePath = Join-Path $CUSTOM_NODES_DIR $node.Name
    $requirementsPath = Join-Path $nodePath "requirements.txt"

    if (-not (Test-Path $nodePath)) {
        Write-Host "[SKIP] $($node.Name) - Not installed" -ForegroundColor Yellow
        continue
    }

    if ($node.HasRequirements -and (Test-Path $requirementsPath)) {
        Write-Host "[INSTALL] $($node.Name) dependencies..." -ForegroundColor Green

        try {
            & $VENV_PYTHON -m pip install -r $requirementsPath --quiet

            if ($LASTEXITCODE -eq 0) {
                Write-Host "          Success!" -ForegroundColor Green
            } else {
                Write-Host "          [WARNING] Some dependencies may have failed" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "          [ERROR] Failed to install dependencies: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "[SKIP] $($node.Name) - No requirements.txt" -ForegroundColor Gray
    }

    # Run install.py if it exists (for comfyui-dynamicprompts)
    if ($node.HasInstallScript) {
        $installScriptPath = Join-Path $nodePath "install.py"
        if (Test-Path $installScriptPath) {
            Write-Host "[RUN] $($node.Name) install script..." -ForegroundColor Green
            & $VENV_PYTHON $installScriptPath
            if ($LASTEXITCODE -eq 0) {
                Write-Host "      Install script completed!" -ForegroundColor Green
            }
        }
    }
}

Write-Host ""

# ============================================================================
# Step 3: Summary
# ============================================================================
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Installed nodes:" -ForegroundColor Yellow

foreach ($node in $nodes) {
    $nodePath = Join-Path $CUSTOM_NODES_DIR $node.Name
    if (Test-Path $nodePath) {
        $status = if ($node.HasRequirements) { "with dependencies" } else { "no dependencies" }
        Write-Host "  [OK] $($node.Name) - $status" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $($node.Name)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "IMPORTANT: Restart ComfyUI for changes to take effect" -ForegroundColor Yellow
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To restart ComfyUI:" -ForegroundColor White
Write-Host "  1. Stop the current ComfyUI process (Ctrl+C)" -ForegroundColor White
Write-Host "  2. Run: .\start-comfy.ps1" -ForegroundColor White
Write-Host ""
Write-Host "Verify installation:" -ForegroundColor White
Write-Host "  - Open http://localhost:8188 in your browser" -ForegroundColor White
Write-Host "  - Right-click on canvas -> Add Node" -ForegroundColor White
Write-Host "  - Look for new node categories (WAS, Inspire, etc.)" -ForegroundColor White
Write-Host ""
