# Submit 3 image generation workflows to ComfyUI server
cd D:\workspace\fluxdype

Write-Host "========================================"
Write-Host "ComfyUI Image Generation - 3 Images"
Write-Host "========================================"
Write-Host ""

$jobs = @()
$jobIds = @()

# Function to submit workflow
function Submit-Job {
  param($workflowFile, $description)

  Write-Host "Submitting: $description"
  Write-Host "  Workflow: $workflowFile"

  try {
    $workflowJson = Get-Content $workflowFile -Raw
    $response = Invoke-WebRequest -Uri "http://localhost:8188/prompt" `
      -Method POST `
      -ContentType "application/json" `
      -Body $workflowJson `
      -TimeoutSec 30 `
      -ErrorAction Stop

    $jobData = ConvertFrom-Json $response.Content
    $jobId = $jobData.prompt_id

    Write-Host "  Status: Submitted successfully"
    Write-Host "  Job ID: $jobId"
    Write-Host ""

    return $jobId
  } catch {
    Write-Host "  Status: ERROR - $($_)"
    Write-Host ""
    return $null
  }
}

# Submit all 3 workflows
$job1 = Submit-Job "image_1_landscape.json" "Image 1: Beautiful Landscape"
$job2 = Submit-Job "image_2_abstract.json" "Image 2: Abstract Art"
$job3 = Submit-Job "image_3_portrait.json" "Image 3: Portrait"

# Collect non-null job IDs
if ($job1) { $jobIds += $job1 }
if ($job2) { $jobIds += $job2 }
if ($job3) { $jobIds += $job3 }

Write-Host "========================================"
Write-Host "Summary"
Write-Host "========================================"
Write-Host "Total Jobs Submitted: $($jobIds.Count)"
Write-Host ""

if ($jobIds.Count -gt 0) {
  Write-Host "Job IDs:"
  for ($i = 0; $i -lt $jobIds.Count; $i++) {
    Write-Host "  $($i+1). $($jobIds[$i])"
  }
  Write-Host ""
  Write-Host "Output Location:"
  Write-Host "  D:\workspace\fluxdype\ComfyUI\output\"
  Write-Host ""
  Write-Host "Monitoring generation progress..."
  Write-Host ""

  # Monitor generation
  $completed = @()
  $checkCount = 0
  $maxChecks = 180  # 30 minutes with 10 second intervals

  while ($completed.Count -lt $jobIds.Count -and $checkCount -lt $maxChecks) {
    foreach ($jobId in $jobIds) {
      if ($completed -contains $jobId) { continue }

      try {
        $historyResponse = Invoke-WebRequest -Uri "http://localhost:8188/history/$jobId" `
          -Method GET `
          -TimeoutSec 5 `
          -ErrorAction SilentlyContinue

        $historyData = ConvertFrom-Json $historyResponse.Content

        if ($historyData.$jobId) {
          Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Job $jobId completed!"
          $completed += $jobId
        } else {
          Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Job $jobId still processing... ($($jobIds.Count - $completed.Count) remaining)"
        }
      } catch {
        # Still processing
      }
    }

    if ($completed.Count -lt $jobIds.Count) {
      Start-Sleep -Seconds 10
      $checkCount += 1
    }
  }

  Write-Host ""
  Write-Host "========================================"
  if ($completed.Count -eq $jobIds.Count) {
    Write-Host "SUCCESS - All images generated!"
    Write-Host ""
    Write-Host "Generated images:"
    Get-ChildItem "D:\workspace\fluxdype\ComfyUI\output\" -Filter "*_*.png" -File | `
      Sort-Object -Property CreationTime -Descending | `
      Select-Object -First 3 | `
      ForEach-Object {
        $sizeMB = [math]::Round($_.Length / 1MB, 2)
        Write-Host "  - $($_.Name) ($($sizeMB) MB, created $(Get-Date $_.CreationTime -Format 'yyyy-MM-dd HH:mm:ss'))"
      }
  } else {
    Write-Host "PARTIAL - $($completed.Count)/$($jobIds.Count) images completed"
    Write-Host "Check the UI for ongoing progress at: http://localhost:8188"
  }
  Write-Host "========================================"
} else {
  Write-Host "ERROR: No jobs were successfully submitted"
  Write-Host "Please check the server logs for details"
}
