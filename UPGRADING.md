# Meta-Orchestrator Version Management & App Upgrading

**Date**: February 27, 2026  
**Purpose**: Enable safe upgrading of apps built with older meta-orchestrator versions

---

## Current Version (v4.x)

**Current Engine Version**: 4.0.0  

### v3.2.0 Notes (MetaAgent v0.9.9 Patterns + Skills)

**Changes** (non-breaking):

- **Turn Report** (Non-Negotiable): Structural enforcement of verification on every output turn. Every claim must trace to a specific artifact (file paths, commands, task IDs).
- **Self-Challenge Gate**: Before presenting recommendations, name key assumptions, counter-indicators, and stress-test high-blast-radius work.
- **Two-Strike Rule**: If the same approach fails twice in the same session, STOP and switch approaches. Don't iterate on a failing method more than twice.
- **Skills System** (`skills/`): Procedural protocols attached to work stages:
  - `investigation-framing.skill.md` — Validate the question before executing analysis
  - `pre-ship-review.skill.md` — Chain-of-Verification before presenting completed work
  - `structured-challenge.skill.md` — Steel-man + failure modes + pre-mortem for high-stakes decisions
  - `selector.md` — Routes work stages to appropriate skills

**New Files**:
- `skills/README.md` — Skills system overview
- `skills/selector.md` — Skill routing by work stage
- `skills/investigation-framing.skill.md`
- `skills/pre-ship-review.skill.md`
- `skills/structured-challenge.skill.md`

**Source**: Patterns generalized from MetaAgent v0.9.7-v0.9.9 and TA (Technical Advisor) child project's production-proven skills system.

### v4.0.0 Notes (MetaAgent v0.10.0 Convergence)

**Changes** (BREAKING — directory restructure):

- **`.meta/` eliminated**: All engine content moved to `.brain/`, `patterns/`, `templates/`, `skills/`, `generators/` at project root
- **Atlas orchestrator**: Single unified orchestrator replaces separate `meta-orchestrator.agent.md` + `app-orchestrator.agent.md`
- **8 Habits system**: Orient, Deliberate, Delegate, Verify, Learn, Ship, Document, Report
- **Skills system expanded**: 6 full quality protocol skills (was 3 stubs)
- **`.brain/` project brain**: `config.yaml`, `lessons.md`, `status.md`, `reflections.md`, `playbooks/`, `wisdom/`, `principles.md`, `roles/`, `context/`
- **`.github/copilot-instructions.md`**: Lightweight project identity for day-to-day work
- **Turn Report**: Non-negotiable structural verification on every output turn

**Path Migration Map**:

| Old Path | New Path |
|----------|----------|
| `.meta/AGENTS.md` | `.brain/playbooks/build-from-intent.md` |
| `.meta/principles.md` | `.brain/principles.md` |
| `.meta/intent.md` | `.brain/context/intent.md` |
| `.meta/VERSION` | `.brain/meta/engine-version.txt` |
| `.meta/wisdom/` | `.brain/wisdom/` |
| `.meta/patterns/` | `patterns/` (root) |
| `.meta/templates/` | `templates/` (root) |
| `.meta/generators/` | `generators/` (root) |
| `.meta/skills/` | `skills/` (root) |
| `.meta/playbooks/` | `.brain/playbooks/` |
| `.meta/roles/` | `.brain/roles/` |
| `.meta/workflows/` | `.brain/playbooks/` |
| `.github/agents/meta-orchestrator.agent.md` | `.github/agents/atlas.agent.md` |
| `.github/agents/app-orchestrator.agent.md` | `.github/agents/atlas.agent.md` |

**New Files**:
- `.brain/config.yaml` — Framework configuration
- `.brain/lessons.md` — Accumulated operational knowledge
- `.brain/status.md` — Session re-entrancy state
- `.brain/reflections.md` — Periodic self-assessment template
- `.brain/context/domain.md` — Project domain context
- `.brain/meta/framework-version.txt` — MetaAgent framework version
- `.github/agents/atlas.agent.md` — Unified orchestrator
- `.github/copilot-instructions.md` — Project identity
- `skills/problem-reframing.skill.md` — Break out of stuck patterns
- `skills/stakeholder-lens.skill.md` — Match stakeholder quality bar
- `skills/strategic-synthesis.skill.md` — Validate strategic recommendations

---

## v3.2.0 → v4.0.0 Upgrade

**Type**: Breaking (directory restructure)  
**Effort**: 15 minutes (scripted migration)

### What Changes

- `.meta/` directory eliminated — content distributed to `.brain/`, `patterns/`, `templates/`, `skills/`, `generators/`
- Single Atlas orchestrator replaces dual meta-orchestrator + app-orchestrator
- Skills system expanded from 3 stubs to 6 full protocols
- `.brain/` becomes project brain with config, lessons, status, reflections

### Upgrade Steps

**Step 1: Backup**
```bash
cd /path/to/your-project
git tag v3-backup
```

**Step 2: Restructure directories**
```bash
# Create new structure
mkdir -p .brain/context .brain/meta .brain/playbooks .brain/wisdom .brain/roles .brain/outputs

# Move engine core
mv .meta/AGENTS.md .brain/playbooks/build-from-intent.md
mv .meta/principles.md .brain/principles.md
mv .meta/intent.md .brain/context/intent.md
mv .meta/VERSION .brain/meta/engine-version.txt

# Move wisdom and roles into .brain/
mv .meta/wisdom/* .brain/wisdom/
mv .meta/roles/* .brain/roles/
mv .meta/playbooks/* .brain/playbooks/

# Move patterns, templates, generators, skills to root
mv .meta/patterns/* patterns/
mv .meta/templates/* templates/
mv .meta/generators/* generators/
mv .meta/skills/* skills/

# Move workflows into playbooks
mv .meta/workflows/* .brain/playbooks/
```

**Step 3: Copy new files from engine repo**
```bash
ENGINE=/path/to/meta-metacognition

# New brain files
cp $ENGINE/.brain/config.yaml .brain/config.yaml
cp $ENGINE/.brain/lessons.md .brain/lessons.md  # Or create your own
cp $ENGINE/.brain/status.md .brain/status.md    # Or create your own
cp $ENGINE/.brain/reflections.md .brain/reflections.md
cp $ENGINE/.brain/context/domain.md .brain/context/domain.md
cp $ENGINE/.brain/meta/framework-version.txt .brain/meta/framework-version.txt

# New agent + instructions
cp $ENGINE/.github/agents/atlas.agent.md .github/agents/atlas.agent.md
cp $ENGINE/.github/copilot-instructions.md .github/copilot-instructions.md

# New/expanded skills
cp $ENGINE/skills/* skills/
```

**Step 4: Update references**
```bash
# Find and fix stale .meta/ references in your project files
grep -r "\.meta/" --include="*.md" --include="*.json" --include="*.py" --include="*.sh" --include="*.yaml" .
# Update each reference per the Path Migration Map above
```

**Step 5: Clean up old structure**
```bash
# Remove old agent files
rm -f .github/agents/meta-orchestrator.agent.md
rm -f .github/agents/app-orchestrator.agent.md

# Delete the old .meta/ directory
rm -rf .meta/

# Update root redirects
echo "# Lessons" > lessons.md
echo "" >> lessons.md  
echo "> This file has moved to \`.brain/lessons.md\`. See there for accumulated operational knowledge." >> lessons.md

echo "# Status" > status.md
echo "" >> status.md
echo "> This file has moved to \`.brain/status.md\`. See there for current project state." >> status.md
```

**Step 6: Edit .brain/config.yaml**
Update with your project's details:
```yaml
version: "0.10.0"
framework:
  source: "github:pazhenchira/meta-metacognition"
  version: "0.10.0"
orchestrator:
  name: "Atlas"  # Or your project's orchestrator name
  mode: "self-building"
project:
  name: "your-project-name"
  version: "4.0.0"
```

**Step 7: Edit .brain/context/domain.md**
Write a one-line description of your project.

**Step 8: Verify and commit**
```bash
# Verify .meta/ is gone
ls .meta/ 2>/dev/null && echo "ERROR: .meta/ still exists!" || echo "OK: .meta/ removed"

# Verify new structure
ls .brain/config.yaml .brain/playbooks/build-from-intent.md .brain/principles.md skills/selector.md patterns/antipatterns.md

# Commit
git add -A
git commit -m "refactor: converge to MetaAgent v0.10.0 — .meta/ → .brain/ + root directories"
git push
```

**Rollback if needed**:
```bash
git reset --hard v3-backup
```

---

## v3.1.1 → v3.2.0 Upgrade

**Type**: Non-breaking  
**Effort**: One sentence to your orchestrator

### What Changes

- Turn Report enforces verification on every output turn (structural, not behavioral)
- Self-Challenge Gate catches optimism bias before presenting recommendations
- Two-Strike Rule prevents rabbit-holing on failing approaches
- Skills system adds reusable quality protocols (investigation framing, pre-ship review, structured challenge)

### For Existing Apps

Tell your app orchestrator:
```
Upgrade the meta-orchestrator engine to the latest version
```

Or manually:
1. Copy `skills/` directory from engine repo
2. Updated `.github/agents/` files include Turn Report, Self-Challenge Gate, Two-Strike Rule
3. No state file changes needed

---

### v3.1.1 Notes (Learnings Applied)

**Changes** (non-breaking):

- **Session Start Protocol**: Replaces per-turn compliance statements and pre-flight checklists
  - Read `lessons.md` + `status.md` at session start
  - Re-orient every ~10 turns via status + lessons (not full checklist)
  - Identity confirmation protocol removed (measured 48% failure rate)
  - Re-orientation loop removed (too expensive in context budget)
- **Deliberation Step** (v0.9.5): Assess ambiguity and blast radius before implementing
- **`lessons.md` + `status.md`**: Templates instantiated; apps get these on new builds or upgrade
- **Auto-upgrade**: `scripts/upgrade-app.sh` pulls latest `.meta/` into downstream apps
- **`engine_source` field**: `.meta-version` now includes the engine repo URL for auto-upgrade awareness

**New Files**:
- `lessons.md` — Accumulated operational knowledge (read at session start)
- `status.md` — Session re-entrancy (what's active/next/blocked)
- `scripts/upgrade-app.sh` — Auto-upgrade script for downstream apps

---

## Upgrading Apps

Tell your app orchestrator:

```
Upgrade the meta-orchestrator engine to the latest version
```

**First time?** If `engine_source` isn't set yet:
```
Upgrade the engine from https://github.com/pazhenchira/meta-metacognition.git
```

**Manual fallback**: See "v3.2.0 → v4.0.0 Upgrade" section for full migration steps. The `.meta/` directory no longer exists in the engine — content is now in `.brain/`, `patterns/`, `templates/`, `skills/`, and `generators/`.

---

## v3.0.x → v3.1.1 Upgrade

**Type**: Non-breaking  
**Effort**: One sentence to your orchestrator

### What Changes

- Session-start protocol replaces per-turn compliance statements + pre-flight checklists
- Deliberation step added (assess ambiguity/blast-radius before acting)
- `lessons.md` + `status.md` for cross-session learning
- Self-upgrade protocol (orchestrator pulls engine updates itself)

---

### v3.0.0 Notes (Brain-Framework Integration)

**New Orchestration Protocols** (all additive, no breaking changes):

- **OWNERSHIP MINDSET**: Orchestrators are owners/decision-makers, not assistants. Ask about WHAT (requirements), decide HOW (implementation). No frivolous questions.
- **ORCHESTRATOR IDENTITY**: Named orchestrators (e.g., `Atlas`, `Nexus`, `Forge`) with identity statements for session continuity
- **DISPATCH PATTERNS**: Clear routing for request types (simple → complex → decision → blocked)
- **SPONSOR INTERACTION PROTOCOL**: When to ask vs decide, One Question Rule, multiple choice format
- **PHASE FRAMEWORK (P.1-P.5)**: High-level abstraction (Understand → Design → Build → Verify → Complete)
  - Complements existing Phase 0-12 detailed pipeline
  - Mapping: P.1=Phase 1-4, P.2=Phase 5-6, P.3=Phase 7-9, P.4=Phase 10-11, P.5=Phase 12
- **DIALECTIC PROCESS**: Thesis-antithesis-synthesis for important decisions
- **SESSION MANAGEMENT**: State persistence protocol with handoff documentation
- **PARALLEL ORCHESTRATION**: Workstream spawning for independent components
- **PLAYBOOK SYSTEM**: Structured checklists in `.brain/playbooks/` with TODO tracking
- **8-PERSPECTIVE DELIBERATION**: Multi-perspective decision protocol (Skeptic, Pragmatist, Systems Thinker, Operator, Economist, Adversary, Visionary, Customer Advocate)

**New State Fields** (optional, backward compatible):
```json
{
  "orchestrator_name": "[Name]",
  "active_workstream": "...",
  "next_action": "..."
}
```

**New Files**:
- `.brain/playbooks/README.md` - Playbook usage guide
- `.brain/playbooks/new-feature.md` - Feature development checklist
- `.brain/playbooks/bug-fix.md` - Bug fix checklist
- `.brain/playbooks/enhancement.md` - Enhancement checklist
- `.brain/playbooks/deliberation.md` - 8-perspective decision checklist

---

## v2.x → v3.0.0 Upgrade

**Type**: Non-breaking (all changes additive)  
**Effort**: Minimal (copy new `.meta/` folder)

### Upgrade Steps

1. **Copy new engine**:
   ```bash
   cp -r /path/to/meta-metacognition/.meta /path/to/your-app/
   ```

2. **Verify version**:
   ```bash
   cat .brain/meta/engine-version.txt
   # Should show: 3.0.0
   ```

3. **(Optional) Update state file** with new fields:
   ```json
   {
     "orchestrator_name": "YourApp-Orchestrator",
     "active_workstream": null,
     "next_action": null
   }
   ```

**That's it!** All v2.x apps work with v3.0.0 engine immediately.

---

## Previous Version (v2.x)

### v2.x Notes (Codex MCP Default + Consistency Guards)

- **App Orchestrator rename**: `.github/agents/app-orchestrator.agent.md` is now the standard (replaces `meta-app-orchestrator.agent.md`)
- **System-of-systems coordination**: new `coordination_mode` (standalone/federated/tracked/governed) and system repo scaffolding
- **Sponsor interface**: App Orchestrator is the sole contact with the human Sponsor
- **App/Sponsor Overrides**: Role-specific guardrails in `APP_OVERRIDES` blocks are preserved across upgrades
- **Strategy Gate 0**: Decision-critical apps require STR-XXX approval before PM creates FR-XXX
- **Role lock state guard**: `orchestrator_state.json` now includes `primary_role` and `role_lock` (HALT if missing/mismatched)
- **Default runtime**: `codex-cli-mcp` (MCP tools inside the Codex session)
- **Auto-setup on upgrade**: generates `.app/runtime/codex_mcp_servers.toml` with profile-scoped MCP enablement
- **Verification**: upgrade checks `codex mcp list` and requires a **Codex restart** if tools were added after session start
- **Sanity check**: each MCP tool is asked for a one-sentence role confirmation and recorded in `APP_ORCHESTRATION.md`
- **Fallback**: if MCP setup fails, fallback to `codex-cli-parallel` or single-session per `subagent_fallback`
- **Timeouts**: MCP tool calls use `mcp_tool_timeout_seconds` (default 7200s) before fallback
- **Fast-fail**: MCP warm-up pings require a response within `mcp_fastfail_seconds` (default 60s)
- **Codex config**: set `tool_timeout_sec` for each MCP server in `~/.codex/config.toml` to match `mcp_tool_timeout_seconds`
- **Multi-app safety**: namespace MCP servers as `{app_slug}__{role}` and set `cwd` to `.app/runtime/mcp/<role>` in `~/.codex/config.toml`
- **MCP role workspaces**: each MCP role server starts in `.app/runtime/mcp/<role>` with a role-specific `AGENTS.md`
- **MCP config merge**: upgrade merges only app-specific MCP blocks into `~/.codex/config.toml` (no global overrides) via `scripts/merge_codex_mcp_config.py` when shell access is available
- **MCP activation**: servers are disabled by default; start Codex with `-p <app_slug>` to enable only that app’s MCP servers
- **Sources of Truth**: apps now include a canonical files map (intent, essence, tracker, orchestration state)
- **Essence sync**: `.app/essence.md` is a generated mirror of `essence.md` (kept in sync on upgrade)
- **Consistency audit**: `python scripts/consistency_audit.py` must pass before completion
- **Triage model**: bug/feature/incident classification determines which roles/subagents are used
- **GTM Strategy Owner gate**: GTM roles run only after a unified GTM strategy is approved
- **Orchestrator discipline**: docs-first ops guidance + subagent enforcement when MCP is available
- **Identity confirmation + doc index**: app orchestrator and subagents must restate role each turn and consult the Documentation Index for ops guidance
- **Regression discipline**: Developer prevents regressions; Tester validates E2E baseline + new behavior
- **App Orchestrator overrides**: APP_OVERRIDES block in `.app/AGENTS.md` preserved on upgrade
- **Document ownership rules**: app_intent/essence/specs/docs have explicit role owners and authoring boundaries

---

## System-of-Systems Upgrade Notes (v2.0.33+)

During upgrade, the orchestrator will ask:
- Is this repo part of a system-of-systems?
- Is this the **system repo** or an **app/component repo**?
- Where is the system repo?
 - Repo host/provider, cloud provider, and permissions (push/PR/deploy/cloud)

Based on answers, it will scaffold coordination files:
- **System repo** → full repo graph + ledger + compatibility matrix
- **App/component repo** → local graph slice + inbox/outbox (tracked/governed)
 - **All repos** → `.app/agent_context.json` with operational context

## ⚠️ v1.x → v2.0.0 MAJOR UPGRADE

**Status**: Breaking changes require migration  
**Type**: Automated with rollback support  
**Time**: 30-60 minutes  

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
cat .brain/meta/engine-version.txt
# Should show: 3.1.1
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
     3. Apply `.brain/wisdom/` to all decisions - cite principles
     4. Maintain architectural alignment - validate against KISS, LEGO, essence
     5. Self-monitor for ratholing - if stuck 3+ iterations, STOP and reassess
     ```
  3. Similarly update `.github/agents/app-orchestrator.agent.md`

---

### v1.7.7 → v1.7.8

**Changes**: Agent reference fix - Corrects incorrect `.brain/playbooks/build-from-intent.md` references in generated agent files

- **What changed**:
  - Enhanced `templates/agent.template.md` with explicit warning about which file to read
  - Added "DO NOT read `.brain/playbooks/build-from-intent.md`" warning in template
  - Added validation steps in Phase 11.2 to verify correct references
  - Added validation steps in UPGRADE mode (Phase 0) to prevent incorrect generation

- **Action required**:
  - **For existing apps**: Check `.github/agents/app-orchestrator.agent.md`
  - **Line 16 should say**: "You read `AGENTS.md` (root) for app-specific logic"
  - **If says `.brain/playbooks/build-from-intent.md`**: This is the bug - agent will read engine logic instead of app logic
  - **To fix manually**: 
    1. Open `.github/agents/app-orchestrator.agent.md`
    2. Find line that says "You read `.brain/playbooks/build-from-intent.md`" or references engine file
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
  - New `[P-WEB]` principle in `.brain/principles.md` guides agents to search online documentation
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
  - New template: `templates/AGENTS.codex.template.md` for Codex configuration
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
  - Both reference same `.brain/playbooks/build-from-intent.md` for engine logic

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
  - `templates/agent.template.md` updated (no tools restriction)
  
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
  - **Manual alternative**: Create `.github/agents/{your-app}.agent.md` using `templates/agent.template.md`
  
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

#### 2. `.brain/meta/engine-version.txt` File

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

## Implementation in .brain/playbooks/build-from-intent.md

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
   - Compare with current meta-orchestrator `.brain/meta/engine-version.txt`
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
✅ **Track versions** with `.meta-version` and `.brain/meta/engine-version.txt`  
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
- Pre-flight Checklist in `.brain/playbooks/build-from-intent.md` (prevents agent amnesia)
- App-specific AGENTS.md template (`templates/AGENTS.template.md`)
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
