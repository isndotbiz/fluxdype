#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Quick test of batch generation system
#>

Write-Host "=" -ForegroundColor Cyan -NoNewline
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host "FLUXDYPE BATCH GENERATOR - QUICK TEST" -ForegroundColor Cyan
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""

# Check if server is running
Write-Host "[1/4] Checking ComfyUI server..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8188/system_stats" -Method GET -TimeoutSec 5 -ErrorAction Stop
    Write-Host "  ✓ Server is running" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Server not running!" -ForegroundColor Red
    Write-Host "  → Start server: .\start-comfy.ps1" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Check if LoRAs exist
Write-Host "[2/4] Checking LoRA files..." -ForegroundColor Yellow
$requiredLoras = @(
    "ComfyUI\models\loras\ultrafluxV1.aWjp.safetensors",
    "ComfyUI\models\loras\facebookQuality.3t4R.safetensors",
    "ComfyUI\models\loras\FLUX.1-Turbo-Alpha.safetensors"
)

$allPresent = $true
foreach ($lora in $requiredLoras) {
    if (Test-Path $lora) {
        $name = Split-Path $lora -Leaf
        Write-Host "  ✓ $name" -ForegroundColor Green
    } else {
        $name = Split-Path $lora -Leaf
        Write-Host "  ✗ $name (missing)" -ForegroundColor Red
        $allPresent = $false
    }
}

if (-not $allPresent) {
    Write-Host ""
    Write-Host "  ⚠ Some LoRAs are missing. Generation may fail." -ForegroundColor Yellow
    Write-Host "  → Download: .\download_ultra_realistic_loras.py" -ForegroundColor Yellow
}

# Check Python environment
Write-Host "[3/4] Checking Python environment..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"

try {
    $pythonVersion = python --version 2>&1
    Write-Host "  ✓ $pythonVersion" -ForegroundColor Green

    # Check required packages
    $packages = @("requests")
    foreach ($pkg in $packages) {
        $installed = python -c "import $pkg; print('OK')" 2>&1
        if ($installed -eq "OK") {
            Write-Host "  ✓ Package: $pkg" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Package: $pkg (not installed)" -ForegroundColor Red
            Write-Host "  → Install: pip install $pkg" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "  ✗ Python not found in venv" -ForegroundColor Red
    exit 1
}

# Run test generation
Write-Host "[4/4] Running test generation..." -ForegroundColor Yellow
Write-Host "  → Generating 1 test image (fast quality)" -ForegroundColor Cyan
Write-Host ""

$testPrompt = "professional portrait of confident businesswoman, natural lighting, modern office background"

python batch_generate.py -p $testPrompt -q fast -r portrait -v 1

Write-Host ""
Write-Host "=" -ForegroundColor Cyan -NoNewline
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host "TEST COMPLETE" -ForegroundColor Green
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""
Write-Host "If test succeeded, you're ready to generate batches!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review: .\BATCH_GENERATION_GUIDE.md" -ForegroundColor White
Write-Host "  2. Edit prompts: .\prompts_phone_app.txt" -ForegroundColor White
Write-Host "  3. Generate batch: .\batch-generate.ps1 -File prompts_phone_app.txt" -ForegroundColor White
Write-Host ""
Write-Host "Output directory: D:\workspace\fluxdype\ComfyUI\output\" -ForegroundColor Cyan
