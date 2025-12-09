#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Batch generate ultra-realistic images for phone apps

.DESCRIPTION
    PowerShell wrapper for batch_generate.py - generates high-quality,
    ultra-realistic images optimized for mobile viewing.

.PARAMETER Prompt
    Single prompt to generate

.PARAMETER File
    Path to file with prompts (one per line)

.PARAMETER Resolution
    Output resolution: portrait, portrait_hd, square, landscape, landscape_hd, story

.PARAMETER Quality
    Quality preset: ultra, high, balanced, fast

.PARAMETER Variations
    Number of variations per prompt

.PARAMETER Negative
    Additional negative prompt

.PARAMETER NoWait
    Submit all jobs without waiting for completion

.EXAMPLE
    .\batch-generate.ps1 -Prompt "beautiful sunset over ocean" -Variations 3

.EXAMPLE
    .\batch-generate.ps1 -File prompts.txt -Quality ultra -Resolution portrait_hd

.EXAMPLE
    .\batch-generate.ps1 -File prompts.txt -Quality fast -Resolution story -Variations 5
#>

param(
    [string]$Prompt,
    [string]$File,
    [ValidateSet("portrait", "portrait_hd", "square", "landscape", "landscape_hd", "story")]
    [string]$Resolution = "portrait",
    [ValidateSet("ultra", "high", "balanced", "fast")]
    [string]$Quality = "high",
    [int]$Variations = 1,
    [string]$Negative = "",
    [switch]$NoWait
)

# Change to fluxdype directory
Set-Location -Path "D:\workspace\fluxdype"

# Activate virtual environment
& ".\venv\Scripts\Activate.ps1"

# Build python command
$pythonArgs = @(
    "batch_generate.py"
)

if ($Prompt) {
    $pythonArgs += "-p", $Prompt
}

if ($File) {
    $pythonArgs += "-f", $File
}

$pythonArgs += "-r", $Resolution
$pythonArgs += "-q", $Quality
$pythonArgs += "-v", $Variations

if ($Negative) {
    $pythonArgs += "-n", $Negative
}

if ($NoWait) {
    $pythonArgs += "--no-wait"
}

# Run batch generator
Write-Host "Starting batch generation..." -ForegroundColor Cyan
python @pythonArgs

Write-Host "`nBatch generation complete!" -ForegroundColor Green
Write-Host "Check output: D:\workspace\fluxdype\ComfyUI\output\" -ForegroundColor Yellow
