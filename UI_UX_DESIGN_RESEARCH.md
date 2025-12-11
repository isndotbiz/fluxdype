# ComfyUI UI/UX Design Image Generation Research

**Research Date:** December 9, 2025
**Target Use Case:** Professional UI/UX design images for Android apps and web pages
**Hardware:** NVIDIA RTX 3090 (24GB VRAM)
**Current Setup:** Flux Kria FP8 models

---

## Executive Summary

This research identifies optimal ComfyUI workflows, models, and techniques for generating professional UI/UX design images including app mockups, web page layouts, icons, UI elements, and marketing assets. Key findings show that Flux.1 models excel at UI design due to superior prompt adherence and typography capabilities, while specialized LoRAs provide flat design and icon generation capabilities.

---

## 1. Best Models for UI/UX Design

### A. Primary Models: Flux.1 Series (RECOMMENDED)

**Flux.1 Dev** - Best overall for UI/UX design work
- **Strengths:**
  - Exceptional prompt adherence for complex UI layouts
  - Superior text rendering within images (labels, buttons, menus)
  - Clean, professional aesthetic suitable for design work
  - Can generate mobile app interfaces and web page layouts
  - Handles readable text labels in mockups

- **Use Cases:**
  - High-fidelity mobile app mockups
  - Web page layout concepts
  - Dashboard and admin panel designs
  - Marketing screenshots with readable UI text

- **Model Size:** Available in FP8 quantized format (your current setup)
- **VRAM:** Works well on RTX 3090 with FP8 version

**Flux.1 Schnell** - Fast iteration option
- **Strengths:**
  - 4-step distilled model for rapid prototyping
  - Lower VRAM requirements
  - Good for quick concept exploration

- **Trade-offs:**
  - Slightly lower quality than Dev version
  - Still maintains good prompt adherence

**Flux 2.0 Dev** (Latest)
- **Strengths:**
  - Enhanced UI mockup generation with readable labels
  - Better complex layout handling
  - Improved typography rendering

- **Recommendation:** Consider upgrading when available for your setup

### B. Stable Diffusion Models (Alternatives)

**For Flat Design & Illustration:**

1. **Aniflatmix (Anime Flat Color Style Mix)**
   - Excellent for flat paint/ligne claire technique
   - Use keywords: `lineart`, `monochrome`, `flat design`
   - Good for minimalist UI element generation

2. **DreamShaper XL**
   - Beautiful digital art aesthetic
   - Works well for design-focused imagery
   - Strong for illustrations and UI concepts

3. **Inkpunk Diffusion**
   - Distinct illustration style
   - Good for creative/artistic UI concepts

4. **Juggernaut XL v9**
   - High clarity and detail
   - Photorealistic capabilities
   - Useful for marketing screenshots

---

## 2. Specialized LoRA Models

### A. Icon Generation LoRAs (HIGHLY RECOMMENDED)

**Icons.Redmond - App Icons LoRA for SDXL 1.0**
- **Purpose:** Specialized for iOS and Android app icon generation
- **Trigger Words:** `app icon, ios app icon` or `app icon, android app icon`
- **Output:** Sized appropriately for mobile app icons
- **Styles:** Supports minimalist shapes (Discord, Monarch, Evernote style)
- **Source:** CivitAI
- **Best For:** Professional app icon assets

**FlatIcon LoRA**
- **Purpose:** Minimalist flat logo/icon generation
- **Style:** Excellent for flat, minimalist icon designs
- **Best For:** Icon sets, UI element libraries
- **Source:** CivitAI

**Flux Icon Kit LoRA**
- **Purpose:** High-quality icon generation with Flux models
- **Trigger Word:** `Icon Kit`
- **Resolution:** 1024x1024 pixels
- **Best For:** Colorful UI icons, consistent icon sets
- **Source:** HuggingFace (Shakker-Labs)

### B. Logo & Branding LoRAs

**FLUX.1-dev-LoRA-Logo-Design (Shakker-Labs)**
- **Purpose:** Professional logo design generation
- **Trigger Words:** `wablogo, logo, Minimalist`
- **Specialties:**
  - Minimalist logo design
  - Shape + letter combinations
  - Dual-element compositions
- **Source:** HuggingFace
- **Best For:** App branding, icon variations

**Logo-Design-Flux-LoRA (prithivMLmods)**
- **Purpose:** Fine-tuned for professional logos
- **Base Model:** FLUX.1-dev
- **Best For:** Corporate/professional branding assets
- **Source:** HuggingFace

**FLUX-LoRA Colorful UI Icons (Shakker AI)**
- **Purpose:** Vibrant UI icon generation
- **Style:** Modern, colorful UI elements
- **Best For:** Material Design style icons
- **Source:** Shakker AI platform

---

## 3. Optimal Prompting Strategies

### A. Mobile App UI Mockup Prompts

**Template Structure:**
```
High-fidelity mockup of a [app type] on a [device type], showing a [screen type] with readable labels: '[Label 1]', '[Label 2]', '[Label 3]', and [UI element]. [Design style], [color scheme], sharp text and icons, [resolution].
```

**Example Prompt:**
```
High-fidelity mockup of a mobile fitness app on a modern smartphone, showing a dashboard screen with readable labels: 'Today', 'Steps', 'Calories', and a graph of weekly progress. Clean, flat UI design, white cards on a soft gradient background, sharp text and icons, 4MP resolution.
```

**Key Elements:**
- Specify "high-fidelity mockup" for quality
- List exact label text in quotes for readability
- Describe UI design style (flat, material, modern, minimal)
- Specify device context (smartphone, tablet, desktop)
- Include resolution requirements

### B. Web Page Layout Prompts

**Template Structure:**
```
[Website type] landing page design, [layout description], featuring [key sections], [design style], [color palette], clean typography, [aspect ratio].
```

**Example Prompt:**
```
E-commerce landing page design, hero section with product showcase, navigation bar with readable menu items: 'Shop', 'About', 'Contact', modern minimal design, white background with accent colors, clean typography, 16:9 aspect ratio.
```

### C. Icon Generation Prompts

**With Icon-Specific LoRAs:**
```
app icon, [platform], [subject/concept], [style], minimalist, [color scheme], clean lines, simple shape, centered composition
```

**Example:**
```
app icon, android app icon, fitness tracking, material design, minimalist, blue and green gradient, clean lines, simple dumbbell shape, centered composition
```

### D. UI Element Generation Prompts

**For Buttons, Cards, Components:**
```
UI [element type] design, [style], [state], [color scheme], [dimensions], professional, clean, modern
```

**Example:**
```
UI button design, material design, primary action state, blue gradient, rounded corners, professional, clean, modern, 512x128 pixels
```

### E. Transparency & PNG-Specific Prompts

**For Transparent Backgrounds:**
```
[element description], isolated on transparent background, PNG, no background, clean edges, [style]
```

**Keywords to Include:**
- `transparent background`
- `isolated`
- `PNG`
- `no background`
- `clean edges`
- `white background` (if using background removal post-processing)

---

## 4. Resolution & Format Recommendations

### A. ComfyUI Resolution Custom Nodes (RECOMMENDED)

**Comfyui-Resolution-Master** (GitHub: Azornes/Comfyui-Resolution-Master)
- **Features:**
  - Interactive canvas interface
  - Extensive presets (SDXL, Flux, WAN)
  - Model-specific optimizations
  - Custom preset manager

- **Supported Resolutions:**
  - 480p, 720p, 1080p (Full HD - 1920x1080), 2160p (4K)
  - Mobile presets (iPhone, Samsung, Google Pixel, OnePlus)
  - Custom aspect ratios

**Installation:**
```bash
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/Azornes/Comfyui-Resolution-Master.git
# Restart ComfyUI
```

### B. Recommended Resolutions by Use Case

**Mobile App Mockups:**
- iPhone 14 Pro Max: 1284x2778
- Samsung Galaxy S22 Ultra: 1440x3088
- Google Pixel 6: 1080x2400
- OnePlus 9 Pro: 1440x3216
- Generic: 1080x1920 (portrait)

**Web Page Mockups:**
- Desktop: 1920x1080 (Full HD)
- Laptop: 1366x768, 1440x900
- Tablet: 1024x768, 768x1024
- Wide: 2560x1440, 3840x2160

**Icons:**
- Standard: 1024x1024 (square)
- App Icons: 512x512, 1024x1024
- Favicon: 512x512 (then downscale)
- Icon Sets: 512x512 (uniform)

**UI Elements:**
- Buttons: 512x128, 1024x256
- Cards: 1024x768, 512x384
- Headers: 1920x400, 1440x300

**Marketing Assets:**
- App Store Screenshot: 1242x2688 (iPhone)
- Google Play Screenshot: 1080x1920
- Social Media: 1080x1080 (square), 1200x630 (landscape)

### C. Aspect Ratio Strategies

**Use ComfyUI Aspect Ratio Nodes:**
- Resolution by Aspect Ratio (ComfyUI_yanc)
- yaResolutionSelector (flexible selection)
- ComfyUI_aspect_ratios selector

**Common Ratios:**
- 16:9 (web, landscape)
- 9:16 (mobile, portrait)
- 1:1 (icons, social)
- 4:3 (tablet)
- 21:9 (ultrawide)

---

## 5. ControlNet Usage for Layout Consistency

### A. ControlNet Models for UI/UX

**Purpose:** Maintain consistent layouts, compositions, and structural elements across multiple generated images.

**Key ControlNet Types for UI Design:**

1. **Canny Edge Detection**
   - **Use Case:** Preserve exact UI layout structure
   - **Best For:** Maintaining button positions, card layouts, grid systems
   - **Process:** Create wireframe → Canny edge detection → Generate with Canny ControlNet

2. **Depth Control**
   - **Use Case:** 3D UI elements, card depth, layered designs
   - **Best For:** Material Design elevation, shadow hierarchy

3. **LineArt**
   - **Use Case:** Stylistic consistency in illustrated UI elements
   - **Best For:** Icon sets, custom illustrations, consistent line weight

4. **OpenPose** (limited use)
   - **Use Case:** Character consistency in app marketing screenshots
   - **Best For:** Mascot consistency, human element in UI

### B. ComfyUI ControlNet Workflow

**Installation:**
ControlNet models automatically detected in `D:\workspace\fluxdype\ComfyUI\models\controlnet\`

**Basic Workflow:**
1. Create or import reference wireframe/layout
2. Load ControlNet model (Canny recommended for UI)
3. Apply ControlNet preprocessor to reference
4. Connect to KSampler with text prompt
5. Generate with layout structure preserved

**Advanced Techniques:**
- **Multiple ControlNet Layering:** Chain Canny (structure) + Depth (hierarchy) + Color (palette)
- **ControlNet Strength:** 0.7-0.9 for UI work (higher = more faithful to structure)
- **Custom Node:** ComfyUI-Advanced-ControlNet (scheduling, masking, sliding context)

### C. Maintaining Design Language Consistency

**Challenge:** Generate multiple UI screens with consistent style, colors, and aesthetic.

**Solution: IPAdapter Plus**

**ComfyUI_IPAdapter_plus** (GitHub: cubiq/ComfyUI_IPAdapter_plus)
- **Purpose:** Style transfer and consistency across images
- **Key Features:**
  - Standard Style Transfer: Transfer reference image style
  - Precise Style Transfer: Separate style and composition layers
  - Works like "1-image LoRA"

**Installation:**
```bash
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
# Restart ComfyUI
```

**Workflow for Brand Consistency:**
1. Generate or provide reference design (your brand style)
2. Load IPAdapter model
3. Connect reference image to IPAdapter
4. Generate new screens/elements with same style applied
5. Adjust weight (0.5-0.8 typical for UI work)

**Use Cases:**
- Marketing materials with consistent branding
- App screens with unified design language
- Icon sets with matching aesthetic
- Multi-page web design mockups

**Advantages Over LoRA Training:**
- No training required
- Single reference image
- Quick style adjustments
- Less computational overhead

---

## 6. Background Removal & Transparency

### A. BiRefNet Background Removal (HIGHLY RECOMMENDED)

**Best Tool for Transparent PNG Creation in ComfyUI**

**Available Custom Nodes:**

1. **ComfyUI-RMBG** (GitHub: 1038lab/ComfyUI-RMBG)
   - **Models:** RMBG-2.0, INSPYRENET, BEN, BEN2, BiRefNet, SDMatte, SAM, SAM2, SAM3, GroundingDINO
   - **Features:** Advanced segmentation (object, face, clothes, fashion)
   - **Output:** RGBA with transparent background

2. **ComfyUI-BiRefNet-ZHO**
   - **Purpose:** Enhanced BiRefNet for ComfyUI
   - **Features:** Superior quality for images and videos
   - **Best For:** Professional background removal

3. **ComfyUI-RemoveBackground_SET**
   - **Features:** RGBA output or background replacement
   - **Default:** Transparency mode
   - **Options:** Replace with custom image/color

**Installation (RMBG - Most Comprehensive):**
```bash
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/1038lab/ComfyUI-RMBG.git
# Restart ComfyUI
```

**Models Auto-Download:**
- BEN2 and BiRefNet-HR download automatically on first use
- Stored in: `D:\workspace\fluxdype\ComfyUI\models\rmbg\`

**Quality Rankings:**
1. BiRefNet-HR (highest quality)
2. BEN2 (excellent quality)
3. RMBG-2.0 (fast, good quality)
4. INSPYRENET (baseline)

### B. Workflow for Transparent UI Elements

**Method 1: Generate with Background Removal**
1. Generate UI element/icon with solid white/colored background
2. Pass through BiRefNet Remove Background node
3. Output as PNG with transparency

**Method 2: Direct Transparent Generation (Alternative Tools)**

**Leonardo.AI Transparency Mode** (External, not ComfyUI)
- Native transparent diffusion
- Models: Kino XL, Vision XL, AlbedoBase XL
- Clean edges, no post-processing needed

**Pincel AI PNG Generator** (External)
- 1024x1024px transparent PNGs
- Prompt keywords: "PNG", "isolated", "transparent"

**For ComfyUI:** BiRefNet post-processing is most reliable method.

### C. Transparent PNG Best Practices

**Generation Strategy:**
1. Generate on clean white or solid color background
2. Use BiRefNet for automatic removal
3. Export as PNG (ensure alpha channel preserved)

**Prompt Optimization:**
- Include: `isolated`, `white background`, `clean edges`, `simple composition`
- Avoid: Complex backgrounds, gradients, shadows (if transparency needed)

**Quality Tips:**
- Generate at 2x target resolution, then downscale
- Use BiRefNet-HR for production assets
- Test multiple background removal models if edges are problematic

---

## 7. Style Consistency Techniques

### A. IPAdapter for Brand Consistency (Primary Method)

**Setup:** See Section 5.C above

**Workflow:**
1. **Create Style Reference:**
   - Generate or import ideal design example
   - Should represent target aesthetic (colors, typography, spacing, style)

2. **Apply to New Generations:**
   - Load reference into IPAdapter
   - Set weight (0.6-0.8 for strong consistency)
   - Generate variations maintaining style

3. **Fine-Tune:**
   - Adjust weight for more/less influence
   - Use Precise Style Transfer for better separation

**Best For:**
- Multi-screen app designs
- Icon set consistency
- Marketing asset series
- Branded web page mockups

### B. LoRA Training (Advanced)

**When to Use:**
- Need very specific brand style repeatedly
- Have dataset of existing designs
- Long-term project with many assets

**Process:**
1. Collect 20-50 images of target style
2. Train custom LoRA on Flux.1 Dev or SDXL
3. Use trained LoRA for all subsequent generations

**Tools:**
- Kohya_ss for LoRA training
- Requires time investment but provides strongest control

### C. Prompt Consistency Strategy

**Maintain Consistent Prompt Structure:**

**Define Style Template:**
```
[subject], [specific elements], modern material design, flat color palette, blue (#2196F3) and white (#FFFFFF), sans-serif typography, 8dp elevation shadows, clean lines, professional
```

**Apply to All Generations:**
- Keep style description identical
- Vary only subject/content
- Use same color codes, fonts, design system terminology

**Example Series:**

*Login Screen:*
```
Login screen UI, email and password fields with submit button, modern material design, flat color palette, blue (#2196F3) and white (#FFFFFF), sans-serif typography, 8dp elevation shadows, clean lines, professional, mobile portrait
```

*Dashboard Screen:*
```
Dashboard screen UI, card grid with statistics and graphs, modern material design, flat color palette, blue (#2196F3) and white (#FFFFFF), sans-serif typography, 8dp elevation shadows, clean lines, professional, mobile portrait
```

### D. Seed Control

**Use Fixed Seeds for Variations:**
- Generate base design with seed
- Note seed number
- Use same seed + varied prompt for related screens
- Maintains certain compositional/aesthetic elements

**ComfyUI Seed Control:**
- Set seed to fixed number (not random)
- Generate variations
- Small prompt changes = similar aesthetic

---

## 8. Typography & Text Rendering

### A. Text in Generated Images (Flux Advantage)

**Flux.1 Text Capabilities:**
- Can generate readable text within UI mockups
- Specify exact labels in quotes in prompt
- Works for buttons, menus, labels, headings

**Limitations:**
- Long text blocks may have errors
- Complex typography may need post-processing
- Best for 1-3 word labels

**Optimization:**
- Use quotes: `"Sign In"`, `"Dashboard"`, `"Settings"`
- Request "readable text", "sharp typography"
- Specify font style in prompt: "sans-serif", "modern font"

### B. ComfyUI Custom Nodes for Text Overlay (Post-Processing)

**For Perfect Typography Control:**

**1. ComfyUI_LayerStyle (RECOMMENDED)**

**LayerUtility: TextImage V2**
- **Purpose:** Advanced text rendering with layout control
- **Features:**
  - Custom font selection
  - Size, spacing, kerning control
  - Color and gradient support
  - Alignment and positioning
  - Typography-focused design tools

**LayerUtility: TextBox**
- **Purpose:** Text boxes within images
- **Best For:** Labels, captions, UI text elements

**Installation:**
```bash
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/chflame163/ComfyUI_LayerStyle.git
# Restart ComfyUI
```

**Workflow:**
1. Generate base UI mockup (can have placeholder/no text)
2. Use TextImage V2 node to add perfect typography
3. Overlay on mockup with exact positioning
4. Export final design

**2. ComfyUI-TextOverlay** (Alternative)

**Features:**
- Custom font support
- Color and alignment control
- Positioning adjustments
- Simpler than LayerStyle, good for basic needs

**Installation:**
```bash
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/munkyfoot/ComfyUI-TextOverlay.git
# Restart ComfyUI
```

**3. ComfyUI-Mana-Nodes**

**Features:**
- Font animation capabilities
- Dynamic captions
- Text-based content creation
- More advanced/specialized

### C. Hybrid Approach (Best Practice)

**Strategy:**
1. **Generation Phase:** Use Flux.1 to generate UI structure and basic text
2. **Refinement Phase:** Use LayerStyle nodes to add/refine critical text elements
3. **Export:** Combine for production-ready assets

**Benefits:**
- Leverage Flux's layout understanding
- Ensure perfect text readability
- Full typography control
- Professional quality output

---

## 9. Specialized Workflows

### A. Icon Generation Workflow

**Setup:**
1. Load Flux.1 Dev or SDXL model
2. Add Icons.Redmond or Flux Icon Kit LoRA
3. Set resolution to 1024x1024 (square)
4. Enable BiRefNet for transparency

**Prompt Template:**
```
app icon, [platform], [concept], minimalist, [color scheme], simple shape, centered composition, flat design, clean lines
```

**Process:**
1. Generate icon set (use seeds for variations)
2. Apply background removal (BiRefNet)
3. Export as PNG 1024x1024
4. Downscale to required sizes (512x512, 256x256, etc.)

**Batch Generation:**
- Use ComfyUI batch processing
- Same LoRA + varied prompts
- Consistent style across set

### B. Mobile App Mockup Workflow

**Setup:**
1. Load Flux.1 Dev model
2. Use Resolution Master with mobile preset (1080x1920 or device-specific)
3. Optional: Load brand LoRA or use IPAdapter for consistency

**Prompt Template:**
```
High-fidelity mockup of [app type] on [device], showing [screen name], featuring [UI elements with labels], [design style], [color palette], clean typography, modern interface
```

**Multi-Screen Workflow:**
1. Generate first screen (e.g., login)
2. Save as style reference for IPAdapter
3. Generate subsequent screens with IPAdapter consistency
4. Use same resolution, color codes in prompts
5. Optional: Use ControlNet for layout structure consistency

**Post-Processing:**
1. Add perfect text with LayerStyle if needed
2. Export at 2x resolution for retina displays
3. Create device frames (external tools or LayerStyle compositing)

### C. Web Page Mockup Workflow

**Setup:**
1. Load Flux.1 Dev model
2. Set resolution to 1920x1080 or 2560x1440
3. Use landscape aspect ratio

**Prompt Template:**
```
[Website type] homepage design, [layout description], navigation bar with [menu items], [content sections], [design style], [color palette], clean typography, modern web design, [specific framework if relevant]
```

**Full Page Workflow:**
1. **Hero Section:** Generate separately, high resolution
2. **Content Sections:** Generate modular sections
3. **Composite:** Use LayerStyle or external tool to combine
4. Alternative: Generate full page in one pass with detailed prompt

**Responsive Design:**
- Generate desktop version (1920x1080)
- Generate tablet version (1024x768)
- Generate mobile version (375x812)
- Maintain style with IPAdapter or consistent prompting

### D. UI Component Library Workflow

**Goal:** Create reusable UI element sets (buttons, cards, forms, etc.)

**Setup:**
1. Load Flux.1 Dev or SDXL
2. Small canvas sizes (512x256 for buttons, 1024x768 for cards)
3. BiRefNet for transparency
4. IPAdapter for consistency across set

**Process:**
1. **Define Style:** Create reference component or style guide image
2. **Load IPAdapter:** Use reference for all generations
3. **Generate Set:**
   - Buttons: Primary, Secondary, Disabled states
   - Forms: Input fields, textareas, dropdowns
   - Cards: Different content types
   - Navigation: Tabs, menus, breadcrumbs
4. **Ensure Consistency:** Same prompts (except element type), same IPAdapter reference
5. **Export Transparent:** BiRefNet removal, PNG output

**Organization:**
- Batch generate by category
- Consistent naming scheme
- Export at multiple scales if needed

---

## 10. Recommended ComfyUI Custom Nodes

### Essential Nodes for UI/UX Design

**1. ComfyUI-RMBG** ⭐⭐⭐⭐⭐
- **GitHub:** https://github.com/1038lab/ComfyUI-RMBG
- **Purpose:** Background removal, transparent PNGs
- **Why:** Industry-leading BiRefNet integration

**2. ComfyUI_IPAdapter_plus** ⭐⭐⭐⭐⭐
- **GitHub:** https://github.com/cubiq/ComfyUI_IPAdapter_plus
- **Purpose:** Style consistency, branding
- **Why:** Essential for multi-image consistency

**3. Comfyui-Resolution-Master** ⭐⭐⭐⭐⭐
- **GitHub:** https://github.com/Azornes/Comfyui-Resolution-Master
- **Purpose:** Resolution/aspect ratio control
- **Why:** Mobile/web presets, model-specific optimization

**4. ComfyUI_LayerStyle** ⭐⭐⭐⭐
- **GitHub:** https://github.com/chflame163/ComfyUI_LayerStyle
- **Purpose:** Typography, text rendering, compositing
- **Why:** Professional text control

**5. ComfyUI-Advanced-ControlNet** ⭐⭐⭐⭐
- **GitHub:** https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet
- **Purpose:** Advanced layout consistency
- **Why:** Scheduling, masking, sliding context

**6. ComfyUI-TextOverlay** ⭐⭐⭐
- **GitHub:** https://github.com/munkyfoot/ComfyUI-TextOverlay
- **Purpose:** Simple text overlay
- **Why:** Quick text additions

**7. ComfyUI_aspect_ratios** ⭐⭐⭐
- **GitHub:** https://github.com/massao000/ComfyUI_aspect_ratios
- **Purpose:** Aspect ratio selection
- **Why:** Quick ratio switching

**8. ComfyUI-Lora-Manager** ⭐⭐⭐
- **GitHub:** https://github.com/willmiao/ComfyUI-Lora-Manager
- **Purpose:** Organize and preview LoRAs
- **Why:** Manage icon/logo LoRA collection

### Installation Script (PowerShell)

```powershell
# Navigate to custom nodes directory
cd D:\workspace\fluxdype\ComfyUI\custom_nodes

# Clone recommended nodes
git clone https://github.com/1038lab/ComfyUI-RMBG.git
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
git clone https://github.com/Azornes/Comfyui-Resolution-Master.git
git clone https://github.com/chflame163/ComfyUI_LayerStyle.git
git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
git clone https://github.com/munkyfoot/ComfyUI-TextOverlay.git
git clone https://github.com/massao000/ComfyUI_aspect_ratios.git
git clone https://github.com/willmiao/ComfyUI-Lora-Manager.git

Write-Host "Custom nodes installed. Restart ComfyUI to load them."
```

---

## 11. Model Download Recommendations

### A. Flux Models (Primary - Already Installed)

**Current Setup:**
- Flux Kria FP8 (optimized for RTX 3090) ✓

**Consider Adding:**
- **Flux.1 Dev (Full Precision):** For highest quality UI work
- **Flux.1 Schnell:** For rapid iteration
- **Flux 2.0 Dev:** When available, enhanced UI capabilities

### B. LoRA Models to Download

**From HuggingFace:**

```bash
# Flux Icon Kit LoRA
wget -P D:\workspace\fluxdype\ComfyUI\models\loras\ https://huggingface.co/Shakker-Labs/FLUX-Icon-Kit-LoRA/resolve/main/FLUX-Icon-Kit-LoRA.safetensors

# FLUX.1-dev-LoRA-Logo-Design
wget -P D:\workspace\fluxdype\ComfyUI\models\loras\ https://huggingface.co/Shakker-Labs/FLUX.1-dev-LoRA-Logo-Design/resolve/main/FLUX.1-dev-LoRA-Logo-Design.safetensors

# Logo-Design-Flux-LoRA (prithivMLmods)
wget -P D:\workspace\fluxdype\ComfyUI\models\loras\ https://huggingface.co/prithivMLmods/Logo-Design-Flux-LoRA/resolve/main/logo_design_flux_lora.safetensors
```

**From CivitAI:**

1. **Icons.Redmond - App Icons LoRA for SDXL**
   - Search CivitAI for "Icons.Redmond"
   - Download to `D:\workspace\fluxdype\ComfyUI\models\loras\`
   - Requires SDXL base model

2. **FlatIcon LoRA**
   - Search CivitAI for "FlatIcon"
   - Download to `D:\workspace\fluxdype\ComfyUI\models\loras\`

### C. Alternative Base Models (SDXL)

**If Exploring SDXL:**

1. **Aniflatmix** (Flat Design)
   - CivitAI: Search "Aniflatmix"
   - Place in `D:\workspace\fluxdype\ComfyUI\models\checkpoints\`

2. **DreamShaper XL** (Digital Art)
   - CivitAI: Search "DreamShaper XL"
   - Place in `D:\workspace\fluxdype\ComfyUI\models\checkpoints\`

3. **Juggernaut XL v9** (High Quality)
   - CivitAI: Most popular SDXL model
   - Place in `D:\workspace\fluxdype\ComfyUI\models\checkpoints\`

### D. ControlNet Models

**Recommended for UI Work:**

Download to `D:\workspace\fluxdype\ComfyUI\models\controlnet\`:

1. **Canny** (Essential for layout structure)
2. **Depth** (Material Design elevation)
3. **LineArt** (Icon consistency)

**HuggingFace SDXL ControlNet:**
- Collection: https://huggingface.co/diffusers/controlnet-canny-sdxl-1.0
- Download Canny, Depth, LineArt variants

### E. IPAdapter Models

**Will auto-download on first use of IPAdapter nodes**

Models stored in: `D:\workspace\fluxdype\ComfyUI\models\ipadapter\`

---

## 12. Workflow Examples (Ready to Use)

### Workflow 1: App Icon Generation

**Filename:** `app_icon_generation.json`

**Components:**
- Flux.1 Dev model
- Flux Icon Kit LoRA (weight: 0.8)
- Resolution: 1024x1024
- BiRefNet background removal
- PNG output with transparency

**Prompt Structure:**
```
Icon Kit, app icon, [platform], [concept], minimalist, [color], simple shape, flat design, centered composition
```

**Steps:**
1. Load workflow in ComfyUI
2. Modify prompt (concept, color, platform)
3. Generate
4. Icon outputs as transparent PNG 1024x1024

### Workflow 2: Mobile App Mockup (Multi-Screen)

**Filename:** `mobile_mockup_series.json`

**Components:**
- Flux.1 Dev model
- Resolution Master (1080x1920 portrait)
- IPAdapter Plus (for consistency)
- LayerStyle TextImage V2 (optional text refinement)

**Process:**
1. Generate Screen 1 (e.g., Login)
2. Save Screen 1 as reference image
3. Load reference into IPAdapter
4. Generate Screen 2-5 with IPAdapter active
5. All screens maintain consistent style

**Prompt Template Per Screen:**
```
High-fidelity mockup of [app type] on modern smartphone, showing [screen name], featuring [elements], modern material design, [brand colors], clean typography, professional mobile interface
```

### Workflow 3: Web Landing Page

**Filename:** `web_landing_page.json`

**Components:**
- Flux.1 Dev model
- Resolution Master (1920x1080)
- Optional: ControlNet Canny (if using wireframe)

**Prompt:**
```
Modern landing page design for [industry], hero section with [headline] and CTA button, navigation bar with readable menu: 'Home', 'Features', 'Pricing', 'Contact', [describe sections], clean modern design, [color palette], professional typography, flat UI, 16:9 aspect ratio
```

**Output:**
- 1920x1080 web mockup
- Readable text elements
- Professional layout

### Workflow 4: UI Component Set

**Filename:** `ui_component_library.json`

**Components:**
- Flux.1 Dev model
- IPAdapter Plus (style reference)
- BiRefNet (transparency)
- Resolution varied per component type

**Process:**
1. Create/generate style reference (1 button in brand style)
2. Load into IPAdapter
3. Batch generate components:
   - Buttons (512x128): Primary, Secondary, Disabled
   - Cards (1024x768): 3 variants
   - Forms (512x256): Input, Dropdown, Checkbox
4. All export as transparent PNGs
5. Consistent style via IPAdapter

### Workflow 5: Icon Set (24-Icon Pack)

**Filename:** `icon_set_batch.json`

**Components:**
- SDXL or Flux.1 Dev
- Icons.Redmond or Flux Icon Kit LoRA
- BiRefNet
- Batch processing (24 prompts)

**Prompt List (Example):**
```
1. app icon, android, home, minimalist, blue, simple house shape
2. app icon, android, settings, minimalist, gray, gear icon
3. app icon, android, profile, minimalist, green, user silhouette
... (24 total)
```

**Output:**
- 24 icons, 1024x1024, transparent PNG
- Consistent style (LoRA + same prompt structure)
- Production-ready

---

## 13. Performance Optimization for RTX 3090

### A. Current Setup (Flux Kria FP8)

**Already Optimized:**
- FP8 quantization reduces VRAM by ~50%
- Your RTX 3090 (24GB) can handle Flux FP8 comfortably

### B. Recommended Launch Flags (from CLAUDE.md)

**For UI/UX Work (Standard VRAM mode):**
```powershell
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --normalvram
```

**If Generating Large Batches (GPU-only mode):**
```powershell
python main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch --gpu-only
```

### C. Batch Processing Strategies

**For Icon Sets / Component Libraries:**
- Generate in batches of 4-8 images
- Use ComfyUI batch processing nodes
- Monitor VRAM usage

**For Mockup Series:**
- Generate sequentially (not parallel)
- Use IPAdapter with shared reference (more VRAM efficient than multiple full generations)

### D. Resolution Considerations

**For Testing/Iteration:**
- Use 512x512 or 768x768 for icons
- Use 1080x1920 for mobile mockups
- Faster generation, lower VRAM

**For Final Assets:**
- Use 1024x1024 for icons
- Use 1284x2778 for production mobile mockups
- Use 1920x1080 or 2560x1440 for web mockups

---

## 14. External Resources & Communities

### A. Workflow Repositories

**ComfyUI Workflow Platforms:**
- **Comfy Workflows:** https://comfyworkflows.com/ (thousands of community workflows)
- **RunComfy:** https://www.runcomfy.com/comfyui-workflows (200+ curated workflows)
- **OpenArt:** https://openart.ai/workflows/home (templates and community workflows)

**GitHub:**
- **Official Examples:** https://github.com/comfyanonymous/ComfyUI_examples

### B. Model Sources

**HuggingFace:**
- Flux models: https://huggingface.co/black-forest-labs
- Shakker-Labs LoRAs: https://huggingface.co/Shakker-Labs
- prithivMLmods LoRAs: https://huggingface.co/prithivMLmods

**CivitAI:**
- Main site: https://civitai.com/
- SDXL models, LoRAs for design work
- Icon.Redmond, FlatIcon LoRAs

**Shakker AI:**
- Platform: https://www.shakker.ai/
- Colorful UI Icons LoRA and other design-focused models

### C. Learning Resources

**ComfyUI Documentation:**
- Official docs: https://docs.comfy.org/
- ControlNet tutorial: https://docs.comfy.org/tutorials/controlnet/controlnet
- Flux tutorial: https://docs.comfy.org/tutorials/flux/flux1-krea-dev

**Comflowy Tutorials:**
- IPAdapter guide: https://comflowy.com/blog/IPAdapter-Plus
- Style transfer: https://comflowy.com/blog/IPAdapter-Tutorial

**Stable Diffusion Art:**
- Flux installation: https://stable-diffusion-art.com/flux-comfyui/
- Model guides: https://stable-diffusion-art.com/models/

### D. AI Design Communities

**Reddit:**
- r/StableDiffusion (Flux discussions)
- r/comfyui (workflow sharing)

**Discord:**
- ComfyUI Official Discord (support, workflow sharing)
- Stable Diffusion Discord (model discussions)

---

## 15. Production Workflow Summary

### Complete UI/UX Asset Generation Pipeline

**Phase 1: Setup (One-time)**
1. Install recommended custom nodes (Section 10)
2. Download Flux Icon Kit and Logo Design LoRAs (Section 11)
3. Download Icons.Redmond for SDXL if using
4. Install BiRefNet node (auto-downloads models)
5. Install IPAdapter Plus node

**Phase 2: Style Definition**
1. Create or generate brand style reference image
2. Define color palette, typography, design system
3. Create prompt templates (Section 3)

**Phase 3: Asset Generation**

**For Icons:**
1. Load Flux + Icon LoRA workflow
2. Batch generate with varied prompts
3. BiRefNet transparency
4. Export 1024x1024 PNG

**For Mockups:**
1. Load Flux + Resolution preset workflow
2. Generate first screen
3. Use as IPAdapter reference
4. Generate remaining screens
5. Optionally refine text with LayerStyle

**For Components:**
1. Create style reference component
2. IPAdapter for consistency
3. Generate component set
4. BiRefNet for transparency
5. Export by category

**Phase 4: Post-Processing**
1. Refine text with LayerStyle if needed
2. Resize/scale assets to target dimensions
3. Organize by category/screen
4. Create device frames (external or LayerStyle)

**Phase 5: Export**
1. PNG for transparency needs (icons, components)
2. JPG for full mockups
3. Organize in asset library structure

---

## 16. Comparison: Flux vs SDXL for UI/UX

| Aspect | Flux.1 Dev | SDXL Models |
|--------|-----------|-------------|
| **Text Rendering** | ⭐⭐⭐⭐⭐ Excellent readable text | ⭐⭐⭐ Decent, often needs refinement |
| **Prompt Adherence** | ⭐⭐⭐⭐⭐ Very precise | ⭐⭐⭐⭐ Good |
| **UI Layout Understanding** | ⭐⭐⭐⭐⭐ Excellent for mockups | ⭐⭐⭐ Moderate |
| **Design Style Control** | ⭐⭐⭐⭐ Strong | ⭐⭐⭐⭐⭐ Wide variety of style LoRAs |
| **Icon Generation** | ⭐⭐⭐⭐ Good with LoRA | ⭐⭐⭐⭐⭐ Excellent LoRA support |
| **LoRA Availability** | ⭐⭐⭐ Growing | ⭐⭐⭐⭐⭐ Extensive library |
| **Speed (RTX 3090)** | ⭐⭐⭐⭐ Fast with FP8 | ⭐⭐⭐⭐⭐ Very fast |
| **VRAM Efficiency** | ⭐⭐⭐⭐ Good with FP8 | ⭐⭐⭐⭐⭐ Excellent |
| **Overall UI/UX** | ⭐⭐⭐⭐⭐ Best for mockups | ⭐⭐⭐⭐ Best for icons/components |

**Recommendation:**
- **Primary:** Flux.1 Dev (your current setup) for mockups, layouts, text-heavy UI
- **Secondary:** SDXL + specialized LoRAs for icon generation, flat design elements
- **Strategy:** Use both depending on task (Flux for mockups, SDXL for icons)

---

## 17. Troubleshooting Common UI/UX Issues

### Issue 1: Blurry or Illegible Text

**Problem:** Generated text in UI mockups is blurred or unreadable

**Solutions:**
1. **Use Flux.1 Dev:** Superior text generation
2. **Specify in quotes:** `"Sign In"`, `"Dashboard"` in prompt
3. **Request explicitly:** Add "readable text", "sharp typography", "clear labels"
4. **Post-process:** Use LayerStyle TextImage V2 to overlay perfect text
5. **Higher resolution:** Generate at 2x, downscale for sharper text

### Issue 2: Inconsistent Style Across Screens

**Problem:** Each generated screen looks different (colors, spacing, style)

**Solutions:**
1. **Use IPAdapter Plus:** Load first screen as reference, maintain consistency
2. **Strict prompt template:** Use exact same style description for all
3. **Fixed seed:** Use same seed for variations
4. **Train custom LoRA:** For brand-specific needs

### Issue 3: Background Not Transparent

**Problem:** Generated images have white/colored backgrounds instead of alpha channel

**Solutions:**
1. **Use BiRefNet:** ComfyUI-RMBG node for automatic removal
2. **Generate on white:** Then apply BiRefNet-HR for clean removal
3. **Check export format:** Ensure PNG output preserves alpha
4. **Avoid complex backgrounds:** Generate on solid color first

### Issue 4: Icons Look Too Realistic/Photographic

**Problem:** Icons have photorealistic rendering instead of flat design

**Solutions:**
1. **Use icon-specific LoRAs:** Icons.Redmond, Flux Icon Kit
2. **Emphasize in prompt:** "flat design", "minimalist", "simple shape", "vector style"
3. **Negative prompts:** "photorealistic", "3D", "detailed texture", "realistic"
4. **Use SDXL + Aniflatmix:** Better for flat illustration styles

### Issue 5: Layout Structure Not Matching Wireframe

**Problem:** Using ControlNet but output doesn't match wireframe structure

**Solutions:**
1. **Increase ControlNet strength:** 0.8-0.9 for UI work
2. **Use Canny preprocessor:** Better for hard edges (UI elements)
3. **Simplify wireframe:** Clearer lines, less ambiguity
4. **Check model compatibility:** Ensure ControlNet matches base model (SDXL ControlNet with SDXL base)

### Issue 6: Out of Memory Errors

**Problem:** VRAM exceeded during generation

**Solutions:**
1. **Use FP8 models:** Your current Flux Kria FP8 is already optimized
2. **Lower resolution:** 1080x1920 instead of 1284x2778
3. **Sequential not parallel:** Generate one at a time
4. **Close other GPU apps:** Ensure ComfyUI has full VRAM access
5. **Use --normalvram flag:** In server launch (see Section 13)

### Issue 7: LoRA Not Affecting Output

**Problem:** Loaded LoRA but output doesn't show style

**Solutions:**
1. **Check LoRA weight:** Increase to 0.8-1.0
2. **Use trigger words:** Icons.Redmond needs "app icon, android app icon"
3. **Verify model compatibility:** Flux LoRA with Flux base, SDXL LoRA with SDXL base
4. **Check file location:** Must be in `ComfyUI/models/loras/`

---

## 18. Next Steps & Implementation Plan

### Immediate Actions (Day 1)

**1. Install Essential Custom Nodes**
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/1038lab/ComfyUI-RMBG.git
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
git clone https://github.com/Azornes/Comfyui-Resolution-Master.git
```
*Restart ComfyUI after installation*

**2. Download Flux Icon LoRA**
- Visit: https://huggingface.co/Shakker-Labs/FLUX-Icon-Kit-LoRA
- Download to: `D:\workspace\fluxdype\ComfyUI\models\loras\`

**3. Test Basic Icon Generation**
- Load Flux Kria FP8 model
- Add Icon Kit LoRA (weight 0.8)
- Prompt: `Icon Kit, app icon, android, fitness, minimalist, blue, simple dumbbell shape, flat design`
- Resolution: 1024x1024
- Generate

### Short-term Goals (Week 1)

**1. Build Standard Workflows**
- Create app icon generation workflow (save as JSON)
- Create mobile mockup workflow
- Create web page mockup workflow
- Save in `D:\workspace\fluxdype\workflows\`

**2. Establish Style Reference Library**
- Generate or collect 3-5 design style references
- Organize by style: Material Design, Flat Design, Minimalist, Modern
- Use for IPAdapter consistency

**3. Test BiRefNet Background Removal**
- Generate sample icons with backgrounds
- Apply BiRefNet removal
- Verify transparent PNG output quality

**4. Install LayerStyle for Typography**
```powershell
cd D:\workspace\fluxdype\ComfyUI\custom_nodes
git clone https://github.com/chflame163/ComfyUI_LayerStyle.git
```
- Test TextImage V2 node
- Create text overlay workflow

### Medium-term Goals (Month 1)

**1. Expand LoRA Library**
- Download Icons.Redmond from CivitAI
- Download FlatIcon LoRA
- Download Logo Design Flux LoRA
- Test each, document best use cases

**2. Build Component Library Workflow**
- Create reusable button set
- Create card component variants
- Create form element set
- All with transparent backgrounds

**3. Master IPAdapter Consistency**
- Generate 5-screen app mockup series with consistent style
- Test style reference weight adjustments
- Document optimal settings

**4. Explore SDXL for Specialized Tasks**
- Download Aniflatmix checkpoint
- Test flat design generation
- Compare with Flux for icons
- Determine best model per task

### Long-term Goals (Quarter 1)

**1. Production Pipeline**
- Automated batch workflows
- Asset organization system
- Quality control checklist
- Documentation for team

**2. Custom LoRA Training** (if needed)
- Collect brand style dataset
- Train custom brand LoRA
- Test on real projects
- Iterate based on results

**3. Advanced Techniques**
- Multi-ControlNet workflows (Canny + Depth)
- Complex layered compositions
- Animation preparation (sprite sheets)
- Video mockup exploration (if supported)

**4. Integration with Design Tools**
- Figma/Sketch import workflows
- Export format optimization
- Asset pipeline to dev teams

---

## 19. Conclusion & Key Takeaways

### Most Important Points

**1. Flux.1 Dev is Your Primary Tool**
- Best text rendering for UI mockups
- Excellent prompt adherence
- Already installed (FP8 optimized)
- Use for: Mockups, layouts, text-heavy designs

**2. Essential Custom Nodes (Install First)**
- ComfyUI-RMBG (BiRefNet) for transparency
- IPAdapter Plus for consistency
- Resolution Master for proper sizing
- LayerStyle for perfect typography

**3. LoRAs for Specialized Tasks**
- Flux Icon Kit LoRA for icons
- Icons.Redmond (SDXL) for app icons
- Logo Design LoRAs for branding

**4. Workflow Strategy**
- IPAdapter for multi-screen consistency
- BiRefNet for transparent assets
- LayerStyle for text refinement
- ControlNet for layout structure

**5. Resolution Best Practices**
- Mobile: 1080x1920 (or device-specific)
- Web: 1920x1080 (Full HD)
- Icons: 1024x1024 (square)
- Generate at 2x for production assets

### Quick Reference Cheat Sheet

**Icon Generation:**
```
Model: Flux + Icon Kit LoRA
Size: 1024x1024
Prompt: Icon Kit, app icon, [platform], [concept], minimalist, [color], simple shape
Post: BiRefNet transparency
```

**Mobile Mockup:**
```
Model: Flux.1 Dev
Size: 1080x1920
Prompt: High-fidelity mockup of [app] on smartphone, showing [screen], featuring [elements], modern design, [colors], clean typography
Post: IPAdapter for series, LayerStyle for text
```

**Web Design:**
```
Model: Flux.1 Dev
Size: 1920x1080
Prompt: [Website type] design, [layout], navigation with [menu items], [sections], [style], [colors], modern web design
```

**Style Consistency:**
```
Tool: IPAdapter Plus
Process: Generate reference → Load in IPAdapter → Generate variations
Weight: 0.6-0.8
```

**Transparency:**
```
Tool: BiRefNet (ComfyUI-RMBG)
Process: Generate on white/solid → BiRefNet removal → PNG export
Model: BiRefNet-HR for best quality
```

---

## 20. Additional Resources & Links

### Documentation Links

**ComfyUI Official:**
- Docs: https://docs.comfy.org/
- Examples: https://comfyanonymous.github.io/ComfyUI_examples/
- GitHub: https://github.com/comfyanonymous/ComfyUI

**Flux Resources:**
- Flux examples: https://comfyanonymous.github.io/ComfyUI_examples/flux/
- Installation guide: https://stable-diffusion-art.com/flux-comfyui/
- Wiki guide: https://comfyui-wiki.com/en/tutorial/advanced/image/flux/flux-1-dev-t2i

**IPAdapter:**
- Tutorial: https://www.comflowy.com/blog/IPAdapter-Plus
- Deep dive: https://www.runcomfy.com/tutorials/comfyui-ipadapter-plus-deep-dive-tutorial

**Background Removal:**
- BiRefNet guide: https://comfyui.org/en/remove-backgrounds-with-comfyui
- Medium article: https://medium.com/code-canvas/background-removal-in-comfyui-just-got-really-really-good-2a12717ff0db

**Resolution & Aspect Ratios:**
- Resolution Master: https://github.com/Azornes/Comfyui-Resolution-Master
- Documentation: https://comfyai.run/documentation/ResolutionCalculator

### Model Repositories

**HuggingFace:**
- Flux Icon Kit: https://huggingface.co/Shakker-Labs/FLUX-Icon-Kit-LoRA
- Logo Design LoRA: https://huggingface.co/Shakker-Labs/FLUX.1-dev-LoRA-Logo-Design
- Logo Design (prithiv): https://huggingface.co/prithivMLmods/Logo-Design-Flux-LoRA

**CivitAI:**
- Main site: https://civitai.com/
- Search for: Icons.Redmond, FlatIcon, Aniflatmix, DreamShaper XL, Juggernaut XL

**Shakker AI:**
- Platform: https://www.shakker.ai/
- Colorful UI Icons: https://www.shakker.ai/modelinfo/0c3ab5ab70404103a99be9ed531e7e93/FLUX-LoRA-Colorful-UI-Icons

### Learning Resources

**Tutorials:**
- Flux for UX: https://www.timeundertension.ai/imagine/flux-for-ux-a-new-design-pardigm
- Prompt guide: https://fluxproweb.com/blog/detail/-How-to-Design-Effective-Prompts-for-Flux-1-Dev-12193866342d/
- ComfyUI beginner guide: https://stablediffusion3.net/blog-beginners-guide-to-stable-diffusion-and-sdxl-with-comfyui-42368

**Articles:**
- Best practices: https://www.visily.ai/blog/ui-mockups-best-practices/
- Creating app icons: https://www.bluelabellabs.com/blog/a-guide-to-creating-app-icons-using-stable-diffusion-ai/

**Community:**
- Comfy Workflows: https://comfyworkflows.com/
- RunComfy: https://www.runcomfy.com/comfyui-workflows
- OpenArt: https://openart.ai/workflows/home

---

## Appendix A: File Locations Reference

```
D:\workspace\fluxdype\
├── ComfyUI\
│   ├── main.py                              # ComfyUI entry point
│   ├── models\
│   │   ├── diffusion_models\                # Flux Kria FP8 (current)
│   │   ├── checkpoints\                     # SDXL models (if added)
│   │   ├── loras\                           # LoRA models (Icon Kit, Logo Design, etc.)
│   │   ├── controlnet\                      # ControlNet models (Canny, Depth, LineArt)
│   │   ├── ipadapter\                       # IPAdapter models (auto-download)
│   │   ├── rmbg\                            # BiRefNet models (auto-download)
│   │   ├── vae\                             # VAE models
│   │   ├── text_encoders\                   # CLIP, T5XXL
│   │   └── upscale_models\                  # Upscaling (optional)
│   ├── output\                              # Generated images
│   ├── custom_nodes\                        # Custom nodes (install here)
│   │   ├── ComfyUI-RMBG\                    # Background removal
│   │   ├── ComfyUI_IPAdapter_plus\          # Style consistency
│   │   ├── Comfyui-Resolution-Master\       # Resolution control
│   │   ├── ComfyUI_LayerStyle\              # Typography
│   │   ├── ComfyUI-Advanced-ControlNet\     # Advanced ControlNet
│   │   ├── ComfyUI-TextOverlay\             # Text overlay
│   │   ├── ComfyUI_aspect_ratios\           # Aspect ratios
│   │   └── ComfyUI-Lora-Manager\            # LoRA management
│   └── input\                               # Input images (references, wireframes)
├── workflows\                               # Custom workflows (create this)
│   ├── app_icon_generation.json
│   ├── mobile_mockup_series.json
│   ├── web_landing_page.json
│   ├── ui_component_library.json
│   └── icon_set_batch.json
├── venv\                                    # Python virtual environment
├── start-comfy.ps1                          # Server startup script
├── run-workflow.ps1                         # Workflow submission script
└── UI_UX_DESIGN_RESEARCH.md                 # This document
```

---

## Appendix B: Prompt Template Library

### Mobile App Screens

**Login Screen:**
```
High-fidelity mockup of login screen on modern smartphone, featuring email field labeled "Email", password field labeled "Password", primary button "Sign In", and link "Forgot Password?", modern material design, blue (#2196F3) and white, clean typography, professional mobile interface, 1080x1920
```

**Dashboard:**
```
High-fidelity mockup of dashboard screen on smartphone, showing header "Dashboard", 4 statistics cards with labels "Users", "Sales", "Revenue", "Growth", and line graph, modern flat design, white cards on light background, clean typography, professional mobile interface, 1080x1920
```

**Profile:**
```
High-fidelity mockup of user profile screen on smartphone, featuring circular avatar placeholder, user name label, email label, "Edit Profile" button, and settings sections: "Account", "Privacy", "Notifications", modern design, minimal interface, clean typography, 1080x1920
```

**Settings:**
```
High-fidelity mockup of settings screen on smartphone, showing grouped list items: "Account Settings", "Notifications", "Privacy", "About", with right-pointing arrows, modern flat design, white background, clean typography, professional mobile interface, 1080x1920
```

**Onboarding:**
```
High-fidelity mockup of onboarding screen on smartphone, featuring illustration placeholder, heading "Welcome", description text, progress dots at bottom, and "Next" button, modern colorful design, gradient background, clean typography, friendly interface, 1080x1920
```

### Web Pages

**Landing Page:**
```
Modern landing page design, hero section with headline "Welcome to Our Service" and CTA button "Get Started", navigation bar with menu items: "Home", "Features", "Pricing", "Contact", features grid with 3 cards, clean modern design, blue and white color scheme, professional typography, 1920x1080
```

**Dashboard (Admin):**
```
Web dashboard admin panel design, left sidebar navigation with icons and labels: "Dashboard", "Users", "Analytics", "Settings", main content area with statistics cards and data table, modern flat design, clean interface, professional, 1920x1080
```

**Product Page:**
```
E-commerce product page design, large product image placeholder on left, product title and price on right, "Add to Cart" button, product description section, reviews section below, modern clean design, white background, professional typography, 1920x1080
```

**Pricing Page:**
```
Pricing page design, 3 pricing tier cards side by side labeled "Basic", "Pro", "Enterprise", each with price, feature list, and "Choose Plan" button, modern design, white cards on light background, clean typography, 1920x1080
```

### Icons

**Social Media Set:**
```
Icon Kit, app icon, android, [facebook/twitter/instagram/linkedin/youtube], minimalist, [brand color], simple recognizable symbol, flat design, centered composition, 1024x1024
```

**Navigation Icons:**
```
Icon Kit, app icon, [home/search/profile/settings/notifications], minimalist, gray (#757575), simple line icon, flat design, centered composition, 1024x1024
```

**Action Icons:**
```
Icon Kit, app icon, [edit/delete/save/share/download], minimalist, blue (#2196F3), simple symbol, flat design, centered composition, 1024x1024
```

### UI Components

**Primary Button:**
```
UI button component, primary action state, blue (#2196F3) background, white text "Submit", rounded corners, material design, 8dp elevation shadow, modern clean design, 512x128
```

**Input Field:**
```
UI text input component, white background, gray border, placeholder text "Enter email", modern minimal design, clean lines, 1024x256
```

**Card Component:**
```
UI card component, white background, rounded corners, 8dp elevation shadow, placeholder for image at top, text content area below, material design, clean modern style, 1024x768
```

---

## Sources & References

This research compiled information from the following sources:

### ComfyUI Resources
- [Comfy Workflows](https://comfyworkflows.com/)
- [RunComfy ComfyUI Workflows](https://www.runcomfy.com/comfyui-workflows)
- [ComfyUI Examples (Official)](https://comfyanonymous.github.io/ComfyUI_examples/)
- [OpenArt ComfyUI Workflows](https://openart.ai/workflows/home)
- [Comflowy](https://www.comflowy.com/)
- [ComfyUI GitHub Repository](https://github.com/comfyanonymous/ComfyUI_examples)
- [ComfyUI Official Documentation](https://docs.comfy.org/)
- [Top 5 Workflows Every Designer Should Try in ComfyUI](https://paacademy.com/blog/top-5-workflows-every-designer-should-try-in-comfyui)

### Flux Models & Resources
- [Flux Examples | ComfyUI](https://comfyanonymous.github.io/ComfyUI_examples/flux/)
- [Flux.1 Krea Dev Tutorial](https://docs.comfy.org/tutorials/flux/flux1-krea-dev)
- [How to Install Flux AI Model on ComfyUI](https://stable-diffusion-art.com/flux-comfyui/)
- [GitHub - XLabs-AI/x-flux-comfyui](https://github.com/XLabs-AI/x-flux-comfyui)
- [Using ComfyUI and Flux on Koyeb](https://www.koyeb.com/tutorials/using-comfyui-and-flux-to-generate-high-quality-images-on-koyeb)
- [Getting Started with Flux Dev Model](https://medium.com/@mukul_jain/getting-start-with-flux-dev-model-with-comfy-ui-830b058e9716)
- [Flux.1 ComfyUI Guide and Workflow](https://comfyui-wiki.com/en/tutorial/advanced/image/flux/flux-1-dev-t2i)
- [Flux Model Resource Collection](https://comfyui-wiki.com/en/resource/flux)
- [Day 1 Support for Flux Tools in ComfyUI](https://blog.comfy.org/p/day-1-support-for-flux-tools-in-comfyui)
- [Flux for UX: A New Design Paradigm](https://www.timeundertension.ai/imagine/flux-for-ux-a-new-design-pardigm)
- [How to Design Effective Prompts for Flux.1 Dev](https://fluxproweb.com/blog/detail/-How-to-Design-Effective-Prompts-for-Flux-1-Dev-12193866342d/)
- [14 Essential FLUX.1 Prompts](https://skywork.ai/blog/flux1-prompts-tested-templates-tips-2025/)
- [Top 10 Prompts for Flux.1](https://aimlapi.com/blog/master-the-art-of-ai-top-10-prompts-for-flux-1-by-black-forests-labs)
- [Flux 2 Prompt Examples](https://www.genaintel.com/guides/flux-2-prompt-examples-dev-flex-pro)

### LoRA Models & Specialized Tools
- [Shakker-Labs/FLUX.1-dev-LoRA-Logo-Design (HuggingFace)](https://huggingface.co/Shakker-Labs/FLUX.1-dev-LoRA-Logo-Design)
- [Flux Icon Kit LoRA (Dataloop)](https://dataloop.ai/library/model/strangerzonehf_flux-icon-kit-lora/)
- [Flux Lora AI Gallery](https://flux1.ai/gallery)
- [prithivMLmods/Logo-Design-Flux-LoRA (HuggingFace)](https://huggingface.co/prithivMLmods/Logo-Design-Flux-LoRA)
- [FLUX-LoRA Colorful UI Icons (Shakker AI)](https://www.shakker.ai/modelinfo/0c3ab5ab70404103a99be9ed531e7e93/FLUX-LoRA-Colorful-UI-Icons)
- [A Guide to Creating App Icons Using Stable Diffusion AI](https://www.bluelabellabs.com/blog/a-guide-to-creating-app-icons-using-stable-diffusion-ai/)

### AI Mockup & UI Tools
- [Quality MockUps ComfyUI Workflow (OpenArt)](https://openart.ai/workflows/juancho%20garzón/quality-mockups/mcR1vZm8IRJMVa7yYq4r)
- [Uizard UI Design Tool](https://uizard.io/)
- [Visily UI Mockup Tool](https://www.visily.ai/ui-mockup-tool/)
- [8 Best Practices for Faster UI Mockups](https://www.visily.ai/blog/ui-mockups-best-practices/)
- [How to Create UI Mockups Guide](https://www.visily.ai/blog/how-to-create-ui-mockups/)
- [The Top 8 AI Tools for UX Design](https://www.uxdesigninstitute.com/blog/the-top-8-ai-tools-for-ux/)

### ControlNet Resources
- [ComfyUI ControlNet Usage Example](https://docs.comfy.org/tutorials/controlnet/controlnet)
- [Mastering ComfyUI ControlNet: Part 1](https://www.toolify.ai/gpts/mastering-comfy-ui-controlnet-part-1-136099)
- [ControlNET Integration in ComfyUI](https://medium.com/@techlatest.net/controlnet-integration-in-comfyui-9ef2087687cc)
- [ControlNet and T2I-Adapter Examples](https://comfyanonymous.github.io/ComfyUI_examples/controlnet/)
- [Mastering ControlNet in ComfyUI](https://www.runcomfy.com/tutorials/mastering-controlnet-in-comfyui)
- [ControlNet Tutorial (ComfyUI Wiki)](https://comfyui-wiki.com/en/tutorial/advanced/how-to-install-and-use-controlnet-models-in-comfyui)
- [GitHub - ComfyUI-Advanced-ControlNet](https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet)

### Transparent Background & PNG Generation
- [How to Create Transparent Background Images](https://www.aiarty.com/midjourney-guide/midjourney-transparent-background.htm)
- [AI Transparent Image Generator - Pincel](https://pincel.app/tools/ai-png)
- [Effortless PNG Generation (PromeAI)](https://www.promeai.pro/ai-png-generator)
- [Leonardo.AI Transparent PNG Generator](https://leonardo.ai/transparent-png-generator/)
- [Best AI PNG Generator](https://clickup.com/blog/ai-png-generator/)
- [Generate Transparent PNG Images With AI](https://blog.pincel.app/ai-png-maker/)
- [The Joy of Prompting AI for PNG Transparency](https://hackernoon.com/the-glorious-glitchy-joy-of-prompting-ai-for-png-transparency)

### Stable Diffusion Models
- [Best Stable Diffusion Models For Any Task](https://stablediffusionxl.com/best-stable-diffusion-models/)
- [Stable Diffusion Models: A Beginner's Guide](https://stable-diffusion-art.com/models/)
- [12 Best Stable Diffusion Models](https://www.videoproc.com/resource/best-stable-diffusion-models.htm)
- [40+ Best Stable Diffusion Models 2025](https://www.aiarty.com/stable-diffusion-guide/best-stable-diffusion-models.htm)
- [Top AI Diffusion Models Comparison Guide](https://www.ikomia.ai/blog/best-ai-diffusion-models-comparison-guide)
- [The 10 Best Stable Diffusion Models by Popularity](https://aituts.com/models/)
- [SD1.5 Recommended Checkpoint Models](https://www.digitalcreativeai.net/en/post/sd15-recommended-checkpoint-models)
- [SDXL Recommended Checkpoint Models](https://www.digitalcreativeai.net/en/post/sdxl-recommended-checkpoint-models)

### Background Removal (BiRefNet)
- [ComfyUI-BiRefNet-ZHO Detailed Guide](https://www.runcomfy.com/comfyui-nodes/ComfyUI-BiRefNet-ZHO)
- [Remove Backgrounds with ComfyUI](https://comfyui.org/en/remove-backgrounds-with-comfyui)
- [Background Removal Just Got Really Good](https://medium.com/code-canvas/background-removal-in-comfyui-just-got-really-really-good-2a12717ff0db)
- [GitHub - ComfyUI-RMBG](https://github.com/1038lab/ComfyUI-RMBG)
- [GitHub - ComfyUI-RemoveBackground_SET](https://github.com/set-soft/ComfyUI-RemoveBackground_SET)
- [Remove Background Workflow (OpenArt)](https://openart.ai/workflows/yu_/remove-background-transparent-background/B07XCOJtOhPVwUN1tDb8)

### Resolution & Aspect Ratio Tools
- [GitHub - Comfyui-Resolution-Master](https://github.com/Azornes/Comfyui-Resolution-Master)
- [Resolution by Aspect Ratio Node](https://www.runcomfy.com/comfyui-nodes/ComfyUI_yanc/--Resolution-by-Aspect-Ratio)
- [ResolutionCalculator Node Documentation](https://comfyai.run/documentation/ResolutionCalculator)
- [GitHub - ComfyUI_ResolutionSelector](https://github.com/bradsec/ComfyUI_ResolutionSelector)
- [GitHub - ComfyUI-yaResolutionSelector](https://github.com/Tropfchen/ComfyUI-yaResolutionSelector)
- [GitHub - ComfyUI_aspect_ratios](https://github.com/massao000/ComfyUI_aspect_ratios)

### IPAdapter & Style Consistency
- [How to Perform Style Transfer Using IPAdapter Plus](https://comflowy.com/blog/IPAdapter-Plus)
- [ComfyUI IPAdapter Plus: Style Transfer Made Easy](https://www.runcomfy.com/comfyui-workflows/comfyui-ipadapter-plus-style-transfer-made-easy)
- [GitHub - ComfyUI_IPAdapter_plus](https://github.com/cubiq/ComfyUI_IPAdapter_plus)
- [ComfyUI_IPAdapter_plus Detailed Guide](https://www.runcomfy.com/comfyui-nodes/ComfyUI_IPAdapter_plus)
- [ComfyUI IPAdapter Plus Deep Dive Tutorial](https://www.runcomfy.com/tutorials/comfyui-ipadapter-plus-deep-dive-tutorial)
- [IPAdapter Tutorial (Comflowy)](https://www.comflowy.com/blog/IPAdapter-Tutorial)

### Typography & Text Rendering
- [LayerUtility: TextImage V2 Documentation](https://comfyai.run/documentation/LayerUtility:%20TextImage%20V2)
- [GitHub - ComfyUI-TextOverlay](https://github.com/Munkyfoot/ComfyUI-TextOverlay)
- [ComfyUI_LayerStyle Custom Node](https://comfyai.run/custom_node/ComfyUI_LayerStyle)
- [GitHub - ComfyUI-Mana-Nodes](https://github.com/ForeignGods/ComfyUI-Mana-Nodes)

---

**Document Version:** 1.0
**Last Updated:** December 9, 2025
**Author:** AI Research Assistant
**For:** FluxDype Project (D:\workspace\fluxdype)
