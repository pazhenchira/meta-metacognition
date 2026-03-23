# Meta-Orchestrator v2.0 - Final Directory Structure

**Status**: Design Complete, Ready for Implementation  
**Date**: 2025-12-06  
**Version**: 2.0.0 (Major Refactor)

---

## Overview

This document defines the **final, approved directory structure** for the refactored meta-orchestrator system.

**Key Design Principles**:
1. **`.app/` is frozen** - Only modified during engine upgrades (prevents tampering)
2. **`.workspace/` is ephemeral** - Deleted after work item completion (git is source of truth)
3. **`specs/` is immutable** - Changes require new work item + new spec
4. **`legos/` are self-documenting** - Docs can regenerate code completely
5. **Multi-role blocking approval** - All 5 roles approve before artifact promotion
6. **Git-enabled by default** - All changes versioned, no extra archives needed

---

## Complete Directory Tree

```
my-awesome-app/                    # Git-enabled repository root
│
├── .git/                          # VERSION CONTROL (initialized at app creation)
│   └── [standard git structure]
│
├── .meta/                         # ENGINE (stable, only changed during upgrades)
│   ├── AGENTS.md                  # Meta-orchestrator (CREATE/UPGRADE mode)
│   ├── generators/                # Templates for generating .app/
│   │   ├── app_agents.template.md
│   │   └── app_folder_generation.md
│   ├── roles/                     # Role TEMPLATES (source of truth)
│   │   ├── product_manager.md
│   │   ├── architect.md
│   │   ├── developer.md
│   │   ├── tester.md
│   │   ├── writer.md
│   │   └── operations.md
│   ├── workflows/                 # Workflow TEMPLATES
│   │   ├── new_feature.md
│   │   ├── enhancement.md
│   │   ├── bug_fix.md
│   │   └── REVIEW_GATES.md
│   ├── wisdom/                    # Full wisdom library
│   │   ├── engineering_wisdom.md
│   │   ├── strategic_wisdom.md
│   │   ├── design_wisdom.md
│   │   └── risk_wisdom.md
│   ├── patterns/                  # Antipatterns & success patterns
│   │   ├── antipatterns.md
│   │   ├── success_patterns.md
│   │   └── trade_off_matrix.md
│   ├── principles.md              # Global principles (KISS, LEGO, etc.)
│   ├── intent.md                  # Meta-orchestrator philosophy
│   └── VERSION                    # Engine version (e.g., 2.0.0)
│
├── .app/                          # 🧠 READ-ONLY AGENT BRAIN (frozen except during upgrades)
│   ├── AGENTS.md                  # App orchestrator (self-contained, no .meta/ refs)
│   ├── essence.md                 # App's value proposition
│   ├── roles/                     # ROLE-SPECIFIC INSTRUCTIONS (adapted from .brain/roles/)
│   │   ├── product_manager.md     # PM sees ONLY PM wisdom/instructions
│   │   ├── architect.md           # Architect sees ONLY Architect wisdom
│   │   ├── developer.md           # Developer sees ONLY Developer wisdom
│   │   ├── tester.md              # Tester sees ONLY Tester wisdom
│   │   ├── writer.md              # Writer sees ONLY Writer wisdom
│   │   └── operations.md          # Operations sees ONLY Ops wisdom (required)
│   ├── workflows/                 # Workflow definitions (adapted from .brain/playbooks/)
│   │   ├── new_feature.md
│   │   ├── enhancement.md
│   │   ├── bug_fix.md
│   │   └── REVIEW_GATES.md
│   ├── wisdom/                    # Inlined principles (no external refs)
│   │   └── core_principles.md
│   └── .engine-version            # Which .brain/meta/engine-version.txt built this (e.g., "2.0.0")
│
├── .workspace/                    # ⚙️ ACTIVE WORK AREA (ephemeral per work item)
│   ├── tracker.json               # 🎯 GLOBAL WORK ITEM LOG (survives workspace deletion)
│   │                              # Schema:
│   │                              # {
│   │                              #   "work_items": [
│   │                              #     {
│   │                              #       "id": "WI-001",
│   │                              #       "type": "new_feature" | "enhancement" | "bug_fix",
│   │                              #       "title": "Add sentiment analysis",
│   │                              #       "state": "COMPLETE",
│   │                              #       "created": "2025-12-06T10:00:00Z",
│   │                              #       "completed": "2025-12-06T14:30:00Z",
│   │                              #       "state_transitions": [
│   │                              #         {"from": "BACKLOG", "to": "ACTIVE", "timestamp": "..."},
│   │                              #         {"from": "ACTIVE", "to": "IN_REVIEW", "timestamp": "..."},
│   │                              #         {"from": "IN_REVIEW", "to": "APPROVED", "timestamp": "..."},
│   │                              #         {"from": "APPROVED", "to": "COMPLETE", "timestamp": "..."}
│   │                              #       ],
│   │                              #       "artifacts": [
│   │                              #         "specs/features/FR-001.md",
│   │                              #         "specs/design/DD-001.md",
│   │                              #         "specs/test_plans/TP-001.md",
│   │                              #         "legos/sentiment_analyzer/"
│   │                              #       ]
│   │                              #     }
│   │                              #   ],
│   │                              #   "backlog": ["WI-002", "WI-003"],
│   │                              #   "active": ["WI-001"],
│   │                              #   "current_work_item": "WI-001"
│   │                              # }
│   │
│   ├── WI-001/                    # Work item folder (DELETED when state=COMPLETE)
│   │   ├── README.md              # Work item overview
│   │   │                          # - What: Feature description
│   │   │                          # - Why: Business justification (essence alignment)
│   │   │                          # - Status: Current phase (PM → Architect → Dev → Test → Write)
│   │   │                          # - Blocked by: Dependencies (if any)
│   │   │
│   │   ├── todos.md               # ✅ CHECKLIST (tracks progress)
│   │   │                          # Example:
│   │   │                          # - [x] PM: Write FR-001
│   │   │                          # - [x] Architect: Review FR-001
│   │   │                          # - [x] Developer: Review FR-001
│   │   │                          # - [x] Tester: Review FR-001
│   │   │                          # - [x] Writer: Review FR-001
│   │   │                          # - [x] Orchestrator: Approve FR-001 (promoted)
│   │   │                          # - [x] Architect: Write DD-001
│   │   │                          # - [ ] PM: Review DD-001  ← CURRENT TASK
│   │   │
│   │   ├── pm/                    # Product Manager workspace
│   │   │   ├── FR-001-draft.md    # Feature spec (work in progress)
│   │   │   └── discovery_notes.md # Essence alignment analysis
│   │   │
│   │   ├── architect/             # Architect workspace
│   │   │   ├── DD-001-draft.md    # Design doc (work in progress)
│   │   │   ├── control_flow.md    # Control & data flow analysis
│   │   │   └── lego_impact.md     # Which LEGOs affected (breaking changes?)
│   │   │
│   │   ├── developer/             # Developer workspace
│   │   │   ├── impl_notes.md      # Implementation approach
│   │   │   ├── prototype.py       # Experimental code (throwaway)
│   │   │   └── sentiment_analyzer/  # New LEGO (work in progress)
│   │   │       ├── README.md      # Complete spec (can regenerate code)
│   │   │       ├── interface.md   # Executable contract
│   │   │       ├── workflows.md   # Inter-LEGO interactions
│   │   │       └── src/           # Implementation (temp until approved)
│   │   │
│   │   ├── tester/                # Tester workspace
│   │   │   ├── TP-001-draft.md    # Test plan (work in progress)
│   │   │   ├── edge_cases.md      # Edge case analysis
│   │   │   └── test_results.md    # Test run logs
│   │   │
│   │   ├── writer/                # Writer workspace
│   │   │   ├── user_guide_draft.md  # External docs (work in progress)
│   │   │   └── api_docs_draft.md
│   │   │
│   │   └── reviews/               # 🔍 MULTI-ROLE REVIEW FEEDBACK
│   │       ├── FR-001_reviews.md  # PM spec reviews:
│   │       │                      # ---
│   │       │                      # Architect: APPROVED ✅ - feasible, maps to LEGOs
│   │       │                      # Developer: APPROVED ✅ - implementable with existing stack
│   │       │                      # Tester: APPROVED ✅ - testable, clear acceptance criteria
│   │       │                      # Writer: APPROVED ✅ - can document for end users
│   │       │                      # Orchestrator: APPROVED ✅ (promotes to specs/features/)
│   │       │                      # ---
│   │       ├── DD-001_reviews.md
│   │       ├── TP-001_reviews.md
│   │       └── code_reviews.md
│   │
│   └── WI-002/                    # Next work item (active or backlog)
│
├── external_input/                # 📥 USER-PROVIDED CONTEXT (user manages lifecycle)
│   ├── competitor_analysis.pdf    # User uploads, user deletes
│   ├── api_spec.json              # External API documentation
│   └── README.md                  # User's notes: "Delete after WI-003 completes"
│
├── legos/                         # 🧱 LEGO BLOCKS (self-contained, regenerable from docs)
│   ├── _manifest.json             # 🎯 LEGO REGISTRY
│   │                              # Schema:
│   │                              # {
│   │                              #   "legos": [
│   │                              #     {
│   │                              #       "name": "signal_generator",
│   │                              #       "version": "1.0.0",
│   │                              #       "dependencies": ["market_data_fetcher", "greeks_calculator"],
│   │                              #       "interface_hash": "sha256:abc123...",
│   │                              #       "breaking_changes": [
│   │                              #         {
│   │                              #           "version": "1.0.0",
│   │                              #           "change": "Initial release",
│   │                              #           "affected_callers": []
│   │                              #         }
│   │                              #       ]
│   │                              #     }
│   │                              #   ],
│   │                              #   "dependency_graph": {
│   │                              #     "signal_generator": ["market_data_fetcher", "greeks_calculator"],
│   │                              #     "market_data_fetcher": [],
│   │                              #     "greeks_calculator": []
│   │                              #   }
│   │                              # }
│   │
│   ├── config_validator/
│   │   ├── README.md              # 📘 COMPLETE INTERNAL SPEC (can regenerate code from this)
│   │   │                          # Must include:
│   │   │                          # - Purpose & Responsibility (single responsibility)
│   │   │                          # - Dependencies (which LEGOs does this call?)
│   │   │                          # - Interface Contract (see interface.md for details)
│   │   │                          # - Implementation Strategy (algorithms, data structures)
│   │   │                          # - Error Handling (what exceptions, when, why)
│   │   │                          # - Testing Strategy (unit, integration, edge cases)
│   │   │                          # - Usage Examples (how other LEGOs call this)
│   │   │                          # - Performance Characteristics (O(n), memory usage)
│   │   │
│   │   ├── interface.md           # 📐 EXECUTABLE INTERFACE CONTRACT
│   │   │                          # Must include:
│   │   │                          # - Function signatures (exact API, types)
│   │   │                          # - Input schemas (validation rules, constraints)
│   │   │                          # - Output schemas (return types, structures)
│   │   │                          # - Error conditions (exceptions raised, when)
│   │   │                          # - Side effects (file writes, network calls, state mutations)
│   │   │                          # - Thread safety (safe? requires locks?)
│   │   │                          # - Performance guarantees (latency, throughput)
│   │   │                          # - Breaking change policy (how changes announced)
│   │   │                          #
│   │   │                          # Example:
│   │   │                          # ```python
│   │   │                          # def validate_config(config_path: str) -> ConfigValidationResult:
│   │   │                          #     """
│   │   │                          #     Validates application configuration file.
│   │   │                          #     
│   │   │                          #     Args:
│   │   │                          #         config_path: Path to config file (must exist)
│   │   │                          #     
│   │   │                          #     Returns:
│   │   │                          #         ConfigValidationResult with:
│   │   │                          #         - is_valid: bool
│   │   │                          #         - errors: List[ValidationError]
│   │   │                          #         - warnings: List[ValidationWarning]
│   │   │                          #     
│   │   │                          #     Raises:
│   │   │                          #         FileNotFoundError: config_path doesn't exist
│   │   │                          #         PermissionError: can't read config_path
│   │   │                          #         JSONDecodeError: config file malformed
│   │   │                          #     
│   │   │                          #     Side Effects:
│   │   │                          #         - Reads file from disk
│   │   │                          #         - May write to log file
│   │   │                          #         - No network calls
│   │   │                          #         - No state mutations
│   │   │                          #     
│   │   │                          #     Thread Safety: Thread-safe (read-only)
│   │   │                          #     Performance: O(n) where n=config file size
│   │   │                          #     """
│   │   │                          # ```
│   │   │
│   │   ├── workflows.md           # 🔄 INTER-LEGO INTERACTIONS
│   │   │                          # Must include:
│   │   │                          # - Which LEGOs call this? (callers)
│   │   │                          # - Which LEGOs does this call? (callees)
│   │   │                          # - Call sequences (normal flow, error flow)
│   │   │                          # - Error propagation (how errors bubble up)
│   │   │                          # - Data flow (what data moves between LEGOs)
│   │   │                          #
│   │   │                          # Example:
│   │   │                          # ## Callers
│   │   │                          # - `app_bootstrap` (calls on startup)
│   │   │                          # - `config_reload_handler` (calls on SIGHUP)
│   │   │                          #
│   │   │                          # ## Callees
│   │   │                          # - None (leaf node in dependency graph)
│   │   │                          #
│   │   │                          # ## Normal Flow
│   │   │                          # 1. Caller passes config_path
│   │   │                          # 2. Validator reads file
│   │   │                          # 3. Validator checks schema
│   │   │                          # 4. Returns result
│   │   │                          #
│   │   │                          # ## Error Flow
│   │   │                          # - File missing → FileNotFoundError → caller handles
│   │   │                          # - Malformed JSON → JSONDecodeError → caller handles
│   │   │                          # - Invalid schema → result.is_valid=False → caller checks
│   │   │
│   │   └── src/                   # Implementation (regenerable from above docs)
│   │       ├── config_validator.py
│   │       ├── __init__.py
│   │       └── tests/             # Tests live WITH code (co-located)
│   │           ├── test_config_validator.py
│   │           └── test_edge_cases.py
│   │
│   ├── signal_generator/
│   │   ├── README.md              # Complete internal spec
│   │   ├── interface.md           # Executable contract
│   │   ├── workflows.md           # Inter-LEGO interactions
│   │   └── src/
│   │       ├── signal_generator.py
│   │       ├── __init__.py
│   │       └── tests/
│   │
│   └── market_data_fetcher/
│       ├── README.md
│       ├── interface.md
│       ├── workflows.md
│       └── src/
│
├── specs/                         # 🔒 IMMUTABLE APPROVED SPECIFICATIONS
│   ├── features/                  # FR-XXX (from PM, approved by all 5 roles)
│   │   ├── FR-001.md              # IMMUTABLE (chmod 444 after promotion)
│   │   └── FR-002.md              # New spec (references FR-001 if enhancement)
│   ├── design/                    # DD-XXX (from Architect, approved by all)
│   │   ├── DD-001.md
│   │   └── DD-002.md
│   └── test_plans/                # TP-XXX (from Tester, approved by all)
│       ├── TP-001.md
│       └── TP-002.md
│
├── tests/                         # 🧪 TEST SUITES (shared/integration/e2e)
│   ├── integration/               # Cross-LEGO tests
│   │   ├── test_signal_generation_flow.py
│   │   └── test_config_validation_flow.py
│   └── e2e/                       # End-to-end user journeys
│       ├── test_user_onboarding.py
│       └── test_signal_workflow.py
│
├── docs/                          # 📚 DOCUMENTATION (separated by audience)
│   ├── README.md                  # Landing page (navigation guide)
│   │                              # "For users, see docs/user/"
│   │                              # "For developers, see docs/dev/"
│   │
│   ├── user/                      # EXTERNAL (customer-facing)
│   │   ├── getting-started.md     # Quick start guide
│   │   ├── user-guide.md          # How to use the app
│   │   ├── api-reference.md       # Public API docs (auto-generated from docstrings)
│   │   ├── troubleshooting.md     # Common issues & solutions
│   │   └── faq.md                 # Frequently asked questions
│   │
│   └── dev/                       # INTERNAL (developer/agent-facing)
│       ├── architecture.md        # System architecture overview
│       ├── design-decisions.md    # ADRs (Architecture Decision Records)
│       ├── contributing.md        # How to contribute (for humans/agents)
│       ├── testing-strategy.md    # Testing philosophy
│       └── deployment.md          # Internal deployment notes
│
├── app_intent.md                  # ORIGINAL USER INTENT (user edits to add features)
├── AGENTS.md                      # ROUTER (points to .app/AGENTS.md for maintenance)
│                                  # Also handles mode detection (CREATE/UPGRADE/MAINTAIN)
├── CHANGELOG.md                   # USER-VISIBLE CHANGES (updated when specs promoted)
├── APP_ORCHESTRATION.md           # DECISION LOG (high-level decisions, rationale)
└── .gitignore                     # Ignores .workspace/ during active work (removed after completion)
```

---

## Work Item States

| State | `.workspace/WI-XXX/` | `tracker.json` | Meaning |
|-------|---------------------|----------------|---------|
| **BACKLOG** | ❌ No | ✅ Yes | Queued, not started |
| **ACTIVE** | ✅ Yes | ✅ Yes | Work in progress |
| **IN_REVIEW** | ✅ Yes | ✅ Yes | Awaiting multi-role approval |
| **APPROVED** | ✅ Yes | ✅ Yes | All approved, promoting artifacts |
| **COMPLETE** | ❌ No (deleted) | ✅ Yes (history) | Done, workspace cleaned up |

---

## Role-Specific Context Isolation

**How Orchestrator Switches Roles**:

1. **Orchestrator reads** `.workspace/WI-001/todos.md`
2. **Identifies current task**: "PM: Review DD-001"
3. **Switches to PM role**:
   - Reads **ONLY** `.app/roles/product_manager.md` (no other role files)
   - PM wisdom inlined (no .meta/ references)
   - PM sees only PM-relevant principles
4. **PM executes review**:
   - Reads `.workspace/WI-001/architect/DD-001-draft.md`
   - Writes feedback to `.workspace/WI-001/reviews/DD-001_reviews.md`
   - Updates `.workspace/WI-001/todos.md` (marks task complete)
5. **Orchestrator steps back**:
   - Checks if all reviewers done
   - If yes → promotes artifact
   - If no → switches to next reviewer role

**Critical**: Orchestrator never loads multiple role contexts simultaneously. One role at a time.

---

## LEGO Regeneration Policy

**When to Regenerate Code from LEGO Docs**:

Trigger: Developer or Architect determines implementation needs **complete overhaul**

**Scenarios**:
1. **Different algorithm** (e.g., switch from polling to webhooks)
2. **Different data source** (e.g., switch from REST API to GraphQL)
3. **Architectural refactor** (e.g., split monolithic LEGO into 3 smaller LEGOs)
4. **New requirements** that invalidate current approach

**Process**:
1. Update `legos/my_lego/README.md` (new implementation strategy)
2. Update `legos/my_lego/interface.md` (if interface changes)
3. Update `legos/my_lego/workflows.md` (if interactions change)
4. Delete `legos/my_lego/src/` (old implementation)
5. Regenerate code from updated docs
6. Multi-role review of docs + code
7. Approve → commit

**Not Regeneration** (normal development):
- Bug fixes (code diverged from spec → fix code)
- Refactoring (improve code quality without changing behavior)
- Performance optimization (same algorithm, better implementation)

---

## Breaking Change Policy

**Policy**: Just break and discover through tests/docs (no deprecation, no versioning)

**Process**:
1. Architect updates `legos/my_lego/interface.md` (breaking change)
2. Update `legos/_manifest.json`:
   ```json
   {
     "name": "signal_generator",
     "version": "2.0.0",  // ← Major version bump
     "breaking_changes": [
       {
         "version": "2.0.0",
         "change": "Renamed parameter: include_sentiment → sentiment_enabled",
         "affected_callers": ["report_generator", "alert_system"]
       }
     ]
   }
   ```
3. Tests break (intentionally):
   ```
   test_report_generator.py: FAILED
   TypeError: unexpected keyword argument 'include_sentiment'
   ```
4. Developer updates affected callers:
   - `report_generator`: Change `include_sentiment` → `sentiment_enabled`
   - `alert_system`: Change `include_sentiment` → `sentiment_enabled`
5. Tests pass → breaking change complete

**Why No Deprecation**:
- Fast feedback loop (tests tell you what broke)
- No technical debt (no deprecated code paths)
- Clear ownership (dependency graph shows affected callers)
- Simple mental model (one version, always current)

---

## Auto-Documentation Scope

**What "Auto-Documentation" Means**:

1. **Inline Code Comments** (comprehensive):
   ```python
   def calculate_sharpe_ratio(returns: List[float], risk_free_rate: float = 0.02) -> float:
       """
       Calculate Sharpe ratio for investment returns.
       
       Sharpe ratio = (mean_return - risk_free_rate) / std_deviation
       Higher values indicate better risk-adjusted returns.
       
       Args:
           returns: List of periodic returns (e.g., daily, monthly)
           risk_free_rate: Risk-free rate (default: 2% annually)
       
       Returns:
           Sharpe ratio (dimensionless)
       
       Raises:
           ValueError: If returns list is empty or all identical (std=0)
       
       Example:
           >>> returns = [0.01, 0.02, -0.005, 0.015]
           >>> sharpe = calculate_sharpe_ratio(returns)
           >>> print(f"Sharpe: {sharpe:.2f}")
           Sharpe: 1.23
       """
   ```

2. **LEGO Doc Sync** (README.md stays current):
   - When code changes, Developer updates `legos/my_lego/README.md`
   - Review gate: Architect verifies docs match implementation
   - If docs outdated → block approval until synced

3. **Generated API Docs** (from docstrings):
   - Use Sphinx/pdoc/pydoc to auto-generate `docs/user/api-reference.md`
   - Runs during Writer phase (after code approved)
   - Committed alongside code (versioned together)

**Not Auto-Documentation**:
- Architectural decisions (manual ADRs in `docs/dev/design-decisions.md`)
- User guides (manual, written by Writer role)
- Rationale for trade-offs (manual, in APP_ORCHESTRATION.md)

---

## Git Integration

**Initialized at App Creation**:
```bash
git init
git add .
git commit -m "Initial app structure (created by meta-orchestrator v2.0.0)"
```

**Workspace Management**:
- `.workspace/` is **NOT** in `.gitignore` during active work
- Committed after each phase completion
- Deleted only after work item COMPLETE
- Git history preserves all decisions (can recreate workspace from commits if needed)

**Commit Strategy**:
- Small, atomic commits per artifact promotion
- Clear commit messages: `"Add FR-001: Sentiment analysis"`
- Tag releases: `git tag v1.0.0`

**Alternative VCS**:
- If app uses Mercurial/SVN/etc., orchestrator adapts
- VCS choice stored in `app_intent.md` or detected from repo

---

## Migration Path (v1.x → v2.0)

For existing apps built with meta-orchestrator v1.x:

1. **Backup**: `git tag v1-backup`
2. **Copy new .meta/**: From meta-metacognition v2.0
3. **Upgrade mode**: Orchestrator detects `.app/.engine-version` < `2.0.0`
4. **Generate .workspace/**: Create tracker.json, initial structure
5. **Generate legos/**: Migrate existing code into LEGO structure
6. **Generate .app/**: Self-contained orchestrator with inlined wisdom
7. **Commit**: `git commit -m "Upgrade to meta-orchestrator v2.0.0"`

---

## Next Steps

1. **Implement in `.brain/playbooks/build-from-intent.md`**: Refactor orchestration logic for v2.0
2. **Create templates**: `generators/` for `.app/` folder generation
3. **Update role files**: `.brain/roles/` with v2.0 responsibilities
4. **Update workflows**: `.brain/playbooks/` with workspace-centric execution
5. **Test with sample app**: Build OptionsTrader with v2.0 architecture
6. **Document**: Update README.md, CHANGELOG.md, UPGRADING.md

---

**Status**: ✅ Design Complete - Ready for Implementation
