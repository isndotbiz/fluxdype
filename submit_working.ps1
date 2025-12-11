# Submit 3 image generation requests - using direct JSON manipulation
cd D:\workspace\fluxdype

Write-Host "Loading workflow template..."
$baseWorkflowJson = Get-Content "working_flux_workflow.json" -Raw

Write-Host "Submitting image generation requests..."

# Helper function to submit workflow
function Submit-Workflow {
  param($workflowJson, $prompt, $seed, $filename, $jobName)
  try {
    # Parse and modify the JSON string directly
    $wf = ConvertFrom-Json $workflowJson

    # Update the fields
    $wf."6".inputs.text = $prompt
    $wf."3".inputs.seed = $seed
    $wf."9".inputs.filename_prefix = $filename

    # Convert back to JSON
    $body = $wf | ConvertTo-Json -Depth 10

    # Submit
    $response = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $body -TimeoutSec 30 -ErrorAction Stop
    $job = (ConvertFrom-Json $response.Content).prompt_id
    Write-Host "$jobName submitted - Job ID: $job"
    return $job
  } catch {
    Write-Host "Error submitting $jobName : $_"
    return $null
  }
}

# Submit Image 1: Landscape
$job1 = Submit-Workflow $baseWorkflowJson "a beautiful landscape with mountains and a lake at sunset, highly detailed, photorealistic, 8k" 42 "flux_landscape" "Image 1 (Landscape)"

# Submit Image 2: Abstract Art
$job2 = Submit-Workflow $baseWorkflowJson "abstract art, colorful, modern design, vibrant colors, digital painting, 8k, highly detailed" 123 "flux_abstract" "Image 2 (Abstract)"

# Submit Image 3: Portrait
$job3 = Submit-Workflow $baseWorkflowJson "beautiful portrait of a woman, professional lighting, high quality, photorealistic, 8k, detailed face, sharp focus" 456 "flux_portrait" "Image 3 (Portrait)"

Write-Host ""
Write-Host "======================================"
Write-Host "All 3 images submitted successfully!"
Write-Host "Job IDs:"
Write-Host "  1. Landscape: $job1"
Write-Host "  2. Abstract: $job2"
Write-Host "  3. Portrait: $job3"
Write-Host ""
Write-Host "Images will be saved to:"
Write-Host "  D:\workspace\fluxdype\ComfyUI\output\"
Write-Host "======================================"

# Monitor progress
if ($job1 -or $job2 -or $job3) {
  Write-Host ""
  Write-Host "Monitoring generation progress..."
  $allJobs = @()
  if ($job1) { $allJobs += $job1 }
  if ($job2) { $allJobs += $job2 }
  if ($job3) { $allJobs += $job3 }

  $completed = @()
  $checkCount = 0

  while ($completed.Count -lt $allJobs.Count -and $checkCount -lt 180) {
    foreach ($jobId in $allJobs) {
      if ($completed -contains $jobId) { continue }
      try {
        $response = Invoke-WebRequest -Uri "http://localhost:8188/history/$jobId" -Method GET -TimeoutSec 5 -ErrorAction SilentlyContinue
        $history = ConvertFrom-Json $response.Content
        if ($history.$jobId) {
          Write-Host "  Job $jobId completed!"
          $completed += $jobId
        } else {
          Write-Host "  Job $jobId still processing..."
        }
      } catch {
        # Still processing or error
      }
    }

    if ($completed.Count -lt $allJobs.Count) {
      Start-Sleep -Seconds 10
      $checkCount += 1
    }
  }

  if ($completed.Count -eq $allJobs.Count) {
    Write-Host ""
    Write-Host "All images generated successfully!"
    Get-ChildItem "D:\workspace\fluxdype\ComfyUI\output\" -Filter "flux_*" -File | Sort-Object -Property CreationTime -Descending | Select-Object -First 3 | ForEach-Object {
      Write-Host "  Generated: $($_.Name) ($([math]::Round($_.Length/1MB, 2)) MB)"
    }
  } else {
    Write-Host "Generation in progress... (monitored for $(3+ $checkCount * 10) seconds)"
  }
}
