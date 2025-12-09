# Test Flux Workflow Script
# Usage: .\test-workflow.ps1 -WorkflowFile "flux_basic.json"

param(
    [Parameter(Mandatory=$true)]
    [string]$WorkflowFile,

    [string]$Host = "localhost",
    [int]$Port = 8188
)

$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $scriptPath

# Check if workflow file exists
$workflowPath = Join-Path $scriptPath $WorkflowFile
if (-not (Test-Path $workflowPath)) {
    Write-Error "Workflow file not found: $workflowPath"
    exit 1
}

# Read workflow JSON
$workflow = Get-Content $workflowPath -Raw

# Wrap in API format
$apiRequest = @{
    prompt = (ConvertFrom-Json $workflow)
} | ConvertTo-Json -Depth 10

Write-Host "Submitting workflow: $WorkflowFile" -ForegroundColor Cyan
Write-Host "Server: http://${Host}:${Port}" -ForegroundColor Cyan

try {
    # Submit workflow
    $response = Invoke-RestMethod -Uri "http://${Host}:${Port}/prompt" -Method POST -ContentType "application/json" -Body $apiRequest

    $promptId = $response.prompt_id
    Write-Host "Job submitted! Prompt ID: $promptId" -ForegroundColor Green

    # Wait for completion
    Write-Host "Waiting for generation to complete..." -ForegroundColor Yellow
    $completed = $false
    $maxWait = 300 # 5 minutes
    $waited = 0

    while (-not $completed -and $waited -lt $maxWait) {
        Start-Sleep -Seconds 2
        $waited += 2

        try {
            $history = Invoke-RestMethod -Uri "http://${Host}:${Port}/history/$promptId" -Method GET

            if ($history.$promptId) {
                $completed = $true
                Write-Host "Generation completed!" -ForegroundColor Green

                # Check for outputs
                if ($history.$promptId.outputs) {
                    Write-Host "Output saved to ComfyUI/output/" -ForegroundColor Green
                    Write-Host "Check the output folder for your generated images." -ForegroundColor Cyan
                }
            } else {
                Write-Host "." -NoNewline
            }
        } catch {
            Write-Host "." -NoNewline
        }
    }

    if (-not $completed) {
        Write-Warning "Generation did not complete within $maxWait seconds. Check ComfyUI server."
    }

} catch {
    Write-Error "Failed to submit workflow: $_"
    exit 1
}
