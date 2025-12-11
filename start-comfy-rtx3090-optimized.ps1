# Start ComfyUI optimized for RTX 3090 24GB with Flux Dev FP8
# Based on comprehensive research for maximum performance

$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $scriptPath

Write-Host "=" -ForegroundColor Cyan -NoNewline; Write-Host ("=" * 79) -ForegroundColor Cyan
Write-Host "  ComfyUI - RTX 3090 24GB Optimized Launch (Flux Dev FP8)" -ForegroundColor Green
Write-Host "=" -ForegroundColor Cyan -NoNewline; Write-Host ("=" * 79) -ForegroundColor Cyan
Write-Host ""

# Activate virtual environment
Write-Host "[1/5] Activating Python virtual environment..." -ForegroundColor Yellow
$venvPath = Join-Path $scriptPath "venv\Scripts\Activate.ps1"
if (Test-Path $venvPath) {
    & $venvPath
    Write-Host "      SUCCESS: venv activated" -ForegroundColor Green
} else {
    Write-Error "Virtual environment not found at $venvPath"
    exit 1
}
Write-Host ""

# Load environment variables from .env
Write-Host "[2/5] Loading environment configuration..." -ForegroundColor Yellow
if (Test-Path "$scriptPath\.env") {
    Get-Content "$scriptPath\.env" | ForEach-Object {
        if ($_ -match '^([^#][^=]+)=(.+)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            Set-Item -Path "env:$name" -Value $value
        }
    }
    Write-Host "      SUCCESS: .env loaded" -ForegroundColor Green
} else {
    Write-Host "      WARNING: .env not found (optional)" -ForegroundColor DarkYellow
}
Write-Host ""

# Set critical PyTorch/CUDA optimization environment variables
Write-Host "[3/5] Configuring PyTorch/CUDA optimizations..." -ForegroundColor Yellow

# Memory fragmentation prevention (CRITICAL for Flux)
$env:PYTORCH_CUDA_ALLOC_CONF = "expandable_segments:True,max_split_size_mb:128"

# Performance settings
$env:CUDA_LAUNCH_BLOCKING = "0"                     # Async kernel launches
$env:CUDA_DEVICE_ORDER = "PCI_BUS_ID"               # Consistent GPU numbering
$env:TORCH_USE_CUDA_DSA = "1"                       # Better error messages
$env:CUDNN_BENCHMARK = "1"                          # cuDNN auto-tuning (5-10% speedup)
$env:CUDA_VISIBLE_DEVICES = "0"                     # Use first GPU only

Write-Host "      PYTORCH_CUDA_ALLOC_CONF = expandable_segments:True,max_split_size_mb:128" -ForegroundColor Gray
Write-Host "      CUDNN_BENCHMARK = 1" -ForegroundColor Gray
Write-Host "      CUDA_LAUNCH_BLOCKING = 0" -ForegroundColor Gray
Write-Host "      SUCCESS: Environment variables set" -ForegroundColor Green
Write-Host ""

# Display optimization summary
Write-Host "[4/5] Optimization Configuration:" -ForegroundColor Yellow
Write-Host "      GPU: NVIDIA RTX 3090 24GB" -ForegroundColor Gray
Write-Host "      Memory Mode: --highvram (24GB optimized)" -ForegroundColor Gray
Write-Host "      Precision: FP16 UNet, FP32 VAE, FP8 Text Encoders" -ForegroundColor Gray
Write-Host "      Attention: PyTorch Native Cross-Attention" -ForegroundColor Gray
Write-Host "      Optimizations: FP16 accumulation, cuBLAS ops, channels-last" -ForegroundColor Gray
Write-Host "      Memory Management: Expandable segments, anti-fragmentation" -ForegroundColor Gray
Write-Host "      VRAM Reserve: 2GB for system stability" -ForegroundColor Gray
Write-Host ""

Write-Host "[5/5] Launching ComfyUI Server..." -ForegroundColor Yellow
Write-Host "      Server URL: http://localhost:8188" -ForegroundColor Cyan
Write-Host "      WebUI: http://localhost:8188" -ForegroundColor Cyan
Write-Host "      Press Ctrl+C to stop the server" -ForegroundColor DarkYellow
Write-Host ""
Write-Host "=" -ForegroundColor Cyan -NoNewline; Write-Host ("=" * 79) -ForegroundColor Cyan
Write-Host ""

cd ComfyUI

# Launch ComfyUI with RTX 3090-optimized flags
python main.py `
  --listen 0.0.0.0 `
  --port 8188 `
  --disable-auto-launch `
  --highvram `
  --fp16-unet `
  --fp32-vae `
  --fp8_e4m3fn-text-enc `
  --force-channels-last `
  --use-pytorch-cross-attention `
  --fast fp16_accumulation cublas_ops `
  --reserve-vram 2 `
  --preview-method auto `
  --cuda-malloc
