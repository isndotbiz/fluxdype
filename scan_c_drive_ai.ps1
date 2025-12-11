# Comprehensive C: Drive AI File Scanner
# Scans for ComfyUI, Flux, Stable Diffusion, and AI-related files

$ErrorActionPreference = "SilentlyContinue"
$results = @{
    "scan_date" = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "c_drive_used_gb" = [math]::Round((Get-PSDrive C).Used / 1GB, 2)
    "c_drive_free_gb" = [math]::Round((Get-PSDrive C).Free / 1GB, 2)
    "ai_directories" = @()
    "model_files" = @()
    "venv_folders" = @()
    "config_files" = @()
    "total_ai_size_gb" = 0
}

Write-Host "Starting comprehensive C: drive AI file scan..." -ForegroundColor Cyan
Write-Host "C: Drive Usage: $($results.c_drive_used_gb) GB used, $($results.c_drive_free_gb) GB free" -ForegroundColor Yellow

# Search paths (excluding system-critical directories)
$searchPaths = @(
    "C:\Users\Jdmal",
    "C:\Program Files",
    "C:\Program Files (x86)",
    "C:\ProgramData"
)

# AI-related directory patterns
$aiPatterns = @(
    "*comfy*", "*ComfyUI*",
    "*flux*", "*Flux*",
    "*stable*diffusion*", "*StableDiffusion*",
    "*automatic1111*", "*a1111*",
    "*invokeai*", "*InvokeAI*",
    "*fooocus*", "*Fooocus*",
    "*lora*", "*LoRA*",
    "*vae*", "*VAE*",
    "*controlnet*", "*ControlNet*"
)

# Model file extensions
$modelExtensions = @("*.safetensors", "*.gguf", "*.ckpt", "*.pth", "*.pt", "*.bin")

# Config file patterns
$configPatterns = @("*config*.json", "*config*.yaml", "*config*.yml")

Write-Host "`n[1/5] Searching for AI application directories..." -ForegroundColor Green

foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        Write-Host "  Scanning: $path" -ForegroundColor Gray

        foreach ($pattern in $aiPatterns) {
            $dirs = Get-ChildItem -Path $path -Directory -Recurse -Filter $pattern -Depth 3 -ErrorAction SilentlyContinue

            foreach ($dir in $dirs) {
                try {
                    $size = (Get-ChildItem -Path $dir.FullName -Recurse -File -ErrorAction SilentlyContinue |
                             Measure-Object -Property Length -Sum).Sum
                    $sizeGB = [math]::Round($size / 1GB, 3)

                    # Determine type
                    $type = "Unknown"
                    if ($dir.Name -match "comfy") { $type = "ComfyUI" }
                    elseif ($dir.Name -match "flux") { $type = "Flux" }
                    elseif ($dir.Name -match "stable|diffusion") { $type = "Stable Diffusion" }
                    elseif ($dir.Name -match "automatic|a1111") { $type = "Automatic1111" }
                    elseif ($dir.Name -match "invoke") { $type = "InvokeAI" }
                    elseif ($dir.Name -match "fooocus") { $type = "Fooocus" }
                    elseif ($dir.Name -match "lora") { $type = "LoRA" }
                    elseif ($dir.Name -match "vae") { $type = "VAE" }
                    elseif ($dir.Name -match "controlnet") { $type = "ControlNet" }

                    $results.ai_directories += @{
                        "path" = $dir.FullName
                        "name" = $dir.Name
                        "size_gb" = $sizeGB
                        "type" = $type
                        "last_modified" = $dir.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                    }

                    $results.total_ai_size_gb += $sizeGB
                    Write-Host "    Found: $($dir.FullName) ($sizeGB GB)" -ForegroundColor Yellow
                } catch {
                    Write-Host "    Error scanning: $($dir.FullName)" -ForegroundColor Red
                }
            }
        }
    }
}

Write-Host "`n[2/5] Searching for AI model files..." -ForegroundColor Green

foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        Write-Host "  Scanning: $path" -ForegroundColor Gray

        foreach ($ext in $modelExtensions) {
            $files = Get-ChildItem -Path $path -File -Recurse -Filter $ext -ErrorAction SilentlyContinue

            foreach ($file in $files) {
                try {
                    $sizeMB = [math]::Round($file.Length / 1MB, 2)
                    $sizeGB = [math]::Round($file.Length / 1GB, 3)

                    # Only include files > 10MB (likely actual models)
                    if ($sizeMB -gt 10) {
                        $modelType = "Unknown"
                        if ($file.Name -match "flux") { $modelType = "Flux" }
                        elseif ($file.Name -match "sd|stable") { $modelType = "Stable Diffusion" }
                        elseif ($file.Name -match "lora") { $modelType = "LoRA" }
                        elseif ($file.Name -match "vae") { $modelType = "VAE" }
                        elseif ($file.Name -match "control") { $modelType = "ControlNet" }
                        elseif ($file.Name -match "clip|t5") { $modelType = "Text Encoder" }

                        $results.model_files += @{
                            "path" = $file.FullName
                            "name" = $file.Name
                            "size_mb" = $sizeMB
                            "size_gb" = $sizeGB
                            "extension" = $file.Extension
                            "type" = $modelType
                            "last_modified" = $file.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                        }

                        $results.total_ai_size_gb += $sizeGB
                        Write-Host "    Found: $($file.Name) ($sizeMB MB)" -ForegroundColor Yellow
                    }
                } catch {
                    Write-Host "    Error scanning: $($file.FullName)" -ForegroundColor Red
                }
            }
        }
    }
}

Write-Host "`n[3/5] Searching for Python virtual environments..." -ForegroundColor Green

$venvPatterns = @("venv", ".venv", "env", ".env")

foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        Write-Host "  Scanning: $path" -ForegroundColor Gray

        foreach ($pattern in $venvPatterns) {
            $venvDirs = Get-ChildItem -Path $path -Directory -Recurse -Filter $pattern -Depth 3 -ErrorAction SilentlyContinue

            foreach ($venv in $venvDirs) {
                # Check if it's actually a Python venv (has Scripts or bin directory)
                $isVenv = (Test-Path (Join-Path $venv.FullName "Scripts")) -or (Test-Path (Join-Path $venv.FullName "bin"))

                if ($isVenv) {
                    try {
                        $size = (Get-ChildItem -Path $venv.FullName -Recurse -File -ErrorAction SilentlyContinue |
                                 Measure-Object -Property Length -Sum).Sum
                        $sizeGB = [math]::Round($size / 1GB, 3)

                        $results.venv_folders += @{
                            "path" = $venv.FullName
                            "name" = $venv.Name
                            "size_gb" = $sizeGB
                            "last_modified" = $venv.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                        }

                        $results.total_ai_size_gb += $sizeGB
                        Write-Host "    Found: $($venv.FullName) ($sizeGB GB)" -ForegroundColor Yellow
                    } catch {
                        Write-Host "    Error scanning: $($venv.FullName)" -ForegroundColor Red
                    }
                }
            }
        }
    }
}

Write-Host "`n[4/5] Searching for AI configuration files..." -ForegroundColor Green

foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        Write-Host "  Scanning: $path" -ForegroundColor Gray

        foreach ($pattern in $configPatterns) {
            $configs = Get-ChildItem -Path $path -File -Recurse -Filter $pattern -Depth 3 -ErrorAction SilentlyContinue

            foreach ($config in $configs) {
                # Check if file content mentions AI tools
                try {
                    $content = Get-Content $config.FullName -Raw -ErrorAction SilentlyContinue
                    if ($content -match "comfy|flux|stable.*diffusion|automatic1111|invokeai|fooocus") {
                        $sizeKB = [math]::Round($config.Length / 1KB, 2)

                        $results.config_files += @{
                            "path" = $config.FullName
                            "name" = $config.Name
                            "size_kb" = $sizeKB
                            "last_modified" = $config.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                        }

                        Write-Host "    Found: $($config.FullName) ($sizeKB KB)" -ForegroundColor Yellow
                    }
                } catch {
                    # Skip files that can't be read
                }
            }
        }
    }
}

Write-Host "`n[5/5] Categorizing and analyzing findings..." -ForegroundColor Green

# Round total size
$results.total_ai_size_gb = [math]::Round($results.total_ai_size_gb, 2)

# Categorization
$results.categorization = @{
    "active" = @()
    "duplicate" = @()
    "obsolete" = @()
    "archive" = @()
}

# Check for duplicates and categorize
$dirPaths = $results.ai_directories | ForEach-Object { $_.path }
$modelPaths = $results.model_files | ForEach-Object { $_.path }

# Directories
foreach ($dir in $results.ai_directories) {
    $category = "ARCHIVE"  # Default to archive (uncertain)

    # Check if it's on D: drive (likely duplicate)
    $dPath = $dir.path -replace "^C:", "D:"
    if (Test-Path $dPath) {
        $category = "DUPLICATE"
    }

    # Check if recently modified (active)
    $daysSinceModified = (Get-Date) - [datetime]::Parse($dir.last_modified)
    if ($daysSinceModified.Days -lt 30) {
        $category = "ACTIVE"
    }

    # Very old files (obsolete)
    if ($daysSinceModified.Days -gt 180) {
        $category = "OBSOLETE"
    }

    $results.categorization.$category.ToLower() += @{
        "type" = "directory"
        "path" = $dir.path
        "size_gb" = $dir.size_gb
        "reason" = $(
            if ($category -eq "DUPLICATE") { "Similar structure exists on D: drive" }
            elseif ($category -eq "ACTIVE") { "Modified within last 30 days" }
            elseif ($category -eq "OBSOLETE") { "Not modified in 180+ days" }
            else { "Uncertain status" }
        )
    }
}

# Model files
foreach ($model in $results.model_files) {
    $category = "ARCHIVE"

    # Check if it's in a D: drive location
    $dPath = $model.path -replace "^C:", "D:"
    if (Test-Path $dPath) {
        $category = "DUPLICATE"
    }

    # Check if recently accessed
    $daysSinceModified = (Get-Date) - [datetime]::Parse($model.last_modified)
    if ($daysSinceModified.Days -lt 30) {
        $category = "ACTIVE"
    }

    if ($daysSinceModified.Days -gt 180) {
        $category = "OBSOLETE"
    }

    $results.categorization.$category.ToLower() += @{
        "type" = "model_file"
        "path" = $model.path
        "size_gb" = $model.size_gb
        "reason" = $(
            if ($category -eq "DUPLICATE") { "Duplicate exists on D: drive" }
            elseif ($category -eq "ACTIVE") { "Modified within last 30 days" }
            elseif ($category -eq "OBSOLETE") { "Not modified in 180+ days" }
            else { "Uncertain status" }
        )
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "SCAN COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total AI-related size on C: $($results.total_ai_size_gb) GB" -ForegroundColor Yellow
Write-Host "AI Directories found: $($results.ai_directories.Count)" -ForegroundColor Yellow
Write-Host "Model files found: $($results.model_files.Count)" -ForegroundColor Yellow
Write-Host "Virtual environments found: $($results.venv_folders.Count)" -ForegroundColor Yellow
Write-Host "Config files found: $($results.config_files.Count)" -ForegroundColor Yellow

# Save results to JSON
$outputPath = "D:\workspace\fluxdype\c_drive_ai_scan_results.json"
$results | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputPath -Encoding UTF8
Write-Host "`nResults saved to: $outputPath" -ForegroundColor Green

# Generate summary recommendations
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RECOMMENDATIONS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$activeCount = $results.categorization.active.Count
$duplicateCount = $results.categorization.duplicate.Count
$obsoleteCount = $results.categorization.obsolete.Count
$archiveCount = $results.categorization.archive.Count

Write-Host "ACTIVE items (keep): $activeCount" -ForegroundColor Green
Write-Host "DUPLICATE items (safe to delete): $duplicateCount" -ForegroundColor Yellow
Write-Host "OBSOLETE items (likely safe to delete): $obsoleteCount" -ForegroundColor Red
Write-Host "ARCHIVE items (review needed): $archiveCount" -ForegroundColor Magenta

# Calculate potential space savings
$duplicateSize = ($results.categorization.duplicate | Measure-Object -Property size_gb -Sum).Sum
$obsoleteSize = ($results.categorization.obsolete | Measure-Object -Property size_gb -Sum).Sum
$potentialSavings = [math]::Round($duplicateSize + $obsoleteSize, 2)

Write-Host "`nPotential space savings: $potentialSavings GB" -ForegroundColor Cyan

Write-Host "`nDetailed results saved to: $outputPath" -ForegroundColor Green
Write-Host "Review the JSON file for complete file paths and categorization." -ForegroundColor Gray
