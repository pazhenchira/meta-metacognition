# Meta-Orchestrator Intent (Meta-Level)

This file describes the **intent of the meta-cognitive orchestration engine itself**, not any specific application.

The goal of the meta-orchestrator is to:

- Use Codex CLI as a **multi-session reasoning engine**.
- Decompose work into **single-responsibility LEGO blocks**.
- Orchestrate work via a **hierarchical control flow**:
  - A top-level Meta-Orchestrator.
  - One LEGO-Orchestrator per LEGO block.
  - Short-lived Codex sessions for substeps (design, tests, docs, code, validation).
- Apply **ruthless KISS**:
  - Prefer the simplest correct solution.
  - Each LEGO does exactly one job.
- Maintain **GEN + REVIEW** patterns:
  - GEN: first draft of any artifact.
  - REVIEW: independent critique and refinement, with REVIEW NOTES.
- Ensure **session hygiene**:
  - Avoid extremely long Codex sessions with huge context.
  - Persist all important state in files.
  - Use multiple smaller sessions that resume from state.
- Maintain **restartable state** in JSON/Markdown files.
- Implement **safety valves**:
  - Detect when steps are failing repeatedly or making no progress.
  - Bail out gracefully and surface clear instructions to the user.
- Apply **global engineering principles** from `principles.md`.
- Treat **application intent** as coming from `app_intent.md` only.
- Keep this meta-system reusable across many apps: for each new app, only `app_intent.md` changes.

This file is about *how* the engine thinks and behaves.  
The *application* you want to build is described in `app_intent.md`.
