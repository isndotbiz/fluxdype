# Submit 3 image generation requests using proper workflow structure
cd D:\workspace\fluxdype

Write-Host "Loading workflow template..."
$baseWorkflow = Get-Content "working_flux_workflow.json" -Raw | ConvertFrom-Json

Write-Host "Submitting image generation requests..."

# Helper function to submit workflow
function Submit-Workflow {
  param($workflow, $prompt, $seed, $filename, $jobName)
  try {
    $workflow."6".inputs.text = $prompt
    $workflow."5".inputs.seed = $seed
    $workflow."9".inputs.filename_prefix = $filename

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

# Submit Image 1: Landscape
$wf1 = $baseWorkflow | ConvertTo-Json | ConvertFrom-Json
$job1 = Submit-Workflow $wf1 "a beautiful landscape with mountains and a lake at sunset, highly detailed, photorealistic, 8k" 42 "flux_landscape" "Image 1 (Landscape)"

# Submit Image 2: Abstract Art
$wf2 = $baseWorkflow | ConvertTo-Json | ConvertFrom-Json
$job2 = Submit-Workflow $wf2 "abstract art, colorful, modern design, vibrant colors, digital painting, 8k, highly detailed" 123 "flux_abstract" "Image 2 (Abstract)"

# Submit Image 3: Portrait
$wf3 = $baseWorkflow | ConvertTo-Json | ConvertFrom-Json
$job3 = Submit-Workflow $wf3 "beautiful portrait of a woman, professional lighting, high quality, photorealistic, 8k, detailed face, sharp focus" 456 "flux_portrait" "Image 3 (Portrait)"

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
