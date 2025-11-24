# GLOBAL PRINCIPLES FOR META-COGNITIVE R&D PIPELINE

These principles govern *every* Codex CLI session in this repository:  
the Meta-Orchestrator, LEGO-Orchestrators, and all nested substeps.

They are meant to be stable across projects. For each new app, you mainly change `app_intent.md`.

---

## [P-KISS] Ruthless KISS

- Prefer the simplest correct solution.
- Each LEGO must have exactly one clear responsibility.
- Avoid unnecessary abstractions, generalizations, or cleverness.
- Favor explicit, straightforward designs and data structures.
- If a concept/layer can be removed without breaking correctness, remove it.

---

## [P-LEGO] Single-Responsibility LEGO Architecture

- Decompose the system into small LEGO blocks (modules/components).
- For each LEGO, define:
  - `name`
  - `responsibility` (one job only)
  - `inputs`
  - `outputs`
  - `assumptions`
  - `fundamentals`:
    - performance
    - scalability
    - quality
    - security
    - privacy
    - cost
- LEGO interfaces must be stable and well-documented.
- Implementations may change (local code ↔ external API ↔ agent), but interfaces remain stable.

---

## [P-FLOW] Hierarchical Flow

- Use a hierarchical control flow:
  - **Meta-Orchestrator** (top-level):
    - reads `intent.md`, `app_intent.md`, `principles.md`, and `meta_config.json`;
    - performs interactive requirements & dependency discovery;
    - discovers legos and builds `lego_plan.json`;
    - writes `plan.md` and `orchestrator_state.json`;
    - launches LEGO-Orchestrator sessions as needed.
  - **LEGO-Orchestrator** (per LEGO):
    - focuses on a single LEGO at a time;
    - handles design, tests, docs, implementation, validation;
    - uses short-lived Codex sessions and `lego_state_<name>.json` for checkpoints.
  - **Substeps** (design, tests, docs, code, validation) are small, focused tasks.

---

## [P-SESSIONS] Session Hygiene & Checkpoints

- Avoid huge, long-running Codex sessions with massive conversation history.
- After ~3–5 substantial tasks in a session:
  - Persist progress to JSON/MD files (state and artifacts).
  - End the session intentionally.
  - Expect the next `codex exec` or `codex exec resume` to resume from state.
- All relevant facts and state must be stored in files, not only in conversation context.

---

## [P-RESTART] Restartability

- Use file-based state to support restartability:
  - `orchestrator_state.json`
  - `lego_plan.json`
  - `lego_state_<name>.json`
- On each new meta run or resume:
  - Read these state files.
  - Determine which steps/legos are READY (dependencies satisfied, status pending).
  - Execute only those steps.
- The pipeline should be safe to stop and restart multiple times without corruption.

---

## [P-GENREVIEW] GEN + REVIEW

For every major artifact (requirements, design, tests, docs, implementation):

- **GEN**:
  - Create an initial draft of the artifact.
- **REVIEW**:
  - Run an independent critique pass.
  - Improve clarity, correctness, and simplicity.
  - Append a `REVIEW NOTES` section to the bottom of the artifact describing:
    - what was changed,
    - what is still a known limitation,
    - any TODOs.

This pattern enforces basic self-critique and metacognition.

---

## [P-DATA] External Data & Subscriptions

- Explicitly enumerate all external data sources and APIs used by the app.
- For each external service, document:
  - name,
  - type (API/DB/file/etc.),
  - purpose,
  - authentication method,
  - pricing model and quotas (free tier vs paid),
  - failure modes and fallbacks.
- Never hard-code secrets in code. Use environment variables or config files for any keys.
- Avoid unnecessary dependencies. Prefer simple/local solutions when possible.

---

## [P-PRIVACY] Privacy & Sensitive Data

- Always classify data sensitivity:
  - public, internal, confidential, PII, PHI, financial, etc.
- Never log raw sensitive data (PII/PHI/financial).
- Apply least-privilege:
  - only the components that must access sensitive data should see it.
- Document:
  - what data is stored,
  - where it is stored (DB, file, cloud),
  - how long it is retained,
  - how it might be removed or anonymized.

---

## [P-TESTING] Test Pyramid & Quality Assurance

- Follow the test pyramid strategy:
  - **Unit Tests** (many, fast): Test individual LEGOs in isolation with mocked dependencies
  - **Integration Tests** (moderate): Test 2-3 LEGOs working together with real implementations
  - **System Tests** (few, comprehensive): Test complete user journeys E2E
  - **Performance Tests** (targeted): Load, stress, and scalability validation
  
- Test generation priorities:
  - Unit tests: ALWAYS generated during LEGO implementation
  - Integration tests: Generated when `enable_integration_tests: true`
  - System tests: Generated when `enable_system_tests: true`
  
- Test coverage expectations:
  - Unit tests: >80% code coverage per LEGO
  - Integration tests: Cover critical data flows between LEGOs
  - System tests: Cover primary user journeys from `requirements.md`
  
- Contract testing:
  - Define explicit interfaces for LEGOs
  - Generate contract tests to prevent breaking changes
  - Validate that implementations honor contracts
  
- Test execution order:
  1. Unit tests during LEGO validation
  2. Integration tests after subsystem completion
  3. System tests after all LEGOs done
  4. Performance tests (if enabled) in final stage

---

## [P-CONFIG] Configuration Validation & Fail-Fast

- **Every application MUST validate configuration before attempting to run**
  - Check all required environment variables exist and are non-empty
  - Test connectivity to external services (databases, APIs, message queues)
  - Validate API keys with lightweight test calls
  - Check configuration file syntax (JSON, YAML, TOML)
  
- **Fail fast with actionable guidance**:
  - Don't start if configuration is invalid
  - Provide clear, specific error messages ("Missing DATABASE_URL")
  - Include remediation steps ("Run: docker-compose up -d postgres")
  - Link to documentation or service signup pages
  
- **Guided setup for first-time users**:
  - Every application MUST include a `--setup-wizard` command
  - Wizard should interactively collect all required configuration
  - Generate `.env` file, start services, validate connectivity
  - Confirm everything works before completing
  
- **Configuration LEGO (always generated)**:
  - The meta-orchestrator MUST always generate a `config_validator` LEGO
  - This LEGO validates all configuration from other LEGOs
  - Has highest priority (runs before other LEGOs can execute)
  - Is a dependency for all implementation LEGOs
  
- **Layered validation (comprehensive, not superficial)**:
  - **Level 1: Dependencies Installed**
    - Verify all runtime dependencies are present (language version, libraries, system tools)
    - Check all development dependencies (test frameworks, linters, build tools)
    - Validate version compatibility (e.g., Python 3.9+, Node 18+)
  - **Level 2: Configuration Values Present & Well-Formed**
    - Environment variables exist and are non-empty
    - Configuration files are valid (parseable JSON/YAML/TOML)
    - URLs are well-formed, ports are valid integers, etc.
  - **Level 3: External Services Reachable & Authenticated**
    - Database connections succeed (network + credentials)
    - API keys are valid (test with lightweight API call)
    - External service URLs are reachable (HTTP 200/401, not 404/500)
    - OAuth flows work end-to-end (if applicable)
  - **Level 4: End-to-End Workflows Function**
    - Test accounts exist for auth testing (create if needed)
    - Write → Read roundtrip works (database, cache, external API)
    - Permissions are correct (can perform expected operations)
    - Integration between services works (e.g., auth + database + API)
  
- **Validation must be testable**:
  - Unit tests: Mock external services, test validation logic
  - Integration tests: Use test databases/APIs, validate L1-L3
  - System/E2E tests: Use real external services (staging), validate L4
  - Config tests MUST cover:
    - Missing env vars detected and reported clearly
    - Invalid values rejected with actionable errors
    - Setup wizard generates working configuration
    - Health checks reflect actual operational status
  
- **Health checks for operations**:
  - Web apps: Expose `/health` endpoint validating configuration
  - CLI apps: Support `--validate-config` command
  - Include status of all external dependencies in health response
  
- **E2E testing of configuration flows**:
  - System tests MUST validate that missing config is detected
  - System tests MUST validate that invalid config is detected
  - System tests MUST validate that setup wizard generates working config
  - System tests MUST validate that health checks reflect actual status
  
- **Documentation (auto-generated)**:
  - Every app generates `CONFIGURATION.md` with:
    - Required environment variables (table with descriptions)
    - External service requirements (setup instructions)
    - Test account creation guide (for auth/authz testing)
    - Troubleshooting guide (common errors and fixes)
    - First-time setup workflow

**Rationale**: Configuration errors are the #1 cause of "it doesn't work" issues. Multi-layered validation (dependencies → values → connectivity → workflows) with comprehensive testing eliminates this entire class of problems.

---

## [P-AGENT] LLM/Agent/MCP Usage

- Use LLMs/agents when:
  - reasoning about unstructured input,
  - dealing with ambiguous requirements,
  - orchestrating multi-step workflows,
  - applying heuristics or fuzzy logic.
- Avoid LLMs/agents for simple, deterministic logic that can be implemented with normal code.
- When using agents, hide them behind clear, typed interfaces (e.g., “analysis” or “explanation” functions).
- Be cost-aware:
  - prefer simpler models or fewer calls where possible,
  - use more expensive models only where they add clear value.

---

## [P-CODE] Code Quality

- Write small, idiomatic, readable functions and modules.
- Keep logical complexity and nesting low.
- Validate inputs at module boundaries (e.g., user input, API responses).
- Fail early with clear, actionable error messages.
- Avoid clever tricks and unnecessary indirection.
- Avoid premature optimization; optimize only when needed and document why.

---

## [P-TEST] Test Engineering

- Tests must encode observable behavior, not internal implementation details.
- Cover:
  - happy paths,
  - edge cases,
  - error handling,
  - regression tests for fixed bugs.
- Each LEGO should be testable in isolation with mocks/stubs for its dependencies.
- Prefer fast, deterministic tests that can run often.

---

## [P-DOC-INT] Internal Documentation

- Document *why* decisions are made, not just *what* the code does.
- Record trade-offs and alternative designs considered.
- Keep internal docs close to code (e.g., `internal-notes.md`, per-lego notes).
- Keep docs short and scannable, but meaningful.

---

## [P-DOC-PUB] Public Documentation

- Focus on clarity and usability for end users or integrators.
- Provide a quickstart section with simple usage examples.
- Avoid internal jargon.
- Highlight main features and usage flows.

---

## [P-SUPPORT] Operability & Support

- Provide basic observability when appropriate:
  - logs (without leaking sensitive data),
  - simple health checks,
  - basic metrics if justified.
- Ensure error messages are understandable and suggest next actions.

---

## [P-SAFETY] Safety Valves

- Track `failure_count` for steps and LEGO substeps.
- If a step fails repeatedly (e.g., 3 times) or pipeline progress stalls:
  - Mark the relevant step/lego as stuck.
  - Write `meta_error.md` explaining:
    - which step/lego failed,
    - what was attempted,
    - what the user should do next.
  - Stop retrying indefinitely; bail out gracefully.

---

## [P-R&D] Red-Team & Evaluation

- For legos that handle sensitive data or security-critical behavior:
  - Perform a REDTEAM REVIEW substep:
    - Look for privacy leaks and misuse paths.
    - Document findings and proposed mitigations.
- Each LEGO should define an evaluation harness:
  - tests, metrics, and qualitative criteria for success.
- Maintain per-LEGO evaluation notes (e.g., `notes_<lego>.md`).

---

## [P-CONFIG] R&D Modes & Approval Flags

- Honor `meta_config.json`:
  - `"r_and_d_mode"`:
    - `"fast"`: minimal GEN+REVIEW cycles, basic eval, limited red-team.
    - `"thorough"`: extensive GEN+REVIEW, robust eval harness, mandatory red-team for sensitive legos.
  - `"require_lego_plan_approval"`:
    - `true`: pause after LEGO plan & high-level design for human approval.
    - `false`: proceed automatically.

These principles are binding on all Codex sessions orchestrated within this repository.
