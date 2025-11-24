# Quick Start: Upgrading Existing Apps Built with Old Meta-Orchestrator

**Date**: November 24, 2025

---

## Your Situation

You have an app built with the old meta-orchestrator (before Phase 1 features like session isolation, config validation, etc.) and want to upgrade it to use the new features without breaking your custom changes.

---

## Quick Answer: 3 Options

### Option 1: Keep Separate Workspaces (SAFEST - Recommended)

**Best for**: When you want to test new features without touching existing app.

```bash
# Your existing app stays untouched
cd /path/to/my-existing-app

# Just update app_intent.md and rerun with new meta-orchestrator
# The new meta-orchestrator will respect your existing code
```

**How it works**:
1. Copy new meta-orchestrator files to your existing app directory (or update them in place)
2. Create `.meta-manifest.json` to mark which files you've manually modified
3. Run meta-orchestrator - it will only touch files marked as `user_modified: false`

**Setup**:
```bash
cd /path/to/my-existing-app

# Create manifest to protect your custom files
cat > .meta-manifest.json << 'EOF'
{
  "generated_by": "meta-orchestrator/0.9.0",
  "files": {
    "src/my_custom_feature.py": {"user_modified": true},
    "src/auth.py": {"user_modified": true},
    "tests/test_custom.py": {"user_modified": true}
  }
}
EOF

# Create version marker (0.9.0 = pre-Phase-1)
cat > .meta-version << 'EOF'
{
  "meta_orchestrator_version": "0.9.0",
  "created_date": "2025-11-01",
  "features": ["lego_architecture", "unit_tests"]
}
EOF

# Copy new meta-orchestrator files
cp /path/to/new-meta-metacognition/AGENTS.md .
cp /path/to/new-meta-metacognition/SESSION_ISOLATION.md .
# ... etc for all engine files

# Now run upgrade
codex exec "Act as meta-orchestrator from AGENTS.md. This is UPGRADE MODE. \
  Read .meta-version (current: 0.9.0) and VERSION (target: 1.1.0). \
  Read .meta-manifest.json to see protected files. \
  Generate upgrade plan showing new features (config_validation, session_isolation, integration_tests). \
  Show plan for approval before applying."
```

---

### Option 2: Clean Migration (More Organized)

**Best for**: When you want long-term maintainability with clear engine/app separation.

```bash
# Reorganize into .meta/ directory structure
cd /path/to/my-existing-app

# 1. Create .meta/ directory and move engine files
mkdir .meta
mv AGENTS.md intent.md principles.md meta_config.json .meta/
mv SESSION_ISOLATION.md TESTING_STRATEGY.md CONFIG_VALIDATION.md .meta/
mv agent_runtime.json runtime_adapters/ .meta/
cp /path/to/new-meta-metacognition/VERSION .meta/

# 2. Create versioning files (in root, not .meta/)
cat > .meta-version << 'EOF'
{
  "meta_orchestrator_version": "0.9.0",
  "created_date": "2025-11-01",
  "features": ["lego_architecture", "unit_tests"]
}
EOF

cat > .meta-manifest.json << 'EOF'
{
  "generated_by": "meta-orchestrator/0.9.0",
  "files": {
    "src/auth.py": {"user_modified": true, "generated": "2025-11-01T10:00:00Z"},
    "src/data_layer.py": {"user_modified": true, "generated": "2025-11-01T11:00:00Z"},
    "lego_plan.json": {"user_modified": false, "regenerate_on_upgrade": true}
  }
}
EOF

# 3. Update meta_config.json to point to new structure
# (meta-orchestrator will auto-detect .meta/ directory)

# 4. Run upgrade
codex exec "Act as meta-orchestrator from .meta/AGENTS.md. \
  Upgrade this app from version 0.9.0 to 1.1.0. \
  Generate upgrade plan and show for approval."
```

**Benefits**:
- ✅ Clean separation: `.meta/` = engine, everything else = your app
- ✅ Easy to update engine (just update `.meta/` directory)
- ✅ Can version control `.meta/` separately (git submodule)

---

### Option 3: Start Fresh, Port Custom Code (Nuclear Option)

**Best for**: When existing app has major issues or you want cleanest possible slate.

```bash
# 1. Create new app with new meta-orchestrator
cd /path/to/new-meta-metacognition
cp /path/to/my-existing-app/app_intent.md .

# 2. Run fresh build
codex exec "Act as meta-orchestrator from AGENTS.md. Build app from app_intent.md."

# 3. Manually port your custom features
# (Review differences, copy over custom logic)

# 4. Test everything
pytest
```

---

## What Gets Protected vs. Updated

### Protected (Won't Be Overwritten)

Files where `user_modified: true` in `.meta-manifest.json`:
- ✅ Your custom business logic (e.g., `src/auth.py` if you edited it)
- ✅ Custom tests you wrote
- ✅ Manual configuration changes

### Updated (Safe to Regenerate)

Files where `user_modified: false` or `regenerate_on_upgrade: true`:
- 🔄 `requirements.md` (requirements may expand with new features)
- 🔄 `lego_plan.json` (new LEGOs like config_validator added)
- 🔄 `dependencies.md`, `external_services.md` (documentation)
- 🔄 Generated boilerplate (e.g., initial `main.py` scaffold)

### Added (New Features)

New files from v1.1.0:
- ✨ `src/config_validator.py` (new LEGO)
- ✨ `tests/integration/test_auth_data_layer.py` (integration tests)
- ✨ `tests/system/test_config_validation.py` (system tests)
- ✨ `CONFIGURATION.md` (config documentation)

---

## Example: Protecting Your Custom Auth Logic

Scenario: You built an app with old meta-orchestrator. You manually rewrote `src/auth.py` to use OAuth2 instead of basic auth.

**Before Upgrade**:
```bash
# Mark your custom file as protected
cat > .meta-manifest.json << 'EOF'
{
  "files": {
    "src/auth.py": {
      "generated": "2025-11-01T10:00:00Z",
      "last_modified": "2025-11-15T14:30:00Z",
      "user_modified": true,
      "regenerate_on_upgrade": false,
      "description": "Custom OAuth2 implementation"
    }
  }
}
EOF
```

**During Upgrade**:
```
Meta-orchestrator: "Analyzing upgrade from v0.9.0 to v1.1.0...

Upgrade Plan:
✅ Add config_validator LEGO (new file: src/config_validator.py)
✅ Add integration tests (new files under tests/integration/)
✅ Update lego_plan.json with new LEGOs
⚠️ PROTECTED: src/auth.py (user_modified: true, will NOT regenerate)

Approve? (y/n)"
```

**After Upgrade**:
- ✅ `src/auth.py` unchanged (your OAuth2 logic intact)
- ✅ New `src/config_validator.py` added
- ✅ New integration tests added
- ✅ `lego_plan.json` updated with config_validator LEGO

---

## Testing the Upgrade

```bash
# 1. Upgrade on a branch
git checkout -b upgrade-meta-orchestrator

# 2. Run upgrade
codex exec "Upgrade this app to meta-orchestrator v1.1.0"

# 3. Review what changed
git diff

# 4. Run all tests
pytest

# 5. Check new features work
python src/config_validator.py  # Should validate config
pytest tests/integration/        # New integration tests
pytest tests/system/             # New system tests

# 6. If good, merge
git checkout main
git merge upgrade-meta-orchestrator
```

---

## FAQ

**Q: Will upgrading break my app?**
A: No, if you properly mark user-modified files in `.meta-manifest.json`. The upgrade agent respects `user_modified: true`.

**Q: Can I adopt only specific new features?**
A: Yes! You can ask for incremental upgrades:
```bash
codex exec "Add only config_validation feature to this app, don't touch anything else"
```

**Q: What if I want to regenerate a file I previously modified?**
A: Edit `.meta-manifest.json` and set `"user_modified": false` for that file, then rerun meta-orchestrator.

**Q: How do I know what version built my app?**
A: Check `.meta-version` file in your app root. Compare with `VERSION` file in meta-orchestrator repo.

**Q: Can I have multiple apps using different meta-orchestrator versions?**
A: Yes! Each app has its own `.meta-version`. You can upgrade them independently.

---

## Recommended Workflow

For your existing app:

```bash
# 1. Backup first
cp -r /path/to/my-app /path/to/my-app-backup

# 2. Create protection manifest
cd /path/to/my-app
# Edit .meta-manifest.json to mark your custom files as user_modified: true

# 3. Create version marker
echo '{"meta_orchestrator_version": "0.9.0", "features": []}' > .meta-version

# 4. Test upgrade on branch
git checkout -b test-upgrade

# 5. Copy new meta-orchestrator files
cp /path/to/new-meta-metacognition/AGENTS.md .
# (copy other engine files)

# 6. Run upgrade with approval
codex exec "Act as meta-orchestrator. Upgrade this app from v0.9.0 to v1.1.0. Show plan before applying."

# 7. Review and test
git diff
pytest

# 8. If good, merge
git checkout main
git merge test-upgrade
```

---

## Summary

✅ **Option 1 (Safest)**: Create `.meta-manifest.json` to protect custom files, run upgrade in place  
✅ **Option 2 (Cleanest)**: Reorganize into `.meta/` directory structure, then upgrade  
✅ **Option 3 (Nuclear)**: Rebuild from scratch, manually port custom code  

**Key Files**:
- `.meta-version` → What version built this app
- `.meta-manifest.json` → What files are protected from regeneration
- `VERSION` → Current meta-orchestrator version

**See**: `UPGRADING.md` for detailed upgrade workflows and examples.
