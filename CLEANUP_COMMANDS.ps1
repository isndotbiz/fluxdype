# C: Drive AI Files Cleanup Script
# Generated: 2025-12-10
# Total Recovery: 11.36 GB

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "C: DRIVE AI FILES CLEANUP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total recovery potential: 11.36 GB" -ForegroundColor Yellow
Write-Host ""

# Confirm before proceeding
$confirm = Read-Host "Do you want to proceed with cleanup? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "Cleanup cancelled." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "[Step 1/4] Deleting duplicate ComfyUI installation..." -ForegroundColor Yellow
Write-Host "  Path: C:\Users\Jdmal\ComfyUI" -ForegroundColor Gray
Write-Host "  Size: 4.975 GB" -ForegroundColor Gray

if (Test-Path "C:\Users\Jdmal\ComfyUI") {
    try {
        Remove-Item -Path "C:\Users\Jdmal\ComfyUI" -Recurse -Force
        Write-Host "  SUCCESS: Deleted C:\Users\Jdmal\ComfyUI" -ForegroundColor Green
        $step1 = $true
    } catch {
        Write-Host "  ERROR: Failed to delete - $($_.Exception.Message)" -ForegroundColor Red
        $step1 = $false
    }
} else {
    Write-Host "  SKIPPED: Path does not exist" -ForegroundColor Yellow
    $step1 = $true
}

Write-Host ""
Write-Host "[Step 2/4] Moving LoRA models to D: drive..." -ForegroundColor Yellow
Write-Host "  Source: C:\Users\Jdmal\Downloads\*.safetensors" -ForegroundColor Gray
Write-Host "  Destination: D:\workspace\fluxdype\ComfyUI\models\loras\" -ForegroundColor Gray
Write-Host "  Size: 1.321 GB (7 files)" -ForegroundColor Gray

$safetensorsFiles = Get-ChildItem "C:\Users\Jdmal\Downloads\*.safetensors" -ErrorAction SilentlyContinue

if ($safetensorsFiles.Count -gt 0) {
    try {
        # Ensure destination exists
        $destLoras = "D:\workspace\fluxdype\ComfyUI\models\loras"
        if (-not (Test-Path $destLoras)) {
            New-Item -Path $destLoras -ItemType Directory -Force | Out-Null
        }

        foreach ($file in $safetensorsFiles) {
            Move-Item -Path $file.FullName -Destination $destLoras -Force
            Write-Host "    Moved: $($file.Name)" -ForegroundColor Green
        }
        Write-Host "  SUCCESS: Moved $($safetensorsFiles.Count) LoRA models" -ForegroundColor Green
        $step2 = $true
    } catch {
        Write-Host "  ERROR: Failed to move - $($_.Exception.Message)" -ForegroundColor Red
        $step2 = $false
    }
} else {
    Write-Host "  SKIPPED: No .safetensors files found" -ForegroundColor Yellow
    $step2 = $true
}

Write-Host ""
Write-Host "[Step 3/4] Moving upscaler model to D: drive..." -ForegroundColor Yellow
Write-Host "  Source: C:\Users\Jdmal\Downloads\*.pth" -ForegroundColor Gray
Write-Host "  Destination: D:\workspace\fluxdype\ComfyUI\models\upscale_models\" -ForegroundColor Gray
Write-Host "  Size: 0.062 GB (1 file)" -ForegroundColor Gray

$pthFiles = Get-ChildItem "C:\Users\Jdmal\Downloads\*.pth" -ErrorAction SilentlyContinue

if ($pthFiles.Count -gt 0) {
    try {
        # Ensure destination exists
        $destUpscale = "D:\workspace\fluxdype\ComfyUI\models\upscale_models"
        if (-not (Test-Path $destUpscale)) {
            New-Item -Path $destUpscale -ItemType Directory -Force | Out-Null
        }

        foreach ($file in $pthFiles) {
            Move-Item -Path $file.FullName -Destination $destUpscale -Force
            Write-Host "    Moved: $($file.Name)" -ForegroundColor Green
        }
        Write-Host "  SUCCESS: Moved $($pthFiles.Count) upscaler model(s)" -ForegroundColor Green
        $step3 = $true
    } catch {
        Write-Host "  ERROR: Failed to move - $($_.Exception.Message)" -ForegroundColor Red
        $step3 = $false
    }
} else {
    Write-Host "  SKIPPED: No .pth files found" -ForegroundColor Yellow
    $step3 = $true
}

Write-Host ""
Write-Host "[Step 4/4] Deleting obsolete WSL ComfyUI installation..." -ForegroundColor Yellow
Write-Host "  Path: C:\Users\Jdmal\Workspace\WSL_Comfy" -ForegroundColor Gray
Write-Host "  Size: 0.057 GB" -ForegroundColor Gray

if (Test-Path "C:\Users\Jdmal\Workspace\WSL_Comfy") {
    try {
        Remove-Item -Path "C:\Users\Jdmal\Workspace\WSL_Comfy" -Recurse -Force
        Write-Host "  SUCCESS: Deleted WSL_Comfy" -ForegroundColor Green
        $step4 = $true
    } catch {
        Write-Host "  ERROR: Failed to delete - $($_.Exception.Message)" -ForegroundColor Red
        $step4 = $false
    }
} else {
    Write-Host "  SKIPPED: Path does not exist" -ForegroundColor Yellow
    $step4 = $true
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CLEANUP SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$successCount = 0
if ($step1) { $successCount++ }
if ($step2) { $successCount++ }
if ($step3) { $successCount++ }
if ($step4) { $successCount++ }

Write-Host "Steps completed: $successCount/4" -ForegroundColor $(if ($successCount -eq 4) { "Green" } else { "Yellow" })
Write-Host ""

if ($step1) { Write-Host "  [OK] ComfyUI installation deleted" -ForegroundColor Green } else { Write-Host "  [FAIL] ComfyUI installation NOT deleted" -ForegroundColor Red }
if ($step2) { Write-Host "  [OK] LoRA models moved" -ForegroundColor Green } else { Write-Host "  [FAIL] LoRA models NOT moved" -ForegroundColor Red }
if ($step3) { Write-Host "  [OK] Upscaler model moved" -ForegroundColor Green } else { Write-Host "  [FAIL] Upscaler model NOT moved" -ForegroundColor Red }
if ($step4) { Write-Host "  [OK] WSL_Comfy deleted" -ForegroundColor Green } else { Write-Host "  [FAIL] WSL_Comfy NOT deleted" -ForegroundColor Red }

Write-Host ""

if ($successCount -eq 4) {
    Write-Host "CLEANUP COMPLETE!" -ForegroundColor Green
    Write-Host "Space recovered: ~11.36 GB" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Active installation remains on D: drive:" -ForegroundColor Yellow
    Write-Host "  D:\workspace\fluxdype\ComfyUI (201+ GB)" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "CLEANUP INCOMPLETE" -ForegroundColor Yellow
    Write-Host "Some steps failed. Review errors above." -ForegroundColor Red
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
