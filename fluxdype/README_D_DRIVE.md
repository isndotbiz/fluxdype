# ✅ ComfyUI Setup Complete on D: Drive

**Everything is on D:\workspace\fluxdype — Your C: drive is clean!**

## What's Installed

- **ComfyUI** — Full repository at `D:\workspace\fluxdype\ComfyUI`
- **Python venv** — Isolated at `D:\workspace\fluxdype\venv`
- **Dependencies** — All in the venv, nothing on C: drive
- **PyTorch with CUDA 12.1** — GPU-ready on D: drive

## Quick Start (Copy & Paste)

### Terminal 1 — Start Server

```pwsh
cd D:\workspace\fluxdype
.\start-comfy.ps1
```

You'll see:
```
Starting ComfyUI on http://localhost:8188
...
Device: cuda:0 NVIDIA GeForce RTX 3090
```

### Terminal 2 — Submit Workflows

```pwsh
cd D:\workspace\fluxdype
.\run-workflow.ps1 -WorkflowPath ".\ComfyUI\my_workflow.json"
```

Or with **-Wait** to block until completion:

```pwsh
.\run-workflow.ps1 -WorkflowPath ".\ComfyUI\my_workflow.json" -Wait
```

---

## File Structure

```
D:\workspace\fluxdype\
├── venv/                    ← Python + all packages (D: only)
├── ComfyUI/                 ← Repository root
│   ├── main.py
│   ├── models/
│   │   ├── checkpoints/     ← SD models go here
│   │   ├── vae/
│   │   ├── loras/
│   │   └── clip/
│   ├── output/              ← Generated images saved here
│   └── ...
├── start-comfy.ps1          ← Run this to start
├── run-workflow.ps1         ← Run this to submit jobs
└── SETUP.md                 ← Detailed guide
```

---

## How It Works

### Architecture

```
┌─────────────────────────────────────┐
│   Your PowerShell Terminal          │
│   (D: drive only)                   │
└──────────────────┬──────────────────┘
                   │
                   ├─→ start-comfy.ps1
                   │   └─→ Activates venv (D:)
                   │       └─→ Runs ComfyUI server
                   │           (http://localhost:8188)
                   │
                   └─→ run-workflow.ps1
                       └─→ Sends JSON to HTTP API
                           └─→ Server processes on GPU
```

### Zero C: Drive Pollution

All dependencies are **entirely on D:**

```pwsh
# Verify C: drive is untouched:
Get-ChildItem C:\Users\Jdmal\ComfyUI -ErrorAction SilentlyContinue

# Should be empty or minimal (old files only)
```

---

## Common Tasks

### Add Models

1. Download model files
2. Place in appropriate subfolder:
   - **Checkpoints**: `D:\workspace\fluxdype\ComfyUI\models\checkpoints\`
   - **VAE**: `D:\workspace\fluxdype\ComfyUI\models\vae\`
   - **LoRA**: `D:\workspace\fluxdype\ComfyUI\models\loras\`

### Use the Web UI

While server is running, open:
```
http://localhost:8188
```

### Different VRAM Modes

Edit the last line of `start-comfy.ps1`:

```pwsh
# High-end GPU (24GB+)
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --gpu-only

# Mid-range GPU (8-16GB)
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --normalvram

# Low-end GPU (4-8GB)
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --lowvram
```

### Submit Workflow with PowerShell

```pwsh
cd D:\workspace\fluxdype
$workflow = Get-Content "ComfyUI\workflow.json" -Raw
$response = Invoke-WebRequest `
  -Uri "http://localhost:8188/prompt" `
  -Method POST `
  -ContentType "application/json" `
  -Body $workflow

$jobId = ($response.Content | ConvertFrom-Json).prompt_id
Write-Host "Job ID: $jobId"
```

### Check Job Status

```pwsh
$jobId = "your-job-id-here"
$history = Invoke-WebRequest `
  -Uri "http://localhost:8188/history/$jobId" `
  -Method GET | ConvertFrom-Json

if ($history.$jobId) {
  Write-Host "✓ Completed!"
  $history.$jobId
} else {
  Write-Host "⏳ Still running..."
}
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **Port 8188 in use** | Change port in `start-comfy.ps1` to `8189` (or any free port) |
| **Connection refused** | Ensure `start-comfy.ps1` is still running in another terminal |
| **GPU out of memory** | Add `--lowvram` or `--cpu` flag |
| **Models not found** | Check `D:\workspace\fluxdype\ComfyUI\models\` folder structure |
| **Permission denied** | Run PowerShell as Administrator (usually not needed) |

---

## Behind the Scenes

### Why This Works

1. **Virtual Environment**: Isolates Python 3.12 + all packages to D:
2. **PyTorch CUDA**: Installed with CUDA 12.1 support for GPU acceleration
3. **No System Python**: Uses venv exclusively — C: drive stays clean
4. **Portable**: Everything can be moved/backed up as a single folder

### What's on Each Drive

| Drive | Contents |
|-------|----------|
| **C:** | Windows + your user files (untouched) |
| **D:** | ComfyUI + venv + all dependencies (self-contained) |

---

## Next Steps

1. **Download models** to `D:\workspace\fluxdype\ComfyUI\models\checkpoints\`
2. **Start the server** with `.\start-comfy.ps1`
3. **Open web UI** at `http://localhost:8188`
4. **Build workflows** in the UI or submit JSON via CLI
5. **Check outputs** in `D:\workspace\fluxdype\ComfyUI\output\`

---

## References

- **Official Docs**: https://docs.comfy.org/
- **API Guide**: https://docs.comfy.org/api
- **GitHub**: https://github.com/comfyanonymous/ComfyUI
- **Examples**: https://comfyanonymous.github.io/ComfyUI_examples/

---

## Support

If issues arise:

1. Check `SETUP.md` for detailed troubleshooting
2. Review `start-comfy.ps1` output for error messages
3. Visit GitHub issues: https://github.com/comfyanonymous/ComfyUI/issues

**You're all set! Enjoy ComfyUI on D: 🚀**
