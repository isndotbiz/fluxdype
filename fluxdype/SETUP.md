# ComfyUI Setup on D: Drive (FluxDype)

Everything is now on **D:\workspace\fluxdype** — no C: drive pollution!

## Quick Start

### 1. Start the Server

Open PowerShell and navigate to the fluxdype folder:

```pwsh
cd D:\workspace\fluxdype
.\start-comfy.ps1
```

You should see:
```
Starting ComfyUI on http://localhost:8188
Press Ctrl+C to stop the server
...
Device: cuda:0 NVIDIA GeForce RTX 3090
```

### 2. Submit Workflows

In another PowerShell window:

```pwsh
cd D:\workspace\fluxdype
.\run-workflow.ps1 -WorkflowPath ".\ComfyUI\my_workflow.json"
```

Or wait for completion:

```pwsh
.\run-workflow.ps1 -WorkflowPath ".\ComfyUI\my_workflow.json" -Wait
```

---

## Folder Structure

```
D:\workspace\fluxdype\
├── venv/                    # Python virtual environment (all deps isolated here)
├── ComfyUI/                 # ComfyUI repository
│   ├── main.py
│   ├── requirements.txt
│   ├── models/              # Model storage
│   ├── output/              # Generated outputs
│   └── ...
├── start-comfy.ps1          # Start the server
├── run-workflow.ps1         # Submit workflows
└── SETUP.md                 # This file
```

---

## Configuration

### Models Location

All models should go in: **D:\workspace\fluxdype\ComfyUI\models\**

Subdirectories:
- `checkpoints/` — Stable Diffusion models
- `vae/` — VAE models
- `loras/` — LoRA models
- `clip/` — CLIP models
- `embeddings/` — Text inversions

### Output Storage

Generated images go to: **D:\workspace\fluxdype\ComfyUI\output\**

### Custom Nodes

Custom nodes go in: **D:\workspace\fluxdype\ComfyUI\custom_nodes\**

---

## Usage Examples

### Basic Startup

```pwsh
# Terminal 1
cd D:\workspace\fluxdype
.\start-comfy.ps1

# Terminal 2 (new window)
cd D:\workspace\fluxdype
.\run-workflow.ps1 -WorkflowPath "workflow.json"
```

### Using Different VRAM Modes

Edit `start-comfy.ps1` or run manually:

```pwsh
# Activate venv first
cd D:\workspace\fluxdype
.\venv\Scripts\Activate.ps1

# Then run with different flags
cd ComfyUI

# GPU-only mode (24GB+ VRAM)
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --gpu-only

# Normal VRAM mode (8-16GB)
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --normalvram

# Low VRAM mode (4-8GB, slower)
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --lowvram

# CPU only (very slow)
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --cpu
```

### Accessing the Web UI

While the server is running, open in your browser:
```
http://localhost:8188
```

---

## HTTP API Examples

### Submit a Workflow

```pwsh
cd D:\workspace\fluxdype
$workflow = Get-Content "ComfyUI\workflow.json" -Raw
$response = Invoke-WebRequest `
  -Uri "http://localhost:8188/prompt" `
  -Method POST `
  -ContentType "application/json" `
  -Body $workflow

$jobId = ($response.Content | ConvertFrom-Json).prompt_id
Write-Host "Job submitted: $jobId"
```

### Check Job Status

```pwsh
$jobId = "your-job-id-here"
$history = Invoke-WebRequest `
  -Uri "http://localhost:8188/history/$jobId" `
  -Method GET | ConvertFrom-Json

if ($history.$jobId) {
  Write-Host "Job completed!"
  $history.$jobId | ConvertTo-Json -Depth 5
} else {
  Write-Host "Job still running..."
}
```

### Interrupt Generation

```pwsh
Invoke-WebRequest `
  -Uri "http://localhost:8188/interrupt" `
  -Method POST
```

### Get System Stats

```pwsh
Invoke-WebRequest `
  -Uri "http://localhost:8188/system_stats" `
  -Method GET | ConvertFrom-Json
```

---

## Troubleshooting

### Port Already in Use

If port 8188 is busy, edit `start-comfy.ps1` and change the port:

```pwsh
python main.py --listen 0.0.0.0 --port 8189 --disable-auto-launch
```

### Connection Refused

Ensure the server is running:
- Check that `start-comfy.ps1` is still running
- Verify with: `curl http://localhost:8188`

### Out of Memory

Try a lower VRAM mode:
```pwsh
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --lowvram
```

### Models Not Found

1. Download models to the correct folder
2. Check paths from the UI
3. From PowerShell:
   ```pwsh
   .\venv\Scripts\Activate.ps1
   cd ComfyUI
   python -c "import folder_paths; print(folder_paths.get_checkpoints_dir())"
   ```

---

## Environment Info

- **Location**: D:\workspace\fluxdype
- **Python**: 3.12+ (in venv)
- **Virtual Env**: D:\workspace\fluxdype\venv
- **ComfyUI**: D:\workspace\fluxdype\ComfyUI
- **C: Drive**: Completely clean (no dependencies)

---

## Maintenance

### Update ComfyUI

```pwsh
cd D:\workspace\fluxdype\ComfyUI
git pull origin main
```

### Update Dependencies

```pwsh
cd D:\workspace\fluxdype
.\venv\Scripts\Activate.ps1
pip install --upgrade -r ComfyUI/requirements.txt
```

### Clean Cache

```pwsh
cd D:\workspace\fluxdype
Remove-Item -Recurse -Force "ComfyUI/__pycache__"
Remove-Item -Recurse -Force "ComfyUI/.pytest_cache"
```

---

## Resources

- **Official Docs**: https://docs.comfy.org/
- **API Reference**: https://docs.comfy.org/api
- **GitHub**: https://github.com/comfyanonymous/ComfyUI
- **Examples**: https://comfyanonymous.github.io/ComfyUI_examples/
