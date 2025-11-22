# GLOBAL PRINCIPLES FOR META-COGNITIVE R&D PIPELINE

These principles govern *every* Codex CLI session: meta-orchestrator, LEGO orchestrators, and nested substeps.

---

## [P-KISS] Ruthless KISS
- Prefer the simplest correct solution.
- Legos must have exactly ONE responsibility.
- Avoid unnecessary abstractions or generalization.
- Prefer simple, explicit data structures and interfaces.
- Delete anything that adds complexity but not value.

---

## [P-LEGO] Single-Responsibility LEGO Architecture
- Decompose into small LEGO blocks with crisp, single-purpose definitions.
- Each LEGO defines:
  - responsibility (exactly one)
  - inputs
  - outputs
  - assumptions
  - fundamentals: performance, scalability, quality, security, privacy, cost
- LEGO interfaces must never leak internal complexity.
- Implementations may change (code ↔ API ↔ agent), but interfaces remain stable.

---

## [P-FLOW] Hierarchical Flow
- Meta-Orchestrator (top)
  - Extracts requirements
  - Defines LEGO blocks
  - Creates plan & state
  - Launches LEGO orchestrators
- LEGO-Orchestrator (per LEGO)
  - Handles design → tests → docs → implementation → validation
  - Uses checkpoints and short-lived sessions
- Substeps of a LEGO orchestrator are independent and executed as separate Codex CLI sessions when possible.

---

## [P-SESSIONS] Session Hygiene & Checkpoints
- No single session should grow too large.
- After ~3–5 Codex tasks within a session:
  - Write all state files,
  - Exit intentionally,
  - Resume via a fresh Codex session.
- All real memory MUST be persisted in files, not held in context.

---

## [P-RESTART] Restartability
- Always update:
  - `orchestrator_state.json`
  - `lego_state_<name>.json`
  - `lego_plan.json`
- The whole pipeline must be restartable via:
  - `codex exec`
  - `codex exec resume --last`

---

## [P-GENREVIEW] GEN + REVIEW Iteration
Each major artifact (requirements, design, tests, docs, implementation):
- GEN: initial creation
- REVIEW: independent critique and refinement
- REVIEW adds:
  - A “REVIEW NOTES” section inside the artifact

---

## [P-DATA] External Data & Subscription Handling
- Enumerate all external data sources and APIs.
- Include:
  - Name
  - Type (API/DB/file)
  - Authentication mechanism
  - Subscription/cost/quotas
- Never hard-code secrets; use env/config.
- Provide fallback or mock implementations.
  
---

## [P-PRIVACY] Privacy & Sensitive Data
- Classify data: public / internal / confidential / PII / PHI / financial.
- Never log raw sensitive data.
- Apply least-privilege to legos touching sensitive data.
- Document retention, storage location, and boundaries.

---

## [P-AGENT] LLM/Agent/MCP Usage
- Use LLM/agent reasoning only for:
  - unstructured input
  - ambiguous requirements
  - judgment calls
  - multi-step orchestration
- Avoid agents for deterministic logic.
- Encapsulate agents behind typed interfaces.
- Be cost-aware; minimize unnecessary agent invocations.

---

## [P-CODE] Code Quality
- Small, readable functions.
- Minimal nesting.
- Strong type discipline where possible.
- Validate inputs at boundaries.
- Fail early with clear errors.

---

## [P-TEST] Test Engineering
- Tests must encode behavior, not implementation details.
- Cover:
  - happy flow
  - edge cases
  - failure modes
  - regression tests
- Legos must be testable in isolation.

---

## [P-DOC-INT] Internal Documentation
- Document *why* decisions were made.
- Include trade-offs.
- Capture experimental branches and discarded alternatives.

---

## [P-DOC-PUB] Public Documentation
- Focus on user needs.
- Provide clear examples.
- Provide a quickstart path.

---

## [P-SUPPORT] Operability
- Provide logging (safe & minimal).
- Provide error messages with recovery hints.
- Add health checks or observability if required.

---

## [P-SAFETY] Safety Valves
- Track `failure_count` for steps.
- If a step fails 3 times:
  - Mark stuck
  - Write `meta_error.md`
  - Halt further attempts
  - Provide explicit user guidance
- Detect pipeline stalling and bail out gracefully.

---

## [P-R&D] Red-Team & Evaluation Best Practices
- For LE GOs handling sensitive data, perform a REDTEAM REVIEW substep:
  - Attempt to find leaks
  - Look for misuse or overexposure
  - Validate privacy boundaries
  - Document findings
- Each LEGO should define an EVALUATION HARNESS:
  - Tests
  - Metrics
  - Behavioral expectations
- LEGO orchestrators should keep per-LEGO evaluation notes.
- Experiment tracking:
  - Capture alternatives considered and reasoning for the chosen one.

---

## [P-CONFIG] Configurable R&D Modes
- Read `meta_config.json`, supporting:
  - `"fast"`: minimal cycles, no red-team unless sensitive
  - `"thorough"`: full cycles, mandatory red-team, detailed eval harness
- Respect `"require_lego_plan_approval"` for optional human approval stop.
