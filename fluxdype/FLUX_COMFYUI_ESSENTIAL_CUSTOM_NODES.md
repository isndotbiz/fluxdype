# Essential ComfyUI Custom Nodes for Flux 2.0 Dev - Comprehensive Guide

**Last Updated:** December 2024
**Target Model:** Flux 2.0 Dev / Flux.1 Dev
**Platform:** ComfyUI

---

## Table of Contents

1. [Quick Start - Must Install First](#1-comfyui-manager-must-install-first)
2. [Flux-Specific Custom Nodes](#flux-specific-custom-nodes)
3. [Quality Enhancement & Upscaling Nodes](#quality-enhancement--upscaling-nodes)
4. [Workflow Management & Efficiency](#workflow-management--efficiency)
5. [Prompt Enhancement Nodes](#prompt-enhancement-nodes)
6. [Speed Optimization & VRAM Management](#speed-optimization--vram-management)
7. [Essential Utility Nodes](#essential-utility-nodes)
8. [Advanced Features & Style Control](#advanced-features--style-control)
9. [Installation Best Practices](#installation-best-practices)
10. [Performance Recommendations](#performance-recommendations)

---

## 1. ComfyUI Manager (MUST INSTALL FIRST)

**Priority:** CRITICAL - Install this before anything else

### Overview
ComfyUI Manager is the essential extension for managing all other custom nodes. It has officially joined the Comfy Org organization and is now part of ComfyUI's core dependencies. When you load a workflow with missing dependencies, Manager automatically detects them and offers one-click installation.

### GitHub Repository
- **URL:** https://github.com/Comfy-Org/ComfyUI-Manager
- **Original Developer:** Dr.Lt.Data (ltdrdata)
- **Status:** Actively maintained (V3.38 as of Dec 2024)

### Installation

**Standard Installation (Git Clone):**
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager
# Restart ComfyUI
```

**Windows Portable Version:**
1. Download `scripts/install-manager-for-portable-version.bat` into your `ComfyUI_windows_portable` directory
2. Right-click and choose 'Save As...'
3. Double-click the batch file to install

**Linux with venv:**
```bash
# Download scripts/install-comfyui-venv-linux.sh into empty install directory
./install-comfyui-venv-linux.sh
```

### Key Features
- One-click installation of custom nodes
- Automatic dependency detection and installation
- Search and browse custom node marketplace
- Update management for all installed nodes
- Workflow sharing and import
- Missing node detection when loading workflows

### Recent Updates (2024)
- V3.38: Security patch - Manager data migrated to protected path
- V3.16: Support for uv package manager added (set `use_uv` in config.ini)

### Why Essential
This is the foundation for everything else. Without ComfyUI Manager, installing and managing custom nodes becomes tedious and error-prone. It saves hours of manual configuration.

---

## Flux-Specific Custom Nodes

### 2. ComfyUI-GGUF (Low VRAM Support)

**Priority:** HIGH (Essential for GPUs with <24GB VRAM)

### Overview
Enables GGUF quantization support for Flux models, allowing them to run on low-end GPUs with significantly reduced VRAM usage. GGUF quantization was popularized by llama.cpp and works well with transformer/DiT models like Flux.

### GitHub Repository
- **URL:** https://github.com/city96/ComfyUI-GGUF
- **Developer:** city96
- **Status:** Actively maintained

### Installation

**Standard Installation:**
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/city96/ComfyUI-GGUF
.\venv\Scripts\Activate.ps1
pip install --upgrade gguf
```

**Standalone/Portable:**
```powershell
git clone https://github.com/city96/ComfyUI-GGUF ComfyUI/custom_nodes/ComfyUI-GGUF
.\python_embeded\python.exe -s -m pip install -r .\ComfyUI\custom_nodes\ComfyUI-GGUF\requirements.txt
```

### Usage
1. Use the "GGUF Unet loader" found under the "bootleg" category
2. Place `.gguf` model files in `ComfyUI/models/unet/` folder
3. Pre-quantized Flux models available at: https://huggingface.co/city96/FLUX.1-dev-gguf

### VRAM Savings
- **FP16:** Baseline (24GB VRAM)
- **FP8 (e4m3fn):** 50% reduction (12GB VRAM)
- **Q8_0:** ~50% reduction
- **Q6_K:** ~62% reduction
- **Q5_K_M:** ~69% reduction
- **Q4_K_M:** ~75% reduction
- **Q4_K_S:** ~75% reduction (slightly lower quality)

### Why Essential
Critical for running Flux Dev on mid-range GPUs (RTX 3090, RTX 4070, etc.). Enables 4-bit quantization with minimal quality loss while dramatically reducing VRAM requirements.

---

### 3. ComfyUI-Fluxpromptenhancer

**Priority:** HIGH

### Overview
Transforms short, simple prompts into detailed, descriptive prompts specifically optimized for Flux models. Uses the Flux-Prompt-Enhance model trained for this specific task.

### GitHub Repository
- **URL:** https://github.com/marduk191/ComfyUI-Fluxpromptenhancer
- **Developer:** marduk191
- **Status:** Active

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/marduk191/ComfyUI-Fluxpromptenhancer
```

### Key Features
- Token Limitation: Optimized for up to 256 tokens
- Uses pre-trained Flux-Prompt-Enhance model
- Context-aware expansion of prompts
- Direct integration into ComfyUI workflows
- No API keys required (local model)

### Usage
1. Add the "Flux Prompt Enhance" node to your workflow
2. Connect your simple prompt as input
3. Enhanced prompt automatically generated
4. Connect enhanced prompt to your Flux sampler

### Example
- **Input:** "a beautiful woman"
- **Output:** "A stunning portrait of an elegant woman with flowing auburn hair, soft ambient lighting, professional photography, detailed facial features, warm color palette, bokeh background, high resolution"

### Why Recommended
Flux models benefit significantly from detailed prompts. This node automates prompt enhancement without requiring external LLM APIs, keeping everything local and fast.

---

### 4. ControlAltAI-Nodes (Flux Sampler)

**Priority:** MEDIUM-HIGH

### Overview
Quality-of-life nodes from ControlAltAI that streamline Flux workflows. The Flux Sampler node combines functionality of CustomSamplerAdvance and input nodes into a single streamlined node.

### GitHub Repository
- **URL:** https://github.com/gseth/ControlAltAI-Nodes
- **Developer:** gseth (ControlAltAI)
- **Status:** Active

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/gseth/ControlAltAI-Nodes
```

### Key Features
- Flux Sampler: All-in-one sampling node for Flux
- Only includes samplers/schedulers compatible with Flux
- Reduces workflow complexity
- Streamlined parameter management

### Why Recommended
Reduces node clutter and simplifies Flux-specific workflows. Makes it easier to manage sampling parameters without dealing with multiple connection nodes.

---

### 5. ComfyUI-PuLID-Flux (Face Consistency)

**Priority:** MEDIUM (Essential for character work)

### Overview
Implementation of PuLID-Flux for face consistency and character preservation across generations. Supports TeaCache for speed optimization and includes commercial-friendly FaceNet implementation.

### GitHub Repository
- **URL:** https://github.com/lldacing/ComfyUI_PuLID_Flux_ll
- **Developer:** lldacing
- **Status:** Actively maintained (Jan 2025 updates)

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/lldacing/ComfyUI_PuLID_Flux_ll.git
cd ComfyUI_PuLID_Flux_ll
pip install -r requirements.txt
pip install facenet-pytorch --no-deps
```

**IMPORTANT:** Uninstall any other PuLID-Flux implementations before installing this version to avoid conflicts.

### Key Features
- Face consistency across multiple generations
- Commercial-friendly FaceNet alternative (no InsightFace licensing issues)
- TeaCache support for 1.2x-1.7x speed improvement
- Works with ComfyUI_Patches_ll for enhanced functionality
- No model pollution

### Usage with TeaCache
1. Must be placed BEFORE FluxForwardOverrider and ApplyTeaCachePatch nodes
2. Link AFTER ApplyPulidFlux node
3. Link FluxForwardOverrider and ApplyTeaCachePatch AFTER this node

### Why Recommended
Essential for character consistency, portrait work, and any project requiring the same face across multiple images. The commercial-friendly license is a major advantage over alternatives.

---

### 6. ComfyUI_Patches_ll (Advanced Flux Patches)

**Priority:** MEDIUM

### Overview
Provides patches and hooks for Flux, HunYuanVideo, LTXVideo, and other models. Supports TeaCache, PuLID, and First Block Cache for performance optimization.

### GitHub Repository
- **URL:** https://github.com/lldacing/ComfyUI_Patches_ll
- **Developer:** lldacing
- **Status:** Active

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/lldacing/ComfyUI_Patches_ll
```

### Key Features
- TeaCache support for multiple models
- First Block Cache for additional speed
- PuLID-Flux integration
- No model pollution
- Supports multiple video models

### Why Recommended
Required for optimal PuLID-Flux performance and enables advanced caching strategies. Essential companion to ComfyUI-PuLID-Flux.

---

### 7. ComfyUI_FluxMod

**Priority:** LOW-MEDIUM (For experimental users)

### Overview
Nodes for use with Chroma model and other Flux prototype models. For users who want to experiment with cutting-edge Flux variants.

### Key Features
- Chroma model support
- Experimental Flux variants
- Prototype model compatibility

### Why Recommended
Only if you're working with experimental Flux models or prototypes. Not needed for standard Flux Dev/Schnell workflows.

---

## Quality Enhancement & Upscaling Nodes

### 8. ComfyUI_UltimateSDUpscale (Tiled Upscaling)

**Priority:** HIGH

### Overview
The standard for high-quality upscaling in ComfyUI. Uses tiled sampling to upscale images to 4K, 8K, 16K, and beyond without running out of VRAM.

### GitHub Repository
- **URL:** https://github.com/ssitu/ComfyUI_UltimateSDUpscale
- **Developer:** ssitu
- **Status:** Actively maintained

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale --recursive
```

### Three Main Nodes

1. **Ultimate SD Upscale**
   - Primary upscaling node
   - Handles scaling and tiled diffusion
   - Recommended upscaler: ESRGAN (photorealistic), R-ESRGAN 4x+ (others)

2. **Ultimate SD Upscale (No Upscale)**
   - For pre-upscaled images
   - Tiled sampling only
   - Detail enhancement without resizing

3. **Ultimate SD Upscale (Custom Sample)**
   - Custom samplers and sigma values
   - Advanced fine-tuning
   - Expert-level control

### Recommended Upscale Models
- **4xUltraSharp:** Best for general use
- **ESRGAN:** Best for photorealistic images
- **R-ESRGAN 4x+:** Best for artwork/anime
- **RealESRGAN:** Good balance for all content types

### Usage Tips
- Tile size: 512x512 for 8GB VRAM, 768x768 for 12GB+, 1024x1024 for 24GB+
- Tile overlap: 64-128 pixels recommended
- Denoise strength: 0.2-0.4 for detail enhancement, 0.5-0.7 for creative upscaling

### Why Essential
Industry-standard upscaling solution. Enables high-resolution outputs (4K-16K+) on consumer GPUs through intelligent tiling.

---

### 9. ComfyUI-TiledDiffusion (MultiDiffusion)

**Priority:** MEDIUM-HIGH

### Overview
Enables large image generation and upscaling with limited VRAM using Tiled Diffusion, MultiDiffusion, and Mixture of Diffusers techniques.

### GitHub Repository
- **URL:** https://github.com/shiimizu/ComfyUI-TiledDiffusion
- **Developer:** shiimizu
- **Status:** Active

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/shiimizu/ComfyUI-TiledDiffusion
```

### Key Features
- Tiled Diffusion for large images
- MultiDiffusion for seamless tiling
- Mixture of Diffusers for regional prompting
- Optimized VAE encoding/decoding
- VRAM-efficient processing

### Why Recommended
Complements Ultimate SD Upscale with additional tiling strategies. Excellent for panoramas, ultra-wide images, and regional control.

---

### 10. Comfyui_TTP_Toolset (Tile Processing)

**Priority:** MEDIUM

### Overview
Advanced tile processing toolset for face restoration and 4K upscaling. Specifically designed to fix distorted faces during upscaling.

### GitHub Repository
- **URL:** https://github.com/TTPlanetPig/Comfyui_TTP_Toolset
- **Developer:** TTPlanetPig
- **Status:** Active

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/TTPlanetPig/Comfyui_TTP_Toolset
```

### Key Features
- TTP Tile Face Restoration
- 4K upscaling workflows
- ControlNet Tile integration
- Fixes common face distortion issues
- Maintains facial features during upscaling

### Why Recommended
Solves the common problem of face distortion during aggressive upscaling. Essential for portrait and character work at high resolutions.

---

### 11. Flux ControlNet Upscaler

**Priority:** MEDIUM-HIGH

### Overview
Specialized ControlNet model for Flux that intelligently upscales images using ControlNet technology. Developed by Jasper AI.

### Key Features
- ControlNet-based upscaling
- Designed specifically for Flux Dev
- Can upscale from 320x192 to 1280x768 (4x)
- Reduces noise while enhancing definition
- Maintains structural coherence

### Model Download
- Available on HuggingFace: Jasper Research Flux Dev ControlNet Upscaler
- License: Non-commercial use only
- Place in: `ComfyUI/models/controlnet/`

### Usage
1. Load base Flux Dev model
2. Add ControlNet Upscaler model
3. Set ControlNet strength: 0.6-0.9
4. Use with Ultimate SD Upscale for best results

### Why Recommended
Flux-specific upscaling provides better results than generic upscalers. ControlNet guidance maintains image coherence during scaling.

---

## Workflow Management & Efficiency

### 12. Efficiency Nodes for ComfyUI

**Priority:** HIGH

### Overview
Combines multiple common operations into single efficient nodes, significantly reducing workflow clutter and improving performance. Essential for professional workflows.

### GitHub Repository
- **URL:** https://github.com/jags111/efficiency-nodes-comfyui
- **Developer:** jags111 (fork of LucianoCirino's original)
- **Status:** Actively maintained

**Note:** The original repository by LucianoCirino is no longer maintained. Use the jags111 fork.

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/jags111/efficiency-nodes-comfyui
```

### Key Nodes

1. **Efficient Loaders**
   - Load & cache Checkpoint, VAE, & LoRA models
   - Apply LoRA & ControlNet stacks
   - Cache settings in `node_settings.json`
   - Reduces reload times

2. **Efficient KSamplers**
   - Live preview during generation
   - Automatic VAE decode
   - Special seed management box
   - Clearer seed control

3. **XY Plot Node**
   - Parameter grid plotting
   - A/B testing workflows
   - Batch comparison
   - Automated testing

4. **Image Overlay Node**
   - Direct image compositing
   - Mask-based blending
   - Quick previews

### Why Essential
Used by 75% of professional workflows. Reduces node count by 30-50% and improves workflow readability. The caching system dramatically speeds up iterative work.

---

### 13. WAS Node Suite

**Priority:** HIGH

### Overview
The most popular ComfyUI custom node pack with over 210 nodes for image processing, text manipulation, video handling, and workflow utilities.

### GitHub Repository
- **URL:** https://github.com/WASasquatch/was-node-suite-comfyui
- **Developer:** WASasquatch
- **Status:** Public archive (no longer actively maintained, but stable)

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/WASasquatch/was-node-suite-comfyui
pip install -r was-node-suite-comfyui/requirements.txt
```

**Note:** WAS Node Suite will attempt to install dependencies automatically, but manual installation may be needed.

### Key Features

1. **BLIP Analyze Image**
   - Get text captions from images
   - Image interrogation
   - Prompt generation from images

2. **Bus Node**
   - Condenses 5 common connectors into one
   - Includes: Model, CLIP, VAE, Positive Conditioning, Negative Conditioning
   - Keeps workspace tidy

3. **CLIPTextEncode (NSP)**
   - Parse noodle soup prompts
   - Wildcard support (A1111 style)
   - Dynamic prompt generation

4. **Video Nodes**
   - Write to Video
   - Create Video from Path
   - GIF creation
   - Experimental features

5. **Math & Logic Nodes**
   - Extensive math operations
   - Conditional logic
   - Variable manipulation

### Why Essential
Used by 90% of professional workflows. Provides essential utilities that fill gaps in ComfyUI's core functionality. Even though it's archived, it remains stable and widely used.

---

### 14. ComfyUI Essentials

**Priority:** MEDIUM-HIGH

### Overview
Essential nodes that are missing from ComfyUI core. Includes image transformations, masking, console debugging, and utility functions.

### GitHub Repository
- **URL:** https://github.com/cubiq/ComfyUI_essentials
- **Developer:** cubiq
- **Status:** Maintenance mode (as of April 14, 2025)

### Installation

**Git Clone Method (Recommended):**
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/cubiq/ComfyUI_essentials.git
```

**Important:** Manual git clone is recommended over ComfyUI Manager installation, as Manager may not install all nodes correctly.

### Key Modules
- Image processing utilities
- Sampling tools
- Conditioning helpers
- Masking operations
- Text manipulation
- Segmentation tools
- General utility functions
- Console debugging

### Notable Nodes
- SimpleMathSlider
- Image transformation suite
- Mask utilities
- Debug console output

### Why Recommended
Fills critical gaps in ComfyUI's core functionality. Even in maintenance mode, these nodes are stable and essential for advanced workflows.

---

### 15. rgthree's ComfyUI Nodes

**Priority:** MEDIUM

### Overview
Quality-of-life nodes focused on workflow organization and complex workflow management.

### Key Nodes
- **Seed:** Advanced seed management
- **Reroute:** Clean cable management
- **Context:** Context passing for complex workflows
- **Lora Loader Stack:** Stack multiple LoRAs
- **Context Switch:** Conditional workflow branching
- **Fast Muter:** Quick node muting

### Why Recommended
Essential for building complex, maintainable workflows. The context and reroute nodes dramatically improve workflow readability.

---

## Prompt Enhancement Nodes

### 16. ComfyUI-LLM-Prompt-Enhancer

**Priority:** MEDIUM-HIGH

### Overview
Advanced prompt enhancement using various LLMs (GPT-4, Claude, Gemini, Ollama). Provides 50+ artistic styles and intelligent prompt expansion.

### GitHub Repository
- **URL:** https://github.com/pinkpixel-dev/comfyui-llm-prompt-enhancer
- **Developer:** pinkpixel-dev
- **Status:** Active

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/pinkpixel-dev/comfyui-llm-prompt-enhancer
```

### Supported LLM Providers
- **OpenAI:** GPT-4 Turbo Preview
- **Anthropic:** Claude 3.5 Sonnet
- **Google:** Gemini Pro
- **OpenRouter:** Multiple models
- **Ollama:** Local LLM support (no API key required)

### Key Features
- 50+ enhancement styles organized by category
- Seamless integration with Flux and SDXL
- Local LLM support via Ollama (privacy-friendly)
- Multiple API provider support
- Style-specific enhancements

### Enhancement Categories
- Photorealistic
- Artistic styles
- Cinematic
- Fantasy
- Sci-fi
- Abstract
- Architecture
- Product photography
- And more...

### Why Recommended
More powerful than Flux-Prompt-Enhancer for users who want maximum control and variety. Local Ollama support means no API costs and complete privacy.

---

## Speed Optimization & VRAM Management

### 17. ComfyUI-TeaCache (Speed Boost)

**Priority:** HIGH

### Overview
Caching node extension that caches internal processes for significant speed improvements in repeated operations. Works with Flux, PuLID-Flux, and video models.

### GitHub Repository
- **URL:** https://github.com/CheungPuiKwan/ComfyUI-TeaCache
- **Also:** https://github.com/welltop-cn/ComfyUI-TeaCache (alternative version)
- **Status:** Actively maintained (Jan 2025 updates)

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/welltop-cn/ComfyUI-TeaCache.git
```

### Performance Improvements
- **PuLID-Flux:** 1.2x lossless, 1.7x with minor quality loss
- **Flux Dev:** 1.5x to 3x speedup with acceptable quality loss
- **General sampling:** 30-50% speed increase

### Supported Models
- Flux Dev / Schnell
- PuLID-Flux (requires ComfyUI_Patches_ll)
- HunYuanVideo
- LTXVideo
- MochiVideo

### Usage
1. Add TeaCache node before sampler
2. Configure cache settings (steps to cache)
3. Run first generation (cache building)
4. Subsequent generations use cached results

### Best Practices
- Use for batch generation with similar prompts
- Best results with 20+ sampling steps
- Clear cache when changing styles significantly
- Combine with other optimization methods

### Why Essential
Dramatic speed improvements with minimal quality loss. Essential for production workflows and batch generation.

---

### 18. ComfyUI Flux Accelerator

**Priority:** HIGH

### Overview
Custom node designed to enhance Flux.1 generation speed by up to 37.25% using quantization and model compilation techniques.

### Key Features
- Uses torchao and torch.compile()
- Quantizes models to float8/int8
- Compiles models for faster execution
- Transformer Block skipping option
- Up to 37.25% speed increase

### Optimization Methods
1. **Model Quantization**
   - Float8 (e4m3fn) quantization
   - Int8 quantization
   - Reduces computational load

2. **Model Compilation**
   - torch.compile() integration
   - JIT compilation for critical paths
   - CUDA kernel optimization

3. **Block Skipping**
   - Skip certain Transformer Blocks
   - Direct speed increase
   - Configurable skip pattern

### Performance Results
- **Default Flux Dev:** Baseline
- **With Accelerator (no block skip):** +25% speed
- **With Accelerator + block skip:** +37.25% speed
- **With TeaCache + Accelerator:** +67% speed (combined)

### Combined Optimization Stack
- TeaCache + Flux Accelerator + KJNodes: 67% speed improvement
- TeaCache + FLUX.1-Turbo-Alpha: High quality + speed
- Flux Accelerator + FP8 model: 50% VRAM reduction + 25% speed boost

### Why Essential
Significant speed improvements without quality degradation. Combines well with other optimization methods for maximum performance.

---

### 19. ComfyUI-ModelQuantizer

**Priority:** MEDIUM

### Overview
Tools for quantizing model weights to lower precision formats (FP16, BF16, FP8) directly in ComfyUI.

### GitHub Repository
- **URL:** https://github.com/ComfyNodePRs/PR-ComfyUI-ModelQuantizer-e24f57d0

### Supported Formats
- **FP16:** Half precision
- **BF16:** Brain float 16
- **Float8_e4m3fn:** FP8 (3-bit mantissa)
- **Float8_e5m2:** FP8 (2-bit mantissa)

### VRAM Savings
- **FP16:** Baseline
- **BF16:** Same size, better range
- **FP8 (e4m3fn):** 50% reduction
- **FP8 (e5m2):** 50% reduction (different precision trade-off)

### Usage
1. Load your model
2. Select target quantization format
3. Quantize and save
4. Use quantized model in workflows

### Why Recommended
Allows on-the-fly quantization without external tools. Useful for testing different quantization levels and creating optimized models for your specific GPU.

---

### 20. Wavespeed / MagCache (Alternative Caching)

**Priority:** LOW-MEDIUM

### Overview
Alternative caching solutions to TeaCache with different performance characteristics.

### Wavespeed
- Similar functionality to TeaCache
- Different caching strategy
- May work better for certain workflows

### MagCache
- Faster than TeaCache (3.96s vs 4.98s in tests)
- May not denoise properly at recommended settings
- Requires careful configuration

### Why Listed
Some users report better results with these alternatives depending on their specific setup and workflows. Worth testing if TeaCache doesn't meet your needs.

---

## Essential Utility Nodes

### 21. ComfyUI-Impact-Pack (Face Enhancement)

**Priority:** HIGH (Essential for portrait work)

### Overview
Comprehensive custom node pack for image enhancement through Detector, Detailer, Upscaler, and Pipe systems. Particularly renowned for face enhancement capabilities.

### GitHub Repository
- **URL:** https://github.com/ltdrdata/ComfyUI-Impact-Pack
- **Developer:** Dr.Lt.Data (ltdrdata)
- **Status:** Actively maintained

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack
```

Or install via ComfyUI-Manager: Search "ComfyUI Impact Pack" and click Install.

### Key Nodes for Face Enhancement

1. **FaceDetailer**
   - Combination of face detection + image enhancement
   - Automatically detects faces
   - Generates high-resolution face details
   - Synthesizes enhanced faces back into image
   - Provides MASK output for visualization

2. **FaceDetailer (pipe)**
   - Easy face detection and improvement
   - Designed for multipass enhancement
   - Pipeline-based workflow

3. **Detector Nodes**
   - Multiple detection models supported
   - Configurable detection thresholds
   - Face, person, hand detection

4. **Detailer Nodes**
   - High-resolution detail generation
   - Automatic face restoration
   - Configurable enhancement strength

### Additional Requirements
- **ComfyUI-Impact-Subpack:** For UltralyticsDetectorProvider node
- Detection models: Download to `ComfyUI/models/` (automatic via Manager)

### Face Enhancement Workflow
1. Generate base image with Flux
2. Detect faces using FaceDetailer
3. Enhance faces at higher resolution
4. Composite enhanced faces back
5. Optional: Multiple passes for extreme detail

### Why Essential
Used by 85% of professional portrait workflows. Solves the common problem of low-quality faces in AI-generated images. Automatic detection and enhancement saves massive amounts of manual work.

---

## Advanced Features & Style Control

### 22. ComfyUI_IPAdapter_plus (Style Transfer)

**Priority:** HIGH (Essential for style work)

### Overview
Reference implementation for IPAdapter models, enabling powerful image-to-image conditioning for style transfer and consistency.

### GitHub Repository
- **URL:** https://github.com/cubiq/ComfyUI_IPAdapter_plus
- **Developer:** cubiq
- **Status:** Maintenance mode (as of April 14, 2025)

**Note:** Repository is in maintenance mode as developer no longer uses ComfyUI as primary tool, but remains functional and widely used.

### Installation
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus
```

### Required Models
Download and place in `ComfyUI/models/` subdirectories:

1. **IPAdapter Models** → `models/ipadapter/`
   - Available on HuggingFace
   - Multiple variants for different use cases

2. **CLIP Vision Encoders** → `models/clip_vision/`
   - CLIP-ViT-H-14-laion2B-s32B-b79K
   - CLIP-ViT-bigG-14-laion2B-39B-b160k

### Key Features
- **Style Transfer:** Transfer style from reference images
- **Subject Consistency:** Maintain subject across generations
- **Image Conditioning:** Use reference images to guide generation
- **Mask Support:** Regional style application
- **Multiple Image Inputs:** Blend styles from multiple references

### Integration with Other Nodes
- **Works excellently with ControlNet:** Structure from ControlNet + Style from IPAdapter
- **Combines with Face Detailers:** Professional face enhancement + style transfer
- **Ultimate SD Upscale:** Apply style during upscaling process

### Common Use Cases
1. **Character Consistency**
   - Maintain same character across multiple images
   - Different poses, same appearance

2. **Style Matching**
   - Match art style from reference
   - Apply specific aesthetic

3. **Brand Consistency**
   - Maintain visual brand across assets
   - Consistent color palette and style

4. **Creative Variations**
   - Generate variations with consistent feel
   - Explore creative directions

### Why Essential
IPAdapter is revolutionary for maintaining consistency and achieving specific styles. When combined with ControlNet and prompt control, it provides unprecedented creative control. Used by 80% of professional workflows requiring style consistency.

---

### 23. ComfyUI-Advanced-ControlNet

**Priority:** MEDIUM-HIGH

### Overview
Advanced ControlNet implementation with additional features and controls beyond the base ComfyUI ControlNet support.

### Key Features
- Multiple ControlNet stacking
- Advanced weight scheduling
- Timestep range control
- Batch ControlNet processing
- Regional ControlNet application

### Common ControlNet Models for Flux
- **ControlNet Tile:** For upscaling and detail enhancement
- **ControlNet Depth:** Depth-guided generation
- **ControlNet Canny:** Edge-guided generation
- **ControlNet OpenPose:** Pose-guided generation

### Why Recommended
Essential for advanced control over generation. Particularly powerful when combined with IPAdapter for structure + style control.

---

### 24. MTB Nodes

**Priority:** MEDIUM

### Overview
Collection of utility nodes by Mel Massadian covering various image processing and utility functions.

### Key Features
- **Face Swap:** Identity transfer
- **Film Interpolation:** Frame interpolation for video
- **Latent Lerp:** Smooth latent blending
- **Bounding Box:** Region selection
- **Crop/Uncrop:** Smart cropping utilities
- **ImageBlur:** Various blur methods
- **Denoise:** Additional denoising options
- **ImageCompare:** Side-by-side comparison
- **Color Correct:** HSV color manipulation
- **Deglaze Image:** Remove AI "glaze" artifacts

### Why Recommended
Fills specific utility gaps. Face Swap and Film Interpolation are particularly useful for advanced workflows.

---

## Installation Best Practices

### Installation Order

1. **FIRST: ComfyUI Manager**
   - Install this before anything else
   - Enables easy installation of everything else

2. **SECOND: Core Utilities**
   - ComfyUI Essentials
   - WAS Node Suite
   - Efficiency Nodes

3. **THIRD: Flux Essentials**
   - ComfyUI-GGUF (if needed for VRAM)
   - ComfyUI-Fluxpromptenhancer
   - ControlAltAI-Nodes

4. **FOURTH: Quality Enhancement**
   - ComfyUI_UltimateSDUpscale
   - ComfyUI-Impact-Pack
   - ComfyUI-TiledDiffusion

5. **FIFTH: Advanced Features**
   - ComfyUI_IPAdapter_plus
   - ComfyUI-PuLID-Flux (if needed)
   - ComfyUI-Advanced-ControlNet

6. **SIXTH: Performance Optimization**
   - ComfyUI-TeaCache
   - ComfyUI Flux Accelerator
   - ComfyUI_Patches_ll

### General Installation Process

```powershell
# Navigate to custom nodes directory
cd D:\workspace\fluxdype\ComfyUI\custom_nodes

# Activate virtual environment
D:\workspace\fluxdype\venv\Scripts\Activate.ps1

# Clone repository
git clone <repository-url>

# Install requirements if present
cd <repository-name>
pip install -r requirements.txt

# Restart ComfyUI
# Then verify installation in ComfyUI UI
```

### Via ComfyUI Manager

1. Start ComfyUI
2. Click "Manager" button in UI
3. Click "Install Custom Nodes"
4. Search for desired node
5. Click "Install"
6. Restart ComfyUI when prompted

### Troubleshooting Installation Issues

**Missing Nodes After Installation:**
- Manually git clone instead of using Manager
- Check for error messages in console
- Verify requirements.txt was installed
- Restart ComfyUI completely

**Dependency Conflicts:**
- Create fresh virtual environment
- Install nodes one at a time
- Check for conflicting package versions
- Consult node's GitHub Issues page

**Performance Issues:**
- Don't install everything at once
- Test workflow performance after each addition
- Disable unused nodes in ComfyUI Manager
- Some nodes may conflict or slow down startup

---

## Performance Recommendations

### For RTX 3090 (24GB VRAM)

**Recommended Setup:**
- Flux Dev FP8 (native or GGUF Q8_0)
- TeaCache for speed
- Flux Accelerator
- Ultimate SD Upscale for quality
- Impact Pack for faces

**Expected Performance:**
- 512x512: 15-25 seconds (20 steps)
- 1024x1024: 45-90 seconds (20 steps)
- 2048x2048 (upscaled): 3-5 minutes

**Optimization Stack:**
```
Base: Flux Dev FP8 (12GB VRAM)
+ TeaCache: 1.5-2x speed improvement
+ Flux Accelerator: Additional 25% speed
+ Efficient Samplers: Reduced overhead
= Total: ~2-2.5x faster than baseline
```

### For RTX 4070/3080 (12GB VRAM)

**Recommended Setup:**
- Flux Dev GGUF Q5_K_M or Q6_K
- ComfyUI-GGUF loader
- TeaCache essential
- Tiled processing for upscaling

**Expected Performance:**
- 512x512: 20-35 seconds (20 steps)
- 1024x1024: 60-120 seconds (20 steps)
- Upscaling: Use tiling, 4-8 minutes for 2K

**Optimization Stack:**
```
Base: Flux Dev GGUF Q6_K (8GB VRAM)
+ TeaCache: 1.5-2x speed
+ Tiled processing: Enable 1024+ generation
= Usable performance with quality preservation
```

### For RTX 3060/4060 (8GB VRAM)

**Recommended Setup:**
- Flux Dev GGUF Q4_K_M or Q4_K_S
- ComfyUI-GGUF loader (essential)
- --lowvram flag
- Aggressive tiling for anything >512

**Expected Performance:**
- 512x512: 30-60 seconds (20 steps)
- 1024x1024: 2-4 minutes (with tiling)
- Limited upscaling capability

**Optimization Stack:**
```
Base: Flux Dev GGUF Q4_K_M (6GB VRAM)
+ --lowvram flag: Enable processing
+ TeaCache: 1.3-1.5x speed
+ Careful workflow design: Avoid VRAM spikes
= Functional but slower workflow
```

### Optimal Node Combinations

**Speed Focus:**
```
ComfyUI-GGUF (Q6_K or Q8_0)
+ TeaCache
+ Flux Accelerator
+ Efficiency Nodes (for caching)
+ Simple samplers (Euler A, 15-20 steps)
= Maximum speed with good quality
```

**Quality Focus:**
```
Flux Dev FP8 (or Q8_0)
+ Ultimate SD Upscale
+ ComfyUI-Impact-Pack (FaceDetailer)
+ IPAdapter Plus (style control)
+ ControlNet (structure control)
+ 25-35 sampling steps
= Maximum quality, slower generation
```

**Balanced Workflow:**
```
Flux Dev GGUF Q8_0
+ TeaCache
+ Ultimate SD Upscale (tiled)
+ Impact Pack (face enhancement)
+ Flux Prompt Enhancer
+ 20 steps Euler A
= Good speed, good quality
```

### VRAM Management Tips

1. **Model Loading:**
   - Use Efficient Loaders to cache models
   - Avoid reloading models unnecessarily
   - Unload unused models explicitly

2. **Tiling Strategy:**
   - 512px tiles for 8GB VRAM
   - 768px tiles for 12GB VRAM
   - 1024px tiles for 24GB VRAM

3. **Batch Size:**
   - Batch size 1 for <12GB VRAM
   - Batch size 2-4 for 24GB VRAM
   - Use sequential generation instead of batching if needed

4. **VAE Handling:**
   - Enable VAE tiling for large images
   - Use fp16 VAE on low VRAM systems
   - Decode in tiles for >2K images

---

## Workflow Examples

### Basic Flux Generation
```
Required Nodes:
- Flux Dev model loader
- CLIP Text Encode (prompt)
- KSampler
- VAE Decode
- Save Image

Optional Enhancements:
+ Flux Prompt Enhancer → Better prompts
+ Efficient KSampler → Caching + previews
```

### High-Quality Portrait
```
Base Generation:
- Flux Dev FP8/Q8_0
- Enhanced prompt (via Prompt Enhancer)
- 25 steps, Euler A
- 1024x1024 base

Enhancement Pipeline:
→ Ultimate SD Upscale (2K/4K)
→ Impact Pack FaceDetailer (face enhancement)
→ Optional: IPAdapter for style consistency
→ Save high-res output
```

### Batch Generation with Consistency
```
Setup:
- PuLID-Flux (face consistency)
- IPAdapter Plus (style consistency)
- TeaCache (speed for batch)
- Efficiency XY Plot (parameter sweep)

Workflow:
1. Set reference face (PuLID)
2. Set reference style (IPAdapter)
3. Define prompt variations
4. Enable TeaCache
5. Generate batch (2x-3x faster after first image)
```

### Ultra-Quality Upscale
```
Pipeline:
1. Generate 1024x1024 with Flux Dev FP8
2. First upscale pass: Ultimate SD Upscale → 2048x2048
3. Face enhancement: Impact Pack FaceDetailer
4. Second upscale pass: Ultimate SD Upscale → 4096x4096
5. Optional: ControlNet Tile for final details
6. Save final 4K/8K output
```

---

## Summary Table - Top 15 Essential Nodes

| Priority | Node Name | Primary Purpose | GitHub URL | VRAM Impact |
|----------|-----------|----------------|------------|-------------|
| 1 | ComfyUI Manager | Node management | https://github.com/ltdrdata/ComfyUI-Manager | Minimal |
| 2 | ComfyUI-GGUF | Low VRAM Flux support | https://github.com/city96/ComfyUI-GGUF | -50% to -75% |
| 3 | Ultimate SD Upscale | Tiled upscaling | https://github.com/ssitu/ComfyUI_UltimateSDUpscale | Varies |
| 4 | ComfyUI-Impact-Pack | Face enhancement | https://github.com/ltdrdata/ComfyUI-Impact-Pack | +10% |
| 5 | Efficiency Nodes | Workflow optimization | https://github.com/jags111/efficiency-nodes-comfyui | -5% |
| 6 | WAS Node Suite | General utilities | https://github.com/WASasquatch/was-node-suite-comfyui | Minimal |
| 7 | ComfyUI Essentials | Core utilities | https://github.com/cubiq/ComfyUI_essentials | Minimal |
| 8 | IPAdapter Plus | Style transfer | https://github.com/cubiq/ComfyUI_IPAdapter_plus | +15% |
| 9 | Flux Prompt Enhancer | Prompt enhancement | https://github.com/marduk191/ComfyUI-Fluxpromptenhancer | Minimal |
| 10 | ComfyUI-TeaCache | Speed optimization | https://github.com/welltop-cn/ComfyUI-TeaCache | Minimal |
| 11 | ComfyUI-TiledDiffusion | Large image generation | https://github.com/shiimizu/ComfyUI-TiledDiffusion | Varies |
| 12 | PuLID-Flux | Face consistency | https://github.com/lldacing/ComfyUI_PuLID_Flux_ll | +10% |
| 13 | ControlAltAI Nodes | Flux workflow QoL | https://github.com/gseth/ControlAltAI-Nodes | Minimal |
| 14 | LLM Prompt Enhancer | Advanced prompts | https://github.com/pinkpixel-dev/comfyui-llm-prompt-enhancer | Minimal |
| 15 | Flux Accelerator | Speed boost | Search in ComfyUI Manager | Minimal |

---

## Additional Resources

### Official Resources
- ComfyUI Wiki: https://comfyui-wiki.com
- ComfyUI Examples: https://comfyanonymous.github.io/ComfyUI_examples/flux/
- Comfy Org Blog: https://blog.comfy.org

### Community Resources
- Awesome ComfyUI List: https://github.com/ComfyUI-Workflow/awesome-comfyui
- RunComfy Node Directory: https://www.runcomfy.com/comfyui-nodes
- OpenArt Workflows: https://openart.ai (search "Flux ComfyUI")

### Model Resources
- HuggingFace Flux Models: https://huggingface.co/black-forest-labs
- GGUF Quantized Models: https://huggingface.co/city96/FLUX.1-dev-gguf
- ControlNet Models: https://huggingface.co/jasperai (Flux ControlNet)

### Learning Resources
- Stable Diffusion Art (ComfyUI tutorials): https://stable-diffusion-art.com
- Apatero ComfyUI Blog: https://apatero.com/blog
- ComfyUI Reddit: r/comfyui

---

## Notes for FluxDype Project

Based on your current setup in `D:\workspace\fluxdype`:

### Currently Installed
- ComfyUI (base installation)
- Flux Kria FP8 models
- Python 3.12+ venv
- CUDA 12.1 + PyTorch

### Recommended Immediate Installations

**For your RTX 3090 (24GB VRAM):**

1. **ComfyUI Manager** (Essential first step)
2. **Efficiency Nodes** (Improve workflow)
3. **WAS Node Suite** (General utilities)
4. **Ultimate SD Upscale** (Quality upscaling)
5. **ComfyUI-Impact-Pack** (Face enhancement)
6. **ComfyUI-TeaCache** (Speed boost for batch work)
7. **Flux Prompt Enhancer** (Better prompts)

### Installation Script for Your Setup

```powershell
# Navigate to custom nodes directory
cd D:\workspace\fluxdype\ComfyUI\custom_nodes

# Activate your venv
D:\workspace\fluxdype\venv\Scripts\Activate.ps1

# Install ComfyUI Manager
git clone https://github.com/ltdrdata/ComfyUI-Manager

# Restart ComfyUI, then use Manager to install:
# - Efficiency Nodes (jags111)
# - WAS Node Suite
# - Ultimate SD Upscale
# - ComfyUI-Impact-Pack
# - ComfyUI-TeaCache
# - ComfyUI-Fluxpromptenhancer
```

### Optional (Based on Your Needs)

- **ComfyUI-GGUF**: Only if you need to test lower VRAM models
- **IPAdapter Plus**: If you need style consistency across images
- **PuLID-Flux**: If you need face consistency (character work)
- **LLM Prompt Enhancer**: If you want maximum prompt control

---

**End of Report**

*This document is based on research conducted in December 2024 and reflects the current state of ComfyUI custom nodes for Flux 2.0 Dev model workflows.*
