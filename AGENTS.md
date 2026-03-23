# meta-metacognition — Agent Router

> **Orchestrator**: Atlas (`.github/agents/atlas.agent.md`)
> **Framework**: MetaAgent v0.10.0

---

## How This Project Works

This project uses the MetaAgent framework for orchestration. Atlas is the orchestrator — it routes work to specialist agents, applies quality protocols (skills), and manages the project brain.

**For engine work** (maintaining/extending the meta-orchestrator): Atlas reads `.brain/playbooks/build-from-intent.md` for the 12-phase pipeline and `.brain/` for engine principles, wisdom, and patterns.

**For app building** (using the engine to create applications): Atlas follows the `.brain/playbooks/build-from-intent.md` pipeline phases, dispatching to appropriate roles.

---

## Key Entry Points

| Need | Go To |
|------|-------|
| Start working | `.github/agents/atlas.agent.md` |
| Project state | `.brain/status.md` |
| Lessons learned | `.brain/lessons.md` |
| Engine pipeline | `.brain/playbooks/build-from-intent.md` |
| Quality protocols | `skills/selector.md` |
| What makes this valuable | `essence.md` |

---

## Session Start

1. Read `.brain/status.md` — what's active, blocked, next
2. Read `.brain/lessons.md` — don't repeat past mistakes
3. Atlas handles the rest

---

## Previous Structure

This project was previously self-orchestrated via `.meta/AGENTS.md` directly. As of v4.0.0, it uses MetaAgent conventions (`.brain/`, `.github/agents/`, `skills/`). The v5.0.0 convergence collapsed `.meta/` entirely into `.brain/`, `patterns/`, `templates/`, and `generators/` — one brain, zero duplication.