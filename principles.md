# GLOBAL PRINCIPLES FOR META-COGNITIVE R&D PIPELINE

These principles govern *every* Codex CLI session in this repository: the Meta-Orchestrator, LEGO-Orchestrators, and all nested substeps.

(Shortened here; you can expand as needed.)

- [P-KISS] Ruthless KISS: single-responsibility legos, simplest correct design.
- [P-LEGO] LEGO Architecture: clear interfaces, stable contracts, explicit fundamentals.
- [P-FLOW] Hierarchical Flow: meta → lego orchestrators → substeps.
- [P-SESSIONS] Session Hygiene: avoid long sessions, use checkpoints.
- [P-RESTART] Restartability: orchestrator_state.json, lego_plan.json, lego_state_*.json.
- [P-GENREVIEW] GEN+REVIEW: draft then critique with REVIEW NOTES.
- [P-DATA] External Data: enumerate APIs, config, cost.
- [P-PRIVACY] Privacy: classify sensitivity, avoid logging raw PII/PHI/financial.
- [P-AGENT] Agents: use only where reasoning helps, not for simple logic.
- [P-CODE], [P-TEST], [P-DOC-INT], [P-DOC-PUB], [P-SUPPORT], [P-SAFETY], [P-R&D], [P-CONFIG]: as discussed in our design.
