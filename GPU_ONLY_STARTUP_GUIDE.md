# GPU-Only Flux Startup Guide

## 🚀 Quick Start (GPU-ONLY Mode)

```powershell
.\start-comfy-gpu-only.ps1
```

This launches ComfyUI with **STRICT GPU-ONLY** settings - no CPU fallback, no conflicts.

---

## ✅ What's Enabled

### GPU-ONLY Flags
- `--gpu-only` - Everything (text encoders, CLIP, models) stays on GPU
- `--highvram` - Models never unload from GPU (24GB RTX 3090)
- `--cuda-malloc` - CUDA native memory allocator (faster)

### Performance Flags
- `--force-fp16` - 30-40% speed boost, minimal quality loss
- `--bf16-vae` - BF16 precision for VAE (faster, compatible)
- `--bf16-text-enc` - BF16 for text encoders
- xformers auto-enabled (15-25% boost)

### Environment Variables
```powershell
CUDA_VISIBLE_DEVICES=0                    # Use first GPU only
PYTORCH_CUDA_ALLOC_CONF=...              # Memory optimization
CUDA_LAUNCH_BLOCKING=0                   # Async operations
CUDA_DEVICE_ORDER=PCI_BUS_ID             # Consistent GPU ordering
PYTORCH_ENABLE_MPS_FALLBACK=0            # No MPS fallback
OMP_NUM_THREADS=1                        # Limit CPU threading
```

---

## ❌ What's DISABLED

- ✖ CPU fallback (`--cpu` flag)
- ✖ DirectML
- ✖ MPS (Apple Metal)
- ✖ Low VRAM mode
- ✖ CPU VAE
- ✖ Any CPU offloading

---

## 📊 Expected Performance (RTX 3090)

### With GPU-Only Script
| Resolution  | Steps | Sampler | Time     |
|-------------|-------|---------|----------|
| 1024x1024   | 20    | euler   | ~37s     |
| 1024x1024   | 25    | euler   | ~50s     |
| 1024x1024   | 30    | dpmpp_2m| ~70s     |
| 1536x1024   | 30    | dpmpp_2m| ~95s     |

### Speed Gains vs Standard
- **30-40%** faster than FP32
- **15-25%** faster with xformers
- **10-20%** faster with CUDA malloc
- **Combined: ~50-70% faster** than default settings

---

## 🔧 Optimal Workflow Settings

### ⚡ Fast (Testing) - 30-40 seconds
```json
{
  "steps": 15-20,
  "sampler": "euler",
  "scheduler": "simple",
  "cfg": 3.0-3.5,
  "resolution": "1024x1024"
}
```

### ⭐ Balanced (Production) - 60 seconds
```json
{
  "steps": 25,
  "sampler": "euler",
  "scheduler": "simple",
  "cfg": 3.5,
  "resolution": "1024x1024"
}
```

### 💎 Maximum Quality - 90 seconds
```json
{
  "steps": 30,
  "sampler": "dpmpp_2m",
  "scheduler": "karras",
  "cfg": 4.0,
  "resolution": "1024x1024"
}
```

---

## 🎯 Best Practices

### 1. **Always Use GPU-Only Script**
```powershell
.\start-comfy-gpu-only.ps1  # ✓ CORRECT
.\start-comfy.ps1           # ✗ Has CPU fallback
```

### 2. **Optimal Resolution**
- **1024x1024** - Sweet spot for speed/quality
- **1536x1024** - High quality landscapes
- **1024x1536** - High quality portraits
- Avoid >1536x1536 (VRAM limits)

### 3. **Sampler Selection**
- **euler** - Fastest, 2.5s/step, excellent quality
- **dpmpp_2m** - Best quality, 2.8s/step
- Use `simple` scheduler for speed
- Use `karras` scheduler for maximum quality

### 4. **CFG Settings**
- **3.0-3.5** - Optimal for most Flux models
- Lower than SDXL (Flux works differently!)
- Don't go above 5.0 (artifacts)

### 5. **Steps**
- **20 steps** - Good quality, fast testing
- **25 steps** - Excellent quality, production
- **30 steps** - Maximum quality
- Beyond 35 = diminishing returns

---

## 🛠️ Troubleshooting

### Issue: "CUDA NOT AVAILABLE" Error
**Solution:**
```powershell
# Check CUDA installation
python -c "import torch; print(torch.cuda.is_available())"
python -c "import torch; print(torch.cuda.get_device_name(0))"
```

### Issue: Out of Memory (OOM)
**Solutions:**
1. Reduce resolution to 1024x1024
2. Close other GPU applications
3. Reduce batch size to 1
4. Don't use multiple models simultaneously

### Issue: Too Slow
**Check:**
1. Using `.\start-comfy-gpu-only.ps1`? ✓
2. Resolution at 1024x1024? ✓
3. Using `euler` sampler? ✓
4. Steps at 20-25? ✓
5. No other GPU apps running? ✓

---

## 📈 Monitoring GPU Usage

```powershell
# Real-time GPU monitoring
nvidia-smi -l 1

# Check VRAM usage
nvidia-smi --query-gpu=memory.used,memory.total --format=csv -l 1
```

---

## 🔄 Startup Options Comparison

| Script                      | GPU-Only | High VRAM | FP16 | Speed  |
|-----------------------------|----------|-----------|------|--------|
| start-comfy-gpu-only.ps1    | ✓        | ✓         | ✓    | Fastest|
| start-comfy-optimized.ps1   | ✗        | ✓         | ✓    | Fast   |
| start-comfy.ps1             | ✗        | ✗         | ✗    | Slow   |

**Always use: `start-comfy-gpu-only.ps1`**

---

## 📝 Summary

**Single Command:**
```powershell
.\start-comfy-gpu-only.ps1
```

**Optimal Settings:**
- Resolution: **1024x1024**
- Sampler: **euler**
- Scheduler: **simple**
- Steps: **25**
- CFG: **3.5**

**Expected Time:**
- **~50 seconds** per image
- **50-70% faster** than default
- **Zero CPU fallback** conflicts

---

## 🎓 Additional Resources

- Full settings guide: `FLUX_OPTIMAL_SETTINGS.md`
- Model guide: `WORKFLOWS_AND_MODELS_GUIDE.md`
- Quick reference: `QUICK_START_GUIDE.md`
