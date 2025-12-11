# Download Flux Kria GGUF from CivitAI
# Requires CIVITAI_API_KEY in .env file

param(
    [string]$Quantization = "Q8",  # Q8, Q4, Q2 options
    [string]$OutputDir = "D:\workspace\fluxdype\ComfyUI\models\unet"
)

Write-Host "=================================="
Write-Host "Flux Kria GGUF Download Helper"
Write-Host "=================================="
Write-Host ""

# Load .env file
if (Test-Path ".env") {
    Get-Content .env | ForEach-Object {
        if ($_ -match "^([^=]+)=(.*)$") {
            [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
        }
    }
}

$CivitAIKey = [System.Environment]::GetEnvironmentVariable("CIVITAI_API_KEY")

if (-not $CivitAIKey) {
    Write-Host "[WARNING] CIVITAI_API_KEY not found in .env"
    Write-Host ""
    Write-Host "Manual Download Instructions:"
    Write-Host "1. Go to: https://civitai.com"
    Write-Host "2. Search for: 'Flux Kria GGUF Q8'"
    Write-Host "3. Download the model file"
    Write-Host "4. Place in: $OutputDir"
    Write-Host ""
    Write-Host "Available GGUF versions:"
    Write-Host "  - Q8 (12.7 GB) - Best quality for RTX 3090"
    Write-Host "  - Q4 (6.8 GB) - Good balance, saves VRAM"
    Write-Host "  - Q2 (4.0 GB) - Smallest, lower quality"
    exit 0
}

Write-Host "CivitAI API Key found"
Write-Host ""
Write-Host "Searching for Flux Kria GGUF models on CivitAI..."
Write-Host ""

# Search for Flux Kria GGUF models
$SearchQuery = "flux kria gguf"
$ApiUrl = "https://civitai.com/api/v1/models?query=$SearchQuery&types=Checkpoint&limit=20"

try {
    $Response = Invoke-WebRequest -Uri $ApiUrl `
        -Headers @{"Authorization" = "Bearer $CivitAIKey"} `
        -ErrorAction Stop

    $Models = $Response.Content | ConvertFrom-Json

    if ($Models.items -and $Models.items.Count -gt 0) {
        Write-Host "Found $($Models.items.Count) models:"
        Write-Host ""

        foreach ($i in 0..([Math]::Min(5, $Models.items.Count - 1))) {
            $Model = $Models.items[$i]
            Write-Host "$($i+1). $($Model.name)"
            Write-Host "   ID: $($Model.id)"
            Write-Host "   Downloads: $($Model.stats.downloadCount)"
            Write-Host ""
        }

        Write-Host "[INFO] To download with API key, use the model ID above"
        Write-Host "[INFO] Example: .\download_flux_kria_gguf.ps1 -ModelId 1234567"
    } else {
        Write-Host "No models found. Try manual download from:"
        Write-Host "https://civitai.com/search/models?query=flux+kria+gguf"
    }
} catch {
    Write-Host "[ERROR] API request failed: $($_.Exception.Message)"
    Write-Host ""
    Write-Host "Manual Download Steps:"
    Write-Host "1. Open: https://civitai.com/search/models?query=flux+kria+gguf"
    Write-Host "2. Find 'Flux Kria GGUF Q8' or similar"
    Write-Host "3. Download the .gguf file"
    Write-Host "4. Place in: $OutputDir"
    Write-Host ""
    Write-Host "Creating output directory if needed..."
    if (-not (Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
        Write-Host "[OK] Created: $OutputDir"
    }
}

Write-Host ""
Write-Host "Expected models in CivitAI:"
Write-Host "  - FLUX.1-Kria GGUF (Q8) - ~12.7 GB"
Write-Host "  - FLUX.1-Kria GGUF (Q4_K_S) - ~6.8 GB"
Write-Host "  - Various community quantizations"
