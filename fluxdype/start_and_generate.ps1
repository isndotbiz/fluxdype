# Start ComfyUI and generate 3 images
cd D:\workspace\fluxdype

# Check if server is running
$serverRunning = $false
try {
  $response = Invoke-WebRequest -Uri "http://localhost:8188/system_stats" -Method GET -ErrorAction Stop -TimeoutSec 2
  $serverRunning = $true
  Write-Host "Server already running"
} catch {
  Write-Host "Starting ComfyUI server..."
  # Activate venv and start server
  & ".\venv\Scripts\Activate.ps1"
  Push-Location ComfyUI
  Start-Process -NoNewWindow -FilePath "python" -ArgumentList "main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --normalvram"
  Pop-Location
  Start-Sleep -Seconds 20
}

# Load workflow
$baseWorkflow = Get-Content "flux_basic.json" -Raw | ConvertFrom-Json

# Helper function to submit workflow
function Submit-Workflow {
  param($workflow, $jobName)
  try {
    $body = $workflow | ConvertTo-Json -Depth 10
    $response = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $body -TimeoutSec 30 -ErrorAction Stop
    $job = (ConvertFrom-Json $response.Content).prompt_id
    Write-Host "$jobName submitted - Job ID: $job"
    return $job
  } catch {
    Write-Host "Error submitting $jobName : $_"
    return $null
  }
}

# Submit Image 1
$wf1 = $baseWorkflow | ConvertTo-Json | ConvertFrom-Json
$job1 = Submit-Workflow $wf1 "Image 1 (Landscape)"

# Submit Image 2
$wf2 = $baseWorkflow | ConvertTo-Json | ConvertFrom-Json
$wf2."2".inputs.text = "abstract art, colorful, modern design, vibrant colors, digital painting, 8k"
$wf2."5".inputs.seed = 123
$wf2."7".inputs.filename_prefix = "flux_abstract"
$job2 = Submit-Workflow $wf2 "Image 2 (Abstract)"

# Submit Image 3
$wf3 = $baseWorkflow | ConvertTo-Json | ConvertFrom-Json
$wf3."2".inputs.text = "beautiful portrait of a woman, professional lighting, high quality, photorealistic, 8k"
$wf3."5".inputs.seed = 456
$wf3."7".inputs.filename_prefix = "flux_portrait"
$job3 = Submit-Workflow $wf3 "Image 3 (Portrait)"

Write-Host ""
Write-Host "======================================"
Write-Host "All 3 images submitted successfully!"
Write-Host "Job IDs:"
Write-Host "  1. $job1"
Write-Host "  2. $job2"
Write-Host "  3. $job3"
Write-Host ""
Write-Host "Images will be saved to:"
Write-Host "  D:\workspace\fluxdype\ComfyUI\output\"
Write-Host "======================================"

# Optional: Monitor progress
if ($job1 -or $job2 -or $job3) {
  Write-Host ""
  Write-Host "Monitoring generation progress..."
  $allJobs = @($job1, $job2, $job3) | Where-Object { $_ }
  $completed = @()

  while ($completed.Count -lt $allJobs.Count) {
    foreach ($jobId in $allJobs) {
      if ($completed -contains $jobId) { continue }
      try {
        $history = Invoke-WebRequest -Uri "http://localhost:8188/history/$jobId" -Method GET -TimeoutSec 5 | ConvertFrom-Json
        if ($history.$jobId) {
          Write-Host "  Job $jobId completed!"
          $completed += $jobId
        }
      } catch {
        # Still processing
      }
    }
    if ($completed.Count -lt $allJobs.Count) {
      Start-Sleep -Seconds 5
    }
  }
  Write-Host "All images generated!"
}
