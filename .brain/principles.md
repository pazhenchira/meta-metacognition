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

## [P-COORD] Coordination Maturity Ladder (System-of-Systems)

- Default to the **lowest coordination** that still preserves correctness and safety.
- Modes (in increasing coordination):
  - **standalone**: single repo, no cross-repo contracts
  - **federated**: explicit contracts + compatibility tests, no ledger
  - **tracked**: light change ledger + dependency graph
  - **governed**: request ledger + handoff packets + cross-repo validation
- Move up **only** when coupling, breakage risk, or organizational complexity requires it.
- **Single source of truth**: system repo holds the full dependency graph; app repos keep only their local slice.
- Prefer **automated compatibility gates** over manual coordination.

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

## [P-FLOW-ANALYSIS] Control Flow & Data Flow Analysis

Every architectural decision must consider BOTH control flow AND data flow.

### Control Flow (Who Decides What Happens)

Analyze and document:
- **Entry Points**: Where does execution begin? (API routes, CLI commands, events)
- **Decision Points**: Where does branching occur? (conditionals, polymorphism)
- **Error Handling**: Where and how are errors caught and handled?
- **Exit Points**: Where does execution terminate? (returns, throws, exits)

Principles for Control Flow:
- Clear ownership: One component owns each decision
- Single entry/single exit: Where practical, simplify paths
- Fail-fast: Validate inputs at boundaries, don't propagate bad state
- No hidden control: Avoid callbacks-within-callbacks, implicit triggers

### Data Flow (What Information Moves Where)

Analyze and document:
- **Sources**: Where does data originate? (user input, APIs, databases)
- **Transformations**: How is data changed? (parsing, validation, enrichment)
- **Sinks**: Where does data end up? (storage, display, external services)

Principles for Data Flow:
- Immutability preferred: Transform, don't mutate
- Clear ownership: One component owns each data type
- No hidden data paths: Avoid global state, implicit caching, side effects
- Validate at boundaries: Never trust external data

### Why Both Matter

A system can have:
- Beautiful control flow + chaotic data flow = **Still a mess** (hard to debug data issues)
- Clean data flow + spaghetti control = **Still a mess** (unpredictable execution)
- Clean both = **Maintainable system**

### When to Apply

- **ALWAYS during DESIGN**: Map both flows before implementation
- **During REVIEW**: Verify flows remain clean after changes
- **When debugging**: Trace both flows to find root cause
- **When adding features**: Ensure new code doesn't pollute existing flows

See `.meta/wisdom/engineering_wisdom.md` #18 for detailed guidance.

---

## [P-SESSIONS] Session Hygiene & Checkpoints

- Avoid huge, long-running Codex sessions with massive conversation history.
- After ~3–5 substantial tasks in a session:
  - Persist progress to JSON/MD files (state and artifacts).
  - End the session intentionally.
  - Expect the next `codex exec` or `codex exec resume` to resume from state.
- All relevant facts and state must be stored in files, not only in conversation context.

---

## [P-REORIENT] Role Re-Orientation Loop

After EVERY command or tool invocation (terminal, MCP, web, etc.):

- Reaffirm your current role in one sentence (e.g., "I am the App Orchestrator for X").
- Re-read the role instructions (AGENTS.md or role file) and this principles file.
- Re-check any required state guards (e.g., `role_lock`, `primary_role`, step readiness).
- If any drift or mismatch is detected, STOP and re-run the pre-flight checklist before continuing.

This applies to Meta-Orchestrator sessions and ALL sub-agents/MCP role sessions.

Rationale: Prevents role drift and incomplete handoffs; aligns with session hygiene and engineering_wisdom.md #1/#14.

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

## [P-MEASURE] Measure Twice, Cut Once (Problem Framing)

Before DESIGN or CODING decisions:

- Restate the problem and desired outcome in plain language.
- List constraints (performance, cost, security, privacy, UX).
- Define acceptance criteria and success metrics for the change.
- List assumptions and unknowns.
- Decide if a second opinion is required.

If ambiguity or risk is high, OR if `r_and_d_mode = "thorough"` for a non-trivial change,
get a second-opinion review (sub-agent or independent review pass) BEFORE implementing.

Rationale: Stepwise refinement and complete understanding before implementation (engineering_wisdom.md #14).

---

## [P-TRIAGE] Bug vs Feature vs Incident Triage

Before any work item proceeds, classify it:

- **Bug**: Deviation from specified or previously working behavior.
  - **PM input** is minimal: user impact, priority, and acceptance criteria for “fixed.”
  - **Do not gate engineering triage** on PM discovery or new specs.
- **Feature / Enhancement**: New capability or behavior change.
  - **PM input is required**: goals, success metrics, scope boundaries, trade-offs.
  - Requires FR/EN specs before design/implementation.
- **Incident**: Operational failure (auth, delivery, integrations, outages).
  - **Route to Ops + Dev first** for containment and recovery.
  - PM is only required for comms and priority, not technical triage.

Rationale: KISS + Thompson #5 — avoid unnecessary role gates and keep response tight for bugs/incidents.

---

## [P-IDENTITY] Role Identity Confirmation

To prevent drift, every role must explicitly confirm identity:

- **First line** of each response states the role (e.g., "Role: App Orchestrator").
- **Final line** confirms alignment (e.g., "Role confirmed.").

Rationale: Reinforces role lock and prevents silent role drift.

---

## [P-DOCS-FIRST] Orchestrator Docs-First Discipline

The App Orchestrator must **consult app documentation and scripts before asking the Sponsor for operational instructions**.

- For **ops/infra tasks** (deploy, logs, access, rollbacks, Git, CI/CD), first read:
  - `docs/dev/README.md`, `DEPLOYMENT_GUIDE.md`, `docs/dev/*`, and `scripts/*`
- If the answer is not found, route to **Operations** (or relevant role) instead of asking the Sponsor.
- The **Sponsor is only asked for product requirements, priorities, and approvals**, not for operational how-to.
- If you catch yourself about to ask the Sponsor for a how-to, STOP and re-run Pre-Flight.

Rationale: Prevent orchestration drift and keep Sponsor input focused on product intent, not process.

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

## [P-E2E] End-to-End Scenario Testing

End-to-end tests validate complete user scenarios with **minimal mock input and zero injected mock data**.

### Philosophy

E2E tests are **canaries for breaks**. They must:
- Use real data flows (no fake data injections)
- Validate business scenarios as users experience them
- Catch integration failures that unit tests miss
- Provide immediate signal when something breaks

### E2E Test Principles

1. **Minimal Mock Input**: 
   - Mock ONLY external service boundaries (APIs, databases connections)
   - Never inject fake data into the middle of a flow
   - Use realistic test fixtures, not synthetic data generators
   - Example: Mock the API client, not the response processing logic

2. **Zero Injected Mock Data**:
   - Data flows through the system as it would in production
   - No bypassing validation, transformation, or business logic
   - If a component needs data, it gets it through normal channels
   - Example: Create real database records, don't mock repository responses

3. **Scenario-Driven**:
   - Each E2E test represents a user story or critical business flow
   - Name tests after the scenario: `test_user_signup_to_first_purchase`
   - Cover both happy paths and critical error scenarios
   - Prioritize scenarios by business impact

4. **Failure Clarity**:
   - When E2E tests fail, the cause must be immediately obvious
   - Include context in assertions (what was expected, what happened)
   - Log key checkpoints during scenario execution
   - Avoid flaky tests (deterministic inputs, stable assertions)

### E2E Test Structure

```python
# tests/e2e/test_trading_scenario.py

def test_options_trading_complete_workflow():
    """
    E2E Scenario: User creates strategy, receives signal, executes trade
    
    This test uses:
    - Real market data (historical fixture, not mocked)
    - Real calculation pipeline (no injection)
    - Real signal generation (no fake signals)
    - Mocked broker API (external boundary only)
    """
    # Arrange: Load real historical data fixture
    market_data = load_fixture("options_chain_2024_01_15.json")
    
    # Act: Run through complete workflow
    strategy = create_strategy(params=DEFAULT_PARAMS)
    signals = generate_signals(strategy, market_data)  # Real calculation
    
    # Assert: Validate business outcomes
    assert len(signals) > 0, "Should generate at least one signal"
    assert all(s.confidence > 0.6 for s in signals), "All signals should meet confidence threshold"
    
    # Verify trade execution (mocked broker, real order logic)
    with mock_broker() as broker:
        execute_trades(signals[:1])
        broker.assert_called_once()
        order = broker.call_args.order
        assert order.symbol == signals[0].symbol
```

### When to Use E2E vs Unit/Integration

| Scenario | Test Type | Mock Level |
|----------|-----------|------------|
| Single function logic | Unit | Mock all dependencies |
| 2-3 LEGOs interaction | Integration | Mock external services |
| Complete user journey | E2E | Mock external boundaries only |
| Critical business flow | E2E | Minimal mocks, real data flows |
| External API behavior | Unit/Integration | Mock responses |
| Database operations | Integration | Real test database |

### E2E Test Requirements

Every application MUST have E2E tests for:
1. **Primary User Journey**: The main value-generating workflow
2. **Onboarding Flow**: First-time user experience
3. **Error Recovery**: What happens when things fail
4. **Data Integrity**: Critical data flows remain consistent

### Anti-Patterns in E2E Testing

❌ **Mocking internal components**: If you mock the service layer, you're not testing E2E
❌ **Injecting fake responses**: Data should flow through real transformations
❌ **Testing implementation details**: E2E tests should validate outcomes, not internals
❌ **Flaky time-dependent tests**: Use deterministic inputs or controlled time
❌ **Testing everything E2E**: Reserve E2E for critical scenarios (expensive to maintain)

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

## [P-DONE] Finish What You Start (Quality & Completion)

If we accept scope, we finish to a complete, production-ready state.
`r_and_d_mode = "fast"` reduces cycles, NOT quality or completeness.

Definition of Done includes (as applicable):
- Functional implementation + tests + docs
- Operations readiness and production deployment (or explicit release equivalent)
- GTM artifacts when GTM roles are available/enabled
- Acceptance criteria and success metrics validated

If any element is not applicable, record the exception and Sponsor approval in APP_ORCHESTRATION.md.

Rationale: "Do one thing and do it well" and completeness before moving on (engineering_wisdom.md #5/#14).

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

---

## [P-INTUITION] Intuition & Judgment (Phase 1.5)

The meta-orchestrator must exercise judgment in ambiguous situations by consulting accumulated wisdom and pattern libraries.

### Wisdom Sources

Consult these files during design and review phases:
- `wisdom/engineering_wisdom.md` - Kernighan, Knuth, Dijkstra, Pike, Kay, Torvalds, etc.
- `wisdom/strategic_wisdom.md` - Sun Tzu, Boyd, Clausewitz, Taleb, Kahneman
- `wisdom/design_wisdom.md` - Dieter Rams, Christopher Alexander, Don Norman
- `wisdom/risk_wisdom.md` - Taleb, Kahneman, Schneier, Saltzer & Schroeder
- `patterns/antipatterns.md` - Common mistakes to avoid
- `patterns/success_patterns.md` - Proven solutions to recurring problems
- `patterns/trade_off_matrix.md` - Decision guidance for common trade-offs

### When to Apply Wisdom

- **REQUIREMENTS Phase**: Strategic wisdom, risk assessment
- **LEGO Discovery**: Engineering wisdom, antipatterns, success patterns
- **DESIGN Phase**: All wisdom categories, trade-off matrix
- **CODING Phase**: Engineering wisdom, design principles
- **REVIEW Phase**: All wisdom, pattern matching, antipattern detection
- **VALIDATION Phase**: Risk wisdom, evaluation criteria

### Decision Framework: Conservative vs Bold

**Be CONSERVATIVE (favor simplicity, proven approaches) when:**
- Data involves PII, financial, health information, or other sensitive data
- User explicitly requests "production-ready" or "enterprise-grade"
- Dependencies are critical (database, authentication, payments, security)
- Failure cost is high (data loss, security breach, compliance violation)
- Long-term maintenance is expected
- Large team will work on this code
- System handles external/untrusted input

**Be BOLD (favor innovation, experimentation) when:**
- User explicitly requests "experimental", "prototype", or "cutting-edge"
- Internal tools or prototypes with low blast radius
- `r_and_d_mode = "fast"` and exploration is the goal
- Failure is recoverable and low-cost (easy rollback, isolated impact)
- Short-term project or MVP
- Small team that can adapt quickly
- Learning opportunity with acceptable risk

### Risk Assessment Matrix

Apply during LEGO discovery and design:

| Risk Level | Characteristics | Required Actions |
|------------|----------------|------------------|
| **CRITICAL** | PII, payments, auth, health data, security-critical | Mandatory red-team review, conservative technology choices, comprehensive tests (unit + integration + system), defense in depth, audit logging, principle of least privilege |
| **HIGH** | Business logic, data integrity, external APIs, user-facing features | Standard GEN+REVIEW cycles, integration tests, error handling, input validation, monitoring |
| **MEDIUM** | UI/UX, formatting, non-critical features, internal tools | Basic unit tests, simple review, standard patterns |
| **LOW** | Logging, internal utilities, dev tools, temporary scaffolding | Minimal review, fast iteration, basic validation |

### Trade-off Resolution Defaults

When facing design choices, use these defaults (consult `patterns/trade_off_matrix.md` for details):

1. **Simplicity vs Power**: Default to **simplicity** (KISS, Dijkstra, Rams)
2. **Speed vs Quality**: If `r_and_d_mode = "fast"`, favor **speed**; if "thorough", favor **quality**
3. **Build vs Buy**: Default to **buy** (use libraries/services, avoid NIH syndrome)
4. **Monolith vs Microservices**: Default to **monolith** (split only when scaling requires it)
5. **SQL vs NoSQL**: Default to **SQL** (Postgres/MySQL) unless specific need for NoSQL
6. **Sync vs Async**: **Sync** for fast ops (< 1s), **async** for slow ops (> 5s)
7. **Conservative vs Bold Tech**: **Conservative** for critical systems (Lindy Effect), **bold** for experiments

### Confidence Scoring

LEGO-orchestrators should track confidence in their design and implementation:

```json
{
  "lego_name": "auth",
  "status": "design",
  "confidence_score": 0.85,
  "confidence_factors": {
    "domain_knowledge": 0.9,
    "requirements_clarity": 0.8,
    "risk_level": "critical",
    "precedent_match": 0.9,
    "team_familiarity": 0.8
  },
  "intuition_check": {
    "wisdom_applied": [
      "Schneier: Defense in depth",
      "Saltzer: Least privilege",
      "Taleb: Fail-safe defaults"
    ],
    "antipatterns_avoided": [
      "Rolling custom crypto",
      "Security through obscurity"
    ],
    "trade_offs_resolved": {
      "jwt_vs_sessions": "sessions (simpler for this scale, stateful is acceptable)"
    }
  }
}
```

**Confidence Score Calculation**:
- Domain knowledge: 0.0-1.0 (how well-understood is this problem domain?)
- Requirements clarity: 0.0-1.0 (how clear are the requirements?)
- Precedent match: 0.0-1.0 (how closely does this match known patterns?)
- Team familiarity: 0.0-1.0 (how familiar is the team with chosen technologies?)

**Overall confidence** = average of factors

**When confidence < 0.6**:
- Flag for additional review
- Consider prototype or spike to reduce uncertainty
- Consult wisdom files more carefully
- If still low confidence, escalate to user for guidance

### Heuristic Triggers

During DESIGN and REVIEW, automatically check for these triggers from wisdom files:

**Engineering (from `wisdom/engineering_wisdom.md`)**:
- Complexity > threshold → Kernighan's Debugging Principle (#1)
- Mentions "optimize" before validation → Knuth's Premature Optimization (#2)
- LEGO with > 3 responsibilities → Thompson's Unix Philosophy (#5)
- Null returns → Hoare's Null Reference (#8)

**Strategic (from `wisdom/strategic_wisdom.md`)**:
- Vague requirements → Sun Tzu's Know Yourself (#1)
- External dependencies → Clausewitz's Friction (#3)
- Critical systems → Taleb's Barbell Strategy (#5)

**Design (from `wisdom/design_wisdom.md`)**:
- New feature → Rams' "Is it useful?" (#1.2)
- Interface design → Norman's Affordances (#4.1)
- Multiple similar operations → Norman's Consistency (#4.7)

**Risk (from `wisdom/risk_wisdom.md`)**:
- Sensitive data → Schneier's Security Mindset (#8)
- Auth/authz → Saltzer's Least Privilege (#9.1)
- External services → Taleb's Antifragile (#6)

### Pattern Matching

During DESIGN and REVIEW:
1. Check if problem matches a success pattern from `patterns/success_patterns.md`
2. Check if design exhibits an antipattern from `patterns/antipatterns.md`
3. If antipattern detected, flag and suggest remedy
4. If success pattern fits, apply it and document the choice

### Intuition Documentation

For each LEGO, document intuition checks in `lego_state_<name>.json`:
- Which wisdom principles were applied
- Which antipatterns were avoided
- Which trade-offs were resolved and why
- Confidence score and factors
- Any concerns or uncertainties

This creates a learning trail for future reference and continuous improvement.

---

## [P-WEB] Online Documentation & Current Information

AI agents work with frozen training data, but software evolves rapidly. For correctness and security, consult current online documentation when needed.

### When to Search Online (Trigger Conditions)

**ALWAYS search online documentation for**:
1. **External APIs** - OpenAI, Anthropic, Azure, AWS, Google, etc.
   - API endpoints change (v1 → v2, deprecations)
   - Authentication methods evolve (API keys → OAuth → custom headers)
   - Rate limits and pricing tiers update frequently
   - New features and parameters added regularly

2. **Package Installation/Upgrades** - Check latest versions and compatibility
   - PyPI (Python): `pip install package-name` → verify latest stable version
   - npm (JavaScript/Node): `npm install package-name` → check for breaking changes
   - NuGet (.NET): Latest package versions and .NET compatibility
   - Security patches and CVE fixes (always use patched versions)

3. **Framework-Specific Patterns** - Frameworks evolve rapidly
   - React: Hooks, Suspense, Server Components (patterns change yearly)
   - FastAPI: Latest async patterns, dependency injection updates
   - Express: Middleware patterns, security best practices
   - Django, Flask, Next.js, Vue, Angular, etc.

4. **Security-Critical Code** - Always validate current best practices
   - Authentication/authorization patterns (JWT, OAuth, session management)
   - Cryptography libraries (algorithms, key sizes, deprecations)
   - CVE databases (check for known vulnerabilities)
   - OWASP Top 10 current guidance

5. **Cloud Service Configuration** - Cloud providers update constantly
   - Azure, AWS, GCP service configurations
   - Deployment patterns and infrastructure-as-code
   - Pricing models and service limits
   - New service features and best practices

### What to Search

**Trusted Official Sources Only**:
- **Official Documentation**:
  - `docs.openai.com`, `docs.anthropic.com` (AI APIs)
  - `docs.python.org`, `nodejs.org/docs` (language docs)
  - `react.dev`, `fastapi.tiangolo.com` (framework docs)
  - `learn.microsoft.com` (Azure/Microsoft)
  - `docs.aws.amazon.com` (AWS)
  
- **Package Registries** (version info, changelogs):
  - `pypi.org` (Python packages)
  - `npmjs.com` (JavaScript packages)
  - `nuget.org` (.NET packages)
  
- **Security Advisories**:
  - CVE databases (cve.mitre.org, nvd.nist.gov)
  - Security bulletins from vendors
  - OWASP documentation (owasp.org)

- **Release Notes & Changelogs**:
  - GitHub releases pages
  - Official blog announcements
  - Migration guides (v1 → v2)

**DO NOT Search** (training data is sufficient):
- Core language features (Python syntax, JavaScript fundamentals, C# basics)
- Fundamental algorithms/data structures (sorting, searching, trees)
- General programming concepts (OOP, functional programming)
- Internal app logic (no web source knows your specific app)

### How to Use Web Information

**During REQUIREMENTS Phase** (Phase 4):
- Search for external service documentation when user mentions APIs
- Validate pricing models and rate limits
- Check authentication requirements

**During DESIGN Phase** (Phase 5-6):
- Verify framework patterns are current
- Check package compatibility matrices
- Validate security best practices

**During CODING Phase** (Phase 7):
- Look up exact API signatures and parameters
- Verify package installation commands
- Check for deprecation warnings

**During REVIEW Phase** (Phase 9):
- Validate that code uses current patterns (not deprecated)
- Check for security vulnerabilities in dependencies
- Verify configuration follows latest best practices

### Documentation in Artifacts

When web research influences design decisions, document in relevant files:

**In `requirements.md`**:
```markdown
## External Dependencies (Researched 2024-01-15)

### OpenAI API (docs.openai.com)
- Current version: v1.52.0
- Authentication: Bearer token in header
- Rate limits: 10,000 RPM (tier 2)
- Pricing: $0.01/1K tokens (GPT-4o mini)
- Source: https://platform.openai.com/docs/api-reference
```

**In `design_<lego>.md`**:
```markdown
## REVIEW NOTES

Web Research:
- Verified FastAPI async patterns (docs: fastapi.tiangolo.com/async/)
- Current best practice: Use `async def` with `await` for I/O-bound operations
- Researched 2024-01-15, FastAPI v0.115.0
```

**In `lego_state_<name>.json`**:
```json
{
  "web_research": {
    "researched_date": "2024-01-15",
    "sources": [
      "https://platform.openai.com/docs/api-reference",
      "https://pypi.org/project/openai/"
    ],
    "key_findings": [
      "OpenAI Python SDK v1.52.0 is latest stable",
      "Async client preferred for production use"
    ]
  }
}
```

### Rationale

**Why This Matters**:
- **Correctness**: Outdated API patterns cause runtime failures
- **Security**: Old cryptographic practices introduce vulnerabilities
- **Efficiency**: Latest packages include performance improvements
- **Maintainability**: Current patterns are better documented and supported

**Aligns With**:
- Thompson #5: "Do one thing well" - building correct apps requires current information
- Knuth #2: Using outdated patterns is a form of premature optimization (avoiding research)
- Schneier #8: Security mindset requires awareness of current threats and mitigations

**Trade-off**:
- Adds ~5-10 minutes per LEGO for research
- Worth it for external dependencies (API correctness is critical)
- Not needed for internal logic (training data is sufficient)

---

## P-VERSIONING: Semantic Versioning for Apps

Every change must update `APP_VERSION`:
- **Patch**: Bug fixes, docs-only changes, internal refactors with no behavior change
- **Minor**: Backwards-compatible features or enhancements
- **Major**: Breaking changes (public API or user-facing behavior changes)

**Rule**: Version bump happens in the same work item as the change.

---

These principles are binding on all Codex sessions orchestrated within this repository.
