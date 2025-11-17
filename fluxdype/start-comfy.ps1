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

# Start ComfyUI from the ComfyUI subfolder
Write-Host "Starting ComfyUI on http://localhost:8188" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host "Working directory: D:\workspace\fluxdype" -ForegroundColor Cyan

cd ComfyUI
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch
