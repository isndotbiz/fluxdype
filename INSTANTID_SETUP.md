# InstantID Face Swap Setup - Complete ✓

## Installation Summary

### ✅ What Was Fixed:
1. **UnboundLocalError in ComfyUI nodes.py** - Fixed variable initialization
2. **Missing simpleeval package** - Installed for Efficiency Nodes
3. **InsightFace installation** - Installed pre-built wheel (v0.2.1)
4. **ONNX Runtime GPU** - Installed for CUDA acceleration on RTX 3090
5. **InstantID Custom Node** - Cloned and configured

### ✅ Installed Packages:
- `insightface==0.2.1` (pre-built wheel)
- `onnxruntime-gpu==1.23.2`
- `simpleeval==1.0.3`
- `Cython==3.2.1`
- Various dependencies (opencv-python, scikit-image, etc.)

### ✅ Downloaded Models:
- **InstantID IP-Adapter**: `models/instantid/ip-adapter.bin` (✓)
- **InstantID ControlNet**: `models/controlnet/instantid_controlnet.safetensors` (✓)
- **AntelopeV2 Face Models**: `models/insightface/models/antelopev2/` (✓)
  - 1k3d68.onnx
  - 2d106det.onnx
  - genderage.onnx
  - glintr100.onnx
  - scrfd_10g_bnkps.onnx

## How to Use InstantID for Face Swapping

### Basic Face Swap Workflow:

1. **Load Your Base Image**
   - Use `Load Image` node

2. **Load Your SDXL Model**
   - Use `Load Checkpoint` node
   - **Important**: InstantID only works with SDXL models (not FLUX)

3. **Apply InstantID**
   - Add `Apply InstantID` node
   - Connect reference face image
   - Adjust strength (0.8-1.0 for strong face similarity)

4. **Add ControlNet**
   - The InstantID ControlNet will be auto-loaded
   - Adjust controlnet strength (0.6-0.8 recommended)

5. **Set CFG Low**
   - **Critical**: Set CFG to 4-5 (not 7-8)
   - High CFG will "burn" the face

6. **Resolution Tips**
   - Use 1016×1016 instead of 1024×1024 to avoid watermarks
   - Or any resolution slightly off standard sizes

### Making Faces More Realistic After Swap:

#### Using Your Existing Nodes:

1. **Face Enhancement with Impact Pack**:
   ```
   [Image] → [FaceDetailer (Impact Pack)] → [Output]
   ```
   - Set detection threshold: 0.5
   - Use bbox_detector: bbox/face_yolov8m.pt
   - Dilation: 10-20

2. **Color Matching**:
   - Add slight color correction to match skin tones
   - Use ComfyUI Essentials color nodes

3. **Post-Processing**:
   - Slight blur on edges for blending
   - Use Impact Pack's ImageBlend node

#### Advanced Workflow:
```
[Original Image] → [InstantID] → [FaceDetailer] → [ColorMatch] → [Final Output]
```

### InstantID Advanced Settings:

- **IP-Adapter Weight**: 0.8-1.0 (controls face similarity)
- **ControlNet Weight**: 0.6-0.8 (controls pose preservation)
- **Noise Injection**: 35% (default, reduces "burn" effect)

## Important Notes

### ⚠️ Limitations:
- **SDXL Only**: InstantID does NOT work with FLUX models
- Your existing IP-Adapter-Flux is for FLUX workflows
- You'll need SDXL checkpoints for face swapping

### Recommended Workflows:
1. **Face Swap**: Use InstantID (SDXL)
2. **General Generation**: Use FLUX with your existing setup
3. **Face Enhancement**: Use Impact Pack (works with both)

### Example Workflow Files:
- Check `ComfyUI/custom_nodes/ComfyUI_InstantID/examples/`
- Load `instantid_basic_workflow.jpg` into ComfyUI

## Next Steps

1. **Download SDXL Model** (if you don't have one):
   - Recommended: SDXL 1.0 base or SDXL Turbo/Lightning
   - Place in `ComfyUI/models/checkpoints/`

2. **Test the Setup**:
   - Restart ComfyUI
   - Load example workflow
   - Test with a face image

3. **Optimize Settings**:
   - Start with CFG: 4.5
   - IP-Adapter strength: 0.8
   - ControlNet strength: 0.7
   - Adjust based on results

## Troubleshooting

### If you get errors on startup:
- Make sure all models are in correct folders
- Restart ComfyUI completely
- Check console for specific error messages

### If faces don't look good:
- Lower CFG (most common issue)
- Add FaceDetailer post-processing
- Try different SDXL checkpoints
- Adjust IP-Adapter weight

### If it's too slow:
- Your RTX 3090 should handle this fine
- Make sure onnxruntime-gpu is being used
- Check GPU utilization in task manager

## Files Created:
- `download_instantid_models.py` - Model download script
- `INSTANTID_SETUP.md` - This guide

---

**Setup completed successfully! Restart ComfyUI to load InstantID nodes.**
