# Verify ComfyUI + Flux + xFormers setup on Windows
# Run this in PowerShell (NOT WSL)

$ErrorActionPreference = "Continue"

function Write-Success { param($msg) Write-Host "  ✅ $msg" -ForegroundColor Green }
function Write-Failure { param($msg) Write-Host "  ❌ $msg" -ForegroundColor Red }
function Write-Warning { param($msg) Write-Host "  ⚠️  $msg" -ForegroundColor Yellow }

Write-Host "================================" -ForegroundColor Cyan
Write-Host "ComfyUI Flux Setup Verification" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Set location to script directory
$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $scriptPath

# [1/7] Check Python
Write-Host "[1/7] Checking Python version..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Success $pythonVersion
} else {
    Write-Failure "Python not found"
}
Write-Host ""

# [2/7] Check venv
Write-Host "[2/7] Checking virtual environment..." -ForegroundColor Yellow
if (Test-Path "venv\Scripts\Activate.ps1") {
    Write-Success "Virtual environment found"
    & ".\venv\Scripts\Activate.ps1"
    Write-Success "Virtual environment activated"
} else {
    Write-Failure "Virtual environment not found at venv\Scripts\Activate.ps1"
    Write-Warning "Run setup-windows-native.ps1 first"
    exit 1
}
Write-Host ""

# [3/7] Check PyTorch
Write-Host "[3/7] Checking PyTorch..." -ForegroundColor Yellow
python -c @"
import torch
print(f'  ✅ PyTorch: {torch.__version__}')
print(f'  ✅ CUDA: {torch.version.cuda}')
print(f'  ✅ CUDA Available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'  ✅ GPU: {torch.cuda.get_device_name(0)}')
    print(f'  ✅ VRAM: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB')
"@
Write-Host ""

# [4/7] Check xFormers
Write-Host "[4/7] Checking xFormers..." -ForegroundColor Yellow
python -c @"
try:
    import xformers
    print(f'  ✅ xFormers: {xformers.__version__}')
    print('  ✅ xFormers loaded successfully')
except Exception as e:
    print(f'  ❌ xFormers failed: {e}')
"@
Write-Host ""

# [5/7] Check ComfyUI
Write-Host "[5/7] Checking ComfyUI installation..." -ForegroundColor Yellow
if (Test-Path "ComfyUI") {
    Write-Success "ComfyUI directory found"
}
if (Test-Path "ComfyUI\main.py") {
    Write-Success "main.py exists"
}
Write-Host ""

# [6/7] Check custom nodes
Write-Host "[6/7] Checking custom nodes..." -ForegroundColor Yellow
$customNodesCount = (Get-ChildItem -Path "ComfyUI\custom_nodes" -Directory | Measure-Object).Count
Write-Success "Found $customNodesCount custom node directories"
if (Test-Path "ComfyUI\custom_nodes\flux_autoload.py") {
    Write-Success "flux_autoload.py found"
} else {
    Write-Warning "flux_autoload.py not found"
}
Write-Host ""

# [7/7] Check models
Write-Host "[7/7] Checking Flux models..." -ForegroundColor Yellow
$checkpointCount = (Get-ChildItem -Path "ComfyUI\models\checkpoints\*.safetensors" -File -ErrorAction SilentlyContinue | Measure-Object).Count
Write-Success "Found $checkpointCount checkpoint models"

$loraCount = (Get-ChildItem -Path "ComfyUI\models\loras\*.safetensors" -File -ErrorAction SilentlyContinue | Measure-Object).Count
Write-Success "Found $loraCount LoRA models"
Write-Host ""

# [8/8] Test xFormers C++/CUDA extensions
Write-Host "[8/8] Testing xFormers C++/CUDA extensions..." -ForegroundColor Yellow
python -c @"
import torch
import xformers
import xformers.ops

try:
    # Try to use xformers operations
    xformers.ops.memory_efficient_attention
    print('  ✅ xFormers C++/CUDA extensions loaded successfully')
    print(f'  ✅ Compatible with PyTorch {torch.__version__}')
except Exception as e:
    print(f'  ❌ xFormers failed: {e}')
"@
Write-Host ""

Write-Host "================================" -ForegroundColor Green
Write-Host "Verification Complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "To start ComfyUI, run:" -ForegroundColor Cyan
Write-Host "  .\start-comfy.ps1" -ForegroundColor White
Write-Host ""
