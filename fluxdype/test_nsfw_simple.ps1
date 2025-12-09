# Clean start: Kill any existing Python processes
Get-Process python -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Write-Host "[1/6] Killed any existing Python processes"
Start-Sleep -Seconds 2

# Start ComfyUI server
Write-Host "[2/6] Starting ComfyUI server..."
cd D:\workspace\fluxdype
Start-Process -FilePath ".\venv\Scripts\python.exe" -ArgumentList "ComfyUI\main.py", "--listen", "0.0.0.0", "--port", "8188", "--disable-auto-launch", "--bf16-unet", "--bf16-vae", "--fast", "fp16_accumulation" -NoNewWindow
Write-Host "[OK] Server process started"

# Wait for server to initialize
Write-Host "[3/6] Waiting 60 seconds for server initialization..."
Start-Sleep -Seconds 60

# Check if server is responding
Write-Host "[4/6] Checking if server is responding..."
$serverReady = $false
for ($i = 1; $i -le 10; $i++) {
    try {
        $resp = Invoke-WebRequest -Uri "http://localhost:8188/system_stats" -TimeoutSec 3 -ErrorAction Stop
        Write-Host "[SUCCESS] Server is responding! Status: $($resp.StatusCode)"
        $serverReady = $true
        break
    } catch {
        if ($i -eq 10) {
            Write-Host "[FAIL] Server not responding after 10 attempts"
            exit 1
        }
        Write-Host "  Attempt $i/10 - waiting..."
        Start-Sleep -Seconds 5
    }
}

if (-not $serverReady) {
    Write-Host "[FAIL] Could not connect to ComfyUI server"
    exit 1
}

# Submit the simple NSFW test workflow
Write-Host "[5/6] Submitting SIMPLE-NSFW-TEST.json workflow..."
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

# Wait for generation to complete
Write-Host "[6/6] Waiting for generation to complete (max 60 seconds)..."
$startTime = Get-Date
$completed = $false
$elapsed = 0

while ($elapsed -lt 60) {
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
    if ($elapsed % 10 -eq 0) {
        Write-Host "  ... Generation in progress ($([math]::Round($elapsed)) seconds elapsed)"
    }
}

if ($completed) {
    Write-Host ""
    Write-Host "========================================="
    Write-Host "[RESULT] Generation SUCCESSFUL!"
    Write-Host "========================================="

    $outputPath = "ComfyUI\output"
    if (Test-Path $outputPath) {
        $files = Get-ChildItem $outputPath -File -Recurse | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 3
        if ($files) {
            Write-Host ""
            Write-Host "Latest Generated Images:"
            Write-Host "-----------------------------------------"
            foreach ($file in $files) {
                $sizeMB = [math]::Round($file.Length / 1MB, 2)
                Write-Host "File: $($file.Name)"
                Write-Host "Size: ${sizeMB}MB"
                Write-Host "Created: $($file.LastWriteTime)"
                Write-Host "Path: $($file.FullName)"
                Write-Host ""
            }
            Write-Host "========================================="
        } else {
            Write-Host "[WARNING] Output folder exists but no files found"
        }
    } else {
        Write-Host "[WARNING] Output folder not found at: $outputPath"
    }
} else {
    Write-Host "[TIMEOUT] Generation did not complete within 60 seconds"
    Write-Host "Job is still processing. Check ComfyUI output folder manually."
}

# Keep server running for future use
Write-Host ""
Write-Host "ComfyUI server is still running on http://localhost:8188"
Write-Host "Press Ctrl+C to stop it."
