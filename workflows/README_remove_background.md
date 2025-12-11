# Background Removal Workflow (BiRefNet RMBG)

## Overview
This ComfyUI workflow removes backgrounds from images using BiRefNet from the ComfyUI-RMBG custom node pack. The output is a transparent PNG with full alpha channel support, perfect for UI/UX work, product images, and portrait extraction.

## Quick Start

### 1. Prepare Your Image
Place your image in the ComfyUI input directory:
```
D:\workspace\fluxdype\ComfyUI\input\your_image.png
```

Supported formats: PNG, JPG, WebP, JPEG, BMP, GIF

### 2. Submit the Workflow
Using PowerShell:
```powershell
cd D:\workspace\fluxdype
.\run-workflow.ps1 -WorkflowPath ".\workflows\remove_background.json" -Wait
```

### 3. Get Results
Output files are saved to:
```
D:\workspace\fluxdype\ComfyUI\output\
```

Files generated:
- `transparent_bg_*.png` - Your image with transparent background (alpha channel)
- `bg_removal_mask_*.png` - Mask visualization (optional, for debugging)

## Workflow Nodes

### Node 1: Load Input Image
- **Type:** LoadImage
- **Function:** Loads your image from the input directory
- **Edit:** Change `"image": "input_image.png"` to your actual filename

Example:
```json
"image": "my_product_photo.jpg"
```

### Node 2: BiRefNet Background Removal
- **Type:** BiRefNetRMBG
- **Function:** Performs the actual background removal using AI

**Key Parameters:**

| Parameter | Default | Range | Description |
|-----------|---------|-------|-------------|
| `model` | BiRefNet-general | See models below | Which BiRefNet variant to use |
| `mask_blur` | 2 | 0-64 | Blur applied to mask edges (higher = smoother) |
| `mask_offset` | 0 | -20 to +20 | Expand (+) or shrink (-) mask boundary |
| `refine_foreground` | true | boolean | Enable foreground refinement (better quality) |
| `background` | Alpha | Alpha/Color | Background type (Alpha = transparent) |

**Available Models:**

| Model | Best For | Max Resolution | Speed |
|-------|----------|-----------------|-------|
| BiRefNet-general | Balanced, general purpose | 2048px | Medium |
| BiRefNet-portrait | People, portraits, faces | 2048px | Medium |
| BiRefNet-matting | General matting tasks | 2048px | Medium |
| BiRefNet-HR | High resolution images | 2560px | Slower |
| BiRefNet-HR-matting | High-res detailed matting | 2560px | Slower |
| BiRefNet_lite | Lightweight, faster | 2048px | Fast |
| BiRefNet_lite-matting | Lightweight matting | 2048px | Fast |
| BiRefNet_512x512 | Speed priority | 1024px | Fastest |
| BiRefNet_dynamic | Dynamic resolution | 2048px | Medium |
| BiRefNet_toonout | Cartoon/outline extraction | 2048px | Medium |

### Node 3: Save Transparent PNG
- **Type:** SaveImage
- **Function:** Saves the transparent PNG output
- **Output:** `transparent_bg_*.png` with alpha channel

### Node 4: Save Mask Visualization (Optional)
- **Type:** SaveImage
- **Function:** Saves mask as image for verification
- **Output:** `bg_removal_mask_*.png` (white=foreground, black=background)

### Node 5: Preview Mask (Optional)
- **Type:** PreviewImage
- **Function:** Shows mask preview in ComfyUI web UI

## Customization Examples

### For Product Photography
```json
"model": "BiRefNet-general",
"mask_blur": 3,
"refine_foreground": true
```

### For Portrait/Face Extraction
```json
"model": "BiRefNet-portrait",
"mask_blur": 2,
"refine_foreground": true
```

### For Speed (512px images)
```json
"model": "BiRefNet_512x512",
"mask_blur": 1,
"refine_foreground": false
```

### For High Resolution (2K+)
```json
"model": "BiRefNet-HR",
"mask_blur": 2,
"refine_foreground": true
```

### For Cartoon/Outline Style
```json
"model": "BiRefNet_toonout",
"mask_blur": 0,
"refine_foreground": false
```

## Tips & Tricks

1. **Edge Quality:** Adjust `mask_blur` (2-4 recommended for UI work)
2. **Trim Edges:** Use negative `mask_offset` to remove fuzzy edges
3. **Expand Selection:** Use positive `mask_offset` to include more foreground
4. **Complex Objects:** Enable `refine_foreground` for better results on detailed images
5. **Batch Processing:** Add multiple images to ComfyUI input, run workflow once
6. **Model Selection:** Start with BiRefNet-general, switch to specialized models if needed

## Troubleshooting

**Issue:** Transparent background not working
- **Solution:** Ensure `"background": "Alpha"` is set (not "Color")
- **Check:** PNG format is correct with alpha channel

**Issue:** Edges look jagged/rough
- **Solution:** Increase `mask_blur` to 3-4
- **Solution:** Enable `refine_foreground: true`

**Issue:** Foreground partially removed
- **Solution:** Use positive `mask_offset` (e.g., 2-3)
- **Solution:** Try `BiRefNet-general` or `BiRefNet-matting`

**Issue:** Processing is slow
- **Solution:** Switch to `BiRefNet_512x512` model (faster)
- **Solution:** Reduce input image size
- **Solution:** Set `refine_foreground: false`

**Issue:** Out of memory (CUDA)
- **Solution:** Use lighter model: `BiRefNet_lite` or `BiRefNet_512x512`
- **Solution:** Reduce image size before processing
- **Solution:** Use `--lowvram` flag when starting ComfyUI

## API/CLI Usage

### Using run-workflow.ps1
```powershell
# Submit and wait for completion
.\run-workflow.ps1 -WorkflowPath ".\workflows\remove_background.json" -Wait

# Submit to different server
.\run-workflow.ps1 -WorkflowPath ".\workflows\remove_background.json" -Host "192.168.1.100" -Port 8189
```

### Using cURL (Direct HTTP)
```bash
curl -X POST http://localhost:8188/prompt \
  -H "Content-Type: application/json" \
  -d @workflows/remove_background.json
```

### Using Python
```python
import json
import requests

with open('workflows/remove_background.json') as f:
    workflow = json.load(f)

response = requests.post(
    'http://localhost:8188/prompt',
    json=workflow['prompt']
)
job_id = response.json()['prompt_id']
print(f"Job submitted: {job_id}")
```

## Output Format

**Transparent PNG Structure:**
- Format: PNG with alpha channel
- Transparency: Full 8-bit alpha (0-255)
- Color Space: RGB + Alpha (RGBA)
- Quality: Lossless (no compression artifacts)
- Size: Same as input image

**Mask Visualization:**
- Format: PNG (8-bit grayscale)
- White (255): Foreground/Keep
- Black (0): Background/Remove
- Gray (0-255): Transition/Blended areas

## Performance Notes

**RTX 3090 Performance (Approx):**
- 512x512: ~0.5-1s per image
- 1024x1024: ~2-3s per image
- 2048x2048: ~8-10s per image
- 2560x2560: ~12-15s per image

*Actual times depend on image complexity and system load*

## File Location
```
D:\workspace\fluxdype\workflows\remove_background.json
```

## Related Files
- ComfyUI Installation: `D:\workspace\fluxdype\ComfyUI\`
- Custom Node: `D:\workspace\fluxdype\ComfyUI\custom_nodes\ComfyUI-RMBG\`
- Input Directory: `D:\workspace\fluxdype\ComfyUI\input\`
- Output Directory: `D:\workspace\fluxdype\ComfyUI\output\`

## License Notes

- BiRefNet Models: Apache-2.0 License
- ComfyUI-RMBG Integration: GPL-3.0 License
- This workflow: Free to use and modify

## References

- [ComfyUI-RMBG Repository](https://github.com/AILab-AI/ComfyUI-RMBG)
- [BiRefNet Models](https://huggingface.co/ZhengPeng7)
- [ComfyUI Documentation](https://github.com/comfyanonymous/ComfyUI)
