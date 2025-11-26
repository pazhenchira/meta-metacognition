# Meta-Orchestrator: Internal Architecture Notes

**Generated**: November 25, 2025  
**Purpose**: Technical notes on meta-orchestrator architecture, rationale, and trade-offs

---

## Core Architecture Decisions

### 1. Document-Driven Orchestration (Not Code)

**Decision**: Use Markdown files (.meta/AGENTS.md) for orchestration logic, not Python/JavaScript code.

**Rationale**:
- **Portability**: Works with any LLM runtime (Codex CLI, GitHub Copilot, OpenAI API)
- **Readability**: Humans can read/modify orchestration logic directly
- **Versioning**: Git-friendly (clear diffs, easy merging)
- **Self-documenting**: Logic and documentation are the same file
- **KISS**: No compilation, dependencies, or runtime complexity

**Trade-offs**:
- ❌ No type safety (vs TypeScript orchestrator)
- ❌ No IDE autocomplete (vs code-based system)
- ✅ Maximum flexibility (any LLM can interpret)
- ✅ Zero dependencies (no npm install, pip install)

**Alternatives Considered**:
1. Python orchestrator with LangChain → Rejected: runtime-specific, heavy dependencies
2. TypeScript with Zod schemas → Rejected: requires compilation, Node.js dependency
3. YAML config files → Rejected: not self-documenting, harder to read

---

### 2. File-Based State Management (Not Database)

**Decision**: Use JSON files (orchestrator_state.json, lego_state_*.json) for pipeline state.

**Rationale**:
- **KISS**: No database server, connection management, schema migrations
- **Restartable**: Pipeline can stop/resume without data loss
- **Debuggable**: State visible in file system (cat orchestrator_state.json)
- **Git-friendly**: Can version control state for reproducibility
- **Zero dependencies**: No PostgreSQL, MongoDB, Redis setup

**Trade-offs**:
- ❌ File locking issues (concurrent writes) → Mitigated: sequential pipeline
- ❌ No transactions (vs database ACID) → Mitigated: atomic file writes
- ✅ Dead simple (cat/grep/jq work out of the box)
- ✅ Works anywhere (no cloud dependencies)

**Alternatives Considered**:
1. SQLite database → Rejected: adds dependency, schema complexity
2. Redis for state → Rejected: requires server, network dependency
3. In-memory state → Rejected: not restartable, session-dependent

---

### 3. Session Isolation via Multi-Agent Spawning

**Decision**: Spawn independent agent sessions per LEGO (not single long conversation).

**Rationale**:
- **Context collapse prevention**: Each agent has <10K tokens (vs 100K+ monolithic)
- **Parallelism**: LEGOs can be built concurrently (like real team)
- **Failure isolation**: One LEGO failure doesn't break entire pipeline
- **Thompson #5**: Each agent does one thing (build one LEGO)
- **Scalability**: Can build 50+ component apps without hitting context limits

**Trade-offs**:
- ❌ Overhead: Multiple sessions vs single session → Mitigated: worth it for large apps
- ❌ Context handoff: Session briefs must be complete → Mitigated: templates ensure completeness
- ✅ Scales to arbitrary complexity
- ✅ Matches real-world team structure (CTO → Tech Leads → Engineers)

**Alternatives Considered**:
1. Single long conversation → Rejected: breaks at 20-30 components
2. Thread-based parallelism → Rejected: requires runtime support
3. Message queue (RabbitMQ) → Rejected: too complex for file-based system

---

### 4. Wisdom as First-Class Citizen

**Decision**: 24,000+ lines of curated engineering wisdom in .meta/wisdom/*.md files.

**Rationale**:
- **Quality over speed**: Better to build right than rebuild later
- **Education**: Users learn Thompson #5, KISS, antipatterns
- **Consistency**: Same principles applied across all generated apps
- **Differentiation**: Only system that systematically applies expert knowledge
- **Compound value**: Wisdom accumulates, improves over time

**Trade-offs**:
- ❌ Slower generation: Wisdom processing adds latency → Acceptable: quality > speed
- ❌ Token overhead: Large context windows needed → Mitigated: wisdom loaded selectively
- ✅ Higher quality output (antipatterns prevented)
- ✅ Maintainable apps (not throwaway code)

**Alternatives Considered**:
1. No wisdom, just code generation → Rejected: becomes like ChatGPT
2. Rules engine (formal logic) → Rejected: too rigid, can't handle nuance
3. ML model fine-tuned on wisdom → Rejected: expensive, less transparent

---

### 5. Hierarchical Control Flow (Meta → LEGO → Substep)

**Decision**: Three levels of orchestration (Meta-Orchestrator, LEGO-Orchestrator, Substep).

**Rationale**:
- **Separation of concerns**: Strategy (Meta) vs Tactics (LEGO) vs Execution (Substep)
- **Real-world analogy**: CTO → Tech Lead → Engineer
- **KISS**: Each level has clear, focused responsibility
- **Scalability**: Can add more levels if needed (Squad → Team → Individual)
- **Understandable**: Humans can trace decision flow

**Trade-offs**:
- ❌ More coordination overhead → Mitigated: worth it for clarity
- ❌ Deeper call stack → Acceptable: max 3 levels (not infinite recursion)
- ✅ Clear ownership (who decides what)
- ✅ Easy to debug (trace through hierarchy)

**Alternatives Considered**:
1. Flat orchestration (all LEGOs equal) → Rejected: no prioritization, no strategy
2. Four+ levels → Rejected: diminishing returns, over-engineering
3. Event-driven (publish/subscribe) → Rejected: too complex for file-based system

---

## Key Implementation Patterns

### GEN+REVIEW Cycle

**Pattern**: Every artifact goes through two phases:
1. **GEN**: Create initial draft
2. **REVIEW**: Independent critique, improve, append REVIEW NOTES

**Why**:
- Simulates peer review (catches mistakes early)
- Forces self-reflection (metacognition)
- Improves quality without external review
- Documents what changed (REVIEW NOTES section)

**Applied to**:
- Requirements (requirements.md)
- LEGO designs (design_*.md)
- Tests (test_*.py)
- Documentation (docs/*.md)
- Code (src/*.py)

---

### Safety Valves

**Pattern**: Detect failure modes and bail out gracefully.

**Implementation**:
- `failure_count` in lego_state_*.json (max 3 retries)
- `confidence_score` in evaluation (0.0-1.0, stop if <0.6)
- `essence_clarity` check (stop if UVP unclear)
- `approval_required` gates (user reviews before execution)

**Why**:
- Prevents infinite loops (retry forever)
- Prevents bad output (low confidence → stop)
- Gives user control (approval gates)
- Clear failure messages (not cryptic errors)

---

### Runtime Adapters

**Pattern**: Abstract runtime-specific commands behind adapter interface.

**Implementations**:
- `codex_cli_adapter.sh` → Codex CLI commands
- `copilot_adapter.sh` → GitHub Copilot API
- `openai_adapter.sh` → OpenAI API (future)

**Why**:
- Portability: Same orchestration logic works across runtimes
- KISS: Adapters hide complexity (spawn session, check status, get output)
- Extensibility: Add new runtimes without changing .meta/AGENTS.md

---

## Component Breakdown

### Core Engine (.meta/)

**AGENTS.md** (926 lines):
- 12 phases (0-11) from version check to deployment
- Each phase: inputs, outputs, exit criteria
- Hierarchical orchestration logic
- GEN+REVIEW patterns
- Safety valves

**principles.md** (506 lines):
- P-KISS: Ruthless simplicity
- P-LEGO: Single-responsibility architecture
- P-FLOW: Hierarchical control
- P-SESSIONS: Session hygiene
- P-RESTART: Restartability
- P-GENREVIEW: Critique pattern

**wisdom/** (4 files, ~24,000 lines):
- engineering_wisdom.md: Thompson, Knuth, Pike, Kernighan
- strategic_wisdom.md: Team dynamics, product decisions
- design_wisdom.md: UX principles (Krug, Norman)
- risk_wisdom.md: Security (Schneier, Saltzer & Schroeder)

**patterns/** (3 files):
- antipatterns.md: God Object, Golden Hammer, Copy-Paste, etc.
- success_patterns.md: Circuit Breaker, Config Validator, Retry Logic
- trade_off_matrix.md: Performance vs Simplicity, Security vs UX

**templates/** (7 files):
- AGENTS.template.md: App-specific orchestrator
- .meta-version.template: Version tracking
- .meta-manifest.template.json: File tracking
- .app_orchestration.template.md: Decision record

---

### Runtime Support

**runtime_adapters/** (3 files):
- adapter_interface.md: Contract all adapters must follow
- codex_cli_adapter.sh: Codex CLI implementation
- copilot_adapter.sh: GitHub Copilot implementation

**Purpose**:
- Abstract runtime differences (command syntax, session management)
- Enable same orchestration logic across platforms
- Simplify adding new runtimes

---

### Documentation Hierarchy

**User-facing** (humans learning the system):
- README.md: Approachable introduction ("virtual CTO")
- DEPLOYMENT_GUIDE.md: How to deploy generated apps
- UPGRADING.md: Version migration guide

**Technical** (developers/AI maintaining engine):
- AGENTS.md (root): Self-maintenance instructions
- essence.md: Why engine exists, UVP, metrics
- internal-notes.md: This file (architecture rationale)
- CHANGELOG.md: Version history

**Supplementary** (deep dives):
- SESSION_ISOLATION.md: Multi-agent architecture details
- CONFIG_VALIDATION.md: Configuration validation approach
- TESTING_STRATEGY.md: Testing philosophy
- INTUITION.md: Wisdom system overview

---

## Performance Characteristics

### Time Complexity

**New App (10 LEGOs)**:
- Requirements discovery: ~2-5 minutes (user interview)
- LEGO planning: ~1-3 minutes (decomposition)
- LEGO implementation: ~10-30 minutes (parallel sessions)
- Integration testing: ~2-5 minutes
- **Total**: 15-45 minutes for complete app

**Maintenance (modify 2 LEGOs)**:
- Evaluation: ~1-2 minutes (KEEP/REFACTOR/REGENERATE decisions)
- Implementation: ~5-10 minutes (targeted changes)
- Testing: ~2-5 minutes
- **Total**: 8-17 minutes for feature addition

**Upgrade (add new engine features)**:
- Evaluation: ~2-5 minutes (scan codebase with new wisdom)
- Enhancement: ~5-15 minutes (selective file updates)
- Testing: ~2-5 minutes
- **Total**: 9-25 minutes for engine upgrade

### Space Complexity

**Engine size**: ~50MB (.meta/ directory with wisdom)
**Generated app**: 1-10MB (depends on features)
**State files**: <1MB (JSON state management)

---

## Security Considerations

### Threat Model

**Threats**:
1. Malicious app_intent.md (code injection via prompt)
2. Compromised .meta/ files (altered wisdom → bad advice)
3. State file tampering (orchestrator_state.json manipulation)
4. Sensitive data in generated apps (API keys, passwords)

**Mitigations**:
1. App intent is data, not code (no eval() calls)
2. .meta/ files tracked in git (tamper-evident)
3. State files validated (schema checks on load)
4. Red-team review for sensitive apps (security audit)

### Data Privacy

**User data**:
- app_intent.md may contain business secrets → stays local
- Generated apps may have sensitive logic → user controls where deployed
- No telemetry by default (user privacy first)

**Best practices**:
- Warn users if app_intent.md contains API keys
- Suggest environment variables for secrets
- Generate .gitignore for sensitive files

---

## Failure Modes & Recovery

### Common Failures

1. **Essence unclear**: User's app_intent.md vague
   - Recovery: Ask probing questions, stop if still unclear after 3 attempts

2. **LEGO generation fails**: Code doesn't compile/pass tests
   - Recovery: Retry up to 3 times, mark as failed if still broken

3. **Context overflow**: Too many LEGOs (>50 components)
   - Recovery: Split into sub-apps, hierarchical composition

4. **Runtime unavailable**: Codex CLI down, API rate limit
   - Recovery: Graceful error message, resume when available

5. **User modifies files**: .meta-manifest.json out of sync
   - Recovery: Detect modifications, mark user_modified=true

### Known Limitations

1. **No GUI apps yet**: Focus on CLI/backend (web UI future)
2. **No mobile apps**: iOS/Android not yet supported
3. **English-only**: Wisdom files in English (i18n future)
4. **Single developer**: No multi-user collaboration features
5. **No real-time sync**: File-based state (no distributed locking)

---

## Future Architecture Evolution

### Near-term (v1.7-1.8)

- **Telemetry**: Opt-in metrics collection (success rates, quality scores)
- **GUI support**: Web app generation (React, Vue, Svelte)
- **Mobile support**: React Native, Flutter apps

### Mid-term (v2.0)

- **Multi-language wisdom**: Spanish, Chinese, Hindi translations
- **Distributed orchestration**: Cloud-based parallel execution
- **Team collaboration**: Multiple developers on same app

### Long-term (v3.0)

- **Self-improving wisdom**: Learn from successful apps, update patterns
- **Domain-specific engines**: Finance, Healthcare, IoT specialized variants
- **Formal verification**: Prove correctness of generated code

---

## REVIEW NOTES

**Strengths**:
- Clear rationale for every major decision
- Trade-offs documented (not just benefits)
- Alternatives considered and rejected (shows thinking)
- Performance characteristics quantified
- Security threats identified with mitigations

**Weaknesses**:
- No real performance benchmarks yet (estimates only)
- Security threat model not exhaustively tested
- Failure recovery procedures untested at scale
- Future roadmap speculative (no user feedback yet)

**Assumptions**:
- Document-driven approach scales to large apps
- File-based state sufficient (no need for DB)
- Wisdom files remain manageable size (<100MB)
- Users willing to learn meta-orchestrator concepts
