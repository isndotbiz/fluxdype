# Test workflow submission script
Write-Host "[1/5] Waiting 60 seconds for ComfyUI server to initialize..."
Start-Sleep -Seconds 60

Write-Host "[2/5] Checking if server is responding..."
$serverReady = $false
for ($i = 1; $i -le 10; $i++) {
    try {
        $resp = Invoke-WebRequest -Uri "http://localhost:8188/system_stats" -TimeoutSec 3 -ErrorAction Stop
        Write-Host "[SUCCESS] Server is responding! Status: 200"
        $serverReady = $true
        break
    } catch {
        if ($i -eq 10) {
            Write-Host "[FAIL] Server not responding after 10 attempts"
            exit 1
        }
        Write-Host "Server check $i/10 - waiting..."
        Start-Sleep -Seconds 5
    }
}

if (-not $serverReady) {
    Write-Host "[FAIL] Could not connect to ComfyUI server"
    exit 1
}

Write-Host "[3/5] Loading and submitting NSFW test workflow..."
$workflow = Get-Content "SIMPLE-NSFW-TEST.json" -Raw | ConvertFrom-Json
$requestBody = @{ prompt = $workflow } | ConvertTo-Json -Depth 100
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $requestBody
    $jobData = $response.Content | ConvertFrom-Json
    $jobId = $jobData.prompt_id
    Write-Host "[OK] Workflow submitted with Job ID: $jobId"
} catch {
    Write-Host "[ERROR] Failed to submit workflow: $_"
    exit 1
}

Write-Host "[4/5] Waiting for generation to complete (max 30 seconds)..."
$startTime = Get-Date
$completed = $false
$elapsed = 0

while ($elapsed -lt 30) {
    try {
        $history = Invoke-WebRequest -Uri "http://localhost:8188/history/$jobId" -Method GET -ErrorAction Stop | ConvertFrom-Json
        if ($history.$jobId) {
            Write-Host "[SUCCESS] Image generation completed!"
            $completed = $true
            break
        }
    } catch {
        # Still processing
    }
    Start-Sleep -Seconds 1
    $elapsed = ((Get-Date) - $startTime).TotalSeconds
    if ($elapsed % 5 -eq 0) {
        Write-Host "  ... Generation in progress ($elapsed seconds elapsed)"
    }
}

if ($completed) {
    Write-Host "[5/5] Checking output folder for generated image..."
    $outputPath = "ComfyUI/output"
    if (Test-Path $outputPath) {
        $files = Get-ChildItem $outputPath -File -Recurse | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
        if ($files) {
            $file = $files
            $sizeMB = [math]::Round($file.Length / 1MB, 2)
            Write-Host ""
            Write-Host "========================================="
            Write-Host "[RESULT] Generation SUCCESSFUL!"
            Write-Host "========================================="
            Write-Host "Generated File: $($file.Name)"
            Write-Host "File Size: ${sizeMB}MB"
            Write-Host "Created: $($file.LastWriteTime)"
            Write-Host "Full Path: $($file.FullName)"
            Write-Host "========================================="
            Write-Host ""
        } else {
            Write-Host "[WARNING] Output folder exists but no files found"
        }
    } else {
        Write-Host "[WARNING] Output folder not found at: $outputPath"
    }
} else {
    Write-Host "[TIMEOUT] Generation did not complete within 30 seconds"
    Write-Host "Job is still processing. Check ComfyUI output folder manually."
}
