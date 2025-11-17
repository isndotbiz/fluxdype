#!/usr/bin/env pwsh
<#
.SYNOPSIS
Submit a workflow to ComfyUI running on D: drive and optionally wait for completion.

.DESCRIPTION
Submits a JSON workflow to the running ComfyUI server at localhost:8188.
Returns the job ID which can be used to query status or retrieve outputs.
All work stays on D:\workspace\fluxdype.

.PARAMETER WorkflowPath
Path to the workflow JSON file to submit (relative or absolute).

.PARAMETER Host
Host/IP of the ComfyUI server (default: localhost).

.PARAMETER Port
Port of the ComfyUI server (default: 8188).

.PARAMETER Wait
If specified, wait for the job to complete before returning.

.EXAMPLE
.\run-workflow.ps1 -WorkflowPath ".\workflow.json"
# Submits the workflow and returns the job ID

.\run-workflow.ps1 -WorkflowPath ".\workflow.json" -Wait
# Submits and waits for completion
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$WorkflowPath,
    
    [string]$Host = "localhost",
    [int]$Port = 8188,
    [switch]$Wait
)

# Validate workflow file exists
if (-not (Test-Path $WorkflowPath)) {
    Write-Error "Workflow file not found: $WorkflowPath"
    exit 1
}

$serverUrl = "http://${Host}:${Port}"
$promptUrl = "${serverUrl}/prompt"
$historyUrl = "${serverUrl}/history"

try {
    # Read and submit the workflow
    $workflowJson = Get-Content $WorkflowPath -Raw
    
    Write-Host "Submitting workflow to $promptUrl..." -ForegroundColor Cyan
    $response = Invoke-WebRequest -Uri $promptUrl `
                                  -Method POST `
                                  -ContentType "application/json" `
                                  -Body $workflowJson `
                                  -ErrorAction Stop
    
    $result = $response.Content | ConvertFrom-Json
    $jobId = $result.prompt_id
    
    Write-Host "✓ Workflow submitted successfully" -ForegroundColor Green
    Write-Host "Job ID: $jobId" -ForegroundColor Yellow
    
    if ($Wait) {
        Write-Host "Waiting for job to complete..." -ForegroundColor Cyan
        $completed = $false
        $maxWait = 3600  # 1 hour timeout
        $elapsed = 0
        $checkInterval = 2  # Check every 2 seconds
        
        while (-not $completed -and $elapsed -lt $maxWait) {
            Start-Sleep -Seconds $checkInterval
            $elapsed += $checkInterval
            
            try {
                $historyResponse = Invoke-WebRequest -Uri "$historyUrl/$jobId" `
                                                     -Method GET `
                                                     -ErrorAction SilentlyContinue
                
                if ($historyResponse.StatusCode -eq 200) {
                    $history = $historyResponse.Content | ConvertFrom-Json
                    if ($null -ne $history.$jobId) {
                        $completed = $true
                        Write-Host "✓ Job completed!" -ForegroundColor Green
                        Write-Host "Output: $($history.$jobId | ConvertTo-Json -Depth 2)" -ForegroundColor Cyan
                    }
                }
            } catch {
                # Job might still be processing
            }
            
            # Show progress dots
            Write-Host "." -NoNewline -ForegroundColor Cyan
        }
        
        if (-not $completed) {
            Write-Warning "Job did not complete within $maxWait seconds"
        }
    }
    
} catch {
    Write-Error "Failed to submit workflow: $_"
    exit 1
}
