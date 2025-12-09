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
    
    [string]$ComfyUIHost = "localhost",
    [int]$Port = 8188,
    [switch]$Wait,
    [string]$Prompt
)

# Validate workflow file exists
if (-not (Test-Path $WorkflowPath)) {
    Write-Error "Workflow file not found: $WorkflowPath"
    exit 1
}

$serverUrl = "http://${ComfyUIHost}:${Port}"
$promptUrl = "${serverUrl}/prompt"
$historyUrl = "${serverUrl}/history"

try {
    # Read and submit the workflow
    $workflowJson = Get-Content $WorkflowPath -Raw
    $workflow = $workflowJson | ConvertFrom-Json
    
    # Convert nodes array to dictionary keyed by node ID
    $nodesDict = @{}
    foreach ($node in $workflow.nodes) {
        $nodeId = $node.id.ToString()
        $nodesDict[$nodeId] = @{
            class_type = $node.type
            inputs = @{}
        }
        
        # Process inputs - convert from array to dictionary
        if ($node.inputs) {
            foreach ($input in $node.inputs) {
                $inputName = $input.name
                if ($input.link -ne $null) {
                    # Find the source node and output for this link
                    $link = $workflow.links | Where-Object { $_[0] -eq $input.link }
                    if ($link) {
                        $nodesDict[$nodeId].inputs[$inputName] = @($link[1].ToString(), $link[2])
                    }
                } elseif ($node.widgets_values) {
                    # Use widget values for inputs without links
                    $widgetIndex = [array]::IndexOf($node.inputs.name, $inputName)
                    if ($widgetIndex -ge 0 -and $widgetIndex -lt $node.widgets_values.Count) {
                        $nodesDict[$nodeId].inputs[$inputName] = $node.widgets_values[$widgetIndex]
                    }
                }
            }
        }
        
        # Add widget values directly for nodes without input links
        if ($node.widgets_values -and $node.widgets_values.Count -gt 0) {
            $widgetInputs = $node.inputs | Where-Object { $_.link -eq $null }
            for ($i = 0; $i -lt [Math]::Min($widgetInputs.Count, $node.widgets_values.Count); $i++) {
                $inputName = $widgetInputs[$i].name
                if (-not $nodesDict[$nodeId].inputs.ContainsKey($inputName)) {
                    $nodesDict[$nodeId].inputs[$inputName] = $node.widgets_values[$i]
                }
            }
        }
    }
    
    # If a prompt is provided, try to inject it into the workflow
    if ($PSBoundParameters.ContainsKey('Prompt')) {
        Write-Host "Attempting to inject provided prompt: '$Prompt'" -ForegroundColor DarkYellow
        $injected = $false
        foreach ($nodeId in $nodesDict.Keys) {
            $node = $nodesDict[$nodeId]
            # Common node types for text prompts in ComfyUI
            if ($node.class_type -eq "CLIPTextEncode" -or $node.class_type -eq "Text" -or $node.class_type -eq "FreeU_V2") {
                if ($node.inputs.ContainsKey('text')) {
                    $nodesDict[$nodeId].inputs['text'] = $Prompt
                    Write-Host "✓ Injected prompt into node $nodeId (Type: $($node.class_type), Input: text)" -ForegroundColor Green
                    $injected = $true
                    break
                }
                elseif ($node.inputs.ContainsKey('positive')) {
                    $nodesDict[$nodeId].inputs['positive'] = $Prompt
                    Write-Host "✓ Injected prompt into node $nodeId (Type: $($node.class_type), Input: positive)" -ForegroundColor Green
                    $injected = $true
                    break
                }
            }
        }
        if (-not $injected) {
            Write-Warning "Could not find a suitable node to inject the prompt into. Workflow might not use a standard text input node."
        }
    }
    
    # Wrap in the prompt field as expected by ComfyUI API
    $payload = @{
        prompt = $nodesDict
    } | ConvertTo-Json -Depth 100 -Compress
    
    Write-Host "Submitting workflow to $promptUrl..." -ForegroundColor Cyan
    $response = Invoke-WebRequest -Uri $promptUrl `
                                  -Method POST `
                                  -ContentType "application/json" `
                                  -Body $payload `
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
