# Version Management System - Summary

**Date**: November 24, 2025  
**Version**: 1.1.0

---

## What Problem Does This Solve?

You built an app with meta-orchestrator v1.0. Now v1.1 is out with new features (session isolation, config validation, integration tests). How do you:

1. ✅ **Upgrade** your existing app to use new features
2. ✅ **Protect** your custom code changes from being overwritten
3. ✅ **Track** what version built your app
4. ✅ **Adopt** new features incrementally (not all-or-nothing)

---

## Solution Overview

### Three Key Files

1. **`VERSION`** (in meta-orchestrator repo)
   ```
   1.1.0
   ```
   Current version of the meta-orchestrator engine.

2. **`.meta-version`** (in your app root)
   ```json
   {
     "meta_orchestrator_version": "1.0.0",
     "created_date": "2025-11-15",
     "features": ["lego_architecture", "unit_tests"]
   }
   ```
   What version of meta-orchestrator built your app.

3. **`.meta-manifest.json`** (in your app root)
   ```json
   {
     "files": {
       "src/auth.py": {
         "generated": "2025-11-15T10:00:00Z",
         "last_modified": "2025-11-20T14:00:00Z",
         "user_modified": true,
         "regenerate_on_upgrade": false
       }
     }
   }
   ```
   Which files you've manually modified (protected from regeneration).

---

## How It Works

### Decision Matrix (4 Modes)

| Scenario | `.meta-version` | `VERSION` | `app_intent.md` | Mode | What Changes |
|----------|-----------------|-----------|-----------------|------|--------------|
| First time | Does not exist | 1.1.0 | New | **NEW APP** | Everything built from scratch |
| No changes | 1.1.0 | 1.1.0 | Unchanged | **NO-OP** | Nothing (exit immediately) |
| Add feature | 1.1.0 | 1.1.0 | Changed | **MAINTENANCE** | New app LEGOs only |
| Engine upgrade | 1.0.0 | 1.1.0 | Unchanged | **ENGINE UPGRADE** | New engine LEGOs only |
| Both | 1.0.0 | 1.1.0 | Changed | **HYBRID** | Engine LEGOs + App LEGOs |

### Visual Flow (All 5 Modes)

```
User runs meta-orchestrator
         │
         ▼
   ┌─────────────┐
   │.meta-version│
   │  exists?    │
   └─────┬───────┘
         │
    ┌────┴────┐
    │         │
   NO        YES
    │         │
    ▼         ▼
┌───────┐  ┌──────────────┐
│NEW APP│  │ Read versions│
│       │  │ & app_intent │
│Build  │  └──────┬───────┘
│from   │         │
│scratch│    ┌────┴────────────────┐
│       │    │Compare .meta-version│
│Write  │    │vs VERSION           │
│.meta- │    └────┬────────────────┘
│version│         │
└───────┘    ┌────┴─────┐
            │          │
         SAME        DIFFERENT
            │          │
            ▼          ▼
    ┌───────────┐  ┌────────────┐
    │Check      │  │Check       │
    │app_intent │  │app_intent  │
    └─────┬─────┘  └──────┬─────┘
          │               │
     ┌────┴───┐      ┌────┴───┐
     │        │      │        │
  UNCHANGED CHANGED UNCHANGED CHANGED
     │        │      │        │
     ▼        ▼      ▼        ▼
  ┌──────┐ ┌───────┐ ┌──────┐ ┌──────┐
  │NO-OP │ │MAINT  │ │ENGINE│ │HYBRID│
  │      │ │       │ │UPGRADE│      │
  │Exit  │ │Add app│ │Add    │ │Do   │
  │      │ │features│ │engine │ │both │
  │      │ │       │ │features│ │in   │
  │      │ │Update │ │       │ │order│
  │      │ │.meta- │ │Update │ │     │
  │      │ │manifest│ │.meta- │ │Update│
  │      │ │       │ │version│ │both │
  └──────┘ └───────┘ └──────┘ └──────┘
```

### Real Examples

#### Example 1: NO-OP MODE
```
You: "Run meta-orchestrator"
Meta: [Checks .meta-version: 1.1.0, VERSION: 1.1.0, app_intent.md: unchanged]
Meta: "✅ App is up-to-date. Nothing to do."
Meta: [Exits]
```

#### Example 2: MAINTENANCE MODE (Add Crypto to Stock Analyzer)
```
You: [Edit app_intent.md to add "Support Bitcoin and Ethereum"]
You: "Run meta-orchestrator"
Meta: [Checks .meta-version: 1.1.0, VERSION: 1.1.0, app_intent.md: CHANGED]
Meta: "📝 MAINTENANCE MODE: Detected changes to app_intent.md"
Meta: "Will add new features while preserving existing code."
Meta: [Generates crypto_fetcher.py, crypto_analyzer.py]
Meta: [Updates lego_plan.json, .meta-manifest.json]
Meta: "✅ Done. Added crypto support."
```

#### Example 3: ENGINE UPGRADE MODE (Add Monitoring)
```
You: [Update VERSION from 1.1.0 to 1.2.0 which has observability features]
You: "Run meta-orchestrator"
Meta: [Checks .meta-version: 1.1.0, VERSION: 1.2.0, app_intent.md: unchanged]
Meta: "⬆️ ENGINE UPGRADE MODE: 1.1.0 → 1.2.0"
Meta: "New features available: observability, health checks"
Meta: "Plan: Add observability.py, update main.py with health endpoint"
Meta: "Protected: src/stock_analyzer.py (user_modified: true)"
Meta: "Approve? (y/n):"
You: "y"
Meta: [Generates observability.py, updates main.py]
Meta: [Updates .meta-version → 1.2.0, .meta-manifest.json]
Meta: "✅ Done. Upgraded to v1.2.0 with observability."
```

#### Example 4: HYBRID MODE (Engine + App Changes)
```
You: [Update VERSION to 1.2.0 AND edit app_intent.md for crypto]
You: "Run meta-orchestrator"
Meta: [Checks .meta-version: 1.1.0, VERSION: 1.2.0, app_intent.md: CHANGED]
Meta: "🔀 HYBRID MODE: Engine upgrade + app changes"
Meta: "Phase A: Add observability (engine upgrade)"
Meta: "Phase B: Add crypto support (app changes)"
Meta: "Combined plan: 6 new files, 1 modified file"
Meta: "Approve? (y/n):"
You: "y"
Meta: [Phase A: Generates observability.py]
Meta: [Phase B: Generates crypto_fetcher.py, crypto_analyzer.py]
Meta: [Updates .meta-version → 1.2.0, .meta-manifest.json]
Meta: "✅ Done. Upgraded to v1.2.0 with crypto support."
```

---

## Old Section (For Reference)

### New App Flow

```
1. User runs meta-orchestrator
2. Meta checks: ".meta-version exists?" → NO
3. Meta: "NEW APP MODE - building from scratch"
4. Meta builds app completely
5. Meta writes .meta-version and .meta-manifest.json
6. Done
```

### Existing App Flow (Same Version) - NOW SPLIT INTO NO-OP vs MAINTENANCE

```
1. User runs meta-orchestrator
2. Meta checks: ".meta-version exists?" → YES
3. Meta reads: .meta-version → v1.1.0, VERSION → v1.1.0
4a. If app_intent.md unchanged: "NO-OP MODE" → Exit
4b. If app_intent.md changed: "MAINTENANCE MODE" → Add features
5. Meta reads .meta-manifest.json
6. Meta respects user_modified: true files
7. Meta generates only new/modified files
8. Meta updates .meta-manifest.json
9. Done
```

### Existing App Flow (Upgrade) - NOW CALLED ENGINE UPGRADE

```
1. User runs meta-orchestrator
2. Meta checks: ".meta-version exists?" → YES
3. Meta reads: .meta-version → v1.0.0, VERSION → v1.1.0
4. Meta: "ENGINE UPGRADE MODE - versions differ"
5. Meta reads UPGRADING.md for upgrade workflow
6. Meta generates upgrade plan:
   - New features: config_validation, session_isolation, integration_tests
   - Will add: src/config_validator.py, tests/integration/
   - Protected: src/auth.py (user_modified: true)
7. Meta shows plan to user
8. User approves: "y"
9. Meta applies upgrade safely
10. Meta updates .meta-version → v1.1.0
11. Meta updates .meta-manifest.json with new files
12. Done
```

---

## Files Added in This Update

### Documentation

1. **`UPGRADING.md`** (570 lines)
   - Complete guide to upgrading existing apps
   - Version compatibility matrix
   - Upgrade scenarios and workflows
   - `.meta-manifest.json` format specification
   - Migration paths for existing apps

2. **`QUICKSTART_UPGRADE.md`** (410 lines)
   - Quick reference for upgrading existing apps
   - 3 upgrade strategies (safest to nuclear)
   - Example: protecting custom OAuth2 auth logic
   - Testing workflows
   - FAQ

3. **`VERSION_MANAGEMENT_SUMMARY.md`** (this file)
   - High-level overview
   - Visual flow diagrams
   - Quick reference

### Version Tracking Files

4. **`VERSION`** (1 line)
   ```
   1.1.0
   ```
   Current meta-orchestrator version.

5. **`.meta-version.template`** (11 lines)
   ```json
   {
     "meta_orchestrator_version": "1.1.0",
     "created_date": "2025-11-24",
     "features": [...]
   }
   ```
   Template for apps to copy and customize.

6. **`.meta-manifest.template.json`** (48 lines)
   ```json
   {
     "generated_by": "meta-orchestrator/1.1.0",
     "files": {
       "requirements.md": {...},
       "lego_plan.json": {...},
       ...
     }
   }
   ```
   Template for tracking generated vs. user-modified files.

### Code Changes

7. **`AGENTS.md`** - Section 0 added (70 lines)
   - New **"0. VERSION CHECK & UPGRADE MODE"** section
   - Checks for `.meta-version` file
   - Routes to NEW APP MODE vs. UPGRADE/MAINTENANCE MODE
   - Version compatibility documentation

8. **`AGENTS.md`** - Section 11 updated (5 lines)
   - Added step to write `.meta-version` and `.meta-manifest.json` on completion (NEW APP MODE only)

9. **`README.md`** - Quick Start section updated (50 lines)
   - Split into "New Application? Start Here" and "Upgrading Existing Application? Go Here"
   - References to QUICKSTART_UPGRADE.md and UPGRADING.md

---

## Version 1.1.0 Features

**New in v1.1.0** (Released November 24, 2025):

- ✨ **Session Isolation** (Phase 1): True multi-session architecture preventing context explosion
- ✨ **Config Validation**: Always-generated `config_validator` LEGO with guided setup
- ✨ **Integration Tests**: Test LEGO interactions (e.g., auth + data_layer)
- ✨ **System Tests**: E2E testing of user workflows
- ✨ **Runtime Adapters**: Tool-agnostic (Codex CLI, GitHub Copilot, Claude MCP)
- ✨ **Version Management**: `.meta-version`, `.meta-manifest.json`, safe upgrade workflow

**Upgrading from v1.0.0**:
- Session isolation: Internal improvement, no app changes needed
- Config validation: Adds new LEGO, requires approval
- Integration/system tests: Adds new test files, safe to adopt
- Runtime adapters: Internal improvement, no app changes needed

---

## Quick Commands

### Check Your App's Version

```bash
cat .meta-version
# Output: {"meta_orchestrator_version": "1.0.0", ...}
```

### Check Latest Meta-Orchestrator Version

```bash
cat /path/to/meta-metacognition/VERSION
# Output: 1.1.0
```

### Upgrade Your App

```bash
# 1. Protect custom files
cat > .meta-manifest.json << 'EOF'
{
  "files": {
    "src/my_custom_file.py": {"user_modified": true}
  }
}
EOF

# 2. Run upgrade
codex exec "Act as meta-orchestrator. Upgrade from v1.0.0 to v1.1.0. Show plan first."
```

### Selectively Adopt New Feature

```bash
codex exec "Add config_validation feature to this app, don't touch anything else"
```

---

## Best Practices

1. ✅ **Always backup** before upgrading
   ```bash
   cp -r my-app my-app-backup
   ```

2. ✅ **Upgrade on a branch**
   ```bash
   git checkout -b upgrade-meta-orchestrator
   # ... upgrade ...
   git diff
   pytest
   git checkout main && git merge upgrade-meta-orchestrator
   ```

3. ✅ **Mark custom files** in `.meta-manifest.json`
   ```json
   {"files": {"src/custom.py": {"user_modified": true}}}
   ```

4. ✅ **Review upgrade plan** before approving
   - Meta shows what will change
   - Meta shows what's protected
   - You approve with "y" or reject with "n"

5. ✅ **Test after upgrade**
   ```bash
   pytest
   # Check new features work
   python src/config_validator.py
   ```

---

## Visual: Upgrade Decision Tree

```
Start: User runs meta-orchestrator
    │
    ├─ Does .meta-version exist?
    │
    ├─ NO → NEW APP MODE
    │   ├─ Build app from app_intent.md
    │   ├─ Write .meta-version (v1.1.0)
    │   ├─ Write .meta-manifest.json
    │   └─ Done
    │
    └─ YES → Read .meta-version
        │
        ├─ Compare with VERSION file
        │
        ├─ Same version (e.g., both 1.1.0) → MAINTENANCE MODE
        │   ├─ User wants to fix bugs or add features
        │   ├─ Read .meta-manifest.json
        │   ├─ Respect user_modified: true files
        │   ├─ Generate only new/modified files
        │   ├─ Update .meta-manifest.json
        │   └─ Done
        │
        └─ Different versions (e.g., 1.0.0 → 1.1.0) → UPGRADE MODE
            ├─ Read UPGRADING.md
            ├─ Generate upgrade plan
            │   ├─ New features available
            │   ├─ Files to add/modify
            │   ├─ Protected files (user_modified: true)
            ├─ Show plan to user
            ├─ User approves? (y/n)
            │
            ├─ NO → Stop, wait for user to modify plan
            │
            └─ YES → Apply upgrade
                ├─ Add new LEGOs
                ├─ Generate new tests
                ├─ Update .meta-version → v1.1.0
                ├─ Update .meta-manifest.json
                └─ Done
```

---

## FAQ

**Q: What if I don't have `.meta-version` in my existing app?**

A: Create it manually:
```bash
echo '{"meta_orchestrator_version": "0.9.0"}' > .meta-version
```
Use `0.9.0` to indicate pre-Phase-1 version.

**Q: Can I skip certain new features?**

A: Yes! Either:
- Decline them during upgrade plan approval
- Or ask for specific features:
  ```bash
  codex exec "Add only config_validation, skip integration tests"
  ```

**Q: Will my custom code be overwritten?**

A: No, if you mark it in `.meta-manifest.json`:
```json
{"files": {"src/custom.py": {"user_modified": true}}}
```

**Q: Can I have multiple apps with different versions?**

A: Yes! Each app has its own `.meta-version`. Upgrade them independently.

**Q: What if upgrade breaks something?**

A: You backed up first, right? 😉
```bash
rm -rf my-app
cp -r my-app-backup my-app
```
Or use git:
```bash
git checkout -- .
git clean -fd
```

---

## Next Steps

1. **Read**: `QUICKSTART_UPGRADE.md` for practical upgrade walkthrough
2. **Read**: `UPGRADING.md` for deep dive on version management
3. **Try**: Upgrade a test app on a branch to see the workflow
4. **Ask**: If you have questions, open an issue or ask in chat

---

## Summary

✅ **Version tracking** via `VERSION`, `.meta-version`, `.meta-manifest.json`  
✅ **Safe upgrades** that protect your custom code  
✅ **Incremental adoption** of new features  
✅ **Clear workflows** for maintenance vs. upgrade modes  
✅ **Well documented** with examples and FAQs  

The meta-orchestrator is now **version-aware** and can safely evolve your existing apps as it learns new capabilities.
