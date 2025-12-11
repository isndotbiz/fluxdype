# Fix Clipboard Issues (RDP)
# Usage: .\fix-clipboard.ps1

Write-Host "Restarting clipboard process..." -ForegroundColor Yellow

# Stop rdpclip
Stop-Process -Name rdpclip -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# Restart rdpclip
Start-Process rdpclip.exe

Start-Sleep -Seconds 1

# Test clipboard
Write-Host "Testing clipboard..." -ForegroundColor Cyan
Set-Clipboard -Value "Clipboard test - $(Get-Date)"
$test = Get-Clipboard

if ($test) {
    Write-Host "✓ Clipboard is working!" -ForegroundColor Green
    Write-Host "Current clipboard content: $test" -ForegroundColor Gray
} else {
    Write-Host "✗ Clipboard still not working. Try logging out and back in." -ForegroundColor Red
}
