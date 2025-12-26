# Meta-Orchestrator Version Management & App Upgrading

**Date**: December 26, 2025  
**Purpose**: Enable safe upgrading of apps built with older meta-orchestrator versions

---

## ⚠️ v1.x → v2.0.0 MAJOR UPGRADE

**Status**: Breaking changes require migration  
**Type**: Automated with rollback support  
**Time**: 30-60 minutes  

**Note**: App/Sponsor-specific guardrails in `APP_OVERRIDES` blocks are preserved across upgrades.

### v2.x Notes (Current)
- **Strategy Gate 0**: Decision-critical apps require STR-XXX approval before PM creates FR-XXX
- **Role lock state guard**: `orchestrator_state.json` includes `primary_role` and `role_lock` (HALT if missing/mismatched)
- **MCP activation**: servers are disabled by default; start Codex with `-p <app_slug>` to enable only this app’s MCP servers
- **Sources of Truth**: canonical files map (intent, essence, tracker, orchestration state) included in app docs
- **Essence sync**: `.app/essence.md` is a generated mirror of `essence.md` (kept in sync on upgrade)
- **Consistency audit**: `python scripts/consistency_audit.py` must pass before completion

---

## Quick Start: 3-Step Upgrade

### Step 1: Backup (CRITICAL!)

```bash
cd /path/to/your-app
git tag v1-backup
git tag -l | grep backup  # Verify backup exists
```

**If this fails**: Fix git before continuing!

### Step 2: Copy New Engine

```bash
# Copy .meta/ folder from meta-metacognition repo to your app
cp -r /path/to/meta-metacognition/.meta /path/to/your-app/

# Verify new version
cd /path/to/your-app
cat .meta/VERSION
# Should show: 2.0.26
```

### Step 3: Run Upgrade

Open your app in Codex CLI or GitHub Copilot and say:

```
Upgrade this app to meta-orchestrator v2.0
```

**That's it!** The orchestrator will:
1. Detect v1.x structure (checks for `.meta-version` or absence of v2.0 folders)
2. Show you the upgrade plan (folders to create, files to migrate)
3. Ask for your approval
4. Execute automated migration (9 phases)
5. Validate everything worked
6. Commit changes to git

**If anything goes wrong**:
```bash
git reset --hard v1-backup
```

---

## What the Upgrade Does (Automated)

### Creates New Folders

```bash
.workspace/          # Work item tracking
legos/              # Self-documenting LEGO blocks
specs/              # Immutable specifications
  ├── features/
  ├── design/
  └── test_plans/
docs/
  ├── user/         # Customer-facing docs
  └── dev/          # Developer-facing docs
external_input/     # User-provided context files
```

### Migrates Your Code

```bash
# Old structure:
src/config_validator.py
src/signal_generator.py
tests/unit/test_config_validator.py

# New structure:
legos/config_validator/
  ├── README.md              # ✨ Auto-generated from code
  ├── interface.md           # ✨ Auto-generated from signatures
  ├── workflows.md           # ✨ Auto-generated from imports
  └── src/
      ├── config_validator.py   # Moved from src/
      └── tests/                # Moved from tests/unit/
          └── test_config_validator.py

legos/signal_generator/
  ├── README.md
  ├── interface.md
  ├── workflows.md
  └── src/
      ├── signal_generator.py
      └── tests/
```

### Generates Documentation

For each LEGO, the orchestrator auto-generates:
- **README.md**: Complete spec (can regenerate code from this)
- **interface.md**: Executable contract (function signatures, types, errors)
- **workflows.md**: Inter-LEGO interactions (who calls whom, data flow)

### Initializes State Files

```bash
.workspace/tracker.json       # Work item log (empty initially)
legos/_manifest.json          # LEGO registry with dependencies
```

### Updates Import Paths

```python
# Old imports updated automatically:
from src.config_validator import validate_config

# Becomes:
from legos.config_validator.src.config_validator import validate_config
```

---

## Rollback If Needed

```bash
git reset --hard v1-backup
cat .meta-version  # Should show v1.x or missing
```

Git history is preserved, workspace is restored.

---

## Post-Upgrade: New Workflow

### Old Way (v1.x)
```bash
# Edit app_intent.md
# Run orchestrator
# Files generated in src/
# Edit code directly
# Commit
```

### New Way (v2.0)
```bash
# Say: "Add feature X"
# Orchestrator creates WI-001 (work item)
# .workspace/WI-001/ folder created
# PM writes spec → all 5 roles review → approved
# Architect writes design → all 5 roles review → approved
# Developer writes LEGO docs + code → reviews → approved
# Tester writes tests → reviews → approved
# Writer writes docs → reviews → approved
# All artifacts promoted to specs/, legos/, docs/
# .workspace/WI-001/ DELETED
# Git history preserves all decisions
```

**Key Difference**: Multi-role approval before promotion, immutable specs, clean workspace.

---

## Version-Specific Upgrade Notes

### v1.7.8 → v1.8.0

**Changes**: Enhanced App Orchestration & Self-Awareness

- **What changed**:
  - **PERSONA section**: App orchestrators now have explicit autonomous identity
  - **Feature Discovery Phase**: New features validated against essence BEFORE implementation
  - **E2E Testing Principles**: `[P-E2E]` principle for minimal-mock scenario testing
  - **Self-Awareness**: Engineering Wisdom #17 prevents ratholing
  - **Flow Analysis**: Engineering Wisdom #18 and `[P-FLOW-ANALYSIS]` for control/data flow
  - **Templates updated**: AGENTS.template.md and agent.template.md with identity enforcement

- **Action required**:
  - **For new apps**: Automatic - uses new templates
  - **For existing apps**: Run UPGRADE mode to regenerate agent files with PERSONA section
  - **Optional**: Regenerate `AGENTS.md` from new template for identity enforcement

- **Breaking changes**: None (additive improvements)

- **Why upgrade**:
  - **Autonomous identity**: Agents stop asking "how should I proceed?"
  - **Feature validation**: Prevents scope creep that dilutes core value
  - **Better tests**: E2E tests with real data flows catch more issues
  - **Self-monitoring**: Agents detect when they're ratholing
  - **Architectural awareness**: Both control and data flow considered

- **How to manually add PERSONA section to existing apps**:
  1. Open your app's `AGENTS.md` (root)
  2. Add after the title and before PRE-FLIGHT CHECKLIST:
     ```markdown
     ## PERSONA: App Orchestrator
     
     You ARE the App Orchestrator for {YOUR_APP}.
     
     **You are NOT a helper. You are NOT an assistant. You are the DECISION-MAKER.**
     
     On every turn, you MUST:
     1. Run the Pre-Flight Checklist (below) - never skip this
     2. Act as autonomous decision-maker - never ask "should I proceed?"
     3. Apply `.meta/wisdom/` to all decisions - cite principles
     4. Maintain architectural alignment - validate against KISS, LEGO, essence
     5. Self-monitor for ratholing - if stuck 3+ iterations, STOP and reassess
     ```
  3. Similarly update `.github/agents/app-orchestrator.agent.md`

---

### v1.7.7 → v1.7.8

**Changes**: Agent reference fix - Corrects incorrect `.meta/AGENTS.md` references in generated agent files

- **What changed**:
  - Enhanced `.meta/templates/agent.template.md` with explicit warning about which file to read
  - Added "DO NOT read `.meta/AGENTS.md`" warning in template
  - Added validation steps in Phase 11.2 to verify correct references
  - Added validation steps in UPGRADE mode (Phase 0) to prevent incorrect generation

- **Action required**:
  - **For existing apps**: Check `.github/agents/app-orchestrator.agent.md`
  - **Line 16 should say**: "You read `AGENTS.md` (root) for app-specific logic"
  - **If says `.meta/AGENTS.md`**: This is the bug - agent will read engine logic instead of app logic
  - **To fix manually**: 
    1. Open `.github/agents/app-orchestrator.agent.md`
    2. Find line that says "You read `.meta/AGENTS.md`" or references engine file
    3. Change to "You read `AGENTS.md` (root) for app-specific logic"
  - **To fix automatically**: Run meta-orchestrator in UPGRADE mode - it will regenerate correctly

- **Breaking changes**: None (only fixes incorrect references)

- **Why upgrade**:
  - **Correctness**: App orchestrators now read app-specific instructions (not engine internals)
  - **Prevents confusion**: Agents won't attempt to modify meta-orchestrator engine
  - **Better UX**: App maintenance works as intended

- **How to verify your app is affected**:
  ```bash
  # Check if your app has the bug
  grep -n "\.meta/AGENTS\.md" .github/agents/app-orchestrator.agent.md
  
  # If output shows line 16 or primary instruction section, you have the bug
  # If output only shows line 74 (reference list), you're OK
  ```

- **Technical details**:
  - Template now has explicit "PRIMARY INSTRUCTIONS" and "DO NOT" sections
  - Phase 11.2 has CRITICAL markers and validation steps
  - UPGRADE mode (Phase 0) has validation to prevent future occurrences

---

### v1.7.6 → v1.7.7

**Changes**: Workflow enforcement guards - Defense against stateless runtime amnesia

- **What changed**:
  - Enhanced pre-flight checklist with visual reinforcement (CRITICAL CHECKPOINT boxes, 🚨 emojis)
  - Memory joggers at every phase (Phases 0-11) remind agents of critical steps
  - State guards in `orchestrator_state.json` (`preflight_run`, `manifest_updated`, `primary_role`, `role_lock`)
  - Manifest validation gate at Phase 11.2 (HALT if manifest not updated before COMPLETE)
  - Before Phase 4: System checks `preflight_run = true` (HALT if false)
  - Before Phase 12 COMPLETE: System checks `manifest_updated = true` (HALT if false)

- **Action required**:
  - **For existing apps**: Automatic on next interaction
  - **No manual changes needed** - agents will apply new enforcement automatically
  - Apps using GitHub Copilot Chat will benefit most (prevents amnesia)

- **Breaking changes**: None (only adds safeguards, doesn't change workflow logic)

- **Why upgrade**:
  - **Reliability**: Prevents agents from forgetting pre-flight checklist or manifest updates
  - **Stateless runtime support**: GitHub Copilot Chat agents reminded on every turn
  - **Defense in depth**: Multiple independent safeguards (visual + programmatic + validation)
  - **Fail-safe defaults**: System halts if critical steps skipped (safe by default)

- **Technical improvements**:
  - Pre-flight checklist: 6 steps → 69-line comprehensive visual guide
  - CRITICAL CHECKPOINT boxes: 12 total (one per phase 0-11)
  - State guards: 2 new flags (`preflight_run`, `manifest_updated`) + later versions add `primary_role`, `role_lock`
  - Validation gate: Verifies manifest exists, complete, and recent before COMPLETE

- **What agents will do differently**:
  - Read enhanced pre-flight checklist on every turn (stateless runtimes)
  - Set `preflight_run: true` in `orchestrator_state.json` after checklist
  - See CRITICAL CHECKPOINT reminder at start of each phase
  - Set `manifest_updated: true` after updating `.meta-manifest.json`
  - Pass validation gate checks before marking pipeline COMPLETE

- **Evidence-based fix**:
  - User reported: GitHub Copilot agents forgot pre-flight and manifest updates
  - Root cause: Stateless runtimes have no memory between turns
  - Solution: Multiple enforcement layers prevent amnesia

---

### v1.7.5 → v1.7.6

**Changes**: Web documentation guidance - Agents search online for current API/package information

- **What changed**:
  - New `[P-WEB]` principle in `.meta/principles.md` guides agents to search online documentation
  - Phase 4 (REQUIREMENTS): Search for external API documentation, rate limits, pricing
  - Phase 8 (CODING): Verify current package versions, API endpoints, security advisories
  - Phase 9 (REVIEW): Check for outdated patterns, deprecated APIs
  - New Engineering Wisdom #16: "Web Research Trigger" detects when web research needed
  - Agents document research sources and dates in artifacts

- **Action required**:
  - **For existing apps**: Automatic on next interaction
  - **No manual changes needed** - agents will apply new guidance automatically
  - When modifying external dependencies, agents will now search for current info

- **Breaking changes**: None (only adds guidance, doesn't change engine behavior)

- **Why upgrade**:
  - **Correctness**: Agents use current API endpoints/authentication (not frozen training data)
  - **Security**: Latest CVEs and security best practices are consulted
  - **Efficiency**: Current package versions include bug fixes and performance improvements
  - **Prevents**: Deprecated API usage, outdated packages, security vulnerabilities

- **Examples of automatic improvements**:
  - External APIs: Agents search `docs.openai.com`, `docs.anthropic.com` for current endpoints
  - Packages: Agents check PyPI, npm, NuGet for latest versions and security patches
  - Frameworks: Agents verify React, FastAPI, Django patterns are current (not deprecated)
  - Security: Agents consult CVE databases and OWASP guidance for auth/crypto
  - Cloud: Agents check Azure, AWS, GCP docs for current configurations

- **What agents will document**:
  ```markdown
  ## Web Research (2025-11-28)
  - Source: https://platform.openai.com/docs/api-reference
  - Current version: v1.52.0
  - Key findings: Async client preferred, rate limits updated
  ```

---

### v1.7.4 → v1.7.5

**Changes**: Dual-runtime agent discovery - OpenAI Codex CLI + GitHub Copilot Chat support

- **What changed**:
  - Now supports BOTH GitHub Copilot Chat (VS Code) AND OpenAI Codex CLI (terminal)
  - UPGRADE mode generates TWO agent configuration files:
    - `.github/agents/app-orchestrator.agent.md` → GitHub Copilot Chat agent picker
    - `AGENTS.md` (root) → OpenAI Codex CLI memory system
  - New template: `.meta/templates/AGENTS.codex.template.md` for Codex configuration
  - Validation checks BOTH files exist

- **Action required**:
  - **For new apps**: Automatic (both files generated during build)
  - **For apps upgraded to v1.7.4 WITHOUT `AGENTS.md`**: Run ENGINE UPGRADE again OR manual fix:
    ```bash
    # Copy template to root
    copy .meta\templates\AGENTS.codex.template.md AGENTS.md
    # Edit AGENTS.md: Replace {APP_NAME} with your app name from app_intent.md
    ```

- **Breaking changes**: None (only adds Codex support, doesn't break Copilot)

- **Why upgrade**:
  - Use EITHER GitHub Copilot Chat (VS Code) OR OpenAI Codex CLI (terminal)
  - Switch between runtimes without losing agent discovery
  - Codex CLI users get app-specific instructions via `AGENTS.md`

- **Runtime-Specific Discovery**:
  - **GitHub Copilot Chat**: Reads `.github/agents/*.agent.md` → Agent picker dropdown
  - **OpenAI Codex CLI**: Reads `AGENTS.md` in directories → Memory/instructions
  - Both reference same `.meta/AGENTS.md` for engine logic

---

### v1.7.3 → v1.7.4

**Changes**: Fixed agent discoverability - MANDATORY `.github/agents/` generation during upgrades

- **What changed**: 
  - UPGRADE mode now **requires** `.github/agents/app-orchestrator.agent.md` generation
  - Added validation: Checks file exists after upgrade, stops if missing
  - Creates `.github/agents/` directory if needed
  - Ensures Codex CLI agent picker can discover "App Orchestrator"
  
- **Action required**: 
  - **For new apps**: Automatic (agent file generated during build)
  - **For apps upgraded v1.7.1-v1.7.3 WITHOUT agent file**: Run ENGINE UPGRADE again OR manual fix:
    ```bash
    mkdir .github\agents
    copy .meta\templates\agent.template.md .github\agents\app-orchestrator.agent.md
    # Edit file: Replace {APP_NAME} with your app name
    ```
  
- **Breaking changes**: None (only improves discoverability)

- **Why upgrade**: 
  - "App Orchestrator" appears in Codex CLI agent picker
  - No need to remember activation phrases
  - Consistent agent experience across all apps
  
- **Benefits**:
  - One-click agent activation from dropdown
  - Guaranteed agent discoverability after upgrade
  - Validation prevents silent failures

---

### v1.7.3 → Current

**Changes**: Inline pre-flight checklist with version/docs checkpoint

- **What changed**: 
  - Pre-flight checklist embedded directly in `.github/agents/*.agent.md` files
  - Checklist executed immediately on activation (not buried in AGENTS.md)
  - Checkpoint #6 added: Version & documentation verification before commits
  - Prevents incomplete releases
  
- **Action required**: 
  - **Automatic for new apps**: Generated agents have inline checklist
  - **For existing apps**: Run ENGINE UPGRADE to update agent files
  
- **Breaking changes**: None (only adds quality enforcement)

- **Why upgrade**: 
  - Agents maintain identity across turns consistently
  - Wisdom applied systematically (KISS, LEGO, Thompson #5)
  - No more incomplete commits (version/docs verified)
  - Quality enforcement through checklists

- **Benefits**:
  - Consistent agent behavior
  - Systematic wisdom application
  - Complete releases (version + docs always updated)
  - Self-enforcing quality standards

---

### v1.7.2 → v1.7.3

**Changes**: Same as v1.7.3 → Current (inline pre-flight checklist)

---

### v1.7.2 → Current

**Changes**: Custom agent terminal access fix - removed tools restriction

- **What changed**: 
  - Removed `tools` field from `.github/agents/*.agent.md` files
  - Custom agents now have full capabilities (terminal, file editing, all tools)
  - `.meta/templates/agent.template.md` updated (no tools restriction)
  
- **Action required**: 
  - **Automatic for new apps**: Generated agents have full capabilities
  - **For existing apps (v1.7.1)**: Run ENGINE UPGRADE or manually remove `tools:` line from agent files
  
- **Breaking changes**: None (only adds capabilities)

- **Why upgrade**: 
  - Custom agents can run terminal commands (git, npm, etc.)
  - Custom agents can edit files directly
  - No artificial capability restrictions

- **Benefits**:
  - Full orchestrator functionality from custom agents
  - No need to switch back to default Agent mode
  - Consistent experience across all agent modes

---

### v1.7.1 → v1.7.2

**Changes**: Same as v1.7.2 → Current (terminal access fix)

---

### v1.7.1 → Current

**Changes**: VS Code custom agent generation - agent appears in Copilot dropdown

- **What changed**: 
  - NEW APP mode generates `.github/agents/{APP_NAME}.agent.md`
  - ENGINE UPGRADE mode creates/updates the agent file
  - Agent appears in VS Code Copilot agent picker dropdown
  - No activation phrases needed - just select from dropdown
  
- **Action required**: 
  - **Automatic for new apps**: Generated when you build new app with v1.7.1+
  - **For existing apps**: Run ENGINE UPGRADE to add agent file:
    ```bash
    @workspace Act as meta-orchestrator. Upgrade this app to v1.7.1 (ENGINE UPGRADE MODE)
    ```
  - **Manual alternative**: Create `.github/agents/{your-app}.agent.md` using `.meta/templates/agent.template.md`
  
- **Breaking changes**: None

- **Why upgrade**: 
  - Discoverable agents: See your app orchestrator in VS Code Copilot dropdown
  - No memorization: Don't need to remember `@workspace Act as...` activation phrases
  - Professional UX: Same experience as built-in agents (Agent, Plan, Ask, Edit)
  - Quick activation: Select agent from picker, start working immediately

- **Benefits**:
  - Agent visible in dropdown (discoverability)
  - Click to activate (vs typing activation phrase)
  - Consistent with VS Code conventions
  - Agent maintains identity across turns (references `AGENTS.md`)

---

### v1.7.0 → v1.7.1

**Changes**: Same as v1.7.1 → Current (VS Code custom agent support)

---

### v1.6.1 → v1.7.0

**Changes**: Conversational MAINTENANCE mode - orchestrator updates app_intent.md after discussion

- **What changed**: 
  - MAINTENANCE mode now has two paths: **Path A (conversational)** and **Path B (manual edit)**
  - Path A: User asks "Add feature X" → orchestrator clarifies → proposes app_intent.md update → gets approval
  - Path B: User manually edits app_intent.md first (existing workflow still works)
  - Orchestrator maintains app_intent.md as living documentation
  - Approval gate prevents mistakes (user reviews diff before writing)
  
- **Action required**: 
  - **None** - Both workflows supported (backward compatible)
  - **Optional**: Regenerate app-specific AGENTS.md to get conversational workflow:
    ```bash
    @workspace Act as meta-orchestrator and regenerate AGENTS.md from template
    ```
  
- **Breaking changes**: None (Path B maintains existing manual workflow)

- **Why upgrade**: 
  - Natural UX: Add features by chatting (like talking to developer)
  - No file editing interruption (orchestrator handles app_intent.md)
  - Better descriptions: AI-written with wisdom/precision
  - Living documentation: app_intent.md stays current with features
  - Still safe: Approval gate before writing

- **Benefits**:
  - Conversational feature additions: "Add Bitcoin trading" → orchestrator asks questions → proposes update
  - Captures conversation context: Clarifying Q&A distilled into clear intent
  - Reduced friction: No switching between chat and file editor
  - Quality improvements: Orchestrator applies wisdom to intent descriptions

### v1.6.1 → Current

**Changes**: Bugfix release - no new features

- **What changed**: `app_intent.md` now correctly describes meta-orchestrator (not OptionsTrader example)
- **Action required**: None (documentation-only fix, no code changes)
- **Breaking changes**: None
- **Why upgrade**: Ensures future AI agents understand the engine's unique architecture (source = `.meta/` prompts)

### v1.6.0 → Current

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

### 5. Select Runtime (New in 2.0.1)

Ensure `meta_config.json` has `preferred_runtime`. If missing, the upgrade flow will ask you to choose.
If you can’t decide, it will default to **single-session role switching**.

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
