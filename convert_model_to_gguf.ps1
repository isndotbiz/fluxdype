# Automated GGUF Model Conversion Script
# Converts SafeTensors models to optimized GGUF format

param(
    [string]$ModelPath = "",
    [string]$ModelName = "flux-dev",
    [string]$Quantization = "Q8_0",  # Q8_0, Q6, Q5, Q4_K_S, Q3_K_S, Q2_K
    [switch]$SkipIntermediate = $false
)

# Color output helpers
$RED = "`e[31m"
$GREEN = "`e[32m"
$YELLOW = "`e[33m"
$BLUE = "`e[34m"
$RESET = "`e[0m"

Write-Host "${BLUE}=================================${RESET}"
Write-Host "${BLUE}GGUF Model Conversion Tool${RESET}"
Write-Host "${BLUE}=================================${RESET}"
Write-Host ""

# Helper function to show progress
function Show-Progress {
    param([string]$Message)
    Write-Host "${BLUE}[INFO]${RESET} $Message"
}

function Show-Success {
    param([string]$Message)
    Write-Host "${GREEN}[OK]${RESET} $Message"
}

function Show-Error {
    param([string]$Message)
    Write-Host "${RED}[ERROR]${RESET} $Message"
}

function Show-Warning {
    param([string]$Message)
    Write-Host "${YELLOW}[WARNING]${RESET} $Message"
}

# Step 0: Validate parameters
if (-not $ModelPath) {
    Write-Host "Available models:"
    Write-Host ""
    ls D:\workspace\fluxdype\ComfyUI\models\diffusion_models\*.safetensors | ForEach-Object {
        Write-Host "  - $($_.Name) ($([math]::Round($_.Length/1GB, 1)) GB)"
    }
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\convert_model_to_gguf.ps1 -ModelPath 'path/to/model.safetensors' -ModelName 'flux-dev' -Quantization 'Q8_0'"
    Write-Host ""
    Write-Host "Quantization options: Q8_0 (best), Q6, Q5, Q4_K_S, Q3_K_S, Q2_K (smallest)"
    exit 1
}

# Step 1: Validate input file
Show-Progress "Validating input model..."

if (-not (Test-Path $ModelPath)) {
    Show-Error "Model not found: $ModelPath"
    exit 1
}

$FileInfo = Get-Item $ModelPath
$FileSizeGB = [math]::Round($FileInfo.Length / 1GB, 2)
Show-Success "Found model: $($FileInfo.Name) ($FileSizeGB GB)"

# Step 2: Check disk space
Show-Progress "Checking disk space..."

$DiskInfo = Get-Volume D: | Select-Object @{N='FreeGB';E={[math]::Round($_.SizeRemaining/1GB)}}
$FreeSpaceGB = $DiskInfo.FreeGB

# Need at least 2x the model size for conversion + quantization
$RequiredSpaceGB = [math]::Ceiling($FileSizeGB * 2.5)

Write-Host "  Available: $FreeSpaceGB GB"
Write-Host "  Required:  $RequiredSpaceGB GB"
Write-Host ""

if ($FreeSpaceGB -lt $RequiredSpaceGB) {
    Show-Warning "Low disk space! May fail."
    $Continue = Read-Host "Continue anyway? (y/n)"
    if ($Continue -ne 'y') {
        exit 0
    }
}
else {
    Show-Success "Sufficient disk space available"
}

# Step 3: Setup conversion directory
Show-Progress "Setting up conversion environment..."

$ConversionDir = "D:\workspace\fluxdype\gguf_conversion"
$LlamaDir = "$ConversionDir\llama.cpp"
$OutputDir = "D:\workspace\fluxdype\ComfyUI\models\unet"

if (-not (Test-Path $ConversionDir)) {
    New-Item -ItemType Directory -Path $ConversionDir -Force | Out-Null
    Show-Success "Created conversion directory"
}

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    Show-Success "Created output directory"
}

# Step 4: Clone llama.cpp if needed
if (-not (Test-Path $LlamaDir)) {
    Show-Progress "Cloning llama.cpp (first time only)..."
    Push-Location $ConversionDir

    git clone https://github.com/ggerganov/llama.cpp | Out-Null

    if ($LASTEXITCODE -ne 0) {
        Show-Error "Failed to clone llama.cpp"
        Pop-Location
        exit 1
    }

    Show-Success "llama.cpp cloned"
    Pop-Location
}

# Step 5: Install dependencies
Show-Progress "Installing Python dependencies..."

Push-Location $LlamaDir

pip install numpy pillow requests -q 2>&1 | Out-Null

Show-Success "Dependencies installed"

# Step 6: Convert to FP16 GGUF
Show-Progress "Converting model to GGUF format..."
Write-Host "  This may take 2-5 minutes..."
Write-Host ""

$FP16Output = Join-Path $LlamaDir "$ModelName-fp16.gguf"
$StartTime = Get-Date

python convert-hf-to-gguf.py --outfile $FP16Output $ModelPath

if ($LASTEXITCODE -ne 0) {
    Show-Error "Conversion failed"
    Pop-Location
    exit 1
}

$ConversionTime = [int]((Get-Date) - $StartTime).TotalSeconds
Show-Success "Conversion complete in ${ConversionTime}s"

# Check file size
$FP16Size = Get-Item $FP16Output
$FP16SizeGB = [math]::Round($FP16Size.Length / 1GB, 2)
Write-Host "  Output: $FP16SizeGB GB"

# Step 7: Quantize
Show-Progress "Quantizing to $Quantization..."
Write-Host "  This may take 1-3 minutes..."
Write-Host ""

$QuantizedOutput = Join-Path $OutputDir "$ModelName-$Quantization.gguf"
$StartTime = Get-Date

.\llama-quantize $FP16Output $QuantizedOutput $Quantization

if ($LASTEXITCODE -ne 0) {
    Show-Error "Quantization failed"
    Pop-Location
    exit 1
}

$QuantizationTime = [int]((Get-Date) - $StartTime).TotalSeconds
Show-Success "Quantization complete in ${QuantizationTime}s"

# Check final file size
$QuantizedSize = Get-Item $QuantizedOutput
$QuantizedSizeGB = [math]::Round($QuantizedSize.Length / 1GB, 2)
Write-Host "  Output: $QuantizedSizeGB GB"

$Reduction = [math]::Round((1 - ($QuantizedSizeGB / $FileSizeGB)) * 100, 1)
Write-Host "  Reduction: $Reduction%"

# Step 8: Cleanup
Show-Progress "Cleaning up intermediate files..."

if ($SkipIntermediate -eq $false) {
    Remove-Item $FP16Output -Force
    Show-Success "Removed FP16 intermediate"
}

Pop-Location

# Step 9: Summary
Write-Host ""
Write-Host "${GREEN}=================================${RESET}"
Write-Host "${GREEN}Conversion Complete!${RESET}"
Write-Host "${GREEN}=================================${RESET}"
Write-Host ""
Write-Host "Original model:  $FileSizeGB GB"
Write-Host "Quantized:       $QuantizedSizeGB GB ($Quantization)"
Write-Host "Saved:           $(($FileSizeGB - $QuantizedSizeGB).ToString('F2')) GB"
Write-Host ""
Write-Host "Output location:"
Write-Host "  ${BLUE}$QuantizedOutput${RESET}"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Restart ComfyUI server"
Write-Host "  2. Load UnetLoaderGGUF node"
Write-Host "  3. Select: $ModelName-$Quantization.gguf"
Write-Host "  4. Generate image to test"
Write-Host ""
