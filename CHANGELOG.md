# Meta-Orchestrator Changelog

All notable changes to the meta-orchestrator system are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), with versions in reverse chronological order (newest first).

---

## v3.1.0 - Quality Enforcement & Behavioral Economics (2026-02-06)

### Anti-Fabrication
- **Evidence Manifest requirement**: All roles must provide structured evidence (FILES_CREATED, FILES_MODIFIED, COMMANDS_RUN, TESTS_PASSED)
- **Fabrication Antipattern**: New antipattern documented with symptoms, root cause, prevention
- **Verification posture**: "An assertion without evidence is not completion. It is a claim."

### System Prompt Override
- **All agent files** now include system prompt override to counter brevity-optimization
- **All role files** include override block
- **All templates** propagate override to generated apps
- **Root cause addressed**: Host system prompts that instruct "be concise" cause agents to fabricate and skip protocol

### Behavioral Economics Wisdom
- **New wisdom source**: `behavioral_economics_wisdom.md` 
- Sources: Levitt (Freakonomics), Ariely (Predictably Irrational), Thaler (Nudge), Meadows (Thinking in Systems), Goodhart
- Key principles: Goodhart's Law, Revealed Preferences, Unintended Consequences, Incentive-Compatible Design, Moral Hazard
- 7 key questions for incentive analysis

### Source
Improvements adopted from brain-framework v0.7.1 quality enforcement cycle.

---

## [3.0.1] - 2026-02-02 (Architect Reorganization Workflow)

### Added
- **REORGANIZATION REQUEST** dispatch pattern for orchestrator-architect collaboration
- **Reorganization playbook** (`.meta/playbooks/reorganization.md`) with:
  - Symptom detection table (God Object, tangled deps, unclear ownership)
  - Architect proposal template (split/merge/extract/relocate)
  - Deliberation integration for significant reorganizations
  - Before-parallelization checklist
- **Architect reorganization workflow** in `architect.md`:
  - Evaluate current state against LEGO principles
  - Analyze dependency graph
  - Propose minimal reorganization
  - Decision framework (symptom count → confidence → recommendation)

### Changed
- Updated playbooks README with reorganization.md and deliberation.md
- Fixed playbook path reference (`_self/` → `.meta/`)

---

## [3.0.0] - 2026-02-02 (Brain-Framework Integration)

### Added
- **ABSOLUTE PRECEDENCE** declaration for instruction hierarchy
- **OWNERSHIP MINDSET** section for autonomous decision-making (ask WHAT, decide HOW)
- **ORCHESTRATOR IDENTITY** naming convention and identity protocol
- **DISPATCH PATTERNS** (simple, complex, decision, blocked request handling)
- **SPONSOR INTERACTION PROTOCOL** (when to ask vs decide, One Question Rule)
- **PHASE FRAMEWORK** (P.1-P.5 high-level progression, complements Phase 0-12)
- **DIALECTIC PROCESS** (thesis-antithesis-synthesis for decisions)
- **SESSION MANAGEMENT** protocol (state persistence, session handoff)
- **PARALLEL ORCHESTRATION** protocol (workstream spawning for independent components)
- **Playbook system** (`.meta/playbooks/`) with TODO tracking integration
- **8-perspective deliberation** protocol for significant decisions
- Playbooks: `deliberation.md`, `new-feature.md`, `bug-fix.md`, `enhancement.md`

### Changed
- Enhanced Identity Confirmation Protocol with compliance requirement
- VERSION: 2.0.34 → 3.0.0 (major release for orchestration evolution)

### Upgrade Notes
- All changes additive (zero breaking changes)
- New `orchestrator_state.json` optional fields: `orchestrator_name`, `active_workstream`, `next_action`
- P.1-P.5 is high-level abstraction; Phase 0-12 remains detailed pipeline

---

## [2.0.34] - 2026-01-09 (Document Ownership + Role Boundaries)

### Added

- **Document ownership model** (explicit authoring boundaries for app_intent, essence, strategy, specs, and docs)
- **App orchestrator enforcement** of ownership rules in templates

### Changed

- **Role architecture** now clarifies core workflow split (decision logic vs user journey vs system flow)
- **Role templates** updated with artifact ownership sections (Essence Analyst, Strategy Owner, PM, Technical Writer)

## [2.0.33] - 2026-01-07 (System-of-Systems Coordination)

### Added

- **Coordination maturity ladder** (`standalone | federated | tracked | governed`)
- **System Orchestrator** scope (system coordination + portfolio/GTM) with dedicated templates
- **Coordination templates** (repo graph, request/response, event log, index, compatibility matrix, cross-repo test plan)
- **System coordination workflow** for cross-repo requests and validation
- **Operational context capture** (`.app/agent_context.json`) for repo/cloud/permission settings

### Changed

- **Meta-orchestrator Phase 0** now detects system-of-systems and scaffolds coordination files
- **System repos default to `tracked`** when system-of-systems is true
- **App/Self-contained templates** include system-of-systems coordination guardrails
- **Consistency audit** now requires `coordination_mode` in `meta_config.json`

## [2.0.32] - 2025-12-29 (MCP Role Isolation + Safe Config Merge)

### Added

- **Role-specific MCP workspaces** (`.app/runtime/mcp/<role>/AGENTS.md`) to prevent App Orchestrator bleed
- **Safe merge helper**: `scripts/merge_codex_mcp_config.py` updates `~/.codex/config.toml` without overriding non-app settings
- **Consistency audit checks** for MCP role workspaces and role-specific `cwd` entries

### Changed

- **Codex MCP server template** now points `cwd` to role workspaces (not app root)
- **Upgrade flow** now generates MCP role workspaces and merges MCP config non-destructively

## [2.0.31] - 2025-12-27 (Regression + Oversight Preservation)

### Added

- **Developer regression requirements** (must prevent regressions + add tests for changes)
- **Tester E2E regression requirement** (baseline + new behavior must pass)
- **App Orchestrator oversight** for catching subagent omissions and updating overrides
- **App Orchestrator overrides preservation** during upgrades (APP_OVERRIDES in `.app/AGENTS.md`)

### Changed

- **Role files** now explicitly call out regression responsibilities

## [2.0.30] - 2025-12-27 (Identity Confirmation + Doc Index)

### Added

- **Documentation Index** in app orchestrator instructions (ops/docs entrypoint)
- **Identity confirmation protocol** (first/last line must restate role)
- **Consistency audit check** for Documentation Index + identity confirmation in `.app/AGENTS.md`

### Changed

- **App orchestrator templates** now include doc index + identity confirmation guardrails

## [2.0.29] - 2025-12-27 (Orchestrator Discipline)

### Added

- **Docs-first rule** for App Orchestrator (ops how-to must come from docs/scripts or Ops role)
- **Subagent enforcement** when MCP subagents are available
- **Consistency audit check** for docs-first + subagent enforcement presence in `.app/AGENTS.md`

### Changed

- **App orchestrator templates** now include docs-first and subagent-enforcement guardrails

## [2.0.28] - 2025-12-27 (GTM Strategy Owner)

### Added

- **GTM Strategy Owner role** to define unified GTM plan before GTM sub-roles execute
- **GTM Strategy review gate** (Strategy → GTM roles) in new feature + enhancement workflows
- **GTM Strategy MCP server wiring** (template + app runtime + wrapper script)

### Changed

- **App orchestrator templates** now insert GTM Strategy Owner before GTM sub-roles when GTM is in scope

## [2.0.27] - 2025-12-26 (Triage + Subagent Selection)

### Added

- **Bug/Feature/Incident triage model** enforced in app orchestrator templates and workflows
- **Role selection matrix** to spawn only the required subagents
- **Final acceptance gate** clarified for bugs/incidents (App Orchestrator)

### Changed

- **Bug fix workflow** updated to route incidents to Ops/Dev first and make PM optional for impact/priority
- **Review gates** updated for non-feature final acceptance

## [2.0.26] - 2025-12-26 (Automated Consistency Audit)

### Added

- **Automated consistency audit** (`scripts/consistency_audit.py`) executed before completion
- **Upgrade gate** requiring audit pass before completion

### Changed

- **Upgrade instructions** now include the consistency audit step

## [2.0.25] - 2025-12-26 (Consistency + Source of Truth)

### Added

- **Sources of Truth map** in README and app orchestrator templates for canonical runtime state
- **Work item context requirement** in role handoffs (tracker.json + WI README/todos)
- **Essence mirror sync rule**: keep `.app/essence.md` aligned with `essence.md`

### Changed

- **App orchestrator templates** now self-contained (no `.meta/` references) and default to `codex-cli-mcp` when runtime is missing
- **Runtime timeout config** de-duplicated in `meta_config.json` (single `mcp_tool_timeout_seconds`)
- **Changelog wording** clarified: work item state moved to `.workspace/tracker.json`, while `orchestrator_state.json` remains for pipeline/role lock

## [2.0.24] - 2025-12-26 (Completion + Re-Orientation)

### Added

- **Role re-orientation loop** after every command/tool call (Meta + subagents)
- **Problem framing gate** ("measure twice") before design/coding with second-opinion requirement when needed
- **Completion gate** requiring production deployment and GTM artifacts when available

### Changed

- **Operations role required**; Gate 6 is always required (release equivalent for non-deployable apps)
- **GTM roles auto-included** when GTM agents are available/enabled
- **requirements.md template** includes Delivery & Launch Requirements section

### Migration

1. Regenerate `.app/` roles/workflows/templates to inherit re-orientation + ops requirement
2. Ensure active work items include Ops Gate 6 and production deployment checks
3. If GTM agents are enabled, include GTM artifacts or document skip with rationale

## [2.0.22] - 2025-12-25 (MCP Profile Activation)

### Added

- **Profile-scoped MCP enablement**: `.app/runtime/codex_mcp_servers.toml` now includes an app profile that turns on only that app’s MCP servers
- **GTM MCP servers** in the Codex MCP template (Monetization, Growth, Evangelist)

### Changed

- **MCP servers default disabled** to prevent cross-app startup storms; enable via profile and start Codex with `-p <app_slug>`
- **Codex MCP instructions** updated in engine templates and README

### Migration

1. Regenerate `.app/runtime/codex_mcp_servers.toml` from the updated template
2. Merge it into `~/.codex/config.toml`
3. Start Codex with `-p <app_slug>` (do not enable MCP servers globally)

## [2.0.21] - 2025-12-24 (Workflow Gate Alignment)

### Added

- **Ops Gate 6 phases** in new feature, enhancement, and bug-fix workflows
- **PM Final Acceptance for bug fixes** (Gate 7)
- **Decision-critical guardrails** for enhancements and bug fixes (Gate 0 required or N/A recorded)

### Changed

- **Role selection inputs**: add `needs_correctness`, `has_ui`, GTM toggles for clearer selection
- **Workflow summaries**: Strategy Gate 0 + Ops Gate 6 reflected in app orchestrator templates
- **Operations handoffs**: explicit Gate 6 signoff path to PM/Release
- **App AGENTS template**: remove engine path references to keep `.app/AGENTS.md` self-contained

### Migration

1. When generating `.app/`, set `needs_correctness`/`has_ui`/GTM flags explicitly
2. For decision-critical apps, ensure STR-XXX exists and Gate 0 is completed before FR-XXX
3. For production apps, insert Ops Gate 6 before PM Final Acceptance

## [2.0.20] - 2025-12-24 (Strategy Gate + Role Lock State Guard)

### Added

- **Strategy review gate (Gate 0)**: Strategy Owner → PM approval for decision-critical specs
- **Role lock state guard**: `primary_role` + `role_lock` in orchestrator state, enforced in app templates

### Changed

- **Role selection for .app generation**: Essence Analyst always included; Strategy Owner added for decision-critical apps
- **Workflows**: strategy phases now reference Gate 0 review criteria

### Migration

1. If decision-critical, route STR-XXX through Gate 0 before FR-XXX creation
2. Ensure `orchestrator_state.json` includes `primary_role` and `role_lock` for active sessions

## [2.0.19] - 2025-12-24 (App/Sponsor Overrides Preservation)

### Added

- **App/Sponsor Overrides block** in every role file (preserved across upgrades)
- **Upgrade preservation rule**: APP_OVERRIDES extracted and reinserted on role regeneration

### Changed

- **Role customization guidance**: app/sponsor guardrails must live in APP_OVERRIDES

### Migration

1. Add app-specific guardrails under APP_OVERRIDES in each role file
2. On upgrade, verify APP_OVERRIDES blocks are preserved

## [2.0.18] - 2025-12-24 (Role Lock Protocol)

### Added

- **Role Lock Protocol**: App Orchestrator must affirm role and detect drift on every session start
- **Codex CLI startup guidance**: start sessions with App Orchestrator instructions to prevent role loss

### Changed

- **App Orchestrator templates**: explicit role lock and drift detection inserted

### Migration

1. Ensure App Orchestrator sessions start from `AGENTS.md`
2. If role drift occurs, re-run pre-flight and re-affirm role

## [2.0.17] - 2025-12-24 (Strategy Owner Role)

### Added

- **Strategy Owner (Domain Expert) role**: defines decision frameworks and benchmarks for decision-critical apps
- **Strategy spec template**: `specs/strategy/STR-XXX-*.md`

### Changed

- **Workflows**: strategy definition/check phase added for decision-critical features/enhancements/bugs
- **Role selection**: Strategy Owner is conditionally required for decision-critical apps

### Migration

1. If your app is decision-critical, add Strategy Owner role and STR-XXX specs
2. Update workflows to include Strategy Definition/Check phases

## [2.0.16] - 2025-12-24 (App Orchestrator + Sponsor Interface)

### Added

- **Sponsor interface**: explicit human owner contract and routing rules (only App Orchestrator communicates with Sponsor)
- **Role specification summaries**: consistent Identity/Mission/Scope/Decision Rights/Guardrails across all role templates

### Changed

- **App Orchestrator naming**: standardized across docs/templates/agent files (replaces Meta-App-Orchestrator)
- **App Orchestrator ownership**: explicitly accountable for delivery and essence alignment
- **PM enforcement**: value→business impact check required for features and bug fixes

### Migration

1. Rename `.github/agents/meta-app-orchestrator.agent.md` → `.github/agents/app-orchestrator.agent.md`
2. Update any custom tooling to reference "App Orchestrator"

## [2.0.15] - 2025-12-21 (Branching Policy)

### Added

- **Branching policy**: `branching_policy` and `branching_risk_threshold` in `meta_config.json`

## [2.0.14] - 2025-12-21 (MCP App Namespacing)

### Added

- **App-scoped MCP servers**: `{app_slug}__{role}` naming with app `cwd` to avoid multi-app collisions

## [2.0.13] - 2025-12-21 (Codex Tool Timeout Sync)

### Added

- **Codex tool timeout sync**: upgrade requires `tool_timeout_sec` in `~/.codex/config.toml` to match `mcp_tool_timeout_seconds`

## [2.0.12] - 2025-12-21 (MCP Fast-Fail Warm-Up)

### Added

- **Fast-fail watchdog**: `mcp_fastfail_seconds`, `mcp_warmup_enabled`, `mcp_retry_once`
- **Warm-up ping**: quick MCP health check before long tasks

## [2.0.11] - 2025-12-21 (GM Orchestrator Model)

### Added

- **GM model**: Orchestrator explicitly sequences and validates sub-agent work instead of doing role work directly

## [2.0.10] - 2025-12-21 (MCP Timeout 120 Minutes)

### Changed

- **Default MCP timeout**: `mcp_tool_timeout_seconds` set to 7200 (120 minutes)

## [2.0.9] - 2025-12-21 (Configurable MCP Timeout)

### Added

- **MCP timeout config**: `mcp_tool_timeout_seconds` in `meta_config.json`

### Changed

- **Fallback rule**: timeouts are compared against `mcp_tool_timeout_seconds`

## [2.0.8] - 2025-12-21 (MCP Timeout Fallback)

### Changed

- **Fallback default**: MCP tool timeouts fall back to `codex-cli-parallel`
- **Docs**: clarified MCP timeout fallback in runtime guidance

## [2.0.7] - 2025-12-21 (Codex MCP Default)

### Changed

- **Runtime selection**: Missing/invalid runtime now defaults to `codex-cli-mcp`
- **Upgrade behavior**: If MCP tools aren’t attached, the upgrade instructs a Codex restart

## [2.0.6] - 2025-12-21 (Codex Parallel Default)

### Changed

- **Runtime selection**: Missing/invalid runtime now defaults to `codex-cli-parallel`
- **Upgrade prompt**: MCP worker mode explicitly offered as optional path

## [2.0.5] - 2025-12-21 (MCP Tool Clarity + Sanity Check)

### Added

- **MCP mental model**: Codex MCP servers are tools inside the session; restart required after registration
- **Sanity check**: one-sentence role confirmations recorded during upgrade setup

## [2.0.4] - 2025-12-21 (Upgrade Auto-Setup for Codex MCP)

### Added

- **Upgrade auto-setup**: MCP servers are registered for active roles during upgrade

### Changed

- **Codex adapter**: `start_mcp_server` accepts an optional role label

## [2.0.3] - 2025-12-21 (Codex Parallel Subagents + MCP Worker Config)

### Added

- **Codex parallel subagents**: `codex-cli-parallel` runtime (role-specific `codex exec` sessions)
- **Codex MCP workers config**: `codex_mcp_servers.toml` template for per-role MCP servers

### Changed

- **Runtime guidance**: Codex defaults to parallel subagents; MCP worker mode documented as tool-driven
- **Codex adapter**: Subagent mode recorded and supports parallel exec

## [2.0.2] - 2025-12-21 (Codex MCP Native Subagents)

### Changed

- **Codex MCP runner**: `codex_mcp_server.py` now starts the native Codex MCP server without OpenAI Agents SDK
- **Runtime configs**: Codex MCP subagent spawning clarified as MCP tool usage (no SDK runner script)
- **Templates**: Removed `codex_agents_runner.py` from generated artifacts

## [2.0.1] - 2025-12-21 (Runtime Capability Matrix + Lifecycle Roles)

### Added

- **Runtime capability matrix**: Config-driven runtime selection with sub-agent/agent-profile awareness
- **Sub-agent delegation rules**: Role-specific delegation when runtime supports it, fallback to role switching
- **New lifecycle roles**: Essence Analyst, Monetization Strategist, Growth Marketer, Evangelist
- **New runtime stubs**: Claude Code and Cursor adapter placeholders
- **App version tracking**: `APP_VERSION` initialized and enforced in workflows

### Changed

- **Workflows**: New Feature/Enhancement/Bug Fix now include essence validation and doc/version updates
- **Role selection logic**: Optional GTM roles included only when requested in app intent
- **Documentation**: README now includes runtime selection and APP_VERSION in structure

## [2.0.0] - 2025-12-06 (Workspace-Centric, Self-Documenting, Idempotent) - MAJOR REFACTOR

### Added

**Workspace-Centric Execution Model**:
- **`.workspace/` folder**: Ephemeral workspace for active work items (deleted after completion)
- **Work item tracking**: `.workspace/tracker.json` logs all work items with state transitions and timestamps
- **Per-work-item state**: Each `WI-XXX/` folder contains README.md, todos.md, role workspaces, reviews/
- **Role-specific workspaces**: `WI-XXX/pm/`, `WI-XXX/architect/`, `WI-XXX/developer/`, etc.
- **Review tracking**: `WI-XXX/reviews/*.md` records multi-role approval feedback

**Work Item Lifecycle**:
- Five states: BACKLOG → ACTIVE → IN_REVIEW → APPROVED → COMPLETE
- State transitions logged with timestamps in tracker.json
- Work items deleted after completion (git history is source of truth)

**Multi-Role Approval System**:
- **Blocking approval**: All 5 roles (PM, Architect, Developer, Tester, Writer) must explicitly approve
- **Review gates**: Orchestrator switches roles sequentially, each reviews and writes feedback
- **Promotion logic**: Artifacts promoted to `specs/` only after all approvals
- **Rejection handling**: Originating role addresses feedback, re-submits for review

**Idempotent Restart Model**:
- **No context loss**: Restart from any point by reading tracker.json + WI-XXX/todos.md
- **Resume detection**: Orchestrator identifies current work item and task from state files
- **Role resumption**: Switches to correct role based on pending task in todos.md

**Immutable Specifications**:
- **`specs/` folder**: Immutable approved specifications (features/, design/, test_plans/)
- **Read-only enforcement**: chmod 444 after promotion
- **Change policy**: Modifications require new work item with new spec referencing original

**Self-Documenting LEGOs**:
- **`legos/` structure**: Each LEGO has README.md (complete spec), interface.md (contract), workflows.md (interactions)
- **Code regeneration**: LEGO docs contain enough detail to completely regenerate code
- **Interface contracts**: Exact function signatures, input/output schemas, error conditions, side effects
- **Inter-LEGO workflows**: Explicit documentation of which LEGOs call which, data flow, error propagation

**LEGO Dependency Management**:
- **`legos/_manifest.json`**: Registry of all LEGOs with dependencies, versions, interface hashes
- **Dependency graph**: Automatically tracks which LEGOs depend on which
- **Breaking change detection**: Interface hash comparison detects breaking changes
- **Affected caller analysis**: Dependency graph identifies LEGOs impacted by interface changes

**Breaking Change Policy**:
- **Just break**: No deprecation, no versioning - fast feedback loop
- **Test-driven discovery**: Tests intentionally break to show affected callers
- **Major version bump**: Breaking changes increment major version (1.0.0 → 2.0.0)
- **Rapid iteration**: Simple mental model (one version, always current)

**Auto-Documentation**:
- **Inline code comments**: Comprehensive docstrings with examples, args, returns, raises
- **LEGO doc sync**: README.md updated when code changes, verified in review gates
- **Generated API docs**: Auto-generated from docstrings (Sphinx/pdoc) → `docs/user/api-reference.md`
- **Not auto**: Architectural decisions (manual ADRs), user guides (manual), trade-off rationale (manual)

**Role Context Isolation**:
- **One role at a time**: Orchestrator reads `.app/roles/{role}.md` exclusively (no multi-role context)
- **Role switching**: Orchestrator identifies role from todos.md, activates role, executes, steps back
- **Wisdom focus**: Each role sees only role-relevant principles and responsibilities
- **Prevents confusion**: No cross-role contamination of context

**Documentation Separation**:
- **Industry standard**: `docs/user/` (customer-facing) + `docs/dev/` (developer/agent-facing)
- **Clear audience**: Users see getting-started, user-guide, API reference, troubleshooting, FAQ
- **Internal docs**: Developers see architecture, design-decisions, contributing, testing-strategy
- **Pattern**: Used by Kubernetes, React, Django, Rails

**Git Integration**:
- **Initialized at creation**: `git init` on new app, all changes versioned
- **Workspace commits**: `.workspace/` committed during active work (preserves decisions)
- **Deletion after completion**: Workspace deleted after work item COMPLETE (git history remains)
- **Atomic commits**: Small, clear commit messages per artifact promotion
- **Alternative VCS**: Detects and adapts to Mercurial, SVN, etc.

**Tamper-Proof Brain**:
- **`.app/` frozen**: Agent brain (roles, workflows, wisdom) only modified during engine upgrades
- **Runtime protection**: Cannot be modified during work item execution
- **Prevents corruption**: User/agent cannot accidentally break orchestrator logic

### Changed

**Directory Structure** (BREAKING):
- Added `.workspace/` for ephemeral work items
- Added `legos/` for self-documenting LEGO blocks
- Added `specs/` for immutable approved specifications
- Changed `docs/` structure to `docs/user/` + `docs/dev/`
- `.app/` remains but enforced as read-only except during upgrades

**Workflow Model** (BREAKING):
- Work items now explicit (WI-XXX folders)
- Multi-role approval required before artifact promotion
- Specs immutable after approval (changes require new work item)
- LEGO docs written before code (docs-driven development)

**State Management** (BREAKING):
- Centralized in `.workspace/tracker.json` (was scattered in root)
- Per-work-item state in `WI-XXX/todos.md` (was implicit)
- Review history in `WI-XXX/reviews/*.md` (was not tracked)

**LEGO Structure** (BREAKING):
- LEGOs now have `legos/{name}/README.md`, `interface.md`, `workflows.md`, `src/`
- LEGO docs are complete specifications (can regenerate code)
- Tests co-located with code in `legos/{name}/src/tests/`

### Removed

**Deprecated Features** (BREAKING):
- Work item state moved to `.workspace/tracker.json` (orchestrator_state.json remains for pipeline/role lock state)
- No more implicit approval (now explicit multi-role review gates)
- No more mutable specs (now immutable in `specs/`)
- No more single `docs/` folder (now separated by audience)

### Migration

**v1.x → v2.0 requires migration**:
- See UPGRADING.md for detailed step-by-step instructions
- Not backward compatible (clean break for long-term stability)
- Backup recommended: `git tag v1-backup` before upgrading

### Philosophy

**The Key Principle**:
> **After CREATE or UPGRADE, you could DELETE `.meta/` and the app would still be fully maintainable.**
> The `.app/` folder is COMPLETELY SELF-CONTAINED.

**Three Modes**:
| Mode | Uses .meta/? | Uses .app/? | Orchestrator |
|------|--------------|-------------|--------------|
| CREATE | ✅ Yes | Creates it | `.meta/AGENTS.md` |
| UPGRADE | ✅ Yes | Regenerates | `.meta/AGENTS.md` |
| MAINTAIN | ❌ No | ✅ Self-contained | `.app/AGENTS.md` |

### Impact

- **At runtime**: Apps don't need engine files (`.meta/` can be absent)
- **For upgrades**: Copy new `.meta/` from meta-metacognition, run upgrade
- **For maintenance**: Only `.app/` folder is needed
- **Cleaner mental model**: Engine vs App separation is explicit

---

## [1.10.0] - 2025-12-04 (Self-Contained App Architecture)

### Added

**Two-Folder Architecture** (`.meta/` vs `.app/`):
- **`.meta/`**: ENGINE folder - contains templates, generators, wisdom library
- **`.app/`**: APP-SPECIFIC folder - generated, self-contained, no `.meta/` references
- Clear separation: `.meta/` for CREATE/UPGRADE, `.app/` for MAINTAIN
- Apps can function with `.meta/` deleted (after generation)

**Generator System** (`.meta/generators/`):
- `app_folder_generation.md`: Documentation for how `.app/` is generated
- `app_agents.template.md`: Template for self-contained app orchestrator

**Self-Contained App Orchestrator**:
- `.app/AGENTS.md` contains ALL context inline (no external references)
- Wisdom principles INLINED, not referenced
- Roles and workflows ADAPTED and copied, not referenced
- `.app/.engine-version` tracks which engine version generated it

**Review Gates System** (`.meta/workflows/REVIEW_GATES.md`):
- Explicit review gates at each handoff between roles
- Six review gates: PM→Architect, Architect→Developer, Developer→Tester, Tester→Writer, Writer→Release, Operations Review
- Receiving role is the reviewer (no separate Reviewer role needed)
- Detailed criteria for each gate (what to look for, red flags)
- Self-review checklists for each role
- Anti-patterns to avoid (rubber-stamping, scope creep, vague rejections)
- Timing guidelines for reviews

**Updated Workflows**:
- All three workflows (New Feature, Enhancement, Bug Fix) now include explicit review gate markers
- Each handoff shows review criteria inline
- Approval outcomes: Approve / Approve with Conditions / Reject

### Philosophy

**The Key Principle**:
> After CREATE or UPGRADE, you could DELETE `.meta/` and the app would still be fully maintainable.

**Three Modes**:
| Mode | Uses .meta/? | Uses .app/? | Orchestrator |
|------|--------------|-------------|--------------|
| CREATE | ✅ Yes | Creates it | `.meta/AGENTS.md` |
| UPGRADE | ✅ Yes | Regenerates | `.meta/AGENTS.md` |
| MAINTAIN | ❌ No | ✅ Self-contained | `.app/AGENTS.md` |

### Impact

- **At runtime**: Apps don't need engine files (`.meta/` can be absent)
- **For upgrades**: Copy new `.meta/` from meta-metacognition, run upgrade
- **For maintenance**: Only `.app/` folder is needed
- **Cleaner mental model**: Engine vs App separation is explicit

---

## [1.9.0] - 2025-12-04 (Role-Based Architecture)

### Added

**Role-Based Structure** (`.meta/roles/`):
- **Product Manager** (`product_manager.md`): Essence Triangle (Customer Value, Business Impact, Feasibility), feature specification ownership, scope discipline
- **Architect** (`architect.md`): Simplicity-first design, control flow & data flow analysis, design decision ownership
- **Developer** (`developer.md`): Spec-faithful implementation, TDD workflow, code quality standards
- **Tester** (`tester.md`): Spec-based validation, edge case hunting, bug reporting standards
- **Technical Writer** (`tech_writer.md`): Audience-focused documentation, progressive disclosure, maintenance
- **Operations** (`operations.md`): Reliability engineering, observability, incident management, runbooks (OPTIONAL - for production services)

**Workflow Definitions** (`.meta/workflows/`):
- **New Feature** (`new_feature.md`): Complete lifecycle from discovery to release
- **Enhancement** (`enhancement.md`): Modifying existing features with immutable spec history
- **Bug Fix** (`bug_fix.md`): Deviation from spec handling with root cause analysis

**Artifact Templates** (`.meta/artifacts/templates/`):
- **Feature Specification** (`feature_spec.template.md`): Complete FR-XXX template with Essence Triangle

**Architecture Documentation**:
- **Role Architecture** (`ROLE_ARCHITECTURE.md`): Overview of role-based model
- **Customizing Roles** (`CUSTOMIZING_ROLES.md`): Guide for adapting roles/workflows to your app

### Philosophy

**Templates, Not Prescriptions**:
- Roles and workflows are STARTING POINTS
- Adapt based on app type (CLI vs web service vs library)
- Not all apps need all roles (Operations is optional, Writer may be optional)
- Formality is a spectrum (prototype → production → regulated)

**The Essence Triangle** (Product Manager's Core Model):
Every feature must satisfy THREE constraints:
1. **Customer Value** (Desirability): What do users GET? Is there EVIDENCE?
2. **Business Impact** (Viability): What does the business GET? How is value CAPTURED?
3. **Product Building** (Feasibility): CAN we build it? With what effort/risk?

All three must be true, or the feature should not proceed.

**Immutable vs Living Artifacts**:
- **Immutable** (append-only): Feature specs, design decisions, test plans, bug reports
  - Once approved, never modified
  - Changes create NEW artifacts that REFERENCE the old
  - Maintains audit trail and traceability
- **Living** (current state): Source code, tests, documentation, architecture diagrams
  - Evolve with the system
  - Represent current truth

**Role Handoffs**:
- PM → Architect: FR-XXX (approved feature spec)
- Architect → Developer: DD-XXX (approved design decision)
- Developer → Tester: Implementation + unit tests
- Tester → Writer: Verified feature
- Each handoff has explicit artifacts and expectations

### Impact

Apps built with v1.9.0 will:
1. Have clear role separation in orchestration
2. Use Essence Triangle for all feature decisions
3. Generate immutable specs in `specs/` directory
4. Maintain audit trail through artifact references
5. Follow role-specific principles and workflows

### Migration

- **New apps**: Automatic role-based structure
- **Existing apps**: Additive (create `specs/` directory, migrate over time)
- **No breaking changes**: Existing artifacts continue to work

---

## [1.8.0] - 2025-12-04 (Enhanced App Orchestration & Self-Awareness)

### Added

**PERSONA Section for App Orchestrators** (Templates Updated):
- `.meta/templates/AGENTS.template.md` now includes explicit PERSONA section
- `.meta/templates/agent.template.md` updated with identity enforcement
- Clear declaration: "You ARE the App Orchestrator. You are NOT a helper."
- On every turn checklist: run pre-flight, act autonomously, apply wisdom, maintain alignment, self-monitor
- Explicit "What You Never Do" list (no "how should I proceed?" questions)

**Feature Discovery Phase (Product Manager Mode)**:
- MAINTENANCE MODE now requires Feature Discovery BEFORE architecture/design/code
- Orchestrator acts as Product Manager first, Engineer second
- Discovery questions validate essence alignment, customer value, business value, feature creep
- Features that dilute essence are flagged for user discussion
- Documented in `.meta/AGENTS.md` Section 0 (MAINTENANCE MODE)

**End-to-End Scenario Testing Principles** (`[P-E2E]` in `.meta/principles.md`):
- E2E tests with minimal mock input, zero injected mock data
- Tests validate complete user scenarios as users experience them
- Mock ONLY external service boundaries (not internal components)
- Data flows through real transformations (no bypassing)
- Scenario-driven naming: `test_user_signup_to_first_purchase`
- Anti-patterns documented: mocking internal components, injecting fake responses
- When to use E2E vs Unit/Integration matrix

**Self-Awareness & Rathole Prevention** (Engineering Wisdom #17):
- New wisdom principle in `.meta/wisdom/engineering_wisdom.md`
- Triggers: >3 failed attempts, complexity exceeding problem, 5+ unrelated files changed
- Actions: STOP, zoom out to essence, run architectural check
- Red flags: "This is the only way", "Just this one exception", "I'll refactor later"
- Self-awareness checkpoints every 3 iterations

**Control Flow & Data Flow Analysis** (Engineering Wisdom #18, `[P-FLOW-ANALYSIS]`):
- New wisdom principle and global principle for architectural analysis
- Every decision must consider BOTH control flow AND data flow
- Control flow: entry points, decision points, error handling, exit points
- Data flow: sources, transformations, sinks
- "Beautiful control flow + chaotic data flow = Still a mess"

### Changed

**MAINTENANCE MODE Workflow** (`.meta/AGENTS.md` Section 0):
- Added Feature Discovery Phase before Two Paths
- Path A now includes Feature Discovery step (read essence.md, validate alignment)
- Path B now includes essence alignment validation (no more "skip questions")
- Both paths document essence alignment rationale in APP_ORCHESTRATION.md

**Templates Updated**:
- `AGENTS.template.md`: Added PERSONA section with identity enforcement
- `agent.template.md`: Added IDENTITY ENFORCEMENT section with explicit do/don't lists

### Philosophy

**From "Build features" → "Validate features serve essence"**:
- Previously: User asks for feature → orchestrator plans implementation
- Now: User asks for feature → orchestrator validates essence alignment FIRST
- Orchestrator acts as Product Manager (validate) before Engineer (implement)
- Features that dilute core value are flagged, not blindly implemented

**From "Solve the problem" → "Know when you're ratholing"**:
- Previously: Keep trying until it works
- Now: After 3 iterations, STOP and reassess architectural alignment
- Self-awareness prevents changes that violate KISS/LEGO principles
- Explicit recognition that "quick fixes" often aren't

### Impact

Apps built/maintained with v1.8.0 will:
1. Have orchestrators with clear autonomous identity (no "how should I proceed?")
2. Validate new features against core essence before implementation
3. Generate E2E tests with minimal mocking (real data flows)
4. Self-monitor for ratholing and architectural drift
5. Consider both control flow and data flow in all decisions
6. Act as Product Manager (validate value) before Engineer (implement)

---

## [1.7.8] - 2025-11-28 (Agent Reference Fix)

### Fixed
- **Bug in generated `.github/agents/app-orchestrator.agent.md`**: Agents were incorrectly referencing `.meta/AGENTS.md` (engine) instead of `AGENTS.md` (root, app-specific)
  - **Problem**: When meta-orchestrator generated app agent files, some agents misunderstood instructions and pointed to engine file
  - **Impact**: App orchestrators would read meta-orchestrator engine logic instead of app-specific maintenance instructions
  - **Root cause**: Instructions were correct but not explicit enough to prevent misinterpretation

### Changed
- **Enhanced template** (`.meta/templates/agent.template.md`):
  - Added explicit warning: "DO NOT read `.meta/AGENTS.md` - that file is for the ENGINE"
  - Clarified: "PRIMARY INSTRUCTIONS: Read `AGENTS.md` (in repository root)"
  - Makes distinction unmistakable for agents generating this file

- **Enhanced generation instructions** (`.meta/AGENTS.md` Phase 11.2):
  - Added CRITICAL marker: "Agent references `AGENTS.md` (root) for complete instructions (NOT `.meta/AGENTS.md`)"
  - Added validation: "Verify generated file contains 'You read `AGENTS.md` (root)' on line 16"
  - Added validation: "Verify file does NOT say 'read `.meta/AGENTS.md`' anywhere"

- **Enhanced UPGRADE mode instructions** (`.meta/AGENTS.md` Phase 0):
  - Added CRITICAL marker for GitHub Copilot Chat agent generation
  - Added validation: "Verify line 16 says 'You read `AGENTS.md` (root)' (not `.meta/AGENTS.md`)"
  - Added validation: "Grep file to ensure no incorrect '.meta/AGENTS.md' references"

### Why This Matters
- **Correctness**: App orchestrators must read app-specific instructions, not engine internals
- **User experience**: Agents now maintain apps correctly (not attempt to modify engine)
- **Clarity**: Explicit warnings prevent misinterpretation by AI agents

### Action Required for Existing Apps
If you have an app created with v1.7.7 or earlier, check `.github/agents/app-orchestrator.agent.md`:
- **Line 16 should say**: "You read `AGENTS.md` (root) for app-specific logic"
- **If incorrect**: Regenerate from template or manually fix reference
- **To regenerate**: Run meta-orchestrator in UPGRADE mode (it will detect and fix)

---

## [1.7.7] - 2025-11-28 (Workflow Enforcement Guards)

### Added
- **Defense-in-Depth for Stateless Runtimes**: Multiple enforcement layers to prevent agents from forgetting critical steps
  - **Enhanced Pre-flight Checklist** (lines 10-78): 
    - Visual reinforcement with `╔═══╗` CRITICAL CHECKPOINT boxes, 🚨 emojis
    - Explicit state guard instructions (set `preflight_run: true`)
    - Clear action items for each checklist step
    - Reminder about stateless runtimes (GitHub Copilot)
  - **Memory Joggers at Every Phase** (Phases 0-11):
    - CRITICAL CHECKPOINT reminder at start of each phase
    - Phase 11 includes additional 📝 MANIFEST REMINDER
    - Visual consistency (unmissable boxes throughout pipeline)
  - **State Guards** (orchestrator_state.json):
    - `preflight_run`: true/false flag (set after pre-flight completes)
    - `manifest_updated`: true/false flag (set at Phase 11.2)
    - Before Phase 4: HALT if `preflight_run != true`
    - Before Phase 12 COMPLETE: HALT if `manifest_updated != true`
  - **Manifest Validation Gate** (Phase 11.2):
    - Required checks before marking COMPLETE
    - Verify `.meta-manifest.json` exists
    - Verify all generated files are listed
    - Verify timestamps are recent (within last hour)
    - Set `manifest_updated = true` flag

### Why This Matters
- **Problem**: Stateless AI runtimes (GitHub Copilot Chat) forget instructions between turns
- **Evidence**: User observed agents skipping pre-flight checklist and manifest updates
- **Solution**: Multiple enforcement layers (visual + programmatic) prevent amnesia
- **Aligns with**: Schneier #8 (defense in depth), Saltzer #4 (fail-safe defaults)

### Technical Details
- Pre-flight checklist expanded from 6 steps to comprehensive 69-line visual guide
- Added 12 CRITICAL CHECKPOINT boxes (one per phase 0-11)
- State guards act as programmatic enforcement (not just reminders)
- Manifest validation gate prevents incomplete pipelines

### Rationale
- **Schneier #8 (Defense in Depth)**: Multiple independent safeguards (visual + state + validation)
- **Saltzer #4 (Fail-Safe Defaults)**: System halts if critical steps skipped (safe by default)
- **Evidence-based**: Addresses observed real-world failures (not theoretical optimization)
- **KISS**: Simple state flags, clear visual markers (no complex infrastructure)

---

## [1.7.6] - 2025-11-28 (Web Documentation Guidance)

### Added
- **Web Documentation Guidance** (`[P-WEB]` principle): Agents now search online documentation for current information about external APIs, packages, frameworks, security advisories, and cloud services
  - New `[P-WEB]` principle in `.meta/principles.md` with trigger conditions (when to search)
  - Trusted sources: Official documentation, package registries, security databases
  - Integration into Phase 4 (REQUIREMENTS), Phase 8 (CODING), Phase 9 (REVIEW)
  - Documentation requirements for web research (sources, dates, findings)
  - New Engineering Wisdom #16: "Web Research Trigger" for detecting outdated patterns

### Why This Matters
- **Correctness**: AI training data is frozen (Claude: Oct 2024), but APIs/packages change frequently
- **Security**: Latest CVEs and security best practices must be consulted
- **Efficiency**: Using current patterns improves performance and maintainability
- **Prevents**: Deprecated API usage, outdated package versions, security vulnerabilities

### Examples of When to Search
- External APIs: OpenAI, Anthropic, Azure, AWS (endpoints, auth, rate limits)
- Packages: Python (PyPI), JavaScript (npm), .NET (NuGet) - latest versions, CVEs
- Frameworks: React, FastAPI, Django - current best practices
- Security: Authentication patterns, cryptography, OWASP guidance
- Cloud: Azure, AWS, GCP configurations and pricing

### Rationale
- Aligns with Thompson #5: "Do one thing well" - building correct apps requires current info
- Aligns with Schneier's Security Mindset: Current threat awareness is critical
- Evidence-based: Discovered through real usage (agents suggesting deprecated patterns)
- KISS: Simple guidance, not complex infrastructure

---

## [1.7.5] - 2025-11-27 (Dual-Runtime Agent Discovery)

### Added

**OpenAI Codex CLI Support**:
- Now supports BOTH GitHub Copilot Chat (VS Code) AND OpenAI Codex CLI (v0.63.0+)
- New template: `.meta/templates/AGENTS.codex.template.md` for Codex CLI agent configuration
- UPGRADE mode generates `AGENTS.md` in repository root (for Codex memory system)
- Codex reads `AGENTS.md` files for instructions (documented in Codex getting-started.md)

### Changed

**Dual-Runtime Agent Generation**:
- `.meta/AGENTS.md` UPGRADE mode now MANDATES both agent file types:
  - `.github/agents/app-orchestrator.agent.md` → GitHub Copilot Chat (VS Code)
  - `AGENTS.md` (root) → OpenAI Codex CLI (terminal)
- Validation checks BOTH files exist after upgrade
- Documentation clarified runtime-specific terminology

### Fixed

**Agent Discoverability in OpenAI Codex CLI**:
- v1.7.4 only generated GitHub Copilot agent file (`.github/agents/`)
- Codex CLI couldn't discover agents (uses different mechanism: `AGENTS.md` files)
- Now properly supports users who switch between VS Code and Codex CLI

---

## [1.7.4] - 2025-11-27 (Agent Discoverability Fix)

### Fixed

**MANDATORY Agent File Generation During Upgrades**:
- UPGRADE mode now **requires** `.github/agents/app-orchestrator.agent.md` generation
- Added validation: Verifies file exists after upgrade, stops with error if missing
- Creates `.github/agents/` directory if needed during upgrade
- Ensures GitHub Copilot Chat agent picker can discover "App Orchestrator" in upgraded apps

**Problem Solved**:
- Users upgrading apps to v1.7.1+ didn't see "App Orchestrator" in VS Code Copilot Chat agent picker
- UPGRADE mode mentioned agent file creation but didn't enforce it
- Silent failure left apps without discoverable custom agents

**Solution Applied (KISS + Thompson #5)**:
- Made agent file generation explicit and mandatory
- Added validation checkpoint (verify file exists with correct content)
- Stop with clear error if validation fails
- Updated UPGRADING.md with manual workaround for already-upgraded apps

### Files Modified

- `.meta/AGENTS.md`: Section 0 (UPGRADE mode) - Made agent file generation MANDATORY with validation
- `UPGRADING.md`: Added v1.7.3 → v1.7.4 section with manual fix for affected apps
- `CHANGELOG.md`: Documented fix
- `.meta/VERSION`, `.meta-version`: Version bump to 1.7.4

### Migration Path

**For apps already upgraded (v1.7.1-v1.7.3) without agent file**:
```bash
mkdir .github\agents
copy .meta\templates\agent.template.md .github\agents\app-orchestrator.agent.md
# Edit: Replace {APP_NAME} with your app name
```

**For new upgrades**: Automatic (validated during UPGRADE mode)

---

## [1.7.3] - 2025-11-26 (Inline Pre-Flight Checklist)

### Added

**Inline Pre-Flight Checklist** (in both Meta-Orchestrator and App Orchestrator agents):
- Pre-flight checklist now embedded directly in `.agent.md` files
- Executed immediately on agent activation (not buried in `AGENTS.md`)
- **Checkpoint #6 added**: Version & Documentation verification before commits
- Prevents incomplete releases (missing version bumps, docs)
- Ensures wisdom application on every turn

**Meta-Orchestrator Checklist** (`.github/agents/meta-orchestrator.agent.md`):
1. Check repository state (engine vs app)
2. Reaffirm role (maintenance orchestrator for engine)
3. Reaffirm authority (autonomous decisions, apply wisdom)
4. Reaffirm knowledge sources (AGENTS.md, .meta/, wisdom/)
5. Determine next action (evaluate with wisdom framework)
6. **Version & documentation checkpoint** (CRITICAL)

**App Orchestrator Checklist** (`.github/agents/app-orchestrator.agent.md`):
1. Check repository context (application, not engine)
2. Reaffirm role (app orchestrator)
3. Reaffirm authority (autonomous decisions, apply wisdom)
4. Check app context (app_intent.md, essence.md, AGENTS.md)
5. Determine next action (features/bugs with wisdom)

### Why This Matters

**Problem**: Agents lost identity across turns, forgot to apply wisdom, rushed commits without version bumps/docs.

**Solution**: Inline pre-flight checklist executed on EVERY turn. Checkpoint #6 prevents incomplete releases.

**Impact**:
- Agents maintain identity consistently
- Wisdom applied systematically (KISS, LEGO, Thompson #5)
- No more incomplete commits (version/docs verified before git)
- Quality enforcement through checklists

### Files Modified

- `.github/agents/meta-orchestrator.agent.md`: Added inline checklist with checkpoint #6
- `.github/agents/app-orchestrator.agent.md`: Added inline checklist
- `.meta/templates/agent.template.md`: Template updated with checklist
- `.meta/VERSION`, `.meta-version`: Version bump to 1.7.3

---

## [1.7.2] - 2025-11-26 (Custom Agent Terminal Access Fix)

### Fixed

**Custom Agent Terminal Access**:
- Removed `tools` field restriction from agent files to enable full capabilities
- Custom agents now have terminal access, file editing, and all other tools
- Previously restricted to read-only tools (`'search'`, `'fetch'`, `'githubRepo'`)
- VS Code doesn't recognize `'terminal'` or `'edit'` as valid tool names
- Omitting `tools` field gives agents full default capabilities

### Why This Matters

**Problem**: Custom agents couldn't run terminal commands or perform file edits when tools field specified read-only tools.

**Solution**: Remove `tools` field entirely - agents inherit full capabilities from default agent behavior.

**Impact**:
- Meta-Orchestrator can run git commands, terminal operations, file edits
- App Orchestrator has full implementation capabilities
- No artificial restrictions on agent capabilities

### Files Modified

- `.github/agents/meta-orchestrator.agent.md`: Removed `tools` field
- `.github/agents/app-orchestrator.agent.md`: Removed `tools` field
- `.meta/templates/agent.template.md`: Removed `tools` field from template
- `.meta/VERSION`, `.meta-version`: Version bump to 1.7.2

---

## [1.7.1] - 2025-11-26 (VS Code Custom Agents)

### Added

**VS Code Custom Agent Generation** (Section 11.2 in `.meta/AGENTS.md`):
- `.github/agents/meta-orchestrator.agent.md` for engine (reads `.meta/AGENTS.md`)
- `.github/agents/app-orchestrator.agent.md` for apps (reads `AGENTS.md`)
- Appears in VS Code Copilot agent dropdown (no activation phrases needed)
- Template at `.meta/templates/agent.template.md`

**Engine Upgrade Support**:
- ENGINE UPGRADE mode creates/updates `.github/agents/app-orchestrator.agent.md`
- Ensures custom agents work after version upgrades
- Consistent naming: "Meta-Orchestrator" (engine) and "App Orchestrator" (apps)

### Why This Matters

**Problem**: Users had to remember activation phrases like `@workspace Act as {app} orchestrator` to use app-specific agents. No visual indicator that custom agent exists.

**Solution**: Two custom agents appear in VS Code Copilot dropdown:
- **Meta-Orchestrator**: For engine work (reads `.meta/AGENTS.md`)
- **App Orchestrator**: For app work (reads `AGENTS.md`)

Users can see and click the agent without memorizing commands.

**Benefits**:
- Discoverable: Agent visible in dropdown, no memorization needed
- Quick activation: Select agent from picker, start working immediately
- Professional UX: Same experience as built-in agents (Agent, Plan, Ask, Edit)
- References full instructions: `.agent.md` points to `AGENTS.md` for complete context
- Persistent identity: Agent maintains role across conversation turns

**Impact**:
- Generated apps get professional agent UX out of the box
- Users discover app orchestrator without reading documentation
- Reduces friction: click dropdown vs typing activation phrase
- Consistent with VS Code Copilot conventions

### Files Modified

- `.meta/AGENTS.md`: Added `.github/agents/{APP_NAME}.agent.md` generation to Section 11.2
- `.meta/AGENTS.md`: Added ENGINE UPGRADE support for agent file creation
- `.meta/templates/agent.template.md` (new): Template for app-specific agents
- `.github/agents/meta-orchestrator.agent.md` (new): Meta-orchestrator's own custom agent
- `.meta/VERSION`, `.meta-version`: Version bump to 1.7.1, added `vscode_custom_agents` feature

---

## [1.7.0] - 2025-11-25 (Conversational Maintenance Mode)

### Added

**Conversational MAINTENANCE Mode** (Section 0 in `.meta/AGENTS.md`):
- Two-path maintenance workflow: **Path A (conversational)** and **Path B (manual edit)**
- **Path A - Natural UX**: User asks "Add feature X" in chat, orchestrator handles app_intent.md updates
  - Orchestrator asks 2-3 clarifying questions
  - Distills conversation into clear feature description
  - Proposes app_intent.md update with diff preview
  - Gets user approval before writing (y/n gate)
  - Logs conversation rationale in APP_ORCHESTRATION.md
  - Proceeds to requirements discovery
- **Path B - Power User**: User manually edits app_intent.md first (existing workflow)
  - Orchestrator detects change via git diff
  - Skips clarifying questions (user already specified intent)
  - Proceeds directly to requirements discovery
- Both paths converge at requirements discovery (Section 4)
- Approval gate prevents orchestrator from misinterpreting user intent
- Living documentation: app_intent.md stays synchronized with actual features

**Template Update** (`.meta/templates/AGENTS.template.md`):
- App-specific orchestrators inherit conversational MAINTENANCE workflow
- Same dual-path structure (Path A conversational, Path B manual)
- Approval gates for app_intent.md updates
- Conversation logging in APP_ORCHESTRATION.md

### Why This Matters

**Problem**: Previous workflow required users to manually edit app_intent.md before asking for features, breaking conversational flow and creating friction.

**Solution**: Orchestrator now maintains app_intent.md as living documentation, updating it after clarifying conversation with approval gate.

**Benefits**:
- Natural UX: "Add Bitcoin trading" → orchestrator asks questions → proposes update → user approves
- Captures context: Clarifying Q&A distilled into precise feature descriptions
- Better descriptions: Orchestrator applies wisdom (technical precision, KISS, domain metrics)
- Living documentation: app_intent.md reflects current state, not outdated spec
- Still safe: Approval gate prevents mistakes, user reviews before writing
- Backward compatible: Manual editing (Path B) still works for power users

**Impact**:
- Conversational feature additions (like talking to developer)
- Reduced friction (no file editing interruption)
- Higher quality intent descriptions (AI-written with wisdom)
- app_intent.md becomes source of truth maintained by orchestrator

---

## [1.6.1] - 2025-11-25 (Dogfooding Bugfix)

### Fixed

**app_intent.md Alignment**:
- Corrected `app_intent.md` to describe meta-orchestrator (not OptionsTrader example)
- Was: Placeholder template with stock trading example
- Now: Actual meta-orchestrator intent (build apps from plain English using 50+ years wisdom)
- Documented unique architecture: Source = `.meta/` AI prompts (Markdown), not traditional code
- Aligned success criteria with `essence.md`: KISS compliance, zero antipatterns, >80% coverage
- Recognized paradigm shift: "Deployment" = copy `.meta/` folder, "Tests" = build sample apps
- Why this matters: Dogfooding principle requires engine to describe itself correctly
- Impact: Future AI agents understand this is a prompt-based orchestration engine, not typical code

**`.meta-manifest.json` Description**:
- Updated `app_intent.md` description from "Example app intent template" to "Meta-orchestrator's actual intent"
- Prevents confusion about whether file is example or actual

### Context

This fixes a violation of the dogfooding principle introduced during initial repository setup. The meta-orchestrator's own `app_intent.md` should follow the same structure it enforces for generated apps: describe the actual app being built, not provide a placeholder example.

---

## [1.6.0] - 2025-11-25 (Stateless Runtime Support & Role Persistence)

### Added

**Pre-flight Checklist** (Section 0 in `.meta/AGENTS.md`):
- Mandatory 5-step checklist executed BEFORE any work on every turn
- Fixes agent amnesia in stateless runtimes (GitHub Copilot Chat)
- Checklist steps:
  1. Check pipeline/app state (orchestrator_state.json, .meta-version, .meta-manifest.json)
  2. Reaffirm role (META-ORCHESTRATOR or APP-SPECIFIC ORCHESTRATOR)
  3. Reaffirm authority (make decisions autonomously using wisdom)
  4. Reaffirm knowledge sources (.meta/principles.md, wisdom/, patterns/)
  5. Determine next action (resume from state, not restart)
- Prevents "how should I proceed?" questions mid-pipeline
- Forces explicit role/state verification on every invocation

**App-Specific AGENTS.md Template** (`.meta/templates/AGENTS.template.md`):
- Complete template for generated app orchestrators
- Includes Pre-flight Checklist for app maintenance mode
- Structured sections: Application Context, Essence, User Journey, LEGO Architecture, Wisdom Applied, etc.
- Ensures app orchestrators maintain identity during multi-turn feature additions/bug fixes
- Template used by Section 11.2 when generating app-specific AGENTS.md

**Meta-Orchestrator Self-Maintenance** (`AGENTS.md` in root):
- Dogfooding: Engine's own maintenance agent using same template structure
- Documents engine architecture as LEGOs (Version Control, Essence Discovery, LEGO Planning, etc.)
- Identifies core value LEGOs (Intuition System, Session Isolation, AGENTS.md Generation)
- Maintenance workflow for improving engine using its own principles
- Enables autonomous engine improvements following KISS + wisdom

### Changed

**Section 11.2 Enhancement** (`.meta/AGENTS.md`):
- Now instructs to use `.meta/templates/AGENTS.template.md` as base
- Ensures consistency across all generated app orchestrators
- Documents that template includes Pre-flight Checklist for amnesia prevention

### Why This Matters

**Problem**: GitHub Copilot Chat agents are stateless - they forget their role between turns in the same conversation, leading to "how should I proceed?" questions even mid-pipeline.

**Solution**: Explicit Pre-flight Checklist forces role/state verification every turn, compensating for stateless runtime behavior.

**Impact**: 
- Meta-orchestrator maintains identity during multi-turn app generation
- App orchestrators maintain identity during multi-turn maintenance
- Works in both stateful (Codex CLI) and stateless (GitHub Copilot Chat) runtimes
- Applies KISS principle: simple explicit checklist vs complex state management

---

## [1.5.0] - 2025-11-25 (Phase 1.8: Product-Market Fit & User Experience Focus)

### Added

**Essence & Value Proposition Discovery** (Section 4.3):
- New step after requirements/dependencies to discover WHY the app exists
- Creates `essence.md` documenting:
  - Problem statement (what problem, who has it, why it matters)
  - Unique value proposition (competitive differentiation, core value)
  - Competitive landscape (existing solutions, strengths, weaknesses)
  - Success metrics (domain-specific: Sharpe ratio, p99 latency, time-to-value, etc.)
  - User journey (discovery → first value → core workflow → ongoing → edge cases)
- **CRITICAL**: Stops if UVP weak or success metrics vague

**Essence-Driven LEGO Prioritization** (Section 5 enhancement):
- Three-tier priority system:
  - **Tier 1: Core Value LEGOs** - deliver essence FIRST (e.g., signal_generator for trading)
  - **Tier 2: Supporting LEGOs** - enable core value (e.g., data_fetcher, calculator)
  - **Tier 3: Config Validation** - always first to implement
- New `lego_plan.json` fields:
  - `priority_tier`: `core_value` | `supporting` | `config_validation`
  - `essence_metric`: which metric from essence.md this LEGO impacts
- Implementation order tied to essence delivery (config → core value → supporting → tests)

**End-to-End Experience Validation** (Section 11.1):
- Validates complete user journey BEFORE declaring app complete
- Assessment phases:
  - Getting started (time to first value, config validation, friction points)
  - Core workflow (delivers UVP?, success metrics measurable?)
  - Failure modes (graceful degradation, recovery, circuit breakers)
  - Continuous improvement (monitoring, benchmarking, feedback collection)
- Creates `experience_validation.md` documenting test results vs targets
- **CRITICAL**: Stops if core value delivery cannot be validated or metrics fall short

**Domain-Specific Success Metrics** (in Section 4.3):
- Performance/Scale apps: p99 latency, throughput (ops/sec, GB/sec), cost per operation
- Simplicity/Experience apps: Time-to-first-value, cognitive load, user retention
- Data/Analytics apps: Query latency, data freshness, insight accuracy
- Financial/Trading apps: Sharpe ratio, win rate, max drawdown
- Developer Tools: LOC to achieve task, build/deploy time

**Enhanced App-Specific AGENTS.md Generation** (Section 11.2):
- Generated AGENTS.md now includes:
  - Essence & Value Proposition (from essence.md)
  - User Journey (complete experience map)
  - Core Value LEGOs (which LEGOs deliver essence, why prioritized)

### Changed

- **Section 5 header**: "LEGO DISCOVERY (KISS-DRIVEN)" → "LEGO DISCOVERY (KISS-DRIVEN, ESSENCE-FIRST)"
- **Section 11 restructure**: "DOCUMENTATION & FINAL REVIEW" → "END-TO-END EXPERIENCE VALIDATION & DOCUMENTATION"
  - Section 11.1: Experience Validation (new)
  - Section 11.2: Final Documentation (enhanced)
- **Pipeline sequence**: Now essence.md → requirements.md → dependencies.md → LEGO discovery

### Philosophy Shift

**From "Build it right"** → **"Build the right thing"**:
- Previously: Focus on engineering quality (tests, architecture, patterns)
- Now: Validate problem-solution fit BEFORE coding, prioritize essence delivery, measure success against domain-specific metrics

### Files Generated (by apps using v1.5.0)

- `essence.md` - Problem, UVP, competitive landscape, success metrics, user journey
- `experience_validation.md` - End-to-end UX validation results

### Impact

Apps built with v1.5.0 will:
1. Explicitly validate they solve the RIGHT problem (not just solve it right)
2. Prioritize core value LEGOs over supporting infrastructure
3. Have measurable, domain-specific success criteria
4. Validate end-to-end user experience before declaring complete
5. Include essence/UVP/journey in app-specific AGENTS.md

---

## [1.4.0] - 2025-11-24 (Phase 1.7: Intelligent Maintenance Mode)

### Added

**Intelligent Maintenance Mode** (Section 0 enhancement):
- **File-by-File Evaluation** when app_intent.md changes:
  - Files with `user_modified: true` → PROTECTED (never touch)
  - Files with `user_modified: false` → EVALUATE using:
    - Phase 1.5 wisdom/intuition (antipattern detection, LEGO principles)
    - Quality metrics (test coverage >80%, error handling, security)
    - Confidence scoring (domain knowledge, requirements clarity, risk level, precedent match)
  - **Decision per file**: KEEP (well-structured) | REFACTOR (fixable issues) | REGENERATE (severe antipatterns)
- **Evaluation report in APP_ORCHESTRATION.md** documenting:
  - What was found (architecture, antipatterns, quality)
  - What decision was made per file (KEEP/REFACTOR/REGENERATE)
  - Why (cite wisdom principles, antipatterns avoided, trade-offs)
- Human approval of evaluation plan before execution

**Intelligent Upgrade Evaluation** (Section 0 enhancement):
- **File-by-File Assessment** when VERSION changes but app_intent.md unchanged:
  - Files with `user_modified: true` → PROTECTED
  - Files with `user_modified: false` → EVALUATE:
    - Apply new wisdom capabilities (e.g., intuition system in v1.2.0)
    - Check if file benefits from new meta-orchestrator features
  - **Decision per file**: KEEP (no new features needed) | ENHANCE (add features without breaking) | REGENERATE (rebuild with new patterns)
- **Upgrade plan in APP_ORCHESTRATION.md** showing:
  - New meta-orchestrator features available
  - Current architecture evaluation (antipatterns, quality, test coverage)
  - Which files will be kept/enhanced/regenerated and why
  - Which new LEGOs will be added
- Human approval before applying upgrade

**Evaluation Framework** (new Section 0 subsection):
- **Systematic Criteria**:
  - Antipattern detection (God Object, Golden Hammer, Magic Numbers, Premature Optimization, Copy-Paste)
  - LEGO principles (Thompson #5, Single Responsibility, KISS, Interface Clarity)
  - Quality metrics (test coverage, error handling, documentation, security)
  - Confidence scoring (0.0-1.0 based on domain knowledge, requirements clarity, risk level, precedent match)
- **Decision Matrix**:
  - KEEP (score >0.8, no antipatterns)
  - REFACTOR (score 0.5-0.8, minor issues, modify incrementally)
  - REGENERATE (score <0.5, severe antipatterns, rebuild from scratch)

**App-Specific AGENTS.md Generation** (Section 11 enhancement):
- Meta-orchestrator now generates **app-specific** `AGENTS.md` (root) for future AI-assisted development
- Content includes:
  - Application Context (purpose, domain, key features)
  - LEGO Architecture (breakdown with rationale citing Thompson #5, KISS)
  - Wisdom Applied (which principles guided design decisions)
  - Antipatterns Avoided (what mistakes were prevented)
  - Success Patterns Used (Circuit Breaker, Config Validator, etc.)
  - Trade-offs Resolved (key decisions and alternatives)
  - Development Guidelines (domain-specific constraints, coding standards)
  - Common Tasks (guide for future changes)
  - References to `.meta/AGENTS.md` (orchestration engine), `.meta/principles.md`, `.meta/wisdom/`, `.meta/patterns/`
- Makes apps **self-documenting** for AI-assisted development

### Changed

- **Section 0 (Version Check)**: Expanded with MAINTENANCE MODE (app_intent.md changed) and ENGINE UPGRADE MODE (VERSION changed)
- **Section 11 (Documentation)**: Enhanced to generate comprehensive app-specific AGENTS.md
- **.meta-manifest.json**: Now includes `user_modified` flag for all generated files (default: false)

### Philosophy

**From reactive fixes** → **wisdom-driven evaluation**:
- Don't blindly regenerate all files when requirements change
- Apply systematic evaluation using intuition/wisdom from Phase 1.5
- Make transparent, justified decisions (KEEP/REFACTOR/REGENERATE)
- Protect user-modified files (respect human customization)
- Document reasoning in APP_ORCHESTRATION.md for human review

### Impact

Apps using v1.4.0 can:
1. Safely evolve when requirements change (intelligent maintenance)
2. Adopt new meta-orchestrator features without breaking (intelligent upgrade)
3. Have transparent, wisdom-driven file-by-file decisions
4. Self-document architecture and wisdom for future AI-assisted development
5. Protect user customizations (user_modified: true files never touched)

---

## [1.3.0] - 2025-11-24 (Phase 1.6: App-Specific Orchestration Documentation)

### Added

**APP_ORCHESTRATION.md** - App-specific orchestration plan:
- Generated after `lego_plan.json` in Section 6
- Uses `.app_orchestration.template.md` as structure
- Documents for THIS specific app:
  - Application overview (from app_intent.md and requirements.md)
  - LEGO architecture breakdown (from lego_plan.json)
  - Session execution plan (dependency graph, parallel groups)
  - Risk & confidence assessment (from LEGO confidence scores)
  - Wisdom & patterns applied (from intuition checks)
  - Testing strategy (unit, integration, system)
  - Documentation plan
  - Success criteria
- **Status tracking**: [IN_PROGRESS] during execution, [COMPLETE] when all LEGOs validated
- **Human-readable**: Clear, transparent orchestration decisions for this app

**.app_orchestration.template.md** - Template for app-specific orchestration:
- Standard structure for all apps
- Sections: Overview, LEGO Architecture, Execution Plan, Risk Assessment, Wisdom Applied, Testing, Documentation, Success Criteria, Execution Log, Final Approval

### Changed

- **Section 6**: Now generates APP_ORCHESTRATION.md and optionally pauses for human approval
- **Section 11**: Finalizes APP_ORCHESTRATION.md status to [COMPLETE] and includes in manifest

### Key Distinction

**Before Phase 1.6**:
- `AGENTS.md` in `.meta/` was universal (same for all apps)
- No app-specific orchestration documentation
- `lego_plan.json` was machine-readable only

**After Phase 1.6**:
- `.meta/AGENTS.md` remains universal (how to orchestrate ANY app)
- `APP_ORCHESTRATION.md` is app-specific (orchestration plan for THIS app)
- Human-readable record of architecture decisions, wisdom applied, risks assessed

### Philosophy

**Transparency & Auditability**:
- Users can review orchestration plan before execution
- Permanent record of why LEGOs were designed this way
- Documents wisdom principles and patterns applied
- Facilitates understanding and debugging

---

## [1.2.0] - 2025-11-24 (Phase 1.5: Intuition & Wisdom System)

### Added

**Wisdom Library** (~24,000 lines, 4 files in `.meta/wisdom/`):

1. **`engineering_wisdom.md`** (~3000 lines):
   - 15 principles from 14 legendary engineers
   - Sources: Kernighan, Knuth, Dijkstra, Pike, Thompson, Kay, Torvalds, Hoare, Brooks, Parnas, Bentley, Liskov, Wirth, Carmack
   - Key triggers:
     - #1: Debugging harder than writing (keep code simple)
     - #2: Premature optimization is evil (profile first)
     - #5: Do one thing well (Thompson's Unix Philosophy)
     - #10: Data structure choice matters most (Pike)
   - Applied during: DESIGN, CODING

2. **`strategic_wisdom.md`** (~4000 lines):
   - 15 principles from 6 strategic thinkers
   - Sources: Sun Tzu, Boyd (OODA Loop), Clausewitz, Taleb (Antifragile, Black Swan, Skin in the Game), Kahneman, Eisenhower
   - Key concepts:
     - #2: OODA Loop (Observe, Orient, Decide, Act)
     - #4: Antifragility (systems that gain from stress)
     - #5: Barbell Strategy (conservative + bold, avoid middle)
     - #10: Via Negativa (subtract, don't add)
   - Applied during: DESIGN, high-level architecture

3. **`design_wisdom.md`** (~3700 lines):
   - 8 principle groups from 3 design masters
   - Sources: Dieter Rams (10 Principles of Good Design), Christopher Alexander (Pattern Language), Don Norman (Design of Everyday Things)
   - Key principles:
     - Rams: "Good design is as little design as possible"
     - Alexander: "Living structure" through patterns
     - Norman: Affordances and signifiers
   - Applied during: DESIGN, interface design

4. **`risk_wisdom.md`** (~3500 lines):
   - Security principles from 2 cryptography/security experts
   - Sources: Bruce Schneier (security mindset), Saltzer & Schroeder (8 security principles)
   - Key concepts:
     - Schneier: Assume breach, defense in depth
     - Saltzer & Schroeder: Least privilege, fail-safe defaults, psychological acceptability
   - Applied during: VALIDATION (sensitive LEGOs)

**Patterns Library** (~9,500 lines, 3 files in `.meta/patterns/`):

1. **`antipatterns.md`** (~3500 lines):
   - 15 common antipatterns with detection rules
   - God Object, Golden Hammer, Spaghetti Code, Magic Numbers, Copy-Paste Programming, Premature Optimization, Not Invented Here, Analysis Paralysis, Cargo Cult Programming, Reinventing the Wheel, Feature Creep, Big Ball of Mud, Lava Flow, Boat Anchor, Dead Code
   - Each includes: definition, why harmful, how to detect, how to avoid
   - Applied during: DESIGN, REVIEW, CODING

2. **`success_patterns.md`** (~3000 lines):
   - 15 proven patterns for robust systems
   - Circuit Breaker, Retry with Exponential Backoff, Bulkhead, Cache-Aside, CQRS, Event Sourcing, Saga, Strangler Fig, Anti-Corruption Layer, Gateway Aggregation, Config Validator, Health Check, Rate Limiting, Idempotency, Dead Letter Queue
   - Each includes: when to use, benefits, implementation notes, trade-offs
   - Applied during: DESIGN

3. **`trade_off_matrix.md`** (~3000 lines):
   - 15 common trade-offs with decision guidance
   - Simplicity vs Power, Performance vs Maintainability, Consistency vs Availability, Security vs Usability, Time-to-Market vs Quality, Flexibility vs Simplicity, Latency vs Throughput, Centralization vs Decentralization, Build vs Buy, Monolith vs Microservices, SQL vs NoSQL, Sync vs Async, Pull vs Push, Optimistic vs Pessimistic Locking, Normalization vs Denormalization
   - Each includes: trade-off description, when to favor each side, decision factors, red flags
   - Applied during: DESIGN

**Intuition Integration** ([P-INTUITION] in .meta/principles.md):
- LEGO-Orchestrators MUST consult wisdom files during DESIGN, CODING, VALIDATION
- Confidence scoring (0.0-1.0) based on:
  - Domain knowledge (how well code matches domain best practices)
  - Requirements clarity (clear need from app_intent.md)
  - Risk level (critical data/security vs low UI formatting)
  - Precedent match (similar to success patterns)
- `lego_state_<name>.json` includes intuition_check:
  - `wisdom_applied`: which principles were used
  - `antipatterns_avoided`: which mistakes were prevented
  - `trade_offs_resolved`: which decisions were made and how

### Changed

- **Section 8 (LEGO-Orchestrator Sessions)**: Enhanced with wisdom consultation steps
  - DESIGN: Check success_patterns.md, use trade_off_matrix.md, apply engineering/design wisdom, check antipatterns.md
  - CODING: Apply engineering wisdom triggers (complexity, optimization, readability)
  - VALIDATION: Apply risk_wisdom.md for sensitive LEGOs
- **`lego_state_<name>.json` format**: Added confidence_score, confidence_factors, intuition_check

### Philosophy

**From heuristics** → **wisdom-driven decisions**:
- Don't rely on generic "best practices"
- Consult battle-tested principles from 20+ legendary figures
- Recognize and avoid known antipatterns
- Apply proven success patterns
- Use decision matrices for trade-offs
- Document which wisdom was applied and why

### Impact

LEGOs designed with Phase 1.5 will:
1. Apply 50+ principles from engineering masters
2. Avoid 15 common antipatterns
3. Use 15 proven success patterns
4. Make informed trade-off decisions (15 scenarios)
5. Calculate confidence scores (0.0-1.0)
6. Document intuition checks for transparency

---

## [1.1.0] - 2025-11-24 (Phase 1: Core Capabilities)

### Added

**Session Isolation & Multi-Agent Architecture**:
- `SESSION_ISOLATION.md` - Complete guide on true multi-session architecture
- Session brief templates for each LEGO (isolated context)
- `session_registry.template.json` - Tracking all active sessions
- `session_queue.template.json` - Dependency-based coordination
- Benefits:
  - Build apps with 50+ components without context degradation
  - 60-80% lower token costs (smaller contexts per session)
  - True parallelism (3+ LEGOs built simultaneously)
  - Fault isolation (one LEGO failure doesn't corrupt pipeline)

**Runtime Adapters (Tool Agnosticism)**:
- `agent_runtime.json` - Configuration for different AI platforms
- `runtime_adapters/adapter_interface.md` - Standard interface for all adapters
- `runtime_adapters/codex_cli_adapter.sh` - OpenAI Codex CLI implementation
- `runtime_adapters/copilot_adapter.sh` - GitHub Copilot implementation
- Extensible: Easy to add Claude MCP, custom APIs, etc.
- Benefits:
  - Switch between AI platforms with config change
  - Not locked into one vendor
  - Can use best tool for each task
  - Future-proof architecture

**Testing Strategy**:
- `TESTING_STRATEGY.md` - Complete guide on unit, integration, system, and deployment tests
- **Unit tests**: Per-LEGO (inputs → outputs, edge cases, error paths)
- **Integration tests**: LEGO-to-LEGO interactions (data flow, error propagation)
- **System tests**: End-to-end workflows (user journeys, multi-LEGO flows)
- **Deployment tests**: Real-world constraints (network failures, rate limits)
- Test LEGOs in `lego_plan.json` (type: `integration_test`, `system_test`)

**Config Validation**:
- `CONFIG_VALIDATION.md` - Complete specification for config_validator LEGO
- Always generated first (dependency for all other LEGOs)
- Responsibilities:
  - Validate `.env` variables (presence, format, connectivity)
  - Check external service endpoints (from external_services.md)
  - Guide users through setup (clear error messages, docs links)
  - Run before any other LEGO (pre-flight check)
- Type: `config_validation` in lego_plan.json

**LEGO Architecture**:
- Single-responsibility components (Thompson #5: "Do one thing well")
- Clear inputs/outputs (KISS principle)
- Minimal dependencies (loose coupling)
- lego_plan.json fields: name, type, responsibility, inputs, outputs, assumptions, fundamentals, sensitive, needs_agent, dependencies

### Changed

- **Section 5 (LEGO Discovery)**: Added config_validator LEGO requirement
- **Section 8 (LEGO-Orchestrator Sessions)**: Added TEST AUTHORING substep
- **Section 11 (Documentation)**: Added integration/system test documentation

### Philosophy

**KISS + LEGO Architecture**:
- Keep It Simple, Stupid (don't over-engineer)
- Single responsibility (one job per LEGO)
- Easy to test (isolated components)
- Easy to replace (swap LEGOs without breaking others)

---

## [1.0.0] - 2025-11-23 (Initial Release)

### Added

**Core Meta-Orchestrator**:
- `.meta/AGENTS.md` - Main orchestrator instructions
- `.meta/intent.md` - Meta-level orchestration intent (how the pipeline behaves)
- `.meta/principles.md` - Global design principles (KISS, LEGO, privacy, testing, R&D modes)
- `meta_config.json` - Configuration (require_lego_plan_approval, r_and_d_mode)

**Pipeline Stages**:
1. Environment Preflight (verify shell commands, file operations)
2. Config Load (read meta_config.json or create with defaults)
3. Load Principles & Meta Intent
4. Interactive Requirements Discovery (from app_intent.md)
5. LEGO Discovery (decompose app into single-responsibility components)
6. Pipeline Planning & Global State (orchestrator_state.json)
7. LEGO-Orchestrator Sessions (one per LEGO: DESIGN → CODING → VALIDATION)
8. GEN+REVIEW Pattern (create → critically evaluate → refine)
9. Safety Valves (failure_count tracking, stuck detection)
10. Documentation & Final Review (README, internal-notes, review.md)
11. Restartability (resume from last checkpoint)

**Requirements Discovery**:
- `requirements.md` template with sections: Metadata, Overview, Scope, Functional Requirements, Non-Functional Requirements, Data & Privacy, External Dependencies, Evaluation, Changelog
- `dependencies.md` - Human-readable dependency summary
- `.env.example` - Required environment variables (names only, no secrets)
- `external_services.md` - API/service documentation (free vs paid, rate limits, how to get keys)

**GEN+REVIEW Pattern**:
- GEN: Create initial artifact
- REVIEW: Critically evaluate and refine
- Append REVIEW NOTES section (changes, limitations, TODOs)
- Applied to: requirements, design, tests, docs, implementation

**Safety Valves**:
- Track failure_count for steps and LEGOs
- Mark as "stuck" after 3 failures
- Write meta_error.md with guidance for user
- Avoid infinite retry loops

**Restartability**:
- Read orchestrator_state.json on each run
- Determine READY steps (dependencies satisfied, not stuck)
- Launch only those sessions
- Continue until complete or safety valve triggered

### Philosophy

**Hierarchical Control**:
- Meta-Orchestrator (this file) coordinates the pipeline
- LEGO-Orchestrators (one per component) handle detailed work
- Session hygiene (exit after 3-5 tasks, checkpoint progress)

**File Roles**:
- `intent.md` → HOW the pipeline works (meta-orchestration)
- `app_intent.md` → WHAT to build (application requirements)
- `.meta/principles.md` → Global design constraints (KISS, LEGO, privacy)

**R&D Modes**:
- `fast`: Minimal cycles, lighter evaluation, red-team only for obviously sensitive LEGOs
- `thorough`: More GEN+REVIEW cycles, richer evaluation harnesses, mandatory red-team for sensitive LEGOs

---

## Version Summary

| Version | Date | Phase | Key Feature | Lines Added |
|---------|------|-------|-------------|-------------|
| 1.10.0 | 2025-12-04 | 2.2 | Self-Contained App Architecture | ~500 |
| 1.9.0 | 2025-12-04 | 2.1 | Role-Based Architecture | ~800 |
| 1.8.0 | 2025-12-04 | 2.0 | Enhanced App Orchestration & Self-Awareness | ~400 |
| 1.5.0 | 2025-11-25 | 1.8 | Product-Market Fit & UX Focus | ~300 |
| 1.4.0 | 2025-11-24 | 1.7 | Intelligent Maintenance Mode | ~400 |
| 1.3.0 | 2025-11-24 | 1.6 | App-Specific Orchestration Documentation | ~200 |
| 1.2.0 | 2025-11-24 | 1.5 | Intuition & Wisdom System | ~24,000 |
| 1.1.0 | 2025-11-24 | 1.0 | Core Capabilities (Session Isolation, Testing, Config) | ~3,000 |
| 1.0.0 | 2025-11-23 | Initial | Meta-Orchestrator Foundation | ~1,500 |

---

## Upgrade Path

### From 1.9.0 to 1.10.0

**Breaking Changes**: None (but new folder structure)

**New Capabilities**:
- `.app/` folder for self-contained app orchestration
- Apps don't need `.meta/` at runtime (after create/upgrade)
- Generator system for creating `.app/` folder
- Clear separation of ENGINE vs APP concerns

**Migration**:
1. Copy new `.meta/` from meta-metacognition (as usual)
2. Run engine - it will detect version mismatch
3. Engine generates `.app/` folder for your app
4. Future maintenance uses `.app/AGENTS.md` only
5. `.meta/` only needed for future upgrades

### From 1.8.0 to 1.9.0

**Breaking Changes**: None

**New Capabilities**:
- Role-based architecture with 5 distinct roles
- Essence Triangle for product decisions
- Immutable specification artifacts (specs/)
- Three workflows: New Feature, Enhancement, Bug Fix
- Role-specific principles and templates

**Migration**:
1. New apps automatically use role-based structure
2. Existing apps: Create `specs/` directory structure when ready
3. Migrate requirements to FR-XXX format over time
4. No immediate action required (fully backward compatible)

### From 1.7.8 to 1.8.0

**Breaking Changes**: None

**New Capabilities**:
- PERSONA section for app orchestrators (explicit autonomous identity)
- Feature Discovery Phase (Product Manager Mode before implementation)
- E2E Scenario Testing principles (`[P-E2E]`)
- Self-Awareness & Rathole Prevention (Engineering Wisdom #17)
- Control Flow & Data Flow Analysis (Engineering Wisdom #18, `[P-FLOW-ANALYSIS]`)

**Migration**:
1. Read `UPGRADING.md` for detailed workflow
2. Meta-orchestrator will detect version mismatch (1.7.8 vs 1.8.0)
3. Run ENGINE UPGRADE MODE to regenerate agent files with PERSONA section
4. Apps will now have orchestrators with autonomous identity enforcement
5. New features will go through Feature Discovery (essence validation) before implementation

### From 1.4.0 to 1.5.0

**Breaking Changes**: None

**New Capabilities**:
- Essence & Value Proposition Discovery (ensures app solves RIGHT problem)
- Essence-driven LEGO prioritization (core value first, supporting second)
- End-to-End Experience Validation (validates user journey before declaring complete)
- Domain-specific success metrics (Sharpe ratio, p99 latency, time-to-value, etc.)
- Enhanced app-specific AGENTS.md (includes essence, UVP, user journey)

**Migration**:
1. Read `UPGRADING.md` for detailed workflow
2. Meta-orchestrator will detect version mismatch (1.4.0 vs 1.5.0)
3. Run ENGINE UPGRADE MODE:
   - Generate upgrade plan in APP_ORCHESTRATION.md
   - Show which files benefit from essence-driven approach
   - Get user approval before applying changes
4. Apps will now generate `essence.md` (before coding) and `experience_validation.md` (before completion)

### From 1.3.0 to 1.4.0

**Breaking Changes**: None

**New Capabilities**:
- Intelligent Maintenance Mode (file-by-file evaluation when requirements change)
- Intelligent Upgrade Evaluation (KEEP/ENHANCE/REGENERATE decisions)
- App-specific AGENTS.md generation (self-documenting apps)
- .meta-manifest.json with user_modified flags

**Migration**:
1. Read `UPGRADING.md` for detailed workflow
2. Meta-orchestrator will detect version mismatch (1.3.0 vs 1.4.0)
3. Run ENGINE UPGRADE MODE:
   - Generate upgrade plan in APP_ORCHESTRATION.md
   - Show which files will be kept/enhanced/regenerated
   - Get user approval before applying changes
4. After upgrade, app will have app-specific AGENTS.md in root

### From 1.2.0 to 1.3.0

**Breaking Changes**: None

**New Capabilities**:
- APP_ORCHESTRATION.md for app-specific orchestration plans
- Human-readable record of architecture decisions, wisdom applied, risks assessed

**Migration**:
1. Update `.meta/` directory to version 1.3.0
2. Run meta-orchestrator on existing app
3. It will generate APP_ORCHESTRATION.md for your app
4. Review and approve (if require_lego_plan_approval: true)

### From 1.1.0 to 1.2.0

**Breaking Changes**: None

**New Capabilities**:
- Intuition & Wisdom System (~24,000 lines)
- Consult 50+ principles from 20+ legendary figures
- Recognize 15 antipatterns, apply 15 success patterns
- Use decision matrices for 15 trade-offs
- Confidence scoring for all designs

**Migration**:
1. Update `.meta/` directory to version 1.2.0
2. Add `wisdom/` and `patterns/` directories (7 new files)
3. Existing apps continue to work (no regeneration needed)
4. New LEGOs will use wisdom/intuition system
5. Consider regenerating critical LEGOs to apply wisdom

### From 1.0.0 to 1.1.0

**Breaking Changes**: None

**New Capabilities**:
- Session isolation (60-80% token cost reduction)
- Runtime adapters (switch between AI platforms)
- Integration/system tests (validation beyond unit tests)
- Config validation LEGO (always generated first)

**Migration**:
1. Update `.meta/` directory to version 1.1.0
2. Add `SESSION_ISOLATION.md`, `TESTING_STRATEGY.md`, `CONFIG_VALIDATION.md`
3. Add `runtime_adapters/` directory with adapter files
4. Existing apps continue to work (no changes needed)
5. New apps will include config_validator LEGO and test LEGOs

---

## Contributing

This is a living document. As the meta-orchestrator evolves, update this CHANGELOG with:
- Version number and date
- Phase number and name
- Added/Changed/Deprecated/Removed/Fixed sections
- Philosophy shifts or architectural changes
- Upgrade instructions for existing apps

---

## References

- **Main Documentation**: `AGENTS.md` (meta-orchestrator engine)
- **Principles**: `principles.md` (KISS, LEGO, privacy, testing)
- **Intuition**: `INTUITION.md` (user-facing wisdom system guide)
- **Wisdom Library**: `.meta/wisdom/` (4 files, ~14,000 lines)
- **Patterns Library**: `.meta/patterns/` (3 files, ~9,500 lines)
- **Testing**: `TESTING_STRATEGY.md` (unit, integration, system tests)
- **Config**: `CONFIG_VALIDATION.md` (config_validator LEGO spec)
- **Deployment**: `DEPLOYMENT_GUIDE.md` (production deployment)
- **Upgrading**: `UPGRADING.md` (version migration workflow)
- **App Orchestration**: `.app_orchestration.template.md` (app-specific plan template)
