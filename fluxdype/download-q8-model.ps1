# Download and Install Flux.1-Dev Q8 Model
# This script downloads from Civitai's delivery server and extracts to the correct directory

$ErrorActionPreference = "Stop"

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  DOWNLOADING FLUX.1-DEV Q8 GGUF MODEL" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$downloadUrl = "https://civitai-delivery-worker-prod.5ac0637cfd0766c97916cefa3764fbdf.r2.cloudflarestorage.com/model/98099/flux1DevQ80.nPmt.zip"
$modelDir = "D:\workspace\fluxdype\ComfyUI\models\diffusion_models"
$downloadFile = "flux1-dev-Q8.zip"
$tempDir = "D:\workspace\fluxdype\temp_extract"

Write-Host "URL: $downloadUrl" -ForegroundColor White
Write-Host "Size: ~11.9GB" -ForegroundColor Yellow
Write-Host "Destination: $modelDir" -ForegroundColor White
Write-Host ""

# Create directories if they don't exist
if (!(Test-Path $modelDir)) {
    Write-Host "Creating model directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $modelDir -Force | Out-Null
}

if (!(Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
}

# Download the model
Write-Host "Starting download (this may take 30-60 minutes depending on internet speed)..." -ForegroundColor Yellow
Write-Host ""

try {
    $ProgressPreference = 'Continue'
    Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadFile -UseBasicParsing
    Write-Host ""
    Write-Host "✅ Download completed successfully" -ForegroundColor Green

    # Check file size
    $fileSize = (Get-Item $downloadFile).Length / 1GB
    Write-Host "Downloaded file size: $([math]::Round($fileSize, 2))GB" -ForegroundColor Cyan
    Write-Host ""

    # Extract the ZIP file
    Write-Host "Extracting ZIP file..." -ForegroundColor Yellow
    Write-Host "This may take 5-10 minutes..." -ForegroundColor Yellow
    Write-Host ""

    Expand-Archive -Path $downloadFile -DestinationPath $tempDir -Force
    Write-Host "✅ Extraction completed" -ForegroundColor Green
    Write-Host ""

    # Find and move the model files
    Write-Host "Moving model files to $modelDir..." -ForegroundColor Yellow

    # Get all .safetensors files from the extracted directory
    $modelFiles = Get-ChildItem -Path $tempDir -Filter "*.safetensors" -Recurse

    if ($modelFiles.Count -eq 0) {
        Write-Host "❌ No .safetensors files found in extracted archive" -ForegroundColor Red
        exit 1
    }

    foreach ($file in $modelFiles) {
        $destination = Join-Path $modelDir $file.Name
        Write-Host "  Moving: $($file.Name)" -ForegroundColor White
        Copy-Item -Path $file.FullName -Destination $destination -Force
    }

    Write-Host "✅ Files moved successfully" -ForegroundColor Green
    Write-Host ""

    # Verify files exist
    Write-Host "Verifying files in $modelDir..." -ForegroundColor Yellow
    $q8Files = Get-ChildItem -Path $modelDir -Filter "*Q8*" -ErrorAction SilentlyContinue
    $allModels = Get-ChildItem -Path $modelDir -Filter "*.safetensors"

    Write-Host "Total models in diffusion_models: $($allModels.Count)" -ForegroundColor Cyan
    Write-Host ""
    foreach ($model in $allModels | Select-Object -Last 5) {
        $size = [math]::Round($model.Length / 1GB, 2)
        Write-Host "  OK: $($model.Name) ($size GB)" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "✅ Q8 MODEL INSTALLATION COMPLETE" -ForegroundColor Green
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Restart ComfyUI server" -ForegroundColor White
    Write-Host "2. Run comparison tests: python compare_fp16_vs_q8.py" -ForegroundColor White
    Write-Host ""

    # Cleanup
    Write-Host "Cleaning up temporary files..." -ForegroundColor Yellow
    Remove-Item -Path $downloadFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Cleanup complete" -ForegroundColor Green

} catch {
    Write-Host ""
    Write-Host "❌ Download failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Check internet connection" -ForegroundColor White
    Write-Host "2. Verify you have sufficient disk space (need ~25GB for download + extract)" -ForegroundColor White
    Write-Host "3. Try again after a few minutes" -ForegroundColor White
    Write-Host ""
    exit 1
}
