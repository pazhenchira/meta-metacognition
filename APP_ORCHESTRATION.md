
## Engine Upgrade v2.0.31
- 2025-12-27: Added regression + E2E requirements for Developer/Tester roles.
- App Orchestrator oversight strengthened; APP_OVERRIDES in `.app/AGENTS.md` preserved on upgrade.

## Engine Upgrade v2.0.30
- 2025-12-27: Added Documentation Index and identity confirmation protocol for App Orchestrator + subagents.
- Consistency audit now verifies doc index + identity confirmation exist in `.app/AGENTS.md`.

## Engine Upgrade v2.0.29
- 2025-12-27: Added docs-first discipline and subagent enforcement for App Orchestrator.
- Consistency audit now verifies these guardrails exist in `.app/AGENTS.md`.

## Engine Upgrade v2.0.28
- 2025-12-27: Added GTM Strategy Owner role and GTM Strategy review gate before GTM sub-roles.
- Wired GTM Strategy Owner into MCP server templates/runtime + app orchestrator templates.

## Engine Upgrade v2.0.27
- 2025-12-26: Added triage model (bug vs feature vs incident) and role selection matrix.
- Bug/incident workflows now route Ops/Dev first; PM is optional for impact/priority.
- Review gates clarified for final acceptance on non-feature work items.

## Engine Upgrade v2.0.26
- 2025-12-26: Added automated consistency audit gate for upgrades and completions.
- New script `scripts/consistency_audit.py` validates sources of truth, work item state, and self-contained app instructions.

## Engine Upgrade v2.0.25
- 2025-12-26: Consistency and source-of-truth alignment across engine templates and docs.
- App orchestrator templates now enforce tracker-based work item context and self-contained role instructions.
- Runtime timeout config de-duplicated; essence mirror sync rule added.

## Engine Upgrade v2.0.24
- 2025-12-26: Engine upgrade to v2.0.24 for re-orientation loop, problem framing gate, and completion gate.
- Operations is now required; production deployment is mandatory (release equivalent for non-deployable apps).
- GTM roles auto-included when GTM agents are available/enabled.
- Updated .app brain, workflows, MCP servers, and templates to enforce new gates.

## Engine Upgrade v2.0.23
- 2025-12-25: Engine upgrade to v2.0.23 for MCP profile wrapper support.
- Added wrapper script template and generator guidance; generated `scripts/codex-meta-metacognition.sh` for per-app MCP enablement.
- Updated MCP guidance to use wrapper scripts due to Codex CLI profile enablement limitations.
