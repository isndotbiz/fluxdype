# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

**FluxDype** is a ComfyUI-based image generation system running entirely on the D: drive (D:\workspace\fluxdype). The project uses ComfyUI with Flux Kria FP8 models optimized for NVIDIA RTX 3090 GPUs. All dependencies are isolated in a Python virtual environment to keep the C: drive clean.

## Project Architecture

### Directory Structure

```
D:\workspace\fluxdype\
├── venv/                       # Python 3.12+ virtual environment (isolated on D:)
├── ComfyUI/                    # ComfyUI repository (cloned from GitHub)
│   ├── main.py                 # ComfyUI entry point
│   ├── models/                 # Model storage directory
│   │   ├── diffusion_models/   # Flux models (.safetensors)
│   │   ├── vae/                # VAE models
│   │   ├── text_encoders/      # CLIP and T5XXL encoders
│   │   ├── loras/              # LoRA models
│   │   ├── controlnet/         # ControlNet models
│   │   ├── embeddings/         # Text inversions
│   │   └── upscale_models/     # Upscaling models
│   ├── output/                 # Generated images
│   └── custom_nodes/           # ComfyUI extensions
├── models/                     # Additional model storage (separate from ComfyUI/models/)
├── start-comfy.ps1             # Server startup script
├── run-workflow.ps1            # Workflow submission script
└── setup_flux_kria_secure.ps1  # Initial setup script (downloads models from HuggingFace)
```

### Key Components

- **Server**: ComfyUI runs on `http://localhost:8188` as a headless HTTP API server
- **Workflow Execution**: JSON workflows are submitted via HTTP POST to `/prompt` endpoint
- **GPU Acceleration**: Uses CUDA 12.1 with PyTorch for RTX 3090
- **Model Management**: Models stored in `ComfyUI/models/` and `models/` directories
- **Virtual Environment**: All Python dependencies isolated in `venv/` on D: drive

## Common Commands

### Starting the Server

```pwsh
cd D:\workspace\fluxdype
.\start-comfy.ps1
```

This activates the venv and launches ComfyUI on port 8188. Server runs until Ctrl+C is pressed.

### Submitting Workflows

```pwsh
# Submit and return immediately
.\run-workflow.ps1 -WorkflowPath ".\ComfyUI\my_workflow.json"

# Submit and wait for completion
.\run-workflow.ps1 -WorkflowPath ".\ComfyUI\my_workflow.json" -Wait

# Submit to different host/port
.\run-workflow.ps1 -WorkflowPath "workflow.json" -Host "192.168.1.100" -Port 8189
```

### Manual ComfyUI Server Launch (with VRAM options)

```pwsh
cd D:\workspace\fluxdype
.\venv\Scripts\Activate.ps1
cd ComfyUI

# High-end GPU (24GB+ VRAM)
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --gpu-only

# Mid-range GPU (8-16GB VRAM) - Default
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --normalvram

# Low VRAM (4-8GB)
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --lowvram

# CPU-only mode (very slow)
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --cpu
```

### HTTP API Usage

```pwsh
# Submit workflow
$workflow = Get-Content "workflow.json" -Raw
$response = Invoke-WebRequest -Uri "http://localhost:8188/prompt" -Method POST -ContentType "application/json" -Body $workflow
$jobId = ($response.Content | ConvertFrom-Json).prompt_id

# Check job status
$history = Invoke-WebRequest -Uri "http://localhost:8188/history/$jobId" -Method GET | ConvertFrom-Json
if ($history.$jobId) { "Job completed" } else { "Still running" }

# Interrupt generation
Invoke-WebRequest -Uri "http://localhost:8188/interrupt" -Method POST

# Get system stats
Invoke-WebRequest -Uri "http://localhost:8188/system_stats" -Method GET | ConvertFrom-Json
```

### Model Management

Models are stored in two locations:

1. **ComfyUI/models/** - Primary location used by ComfyUI
2. **models/** - Additional model storage (separate structure)

To add new models:
```pwsh
# Place models in appropriate subdirectory
cp model.safetensors D:\workspace\fluxdype\ComfyUI\models\diffusion_models\
```

### Initial Setup (First-time only)

```pwsh
# Requires .env file with HUGGINGFACE_TOKEN
.\setup_flux_kria_secure.ps1
```

This script:
- Creates Python venv on D: drive
- Clones ComfyUI repository
- Installs PyTorch with CUDA 12.1
- Downloads Flux Kria FP8 models from HuggingFace
- Launches ComfyUI server

## Environment Configuration

### Required Environment Variables

Create a `.env` file from `.env.example`:

```bash
# HuggingFace API Token (required for model downloads)
HUGGINGFACE_TOKEN=your_token_here

# CivitAI API Key (optional, for CivitAI model downloads)
CIVITAI_API_KEY=your_key_here
```

**IMPORTANT**: Never commit `.env` files to Git. Use `.env.example` as a template.

## Development Workflows

### Adding Custom Nodes

```pwsh
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone <custom-node-repository>
cd ..
# Restart ComfyUI server
```

### Updating ComfyUI

```pwsh
cd D:\workspace\fluxdype\ComfyUI
git pull origin main
# Restart server to apply changes
```

### Updating Python Dependencies

```pwsh
cd D:\workspace\fluxdype
.\venv\Scripts\Activate.ps1
pip install --upgrade -r ComfyUI\requirements.txt
```

## GPU Optimization (RTX 3090 Specific)

The `setup_flux_kria_secure.ps1` launches with these optimizations:

```pwsh
--precision=bf16              # Use BF16 precision
--xformers                    # Enable xformers memory-efficient attention
--opt-sdp-no-mem-attention    # Optimize scaled dot-product attention
--opt-channelslast            # Channel-last memory layout
--no-half-vae                 # Keep VAE in full precision
--force-enable-xformers       # Force xformers even if not detected
```

For `start-comfy.ps1`, default mode uses standard VRAM mode. Edit the script to add optimization flags as needed.

## Important Notes

- **Drive Isolation**: Everything runs on D: drive. C: drive has no ComfyUI-related files.
- **Virtual Environment**: Always activate venv before running Python commands manually.
- **Port Conflicts**: If port 8188 is in use, change the port in `start-comfy.ps1` or use `-Port` parameter.
- **Model Storage**: Large model files (.safetensors, .ckpt) are excluded from Git via `.gitignore`.
- **Web UI**: Access the ComfyUI web interface at `http://localhost:8188` while server is running.
- **Workflow JSON**: Workflows can be exported from the web UI and submitted programmatically via `run-workflow.ps1`.

## Credential Management

- API keys and tokens are stored in `.env` (never committed)
- `.env.example` provides template with placeholder values
- `setup_flux_kria_secure.ps1` loads credentials from `.env` for secure HuggingFace downloads
- Git ignores all `.env*` files, `.key`, `.pem`, `credentials.json`, `secrets.json`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Port 8188 already in use | Change port in `start-comfy.ps1` or kill existing process |
| Connection refused | Ensure `start-comfy.ps1` is running in another terminal |
| Out of memory (CUDA) | Use `--lowvram` or `--cpu` flags in server launch |
| Models not found | Verify models are in `ComfyUI/models/<type>/` directory |
| Import errors | Reactivate venv: `.\venv\Scripts\Activate.ps1` |
| HuggingFace download fails | Check `HUGGINGFACE_TOKEN` in `.env` file |
