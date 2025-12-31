# Getting Started with the Meta-Orchestrator

This guide is the shortest path to a working app. It focuses on setup and first run. For deeper detail, see the links at the end.

---

## Quick Start (5 minutes)

### 1) Clone the repo

```bash
git clone https://github.com/pazhenchira/meta-metacognition.git
cd meta-metacognition
```

### 2) Describe your app

Edit `app_intent.md` and be explicit about goals, inputs, and constraints.

Example:
```markdown
# My Trading Signal App

I want an app that analyzes options data and surfaces actionable signals.

## What it should do:
- Pull options chain data
- Compute key analytics
- Rank signals using a clear, risk-aware metric

## Constraints:
- Use free or low-cost data sources
- Run locally on my laptop
- Keep the workflow simple
```

### 3) Pick a runtime (optional)

Set your preferred runtime in `meta_config.json`:
```json
{
  "preferred_runtime": "codex-cli-parallel",
  "enable_subagents": true
}
```

Notes:
- `codex-cli-parallel` is the most reliable mode (one role per session).
- If MCP tools are configured and available, `codex-cli-mcp` can be faster.
- If you are unsure, leave the defaults and proceed.
 - If you choose MCP mode and tools do not appear, merge `.app/runtime/codex_mcp_servers.toml` into `~/.codex/config.toml` (non-destructively) and restart Codex. You can use `scripts/merge_codex_mcp_config.py`.

### 4) Run the meta-orchestrator

```bash
# Option A: Copilot Chat Agent Picker
# - Select "Meta-Orchestrator"
# - Say: "Build the app from app_intent.md"

# Option B: Codex CLI (terminal)
# - Start: codex
# - Say: "Build the app from app_intent.md"

# Option C: Manual activation (any runtime)
@workspace Act as the meta-orchestrator in .meta/AGENTS.md and build this app
```

### 5) Review what you get

In 10-30 minutes (depending on complexity), you should see:
- `src/` with your application code
- `tests/` with unit/integration/system tests
- `essence.md` describing the value hypothesis
- `requirements.md` describing the spec
- `APP_ORCHESTRATION.md` documenting decisions

---

## Key ideas (short versions)

- **Essence discovery**: The orchestrator identifies the core value, not just features.
- **LEGOs**: Small, single-responsibility components built in parallel.
- **Session isolation**: Each LEGO is built in a focused session to avoid context overload.

---

## Example (high level, intentionally sparse)

**Core Alpha Systems (Options Trader)** is an example of the kind of system this engine can support. The orchestration emphasizes:
- separating core signal logic from supporting data and validation components,
- defining a success metric up front,
- and validating the end-to-end user workflow.

Details are intentionally omitted to avoid leaking product specifics.

---

## Common tasks

### Add a feature

1. Update `app_intent.md` with the new capability.
2. Re-run the orchestrator.
3. It will enter maintenance mode and propose a keep/refactor/regenerate plan.

### Protect custom code

If you edit generated code, mark it as user-modified in `.meta-manifest.json` so it is protected on future runs.

### Upgrade the engine

See `UPGRADING.md` for the supported upgrade workflow and guardrails.

---

## Helpful references

- Engine intent: `.meta/intent.md`
- Orchestration logic: `.meta/AGENTS.md`
- Testing philosophy: `TESTING_STRATEGY.md`
- Config validation: `CONFIG_VALIDATION.md`
- Upgrade guide: `UPGRADING.md`
- Session model: `SESSION_ISOLATION.md`
