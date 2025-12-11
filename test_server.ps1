# Test the server API
$workflow = @{
    "3" = @{
        "inputs" = @{
            "seed" = 42
            "steps" = 5
            "cfg" = 3.5
            "sampler_name" = "euler"
            "scheduler" = "simple"
            "denoise" = 1
            "model" = @("11", 0)
            "positive" = @("6", 0)
            "negative" = @("7", 0)
            "latent_image" = @("5", 0)
        }
        "class_type" = "KSampler"
    }
    "5" = @{
        "inputs" = @{
            "width" = 512
            "height" = 512
            "batch_size" = 1
        }
        "class_type" = "EmptyLatentImage"
    }
    "6" = @{
        "inputs" = @{
            "text" = "test landscape"
            "clip" = @("10", 1)
        }
        "class_type" = "CLIPTextEncode"
    }
    "7" = @{
        "inputs" = @{
            "text" = "blurry, low quality"
            "clip" = @("10", 1)
        }
        "class_type" = "CLIPTextEncode"
    }
    "8" = @{
        "inputs" = @{
            "samples" = @("3", 0)
            "vae" = @("11", 2)
        }
        "class_type" = "VAEDecode"
    }
    "9" = @{
        "inputs" = @{
            "filename_prefix" = "test_image"
            "images" = @("8", 0)
        }
        "class_type" = "SaveImage"
    }
    "10" = @{
        "inputs" = @{
            "clip_name1" = "clip_l.safetensors"
            "clip_name2" = "t5xxl_fp16.safetensors"
            "type" = "flux"
        }
        "class_type" = "DualCLIPLoader"
    }
    "11" = @{
        "inputs" = @{
            "unet_name" = "flux1-krea-dev_fp8_scaled.safetensors"
            "weight_dtype" = "fp8_e4m3fn"
        }
        "class_type" = "UNETLoader"
    }
}

$body = $workflow | ConvertTo-Json -Depth 10
Write-Host "Sending workflow..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $body -TimeoutSec 10
    Write-Host "Status: $($response.StatusCode)"
    Write-Host "Response:"
    Write-Host $response.Content

    $data = $response.Content | ConvertFrom-Json
    Write-Host "Job ID: $($data.prompt_id)"
} catch {
    Write-Host "Error: $_"
    Write-Host "Response: $($_.Exception.Response)"
}
