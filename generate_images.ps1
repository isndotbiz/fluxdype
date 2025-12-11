# Submit 3 image generation requests to ComfyUI

# Test if server is running
try {
  $response = Invoke-WebRequest -Uri "http://localhost:8188/system_stats" -Method GET -ErrorAction Stop -TimeoutSec 5
  Write-Host "ComfyUI server is running!"
} catch {
  Write-Host "Server not responding yet, but continuing with requests..."
}

# Load base workflow
$baseWorkflow = Get-Content "D:\workspace\fluxdype\flux_basic.json" -Raw | ConvertFrom-Json

# Image 1: Landscape with sunset (seed 42)
$workflow1 = $baseWorkflow | ConvertTo-Json -Depth 10
$response1 = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $workflow1
$job1 = (ConvertFrom-Json $response1.Content).prompt_id
Write-Host "Image 1 submitted - Job ID: $job1"
Write-Host "  Prompt: a beautiful landscape with mountains and a lake at sunset"

# Image 2: Abstract art (seed 123)
$workflow2 = $baseWorkflow | ConvertTo-Json -Depth 10 | ConvertFrom-Json
$workflow2."2".inputs.text = "abstract art, colorful, modern design, vibrant colors, digital painting"
$workflow2."5".inputs.seed = 123
$workflow2."7".inputs.filename_prefix = "flux_abstract"
$body2 = $workflow2 | ConvertTo-Json -Depth 10
$response2 = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $body2
$job2 = (ConvertFrom-Json $response2.Content).prompt_id
Write-Host "Image 2 submitted - Job ID: $job2"
Write-Host "  Prompt: abstract art, colorful, modern design"

# Image 3: Portrait (seed 456)
$workflow3 = $baseWorkflow | ConvertTo-Json -Depth 10 | ConvertFrom-Json
$workflow3."2".inputs.text = "beautiful portrait of a woman, professional lighting, high quality, photorealistic, 8k"
$workflow3."5".inputs.seed = 456
$workflow3."7".inputs.filename_prefix = "flux_portrait"
$body3 = $workflow3 | ConvertTo-Json -Depth 10
$response3 = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $body3
$job3 = (ConvertFrom-Json $response3.Content).prompt_id
Write-Host "Image 3 submitted - Job ID: $job3"
Write-Host "  Prompt: beautiful portrait of a woman, photorealistic"

Write-Host ""
Write-Host "======================================"
Write-Host "All 3 images have been submitted!"
Write-Host "Job IDs: $job1, $job2, $job3"
Write-Host "Images will be saved to: D:\workspace\fluxdype\ComfyUI\output\"
Write-Host "======================================"
