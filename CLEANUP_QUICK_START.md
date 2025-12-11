# Quick Start: Master Cleanup Execution

## Overview

You have accumulated **109 GB of redundant files** that can be safely removed. This guide walks you through the process in 5 minutes.

---

## TL;DR - Quick Commands

### Option 1: Safe Dry-Run (Preview Only - No Changes)
```powershell
cd D:\workspace\fluxdype
.\execute_full_cleanup.ps1 -DryRun
```

### Option 2: Full Cleanup with Confirmations (Recommended)
```powershell
cd D:\workspace\fluxdype
.\execute_full_cleanup.ps1
```

### Option 3: Force Execute All Phases (Fastest)
```powershell
cd D:\workspace\fluxdype
.\execute_full_cleanup.ps1 -Force
```

### Option 4: Skip Specific Phases
```powershell
# Skip Phase 5 (external dirs) - only clean fluxdype folder
.\execute_full_cleanup.ps1 -SkipPhase5

# Skip Phase 1 (model backup) - keep 102 GB backup
.\execute_full_cleanup.ps1 -SkipPhase1

# Combine multiple skips
.\execute_full_cleanup.ps1 -SkipPhase1 -SkipPhase5
```

---

## What Gets Deleted?

### Safe Deletions (108 GB) - Phase 1

| Item | Size | Status | Can Recover? |
|------|------|--------|--------------|
| `venv_3.10_backup/` | 5.6 GB | Old Python | From archive |
| `models_removed_backup/` | 102 GB | Superseded models | Original models still active |
| `.archived_nodes/` | 154 MB | Old custom nodes | Not needed |
| `gguf_conversion/` | 316 MB | Old experiment | Not needed |
| `llama.cpp/` (dup) | 136 MB | Duplicate copy | Original in D:\workspace\llama.cpp\ |

**Risk**: ZERO - All items marked as obsolete

### What Stays (All Active)

- `ComfyUI/` - Complete with all models
- `venv/` - Active Python environment
- `workflows/` - All workflow definitions
- `outputs/` - Generated images

---

## Step-by-Step Execution

### 1. Prepare (2 minutes)

```powershell
# Open PowerShell as Administrator
# Navigate to fluxdype
cd D:\workspace\fluxdype

# Verify you're in the right place
Get-Item .\execute_full_cleanup.ps1
```

### 2. Dry-Run (3 minutes)

```powershell
# Preview what will happen - NO ACTUAL CHANGES
.\execute_full_cleanup.ps1 -DryRun
```

Expected output:
```
[DRY-RUN] Would delete: D:\workspace\fluxdype\venv_3.10_backup (5.6 GB)
[DRY-RUN] Would delete: D:\workspace\fluxdype\models_removed_backup (102 GB)
...
```

### 3. Execute (10 minutes)

```powershell
# Interactive mode - you confirm each phase
.\execute_full_cleanup.ps1
```

Script will ask:
```
Execute Phase 1 - Continue? (yes/no): yes
Archive old documentation? (yes/no): yes
Archive external directories? (yes/no): no  # Skip if you're not sure
```

### 4. Verify (5 minutes)

```powershell
# Restart ComfyUI to verify everything still works
.\start-comfy.ps1

# Test in browser: http://localhost:8188
```

---

## Recovery Options

### If You Delete Something Important

All deleted items are preserved in the archive:
```
D:\AI_CONSOLIDATION_ARCHIVE\
├── fluxdype-models-removed/    ← Old models backup
├── fluxdype-docs/              ← Archived documentation
└── external/                   ← External projects
```

### To Restore Deleted Files

```powershell
# Copy back from archive
Copy-Item "D:\AI_CONSOLIDATION_ARCHIVE\fluxdype-models-removed\*" `
          "D:\workspace\fluxdype\models_removed_backup\" -Recurse
```

---

## Storage Impact

### Before Cleanup
```
D:\workspace\fluxdype: 316 GB
  - 102 GB: Old model backup
  - 109 GB: Other redundant items
  - 105 GB: Active/essential
```

### After Cleanup
```
D:\workspace\fluxdype: 207 GB (-109 GB)
  - All active models: ✓ Preserved
  - ComfyUI: ✓ Fully functional
  - venv: ✓ Active environment
  - Workflows: ✓ All saved
```

### Result
**34.5% reduction in project size**

---

## Common Questions

### Q: Will this break ComfyUI?
**A**: No. ComfyUI and all active models are preserved. Only old backups are deleted.

### Q: Can I recover the deleted models?
**A**: Yes! They're archived in `D:\AI_CONSOLIDATION_ARCHIVE\`. You can restore anytime.

### Q: Should I skip Phase 5 (external dirs)?
**A**: Yes, unless you're certain you don't need `cli/`, `wan-automation/`, or `llama.cpp/`.

### Q: How long does it take?
**A**: ~15-20 minutes total (mostly file I/O). With `-Force` flag, ~5 minutes.

### Q: Do I need to restart ComfyUI?
**A**: No, but it's good practice to test it afterward.

### Q: What if something goes wrong?
**A**: Check the log file and restore from `D:\AI_CONSOLIDATION_ARCHIVE\`.

---

## Recommended Execution Plan

1. **Now**: Read MASTER_CLEANUP_PLAN.md for full details
2. **Day 1**: Run `-DryRun` to preview
3. **Day 2**: Execute main cleanup with `.\execute_full_cleanup.ps1`
4. **Day 2**: Verify ComfyUI still works
5. **Optional**: Later, archive external dirs with `-SkipPhase5 false`

---

## Important Files

| File | Purpose |
|------|---------|
| `MASTER_CLEANUP_PLAN.md` | Full detailed plan |
| `execute_full_cleanup.ps1` | Main cleanup script |
| `CLEANUP_QUICK_START.md` | This file |
| `cleanup_logs/` | Execution logs |

---

## Example Scenarios

### Scenario 1: I'm in a hurry
```powershell
.\execute_full_cleanup.ps1 -Force
# Takes ~5 minutes, no prompts
```

### Scenario 2: I want to be careful
```powershell
.\execute_full_cleanup.ps1 -DryRun
# Preview only - takes ~3 minutes
# Then run again without -DryRun to execute
```

### Scenario 3: I only want to delete backups, not archive docs
```powershell
.\execute_full_cleanup.ps1 -SkipPhase4 -SkipPhase5
# Only does Phase 1-3: Safe deletions and venv cleanup
```

### Scenario 4: I'm nervous about Phase 1
```powershell
.\execute_full_cleanup.ps1 -SkipPhase1
# Skips deletion of venv backup and model backup
# Still does model review, venv cleanup, doc archival
# Recovers: ~100 MB instead of 109 GB
```

---

## Exit Codes

```
0  = Success
1  = Not running as Administrator
2  = Critical error (check log)
```

---

## Support Files

### Log Files
After execution, check:
```
D:\workspace\fluxdype\cleanup_logs\cleanup_YYYYMMDD_HHMMSS.log
D:\workspace\fluxdype\cleanup_logs\storage_stats_YYYYMMDD_HHMMSS.txt
```

### Full Documentation
Read: `D:\workspace\fluxdype\MASTER_CLEANUP_PLAN.md`

---

## Still Uncertain?

Before executing, answer these questions:

1. Do you need the **102 GB model backup**?
   - If NO → Safe to delete (Phase 1)
   - If YES → Keep with `-SkipPhase1`

2. Do you have other active projects in **D:\workspace\cli/**?
   - If NO → Can archive (Phase 5)
   - If YES → Skip Phase 5

3. Do you need all the **50+ documentation files**?
   - If NO → Archive old docs (Phase 4)
   - If YES → Skip Phase 4

4. How much **free space** do you need?
   - 109 GB → Do full cleanup
   - Just clearing venv → Use `-SkipPhase1` only

---

## Next Steps

1. Run: `.\execute_full_cleanup.ps1 -DryRun`
2. Review output
3. Run: `.\execute_full_cleanup.ps1`
4. Test: `.\start-comfy.ps1`
5. Verify: Open http://localhost:8188 in browser

---

**Ready?** Let's clean up!

```powershell
cd D:\workspace\fluxdype
.\execute_full_cleanup.ps1 -DryRun
```

Questions? Check `MASTER_CLEANUP_PLAN.md` for comprehensive details.

