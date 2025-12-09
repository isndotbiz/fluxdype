# Download GGUF Q8 Models for Comparison
# These downloads require Civitai access
# Instructions:
# 1. Visit https://civitai.com/models/647237 in your browser
# 2. Click "Download" on the Q8_0 version
# 3. Extract the .zip file to: D:\workspace\fluxdype\ComfyUI\models\diffusion_models\
#
# MANUAL DOWNLOAD LINKS:
# - Flux.1-Dev Q8: https://civitai.com/models/647237/flux1-dev-gguf-q2k-q3ks-q4q41q4ks-q5q51q5ks-q6k-q8
# - Flux Fusion V2: https://civitai.com/models/630820/flux-fusion-v2-4-steps-gguf-nf4-fp8fp16
# - HyperFlux Diversity: https://civitai.com/models/1023476/hyperflux-diversity

Write-Host "GGUF Q8 Model Download Instructions" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Flux.1-Dev Q8 (Base Model - Recommended)" -ForegroundColor Green
Write-Host "   URL: https://civitai.com/models/647237" -ForegroundColor White
Write-Host "   Size: 11.9GB" -ForegroundColor White
Write-Host "   Installation: Extract to D:\workspace\fluxdype\ComfyUI\models\diffusion_models\" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Alternative: Flux Fusion V2 (4-step accelerated)" -ForegroundColor Green
Write-Host "   URL: https://civitai.com/models/630820" -ForegroundColor White
Write-Host "   Size: ~4GB" -ForegroundColor White
Write-Host "   Installation: Extract to D:\workspace\fluxdype\ComfyUI\models\diffusion_models\" -ForegroundColor Yellow
Write-Host ""
Write-Host "After downloading and extracting:" -ForegroundColor Cyan
Write-Host "1. Restart ComfyUI" -ForegroundColor White
Write-Host "2. Run: .\compare_models.ps1" -ForegroundColor White
Write-Host ""
Write-Host "Expected benefits of Q8:" -ForegroundColor Cyan
Write-Host "  - 50% smaller file size (12GB vs 23GB)" -ForegroundColor White
Write-Host "  - 99% quality (nearly lossless)" -ForegroundColor White
Write-Host "  - Same or faster inference speed" -ForegroundColor White
Write-Host ""
