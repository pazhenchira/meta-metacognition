# Meta-Orchestrator Version Management & App Upgrading

**Date**: November 24, 2025  
**Purpose**: Enable safe upgrading of apps built with older meta-orchestrator versions

---

## Problem Statement

When you build an app with meta-orchestrator v1.0 and later upgrade to v2.0, how do you:
1. Apply new meta-orchestrator features to existing apps?
2. Avoid overwriting app-specific code changes?
3. Know which version of meta-orchestrator built an app?
4. Safely adopt new features (session isolation, config validation, etc.)?

---

## Understanding the Four Modes

The meta-orchestrator detects what you're trying to do based on **two factors**:

1. **Version comparison**: `.meta-version` (app) vs `VERSION` (engine)
2. **Intent change**: Has `app_intent.md` been modified since last run?

### Mode Decision Matrix

| `.meta-version` | `VERSION` | `app_intent.md` | Mode | What Happens |
|-----------------|-----------|-----------------|------|--------------|
| Does not exist | (any) | (any) | **NEW APP** | Build from scratch, create versioning files |
| 1.1.0 | 1.1.0 | Unchanged | **NO-OP** | Nothing to do, app is current |
| 1.1.0 | 1.1.0 | Changed | **MAINTENANCE** | Add/remove app features based on new requirements |
| 1.0.0 | 1.1.0 | Unchanged | **ENGINE UPGRADE** | Add new meta-orchestrator features to existing app |
| 1.0.0 | 1.1.0 | Changed | **HYBRID** | Do ENGINE UPGRADE + MAINTENANCE in sequence |

### Real-World Examples

#### Example 1: NO-OP MODE
```
Scenario: You built a stock analyzer last week. Nothing changed.

.meta-version: 1.1.0
VERSION: 1.1.0
app_intent.md: Unchanged since last run

Meta-orchestrator says:
"App is up-to-date. To add features, edit app_intent.md. To adopt new 
meta-orchestrator features, update VERSION file."

Action: Exits immediately, nothing to do.
```

#### Example 2: MAINTENANCE MODE (Add Feature to Existing App)
```
Scenario: Your stock analyzer works great. Now you want to add crypto support.

.meta-version: 1.1.0 (stays the same)
VERSION: 1.1.0 (stays the same)
app_intent.md: YOU EDITED IT to add "Support Bitcoin and Ethereum"

Meta-orchestrator says:
"Detected changes to app_intent.md. Running MAINTENANCE MODE.
Will generate new LEGOs for crypto support while preserving existing code."

Actions:
1. Re-runs requirements discovery with updated app_intent.md
2. Adds new requirements (FR-05: Crypto data fetching, FR-06: Crypto analysis)
3. Updates lego_plan.json with new LEGOs (crypto_fetcher, crypto_analyzer)
4. Respects user_modified: true files (your custom stock analyzer logic)
5. Generates new src/crypto_fetcher.py, src/crypto_analyzer.py
6. Generates new tests for crypto LEGOs
7. Updates .meta-manifest.json with new files
8. DOES NOT update .meta-version (still 1.1.0)

Result: Your stock analyzer now also handles crypto, custom code untouched.
```

#### Example 3: ENGINE UPGRADE MODE (Adopt New Meta-Orchestrator Features)
```
Scenario: Meta-orchestrator v1.2.0 just released with observability features.
         Your stock analyzer works fine, you just want better monitoring.

.meta-version: 1.1.0 (will be updated to 1.2.0)
VERSION: 1.2.0 (new)
app_intent.md: Unchanged

Meta-orchestrator says:
"Detected meta-orchestrator upgrade: 1.1.0 → 1.2.0.
Running ENGINE UPGRADE MODE.

Upgrade Plan:
✅ New features in v1.2.0:
   - Observability LEGO (telemetry, logging, metrics)
   - Health check endpoints
   - Production monitoring integration

📝 Changes:
   - Add: src/observability.py (new LEGO)
   - Add: tests/test_observability.py
   - Add: MONITORING.md
   - Modify: main.py (add health check endpoint)

⚠️ Protected files (won't regenerate):
   - src/stock_analyzer.py (user_modified: true)
   - src/auth.py (user_modified: true)

Approve upgrade? (y/n):"

Actions (after approval):
1. Generates new observability LEGO
2. Adds health check to main.py (small targeted change)
3. Updates lego_plan.json with new LEGO
4. Updates .meta-version → 1.2.0
5. Updates .meta-manifest.json with new files
6. DOES NOT touch app_intent.md or existing app logic

Result: Your stock analyzer has same features, but now with monitoring.
```

#### Example 4: HYBRID MODE (Both Engine + App Changes)
```
Scenario: Meta-orchestrator v1.2.0 released with observability features.
          You also want to add crypto support to your stock analyzer.

.meta-version: 1.1.0 (will be updated to 1.2.0)
VERSION: 1.2.0 (new)
app_intent.md: YOU EDITED IT to add crypto support

Meta-orchestrator says:
"Detected HYBRID MODE: Both engine upgrade (1.1.0 → 1.2.0) AND app changes.

Will execute in two phases:
Phase A: ENGINE UPGRADE (add observability features)
Phase B: MAINTENANCE (add crypto support)

Combined Plan:
📦 Phase A (Engine Upgrade):
   - Add: src/observability.py
   - Add: tests/test_observability.py
   - Modify: main.py (health checks)

📦 Phase B (Maintenance):
   - Add: src/crypto_fetcher.py (new app feature)
   - Add: src/crypto_analyzer.py (new app feature)
   - Add: tests/test_crypto_*.py

⚠️ Protected files (won't regenerate):
   - src/stock_analyzer.py (user_modified: true)

Total changes: 6 new files, 1 modified file, 0 deleted files

Approve combined plan? (y/n):"

Actions (after approval):
1. Phase A: Add observability LEGO (engine feature)
2. Phase A: Update main.py with health checks
3. Phase B: Re-run requirements discovery with new app_intent.md
4. Phase B: Add crypto LEGOs (app features)
5. Update .meta-version → 1.2.0
6. Update .meta-manifest.json with all new files

Result: Your stock analyzer has crypto support AND monitoring.
```

---

## Solution: Version-Aware Workspaces

### Directory Structure (Recommended)

```
your-project/
├── .meta/                          # Meta-orchestrator engine (version controlled)
│   ├── AGENTS.md
│   ├── intent.md
│   ├── principles.md
│   ├── meta_config.json
│   ├── wisdom/
│   ├── patterns/
│   ├── templates/
│   ├── SESSION_ISOLATION.md
│   ├── TESTING_STRATEGY.md
│   ├── CONFIG_VALIDATION.md
│   ├── runtime_adapters/
│   └── VERSION                     # Engine version identifier
│
├── app_intent.md                   # Your app-specific intent
├── requirements.md                 # Generated, versioned
├── lego_plan.json                  # Generated, versioned
├── orchestrator_state.json         # Generated, ephemeral
│
├── src/                            # Generated app code (your app owns this)
│   ├── auth.py
│   ├── data_layer.py
│   └── ...
│
├── tests/                          # Generated tests (your app owns this)
│   ├── test_auth.py
│   └── ...
│
├── .meta-version                   # Which meta-orchestrator version built this app
└── .meta-manifest.json             # What files meta-orchestrator generated
```

### Key Changes

#### 1. `.meta/` Directory (Meta-Orchestrator Engine)

Move all meta-orchestrator files into `.meta/`:

```bash
mkdir .meta
mv AGENTS.md intent.md principles.md meta_config.json .meta/
mv wisdom/ patterns/ templates/ .meta/
mv SESSION_ISOLATION.md TESTING_STRATEGY.md CONFIG_VALIDATION.md .meta/
mv runtime_adapters/ .meta/
```

**Benefits**:
- Clear separation: `.meta/` = engine, everything else = app
- Can update `.meta/` without touching app code
- Can version control `.meta/` separately (git submodule or subtree)

#### 2. `.meta/VERSION` File

```
1.0.0
```

Semantic versioning for the meta-orchestrator engine:
- **Major**: Breaking changes (e.g., AGENTS.md workflow changes)
- **Minor**: New features (e.g., config validation, session isolation)
- **Patch**: Bug fixes

#### 3. `.meta-version` File (In App Root)

```json
{
  "meta_orchestrator_version": "1.0.0",
  "created_date": "2025-11-15",
  "last_updated": "2025-11-24",
  "features": [
    "lego_architecture",
    "unit_tests",
    "session_isolation",
    "config_validation"
  ]
}
```

Records which version of meta-orchestrator built this app and what features it has.

#### 4. `.meta-manifest.json` (Generated Files Tracking)

```json
{
  "generated_by": "meta-orchestrator/1.0.0",
  "timestamp": "2025-11-24T10:00:00Z",
  "files": {
    "requirements.md": {
      "generated": "2025-11-15T10:00:00Z",
      "last_modified": "2025-11-24T10:00:00Z",
      "user_modified": false,
      "regenerate_on_upgrade": true
    },
    "lego_plan.json": {
      "generated": "2025-11-15T10:00:00Z",
      "last_modified": "2025-11-15T10:00:00Z",
      "user_modified": false,
      "regenerate_on_upgrade": true
    },
    "src/auth.py": {
      "generated": "2025-11-15T10:30:00Z",
      "last_modified": "2025-11-20T14:00:00Z",
      "user_modified": true,
      "regenerate_on_upgrade": false
    },
    "src/config_validator.py": {
      "generated": "2025-11-24T10:00:00Z",
      "last_modified": "2025-11-24T10:00:00Z",
      "user_modified": false,
      "regenerate_on_upgrade": true,
      "added_in_version": "1.1.0"
    }
  }
}
```

---

## Upgrading Existing Apps

### Scenario 1: Overlay New Meta-Orchestrator on Existing App

```bash
# 1. Backup your app
cp -r my-app my-app-backup

# 2. Check current meta version
cd my-app
cat .meta-version  # Shows: "1.0.0" (or doesn't exist)

# 3. Download new meta-orchestrator
git clone https://github.com/yourorg/meta-metacognition.git .meta-new

# 4. Run upgrade command
codex exec "Act as meta-orchestrator. Read .meta-new/ for new engine files, \
  read .meta-version and .meta-manifest.json to understand current app state, \
  and upgrade this app to use new meta-orchestrator features."
```

### What the Upgrade Agent Does

1. **Reads current app state**:
   - `.meta-version` → what version built this app
   - `.meta-manifest.json` → which files are user-modified
   - `lego_plan.json` → current architecture

2. **Analyzes new features**:
   - Compares `.meta-new/VERSION` with `.meta-version`
   - Identifies new features (config_validation, session_isolation, etc.)
   - Determines what can be added safely

3. **Generates upgrade plan**:
   ```markdown
   # Upgrade Plan: v1.0.0 → v1.2.0
   
   ## New Features Available
   - ✅ Config Validation (recommended)
   - ✅ Session Isolation (internal, no app changes)
   - ✅ Integration Tests (recommended)
   
   ## Proposed Changes
   1. Add config_validator LEGO to lego_plan.json
   2. Generate src/config_validator.py
   3. Update main.py to call config validation on startup
   4. Generate CONFIGURATION.md
   5. Add tests/system/test_config_validation.py
   
   ## User-Modified Files (Won't Touch)
   - src/auth.py (modified 2025-11-20)
   - src/data_layer.py (modified 2025-11-18)
   
   ## Approve upgrade? (y/n):
   ```

4. **Applies upgrade safely**:
   - Only modifies files where `user_modified: false`
   - Adds new LEGOs (config_validator)
   - Generates new tests
   - Updates `.meta-version` and `.meta-manifest.json`

### Scenario 2: Incremental Feature Adoption

```bash
# Adopt only specific new features
codex exec "Act as meta-orchestrator. Upgrade this app to add config_validation \
  feature from .meta-new/ without changing existing LEGOs."
```

The upgrade agent:
1. Reads `.meta-new/CONFIG_VALIDATION.md`
2. Generates only `config_validator` LEGO
3. Adds to `lego_plan.json` without modifying existing LEGOs
4. Generates `src/config_validator.py` and tests
5. Updates `main.py` to call validator on startup

---

## Version Compatibility Matrix

| App Built With | Can Upgrade To | Notes |
|----------------|----------------|-------|
| v1.0.0 (no session isolation) | v1.1.0 (session isolation) | ✅ Safe: Internal improvement, no app changes |
| v1.0.0 (no config validation) | v1.1.0 (config validation) | ⚠️ Adds new LEGO, requires approval |
| v1.0.0 | v2.0.0 (breaking changes) | ❌ Requires manual migration |

---

## Meta-Orchestrator Commands for Existing Apps

### Check Current Version

```bash
codex exec "Act as meta-orchestrator. Report current meta-orchestrator version \
  used to build this app and available upgrades."
```

Output:
```
Current Version: 1.0.0 (built 2025-11-15)
Latest Version: 1.2.0

Available Upgrades:
- v1.1.0: Adds config validation, session isolation
- v1.2.0: Adds integration tests, health checks

Run upgrade: codex exec "Upgrade this app to v1.2.0"
```

### Upgrade with Approval

```bash
codex exec "Act as meta-orchestrator. Upgrade this app to meta-orchestrator v1.2.0. \
  Show upgrade plan before applying."
```

### Force Regenerate Specific Files

```bash
codex exec "Act as meta-orchestrator. Regenerate requirements.md and lego_plan.json \
  using current app_intent.md and new meta-orchestrator features."
```

---

## Best Practices

### 1. Use `.meta/` Directory (Recommended)

Move all meta-orchestrator files into `.meta/`:
- Keeps root directory clean
- Clear ownership: `.meta/` = engine, `src/` = your app
- Easy to update engine via git submodule/subtree

### 2. Version Control `.meta-manifest.json`

Track which files are generated vs. user-modified:
- Commit `.meta-manifest.json` to git
- Update it whenever you manually edit generated files
- Meta-orchestrator respects `user_modified: true`

### 3. Pin Meta-Orchestrator Version

In `meta_config.json`:
```json
{
  "meta_orchestrator_version": "1.2.0",
  "auto_upgrade": false
}
```

Prevents accidental upgrades until you're ready.

### 4. Test Upgrades on Branches

```bash
git checkout -b upgrade-meta-orchestrator
codex exec "Upgrade this app to meta-orchestrator v1.2.0"
# Review changes
git diff
# Test
pytest
# Merge if good
git checkout main
git merge upgrade-meta-orchestrator
```

---

## Implementation in .meta/AGENTS.md

Add new section **"0. VERSION CHECK & UPGRADE MODE"**:

```markdown
## 0. VERSION CHECK & UPGRADE MODE

Before starting the pipeline, check if this is a new app or an upgrade:

1. **Check for `.meta-version`**:
   - If exists: UPGRADE MODE
   - If not: NEW APP MODE

2. **NEW APP MODE**:
   - Proceed with normal pipeline (Sections 1-12)
   - At completion, write `.meta-version` and `.meta-manifest.json`

3. **UPGRADE MODE**:
   - Read `.meta-version` to see app's current meta-orchestrator version
   - Read `.meta-manifest.json` to see user-modified files
   - Compare with current meta-orchestrator `.meta/VERSION`
   - If versions match: MAINTENANCE MODE (fix bugs, add features to existing app)
   - If versions differ: UPGRADE MODE (apply new meta-orchestrator features)

4. **UPGRADE MODE WORKFLOW**:
   a. Analyze new features available in current meta-orchestrator
   b. Generate upgrade plan (what will change, what's protected)
   c. Show plan to user, get approval
   d. Apply upgrade (respecting user-modified files)
   e. Update `.meta-version` and `.meta-manifest.json`
```

---

## Migration Path for Your Existing App

Since you have an app built with the old structure:

### Option A: Keep Separate (Safest)

```bash
# Keep your existing app as-is
cd my-existing-app

# Copy new meta-orchestrator to .meta/
git clone https://github.com/yourorg/meta-metacognition.git .meta

# Create versioning files
echo '{"meta_orchestrator_version": "0.9.0", "features": []}' > .meta-version
# (0.9.0 = pre-Phase-1 version)

# Now you can selectively adopt new features
codex exec "Add config_validation to this app using .meta/ engine"
```

### Option B: Clean Migration (More Work)

```bash
# 1. Document current app
cd my-existing-app
git commit -am "Snapshot before meta-orchestrator upgrade"

# 2. Create manifest of what you manually modified
cat > .meta-manifest.json << 'EOF'
{
  "files": {
    "src/custom_feature.py": {"user_modified": true},
    "src/auth.py": {"user_modified": true}
  }
}
EOF

# 3. Copy new meta-orchestrator
mkdir .meta
cp -r /path/to/new-meta-metacognition/* .meta/

# 4. Run upgrade
codex exec "Read .meta/ for new meta-orchestrator engine. \
  Upgrade this app to use new features while preserving user-modified files in .meta-manifest.json"
```

---

## Summary

✅ **Use `.meta/` directory** for clean separation  
✅ **Track versions** with `.meta-version` and `.meta/VERSION`  
✅ **Protect user changes** with `.meta-manifest.json`  
✅ **Upgrade safely** with approval workflow  
✅ **Test on branches** before merging  

This enables:
- Updating meta-orchestrator engine without breaking existing apps
- Selectively adopting new features
- Preserving your custom code changes
- Clear audit trail of what changed and when

---

## Version-Specific Upgrade Notes

### Upgrading to v1.6.0 (Stateless Runtime Support)

**New Features**:
- Pre-flight Checklist in `.meta/AGENTS.md` (prevents agent amnesia)
- App-specific AGENTS.md template (`.meta/templates/AGENTS.template.md`)
- Meta-orchestrator self-maintenance (`AGENTS.md` in root)

**Breaking Changes**: None

**Upgrade Steps**:

1. **Update `.meta/` directory**:
```bash
cd your-app
git pull origin main  # If using .meta/ as submodule
# OR
cp -r /path/to/meta-metacognition-v1.6.0/.meta ./
```

2. **Regenerate app-specific AGENTS.md** (optional but recommended):
```bash
@workspace Act as meta-orchestrator and regenerate AGENTS.md from template for this app
```

This gives your app orchestrator the Pre-flight Checklist, fixing amnesia during maintenance.

**Benefits**:
- App orchestrator maintains role during multi-turn feature additions
- Works in both Codex CLI and GitHub Copilot Chat
- No more "how should I proceed?" questions mid-pipeline

**No action required if**: Your app works fine and you don't need multi-turn maintenance sessions.
