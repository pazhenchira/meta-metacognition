# Intent

I want Codex CLI to act as a fully autonomous, meta-cognitive orchestration engine that builds complete applications from scratch.

The pipeline should:

- Extract requirements interactively, asking me only the minimal number of clarifying questions.
- Design a ruthlessly simple, single-responsibility LEGO architecture.
- Use one dedicated Codex CLI session (LEGO-Orchestrator) per LEGO block.
- For each LEGO, perform:
  - design
  - test authoring
  - documentation
  - coding
  - validation
- Use GEN + REVIEW patterns (first draft, then independent critique and refinement).
- Handle external data sources and subscriptions explicitly.
- Classify and protect sensitive data (PII/PHI/financial) with strict privacy rules.
- Be restartable using file-based state and Codex’s resume capabilities.
- Implement safety valves to bail out gracefully if a problem is too difficult or the environment is too restricted.

This repository defines the metacognitive pipeline itself. Future projects can copy this setup and adapt `intent.md` for their own apps.
