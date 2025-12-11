# Generate test images with production photorealistic turbo workflow
# Tests the complete Flux Kria + Turbo LoRA system with high-quality settings

$workflowPath = "D:\workspace\fluxdype\workflows\production_photorealistic_turbo.json"
$outputDir = "D:\workspace\fluxdype\ComfyUI\output"
$server = "http://localhost:8188"

# High-quality test prompts emphasizing professional photography
$testPrompts = @(
    "luxury watch product photograph, professional studio lighting, sharp focus, 8k, high contrast, crystal clear, museum quality, perfectly exposed",
    "professional headshot portrait, studio portrait lighting, cinematic lighting, perfect skin texture, best quality, award-winning photography, ultra realistic",
    "high-end cosmetics product photography, dramatic lighting, vibrant colors, sharp focus, professional quality, e-commerce ready, commercial grade",
    "professional architecture photography, modern building facade, golden hour lighting, perfect composition, technical perfection, award-winning, 8k detail",
    "premium jewelry product shot, studio macro photography, professional lighting, crystal sharp, best quality, museum piece, perfectly lit, high contrast"
)

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "FLUX KRIA FP8 + TURBO LORA TEST IMAGE GENERATION" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Load the workflow
if (-not (Test-Path $workflowPath)) {
    Write-Host "ERROR: Workflow not found at $workflowPath" -ForegroundColor Red
    exit 1
}

$workflow = Get-Content $workflowPath -Raw | ConvertFrom-Json
Write-Host "[OK] Loaded workflow: $(($workflow.workflow_info).name)" -ForegroundColor Green
Write-Host "     Resolution: $(($workflow.workflow_info).resolution)" -ForegroundColor Green
Write-Host "     Expected time: $(($workflow.workflow_info).inference_time_seconds)s per image" -ForegroundColor Green
Write-Host ""

# Test 1: Check server connectivity
Write-Host "Testing server connectivity..." -ForegroundColor Yellow
try {
    $health = Invoke-WebRequest -Uri "$server/system_stats" -TimeoutSec 3 | ConvertFrom-Json
    Write-Host "[OK] ComfyUI server online at $server" -ForegroundColor Green
    $ramFree = [math]::Round($health.ram_free / 1GB, 1)
    $ramTotal = [math]::Round($health.ram_total / 1GB, 1)
    Write-Host "     VRAM available: ${ramFree}GB / ${ramTotal}GB" -ForegroundColor Cyan
    Write-Host "     ComfyUI version: $($health.comfyui_version)" -ForegroundColor Cyan
} catch {
    Write-Host "ERROR: Cannot connect to ComfyUI server at $server" -ForegroundColor Red
    Write-Host "Make sure ComfyUI is running: .\start-comfy.ps1" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Test 2: Verify all required models are available
Write-Host "Verifying model availability..." -ForegroundColor Yellow
$requiredModels = @(
    "ComfyUI/models/diffusion_models/flux1-krea-dev_fp8_scaled.safetensors",
    "ComfyUI/models/text_encoders/clip_l.safetensors",
    "ComfyUI/models/text_encoders/t5xxl_fp16.safetensors",
    "ComfyUI/models/vae/ae.safetensors",
    "ComfyUI/models/loras/FLUX.1-Turbo-Alpha.safetensors"
)

$missingModels = @()
foreach ($model in $requiredModels) {
    $fullPath = "D:\workspace\fluxdype\$model"
    if (Test-Path $fullPath) {
        $size = [math]::Round((Get-Item $fullPath).Length / 1GB, 1)
        Write-Host "[OK] $(Split-Path $model -Leaf) (${size}GB)" -ForegroundColor Green
    } else {
        $missingModels += $model
        Write-Host "[!] $(Split-Path $model -Leaf) - MISSING" -ForegroundColor Red
    }
}

if ($missingModels.Count -gt 0) {
    Write-Host ""
    Write-Host "ERROR: Missing required models:" -ForegroundColor Red
    $missingModels | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}
Write-Host ""

# Generate test images with different prompts
$imageCount = 0
$totalTime = 0
$failedCount = 0

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "GENERATING TEST IMAGES" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

foreach ($i in 0..($testPrompts.Count - 1)) {
    $prompt = $testPrompts[$i]
    $testNum = $i + 1

    Write-Host "Test $testNum / $($testPrompts.Count): Generating high-quality photorealistic image..." -ForegroundColor Yellow
    $promptPreview = if ($prompt.Length -gt 70) { $prompt.Substring(0, 70) + "..." } else { $prompt }
    Write-Host "     Prompt: $promptPreview" -ForegroundColor Cyan

    try {
        # Update positive prompt in workflow
        $workflow.prompt."4".inputs.text = $prompt

        # Set random seed for variation
        $workflow.prompt."9".inputs.seed = Get-Random -Minimum 0 -Maximum 4294967295

        # Submit workflow
        $startTime = Get-Date
        $response = Invoke-WebRequest -Uri "$server/prompt" `
            -Method POST `
            -ContentType "application/json" `
            -Body ($workflow | ConvertTo-Json -Depth 10) `
            -TimeoutSec 60

        $jobData = $response.Content | ConvertFrom-Json
        $promptId = $jobData.prompt_id
        $promptIdShort = $promptId.Substring(0, 8)

        Write-Host "     [OK] Submitted (Job ID: ${promptIdShort}...)" -ForegroundColor Green

        # Wait for completion
        $completed = $false
        $waitTime = 0
        $maxWait = 120

        while (-not $completed -and $waitTime -lt $maxWait) {
            Start-Sleep -Seconds 1
            $waitTime++

            try {
                $history = Invoke-WebRequest -Uri "$server/history/$promptId" -TimeoutSec 5 | ConvertFrom-Json

                if ($history.$promptId) {
                    $completed = $true
                    $elapsedTime = (Get-Date) - $startTime
                    $elapsed = [math]::Round($elapsedTime.TotalSeconds, 1)
                    Write-Host "     [OK] Completed in ${elapsed}s" -ForegroundColor Green
                    $totalTime += $elapsedTime.TotalSeconds
                    $imageCount++
                } else {
                    # Show progress
                    if ($waitTime % 5 -eq 0) {
                        Write-Host "     [..] Generating... ($waitTime s)" -ForegroundColor Cyan
                    }
                }
            } catch {
                # Retry on error
            }
        }

        if (-not $completed) {
            Write-Host "     [!] TIMEOUT after ${maxWait}s" -ForegroundColor Red
            $failedCount++
        }

    } catch {
        Write-Host "     [!] ERROR: $($_.Exception.Message)" -ForegroundColor Red
        $failedCount++
    }

    Write-Host ""
}

# Summary
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "TEST GENERATION COMPLETE" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Results:" -ForegroundColor Yellow
Write-Host "  Images generated: $imageCount / $($testPrompts.Count)" -ForegroundColor Cyan
$failColor = if ($failedCount -gt 0) { "Red" } else { "Green" }
Write-Host "  Failed: $failedCount" -ForegroundColor $failColor

if ($imageCount -gt 0) {
    $avgTime = [math]::Round($totalTime / $imageCount, 1)
    Write-Host "  Average generation time: ${avgTime}s per image" -ForegroundColor Cyan
    $speedColor = if ($avgTime -gt 8) { "Yellow" } else { "Green" }
    Write-Host "  Expected range: 5-8s (target for RTX 3090)" -ForegroundColor $speedColor
}

Write-Host ""
Write-Host "Output location: $outputDir" -ForegroundColor Cyan
Write-Host "Prefix: production_photo_" -ForegroundColor Cyan

# List generated images
$generatedImages = @(Get-ChildItem "$outputDir\production_photo_*.png" -ErrorAction SilentlyContinue)
if ($generatedImages.Count -gt 0) {
    Write-Host ""
    Write-Host "Generated images:" -ForegroundColor Yellow
    $generatedImages | ForEach-Object {
        $size = [math]::Round($_.Length / 1MB, 1)
        Write-Host "  [OK] $($_.Name) (${size}MB)" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "No images generated yet. Check ComfyUI logs for errors." -ForegroundColor Yellow
}

Write-Host ""
if ($imageCount -eq $testPrompts.Count) {
    Write-Host "[OK] ALL TESTS PASSED - System is production ready!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "[!] SOME TESTS FAILED - Review errors above" -ForegroundColor Yellow
    exit 1
}
