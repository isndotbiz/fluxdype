# ComfyUI Custom Nodes Cleanup Guide

## Overview

The `cleanup_custom_nodes.ps1` script safely removes conflicting and redundant custom nodes from your ComfyUI installation. It prioritizes safety by backing up all removed nodes before deletion.

## Script Features

- **Automatic Backups**: All removed nodes are backed up to `custom_nodes_removed_backup/` with timestamps
- **Safe Operations**: Creates backups BEFORE deletion
- **Detailed Logging**: Complete log of all operations in `cleanup_custom_nodes_log.txt`
- **Interactive Confirmation**: Asks for confirmation before making changes (can be bypassed with `-Force`)
- **Core Node Protection**: Prevents accidental removal of essential nodes
- **Color-Coded Output**: Easy to read status messages

## Usage

### Basic Usage (Interactive)

```powershell
cd D:\workspace\fluxdype
.\cleanup_custom_nodes.ps1
```

This will:
1. Display all nodes to be removed (grouped by priority)
2. Show all protected core nodes
3. Ask for confirmation before proceeding
4. Create backups of all nodes
5. Remove the conflicting nodes
6. Log all operations
7. Display final node listing

### Force Mode (No Confirmation)

```powershell
.\cleanup_custom_nodes.ps1 -Force
```

Use this when you're confident about the removal and don't want interactive prompts.

### Skip Backup (NOT RECOMMENDED)

```powershell
.\cleanup_custom_nodes.ps1 -SkipBackup -Force
```

Only use this if you're certain you don't need backups. Once nodes are deleted without backup, recovery is not possible via this script.

## Nodes Being Removed

### HIGH Priority (Flux Workflow Conflicts)

| Node | Reason |
|------|--------|
| **ComfyUI-GGUF** | Conflicts with Turbo LoRA workflows, not needed for Flux |
| **ComfyUI-IPAdapter-Flux** | Superseded by ComfyUI_IPAdapter_plus |
| **controlaltai-nodes** | Unmet dependencies, potential conflicts with Flux workflow |

### MEDIUM Priority (Overlapping Functionality)

| Node | Reason |
|------|--------|
| **ComfyUI_InstantID** | Requires external APIs with authentication conflicts |
| **ComfyUI_Comfyroll_CustomNodes** | Deprecated, overlaps with core node functionality |
| **efficiency-nodes-comfyui** | Deprecated, overlaps with ComfyUI_essentials |
| **ComfyUI_essentials** | Dependency conflicts with recent ComfyUI builds |
| **comfyui_controlnet_aux** | Heavy dependencies, potential VRAM issues with RTX 3090 |

### LOW Priority (Low Utility)

| Node | Reason |
|------|--------|
| **cg-use-everywhere** | Minimal usage, can be re-added if needed |
| **rgthree-comfy** | Overlaps with ComfyUI-Manager functionality |
| **ComfyUI-Custom-Scripts** | Low maintenance, overlaps with other utilities |

## Protected Core Nodes (NEVER Removed)

These nodes are essential for your Flux workflow and will never be removed:

1. **was-node-suite-comfyui** - Comprehensive node suite
2. **ComfyUI-Impact-Pack** - Image processing and analysis
3. **ComfyUI-Inspire-Pack** - Workflow inspirations and templates
4. **multi-lora-stack** - LoRA management (critical for Turbo LoRA)
5. **x-flux-comfyui** - Flux model integration
6. **ComfyUI_IPAdapter_plus** - IP-Adapter integration (replaces Flux version)
7. **ComfyUI_UltimateSDUpscale** - Image upscaling
8. **ComfyUI-RMBG** - Background removal
9. **comfyui-dynamicprompts** - Dynamic prompt generation
10. **ComfyUI-Manager** - Node and dependency management

## What Happens During Cleanup

### Step 1: Validation
- Verifies the custom_nodes directory exists
- Displays all nodes to be removed and protected cores
- Asks for user confirmation (unless `-Force` is used)

### Step 2: Backup Creation
- Creates `D:\workspace\fluxdype\custom_nodes_removed_backup\` directory
- Copies each node to: `custom_nodes_removed_backup\NodeName_YYYYMMdd_HHmmss\`
- Timestamps prevent overwriting previous backups

### Step 3: Node Removal
- Removes each node directory from `ComfyUI\custom_nodes\`
- Logs success/failure for each removal
- Continues even if one node fails to remove

### Step 4: Final Report
- Lists all remaining nodes in the custom_nodes directory
- Shows total removed and skipped counts
- Displays backup location for recovery
- Provides instructions for restoring nodes if needed

### Step 5: Logging
- Creates `cleanup_custom_nodes_log.txt` with detailed operation log
- Documents all backups, removals, and errors
- Timestamp-based organization for future reference

## Recovery: How to Restore Removed Nodes

If you need to restore a removed node:

```powershell
# List available backups
Get-ChildItem "D:\workspace\fluxdype\custom_nodes_removed_backup\"

# Restore a specific node (example: ComfyUI-GGUF)
Copy-Item -Path "D:\workspace\fluxdype\custom_nodes_removed_backup\ComfyUI-GGUF_*" `
          -Destination "D:\workspace\fluxdype\ComfyUI\custom_nodes\ComfyUI-GGUF" `
          -Recurse -Force

# Restart ComfyUI
.\start-comfy.ps1
```

## After Cleanup: Next Steps

1. **Restart ComfyUI Server**
   ```powershell
   # In the ComfyUI terminal, press Ctrl+C to stop
   # Then run:
   .\start-comfy.ps1
   ```

2. **Verify Workflow Compatibility**
   - Test your Turbo LoRA workflows
   - Check that Flux generation still works
   - Verify IP-Adapter functionality

3. **Review Log File**
   ```powershell
   Get-Content "D:\workspace\fluxdype\cleanup_custom_nodes_log.txt"
   ```

4. **Monitor for Issues**
   - If you encounter missing node errors, check the log
   - Restore problematic nodes using the recovery instructions above
   - The backup directory keeps all removed nodes for 30+ days

## Troubleshooting

### "Directory not found" for a node
- The node was already removed or never existed
- Safe to proceed with script; it will skip missing nodes

### ComfyUI Server Won't Start After Cleanup
1. Check the ComfyUI console for missing node errors
2. Note the missing node name
3. Restore it from the backup using recovery instructions
4. Restart ComfyUI

### Need to Undo Everything
1. Stop ComfyUI server
2. Delete the current custom_nodes directory:
   ```powershell
   Remove-Item "D:\workspace\fluxdype\ComfyUI\custom_nodes" -Recurse -Force
   ```
3. Rename the backup directory:
   ```powershell
   Rename-Item -Path "D:\workspace\fluxdype\custom_nodes_removed_backup" `
               -NewName "custom_nodes"
   ```
4. Restart ComfyUI

### Cannot Remove a Specific Node
- Check if the node directory is locked by ComfyUI server
- Stop the ComfyUI server and try again
- If it still fails, manually delete the directory

## Performance Impact After Cleanup

Expected improvements:

- **Faster ComfyUI Startup**: Fewer custom nodes to load
- **Lower Memory Overhead**: Removes heavy dependency packages
- **Reduced Disk I/O**: Smaller custom_nodes directory
- **Better VRAM Utilization**: No conflicting GPU memory allocations
- **Cleaner Logs**: Fewer irrelevant error messages during generation

## Backup Storage

- **Location**: `D:\workspace\fluxdype\custom_nodes_removed_backup\`
- **Retention**: Indefinite (manually delete when safe)
- **Cleanup Option**: Delete old backups after confirming workflows work:
  ```powershell
  Remove-Item "D:\workspace\fluxdype\custom_nodes_removed_backup\*_older_than_7_days" -Recurse -Force
  ```

## Getting Help

If a critical node is missing after cleanup:

1. Check `cleanup_custom_nodes_log.txt` for what was removed
2. Identify which removed node you need
3. Restore using the recovery commands above
4. Consider adding the node back to the protected list in the script

## Script Parameters Reference

```powershell
.\cleanup_custom_nodes.ps1 [-Force] [-SkipBackup]

Parameters:
  -Force          Removes nodes without interactive confirmation
  -SkipBackup     Skips backup creation (NOT RECOMMENDED)
```

## Example Complete Workflow

```powershell
# 1. Review what will be removed (interactive)
.\cleanup_custom_nodes.ps1

# 2. If you want to proceed without confirmation
# Press Ctrl+C to stop and add -Force parameter
.\cleanup_custom_nodes.ps1 -Force

# 3. Wait for completion and read the final report

# 4. Restart ComfyUI server
.\start-comfy.ps1

# 5. Test your workflows in the web UI
# Visit: http://localhost:8188

# 6. Check the log file if anything seems wrong
Get-Content "cleanup_custom_nodes_log.txt" -Tail 50
```

---

**Last Updated**: December 10, 2024
**Script Version**: 1.0
**Target Environment**: ComfyUI with Flux Kria FP8 on RTX 3090
