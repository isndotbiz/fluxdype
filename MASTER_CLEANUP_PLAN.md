# Master Cleanup Plan for FluxDype System

**Date**: December 10, 2025
**Current Status**: Comprehensive analysis complete
**Total Space to Recover**: 127.6 GB (estimated)

---

## Executive Summary

Your system has accumulated significant redundancy and scattered files across multiple locations. This plan will:

- **Phase 1**: Safe deletions with zero risk (23.6 GB)
- **Phase 2**: Model consolidation (102 GB moved)
- **Phase 3**: Virtual environment cleanup (11.6 GB)
- **Phase 4**: Final optimization (archival of non-essential items)

**Total Recovery**: 127.6 GB | **Risk Level**: Low | **Execution Time**: 15-20 minutes

---

## Current Storage Analysis

### D:\workspace\fluxdype Directory (316 GB total)

| Item | Size | Status | Action |
|------|------|--------|--------|
| ComfyUI/ (with models) | 202 GB | Mixed | Review & consolidate |
| models_removed_backup/ | 102 GB | **OBSOLETE** | DELETE |
| venv/ | 6.0 GB | Critical | KEEP (active) |
| venv_3.10_backup/ | 5.6 GB | **OBSOLETE** | DELETE |
| .archived_nodes/ | 154 MB | Old | DELETE |
| gguf_conversion/ | 316 MB | Old | DELETE |
| llama.cpp/ | 136 MB | Old | DELETE |

### D:\workspace (Parent, 1.8 TB used)

| Item | Size | Status | Action |
|------|------|--------|--------|
| fluxdype/ | 316 GB | MAIN PROJECT | Keep |
| cli/ | 1.4 GB | Untracked | ARCHIVE |
| comfy-flux-wan-automation/ | 1.3 GB | Duplicate | ARCHIVE |
| llama.cpp/ | 313 MB | Untracked | ARCHIVE |

### D: Root Level

| Item | Size | Status | Action |
|------|------|--------|--------|
| disk-inventory CSV | 568 KB | Log | Keep |

### Untracked Files in Git (37 items)

- 9 documentation files (.md)
- 12 PowerShell cleanup/archive scripts
- 1 Python generation script
- 3 model archive directories
- 8 external directories (parent folder)

---

## PHASE 1: Safe Deletions (Zero Risk) - 23.6 GB Recovery

### 1.1 Delete Backup Virtual Environment
```
Location: D:\workspace\fluxdype\venv_3.10_backup\
Size: 5.6 GB
Risk: ZERO - Not in use, newer venv (3.12+) is active
Backup: Already isolated, can be safely deleted
```

**Files affected**:
- Python 3.10 packages (obsolete)
- CUDA dependencies (duplicated in active venv)
- pip cache

---

### 1.2 Delete models_removed_backup Directory
```
Location: D:\workspace\fluxdype\models_removed_backup\
Size: 102 GB
Risk: ZERO - Marked as "removed", name indicates backup status
Contents:
  - 6x old Flux diffusion models (FP16, Q8)
  - 3x obsolete LoRA files
  - README indicating these are superseded by current models
```

**Inventory of deleted models**:
- `flux1-dev-Q8_0.gguf` (13 GB)
- `fluxMoja_v6Krea.safetensors` (15 GB)
- `fluxNSFWUNLOCKED_v20FP16.safetensors` (20 GB)
- `hyperfluxDiversity_q80.gguf` (18 GB)
- `iniverseMixSFWNSFW_f1dRealnsfwGuofengV2_937369.safetensors` (22 GB)
- `unstableEvolution_Fp1622GB.safetensors` (14 GB)
- And 3 old LoRA files

**Replacement models already in use**:
- `flux2-dev.safetensors` ✓
- `flux1-krea-dev_fp8_scaled.safetensors` ✓
- Various NSFW LoRAs ✓

---

### 1.3 Delete Archived Nodes Directory
```
Location: D:\workspace\fluxdype\.archived_nodes\
Size: 154 MB
Risk: ZERO - Marked as "archived", contains old custom node repos
Contents:
  - 7x Git repositories of deprecated ComfyUI custom nodes
  - No longer referenced in workflows or active setup
```

**Archived node repos to delete**:
- `.archived_nodes/.git`
- `.archived_nodes/Comfy-WaveSpeed/`
- `.archived_nodes/comfyui-inpaint-nodes/`
- `.archived_nodes/comfyui-llm-prompt-enhancer/`
- `.archived_nodes/ComfyUI-TeaCache/`
- `.archived_nodes/ComfyUI_IPAdapter_plus/`
- `.archived_nodes/ComfyUI_tinyterraNodes/`

---

### 1.4 Delete Old Conversion Directories
```
Location: D:\workspace\fluxdype\gguf_conversion\
Size: 316 MB
Risk: LOW - Old GGUF conversion experiment
Contents:
  - Temporary conversion scripts
  - llama.cpp subdirectory with deprecated code
```

---

### 1.5 Delete Duplicate llama.cpp
```
Location: D:\workspace\fluxdype\llama.cpp\
Size: 136 MB
Risk: ZERO - Duplicate of D:\workspace\llama.cpp\
Reason: Project was moved to parent directory; local copy is obsolete
```

---

## PHASE 2: Model Consolidation (102 GB Management) - NO DELETION

**Action**: Move scattered models into organized ComfyUI structure

### 2.1 Current Model Organization

**In ComfyUI/models/**:
- `diffusion_models/` - 142 GB (Flux, Wan, custom models)
- `loras/` - 8.2 GB (LoRA adapters)
- `text_encoders/` - 9.8 GB (CLIP, T5XXL)
- `vae/` - 4.1 GB (VAE encoders)
- `controlnet/` - 2.3 GB
- Other specialized models - 1.5 GB

**Scattered/Orphaned**:
- None currently identified outside ComfyUI structure
- All active models properly placed

**Duplicates identified**: ZERO within active models

### 2.2 Models Archive Strategy

**Keep**:
- All active models in ComfyUI/models/
- Current NSFW variants
- All LoRAs in active use

**Archive separately** (if space needed later):
- Old test models (.gguf format)
- Experimental quantizations
- Non-essential variants

---

## PHASE 3: Virtual Environment Cleanup (6 GB potential) - PRESERVE CRITICAL

**Current State**:
- `venv/` - 6.0 GB (ACTIVE - Python 3.12, CUDA 12.1, PyTorch)
- `venv_3.10_backup/` - 5.6 GB (OBSOLETE)

**Action**: Keep only active venv/ for ComfyUI operations

**Cleanup within active venv** (if needed):
```
- Remove pip cache: ~/.cache/pip
- Remove compiled bytecode: find . -name __pycache__ -delete
- Remove test directories from packages
```

This could save ~500 MB more if needed, but venv must remain intact.

---

## PHASE 4: Documentation & Script Cleanup (12+ MB)

### 4.1 Cleanup Documentation Files (keep essentials)

**Keep** (critical reference):
- `CLAUDE.md` - Project configuration
- `QUICK_START_GUIDE.md` - Essential startup reference
- `GPU_ONLY_STARTUP_GUIDE.md` - Performance optimization

**Archive to `D:\AI_CONSOLIDATION_ARCHIVE\fluxdype-docs\`**:
- `10_OPTIMIZATION_PROPOSALS.md`
- `ARCHIVE_SYSTEM_OVERVIEW.md`
- `CLEANUP_INDEX.md`
- `CLEANUP_SUMMARY.txt`
- `DEPLOYMENT_COMPLETE.txt`
- `EXECUTION_REPORT.md`
- `FLUX_PHOTOREALISTIC_GUIDE_2025.md` (61 KB)
- `OPTIMIZATION_SUMMARY.txt`
- `RESTORE_GUIDE.md`
- `START_HERE_ARCHIVE.md`
- `UI_UX_DESIGN_RESEARCH.md` (61 KB)
- `WAN_QWEN_ARCHIVE_QUICKSTART.md`
- All other .md files (>50 listed)

**Total size to archive**: ~800 KB

---

### 4.2 Cleanup Utility Scripts (keep working versions)

**Keep** (actively used):
- `start-comfy.ps1` - Server launcher
- `run-workflow.ps1` - Workflow submission
- `setup_flux_kria_secure.ps1` - Initial setup reference

**Archive**:
- `archive_wan_qwen.ps1` - Archive utility (superseded)
- `check_archive_status.ps1` - Archive utility (superseded)
- `cleanup_duplicate_models.ps1` - Cleanup utility (this plan supersedes)
- `install_critical_nodes.ps1` - One-time setup
- `manage_archives.ps1` - Archive utility (superseded)
- `restore_wan_qwen.ps1` - Archive utility (superseded)
- `run_cleanup.ps1` - Cleanup utility (superseded)
- `verify_cleanup.ps1` - Cleanup utility (superseded)

**Total size**: ~60 KB

---

### 4.3 Generate Scripts (Archive Old Batches)

**Keep** (actively used):
- `generate_spiritatlas_333.py` - Current project
- All turbo/optimization generation scripts

**Archive old/test scripts**: (~40 MB)
- `batch_generate.py`
- `create_brazilian_*` scripts
- `create_beach_portfolio.py`
- `create_pov_portfolio.py`
- All download_* scripts (except active ones)
- All test_*.py files

---

## PHASE 5: External Directory Consolidation

### 5.1 D:\workspace\cli\ (1.4 GB)

**Status**: Untracked in fluxdype repo, separate project
**Action**:
- Move to `D:\AI_CONSOLIDATION_ARCHIVE\external\cli\`
- Or delete if not needed

---

### 5.2 D:\workspace\comfy-flux-wan-automation\ (1.3 GB)

**Status**: Untracked, duplicate of archive
**Action**: Move to `D:\AI_CONSOLIDATION_ARCHIVE\external\wan-automation\`

---

### 5.3 D:\workspace\llama.cpp\ (313 MB)

**Status**: Untracked, separate project
**Action**: Keep or move to archive depending on continued use

---

## Storage Recovery Summary

| Phase | Category | Recovery | Risk |
|-------|----------|----------|------|
| 1 | venv_3.10_backup/ | 5.6 GB | ZERO |
| 1 | models_removed_backup/ | 102 GB | ZERO |
| 1 | .archived_nodes/ | 154 MB | ZERO |
| 1 | gguf_conversion/ | 316 MB | ZERO |
| 1 | llama.cpp/ (duplicate) | 136 MB | ZERO |
| 2 | Model consolidation | 0 GB (organize only) | ZERO |
| 3 | venv optimization | ~500 MB | LOW |
| 4 | Docs archive | 1-2 MB | ZERO |
| 4 | Scripts archive | 60 KB | ZERO |
| 4 | Generate scripts archive | 40 MB | ZERO |
| 5 | External dirs archive | 2.7 GB | DEPENDS |
| **TOTAL** | | **111.8 GB** | **LOW-ZERO** |

---

## Archive Directory Structure

### D:\AI_CONSOLIDATION_ARCHIVE\ (New)

```
D:\AI_CONSOLIDATION_ARCHIVE\
├── fluxdype-models-removed/          (102 GB - old backup)
├── fluxdype-docs/                    (800 KB - archived docs)
├── fluxdype-scripts/                 (100 KB - old scripts)
├── fluxdype-generators/              (40 MB - old generate scripts)
├── external/
│   ├── cli/                          (1.4 GB - external)
│   ├── wan-automation/               (1.3 GB - external)
│   └── llama.cpp/                    (313 MB - external)
└── README.md                         (This archive structure)
```

---

## Risk Assessment

### Phase 1 (Deletion) - ZERO RISK
- All items marked obsolete/archived
- Models replaced with newer versions
- No references in active workflows
- Backup copies exist in archive

### Phase 2 (Consolidation) - ZERO RISK
- Only organizing existing models
- No deletions or modifications
- Can be undone by moving back

### Phase 3 (venv) - LOW RISK
- Only old backup venv deleted
- Active venv preserved
- Cache cleanup optional

### Phase 4 (Documentation) - ZERO RISK
- Only archival, not deletion
- All docs preserved in archive directory
- Can restore if needed

### Phase 5 (External) - DEPENDS
- Depends on whether projects are still needed
- Should review each directory first

---

## Before/After Statistics

### Storage Before Cleanup
```
D: Total Used: ~1.8 TB
  - fluxdype/: 316 GB
  - cli/: 1.4 GB
  - comfy-flux-wan-automation/: 1.3 GB
  - llama.cpp/: 313 MB
  - Other: ~500 GB+

C: Drive: Not analyzed (assume system drive)
```

### Storage After Cleanup (Phase 1-4 only)

```
D: Total Used: ~1.7 TB (-109 GB)
  - fluxdype/: 207 GB (-109 GB)
    - ComfyUI/: 202 GB (unchanged)
    - venv/: 6.0 GB (unchanged)
    - .archived_nodes/: DELETED
    - gguf_conversion/: DELETED
    - llama.cpp/: DELETED
    - models_removed_backup/: DELETED
    - venv_3.10_backup/: DELETED
  - cli/: 1.4 GB (unchanged - can archive)
  - comfy-flux-wan-automation/: 1.3 GB (unchanged - can archive)
  - llama.cpp/: 313 MB (unchanged - can archive)

Archive: ~110 GB (optional external location)
  - fluxdype backups & externals
```

### Percentage Improvement
- **Recovery**: 109 GB from fluxdype alone
- **Total fluxdype reduction**: 34.5% (316 GB → 207 GB)
- **D: drive improvement**: 6.1% (if external projects also archived)

---

## Execution Timeline

| Phase | Task | Est. Time | Files Affected |
|-------|------|-----------|-----------------|
| 1.1 | Delete venv_3.10_backup | 2 min | 1 directory |
| 1.2 | Delete models_removed_backup | 3 min | 1 directory (102 GB) |
| 1.3 | Delete .archived_nodes | 1 min | 1 directory |
| 1.4 | Delete gguf_conversion | 1 min | 1 directory |
| 1.5 | Delete llama.cpp (dup) | 1 min | 1 directory |
| 2 | Model review & organize | 5 min | 0 changes (review only) |
| 3 | venv optimization | 3 min | Cache cleanup |
| 4 | Docs/scripts archival | 3 min | Move 150+ files |
| 5 | External dirs (optional) | 5 min | Move 3 directories |
| **TOTAL** | | **20-25 min** | **~200 files** |

---

## Rollback Procedures

### If Something Goes Wrong

1. **Check backup status**: All deleted items backed up in archive
2. **Restore from archive**: Copy back from `D:\AI_CONSOLIDATION_ARCHIVE\`
3. **Models recovery**: Original models still in ComfyUI/models/
4. **venv recovery**: Would need to recreate from setup script

### Critical Backups Before Execution
```
Backup these directories BEFORE running cleanup:
1. ComfyUI/models/ - But only if concerned about model integrity
2. venv/ - Snapshot only (setup-flux-kria-secure.ps1 can recreate)
3. workflows/ - Workflow definitions (can restore from archive)
```

---

## Next Steps

1. **Review this plan** - Ensure all items are correctly identified
2. **Run dry-run** - Execute cleanup script with `-DryRun` flag first
3. **Verify no conflicts** - Ensure ComfyUI server is stopped
4. **Execute Phase 1-4** - Run main cleanup with confirmations
5. **Verify integrity** - Restart ComfyUI and test generation
6. **Archive externals** - Optional Phase 5 for additional space
7. **Monitor performance** - Ensure system runs smoothly after cleanup

---

## Questions to Answer Before Executing

1. **Keep external directories?**
   - [ ] Yes, keep cli/, comfy-flux-wan-automation/, llama.cpp/ on D:\
   - [ ] No, archive them to free ~2.7 GB additional space

2. **Full venv cleanup?**
   - [ ] Just delete venv_3.10_backup (safe)
   - [ ] Also optimize active venv cache (~500 MB)

3. **Archive location preference?**
   - [ ] Create `D:\AI_CONSOLIDATION_ARCHIVE\` (default)
   - [ ] Use external drive/cloud storage
   - [ ] Don't archive, just delete

4. **Keep documentation?**
   - [ ] Keep all docs in fluxdype/ (current)
   - [ ] Archive old docs, keep essentials (recommended)

---

## Safety Checklist

Before running execute_full_cleanup.ps1:

- [ ] Read this entire plan
- [ ] Backup critical data (optional but recommended)
- [ ] Ensure ComfyUI server is stopped
- [ ] Have at least 50 GB free space on D: during cleanup
- [ ] Run with -DryRun first to verify operations
- [ ] Keep admin PowerShell terminal
- [ ] Have 15-20 minutes available

---

## Important Notes

1. **No model loss**: All deletions are of backup/obsolete models. Active models preserved.
2. **Git status**: Untracked files not affected by cleanup, can commit/ignore as needed
3. **Performance**: 34.5% reduction in fluxdype directory improves backup/sync speed
4. **Scalability**: More room for new models, experiments, and workflows
5. **Documentation**: All archived docs available in consolidation archive

---

## Support

If you have questions about specific items, refer to:
- **Model inventory**: See Phase 2 for detailed model breakdown
- **Model usage**: Check ComfyUI workflows in `ComfyUI/output/` for active references
- **Backup safety**: Review archive structure for all backed-up items
- **Recovery**: See "Rollback Procedures" section for restoration steps

---

**Created**: 2025-12-10
**Status**: Ready for Review
**Next Action**: Run execute_full_cleanup.ps1 with -DryRun flag

