$modelsSize = (Get-ChildItem -Path 'D:\workspace\fluxdype\ComfyUI\models' -Recurse -File | Measure-Object -Property Length -Sum).Sum
$backupSize = (Get-ChildItem -Path 'D:\workspace\fluxdype\models_removed_backup' -Recurse -File | Measure-Object -Property Length -Sum).Sum

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Cleanup Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "ComfyUI Models Directory Size: $('{0:N2} GB' -f ($modelsSize/1GB))" -ForegroundColor Green
Write-Host "Backup Directory Size:         $('{0:N2} GB' -f ($backupSize/1GB))" -ForegroundColor Yellow
Write-Host ""

$modelsCount = (Get-ChildItem -Path 'D:\workspace\fluxdype\ComfyUI\models' -Recurse -File | Measure-Object).Count
$backupCount = (Get-ChildItem -Path 'D:\workspace\fluxdype\models_removed_backup' -Recurse -File | Measure-Object).Count

Write-Host "ComfyUI Models File Count: $modelsCount files" -ForegroundColor Green
Write-Host "Backup File Count:         $backupCount files" -ForegroundColor Yellow
Write-Host ""
