# Custom Nodes Conflict Analysis

## Status Summary

**Total Custom Nodes Installed:** 24
**Currently Enabled:** 16
**Currently Disabled:** 8

## Disabled Nodes (in .disabled_nodes.txt)

1. **ComfyUI-Crystools** - System monitoring and performance tools
2. **ComfyUI-GGUF** - GGUF format model loader (using SafeTensors instead)
3. **ComfyUI-Impact-Pack** - Advanced impact analysis nodes
4. **ComfyUI-IPAdapter-Flux** - IP-Adapter for Flux models
5. **ComfyUI-KJNodes** - KJ's custom node suite
6. **ComfyUI-Lora-Manager** - LoRA management (rgthree-comfy handles this)
7. **ComfyUI-TeaCache** - Caching optimization
8. **comfyui_controlnet_aux** - ControlNet auxiliary tools

---

## Enabled Nodes & Functionality

### GPU/VRAM Monitoring
- **ComfyUI_essentials** - Contains `cleanGpuUsed` node (GPU memory clearing)
- **efficiency-nodes-comfyui** - May have monitoring features

### Model Loading & Control
- **x-flux-comfyui** - Flux model support (primary)
- **ComfyUI-Advanced-ControlNet** - ControlNet for guided generation
- **ComfyUI_IPAdapter_plus** - IP-Adapter variant

### Inpainting & Image Processing
- **ComfyUI_UltimateSDUpscale** - Image upscaling
- **ComfyUI_tinyterraNodes** - Image processing utilities
- **comfyui-inpaint-nodes** - Inpainting capability
- **ComfyUI-TiledDiffusion** - Large image processing

### Workflow & Utility
- **rgthree-comfy** - Power LoRA loader & workflow utilities (RECOMMENDED TO KEEP)
- **ComfyUI_Comfyroll_CustomNodes** - Template & workflow nodes
- **ComfyUI-Manager** - Node/extension manager
- **ComfyUI-Custom-Scripts** - Custom execution scripts
- **cg-use-everywhere** - Connection workflow utilities

### LLM Integration
- **comfyui-llm-prompt-enhancer** - Prompt enhancement via LLM

---

## Known Conflicts & Issues

### MAJOR CONFLICT: LoRA Loading
- **ComfyUI-Lora-Manager** (DISABLED) - Full LoRA management
- **rgthree-comfy** (ENABLED) - Power LoRA Loader + workflow tools
- **Resolution:** Disabled ComfyUI-Lora-Manager, keeping rgthree-comfy ✓

### CONFLICT: GPU Monitoring
- **ComfyUI-Crystools** (DISABLED) - Full GPU/CPU monitoring dashboard
- **ComfyUI_essentials** (ENABLED) - Has cleanGpuUsed node
- **Issue:** You wanted GPU/CPU monitoring visible. ComfyUI_essentials has cleanup but not live monitoring
- **Action Needed:** May need to re-enable ComfyUI-Crystools OR find alternative monitoring

### CONFLICT: ControlNet Implementations
- **ComfyUI-Advanced-ControlNet** (ENABLED)
- **comfyui_controlnet_aux** (DISABLED)
- **ComfyUI_IPAdapter_plus** (ENABLED) + **ComfyUI-IPAdapter-Flux** (DISABLED)
- **Resolution:** Kept Advanced version, disabled aux and Flux variant

### CONFLICT: Caching/Optimization
- **ComfyUI-TeaCache** (DISABLED)
- **efficiency-nodes-comfyui** (ENABLED)
- **Resolution:** efficiency-nodes handles optimization, TeaCache disabled

---

## Recommendation: Minimal Optimized Setup

### CRITICAL (Must Keep)
1. **x-flux-comfyui** - Core Flux model support
2. **rgthree-comfy** - LoRA loading and workflow tools
3. **ComfyUI-Manager** - Node management

### HIGHLY RECOMMENDED (Keep)
4. **ComfyUI_essentials** - GPU memory management + useful utilities
5. **efficiency-nodes-comfyui** - Performance optimization
6. **ComfyUI-Advanced-ControlNet** - Guided image generation

### OPTIONAL (Use if needed)
7. **ComfyUI_Comfyroll_CustomNodes** - Templates & quick workflows
8. **was-node-suite-comfyui** - WAS node utilities
9. **ComfyUI-TiledDiffusion** - For large images
10. **comfyui-inpaint-nodes** - For inpainting work

### OPTIONAL (Rarely Used)
11. **ComfyUI_tinyterraNodes** - Extra image processing
12. **ComfyUI_IPAdapter_plus** - Advanced IP-Adapter
13. **cg-use-everywhere** - Advanced connectivity
14. **comfyui-llm-prompt-enhancer** - LLM prompt enhancement
15. **ComfyUI_UltimateSDUpscale** - Advanced upscaling

---

## GPU/CPU Monitoring Issue

**Problem:** You liked seeing GPU/CPU usage during generation
**Current Situation:**
- ComfyUI-Crystools (disabled) had full monitoring
- ComfyUI_essentials has `cleanGpuUsed` for memory cleanup
- No live GPU/CPU monitoring currently visible

**Options:**
1. **Re-enable ComfyUI-Crystools** - Full GPU/CPU dashboard
2. **Use system-level monitoring** - Task Manager / GPU-Z in background
3. **Check ComfyUI system_stats endpoint** - Get real-time VRAM usage via API

---

## Recommended Actions

1. **Add back GPU monitoring:** Re-enable ComfyUI-Crystools for the dashboard you liked
2. **Remove unused nodes:** Disable efficiency-nodes-comfyui if you don't need it
3. **Clean up redundant nodes:** Remove was-node-suite if not actively using
4. **Test minimal setup:** Start with critical + recommended nodes

Would you like me to implement these changes?
