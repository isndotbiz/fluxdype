# Start ComfyUI and generate 3 images
cd D:\workspace\fluxdype

Write-Host "========================================"
Write-Host "ComfyUI Image Generation - FluxDype"
Write-Host "========================================"
Write-Host ""

# Start ComfyUI server in background
Write-Host "Step 1: Starting ComfyUI server..."
Start-Process -NoNewWindow -FilePath ".\venv\Scripts\python.exe" -ArgumentList "ComfyUI\main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --normalvram"
Write-Host "Waiting for server to initialize..."
Start-Sleep -Seconds 20

# Test server connection
Write-Host ""
Write-Host "Step 2: Testing server connection..."
$retries = 0
$connected = $false
while ($retries -lt 5 -and -not $connected) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8188/system_stats" -Method GET -TimeoutSec 5 -ErrorAction Stop
        Write-Host "✓ Server is responding"
        $connected = $true
    } catch {
        $retries++
        Write-Host "  Attempt $retries/5 - Waiting..."
        Start-Sleep -Seconds 5
    }
}

if (-not $connected) {
    Write-Host "✗ Server failed to start. Check ComfyUI logs."
    exit 1
}

Write-Host ""
Write-Host "Step 3: Submitting 3 image generation workflows..."
Write-Host ""

$jobs = @()

# Submit workflow 1: Landscape
$wf1 = Get-Content "image_1_landscape.json" -Raw
try {
    $resp1 = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $wf1 -TimeoutSec 30
    $data1 = ConvertFrom-Json $resp1.Content
    $job1 = $data1.prompt_id
    $jobs += $job1
    Write-Host "✓ Image 1 (Landscape): $job1"
} catch {
    Write-Host "✗ Image 1 failed: $($_.Exception.Message)"
}

# Submit workflow 2: Abstract
$wf2 = Get-Content "image_2_abstract.json" -Raw
try {
    $resp2 = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $wf2 -TimeoutSec 30
    $data2 = ConvertFrom-Json $resp2.Content
    $job2 = $data2.prompt_id
    $jobs += $job2
    Write-Host "✓ Image 2 (Abstract): $job2"
} catch {
    Write-Host "✗ Image 2 failed: $($_.Exception.Message)"
}

# Submit workflow 3: Portrait
$wf3 = Get-Content "image_3_portrait.json" -Raw
try {
    $resp3 = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $wf3 -TimeoutSec 30
    $data3 = ConvertFrom-Json $resp3.Content
    $job3 = $data3.prompt_id
    $jobs += $job3
    Write-Host "✓ Image 3 (Portrait): $job3"
} catch {
    Write-Host "✗ Image 3 failed: $($_.Exception.Message)"
}

Write-Host ""
Write-Host "========================================"
Write-Host "Generation Status"
Write-Host "========================================"

if ($jobs.Count -eq 0) {
    Write-Host "ERROR: No jobs were successfully submitted"
    exit 1
}

Write-Host "SUCCESS: Submitted $($jobs.Count) images"
Write-Host ""
Write-Host "Monitoring generation progress..."
Write-Host "(This may take 5-10 minutes per image on RTX 3090)"
Write-Host ""

$completed = @()
$checkCount = 0

while ($completed.Count -lt $jobs.Count) {
    foreach ($jobId in $jobs) {
        if ($completed -contains $jobId) {
            continue
        }

        $histResp = Invoke-WebRequest -Uri "http://localhost:8188/history/$jobId" -Method GET -TimeoutSec 5 -ErrorAction SilentlyContinue
        if ($histResp) {
            $hist = ConvertFrom-Json $histResp.Content
            if ($hist.$jobId) {
                Write-Host "Job $jobId completed!"
                $completed += $jobId
            }
        }
    }

    if ($completed.Count -lt $jobs.Count) {
        $remaining = $jobs.Count - $completed.Count
        Write-Host "Processing... ($remaining images remaining)"
        Start-Sleep -Seconds 10
        $checkCount++
        if ($checkCount -gt 360) { break }
    }
}

Write-Host ""
Write-Host "========================================"
if ($completed.Count -eq $jobs.Count) {
    Write-Host "✓✓✓ All images generated successfully! ✓✓✓"
    Write-Host ""
    Write-Host "Generated images:"
    Get-ChildItem "ComfyUI\output\" -Filter "*.png" -File | Sort-Object -Property CreationTime -Descending | Select-Object -First 3 | ForEach-Object {
        $sizeMB = [math]::Round($_.Length / 1MB, 2)
        $time = Get-Date $_.CreationTime -Format "HH:mm:ss"
        Write-Host "  • $($_.Name) ($sizeMB MB) - $time"
    }
} else {
    Write-Host "⚠ Generation in progress: $($completed.Count)/$($jobs.Count) completed"
}
Write-Host "========================================"
