# Install missing dependencies for custom nodes
cd D:\workspace\fluxdype

# Activate venv
& ".\venv\Scripts\Activate.ps1"

Write-Host "Installing missing dependencies..."
Write-Host ""

# List of missing packages
$packages = @(
    "deepdiff",
    "opencv-python",
    "diffusers",
    "platformdirs",
    "gguf"
)

foreach ($package in $packages) {
    Write-Host "Installing $package..."
    pip install $package --quiet 2>&1 | Select-String -Pattern "Successfully|Requirement" | Write-Host
}

Write-Host ""
Write-Host "Dependency installation complete!"
