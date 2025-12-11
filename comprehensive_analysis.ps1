# Comprehensive C: Drive AI Analysis with D: Drive Comparison
$ErrorActionPreference = "SilentlyContinue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMPREHENSIVE C: DRIVE AI ANALYSIS" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Drive statistics
$cDrive = Get-PSDrive C
$cUsedGB = [math]::Round($cDrive.Used / 1GB, 2)
$cFreeGB = [math]::Round($cDrive.Free / 1GB, 2)

Write-Host "C: Drive: $cUsedGB GB used, $cFreeGB GB free`n" -ForegroundColor Yellow

# Main findings
$findings = @{
    "ComfyUI_C" = "C:\Users\Jdmal\ComfyUI"
    "ComfyUI_D" = "D:\workspace\fluxdype\ComfyUI"
    "venv_C" = "C:\Users\Jdmal\ComfyUI\venv"
    "venv_D" = "D:\workspace\fluxdype\venv"
}

$report = @()

# 1. ComfyUI installations
Write-Host "[1] ComfyUI Installations" -ForegroundColor Green
Write-Host "-------------------------" -ForegroundColor Green

$cComfySizeGB = [math]::Round((Get-ChildItem $findings.ComfyUI_C -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1GB, 3)
$dComfySizeGB = [math]::Round((Get-ChildItem $findings.ComfyUI_D -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1GB, 3)

Write-Host "C:\Users\Jdmal\ComfyUI: $cComfySizeGB GB" -ForegroundColor Yellow
Write-Host "D:\workspace\fluxdype\ComfyUI: $dComfySizeGB GB" -ForegroundColor Green
Write-Host "STATUS: C: installation is OBSOLETE/DUPLICATE`n" -ForegroundColor Red

$report += @{
    "category" = "DUPLICATE"
    "type" = "ComfyUI Installation"
    "path" = $findings.ComfyUI_C
    "size_gb" = $cComfySizeGB
    "reason" = "Active installation on D: drive ($dComfySizeGB GB)"
    "recommendation" = "DELETE - Use D: drive installation exclusively"
}

# 2. Python virtual environments
Write-Host "[2] Python Virtual Environments" -ForegroundColor Green
Write-Host "-------------------------------" -ForegroundColor Green

$cVenvSizeGB = [math]::Round((Get-ChildItem $findings.venv_C -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1GB, 3)
$dVenvSizeGB = [math]::Round((Get-ChildItem $findings.venv_D -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1GB, 3)

Write-Host "C:\Users\Jdmal\ComfyUI\venv: $cVenvSizeGB GB" -ForegroundColor Yellow
Write-Host "D:\workspace\fluxdype\venv: $dVenvSizeGB GB" -ForegroundColor Green
Write-Host "STATUS: C: venv is DUPLICATE`n" -ForegroundColor Red

$report += @{
    "category" = "DUPLICATE"
    "type" = "Python venv"
    "path" = $findings.venv_C
    "size_gb" = $cVenvSizeGB
    "reason" = "Active venv on D: drive ($dVenvSizeGB GB)"
    "recommendation" = "DELETE - Use D: drive venv exclusively"
}

# 3. Model files in Downloads
Write-Host "[3] Model Files in Downloads" -ForegroundColor Green
Write-Host "----------------------------" -ForegroundColor Green

$modelFiles = @(
    "C:\Users\Jdmal\Downloads\Facebookq-fotos.safetensors",
    "C:\Users\Jdmal\Downloads\Facebook_Quality_Photos.safetensors",
    "C:\Users\Jdmal\Downloads\ponyChar4ByStableYogi.uIsD.safetensors",
    "C:\Users\Jdmal\Downloads\realism20lora20by.cpW5.safetensors",
    "C:\Users\Jdmal\Downloads\realismLoraByStable.VvFC.safetensors",
    "C:\Users\Jdmal\Downloads\Realism_Lora_By_Stable_yogi_SDXL8.1.safetensors",
    "C:\Users\Jdmal\Downloads\superEyeDetailerBy.4EGS.safetensors",
    "C:\Users\Jdmal\Downloads\4x_NickelbackFS_72000_G.pth"
)

$totalModelSizeGB = 0
foreach ($file in $modelFiles) {
    if (Test-Path $file) {
        $fileObj = Get-Item $file
        $sizeMB = [math]::Round($fileObj.Length / 1MB, 2)
        $sizeGB = [math]::Round($fileObj.Length / 1GB, 3)
        $totalModelSizeGB += $sizeGB

        Write-Host "  $($fileObj.Name): $sizeMB MB" -ForegroundColor Yellow

        $report += @{
            "category" = "ARCHIVE"
            "type" = "Model File"
            "path" = $file
            "size_gb" = $sizeGB
            "reason" = "Downloaded model not yet moved to D: drive"
            "recommendation" = "MOVE to D:\workspace\fluxdype\ComfyUI\models\<appropriate_folder>"
        }
    }
}

Write-Host "Total model files size: $([math]::Round($totalModelSizeGB, 3)) GB" -ForegroundColor Cyan
Write-Host "STATUS: Should be MOVED to D: drive`n" -ForegroundColor Yellow

# 4. Other virtual environments
Write-Host "[4] Other Python Virtual Environments" -ForegroundColor Green
Write-Host "-------------------------------------" -ForegroundColor Green

$otherVenvs = @(
    "C:\Users\Jdmal\.hf-cli\venv",
    "C:\Users\Jdmal\OneDrive\Dev\venv",
    "C:\Users\Jdmal\Workspace\True_Nas\.venv"
)

foreach ($venv in $otherVenvs) {
    if (Test-Path $venv) {
        $size = (Get-ChildItem $venv -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $sizeGB = [math]::Round($size / 1GB, 3)

        if ($sizeGB -gt 0.001) {
            Write-Host "  $venv : $sizeGB GB" -ForegroundColor Yellow

            $report += @{
                "category" = "ARCHIVE"
                "type" = "Python venv"
                "path" = $venv
                "size_gb" = $sizeGB
                "reason" = "Separate project venv"
                "recommendation" = "KEEP if actively used, otherwise DELETE"
            }
        }
    }
}
Write-Host ""

# 5. Claude project caches
Write-Host "[5] Claude Project Caches" -ForegroundColor Green
Write-Host "-------------------------" -ForegroundColor Green

$claudePaths = @(
    "C:\Users\Jdmal\.claude\projects\D--workspace-fluxdype",
    "C:\Users\Jdmal\.claude\projects\D--workspace-fluxdype-ComfyUI"
)

foreach ($path in $claudePaths) {
    if (Test-Path $path) {
        $size = (Get-ChildItem $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $sizeGB = [math]::Round($size / 1GB, 3)

        Write-Host "  $path : $sizeGB GB" -ForegroundColor Yellow

        $report += @{
            "category" = "ACTIVE"
            "type" = "Claude Cache"
            "path" = $path
            "size_gb" = $sizeGB
            "reason" = "Active Claude Code project cache"
            "recommendation" = "KEEP - Required for Claude Code operation"
        }
    }
}
Write-Host ""

# 6. Old Flux test folders
Write-Host "[6] Old Flux Test/Workflow Folders" -ForegroundColor Green
Write-Host "-----------------------------------" -ForegroundColor Green

$oldFlux = @(
    "C:\Users\Jdmal\OneDrive\Dev\flux_kontext_test_20250622_095033",
    "C:\Users\Jdmal\OneDrive\Dev\output\flux_runway_content",
    "C:\Users\Jdmal\OneDrive\Dev\temp\flux_workflow"
)

foreach ($path in $oldFlux) {
    if (Test-Path $path) {
        $size = (Get-ChildItem $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $sizeGB = [math]::Round($size / 1GB, 3)

        if ($sizeGB -gt 0.001) {
            Write-Host "  $path : $sizeGB GB" -ForegroundColor Yellow

            $lastModified = (Get-Item $path).LastWriteTime
            $daysOld = ((Get-Date) - $lastModified).Days

            $report += @{
                "category" = "OBSOLETE"
                "type" = "Old Test Folder"
                "path" = $path
                "size_gb" = $sizeGB
                "reason" = "Last modified $daysOld days ago"
                "recommendation" = "DELETE if no longer needed"
            }
        }
    }
}
Write-Host ""

# 7. WSL_Comfy
Write-Host "[7] WSL ComfyUI Installation" -ForegroundColor Green
Write-Host "-----------------------------" -ForegroundColor Green

$wslComfy = "C:\Users\Jdmal\Workspace\WSL_Comfy"
if (Test-Path $wslComfy) {
    $size = (Get-ChildItem $wslComfy -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $sizeGB = [math]::Round($size / 1GB, 3)

    Write-Host "  $wslComfy : $sizeGB GB" -ForegroundColor Yellow
    Write-Host "  STATUS: Old WSL experiment`n" -ForegroundColor Red

    $report += @{
        "category" = "OBSOLETE"
        "type" = "Old ComfyUI Test"
        "path" = $wslComfy
        "size_gb" = $sizeGB
        "reason" = "Old WSL experiment, superseded by D: drive installation"
        "recommendation" = "DELETE"
    }
}

# Calculate totals by category
$totalDuplicate = ($report | Where-Object { $_.category -eq "DUPLICATE" } | Measure-Object -Property size_gb -Sum).Sum
$totalObsolete = ($report | Where-Object { $_.category -eq "OBSOLETE" } | Measure-Object -Property size_gb -Sum).Sum
$totalArchive = ($report | Where-Object { $_.category -eq "ARCHIVE" } | Measure-Object -Property size_gb -Sum).Sum
$totalActive = ($report | Where-Object { $_.category -eq "ACTIVE" } | Measure-Object -Property size_gb -Sum).Sum

$totalSavings = $totalDuplicate + $totalObsolete

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "DUPLICATE items: $([math]::Round($totalDuplicate, 2)) GB" -ForegroundColor Red
Write-Host "OBSOLETE items: $([math]::Round($totalObsolete, 2)) GB" -ForegroundColor Red
Write-Host "ARCHIVE items (move/review): $([math]::Round($totalArchive, 2)) GB" -ForegroundColor Yellow
Write-Host "ACTIVE items (keep): $([math]::Round($totalActive, 2)) GB" -ForegroundColor Green

Write-Host "`nPotential space savings from deletion: $([math]::Round($totalSavings, 2)) GB" -ForegroundColor Cyan
Write-Host "Additional space if models moved to D: $([math]::Round($totalArchive, 2)) GB" -ForegroundColor Yellow

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RECOMMENDED ACTIONS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n1. IMMEDIATE DELETION (Safe - Duplicates on D: drive)" -ForegroundColor Red
Write-Host "   - C:\Users\Jdmal\ComfyUI ($cComfySizeGB GB)" -ForegroundColor Yellow
Write-Host "   - C:\Users\Jdmal\ComfyUI\venv ($cVenvSizeGB GB)" -ForegroundColor Yellow

Write-Host "`n2. MOVE TO D: DRIVE (Model Files)" -ForegroundColor Yellow
Write-Host "   - Move all .safetensors and .pth files from Downloads to:" -ForegroundColor Gray
Write-Host "     D:\workspace\fluxdype\ComfyUI\models\loras\" -ForegroundColor Gray
Write-Host "   - Total: $([math]::Round($totalArchive, 2)) GB" -ForegroundColor Yellow

Write-Host "`n3. CLEANUP OLD TEST FOLDERS (Obsolete)" -ForegroundColor Red
Write-Host "   - C:\Users\Jdmal\Workspace\WSL_Comfy" -ForegroundColor Gray
Write-Host "   - C:\Users\Jdmal\OneDrive\Dev\flux_* folders" -ForegroundColor Gray

Write-Host "`n4. KEEP (Active Use)" -ForegroundColor Green
Write-Host "   - C:\Users\Jdmal\.claude\projects\* (Claude Code caches)" -ForegroundColor Gray
Write-Host "   - C:\Users\Jdmal\.hf-cli\venv (HuggingFace CLI)" -ForegroundColor Gray
Write-Host "   - C:\Users\Jdmal\Workspace\True_Nas\.venv (if actively used)" -ForegroundColor Gray

# Save detailed report
$outputPath = "D:\workspace\fluxdype\detailed_c_drive_analysis.json"
$report | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "`nDetailed report saved to: $outputPath" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "NEXT STEPS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host @"

To execute cleanup safely:

1. Backup important files first (if any custom workflows exist in C:\Users\Jdmal\ComfyUI)

2. Delete duplicate ComfyUI installation:
   Remove-Item -Path "C:\Users\Jdmal\ComfyUI" -Recurse -Force

3. Move model files to D: drive:
   Move-Item -Path "C:\Users\Jdmal\Downloads\*.safetensors" -Destination "D:\workspace\fluxdype\ComfyUI\models\loras\"
   Move-Item -Path "C:\Users\Jdmal\Downloads\*.pth" -Destination "D:\workspace\fluxdype\ComfyUI\models\upscale_models\"

4. Delete obsolete test folders:
   Remove-Item -Path "C:\Users\Jdmal\Workspace\WSL_Comfy" -Recurse -Force
   Remove-Item -Path "C:\Users\Jdmal\OneDrive\Dev\flux_*" -Recurse -Force

Total space recovered: ~$([math]::Round($totalSavings + $totalArchive, 2)) GB

"@ -ForegroundColor Gray
