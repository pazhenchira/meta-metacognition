# v2.0 Upgrade Quick Reference

**For users upgrading existing apps from v1.x to v2.0**

---

## 🚀 3-Step Upgrade

### 1️⃣ Backup (5 seconds)
```bash
cd /path/to/your-app
git tag v1-backup
```

### 2️⃣ Copy Engine (10 seconds)
```bash
cp -r /path/to/meta-metacognition/.meta ./
cat .meta/VERSION  # Verify: 2.0.29
```

### 3️⃣ Run Upgrade (30-60 minutes, automated)

Open app in Codex CLI or GitHub Copilot:
```
Upgrade this app to meta-orchestrator v2.0.29
```

**Done!** ✅

**Note (2.0.29)**:
- Decision-critical apps require **Strategy Gate 0** (STR-XXX) before PM specs.
- Role lock is enforced via `orchestrator_state.json` (`primary_role`, `role_lock`).
- MCP servers are disabled by default; start Codex with `-p <app_slug>` to enable only this app’s servers.
- Consistency audit runs before completion: `python scripts/consistency_audit.py`.
- Triage model routes incidents/bugs without PM gating; features require PM.
- GTM Strategy Owner defines the unified plan before GTM sub-roles run.
- App Orchestrator must use docs/scripts for ops how-to and delegate when MCP subagents are available.

---

## 🔄 What Happens (Automated)

1. **Orchestrator detects** v1.x structure
2. **Shows plan**: Folders to create, files to migrate
3. **Asks approval**: "Proceed? (y/n)"
4. **Creates folders**: `.workspace/`, `legos/`, `specs/`, `docs/user/`, `docs/dev/`
5. **Migrates code**: `src/*.py` → `legos/*/src/`
6. **Generates docs**: README, interface, workflows for each LEGO
7. **Initializes state**: `tracker.json`, `_manifest.json`
8. **Updates imports**: Old paths → new paths
9. **Validates**: Folders exist, files migrated, tests pass
10. **Commits**: Single atomic commit to git
11. **Shows summary**: What changed, what's next

**Time**: 30-60 minutes (mostly automated)

---

## 🛟 Rollback (If Needed)

```bash
git reset --hard v1-backup
```

**That's it!** Back to v1.x instantly.

---

## 📊 Before vs After

### Before (v1.x)
```
my-app/
├── src/
│   ├── config_validator.py
│   └── signal_generator.py
├── tests/
│   └── unit/
│       └── test_config_validator.py
└── docs/
    └── user_guide.md
```

### After (v2.0)
```
my-app/
├── .workspace/
│   └── tracker.json          # ✨ NEW: Work item log
├── legos/
│   ├── _manifest.json        # ✨ NEW: LEGO registry
│   ├── config_validator/
│   │   ├── README.md         # ✨ AUTO-GENERATED
│   │   ├── interface.md      # ✨ AUTO-GENERATED
│   │   ├── workflows.md      # ✨ AUTO-GENERATED
│   │   └── src/
│   │       ├── config_validator.py
│   │       └── tests/        # Co-located
│   └── signal_generator/
│       ├── README.md
│       ├── interface.md
│       ├── workflows.md
│       └── src/
├── specs/                    # ✨ NEW: Immutable specs
│   ├── features/
│   ├── design/
│   └── test_plans/
└── docs/
    ├── user/                 # ✨ SEPARATED
    │   └── user-guide.md
    └── dev/                  # ✨ SEPARATED
        └── architecture.md   # ✨ AUTO-GENERATED
```

---

## 🎯 What You Get

✅ **Self-documenting LEGOs**: Complete docs can regenerate code  
✅ **Work item tracking**: `.workspace/tracker.json` logs all work  
✅ **Multi-role approval**: 5 roles review before promotion  
✅ **Immutable specs**: Read-only after approval  
✅ **Clean workspace**: All WIP in `.workspace/`, deleted after completion  
✅ **Idempotent restart**: Resume from any point without context loss  
✅ **Breaking change detection**: Tests fail immediately, show affected code  

---

## 🆕 New Workflow

### Adding a Feature (v2.0)

**Say**: `"Add sentiment analysis to trading signals"`

**Orchestrator**:
1. Creates WI-001 (work item)
2. PM writes spec → 5 roles review → approved
3. Architect writes design → 5 roles review → approved
4. Developer writes LEGO docs + code → 5 roles review → approved
5. Tester writes tests → 5 roles review → approved
6. Writer writes user docs → 5 roles review → approved
7. Promotes all to `specs/`, `legos/`, `docs/`
8. Deletes `.workspace/WI-001/`
9. Commits to git

**Result**: Feature complete, fully documented, fully tested, fully reviewed!

---

## ❓ FAQ

**Q: Will my app break?**  
A: No! Automated migration preserves all functionality. Tests run after migration to verify.

**Q: Can I rollback?**  
A: Yes! `git reset --hard v1-backup` restores instantly.

**Q: How long does it take?**  
A: 30-60 minutes (mostly automated, you approve and watch).

**Q: What if tests fail after upgrade?**  
A: Usually just import paths. Orchestrator updates them, but manual fixes may be needed.

**Q: Do I have to upgrade?**  
A: No! v1.x continues to work. Upgrade when ready.

**Q: Can I test first?**  
A: Yes! Create branch: `git checkout -b test-v2`, run upgrade, test, rollback if needed.

---

## 📝 Summary

**Upgrade = 3 commands**:
```bash
git tag v1-backup
cp -r /path/to/meta-metacognition/.meta ./
# Say: "Upgrade this app to meta-orchestrator v2.0.29"
```

**Rollback = 1 command**:
```bash
git reset --hard v1-backup
```

**Result**: Workspace-centric, self-documenting, idempotent app! 🚀

---

See **UPGRADING.md** for full details.
