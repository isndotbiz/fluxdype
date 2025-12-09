# Start ComfyUI in headless mode with PERFORMANCE OPTIMIZATIONS
# Usage: .\start-comfy-optimized.ps1
# The server will be accessible at http://localhost:8188
# Everything runs on D:\workspace\fluxdype (no C: drive involvement)
#
# OPTIMIZATIONS APPLIED (from community best practices 2025):
# - --highvram: Keep models in GPU memory (RTX 3090 24GB)
# - --force-fp16: 30-40% speed boost, minimal quality loss
# - --bf16-vae: BF16 precision for VAE
# - --bf16-text-enc: BF16 for text encoders
# - xformers: Already enabled via ComfyUI detection (15-25% boost)

$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $scriptPath

# Activate virtual environment
$venvPath = Join-Path $scriptPath "venv\Scripts\Activate.ps1"
if (Test-Path $venvPath) {
    & $venvPath
} else {
    Write-Error "Virtual environment not found at $venvPath"
    exit 1
}

# Start ComfyUI from the ComfyUI subfolder with optimization flags
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  Starting ComfyUI with PERFORMANCE OPTIMIZATIONS" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Server URL: http://localhost:8188" -ForegroundColor Green
Write-Host "Working directory: D:\workspace\fluxdype" -ForegroundColor Cyan
Write-Host ""
Write-Host "Optimizations enabled:" -ForegroundColor Yellow
Write-Host "  - High VRAM mode (keep models in GPU)" -ForegroundColor White
Write-Host "  - FP16 precision (30-40% faster)" -ForegroundColor White
Write-Host "  - BF16 VAE & Text Encoders" -ForegroundColor White
Write-Host "  - xformers (auto-detected, 15-25% faster)" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

cd ComfyUI
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch `
    --highvram `
    --force-fp16 `
    --bf16-vae `
    --bf16-text-enc
