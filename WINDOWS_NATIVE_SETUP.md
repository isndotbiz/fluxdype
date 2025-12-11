# Windows Native Setup Guide (Maximum Performance)

This guide helps you set up ComfyUI with Flux on **Windows natively** for **10-20% better performance** compared to WSL2.

---

## 🎯 Why Windows Native?

### Performance Benefits
- ✅ **10-20% faster CUDA performance** vs WSL2
- ✅ **Direct GPU access** - no virtualization overhead
- ✅ **Stable performance** - no WSL2 instability issues
- ✅ **Faster memory transfers** - better model loading speeds
- ✅ **Better xFormers performance** - 37% improvement over baseline

### When to Use WSL2
- ❌ WSL2 has virtualization overhead
- ❌ Unstable CUDA performance in some scenarios
- ❌ Slower host-to-GPU memory transfers
- ✅ Only use WSL2 if you need Linux-specific tools

---

## 📋 Prerequisites

1. **Windows 10/11** with latest updates
2. **NVIDIA GPU** (RTX 3090 or similar)
3. **NVIDIA Drivers** (Latest version from nvidia.com)
4. **Python 3.10+** installed on Windows
   - Download from: https://www.python.org/downloads/
   - During installation, check "Add Python to PATH"

---

## 🚀 Quick Setup (Automated)

### Step 1: Open PowerShell as Administrator

1. Press `Win + X`
2. Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

### Step 2: Navigate to Project Directory

```powershell
cd D:\workspace\fluxdype
```

### Step 3: Run Setup Script

```powershell
.\setup-windows-native.ps1
```

This will:
- ✅ Create a Windows-native Python virtual environment
- ✅ Backup your WSL venv (rename to `venv_wsl_backup`)
- ✅ Install PyTorch 2.9.0 with CUDA 12.6
- ✅ Install xFormers 0.0.33.post1
- ✅ Verify everything is working

**Expected runtime:** 5-10 minutes (downloads ~3GB)

### Step 4: Verify Installation

Close PowerShell and open a **new** PowerShell window, then:

```powershell
cd D:\workspace\fluxdype
.\verify-windows.ps1
```

You should see:
```
✅ PyTorch: 2.9.0+cu126
✅ CUDA Available: True
✅ xFormers: 0.0.33.post1
✅ xFormers C++/CUDA extensions loaded successfully
✅ Found 5 checkpoint models
✅ Found 17 LoRA models
```

### Step 5: Start ComfyUI

```powershell
.\start-comfy.ps1
```

ComfyUI will be available at: **http://localhost:8188**

---

## 🔧 Manual Setup (If Automated Fails)

### 1. Create Virtual Environment

```powershell
cd D:\workspace\fluxdype
python -m venv venv
```

### 2. Activate Virtual Environment

```powershell
.\venv\Scripts\Activate.ps1
```

### 3. Upgrade pip

```powershell
python -m pip install --upgrade pip
```

### 4. Install PyTorch with CUDA 12.6

```powershell
pip install torch==2.9.0 torchvision==0.24.0 torchaudio==2.9.0 --index-url https://download.pytorch.org/whl/cu126
```

### 5. Install xFormers

```powershell
pip install -U xformers --index-url https://download.pytorch.org/whl/cu126
```

### 6. Verify Installation

```powershell
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA: {torch.cuda.is_available()}')"
python -c "import xformers; print(f'xFormers: {xformers.__version__}')"
```

### 7. Install ComfyUI Dependencies (if needed)

```powershell
cd ComfyUI
pip install -r requirements.txt
cd ..
```

---

## 🎮 Starting ComfyUI

### Option 1: Using the Startup Script (Recommended)

```powershell
cd D:\workspace\fluxdype
.\start-comfy.ps1
```

### Option 2: Manual Start

```powershell
cd D:\workspace\fluxdype
.\venv\Scripts\Activate.ps1
cd ComfyUI
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch
```

### Accessing ComfyUI Web Interface

Open your browser and go to:
- **http://localhost:8188**
- Or **http://127.0.0.1:8188**

---

## 🔍 Troubleshooting

### "Cannot be loaded because running scripts is disabled"

Run this in PowerShell as Administrator:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Python not found"

1. Install Python from https://www.python.org/downloads/
2. During installation, check "Add Python to PATH"
3. Restart PowerShell

### "CUDA not available"

1. Update NVIDIA drivers: https://www.nvidia.com/Download/index.aspx
2. Verify GPU is detected:
   ```powershell
   nvidia-smi
   ```
3. Reinstall PyTorch with CUDA:
   ```powershell
   pip uninstall torch torchvision torchaudio
   pip install torch==2.9.0 torchvision==0.24.0 torchaudio==2.9.0 --index-url https://download.pytorch.org/whl/cu126
   ```

### xFormers Warning Still Appears

This means xFormers isn't loading. Verify:
```powershell
python -c "import xformers.ops; print('xFormers OK')"
```

If it fails, reinstall:
```powershell
pip uninstall xformers
pip install -U xformers --index-url https://download.pytorch.org/whl/cu126
```

### Port 8188 Already in Use

Change the port in `start-comfy.ps1`:
```powershell
python main.py --listen 0.0.0.0 --port 8189 --disable-auto-launch
```

Or kill the existing process:
```powershell
Get-Process | Where-Object {$_.ProcessName -eq "python"} | Stop-Process -Force
```

---

## 📊 Performance Comparison

| Environment | CUDA Performance | Memory Transfer | Stability | xFormers Boost |
|-------------|-----------------|-----------------|-----------|----------------|
| **Windows Native** | **100% (baseline)** | **Fast** | **Stable** | **+37%** |
| WSL2 | 80-90% | Slower | Unstable | +20-30% |

**Recommendation:** Use Windows Native for production workloads.

---

## 📁 Directory Structure

```
D:\workspace\fluxdype\
├── venv\                          # Windows-native Python environment
├── venv_wsl_backup\               # Backup of WSL environment (if exists)
├── ComfyUI\                       # ComfyUI installation
│   ├── main.py
│   ├── models\
│   │   ├── checkpoints\           # 5 Flux models (80GB)
│   │   └── loras\                 # 17 LoRA models (2.5GB)
│   └── custom_nodes\              # 16 custom nodes installed
├── setup-windows-native.ps1       # Automated setup script
├── verify-windows.ps1             # Verification script
└── start-comfy.ps1                # Startup script
```

---

## 🎨 What's Included

### Installed Software
- ✅ PyTorch 2.9.0 + CUDA 12.6
- ✅ xFormers 0.0.33.post1
- ✅ ComfyUI with Flux support

### Installed Custom Nodes (16 total)
- ComfyUI-Manager
- x-flux-comfyui (Flux-specific features)
- ComfyUI-Impact-Pack
- rgthree-comfy
- Use Everywhere
- Efficiency Nodes
- ComfyUI Essentials
- Advanced ControlNet
- KJNodes
- ComfyUI-GGUF
- Ultimate SD Upscale
- Comfyroll Studio
- WAS Node Suite
- Crystools
- ComfyUI Custom Scripts
- flux_autoload.py (auto-detect Flux models)

### Your Models
- **5 Flux Checkpoint Models** (~80GB)
  - fluxedUpFluxNSFW_60FP16_2250122.safetensors
  - iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors
  - iniverseMixSFWNSFW_guofengXLV15.safetensors
  - unstableEvolution_Fp1622GB.safetensors
  - flux_dev.safetensors

- **17 LoRA Models** (~2.5GB)
  - Detail enhancers, realism, character LoRAs

---

## 🔄 Switching Between Windows and WSL

### To Use Windows (Performance)
```powershell
# In Windows PowerShell
cd D:\workspace\fluxdype
.\start-comfy.ps1
```

### To Use WSL (Development/Linux Tools)
```bash
# In WSL terminal
cd /mnt/d/workspace/fluxdype
./start-comfy-wsl.sh
```

**Note:** Models are shared between both environments (in `ComfyUI/models/`), but each has its own Python virtual environment.

---

## 📚 Next Steps

1. ✅ Run `.\verify-windows.ps1` to confirm setup
2. ✅ Start ComfyUI with `.\start-comfy.ps1`
3. ✅ Open http://localhost:8188 in your browser
4. ✅ Load a Flux model from the "Load Checkpoint" node
5. ✅ Try applying a LoRA for enhanced results
6. ✅ Explore the 16 installed custom nodes

---

## 🆘 Support

If you encounter issues:
1. Check the [Troubleshooting](#-troubleshooting) section above
2. Run `.\verify-windows.ps1` to diagnose problems
3. Check ComfyUI logs in the PowerShell window
4. Verify GPU drivers with `nvidia-smi`

---

## 📖 Additional Documentation

- `COMFYUI_EXTENSIONS_AND_MODELS_GUIDE.md` - Complete extension and model guide
- `CLAUDE.md` - Project overview and architecture
- ComfyUI Official Docs: https://docs.comfy.org/

---

**Enjoy 10-20% faster Flux generation with Windows Native! 🚀**
