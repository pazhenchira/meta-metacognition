# Meta-Orchestrator Intent (Meta-Level)

This file describes the **intent of the meta-cognitive orchestration engine itself**, not any specific application.

The goal of the meta-orchestrator is to:

- Use Codex CLI as a **multi-session reasoning engine**.
- Decompose work into **single-responsibility LEGO blocks**.
- Use **hierarchical control**:
  - A top-level Meta-Orchestrator
  - One LEGO-Orchestrator per LEGO
  - Short-lived Codex sessions for substeps
- Apply **ruthless KISS**:
  - Prefer the simplest correct solution.
  - Each LEGO does exactly one job.
- Maintain **GEN + REVIEW** patterns:
  - First draft (GEN)
  - Independent critique & refinement (REVIEW)
- Handle **session hygiene**:
  - Avoid extremely long Codex sessions.
  - Write state to files, then resume with fresh sessions.
- Maintain **restartable state** in JSON/Markdown files.
- Implement **safety valves**:
  - Detect when steps are failing or stuck.
  - Bail out gracefully and surface clear instructions.
- Apply **global engineering principles** from `principles.md`.
- Treat **application intent** as coming from `app_intent.md` only.

This file is about *how* the engine thinks and behaves. The *application* you want to build is described in `app_intent.md`.
