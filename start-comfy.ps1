# Start ComfyUI in headless mode on D: drive
# Usage: .\start-comfy.ps1
# The server will be accessible at http://localhost:8188
# Everything runs on D:\workspace\fluxdype (no C: drive involvement)

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

# Set optimal environment variables for GPU performance
$env:PYTORCH_ALLOC_CONF = "max_split_size_mb:1024,expandable_segments:True"
$env:CUDA_LAUNCH_BLOCKING = "0"
$env:CUDA_DEVICE_ORDER = "PCI_BUS_ID"
$env:PYTORCH_CUDA_ALLOC_CONF = "max_split_size_mb:1024,expandable_segments:True"

# Start ComfyUI from the ComfyUI subfolder
Write-Host "Starting ComfyUI on http://localhost:8188" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host "Working directory: D:\workspace\fluxdype" -ForegroundColor Cyan
Write-Host "GPU Optimization: PYTORCH_ALLOC_CONF enabled" -ForegroundColor Cyan

cd ComfyUI
# Optimized flags for RTX 3090 with BF16 precision and fast inference
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch `
  --bf16-unet `
  --bf16-vae `
  --fast fp16_accumulation
