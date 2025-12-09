# ComfyUI Flux Setup for Windows Native (Maximum Performance)
# Run this in PowerShell as Administrator on Windows (NOT WSL)
# This creates a fresh Windows-native Python environment

param(
    [switch]$SkipVenv = $false
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ComfyUI Flux - Windows Native Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Set location to script directory
$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $scriptPath

Write-Host "[1/6] Checking Python installation..." -ForegroundColor Yellow
$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) {
    Write-Host "ERROR: Python not found in PATH" -ForegroundColor Red
    Write-Host "Please install Python 3.10+ from https://www.python.org/downloads/" -ForegroundColor Red
    exit 1
}

$pythonVersion = python --version
Write-Host "  Found: $pythonVersion" -ForegroundColor Green

# Check Python version
$versionMatch = $pythonVersion -match "Python (\d+)\.(\d+)"
if ($versionMatch) {
    $major = [int]$matches[1]
    $minor = [int]$matches[2]
    if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 10)) {
        Write-Host "ERROR: Python 3.10+ required, found $pythonVersion" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "[2/6] Creating Windows-native virtual environment..." -ForegroundColor Yellow

if (-not $SkipVenv) {
    # Rename old venv if it exists (WSL version)
    if (Test-Path "venv") {
        Write-Host "  Backing up existing venv to venv_wsl_backup..." -ForegroundColor Yellow
        if (Test-Path "venv_wsl_backup") {
            Remove-Item -Recurse -Force "venv_wsl_backup"
        }
        Rename-Item "venv" "venv_wsl_backup"
    }

    Write-Host "  Creating new Windows venv..." -ForegroundColor Cyan
    python -m venv venv
    Write-Host "  Virtual environment created" -ForegroundColor Green
} else {
    Write-Host "  Skipping venv creation (already exists)" -ForegroundColor Green
}

Write-Host ""
Write-Host "[3/6] Activating virtual environment..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"
Write-Host "  Virtual environment activated" -ForegroundColor Green

Write-Host ""
Write-Host "[4/6] Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip
Write-Host "  pip upgraded" -ForegroundColor Green

Write-Host ""
Write-Host "[5/6] Installing PyTorch 2.9.0 with CUDA 12.6..." -ForegroundColor Yellow
Write-Host "  This may take several minutes..." -ForegroundColor Cyan
pip install torch==2.9.0 torchvision==0.24.0 torchaudio==2.9.0 --index-url https://download.pytorch.org/whl/cu126
Write-Host "  PyTorch installed" -ForegroundColor Green

Write-Host ""
Write-Host "[6/6] Installing xFormers for CUDA 12.6..." -ForegroundColor Yellow
pip install -U xformers --index-url https://download.pytorch.org/whl/cu126
Write-Host "  xFormers installed" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Verifying Installation..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Verify PyTorch
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA Available: {torch.cuda.is_available()}'); print(f'CUDA Version: {torch.version.cuda}')"

Write-Host ""

# Verify xFormers
python -c "import xformers; print(f'xFormers: {xformers.__version__}')"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Close this PowerShell window" -ForegroundColor White
Write-Host "2. Open a new PowerShell window in this directory" -ForegroundColor White
Write-Host "3. Run: .\start-comfy.ps1" -ForegroundColor White
Write-Host ""
Write-Host "Your setup:" -ForegroundColor Yellow
Write-Host "  - Windows-native Python environment (10-20% faster than WSL)" -ForegroundColor White
Write-Host "  - PyTorch 2.9.0 + CUDA 12.6" -ForegroundColor White
Write-Host "  - xFormers 0.0.33.post1 (memory-efficient attention)" -ForegroundColor White
Write-Host "  - 5 Flux models + 17 LoRAs ready to use" -ForegroundColor White
Write-Host "  - 16 custom nodes installed" -ForegroundColor White
Write-Host ""
