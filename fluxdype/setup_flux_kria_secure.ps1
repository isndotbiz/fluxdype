<#
ComfyUI + Flux Kria FP8 One‑Shot Secure Installer (RTX 3090)
Created for Claude CLI / local execution
#>

Write-Host "=== Secure ComfyUI + Flux Kria Setup Starting ===" -ForegroundColor Cyan

# -------------------------------
#  USER CONFIGURATION
# -------------------------------
# Load environment variables from .env file
if (Test-Path "$PSScriptRoot\.env") {
    Get-Content "$PSScriptRoot\.env" | ForEach-Object {
        if ($_ -match '^([^#][^=]+)=(.+)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            Set-Item -Path "env:$name" -Value $value
        }
    }
    Write-Host "✓ Loaded credentials from .env file" -ForegroundColor Green
} else {
    Write-Host "⚠ Warning: .env file not found. Please create one based on .env.example" -ForegroundColor Yellow
    exit 1
}
# -------------------------------

$WorkDir = "$PSScriptRoot"  # Use current directory (fluxdype)
$VenvPath = "$WorkDir\venv"
$RepoURL  = "https://github.com/comfyanonymous/ComfyUI.git"
$HF_BASE  = "https://huggingface.co"
$Headers  = @{ Authorization = "Bearer $env:HUGGINGFACE_TOKEN" }

# -------------------------------
#  SETUP
# -------------------------------
Write-Host "`n[1/6] Preparing workspace..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
Set-Location $WorkDir

if (-not (Test-Path "$WorkDir\ComfyUI")) {
    git clone $RepoURL
}
Set-Location "$WorkDir\ComfyUI"

Write-Host "`n[2/6] Creating Python venv..." -ForegroundColor Cyan
python -m venv $VenvPath
& "$VenvPath\Scripts\activate.ps1"

Write-Host "`n[3/6] Installing dependencies..." -ForegroundColor Cyan
pip install --upgrade pip wheel setuptools
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
pip install diffusers transformers accelerate safetensors sentencepiece tqdm pillow opencv-python einops xformers flash-attn

# -------------------------------
#  FOLDER STRUCTURE
# -------------------------------
Write-Host "`n[4/6] Creating model folders..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "models/diffusion_models" | Out-Null
New-Item -ItemType Directory -Force -Path "models/vae" | Out-Null
New-Item -ItemType Directory -Force -Path "models/text_encoders" | Out-Null

# -------------------------------
#  DOWNLOADING MODELS (Hugging Face)
# -------------------------------
Write-Host "`n[5/6] Downloading required models securely..." -ForegroundColor Cyan

# helper function
function Get-HFModel {
    param($RepoPath, $FileName, $TargetDir)
    $url = "$HF_BASE/$RepoPath/resolve/main/$FileName"
    $dest = "$TargetDir\$FileName"
    if (-not (Test-Path $dest)) {
        Write-Host "→ Downloading $FileName ..."
        Invoke-WebRequest -Uri $url -Headers $Headers -OutFile $dest
    } else {
        Write-Host "$FileName already exists. Skipping."
    }
}

# Example repos (replace if you use different forks)
Get-HFModel "nextdiffusion/flux-kria-fp8"          "flux1-kria-dev_fp8_scaled.safetensors" "models\diffusion_models"
Get-HFModel "nextdiffusion/autoencoder"            "ae.safetensors"                        "models\vae"
Get-HFModel "nextdiffusion/clip-text-encoders"     "clip_l.safetensors"                    "models\text_encoders"
Get-HFModel "nextdiffusion/t5xxl-text-encoder"     "t5xxl_fp16.safetensors"                "models\text_encoders"

Write-Host "`n✅ Model downloads complete!"

# -------------------------------
#  LAUNCH COMFYUI
# -------------------------------
Write-Host "`n[6/6] Launching ComfyUI optimized for RTX 3090..." -ForegroundColor Cyan
python main.py --listen `
 --precision=bf16 `
 --xformers `
 --opt-sdp-no-mem-attention `
 --opt-channelslast `
 --no-half-vae `
 --force-enable-xformers

Write-Host "`n✨ ComfyUI launched — open http://127.0.0.1:8188 in your browser."