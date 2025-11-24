# Meta-Orchestrator Modes - Quick Reference Card

**Date**: November 24, 2025

---

## 🎯 Quick Decision Guide

**Ask yourself two questions:**

1. **Did I change `app_intent.md`?** (Yes/No)
2. **Did I update meta-orchestrator engine files?** (Yes/No)

Then use this table:

| Changed `app_intent.md`? | Updated Engine? | Mode | What Happens |
|--------------------------|-----------------|------|--------------|
| ❌ No | ❌ No | **NO-OP** | Nothing (exits immediately) |
| ✅ Yes | ❌ No | **MAINTENANCE** | Adds/removes app features |
| ❌ No | ✅ Yes | **ENGINE UPGRADE** | Adds meta-orchestrator capabilities |
| ✅ Yes | ✅ Yes | **HYBRID** | Does BOTH (engine first, then app) |

---

## 📋 Mode Details

### Mode 1: NO-OP ⏭️
**When**: App is current, nothing changed  
**Trigger**: `.meta-version` == `VERSION` && `app_intent.md` unchanged  
**Action**: Exits immediately with message  
**Files Changed**: None  

**Example**:
```bash
$ codex exec "Act as meta-orchestrator..."
✅ App is up-to-date. To add features, edit app_intent.md.
```

---

### Mode 2: MAINTENANCE 🔧
**When**: You want to add/remove features from existing app  
**Trigger**: `.meta-version` == `VERSION` && `app_intent.md` **CHANGED**  
**Action**: Re-runs requirements discovery, generates new LEGOs  
**Files Changed**: New app LEGOs, tests, updated `lego_plan.json`, `.meta-manifest.json`  
**Files Protected**: Anything marked `user_modified: true`  

**Example**:
```bash
# Edit app_intent.md to add crypto support
$ vim app_intent.md

$ codex exec "Act as meta-orchestrator..."
📝 MAINTENANCE MODE: Detected changes to app_intent.md
Generating new LEGOs for crypto support...
✅ Done. Added src/crypto_fetcher.py, src/crypto_analyzer.py
```

**Real-World Scenarios**:
- Add new feature (crypto support to stock analyzer)
- Remove deprecated feature (old API integration)
- Fix bugs in existing feature (improve data validation)
- Change behavior (switch from REST to GraphQL)

---

### Mode 3: ENGINE UPGRADE ⬆️
**When**: You want to adopt new meta-orchestrator capabilities  
**Trigger**: `.meta-version` < `VERSION` && `app_intent.md` unchanged  
**Action**: Adds new engine LEGOs (config_validator, observability, etc.)  
**Files Changed**: New engine LEGOs, tests, `.meta-version`, `.meta-manifest.json`  
**Files Protected**: All app logic (your LEGOs stay untouched)  

**Example**:
```bash
# Copy new meta-orchestrator files (VERSION now 1.2.0)
$ cp /path/to/new-meta/VERSION .

$ codex exec "Act as meta-orchestrator..."
⬆️ ENGINE UPGRADE MODE: 1.1.0 → 1.2.0

Upgrade Plan:
✅ New features: observability, health checks
📦 Will add: src/observability.py, tests/test_observability.py
⚠️ Protected: src/stock_analyzer.py (user_modified: true)

Approve? (y/n): y
✅ Done. Upgraded to v1.2.0 with observability.
```

**Real-World Scenarios**:
- v1.0.0 → v1.1.0: Add config_validation LEGO
- v1.1.0 → v1.2.0: Add observability LEGO
- v1.2.0 → v1.3.0: Add rate_limiter LEGO
- Any engine improvement that benefits all apps

---

### Mode 4: HYBRID 🔀
**When**: You want BOTH engine upgrades AND app changes  
**Trigger**: `.meta-version` < `VERSION` && `app_intent.md` **CHANGED**  
**Action**: Phase A (engine upgrade) then Phase B (maintenance)  
**Files Changed**: Engine LEGOs + App LEGOs, `.meta-version`, `.meta-manifest.json`  

**Example**:
```bash
# Update engine AND edit app_intent.md
$ cp /path/to/new-meta/VERSION .  # Now 1.2.0
$ vim app_intent.md                # Add crypto support

$ codex exec "Act as meta-orchestrator..."
🔀 HYBRID MODE: Engine upgrade + app changes

Phase A (Engine Upgrade 1.1.0 → 1.2.0):
  - Add observability.py

Phase B (Maintenance):
  - Add crypto_fetcher.py, crypto_analyzer.py

Combined: 3 new files, 1 modified file
Approve? (y/n): y

Phase A: ✅ Added observability
Phase B: ✅ Added crypto support
✅ Done. Upgraded to v1.2.0 with crypto support.
```

**Real-World Scenarios**:
- Upgrade engine + add new feature at same time
- Catch up on multiple engine versions + refactor app
- Adopt best practices (engine) + expand functionality (app)

---

## 🔍 How Meta-Orchestrator Detects Mode

```python
# Pseudocode
if not os.path.exists('.meta-version'):
    return Mode.NEW_APP
    
app_version = read('.meta-version')['meta_orchestrator_version']
engine_version = read('VERSION').strip()
app_intent_changed = has_changed_since_last_run('app_intent.md')

if app_version == engine_version:
    if app_intent_changed:
        return Mode.MAINTENANCE  # Add/remove app features
    else:
        return Mode.NO_OP         # Nothing to do
else:  # app_version < engine_version
    if app_intent_changed:
        return Mode.HYBRID        # Engine upgrade + maintenance
    else:
        return Mode.ENGINE_UPGRADE  # Just adopt new engine features
```

---

## 📦 What Gets Changed in Each Mode

### NEW APP MODE
- ✅ Creates: Everything (requirements.md, src/, tests/, docs/)
- ✅ Writes: `.meta-version`, `.meta-manifest.json`

### NO-OP MODE
- ❌ Changes: Nothing
- ℹ️ Exits: Immediately

### MAINTENANCE MODE
- ✅ Updates: `requirements.md`, `lego_plan.json`
- ✅ Creates: New app LEGOs, new tests
- ✅ Updates: `.meta-manifest.json`
- ❌ Skips: Files where `user_modified: true`
- ❌ Does NOT update: `.meta-version` (stays same)

### ENGINE UPGRADE MODE
- ✅ Creates: New engine LEGOs (config_validator, observability, etc.)
- ✅ Updates: `lego_plan.json`, `.meta-version`, `.meta-manifest.json`
- ❌ Does NOT touch: App logic LEGOs, `app_intent.md`

### HYBRID MODE
- ✅ Creates: New engine LEGOs + new app LEGOs
- ✅ Updates: `requirements.md`, `lego_plan.json`, `.meta-version`, `.meta-manifest.json`
- ❌ Skips: Files where `user_modified: true`

---

## 🛡️ File Protection Rules

### Always Protected (Never Regenerated)
Files where `.meta-manifest.json` has `"user_modified": true`:
- Your custom business logic
- Manual configuration tweaks
- Custom tests you wrote

### Always Regenerable
Files where `.meta-manifest.json` has `"regenerate_on_upgrade": true`:
- `requirements.md` (can expand with new requirements)
- `lego_plan.json` (architecture definition)
- `dependencies.md`, `external_services.md` (documentation)

### Generated Once, Then Yours
Files like `.env.example`, `main.py` (initial scaffold):
- Generated in NEW APP MODE
- Marked `user_modified: false` initially
- If you edit them, manually update `.meta-manifest.json` to `user_modified: true`

---

## 🚀 Common Workflows

### Workflow 1: Add Feature to Existing App
```bash
# 1. Edit app_intent.md with new feature
vim app_intent.md

# 2. Run meta-orchestrator (triggers MAINTENANCE MODE)
codex exec "Act as meta-orchestrator..."

# 3. Review generated files
git diff

# 4. Test
pytest

# 5. Commit
git add . && git commit -m "Add crypto support"
```

### Workflow 2: Upgrade to New Meta-Orchestrator Version
```bash
# 1. Backup
cp -r my-app my-app-backup

# 2. Update engine files
cp -r /path/to/new-meta/* .

# 3. Run meta-orchestrator (triggers ENGINE UPGRADE MODE)
codex exec "Act as meta-orchestrator..."

# 4. Review upgrade plan, approve
# (meta-orchestrator shows plan and waits for "y")

# 5. Test
pytest

# 6. Commit
git add . && git commit -m "Upgrade to meta-orchestrator v1.2.0"
```

### Workflow 3: Both Engine Upgrade + New Feature
```bash
# 1. Update engine files
cp -r /path/to/new-meta/* .

# 2. Edit app_intent.md
vim app_intent.md

# 3. Run meta-orchestrator (triggers HYBRID MODE)
codex exec "Act as meta-orchestrator..."

# 4. Review combined plan, approve

# 5. Test
pytest

# 6. Commit
git add . && git commit -m "Upgrade to v1.2.0 and add crypto support"
```

---

## 🆘 Troubleshooting

**Q: Meta-orchestrator says "NO-OP" but I changed app_intent.md!**

A: Check if `app_intent.md` is actually tracked in `.meta-manifest.json`. Meta uses file modification timestamps or git status to detect changes.

**Q: Meta-orchestrator overwrote my custom code!**

A: You forgot to mark it in `.meta-manifest.json`:
```json
{"files": {"src/custom.py": {"user_modified": true}}}
```

**Q: I want to force regenerate a protected file**

A: Edit `.meta-manifest.json` and set `user_modified: false` for that file, then rerun.

**Q: Can I skip ENGINE UPGRADE and only do MAINTENANCE?**

A: Yes! Don't update engine files (keep same VERSION). Just edit `app_intent.md` and run.

**Q: What if I want only specific engine features, not all of them?**

A: During upgrade approval, you can selectively decline features. Or run:
```bash
codex exec "Add only config_validation, skip observability"
```

---

## 📚 See Also

- **`UPGRADING.md`**: Detailed upgrade workflows and examples
- **`QUICKSTART_UPGRADE.md`**: Quick start for existing apps
- **`VERSION_MANAGEMENT_SUMMARY.md`**: High-level overview
- **`AGENTS.md` Section 0**: Version check implementation

---

## 🎯 Summary

**5 Modes**:
1. **NEW APP** - First run, build everything
2. **NO-OP** - Nothing changed, exit
3. **MAINTENANCE** - App features changed
4. **ENGINE UPGRADE** - Meta-orchestrator upgraded
5. **HYBRID** - Both engine + app changed

**Key Files**:
- `VERSION` - Current meta-orchestrator version
- `.meta-version` - What version built this app
- `.meta-manifest.json` - What files are protected
- `app_intent.md` - What the app should do

**Protection**:
- `user_modified: true` = Never regenerate
- `user_modified: false` = Safe to regenerate

**Tip**: Always backup and test on a branch before upgrading!
