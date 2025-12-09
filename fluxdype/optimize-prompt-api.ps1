# API-Based Prompt Optimizer (No Local VRAM)
# Usage: .\optimize-prompt-api.ps1 -Prompt "your idea" -Style "photorealistic"

param(
    [Parameter(Mandatory=$true)]
    [string]$Prompt,

    [string]$Style = "photorealistic",
    [string]$Model = "anthropic/claude-3.5-sonnet"  # Fast and cheap
)

# Load API key from .env
$envFile = Join-Path $PSScriptRoot ".env"
$apiKey = $null

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^OPENROUTER_API_KEY=(.+)$') {
            $apiKey = $matches[1]
        }
    }
}

if (-not $apiKey) {
    Write-Host "`nError: OPENROUTER_API_KEY not found in .env file" -ForegroundColor Red
    Write-Host "`nTo fix this:" -ForegroundColor Yellow
    Write-Host "1. Go to https://openrouter.ai/" -ForegroundColor Cyan
    Write-Host "2. Sign in and get an API key" -ForegroundColor Cyan
    Write-Host "3. Add to .env file: OPENROUTER_API_KEY=sk-or-v1-..." -ForegroundColor Cyan
    Write-Host "`nSee API_PROMPT_HELPER_SETUP.md for details`n" -ForegroundColor Green
    exit 1
}

$systemPrompt = @"
You are an expert Flux image prompt engineer. Optimize prompts following these rules:

1. Use clear, descriptive language with comma-separated keywords
2. Include technical details (lighting, composition, camera settings for photos)
3. Add quality markers: masterpiece, best quality, highly detailed, 8k
4. Match the requested style exactly
5. Suggest optimal negative prompt to avoid common issues
6. Recommend specific settings (sampler, steps, CFG, resolution)

Output format:
OPTIMIZED PROMPT: [detailed comma-separated prompt]

NEGATIVE PROMPT: [things to avoid]

RECOMMENDED SETTINGS:
- Model: [best Flux model for this]
- Sampler: [sampler name]
- Scheduler: [scheduler name]
- Steps: [number]
- CFG: [value]
- Resolution: [width x height]
- LoRAs: [suggested LoRAs if applicable]
"@

$requestBody = @{
    model = $Model
    messages = @(
        @{
            role = "system"
            content = $systemPrompt
        },
        @{
            role = "user"
            content = "Style: $Style`nOriginal idea: $Prompt`n`nOptimize this for Flux image generation."
        }
    )
} | ConvertTo-Json -Depth 10

Write-Host "`nOptimizing prompt..." -ForegroundColor Yellow
Write-Host "Model: $Model" -ForegroundColor Cyan
Write-Host ""

try {
    $response = Invoke-RestMethod `
        -Uri "https://openrouter.ai/api/v1/chat/completions" `
        -Method POST `
        -Headers @{
            "Authorization" = "Bearer $apiKey"
            "Content-Type" = "application/json"
            "HTTP-Referer" = "https://github.com/fluxdype"
            "X-Title" = "Flux Prompt Optimizer"
        } `
        -Body $requestBody

    Write-Host "="*70 -ForegroundColor Cyan
    Write-Host "AI PROMPT OPTIMIZER" -ForegroundColor Cyan
    Write-Host "="*70 -ForegroundColor Cyan
    Write-Host $response.choices[0].message.content -ForegroundColor Green
    Write-Host "="*70 -ForegroundColor Cyan

    $tokens = $response.usage.total_tokens
    $cost = $tokens * 0.000001
    Write-Host "`nTokens used: $tokens | Estimated cost: ~`$$($cost.ToString('F6'))" -ForegroundColor Yellow
    Write-Host ""

} catch {
    Write-Host "`nAPI request failed!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "`nPossible issues:" -ForegroundColor Yellow
    Write-Host "- Check your API key is valid" -ForegroundColor Cyan
    Write-Host "- Ensure you have credits at https://openrouter.ai/credits" -ForegroundColor Cyan
    Write-Host "- Check your internet connection" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}
