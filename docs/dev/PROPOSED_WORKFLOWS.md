# Proposed Workflows for Meta-Orchestrator v2.0

## Overview

This document describes the workflow model for the refactored meta-orchestrator system based on:
- **Workspace-centric execution** (`.workspace/WI-XXX/`)
- **Role-specific instructions** (`.app/roles/`)
- **Multi-role blocking approval gates**
- **Immutable artifacts** (`specs/`)
- **Self-documenting LEGOs** (`legos/*/`)
- **Git-enabled by default**

---

## Core Principles

1. **`.app/` is frozen** - Only modified during engine upgrades
2. **`.workspace/` is ephemeral** - Deleted after work item completion
3. **Specs are immutable** - Changes require new work item + new spec
4. **All roles must approve** - Blocking approval before promotion
5. **LEGOs are regenerable** - Docs contain complete specification
6. **Git is source of truth** - All changes versioned, workspace deletion is safe

---

## Work Item Lifecycle

```
BACKLOG → ACTIVE → IN_REVIEW → APPROVED → COMPLETE → [WORKSPACE DELETED]
   ↓                                                         ↓
tracker.json                                          Git history only
```

### State Definitions

| State | Meaning | `.workspace/WI-XXX/` Exists? | `tracker.json` Entry? |
|-------|---------|------------------------------|----------------------|
| **BACKLOG** | Queued, not started | ❌ No | ✅ Yes |
| **ACTIVE** | Work in progress | ✅ Yes | ✅ Yes |
| **IN_REVIEW** | Artifacts awaiting multi-role approval | ✅ Yes | ✅ Yes |
| **APPROVED** | All approvals received, promoting artifacts | ✅ Yes | ✅ Yes |
| **COMPLETE** | Artifacts promoted, workspace deleted | ❌ No (deleted) | ✅ Yes (history) |

---

## Workflow #1: New Feature

### Phase 1: Discovery (Product Manager)

**Trigger**: User edits `app_intent.md` OR asks in chat "Add feature X"

**Steps**:
1. **App-Orchestrator creates work item**:
   ```bash
   mkdir .workspace/WI-001
   echo "Feature: Add sentiment analysis" > .workspace/WI-001/README.md
   ```

2. **Switch to PM role** (reads `.app/roles/product_manager.md` ONLY):
   - Discovers essence alignment (does feature serve core value?)
   - Asks clarifying questions (2-3 max)
   - Creates `.workspace/WI-001/pm/FR-001-draft.md`

3. **Multi-role review gate**:
   - PM marks draft complete in `.workspace/WI-001/todos.md`
   - Orchestrator switches to each reviewer role sequentially:
     - **Architect** (reads `.app/roles/architect.md`): Reviews FR-001 for feasibility
     - **Developer** (reads `.app/roles/developer.md`): Reviews for implementability
     - **Tester** (reads `.app/roles/tester.md`): Reviews for testability
     - **Writer** (reads `.app/roles/writer.md`): Reviews for documentability
   - Each role writes feedback to `.workspace/WI-001/reviews/FR-001_reviews.md`

4. **Approval decision**:
   - If **all 5 approve** (APPROVED ✅):
     - Promote `FR-001-draft.md` → `specs/features/FR-001.md` (immutable)
     - Mark readonly: `chmod 444 specs/features/FR-001.md`
     - Delete `.workspace/WI-001/pm/` (no longer needed)
     - Git commit: `git add specs/features/FR-001.md && git commit -m "Add FR-001: Sentiment analysis"`
   - If **any reject**:
     - PM addresses feedback (updates draft)
     - Re-submit for review (repeat cycle)

### Phase 2: Design (Architect)

**Trigger**: FR-001 approved

**Steps**:
1. **Switch to Architect role** (reads `.app/roles/architect.md` ONLY):
   - Reads `specs/features/FR-001.md` (immutable spec)
   - Analyzes LEGO impact (which LEGOs affected?)
   - Updates `legos/_manifest.json` (dependency graph)
   - Creates `.workspace/WI-001/architect/DD-001-draft.md`
   - Creates `.workspace/WI-001/architect/lego_impact.md`:
     ```markdown
     # LEGO Impact Analysis
     
     ## New LEGOs
     - `sentiment_analyzer` (new, no dependencies)
     
     ## Modified LEGOs
     - `signal_generator` (adds call to sentiment_analyzer)
     
     ## Interface Changes
     - `signal_generator.interface.md`: Add parameter `include_sentiment: bool`
     - **BREAKING CHANGE**: Yes (default False for backward compat)
     
     ## Affected Callers
     - `legos/_manifest.json` shows: `report_generator` calls `signal_generator`
     - **Action Required**: Update `report_generator` to handle new parameter
     ```

2. **Multi-role review gate** (same process as Phase 1):
   - All 5 roles review DD-001-draft.md
   - If approved → promote to `specs/design/DD-001.md` (immutable)
   - Delete `.workspace/WI-001/architect/`

### Phase 3: Implementation (Developer)

**Trigger**: DD-001 approved

**Steps**:
1. **Switch to Developer role** (reads `.app/roles/developer.md` ONLY):
   - Reads `specs/features/FR-001.md` and `specs/design/DD-001.md`
   - Creates new LEGO: `.workspace/WI-001/developer/sentiment_analyzer/`
   - Writes complete LEGO docs:
     - `README.md` (internal spec - can recreate code)
     - `interface.md` (executable contract)
     - `workflows.md` (inter-LEGO interactions)
   - Implements code in `src/` (temporary location during development)

2. **LEGO doc review gate**:
   - Before coding, LEGO docs reviewed by Architect + Tester
   - Ensures interface contract is clear
   - If approved → proceed to implementation

3. **Implementation**:
   - Writes tests first (TDD)
   - Implements code
   - Runs tests locally
   - Updates `legos/_manifest.json` (add sentiment_analyzer entry)

4. **Final review gate**:
   - All roles review implementation
   - If approved:
     - Promote LEGO docs → `legos/sentiment_analyzer/`
     - Promote code → `legos/sentiment_analyzer/src/`
     - Git commit
     - Delete `.workspace/WI-001/developer/`

### Phase 4: Testing (Tester)

**Trigger**: Implementation approved

**Steps**:
1. **Switch to Tester role** (reads `.app/roles/tester.md` ONLY):
   - Reads FR-001, DD-001 (immutable specs)
   - Creates `.workspace/WI-001/tester/TP-001-draft.md`
   - Writes test cases (unit, integration, e2e)
   - Runs tests against implemented code

2. **Multi-role review gate**:
   - All roles review test plan
   - If approved → promote to `specs/test_plans/TP-001.md`
   - Promote tests → `tests/`
   - Delete `.workspace/WI-001/tester/`

### Phase 5: Documentation (Writer)

**Trigger**: Tests approved

**Steps**:
1. **Switch to Writer role** (reads `.app/roles/writer.md` ONLY):
   - Reads FR-001 (feature spec)
   - Writes customer-facing docs in `.workspace/WI-001/writer/`
   - Updates `docs/user_guide.md`, `docs/api_reference.md`

2. **Multi-role review gate**:
   - All roles review docs (clarity, accuracy)
   - If approved → promote to `docs/`
   - Update `CHANGELOG.md` (user-visible change)
   - Delete `.workspace/WI-001/writer/`

### Phase 6: Completion

**Trigger**: All artifacts approved and promoted

**Steps**:
1. **Final validation**:
   - All specs promoted to `specs/`
   - All LEGO docs promoted to `legos/`
   - All code committed to git
   - All tests passing

2. **Workspace cleanup**:
   ```bash
   git add -A
   git commit -m "Complete WI-001: Sentiment analysis feature"
   rm -rf .workspace/WI-001/
   ```

3. **Update tracker**:
   ```json
   {
     "work_items": [
       {
         "id": "WI-001",
         "state": "COMPLETE",
         "created": "2025-12-06T10:00:00Z",
         "completed": "2025-12-06T14:30:00Z",
         "state_transitions": [
           {"from": "BACKLOG", "to": "ACTIVE", "timestamp": "2025-12-06T10:00:00Z"},
           {"from": "ACTIVE", "to": "IN_REVIEW", "timestamp": "2025-12-06T12:00:00Z"},
           {"from": "IN_REVIEW", "to": "APPROVED", "timestamp": "2025-12-06T13:30:00Z"},
           {"from": "APPROVED", "to": "COMPLETE", "timestamp": "2025-12-06T14:30:00Z"}
         ],
         "artifacts": [
           "specs/features/FR-001.md",
           "specs/design/DD-001.md",
           "specs/test_plans/TP-001.md",
           "legos/sentiment_analyzer/",
           "docs/user_guide.md (updated)"
         ]
       }
     ]
   }
   ```

---

## Workflow #2: Enhancement (Modify Existing Feature)

**Difference from New Feature**:
- New spec references original spec (e.g., FR-002 references FR-001)
- LEGO modifications tracked in `legos/_manifest.json` (version bump)
- Breaking changes detected via interface hash comparison
- Affected LEGOs identified from dependency graph

**Example**:
```markdown
# FR-002: Enhance Sentiment Analysis with Multi-Language Support

**References**: FR-001 (original sentiment analysis feature)

**Changes to Original**:
- FR-001 specified English-only
- FR-002 adds Spanish, French, German support
- Backward compatible (English remains default)

**LEGO Impact**:
- `sentiment_analyzer` version: 1.0.0 → 1.1.0 (non-breaking)
- Interface change: Add `language` parameter (default="en")
- No callers affected (parameter is optional)
```

---

## Workflow #3: Bug Fix

**Difference from Enhancement**:
- Bug spec (BUG-001) references original spec + design doc
- Identifies "deviation from spec" (spec was correct, implementation wrong)
- OR identifies "spec was wrong" (requires new spec to correct)
- Root cause analysis required

**Example**:
```markdown
# BUG-001: Sentiment Analyzer Crashes on Empty Input

**References**: 
- FR-001 (feature spec)
- DD-001 (design doc - specified null check)

**Root Cause**:
- DD-001 specified: "Validate input is non-empty before processing"
- Implementation: Missing null check
- **Deviation**: Implementation did not follow design

**Fix**:
- Add input validation (as originally specified)
- Add test case for empty input
- No spec changes needed (spec was correct)

**LEGO Impact**:
- `sentiment_analyzer` version: 1.1.0 → 1.1.1 (patch)
- No interface changes
- No callers affected
```

---

## Role Switching Mechanism

**Key Principle**: Copilot/Codex CLI reads ONLY the relevant role file when switching contexts.

### Implementation:

**Option A: Explicit Role Files**
```markdown
# .app/roles/product_manager.md

You are the PRODUCT MANAGER for this app.

**Your Responsibilities**:
- Feature discovery (essence alignment)
- Writing feature specs (FR-XXX)
- Customer value validation

**Your Wisdom** (inlined, no .meta/ references):
[PM-specific principles from .meta/wisdom/ - inlined here]

**Your Artifacts**:
- Feature specs (FR-XXX) in .workspace/WI-XXX/pm/
- Move to specs/features/ after approval

**Review Responsibilities**:
- Review architect designs (feasibility)
- Review developer code (matches spec)
- Review tester plans (covers requirements)
- Review writer docs (accurate representation)
```

**Option B: Orchestrator Activates Role**
```markdown
# In .app/AGENTS.md

## Role Activation

When switching to a role:
1. Read `.app/roles/{role_name}.md` ONLY
2. Ignore all other role files
3. Execute role's responsibilities
4. Hand off to next role via review gate
```

**Option C: Git-like Context Switching** (Most Elegant)
```bash
# Orchestrator command:
codex --context .app/roles/product_manager.md "Write FR-001 for sentiment analysis"

# This ensures only PM context is loaded
```

---

## Idempotent Restart Model

**Scenario**: Copilot session ends mid-work-item. How to resume?

### Restart Procedure:

1. **Orchestrator reads state**:
   ```bash
   cat .workspace/tracker.json  # Identifies active work item: WI-001
   cd .workspace/WI-001
   cat README.md                # What is this work item?
   cat todos.md                 # What's complete? What's pending?
   ```

2. **Identify current phase**:
   ```markdown
   # todos.md
   - [x] PM: Write FR-001
   - [x] Architect: Review FR-001
   - [x] Developer: Review FR-001
   - [x] Tester: Review FR-001
   - [x] Writer: Review FR-001
   - [x] Orchestrator: Approve FR-001 (promoted to specs/features/)
   - [x] Architect: Write DD-001
   - [ ] PM: Review DD-001  ← CURRENT TASK
   ```

3. **Resume execution**:
   - Orchestrator: "I see WI-001 is waiting for PM review of DD-001"
   - Switch to PM role
   - Read `.workspace/WI-001/architect/DD-001-draft.md`
   - Execute review
   - Update `todos.md` and `reviews/DD-001_reviews.md`

**Key Point**: No context loss because all state is in files:
- `tracker.json` = global state
- `.workspace/WI-XXX/README.md` = work item context
- `.workspace/WI-XXX/todos.md` = progress tracking
- `.workspace/WI-XXX/reviews/*.md` = review history

---

## Questions for You:

**Q1: Role Switching Preference**
Which option do you prefer?
- **Option A**: Role files are complete standalone contexts
- **Option B**: Orchestrator explicitly activates role (reads file)
- **Option C**: Git-like context switching (pass file to Codex CLI)

**Q2: LEGO Regeneration Trigger**
When should code be regenerated from LEGO docs?
- **A)** Only during bug fixes (code diverged from spec)
- **B)** Periodically (to apply new wisdom/patterns)
- **C)** Never (code is source of truth after initial generation)

**Q3: Breaking Change Policy**
When `signal_generator` interface changes (breaking):
- **A)** Block until all callers updated (strict)
- **B)** Allow with deprecation warning (gradual)
- **C)** Version both interfaces (v1 + v2 coexist)

**Q4: Auto-Documentation Scope**
Should "auto-documentation" mean:
- **A)** Code has comprehensive inline comments
- **B)** LEGO docs stay synced with code (README.md updated)
- **C)** Both A + B + generated API docs (e.g., from docstrings)

**Q5: Workspace Archival**
You said "delete immediately", but should we:
- **A)** Git commit before deleting (history is enough)
- **B)** Tar archive to `.workspace/archive/` (extra backup)
- **C)** Just delete (trust git completely)

Your answers will finalize the workflow model!
