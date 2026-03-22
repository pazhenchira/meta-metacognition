# meta-metacognition

**Framework**: metaagent v0.10.0
**Orchestrator**: Atlas

This file provides lightweight context for day-to-day work. For full orchestrator mode with deliberation, role delegation, and perspective challenges, run `/agent` and select **Atlas**.

---

## Project Identity

**Name**: meta-metacognition

**Essence**: A meta-orchestrator engine that builds applications through a KISS-driven, LEGO-based, multi-session R&D pipeline. It orchestrates complete application generation from intent to deployed code.

**Success Criteria**:

| Criterion | Target | Measurement |
|-----------|--------|-------------|
| End-to-end app generation | Intent → running app | Pipeline completes all 12 phases |
| Quality enforcement | No fabricated artifacts | GEN+REVIEW pattern, Turn Report |
| Framework alignment | MetaAgent v0.10.0 conventions | .brain/ structure, habits, skills |

---

## How Work Gets Done

**Atlas** (the orchestrator) routes work to specialist agents. It uses 8 habits: Orient, Deliberate, Delegate, Verify, Learn, Ship, Document, Report.

The engine's 12-phase build pipeline lives in `.meta/AGENTS.md` — Atlas references it when building applications.

---

## Core Principles

1. **KISS** — Simplest solution that works
2. **LEGO Architecture** — Single-responsibility, composable components
3. **GEN+REVIEW** — Every generated artifact gets independent review
4. **Essence-First** — Discover what makes the app valuable before building

See: `.meta/principles.md`, `.meta/wisdom/`

---

## Key Directories

```
meta-metacognition/
├── .github/agents/        # Atlas orchestrator
├── .brain/                # Project brain (MetaAgent convention)
│   ├── config.yaml        # Framework config
│   ├── lessons.md         # Accumulated knowledge
│   ├── status.md          # Current state
│   └── work-items/        # Work tracking
├── .meta/                 # Engine core (READ-ONLY)
│   ├── AGENTS.md          # 12-phase build pipeline
│   ├── principles.md      # KISS, LEGO, etc.
│   ├── wisdom/            # Engineering wisdom
│   ├── patterns/          # Antipatterns, BS detection
│   ├── roles/             # Role specs
│   ├── playbooks/         # Structured workflows
│   └── templates/         # App generation templates
├── skills/                # Quality protocols
├── essence.md             # What makes this engine valuable
└── [app code]             # codex_mcp_server.py, runtime_adapters/, etc.
```
