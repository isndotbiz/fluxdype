# Check if server is responsive
Write-Host "Checking server status..."

try {
  $response = Invoke-WebRequest -Uri 'http://localhost:8188/system_stats' -Method GET -TimeoutSec 5
  Write-Host "Server Status: OK ($($response.StatusCode))"
  $data = ConvertFrom-Json $response.Content
  Write-Host "System Stats:"
  Write-Host "  Timestamp: $($data.timestamp)"
  Write-Host ""

  # Try to get available models
  Write-Host "Checking system information..."
  $infoResponse = Invoke-WebRequest -Uri 'http://localhost:8188/api/models' -Method GET -TimeoutSec 5 -ErrorAction SilentlyContinue
  if ($infoResponse) {
    Write-Host "Models API: OK"
  } else {
    Write-Host "Models API: Not available"
  }
} catch {
  Write-Host "Server Status: ERROR"
  Write-Host "Error: $($_.Exception.Message)"
}

# Check available nodes
Write-Host ""
Write-Host "Checking available nodes..."
try {
  $nodesResponse = Invoke-WebRequest -Uri 'http://localhost:8188/object_info' -Method GET -TimeoutSec 5
  Write-Host "Nodes API: OK"
  $nodesData = ConvertFrom-Json $nodesResponse.Content
  Write-Host "Total node types: $($nodesData.PSObject.Properties.Count)"

  # Check for specific nodes we need
  if ($nodesData.'CheckpointLoaderSimple') {
    Write-Host "  ✓ CheckpointLoaderSimple available"
  } else {
    Write-Host "  ✗ CheckpointLoaderSimple NOT available"
  }

  if ($nodesData.'CLIPTextEncode') {
    Write-Host "  ✓ CLIPTextEncode available"
  } else {
    Write-Host "  ✗ CLIPTextEncode NOT available"
  }

  if ($nodesData.'KSampler') {
    Write-Host "  ✓ KSampler available"
  } else {
    Write-Host "  ✗ KSampler NOT available"
  }

  if ($nodesData.'VAEDecode') {
    Write-Host "  ✓ VAEDecode available"
  } else {
    Write-Host "  ✗ VAEDecode NOT available"
  }

  if ($nodesData.'SaveImage') {
    Write-Host "  ✓ SaveImage available"
  } else {
    Write-Host "  ✗ SaveImage NOT available"
  }

  if ($nodesData.'DualCLIPLoader') {
    Write-Host "  ✓ DualCLIPLoader available"
  } else {
    Write-Host "  ✗ DualCLIPLoader NOT available"
  }

} catch {
  Write-Host "Nodes API: ERROR"
  Write-Host "Error: $($_.Exception.Message)"
}
