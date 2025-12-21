# Application Intent

**👋 START HERE**: This is where you describe what you want to build.

The meta-orchestrator will read this file, ask clarifying questions, and build your complete app.

---

## What Do You Want To Build?

**Meta-Orchestrator**: A meta-cognitive orchestration engine that builds complete, production-ready 
applications from plain English descriptions.

**Problem**: Most AI coding tools (ChatGPT, GitHub Copilot, Claude) generate code snippets but fail 
at complete applications. They lack systematic application of engineering best practices, can't 
handle complex multi-component systems, and don't validate that apps actually deliver promised value.

**Solution**: An orchestration engine that:
- Applies 50+ years of engineering wisdom systematically (Thompson, Knuth, Pike, Kernighan, Schneier)
- Decomposes complex apps into single-responsibility LEGO components
- Validates apps deliver their essence through end-to-end experience testing
- Generates self-documenting apps with AGENTS.md for future AI-assisted maintenance
- Supports intelligent maintenance (KEEP/REFACTOR/REGENERATE) and version upgrades
- Prevents context collapse via session isolation (can build 50+ component apps)

**Unique Architecture**: The "source code" is a set of AI agent prompts (Markdown files) in `.meta/`:
- `AGENTS.md`: Meta-orchestrator orchestration logic (12 phases: NEW APP, MAINTENANCE, UPGRADE)
- `wisdom/`: 24,000+ lines of curated engineering principles (Thompson, Knuth, Pike, Kernighan)
- `patterns/`: Antipattern detection (God Object, Golden Hammer) + success patterns (Circuit Breaker)
- `templates/`: Templates for generated artifacts (AGENTS.md, APP_ORCHESTRATION.md)
- `principles.md`: Global principles (KISS, LEGO, Thompson #5, GEN+REVIEW)

**Target Users**: Non-technical founders, solo developers, small teams, prototypers, anyone who wants 
to build production apps without writing code manually.

---

## Constraints & Priorities

**Architecture**:
- Document-driven: Source = Markdown prompts (`.meta/` folder), not traditional code
- Stateless agents: File-based coordination (orchestrator_state.json, lego_state_*.json)
- Runtime-agnostic: Works with Codex CLI, GitHub Copilot Chat, OpenAI API
- No execution at runtime: "Code" is agent prompts executed by AI systems

**Performance**:
- Time-to-first-value: 15-45 minutes (user's app idea → working app)
- Session isolation: Can build 50+ component apps without context collapse
- Parallel execution: LEGO-Orchestrators work independently

**Privacy / Security**:
- User data: Stays in user's workspace (no telemetry, no cloud storage)
- Sensitive data: Apps apply Schneier's security principles + Saltzer & Schroeder
- Red-team reviews: Validation for apps handling sensitive data

**Cost**:
- Zero infrastructure: Runs via AI chat (GitHub Copilot) or CLI (Codex)
- No cloud services: File-based state management (SQLite/JSON)
- Free to use: Open-source (MIT license)

**Complexity**:
- KISS: Simple document-driven architecture (no complex orchestration engine)
- LEGO: Single-responsibility decomposition (Thompson #5: "Do one thing well")
- Wisdom: 24,000+ lines of principles guide decisions (not rigid rules)

---

## What's NOT In Scope (For Now)

**Not Building**:
- No traditional code generation (we orchestrate AI agents, not compile code)
- No runtime execution engine (AI systems execute the prompts, not a VM)
- No web UI (works through GitHub Copilot Chat, Codex CLI, or OpenAI API)
- No telemetry or analytics (privacy-first, no usage tracking)
- No cloud deployment (users deploy generated apps, not the engine itself)

**Limitations** (accepted trade-offs):
- Requires AI runtime (GitHub Copilot, Codex CLI, or OpenAI API)
- Stateless agents (no persistent memory between sessions)
- File-based coordination (no distributed orchestration)
- Single-user focus (no multi-tenant support)

---

## Known Integrations or APIs

**AI Runtimes** (the engine supports multiple):
- GitHub Copilot Chat (primary, best UX for users)
- Codex CLI (command-line interface, scriptable)
- OpenAI API (direct API integration, most flexible)

**Runtime Adapters** (abstraction layer in `runtime_adapters/`):
- `adapter_interface.md`: Contract for runtime implementations
- `codex_cli_adapter.sh`: Codex CLI integration
- `copilot_adapter.sh`: GitHub Copilot integration

**State Management**:
- File-based state: JSON (orchestrator_state.json, lego_state_*.json)
- Version tracking: .meta-version, .meta-manifest.json
- No databases: Simple file I/O for coordination

**Wisdom Sources** (curated engineering principles):
- Thompson: Unix philosophy (24,000+ lines across wisdom/)
- Knuth: Premature optimization, literate programming
- Pike: Simplicity, Go design principles
- Kernighan: Debugging, API design
- Schneier: Security principles
- Saltzer & Schroeder: Security design principles

---

## Success Criteria

**Primary Success Metrics** (for generated apps):
- KISS compliance: 100% of generated code follows single-responsibility principle
- Zero antipatterns: No God Objects, Golden Hammers, Magic Numbers in generated code
- Test coverage: >80% on all generated code (unit + integration + system)
- Essence delivery: 100% of apps pass end-to-end experience validation
- Maintainability: 100% of apps include AGENTS.md for future development

**Usability** (for users building apps):
- Time-to-first-value: 15-45 minutes (app idea → working app)
- Non-technical friendly: Plain English descriptions, no jargon
- Clarifying questions: 2-3 max before starting build
- Documentation: README.md + APP_ORCHESTRATION.md + AGENTS.md generated automatically

**Engine Quality** (for meta-orchestrator itself):
- Version stability: Clear upgrade paths between versions (UPGRADING.md)
- Dogfooding: Engine follows own structure (.meta-version, essence.md, AGENTS.md)
- Pre-flight Checklist: Prevents agent amnesia in stateless runtimes (GitHub Copilot)
- Session isolation: Can build 50+ component apps without context collapse

**Benchmark** (vs competitors):
- Completeness: Full apps (vs ChatGPT/Claude snippets)
- Quality: >80% test coverage (vs Bolt.new basic tests)
- Wisdom: Thompson/Knuth principles (vs Cursor/GitHub Copilot none)
- Maintainability: AGENTS.md for ongoing work (vs all competitors: throwaway code)

---

## Additional Context

**Development Philosophy**:
- Dogfooding: Engine applies own principles to itself (LEGO, KISS, wisdom)
- Recursive application: AGENTS.md (root) maintains engine using .meta/AGENTS.md
- Document-driven: All orchestration logic in Markdown (human-readable, AI-executable)
- Wisdom-first: 50+ years of expert knowledge guides decisions (not rigid rules)

**Unique Characteristics**:
- Source = Prompts: "Code" is AI agent instructions (Markdown), not traditional code
- Deployment = Copy: Users copy `.meta/` folder to their workspace
- Testing = Build Apps: Validate engine by building sample apps and checking quality
- Upgrades = File Updates: Version bumps mean updating Markdown files, not binaries

**Technical Lineage**:
- Inspired by: Unix philosophy (Thompson #5), literate programming (Knuth)
- Architecture: Hierarchical orchestration (Meta → LEGO-Orchestrators → Substeps)
- Wisdom sources: Thompson, Knuth, Pike, Kernighan, Schneier, Saltzer & Schroeder
- Patterns: Antipattern detection + success pattern library + trade-off matrices

**Future Evolution**:
- v1.6.0: Pre-flight Checklist (prevents agent amnesia in stateless runtimes)
- v1.7.0+: Telemetry (optional), benchmark suite, user feedback collection
- Long-term: Multi-language support (beyond Python), visual orchestration UI

---

## Ready?

Once you've filled this out, run:

```bash
@workspace Act as the meta-orchestrator in .meta/AGENTS.md and build this app
```

The meta-orchestrator will:
1. Ask 2-3 clarifying questions
2. Discover the "essence" of your app (what makes it unique)
3. Design the architecture (LEGO components)
4. Build everything in parallel
5. Test it thoroughly
6. Validate it actually works

You'll get a complete, working app in 15-45 minutes. 🚀
