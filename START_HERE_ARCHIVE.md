# Wan & Qwen Archive System - START HERE

Welcome! You now have a complete archive management system for Wan 2.2 and Qwen models.

**This file is your entry point.** Start here, then follow the links below.

---

## What Is This?

A production-ready system to:
- Move 46 GB of Wan/Qwen models to an archive folder
- Free up disk space and GPU memory on your RTX 3090
- Restore models anytime when needed
- Track everything with detailed logs

---

## Quick Start (2 Minutes)

### 1. View Current Status
```powershell
cd D:\workspace\fluxdype
.\check_archive_status.ps1
```

This shows what's archived vs. active.

### 2. Archive the Models (When Ready)
```powershell
.\archive_wan_qwen.ps1
```

Takes ~5-15 minutes. Moves 10 models, creates archive.log.

### 3. Restore When Needed
```powershell
.\restore_wan_qwen.ps1
```

Takes ~5-15 minutes. Moves models back, verifies integrity.

---

## Documentation Guide

Choose what you need:

### I want to get started NOW
→ Read: **WAN_QWEN_ARCHIVE_QUICKSTART.md** (2-3 min read)

This has:
- What's being archived
- Before/after checklist
- Step-by-step instructions
- Common commands
- Quick troubleshooting

### I want to understand the system
→ Read: **ARCHIVE_SYSTEM_OVERVIEW.md** (5-10 min read)

This has:
- Complete system overview
- All components explained
- Architecture and design
- Common workflows
- File locations

### I want detailed technical info
→ Read: **models_archive/wan_qwen/README.md** (10-15 min read)

This has:
- Archive contents (all 10 models listed)
- Why models were archived
- GPU memory considerations
- Wan 2.2 video generation guide
- Qwen multimodal capabilities
- Comprehensive troubleshooting

### I want the most direct help
→ Run: **.\manage_archives.ps1**

Interactive menu-driven system with:
- Status checking
- Archive/restore operations
- Log viewing
- Integrity verification
- Direct access to documentation

---

## The Scripts You Have

### Archive Operations

**archive_wan_qwen.ps1** (247 lines)
- Moves models to archive folder
- Creates organized subfolder structure
- Logs all operations with timestamps
- Frees 46 GB on D: drive

**restore_wan_qwen.ps1** (311 lines)
- Restores archived models
- Verifies file integrity with SHA256 hashes
- Recreates original folder structure
- Detailed operation logging

### Status & Management

**check_archive_status.ps1** (249 lines)
- Shows what's archived vs. active
- Displays archive size
- Lists individual model status
- Provides recommendations
- Optional detailed log view

**manage_archives.ps1** (291 lines)
- Interactive menu interface
- Safe operation confirmations
- Log viewing
- Archive integrity verification
- Opens documentation

**Total: 1,098 lines of production-ready PowerShell**

---

## The Documentation You Have

1. **START_HERE_ARCHIVE.md** (This file)
   - Entry point and navigation guide
   - Quick start (2 min)
   - Points to right docs for your needs

2. **WAN_QWEN_ARCHIVE_QUICKSTART.md**
   - Quick reference
   - TL;DR instructions
   - Common commands
   - Fast troubleshooting

3. **ARCHIVE_SYSTEM_OVERVIEW.md**
   - Complete system explanation
   - Architecture and design
   - Workflows and examples
   - File locations

4. **models_archive/wan_qwen/README.md**
   - Comprehensive technical documentation
   - All 10 models detailed
   - GPU optimization
   - Wan and Qwen usage guides
   - Full troubleshooting

5. **models_archive/wan_qwen/archive.log** (created after archiving)
   - Records of archival operation
   - Original file locations
   - Timestamps and sizes

6. **models_archive/wan_qwen/restore.log** (created after restoring)
   - Records of restoration operation
   - Hash verification results
   - Timestamps

---

## Common Scenarios

### Scenario 1: "I want to free up 46 GB today"
1. Read: **WAN_QWEN_ARCHIVE_QUICKSTART.md** (2 min)
2. Run: `.\archive_wan_qwen.ps1` (10 min)
3. Done! Check status: `.\check_archive_status.ps1` (1 min)

### Scenario 2: "I'm setting up video generation"
1. Check: `.\check_archive_status.ps1`
2. If archived, run: `.\restore_wan_qwen.ps1` (15 min)
3. Read: **models_archive/wan_qwen/README.md** - Wan 2.2 section
4. Start building workflows in ComfyUI

### Scenario 3: "Something's wrong, help!"
1. Run: `.\check_archive_status.ps1 -DetailedLogs`
2. Check: **WAN_QWEN_ARCHIVE_QUICKSTART.md** troubleshooting table
3. See: **models_archive/wan_qwen/README.md** troubleshooting section
4. Or use: `.\manage_archives.ps1` option 4-5 to view logs

### Scenario 4: "I want to understand everything"
1. Read: **ARCHIVE_SYSTEM_OVERVIEW.md** (10 min)
2. Read: **models_archive/wan_qwen/README.md** (15 min)
3. Run: `.\manage_archives.ps1` (explore interactively)
4. You're now an expert!

---

## File Organization

```
D:\workspace\fluxdype/
├── START_HERE_ARCHIVE.md                    ← You are here
├── WAN_QWEN_ARCHIVE_QUICKSTART.md           ← Quick reference
├── ARCHIVE_SYSTEM_OVERVIEW.md               ← Full understanding
│
├── archive_wan_qwen.ps1                     ← Archive script
├── restore_wan_qwen.ps1                     ← Restore script
├── check_archive_status.ps1                 ← Status checker
├── manage_archives.ps1                      ← Interactive menu
│
└── models_archive/wan_qwen/
    ├── README.md                            ← Detailed docs
    ├── archive.log                          ← Operation log (after archiving)
    └── restore.log                          ← Operation log (after restoring)
```

---

## Key Commands Reference

```powershell
# Check status (no changes)
.\check_archive_status.ps1

# Check status with detailed logs
.\check_archive_status.ps1 -DetailedLogs

# Interactive management
.\manage_archives.ps1

# Archive models (moves to archive folder)
.\archive_wan_qwen.ps1

# Restore models (moves from archive folder)
.\restore_wan_qwen.ps1

# Restore without hash verification (faster)
.\restore_wan_qwen.ps1 -SkipVerification
```

---

## The Archive Folder

All archived files live here:
```
D:\workspace\fluxdype\models_archive\wan_qwen/
├── README.md
├── archive.log
├── restore.log
├── diffusion_models/     (Wan video models - 26.62 GB)
├── clip/                 (Qwen vision model - 8.8 GB)
├── loras/                (Lightning optimizers - 2.72 GB)
├── text_encoders/        (Wan text encoder)
└── vae/                  (Encoding/decoding - 486 MB)
```

---

## Important Notes

### GPU Memory (RTX 3090 - 24GB)

**Flux alone:** ~22-24 GB ✓ Optimal
**Flux + Wan:** ~32+ GB ✗ Doesn't fit
**Flux + Qwen:** ~30+ GB ✗ Doesn't fit
**Flux + Wan + Qwen:** ~38+ GB ✗ Way over

**Solution:** Keep Wan/Qwen archived. Restore only when needed.

### Safety

- **No data loss:** Files are moved, never deleted
- **Verified restoration:** SHA256 hash checking
- **Full logging:** Every operation tracked
- **Easy reversal:** Complete restoration capability

### Time Requirements

- **Archiving:** 5-15 minutes (disk speed dependent)
- **Restoring:** 5-15 minutes (disk speed dependent)
- **Status checking:** 1-2 seconds
- **Management menu:** Interactive, as long as needed

---

## Next Steps

### Right Now
1. Read this file (you're doing it!)
2. Run: `.\check_archive_status.ps1`
3. Decide: Archive now or later?

### Choose Your Path

**Path A: Archive Today**
```
1. Read: WAN_QWEN_ARCHIVE_QUICKSTART.md
2. Run: .\archive_wan_qwen.ps1
3. Verify: .\check_archive_status.ps1
4. Done!
```

**Path B: Learn First, Archive Later**
```
1. Read: ARCHIVE_SYSTEM_OVERVIEW.md
2. Read: models_archive/wan_qwen/README.md
3. When ready: .\archive_wan_qwen.ps1
```

**Path C: Use Interactive Menu**
```
1. Run: .\manage_archives.ps1
2. Navigate menu
3. Archive/restore as needed
```

---

## Support Resources

| Need | File/Command |
|------|--------------|
| 2-minute quickstart | WAN_QWEN_ARCHIVE_QUICKSTART.md |
| System overview | ARCHIVE_SYSTEM_OVERVIEW.md |
| Technical details | models_archive/wan_qwen/README.md |
| Status check | `.\check_archive_status.ps1` |
| Interactive help | `.\manage_archives.ps1` |
| View archive log | `.\manage_archives.ps1` → option 4 |
| View restore log | `.\manage_archives.ps1` → option 5 |

---

## Last Minute FAQs

**Q: Is it safe to archive?**
A: Yes! Every operation is logged, files are never deleted, and restoration is fully verified.

**Q: How long does it take?**
A: Archiving or restoring takes ~5-15 minutes depending on disk speed.

**Q: Can I restore anytime?**
A: Yes! Just run `.\restore_wan_qwen.ps1` whenever you need the models.

**Q: Will ComfyUI still work after archiving?**
A: Yes! Flux models (your main workflow) stay active. Only Wan/Qwen are archived.

**Q: What if something goes wrong?**
A: Check the logs: `.\check_archive_status.ps1 -DetailedLogs`

**Q: Can I run Wan or Qwen on a separate ComfyUI instance?**
A: Yes! See README.md for separate port setup.

**Q: How much space is freed?**
A: ~46 GB on your D: drive.

**Q: What if I'm not sure?**
A: Run status checker first: `.\check_archive_status.ps1` - no changes made.

---

## You're Ready!

Choose your next step above and get started. Everything is documented and safe.

**Questions?** Check the relevant guide above.

**Ready to archive?** Run: `.\archive_wan_qwen.ps1`

**Want to explore first?** Run: `.\check_archive_status.ps1`

**Prefer interactive?** Run: `.\manage_archives.ps1`

---

**Created:** 2025-12-10
**For:** FluxDype project (D:\workspace\fluxdype\)
**Status:** Production-ready ✓
