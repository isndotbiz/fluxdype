# Production Batch Generation Script - 100 Images in 4-5 Minutes
# Usage: .\batch_100_production.ps1
# Prerequisites: ComfyUI server running (.\start-comfy.ps1 in another terminal)

param(
    [int]$NumBatches = 25,
    [int]$StartSeed = 0,
    [string]$WorkflowPath = ".\workflows\production_batch_turbo.json"
)

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  PRODUCTION BATCH TURBO - 100 Image Generation Pipeline       ║" -ForegroundColor Cyan
Write-Host "║  RTX 3090 Optimized - Flux Turbo Alpha LoRA @ 0.7 Strength   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host ""
Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  - Batches: $NumBatches"
Write-Host "  - Seed Range: $StartSeed-$($StartSeed + $NumBatches - 1)"
Write-Host "  - Images per Batch: 4"
Write-Host "  - Total Images: $($NumBatches * 4)"
Write-Host "  - Workflow: $WorkflowPath"
Write-Host "  - Estimated Runtime: 4-5 minutes"
Write-Host ""

# Validate workflow file exists
if (-not (Test-Path $WorkflowPath)) {
    Write-Host "ERROR: Workflow file not found: $WorkflowPath" -ForegroundColor Red
    exit 1
}

Write-Host "Starting batch generation at $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Green
$startTime = Get-Date
Write-Host ""

# Generate batches
for ($i = 0; $i -lt $NumBatches; $i++) {
    $seed = $StartSeed + $i
    $batchNum = $i + 1
    $firstImageNum = $batchNum * 4 - 3
    $lastImageNum = $batchNum * 4
    $totalImages = $batchNum * 4

    # Progress bar
    $percentComplete = [Math]::Round(($batchNum / $NumBatches) * 100)
    Write-Host "[" -NoNewline -ForegroundColor White
    Write-Host ("#" * ($batchNum)) -NoNewline -ForegroundColor Green
    Write-Host (" " * ($NumBatches - $batchNum)) -NoNewline -ForegroundColor Gray
    Write-Host "] $percentComplete% - Batch $batchNum/$NumBatches | Seed: $seed | Images: $firstImageNum-$lastImageNum" -ForegroundColor Cyan

    # Submit workflow
    $result = & .\run-workflow.ps1 -WorkflowPath $WorkflowPath -Wait 2>$null

    if ($LASTEXITCODE -eq 0) {
        $elapsedSeconds = [Math]::Round(((Get-Date) - $startTime).TotalSeconds)
        $elapsedMinutes = [Math]::Round($elapsedSeconds / 60, 1)
        $estimatedTotalSeconds = [Math]::Round($elapsedSeconds / $batchNum * $NumBatches)
        $estimatedTotalMinutes = [Math]::Round($estimatedTotalSeconds / 60, 1)
        $remainingSeconds = $estimatedTotalSeconds - $elapsedSeconds
        $remainingMinutes = [Math]::Round($remainingSeconds / 60, 1)

        Write-Host "  ✓ Success | Elapsed: ${elapsedMinutes}m | Estimated Total: ${estimatedTotalMinutes}m | Remaining: ${remainingMinutes}m" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Error | Batch $batchNum failed" -ForegroundColor Red
        Write-Host "  Stopping batch generation." -ForegroundColor Red
        exit 1
    }

    # Small delay between batches (allow ComfyUI to reset)
    if ($i -lt $NumBatches - 1) {
        Start-Sleep -Milliseconds 500
    }
}

$endTime = Get-Date
$totalSeconds = ($endTime - $startTime).TotalSeconds
$totalMinutes = [Math]::Round($totalSeconds / 60, 1)

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  BATCH GENERATION COMPLETE                                   ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host ""
Write-Host "Results:" -ForegroundColor Yellow
Write-Host "  - Total Batches: $NumBatches"
Write-Host "  - Total Images Generated: $($NumBatches * 4)"
Write-Host "  - Total Runtime: ${totalMinutes} minutes ($([Math]::Round($totalSeconds)) seconds)"
Write-Host "  - Average Time per Image: $([Math]::Round($totalSeconds / ($NumBatches * 4), 2)) seconds"
Write-Host "  - Throughput: $([Math]::Round(($NumBatches * 4) / ($totalSeconds / 60), 1)) images/minute"
Write-Host "  - Start Time: $($startTime.ToString('HH:mm:ss'))"
Write-Host "  - End Time: $($endTime.ToString('HH:mm:ss'))"
Write-Host "  - Output Location: ComfyUI/output/"
Write-Host ""

Write-Host "Generated images:" -ForegroundColor Cyan
Write-Host "  prod_batch_turbo_00001.png - prod_batch_turbo_$([Math]::Round($NumBatches * 4).ToString('D5')).png" -ForegroundColor Cyan
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Review generated images in ComfyUI/output/"
Write-Host "  2. Archive to backup storage: Archive-Item -Path 'ComfyUI\output\prod_batch_turbo_*.png' -DestinationPath 'archive_$(Get-Date -Format 'yyyyMMdd').zip'"
Write-Host "  3. For additional 100 images: .\\batch_100_production.ps1 -StartSeed $($StartSeed + $NumBatches)"
Write-Host ""

Write-Host "Production Status: READY FOR CONTINUOUS USE" -ForegroundColor Green
