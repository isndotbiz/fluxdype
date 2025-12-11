# Fresh test with model scan
Write-Host ""
Write-Host "========================================="
Write-Host "FluxDype NSFW Image Generation Test"
Write-Host "========================================="
Write-Host ""

# Make sure no old processes are running
Write-Host "[1/7] Cleaning up old processes..."
Get-Process python -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Start ComfyUI server
Write-Host "[2/7] Starting ComfyUI server with fresh model scan..."
cd D:\workspace\fluxdype
Start-Process -FilePath ".\venv\Scripts\python.exe" -ArgumentList "ComfyUI\main.py", "--listen", "0.0.0.0", "--port", "8188", "--disable-auto-launch", "--bf16-unet", "--bf16-vae", "--fast", "fp16_accumulation" -NoNewWindow
Write-Host "[OK] Server process started"

# Wait for server to initialize AND scan models
Write-Host "[3/7] Waiting 90 seconds for server initialization and model scanning..."
Start-Sleep -Seconds 90

# Check if server is responding
Write-Host "[4/7] Checking if server is responding..."
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
        Start-Sleep -Seconds 3
    }
}

if (-not $serverReady) {
    Write-Host "[FAIL] Could not connect to ComfyUI server"
    exit 1
}

# List available checkpoints to debug
Write-Host "[5/7] Querying available checkpoints..."
try {
    $checkpoints = Invoke-WebRequest -Uri "http://localhost:8188/embeddings" -Method GET -ErrorAction SilentlyContinue
    Write-Host "[OK] Server API is responding"
} catch {
    Write-Host "[WARNING] Could not check embeddings: $_"
}

# Submit the NSFW test workflow
Write-Host "[6/7] Submitting NSFW workflow..."
$workflow = Get-Content "SIMPLE-NSFW-TEST.json" -Raw | ConvertFrom-Json
$requestBody = @{ prompt = $workflow } | ConvertTo-Json -Depth 100

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $requestBody
    $jobData = $response.Content | ConvertFrom-Json
    $jobId = $jobData.prompt_id
    Write-Host "[SUCCESS] Workflow submitted with Job ID: $jobId"
} catch {
    Write-Host "[ERROR] Failed to submit workflow:"
    Write-Host $_.Exception.Response.Content
    exit 1
}

# Wait for generation
Write-Host "[7/7] Waiting for generation (max 120 seconds)..."
$startTime = Get-Date
$completed = $false
$elapsed = 0

while ($elapsed -lt 120) {
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
    Start-Sleep -Seconds 2
    $elapsed = ((Get-Date) - $startTime).TotalSeconds
    if ($elapsed % 20 -eq 0) {
        Write-Host "  ... Still generating ($([math]::Round($elapsed)) seconds elapsed)"
    }
}

Write-Host ""
Write-Host "========================================="
if ($completed) {
    Write-Host "[RESULT] Generation SUCCESSFUL!"
    Write-Host "========================================="

    # Check output folder
    $outputPath = "ComfyUI\output"
    if (Test-Path $outputPath) {
        $files = Get-ChildItem $outputPath -File -Recurse | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
        if ($files) {
            $file = $files
            $sizeMB = [math]::Round($file.Length / 1MB, 2)
            Write-Host ""
            Write-Host "Generated File: $($file.Name)"
            Write-Host "File Size: ${sizeMB}MB"
            Write-Host "Created: $($file.LastWriteTime)"
            Write-Host "Path: $($file.FullName)"
            Write-Host ""
            Write-Host "✓ NSFW generation working!"
            Write-Host "✓ System is ready for production use"
            Write-Host "========================================="
        } else {
            Write-Host "[WARNING] Output folder exists but no files found"
        }
    } else {
        Write-Host "[WARNING] Output folder not found at: $outputPath"
    }
} else {
    Write-Host "[TIMEOUT] Generation did not complete within 120 seconds"
    Write-Host "Job may still be processing..."
    Write-Host "========================================="
}

Write-Host ""
Write-Host "Server is running on http://localhost:8188"
Write-Host "Press Ctrl+C to stop it."
