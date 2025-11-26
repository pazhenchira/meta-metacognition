# Meta-Orchestrator Changelog

All notable changes to the meta-orchestrator system are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), with versions in reverse chronological order (newest first).

---

## [1.7.1] - 2025-11-26 (Copilot Custom Agent Mode)

### Added

**Copilot Custom Agent Mode Configuration** (`.github/copilot-instructions.md`):
- Tells GitHub Copilot to recognize `AGENTS.md` as custom agent mode
- Activation phrases: `@workspace Act as meta-orchestrator maintenance agent`, `@workspace /agents`
- Agent maintains identity across turns (no more "waiting for confirmation" after each response)
- Reads `AGENTS.md`, `.meta/principles.md`, `.meta/wisdom/` automatically on every turn
- Makes autonomous decisions (only asks WHAT to build, not HOW)

**Documentation Update** (README.md):
- Added "Using the Custom Agent Mode" section
- Explains activation phrases and key benefits
- Updated Quick Commands Cheat Sheet with custom agent examples
- Clarified v1.7.0 conversational maintenance workflow

### Why This Matters

**Problem**: In standard Copilot chat, agent loses identity after every turn. Users had to repeatedly say "keep going" or "proceed" because agent kept asking "should I continue?"

**Root Cause**: Without `.github/copilot-instructions.md`, Copilot doesn't remember it's acting as the meta-orchestrator maintenance agent.

**Solution**: `.github/copilot-instructions.md` tells Copilot to:
1. Read `AGENTS.md` on every turn
2. Reaffirm role and authority
3. Apply wisdom autonomously
4. Make decisions without constant user approval

**Benefits**:
- Persistent identity: Agent remembers role across turns
- Autonomous execution: Makes technical decisions without asking "how should I proceed?"
- Context-aware: Reads principles, wisdom, patterns automatically
- Better UX: Users focus on WHAT to build, agent handles HOW

**Impact**:
- Eliminates friction in maintenance workflows
- Agent acts like true "virtual CTO" (makes decisions, doesn't ask permission for technical choices)
- Same pattern can be applied to apps built by meta-orchestrator (add `.github/copilot-instructions.md` to generated apps)

### Files Modified

- `.github/copilot-instructions.md` (new): Custom agent configuration
- `README.md`: Added custom agent mode documentation and updated Quick Commands Cheat Sheet

---

## [1.7.0] - 2025-11-25 (Conversational Maintenance Mode)

### Added

**Conversational MAINTENANCE Mode** (Section 0 in `.meta/AGENTS.md`):
- Two-path maintenance workflow: **Path A (conversational)** and **Path B (manual edit)**
- **Path A - Natural UX**: User asks "Add feature X" in chat, orchestrator handles app_intent.md updates
  - Orchestrator asks 2-3 clarifying questions
  - Distills conversation into clear feature description
  - Proposes app_intent.md update with diff preview
  - Gets user approval before writing (y/n gate)
  - Logs conversation rationale in APP_ORCHESTRATION.md
  - Proceeds to requirements discovery
- **Path B - Power User**: User manually edits app_intent.md first (existing workflow)
  - Orchestrator detects change via git diff
  - Skips clarifying questions (user already specified intent)
  - Proceeds directly to requirements discovery
- Both paths converge at requirements discovery (Section 4)
- Approval gate prevents orchestrator from misinterpreting user intent
- Living documentation: app_intent.md stays synchronized with actual features

**Template Update** (`.meta/templates/AGENTS.template.md`):
- App-specific orchestrators inherit conversational MAINTENANCE workflow
- Same dual-path structure (Path A conversational, Path B manual)
- Approval gates for app_intent.md updates
- Conversation logging in APP_ORCHESTRATION.md

### Why This Matters

**Problem**: Previous workflow required users to manually edit app_intent.md before asking for features, breaking conversational flow and creating friction.

**Solution**: Orchestrator now maintains app_intent.md as living documentation, updating it after clarifying conversation with approval gate.

**Benefits**:
- Natural UX: "Add Bitcoin trading" → orchestrator asks questions → proposes update → user approves
- Captures context: Clarifying Q&A distilled into precise feature descriptions
- Better descriptions: Orchestrator applies wisdom (technical precision, KISS, domain metrics)
- Living documentation: app_intent.md reflects current state, not outdated spec
- Still safe: Approval gate prevents mistakes, user reviews before writing
- Backward compatible: Manual editing (Path B) still works for power users

**Impact**:
- Conversational feature additions (like talking to developer)
- Reduced friction (no file editing interruption)
- Higher quality intent descriptions (AI-written with wisdom)
- app_intent.md becomes source of truth maintained by orchestrator

---

## [1.6.1] - 2025-11-25 (Dogfooding Bugfix)

### Fixed

**app_intent.md Alignment**:
- Corrected `app_intent.md` to describe meta-orchestrator (not OptionsTrader example)
- Was: Placeholder template with stock trading example
- Now: Actual meta-orchestrator intent (build apps from plain English using 50+ years wisdom)
- Documented unique architecture: Source = `.meta/` AI prompts (Markdown), not traditional code
- Aligned success criteria with `essence.md`: KISS compliance, zero antipatterns, >80% coverage
- Recognized paradigm shift: "Deployment" = copy `.meta/` folder, "Tests" = build sample apps
- Why this matters: Dogfooding principle requires engine to describe itself correctly
- Impact: Future AI agents understand this is a prompt-based orchestration engine, not typical code

**`.meta-manifest.json` Description**:
- Updated `app_intent.md` description from "Example app intent template" to "Meta-orchestrator's actual intent"
- Prevents confusion about whether file is example or actual

### Context

This fixes a violation of the dogfooding principle introduced during initial repository setup. The meta-orchestrator's own `app_intent.md` should follow the same structure it enforces for generated apps: describe the actual app being built, not provide a placeholder example.

---

## [1.6.0] - 2025-11-25 (Stateless Runtime Support & Role Persistence)

### Added

**Pre-flight Checklist** (Section 0 in `.meta/AGENTS.md`):
- Mandatory 5-step checklist executed BEFORE any work on every turn
- Fixes agent amnesia in stateless runtimes (GitHub Copilot Chat)
- Checklist steps:
  1. Check pipeline/app state (orchestrator_state.json, .meta-version, .meta-manifest.json)
  2. Reaffirm role (META-ORCHESTRATOR or APP-SPECIFIC ORCHESTRATOR)
  3. Reaffirm authority (make decisions autonomously using wisdom)
  4. Reaffirm knowledge sources (.meta/principles.md, wisdom/, patterns/)
  5. Determine next action (resume from state, not restart)
- Prevents "how should I proceed?" questions mid-pipeline
- Forces explicit role/state verification on every invocation

**App-Specific AGENTS.md Template** (`.meta/templates/AGENTS.template.md`):
- Complete template for generated app orchestrators
- Includes Pre-flight Checklist for app maintenance mode
- Structured sections: Application Context, Essence, User Journey, LEGO Architecture, Wisdom Applied, etc.
- Ensures app orchestrators maintain identity during multi-turn feature additions/bug fixes
- Template used by Section 11.2 when generating app-specific AGENTS.md

**Meta-Orchestrator Self-Maintenance** (`AGENTS.md` in root):
- Dogfooding: Engine's own maintenance agent using same template structure
- Documents engine architecture as LEGOs (Version Control, Essence Discovery, LEGO Planning, etc.)
- Identifies core value LEGOs (Intuition System, Session Isolation, AGENTS.md Generation)
- Maintenance workflow for improving engine using its own principles
- Enables autonomous engine improvements following KISS + wisdom

### Changed

**Section 11.2 Enhancement** (`.meta/AGENTS.md`):
- Now instructs to use `.meta/templates/AGENTS.template.md` as base
- Ensures consistency across all generated app orchestrators
- Documents that template includes Pre-flight Checklist for amnesia prevention

### Why This Matters

**Problem**: GitHub Copilot Chat agents are stateless - they forget their role between turns in the same conversation, leading to "how should I proceed?" questions even mid-pipeline.

**Solution**: Explicit Pre-flight Checklist forces role/state verification every turn, compensating for stateless runtime behavior.

**Impact**: 
- Meta-orchestrator maintains identity during multi-turn app generation
- App orchestrators maintain identity during multi-turn maintenance
- Works in both stateful (Codex CLI) and stateless (GitHub Copilot Chat) runtimes
- Applies KISS principle: simple explicit checklist vs complex state management

---

## [1.5.0] - 2025-11-25 (Phase 1.8: Product-Market Fit & User Experience Focus)

### Added

**Essence & Value Proposition Discovery** (Section 4.3):
- New step after requirements/dependencies to discover WHY the app exists
- Creates `essence.md` documenting:
  - Problem statement (what problem, who has it, why it matters)
  - Unique value proposition (competitive differentiation, core value)
  - Competitive landscape (existing solutions, strengths, weaknesses)
  - Success metrics (domain-specific: Sharpe ratio, p99 latency, time-to-value, etc.)
  - User journey (discovery → first value → core workflow → ongoing → edge cases)
- **CRITICAL**: Stops if UVP weak or success metrics vague

**Essence-Driven LEGO Prioritization** (Section 5 enhancement):
- Three-tier priority system:
  - **Tier 1: Core Value LEGOs** - deliver essence FIRST (e.g., signal_generator for trading)
  - **Tier 2: Supporting LEGOs** - enable core value (e.g., data_fetcher, calculator)
  - **Tier 3: Config Validation** - always first to implement
- New `lego_plan.json` fields:
  - `priority_tier`: `core_value` | `supporting` | `config_validation`
  - `essence_metric`: which metric from essence.md this LEGO impacts
- Implementation order tied to essence delivery (config → core value → supporting → tests)

**End-to-End Experience Validation** (Section 11.1):
- Validates complete user journey BEFORE declaring app complete
- Assessment phases:
  - Getting started (time to first value, config validation, friction points)
  - Core workflow (delivers UVP?, success metrics measurable?)
  - Failure modes (graceful degradation, recovery, circuit breakers)
  - Continuous improvement (monitoring, benchmarking, feedback collection)
- Creates `experience_validation.md` documenting test results vs targets
- **CRITICAL**: Stops if core value delivery cannot be validated or metrics fall short

**Domain-Specific Success Metrics** (in Section 4.3):
- Performance/Scale apps: p99 latency, throughput (ops/sec, GB/sec), cost per operation
- Simplicity/Experience apps: Time-to-first-value, cognitive load, user retention
- Data/Analytics apps: Query latency, data freshness, insight accuracy
- Financial/Trading apps: Sharpe ratio, win rate, max drawdown
- Developer Tools: LOC to achieve task, build/deploy time

**Enhanced App-Specific AGENTS.md Generation** (Section 11.2):
- Generated AGENTS.md now includes:
  - Essence & Value Proposition (from essence.md)
  - User Journey (complete experience map)
  - Core Value LEGOs (which LEGOs deliver essence, why prioritized)

### Changed

- **Section 5 header**: "LEGO DISCOVERY (KISS-DRIVEN)" → "LEGO DISCOVERY (KISS-DRIVEN, ESSENCE-FIRST)"
- **Section 11 restructure**: "DOCUMENTATION & FINAL REVIEW" → "END-TO-END EXPERIENCE VALIDATION & DOCUMENTATION"
  - Section 11.1: Experience Validation (new)
  - Section 11.2: Final Documentation (enhanced)
- **Pipeline sequence**: Now essence.md → requirements.md → dependencies.md → LEGO discovery

### Philosophy Shift

**From "Build it right"** → **"Build the right thing"**:
- Previously: Focus on engineering quality (tests, architecture, patterns)
- Now: Validate problem-solution fit BEFORE coding, prioritize essence delivery, measure success against domain-specific metrics

### Files Generated (by apps using v1.5.0)

- `essence.md` - Problem, UVP, competitive landscape, success metrics, user journey
- `experience_validation.md` - End-to-end UX validation results

### Impact

Apps built with v1.5.0 will:
1. Explicitly validate they solve the RIGHT problem (not just solve it right)
2. Prioritize core value LEGOs over supporting infrastructure
3. Have measurable, domain-specific success criteria
4. Validate end-to-end user experience before declaring complete
5. Include essence/UVP/journey in app-specific AGENTS.md

---

## [1.4.0] - 2025-11-24 (Phase 1.7: Intelligent Maintenance Mode)

### Added

**Intelligent Maintenance Mode** (Section 0 enhancement):
- **File-by-File Evaluation** when app_intent.md changes:
  - Files with `user_modified: true` → PROTECTED (never touch)
  - Files with `user_modified: false` → EVALUATE using:
    - Phase 1.5 wisdom/intuition (antipattern detection, LEGO principles)
    - Quality metrics (test coverage >80%, error handling, security)
    - Confidence scoring (domain knowledge, requirements clarity, risk level, precedent match)
  - **Decision per file**: KEEP (well-structured) | REFACTOR (fixable issues) | REGENERATE (severe antipatterns)
- **Evaluation report in APP_ORCHESTRATION.md** documenting:
  - What was found (architecture, antipatterns, quality)
  - What decision was made per file (KEEP/REFACTOR/REGENERATE)
  - Why (cite wisdom principles, antipatterns avoided, trade-offs)
- Human approval of evaluation plan before execution

**Intelligent Upgrade Evaluation** (Section 0 enhancement):
- **File-by-File Assessment** when VERSION changes but app_intent.md unchanged:
  - Files with `user_modified: true` → PROTECTED
  - Files with `user_modified: false` → EVALUATE:
    - Apply new wisdom capabilities (e.g., intuition system in v1.2.0)
    - Check if file benefits from new meta-orchestrator features
  - **Decision per file**: KEEP (no new features needed) | ENHANCE (add features without breaking) | REGENERATE (rebuild with new patterns)
- **Upgrade plan in APP_ORCHESTRATION.md** showing:
  - New meta-orchestrator features available
  - Current architecture evaluation (antipatterns, quality, test coverage)
  - Which files will be kept/enhanced/regenerated and why
  - Which new LEGOs will be added
- Human approval before applying upgrade

**Evaluation Framework** (new Section 0 subsection):
- **Systematic Criteria**:
  - Antipattern detection (God Object, Golden Hammer, Magic Numbers, Premature Optimization, Copy-Paste)
  - LEGO principles (Thompson #5, Single Responsibility, KISS, Interface Clarity)
  - Quality metrics (test coverage, error handling, documentation, security)
  - Confidence scoring (0.0-1.0 based on domain knowledge, requirements clarity, risk level, precedent match)
- **Decision Matrix**:
  - KEEP (score >0.8, no antipatterns)
  - REFACTOR (score 0.5-0.8, minor issues, modify incrementally)
  - REGENERATE (score <0.5, severe antipatterns, rebuild from scratch)

**App-Specific AGENTS.md Generation** (Section 11 enhancement):
- Meta-orchestrator now generates **app-specific** `AGENTS.md` (root) for future AI-assisted development
- Content includes:
  - Application Context (purpose, domain, key features)
  - LEGO Architecture (breakdown with rationale citing Thompson #5, KISS)
  - Wisdom Applied (which principles guided design decisions)
  - Antipatterns Avoided (what mistakes were prevented)
  - Success Patterns Used (Circuit Breaker, Config Validator, etc.)
  - Trade-offs Resolved (key decisions and alternatives)
  - Development Guidelines (domain-specific constraints, coding standards)
  - Common Tasks (guide for future changes)
  - References to `.meta/AGENTS.md` (orchestration engine), `.meta/principles.md`, `.meta/wisdom/`, `.meta/patterns/`
- Makes apps **self-documenting** for AI-assisted development

### Changed

- **Section 0 (Version Check)**: Expanded with MAINTENANCE MODE (app_intent.md changed) and ENGINE UPGRADE MODE (VERSION changed)
- **Section 11 (Documentation)**: Enhanced to generate comprehensive app-specific AGENTS.md
- **.meta-manifest.json**: Now includes `user_modified` flag for all generated files (default: false)

### Philosophy

**From reactive fixes** → **wisdom-driven evaluation**:
- Don't blindly regenerate all files when requirements change
- Apply systematic evaluation using intuition/wisdom from Phase 1.5
- Make transparent, justified decisions (KEEP/REFACTOR/REGENERATE)
- Protect user-modified files (respect human customization)
- Document reasoning in APP_ORCHESTRATION.md for human review

### Impact

Apps using v1.4.0 can:
1. Safely evolve when requirements change (intelligent maintenance)
2. Adopt new meta-orchestrator features without breaking (intelligent upgrade)
3. Have transparent, wisdom-driven file-by-file decisions
4. Self-document architecture and wisdom for future AI-assisted development
5. Protect user customizations (user_modified: true files never touched)

---

## [1.3.0] - 2025-11-24 (Phase 1.6: App-Specific Orchestration Documentation)

### Added

**APP_ORCHESTRATION.md** - App-specific orchestration plan:
- Generated after `lego_plan.json` in Section 6
- Uses `.app_orchestration.template.md` as structure
- Documents for THIS specific app:
  - Application overview (from app_intent.md and requirements.md)
  - LEGO architecture breakdown (from lego_plan.json)
  - Session execution plan (dependency graph, parallel groups)
  - Risk & confidence assessment (from LEGO confidence scores)
  - Wisdom & patterns applied (from intuition checks)
  - Testing strategy (unit, integration, system)
  - Documentation plan
  - Success criteria
- **Status tracking**: [IN_PROGRESS] during execution, [COMPLETE] when all LEGOs validated
- **Human-readable**: Clear, transparent orchestration decisions for this app

**.app_orchestration.template.md** - Template for app-specific orchestration:
- Standard structure for all apps
- Sections: Overview, LEGO Architecture, Execution Plan, Risk Assessment, Wisdom Applied, Testing, Documentation, Success Criteria, Execution Log, Final Approval

### Changed

- **Section 6**: Now generates APP_ORCHESTRATION.md and optionally pauses for human approval
- **Section 11**: Finalizes APP_ORCHESTRATION.md status to [COMPLETE] and includes in manifest

### Key Distinction

**Before Phase 1.6**:
- `AGENTS.md` in `.meta/` was universal (same for all apps)
- No app-specific orchestration documentation
- `lego_plan.json` was machine-readable only

**After Phase 1.6**:
- `.meta/AGENTS.md` remains universal (how to orchestrate ANY app)
- `APP_ORCHESTRATION.md` is app-specific (orchestration plan for THIS app)
- Human-readable record of architecture decisions, wisdom applied, risks assessed

### Philosophy

**Transparency & Auditability**:
- Users can review orchestration plan before execution
- Permanent record of why LEGOs were designed this way
- Documents wisdom principles and patterns applied
- Facilitates understanding and debugging

---

## [1.2.0] - 2025-11-24 (Phase 1.5: Intuition & Wisdom System)

### Added

**Wisdom Library** (~24,000 lines, 4 files in `.meta/wisdom/`):

1. **`engineering_wisdom.md`** (~3000 lines):
   - 15 principles from 14 legendary engineers
   - Sources: Kernighan, Knuth, Dijkstra, Pike, Thompson, Kay, Torvalds, Hoare, Brooks, Parnas, Bentley, Liskov, Wirth, Carmack
   - Key triggers:
     - #1: Debugging harder than writing (keep code simple)
     - #2: Premature optimization is evil (profile first)
     - #5: Do one thing well (Thompson's Unix Philosophy)
     - #10: Data structure choice matters most (Pike)
   - Applied during: DESIGN, CODING

2. **`strategic_wisdom.md`** (~4000 lines):
   - 15 principles from 6 strategic thinkers
   - Sources: Sun Tzu, Boyd (OODA Loop), Clausewitz, Taleb (Antifragile, Black Swan, Skin in the Game), Kahneman, Eisenhower
   - Key concepts:
     - #2: OODA Loop (Observe, Orient, Decide, Act)
     - #4: Antifragility (systems that gain from stress)
     - #5: Barbell Strategy (conservative + bold, avoid middle)
     - #10: Via Negativa (subtract, don't add)
   - Applied during: DESIGN, high-level architecture

3. **`design_wisdom.md`** (~3700 lines):
   - 8 principle groups from 3 design masters
   - Sources: Dieter Rams (10 Principles of Good Design), Christopher Alexander (Pattern Language), Don Norman (Design of Everyday Things)
   - Key principles:
     - Rams: "Good design is as little design as possible"
     - Alexander: "Living structure" through patterns
     - Norman: Affordances and signifiers
   - Applied during: DESIGN, interface design

4. **`risk_wisdom.md`** (~3500 lines):
   - Security principles from 2 cryptography/security experts
   - Sources: Bruce Schneier (security mindset), Saltzer & Schroeder (8 security principles)
   - Key concepts:
     - Schneier: Assume breach, defense in depth
     - Saltzer & Schroeder: Least privilege, fail-safe defaults, psychological acceptability
   - Applied during: VALIDATION (sensitive LEGOs)

**Patterns Library** (~9,500 lines, 3 files in `.meta/patterns/`):

1. **`antipatterns.md`** (~3500 lines):
   - 15 common antipatterns with detection rules
   - God Object, Golden Hammer, Spaghetti Code, Magic Numbers, Copy-Paste Programming, Premature Optimization, Not Invented Here, Analysis Paralysis, Cargo Cult Programming, Reinventing the Wheel, Feature Creep, Big Ball of Mud, Lava Flow, Boat Anchor, Dead Code
   - Each includes: definition, why harmful, how to detect, how to avoid
   - Applied during: DESIGN, REVIEW, CODING

2. **`success_patterns.md`** (~3000 lines):
   - 15 proven patterns for robust systems
   - Circuit Breaker, Retry with Exponential Backoff, Bulkhead, Cache-Aside, CQRS, Event Sourcing, Saga, Strangler Fig, Anti-Corruption Layer, Gateway Aggregation, Config Validator, Health Check, Rate Limiting, Idempotency, Dead Letter Queue
   - Each includes: when to use, benefits, implementation notes, trade-offs
   - Applied during: DESIGN

3. **`trade_off_matrix.md`** (~3000 lines):
   - 15 common trade-offs with decision guidance
   - Simplicity vs Power, Performance vs Maintainability, Consistency vs Availability, Security vs Usability, Time-to-Market vs Quality, Flexibility vs Simplicity, Latency vs Throughput, Centralization vs Decentralization, Build vs Buy, Monolith vs Microservices, SQL vs NoSQL, Sync vs Async, Pull vs Push, Optimistic vs Pessimistic Locking, Normalization vs Denormalization
   - Each includes: trade-off description, when to favor each side, decision factors, red flags
   - Applied during: DESIGN

**Intuition Integration** ([P-INTUITION] in .meta/principles.md):
- LEGO-Orchestrators MUST consult wisdom files during DESIGN, CODING, VALIDATION
- Confidence scoring (0.0-1.0) based on:
  - Domain knowledge (how well code matches domain best practices)
  - Requirements clarity (clear need from app_intent.md)
  - Risk level (critical data/security vs low UI formatting)
  - Precedent match (similar to success patterns)
- `lego_state_<name>.json` includes intuition_check:
  - `wisdom_applied`: which principles were used
  - `antipatterns_avoided`: which mistakes were prevented
  - `trade_offs_resolved`: which decisions were made and how

### Changed

- **Section 8 (LEGO-Orchestrator Sessions)**: Enhanced with wisdom consultation steps
  - DESIGN: Check success_patterns.md, use trade_off_matrix.md, apply engineering/design wisdom, check antipatterns.md
  - CODING: Apply engineering wisdom triggers (complexity, optimization, readability)
  - VALIDATION: Apply risk_wisdom.md for sensitive LEGOs
- **`lego_state_<name>.json` format**: Added confidence_score, confidence_factors, intuition_check

### Philosophy

**From heuristics** → **wisdom-driven decisions**:
- Don't rely on generic "best practices"
- Consult battle-tested principles from 20+ legendary figures
- Recognize and avoid known antipatterns
- Apply proven success patterns
- Use decision matrices for trade-offs
- Document which wisdom was applied and why

### Impact

LEGOs designed with Phase 1.5 will:
1. Apply 50+ principles from engineering masters
2. Avoid 15 common antipatterns
3. Use 15 proven success patterns
4. Make informed trade-off decisions (15 scenarios)
5. Calculate confidence scores (0.0-1.0)
6. Document intuition checks for transparency

---

## [1.1.0] - 2025-11-24 (Phase 1: Core Capabilities)

### Added

**Session Isolation & Multi-Agent Architecture**:
- `SESSION_ISOLATION.md` - Complete guide on true multi-session architecture
- Session brief templates for each LEGO (isolated context)
- `session_registry.template.json` - Tracking all active sessions
- `session_queue.template.json` - Dependency-based coordination
- Benefits:
  - Build apps with 50+ components without context degradation
  - 60-80% lower token costs (smaller contexts per session)
  - True parallelism (3+ LEGOs built simultaneously)
  - Fault isolation (one LEGO failure doesn't corrupt pipeline)

**Runtime Adapters (Tool Agnosticism)**:
- `agent_runtime.json` - Configuration for different AI platforms
- `runtime_adapters/adapter_interface.md` - Standard interface for all adapters
- `runtime_adapters/codex_cli_adapter.sh` - OpenAI Codex CLI implementation
- `runtime_adapters/copilot_adapter.sh` - GitHub Copilot implementation
- Extensible: Easy to add Claude MCP, custom APIs, etc.
- Benefits:
  - Switch between AI platforms with config change
  - Not locked into one vendor
  - Can use best tool for each task
  - Future-proof architecture

**Testing Strategy**:
- `TESTING_STRATEGY.md` - Complete guide on unit, integration, system, and deployment tests
- **Unit tests**: Per-LEGO (inputs → outputs, edge cases, error paths)
- **Integration tests**: LEGO-to-LEGO interactions (data flow, error propagation)
- **System tests**: End-to-end workflows (user journeys, multi-LEGO flows)
- **Deployment tests**: Real-world constraints (network failures, rate limits)
- Test LEGOs in `lego_plan.json` (type: `integration_test`, `system_test`)

**Config Validation**:
- `CONFIG_VALIDATION.md` - Complete specification for config_validator LEGO
- Always generated first (dependency for all other LEGOs)
- Responsibilities:
  - Validate `.env` variables (presence, format, connectivity)
  - Check external service endpoints (from external_services.md)
  - Guide users through setup (clear error messages, docs links)
  - Run before any other LEGO (pre-flight check)
- Type: `config_validation` in lego_plan.json

**LEGO Architecture**:
- Single-responsibility components (Thompson #5: "Do one thing well")
- Clear inputs/outputs (KISS principle)
- Minimal dependencies (loose coupling)
- lego_plan.json fields: name, type, responsibility, inputs, outputs, assumptions, fundamentals, sensitive, needs_agent, dependencies

### Changed

- **Section 5 (LEGO Discovery)**: Added config_validator LEGO requirement
- **Section 8 (LEGO-Orchestrator Sessions)**: Added TEST AUTHORING substep
- **Section 11 (Documentation)**: Added integration/system test documentation

### Philosophy

**KISS + LEGO Architecture**:
- Keep It Simple, Stupid (don't over-engineer)
- Single responsibility (one job per LEGO)
- Easy to test (isolated components)
- Easy to replace (swap LEGOs without breaking others)

---

## [1.0.0] - 2025-11-23 (Initial Release)

### Added

**Core Meta-Orchestrator**:
- `.meta/AGENTS.md` - Main orchestrator instructions
- `.meta/intent.md` - Meta-level orchestration intent (how the pipeline behaves)
- `.meta/principles.md` - Global design principles (KISS, LEGO, privacy, testing, R&D modes)
- `meta_config.json` - Configuration (require_lego_plan_approval, r_and_d_mode)

**Pipeline Stages**:
1. Environment Preflight (verify shell commands, file operations)
2. Config Load (read meta_config.json or create with defaults)
3. Load Principles & Meta Intent
4. Interactive Requirements Discovery (from app_intent.md)
5. LEGO Discovery (decompose app into single-responsibility components)
6. Pipeline Planning & Global State (orchestrator_state.json)
7. LEGO-Orchestrator Sessions (one per LEGO: DESIGN → CODING → VALIDATION)
8. GEN+REVIEW Pattern (create → critically evaluate → refine)
9. Safety Valves (failure_count tracking, stuck detection)
10. Documentation & Final Review (README, internal-notes, review.md)
11. Restartability (resume from last checkpoint)

**Requirements Discovery**:
- `requirements.md` template with sections: Metadata, Overview, Scope, Functional Requirements, Non-Functional Requirements, Data & Privacy, External Dependencies, Evaluation, Changelog
- `dependencies.md` - Human-readable dependency summary
- `.env.example` - Required environment variables (names only, no secrets)
- `external_services.md` - API/service documentation (free vs paid, rate limits, how to get keys)

**GEN+REVIEW Pattern**:
- GEN: Create initial artifact
- REVIEW: Critically evaluate and refine
- Append REVIEW NOTES section (changes, limitations, TODOs)
- Applied to: requirements, design, tests, docs, implementation

**Safety Valves**:
- Track failure_count for steps and LEGOs
- Mark as "stuck" after 3 failures
- Write meta_error.md with guidance for user
- Avoid infinite retry loops

**Restartability**:
- Read orchestrator_state.json on each run
- Determine READY steps (dependencies satisfied, not stuck)
- Launch only those sessions
- Continue until complete or safety valve triggered

### Philosophy

**Hierarchical Control**:
- Meta-Orchestrator (this file) coordinates the pipeline
- LEGO-Orchestrators (one per component) handle detailed work
- Session hygiene (exit after 3-5 tasks, checkpoint progress)

**File Roles**:
- `intent.md` → HOW the pipeline works (meta-orchestration)
- `app_intent.md` → WHAT to build (application requirements)
- `.meta/principles.md` → Global design constraints (KISS, LEGO, privacy)

**R&D Modes**:
- `fast`: Minimal cycles, lighter evaluation, red-team only for obviously sensitive LEGOs
- `thorough`: More GEN+REVIEW cycles, richer evaluation harnesses, mandatory red-team for sensitive LEGOs

---

## Version Summary

| Version | Date | Phase | Key Feature | Lines Added |
|---------|------|-------|-------------|-------------|
| 1.5.0 | 2025-11-25 | 1.8 | Product-Market Fit & UX Focus | ~300 |
| 1.4.0 | 2025-11-24 | 1.7 | Intelligent Maintenance Mode | ~400 |
| 1.3.0 | 2025-11-24 | 1.6 | App-Specific Orchestration Documentation | ~200 |
| 1.2.0 | 2025-11-24 | 1.5 | Intuition & Wisdom System | ~24,000 |
| 1.1.0 | 2025-11-24 | 1.0 | Core Capabilities (Session Isolation, Testing, Config) | ~3,000 |
| 1.0.0 | 2025-11-23 | Initial | Meta-Orchestrator Foundation | ~1,500 |

---

## Upgrade Path

### From 1.4.0 to 1.5.0

**Breaking Changes**: None

**New Capabilities**:
- Essence & Value Proposition Discovery (ensures app solves RIGHT problem)
- Essence-driven LEGO prioritization (core value first, supporting second)
- End-to-End Experience Validation (validates user journey before declaring complete)
- Domain-specific success metrics (Sharpe ratio, p99 latency, time-to-value, etc.)
- Enhanced app-specific AGENTS.md (includes essence, UVP, user journey)

**Migration**:
1. Read `UPGRADING.md` for detailed workflow
2. Meta-orchestrator will detect version mismatch (1.4.0 vs 1.5.0)
3. Run ENGINE UPGRADE MODE:
   - Generate upgrade plan in APP_ORCHESTRATION.md
   - Show which files benefit from essence-driven approach
   - Get user approval before applying changes
4. Apps will now generate `essence.md` (before coding) and `experience_validation.md` (before completion)

### From 1.3.0 to 1.4.0

**Breaking Changes**: None

**New Capabilities**:
- Intelligent Maintenance Mode (file-by-file evaluation when requirements change)
- Intelligent Upgrade Evaluation (KEEP/ENHANCE/REGENERATE decisions)
- App-specific AGENTS.md generation (self-documenting apps)
- .meta-manifest.json with user_modified flags

**Migration**:
1. Read `UPGRADING.md` for detailed workflow
2. Meta-orchestrator will detect version mismatch (1.3.0 vs 1.4.0)
3. Run ENGINE UPGRADE MODE:
   - Generate upgrade plan in APP_ORCHESTRATION.md
   - Show which files will be kept/enhanced/regenerated
   - Get user approval before applying changes
4. After upgrade, app will have app-specific AGENTS.md in root

### From 1.2.0 to 1.3.0

**Breaking Changes**: None

**New Capabilities**:
- APP_ORCHESTRATION.md for app-specific orchestration plans
- Human-readable record of architecture decisions, wisdom applied, risks assessed

**Migration**:
1. Update `.meta/` directory to version 1.3.0
2. Run meta-orchestrator on existing app
3. It will generate APP_ORCHESTRATION.md for your app
4. Review and approve (if require_lego_plan_approval: true)

### From 1.1.0 to 1.2.0

**Breaking Changes**: None

**New Capabilities**:
- Intuition & Wisdom System (~24,000 lines)
- Consult 50+ principles from 20+ legendary figures
- Recognize 15 antipatterns, apply 15 success patterns
- Use decision matrices for 15 trade-offs
- Confidence scoring for all designs

**Migration**:
1. Update `.meta/` directory to version 1.2.0
2. Add `wisdom/` and `patterns/` directories (7 new files)
3. Existing apps continue to work (no regeneration needed)
4. New LEGOs will use wisdom/intuition system
5. Consider regenerating critical LEGOs to apply wisdom

### From 1.0.0 to 1.1.0

**Breaking Changes**: None

**New Capabilities**:
- Session isolation (60-80% token cost reduction)
- Runtime adapters (switch between AI platforms)
- Integration/system tests (validation beyond unit tests)
- Config validation LEGO (always generated first)

**Migration**:
1. Update `.meta/` directory to version 1.1.0
2. Add `SESSION_ISOLATION.md`, `TESTING_STRATEGY.md`, `CONFIG_VALIDATION.md`
3. Add `runtime_adapters/` directory with adapter files
4. Existing apps continue to work (no changes needed)
5. New apps will include config_validator LEGO and test LEGOs

---

## Contributing

This is a living document. As the meta-orchestrator evolves, update this CHANGELOG with:
- Version number and date
- Phase number and name
- Added/Changed/Deprecated/Removed/Fixed sections
- Philosophy shifts or architectural changes
- Upgrade instructions for existing apps

---

## References

- **Main Documentation**: `AGENTS.md` (meta-orchestrator engine)
- **Principles**: `principles.md` (KISS, LEGO, privacy, testing)
- **Intuition**: `INTUITION.md` (user-facing wisdom system guide)
- **Wisdom Library**: `.meta/wisdom/` (4 files, ~14,000 lines)
- **Patterns Library**: `.meta/patterns/` (3 files, ~9,500 lines)
- **Testing**: `TESTING_STRATEGY.md` (unit, integration, system tests)
- **Config**: `CONFIG_VALIDATION.md` (config_validator LEGO spec)
- **Deployment**: `DEPLOYMENT_GUIDE.md` (production deployment)
- **Upgrading**: `UPGRADING.md` (version migration workflow)
- **App Orchestration**: `.app_orchestration.template.md` (app-specific plan template)
