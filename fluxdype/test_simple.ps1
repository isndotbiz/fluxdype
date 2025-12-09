# Test simple workflow
$workflow = Get-Content 'D:\workspace\fluxdype\simple_gen.json' -Raw
Write-Host "Submitting workflow..."

try {
  $response = Invoke-WebRequest -Uri 'http://localhost:8188/prompt' -Method POST -ContentType 'application/json' -Body $workflow -TimeoutSec 30
  Write-Host "Status: $($response.StatusCode)"
  $data = ConvertFrom-Json $response.Content
  Write-Host "Job ID: $($data.prompt_id)"
  Write-Host "Success!"
} catch {
  Write-Host "Error: $($_.Exception.Message)"
  Write-Host "Status Code: $($_.Exception.Response.StatusCode)"
}
