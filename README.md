# Meta-Metacognition Pipeline - Autonomous Multi-Agent Development System

> **A hierarchical, LEGO-based, KISS-driven, meta-cognitive R&D pipeline that builds, tests, and maintains complete applications using isolated AI agent teams.**

This repository defines a **scalable meta-orchestrator** that spawns independent AI agent sessions to build applications from intent to production-ready code—including requirements, architecture, implementation, tests (unit/integration/system), and documentation.

**Key Innovation**: True session isolation prevents context explosion, enabling the system to build large applications (50+ components) by coordinating multiple parallel agent "teams."

---

## 📘 Getting Started

**Using this with your applications?**

👉 **See [`DEPLOYMENT_GUIDE.md`](DEPLOYMENT_GUIDE.md)** for:
- How to copy meta-orchestrator files into your app
- Directory structure recommendations (`.meta/` vs root-level)
- Using with NEW applications (step-by-step)
- Using with EXISTING applications (upgrade workflow)
- Cleanup and maintenance

**Quick answer**: Copy all files (except `.git/`, `README.md`, `DEPLOYMENT_GUIDE.md`) into your app's `.meta/` directory, then run meta-orchestrator.

---

## 🎯 What This System Does

Run **one command**, and the meta-orchestrator:

1. ✅ **Environment Preflight** - Verifies shell commands and file operations work
2. ✅ **Requirements Discovery** - Interactively extracts application requirements from `app_intent.md`
3. ✅ **Dependency Mapping** - Identifies all runtime/dev dependencies and external services
4. ✅ **LEGO Architecture** - Decomposes app into single-responsibility components
5. ✅ **Session Isolation** - Spawns independent agent sessions per LEGO (no context explosion)
6. ✅ **Parallel Execution** - Builds multiple LEGOs simultaneously (configurable parallelism)
7. ✅ **Test Pyramid** - Generates unit, integration, and system tests automatically
8. ✅ **Tool Agnostic** - Works with Codex CLI, GitHub Copilot, Claude MCP (via runtime adapters)
9. ✅ **Restartable State** - Can pause/resume at any time without data loss
10. ✅ **Safety Valves** - Detects stuck steps and provides clear remediation guidance

**Result**: A complete, tested, documented application ready for deployment.

---

## 📐 Architecture

```
┌──────────────────────────────────────────────────────────────┐
│              Meta-Orchestrator (Session 0)                   │
│  Role: CTO - Strategy, Coordination, Dependency Management   │
│  Context: requirements.md, lego_plan.json, principles.md     │
└───────────┬──────────────────────────────────────────────────┘
            │ (spawns isolated agent sessions via runtime adapter)
            │
            ├─────────────────────────┬─────────────────────────┐
            │                         │                         │
    ┌───────▼────────┐       ┌───────▼────────┐       ┌───────▼────────┐
    │ LEGO-Orch: Auth│       │ LEGO-Orch: Data│       │LEGO-Orch: API  │
    │  (Session 3)   │       │  (Session 4)   │       │  (Session 5)   │
    │ Role: Tech Lead│       │ Role: Tech Lead│       │ Role: Tech Lead│
    │ Context: Brief │       │ Context: Brief │       │ Context: Brief │
    └───────┬────────┘       └───────┬────────┘       └───────┬────────┘
            │                        │                        │
      ┌─────┼──────┬─────┐    (parallel execution)     (parallel execution)
      │     │      │     │
   Design  Test  Code  Val
```

**Benefits**:
- ✅ **Scalability**: No context explosion—each agent sees only its brief
- ✅ **Parallelism**: Build 3+ LEGOs simultaneously (configurable)
- ✅ **Cost Efficiency**: Smaller contexts = 60-80% lower token costs
- ✅ **Fault Isolation**: One LEGO failure doesn't corrupt entire pipeline
- ✅ **True Multi-Agent**: Mimics real engineering team structure

---

## 🚀 Quick Start

### New Application? Start Here

If you're **building a new app from scratch**, follow these steps:

### Prerequisites
- **WSL/Linux/macOS** (PowerShell via WSL works)
- **Codex CLI** installed (or GitHub Copilot CLI, or Claude MCP)
- **jq** for JSON parsing: `sudo apt install jq` (Linux) or `brew install jq` (macOS)

### 1️⃣ Clone & Configure

```bash
git clone https://github.com/yourorg/meta-metacognition.git
cd meta-metacognition

# Review/edit configuration (optional)
cat meta_config.json
```

**Key config options**:
```json
{
  "require_lego_plan_approval": false,   // Pause for human approval after architecture?
  "r_and_d_mode": "fast",                // "fast" | "thorough"
  "agent_runtime": "codex-cli",          // "codex-cli" | "github-copilot" | "claude-mcp"
  "session_isolation": "full",           // Always use "full" for Phase 1
  "max_parallel_sessions": 3,            // How many LEGOs to build simultaneously
  "enable_integration_tests": true,      // Generate integration tests?
  "enable_system_tests": true            // Generate E2E tests?
}
```

### 2️⃣ Define Your Application

Edit **`app_intent.md`** to describe what you want to build:

```markdown
# Application Intent: Stock Analyzer

## Purpose
Build a CLI tool that analyzes stock data and generates reports.
```

### 3️⃣ Run Meta-Orchestrator

```bash
codex exec "Act as the meta-orchestrator described in AGENTS.md and execute the full pipeline."
```

The pipeline will:
- Extract requirements interactively
- Generate LEGO architecture
- Build all components in parallel
- Generate tests and documentation
- Write `.meta-version` and `.meta-manifest.json` on completion

---

### Upgrading Existing Application? Go Here

If you **already have an app** built with an older version of meta-orchestrator and want to upgrade:

📘 **See**: [`MODES_QUICK_REFERENCE.md`](MODES_QUICK_REFERENCE.md) for:
- **Quick decision guide**: Which mode applies to your situation?
- All 5 modes explained (NEW APP, NO-OP, MAINTENANCE, ENGINE UPGRADE, HYBRID)
- Real-world examples with before/after
- Common workflows

📘 **See**: [`QUICKSTART_UPGRADE.md`](QUICKSTART_UPGRADE.md) for:
- How to protect your custom code changes
- Three upgrade strategies (safest to nuclear)
- Version compatibility matrix
- Step-by-step upgrade workflow

📘 **See**: [`UPGRADING.md`](UPGRADING.md) for:
- Deep dive on version management
- `.meta-version` and `.meta-manifest.json` format
- Mode decision matrix with examples
- Incremental feature adoption
- Upgrade agent behavior

📘 **See**: [`VERSION_MANAGEMENT_SUMMARY.md`](VERSION_MANAGEMENT_SUMMARY.md) for:
- High-level visual overview
- Flow diagrams for all modes
- Quick commands reference

**Quick command** (from your existing app directory):
```bash
# Protect your custom files first
cat > .meta-manifest.json << 'EOF'
{
  "files": {
    "src/my_custom_file.py": {"user_modified": true}
  }
}
EOF

# Mark current version
echo '{"meta_orchestrator_version": "0.9.0"}' > .meta-version

# Copy new engine files
cp /path/to/new-meta-metacognition/AGENTS.md .
# (copy other files)

# Run upgrade
codex exec "Act as meta-orchestrator. Upgrade this app from v0.9.0 to v1.1.0. Show plan first."
```

---
Build a CLI tool that analyzes stock market data and generates investment insights.

## Core Features
- Fetch stock price history from free API (Alpha Vantage or similar)
- Calculate technical indicators (SMA, RSI, MACD)
- Generate buy/sell recommendations
- Export reports to CSV

## Constraints
- Must work offline after initial data fetch
- Privacy: No user data leaves local machine
- KISS: Prefer simple algorithms over complex ML
- Cost: Use only free-tier APIs
```

### 3️⃣ Run the Meta-Orchestrator

```bash
codex exec "Act as the meta-orchestrator described in AGENTS.md and run the full pipeline."
```

The system will:
1. Ask 2-3 clarifying questions about your app
2. Generate `requirements.md`, `dependencies.md`, `.env.example`
3. Discover LEGO architecture → `lego_plan.json`
4. (Optional) Pause for your approval of the architecture
5. Spawn isolated agent sessions for each LEGO
6. Build all LEGOs in parallel (respecting dependencies)
7. Generate unit, integration, and system tests
8. Produce final documentation and review

### 4️⃣ Resume If Interrupted

```bash
codex exec resume --last "Continue the meta-orchestrator pipeline."
```

The system reads state files and continues from where it left off.

---

## 📁 Repository Structure

### **Files YOU Provide**
```
meta-metacognition/
├── AGENTS.md                    # Meta-orchestrator behavior contract
├── intent.md                    # How the meta-engine operates
├── app_intent.md                # 🎯 WHAT to build (you edit this per app)
├── principles.md                # Global engineering principles (KISS, testing, etc.)
├── meta_config.json             # Configuration (modes, flags)
└── README.md                    # This file
```

### **Files GENERATED by System**
```
meta-metacognition/
├── requirements.md              # Application requirements (versioned, with changelog)
├── dependencies.md              # Runtime + dev dependencies summary
├── external_services.md         # API/service documentation
├── .env.example                 # Environment variable template
├── requirements.txt             # Python deps (or package.json for Node)
├── lego_plan.json               # LEGO architecture definition
├── plan.md                      # Human-readable pipeline overview
├── orchestrator_state.json      # Global pipeline state
├── session_registry.json        # Tracks all active LEGO-Orchestrator sessions
├── lego_state_<name>.json       # Per-LEGO progress tracking
│
├── sessions/                    # Isolated agent session workspaces
│   ├── session_auth_brief.md
│   ├── session_data_brief.md
│   └── ...
│
├── src/                         # Generated source code
│   ├── auth.py
│   ├── data_layer.py
│   └── ...
│
├── tests/                       # Generated tests
│   ├── test_auth.py             # Unit tests
│   ├── integration/             # Integration tests
│   │   └── test_auth_data.py
│   └── system/                  # E2E tests
│       └── test_user_onboarding.py
│
├── docs/                        # Generated documentation
│   ├── auth_internal.md
│   ├── auth_public.md
│   └── ...
│
├── internal-notes.md            # Technical rationale & trade-offs
├── review.md                    # Final system-level review
├── env_diagnostics.md           # (only if environment issues)
└── meta_error.md                # (only if safety valve triggered)
```

---

## 🔧 Runtime Adapters (Tool Agnosticism)

The system can work with different AI tools via **runtime adapters**.

### Supported Runtimes

| Runtime | Adapter | Parallelism | Notes |
|---------|---------|-------------|-------|
| **Codex CLI** | `runtime_adapters/codex_cli_adapter.sh` | ✅ Yes | Default, recommended |
| **GitHub Copilot** | `runtime_adapters/copilot_adapter.sh` | ⚠️ Limited | Single-session mode |
| **Claude MCP** | `runtime_adapters/claude_mcp_adapter.sh` | ✅ Yes | Future integration |

### Switching Runtimes

Edit `meta_config.json`:
```json
{
  "agent_runtime": "github-copilot"  // Change from "codex-cli"
}
```

See **`runtime_adapters/adapter_interface.md`** for details on creating custom adapters.

---

## 🧪 Testing Strategy

### Test Pyramid (Automatic)

```
        ┌─────────────┐
        │  System/E2E │  ← 5-10 tests (full user journeys)
        │   Tests     │
        ├─────────────┤
        │Integration  │  ← 20-30 tests (LEGO interactions)
        │   Tests     │
        ├─────────────┤
        │   Unit      │  ← 100+ tests (per-LEGO behavior)
        │   Tests     │
        └─────────────┘
```

### Test Generation Rules

1. **Unit Tests** (always generated):
   - Created during LEGO-Orchestrator `TEST AUTHORING` substep
   - Location: `tests/test_<lego>.py`
   - Must pass before LEGO marked as "done"

2. **Integration Tests** (if `enable_integration_tests: true`):
   - Generated after dependent LEGOs complete
   - Tests 2-3 LEGOs working together
   - Location: `tests/integration/`

3. **System Tests** (if `enable_system_tests: true`):
   - Generated after all LEGOs done
   - Tests complete user journeys from `requirements.md`
   - Location: `tests/system/`

See **`TESTING_STRATEGY.md`** for comprehensive testing documentation.

---

## ⚙️ Configuration Reference

### `meta_config.json` Options

```json
{
  // === PHASE 1: Session Isolation, Tool Agnosticism, Testing ===
  "agent_runtime": "codex-cli",           // Which AI tool to use
  "session_isolation": "full",            // Always "full" for scale
  "max_parallel_sessions": 3,             // How many LEGOs built simultaneously
  "enable_integration_tests": true,       // Generate integration tests?
  "enable_system_tests": true,            // Generate E2E tests?
  
  // === CORE SETTINGS ===
  "require_lego_plan_approval": false,    // Pause for human review of architecture?
  "r_and_d_mode": "fast",                 // "fast" | "thorough"
  
  // === PHASE 2: Agent Tuning & Problem Evolution (future) ===
  "enable_agent_tuning": false,           // Adaptive agent prompts
  "enable_problem_evolution": false,      // Problem-solving feedback loop
  
  // === PHASE 3: Production Monitoring (future) ===
  "enable_production_monitoring": false,  // Observability & feedback
  "feedback_loop_interval_hours": 24      // How often to reassess
}
```

### R&D Modes

- **`fast`** (recommended for iteration):
  - Minimal GEN+REVIEW cycles
  - Lighter evaluation harnesses
  - Red-team only for obviously sensitive LEGOs
  - Faster execution

- **`thorough`** (for production-ready code):
  - More GEN+REVIEW cycles
  - Richer evaluation harnesses
  - Mandatory red-team for sensitive LEGOs
  - Deeper testing

---

## 🎓 How It Works (Conceptual)

### 1. Environment Preflight
Verifies shell commands (`pwd`, `echo`) and file operations work. Writes `env_diagnostics.md` if issues detected.

### 2. Requirements & Dependency Discovery
- Reads `app_intent.md`
- Asks minimal clarifying questions
- Generates `requirements.md` with versioned changelog
- Identifies ALL dependencies → `dependencies.md`, `.env.example`, `external_services.md`
- Validates feasibility before proceeding

### 3. LEGO Discovery (KISS-Driven)
- Decomposes app into single-responsibility components
- Each LEGO defined with: name, responsibility, inputs, outputs, dependencies, fundamentals
- Writes `lego_plan.json`
- Splits any LEGO attempting multiple jobs

### 4. Optional Architecture Approval
If `require_lego_plan_approval: true`, pauses to show you the LEGO plan and waits for confirmation.

### 5. Session Spawning (True Isolation)
For each LEGO:
1. Meta-Orchestrator creates `sessions/session_<lego>_brief.md`
2. Spawns isolated agent session via runtime adapter
3. LEGO-Orchestrator executes substeps: DESIGN → TEST → DOC → CODE → VALIDATION
4. Updates `lego_state_<lego>.json` with progress
5. Meta-Orchestrator monitors and coordinates

### 6. Parallel Execution
- Respects `max_parallel_sessions` limit
- Launches new sessions as dependencies complete
- Handles failures with retry logic and safety valves

### 7. Testing Pyramid
- Unit tests during LEGO validation
- Integration tests after subsystem completion
- System tests as final pipeline stage

### 8. Finalization
- Generates `internal-notes.md`, `review.md`, updates `README.md`
- Aggregates all test results
- Provides recommendations for improvement

---

## 🆘 Troubleshooting

### **Environment Issues**

**Problem**: "Codex cannot write files or run commands"

**Solution**:
1. Run in WSL or Linux/macOS shell (not pure Windows CMD)
2. Ensure repo is in writable directory (`~/projects/`, not `/mnt/c/...`)
3. Check `env_diagnostics.md` for details

---

### **Pipeline Stuck / Safety Valve Triggered**

**Problem**: "Step X failed 3 times, marked as stuck"

**Solution**:
1. Read `meta_error.md` to see which step/LEGO failed
2. Check the specific `lego_state_<name>.json` for error details
3. Common fixes:
   - Clarify ambiguous requirements in `app_intent.md`
   - Add missing dependencies to `dependencies.md`
   - Simplify LEGO responsibilities (split complex LEGOs)
4. Re-run after fixes

---

### **Too Many Questions During Setup**

**Problem**: Meta-orchestrator asks excessive clarifying questions

**Solution**:
1. Make `app_intent.md` more explicit:
   - List specific features
   - Define constraints clearly
   - Specify tech stack preferences
2. Use `"r_and_d_mode": "fast"` for fewer cycles

---

### **Want Deeper Exploration**

**Problem**: Need more thorough testing and evaluation

**Solution**:
Set `"r_and_d_mode": "thorough"` in `meta_config.json` for:
- More GEN+REVIEW cycles
- Richer evaluation harnesses
- Mandatory red-team reviews for sensitive LEGOs

---

### **Session Not Resuming Correctly**

**Problem**: "codex exec resume" doesn't continue from correct state

**Solution**:
1. Check `orchestrator_state.json` for current pipeline status
2. Verify `lego_state_*.json` files exist for in-progress LEGOs
3. If corrupted, delete specific LEGO state file to restart that LEGO only
4. Never delete `orchestrator_state.json` unless starting completely fresh

---

## 📚 Additional Documentation

- **`AGENTS.md`** - Complete meta-orchestrator behavior contract
- **`SESSION_ISOLATION.md`** - Deep dive on multi-agent session architecture
- **`TESTING_STRATEGY.md`** - Comprehensive testing methodology
- **`runtime_adapters/adapter_interface.md`** - How to add new AI tool support
- **`principles.md`** - Global engineering principles (KISS, LEGO, testing)
- **`intent.md`** - Meta-orchestrator intent and philosophy

---

## 🎉 Example: Building a Stock Analyzer

```bash
# 1. Edit app_intent.md
cat > app_intent.md << 'EOF'
# Stock Analyzer CLI Tool

## Purpose
Analyze stock market data and generate investment insights.

## Features
- Fetch stock data from free API
- Calculate technical indicators (SMA, RSI)
- Generate buy/sell signals
- Export reports to CSV

## Constraints
- Free APIs only
- Works offline after initial fetch
- No user data leaves local machine
EOF

# 2. Run meta-orchestrator
codex exec "Act as the meta-orchestrator described in AGENTS.md and run the full pipeline."

# 3. Answer 2-3 questions (e.g., preferred API, output format)

# 4. Let it build! It will:
#    - Generate requirements.md
#    - Discover LEGOs: data_fetcher, indicator_calculator, signal_generator, report_exporter
#    - Spawn 3 parallel sessions (respecting dependencies)
#    - Generate unit + integration + system tests
#    - Produce complete, tested CLI tool

# 5. If interrupted:
codex exec resume --last "Continue building the stock analyzer."
```

---

## 🌟 What Makes This Unique

1. **True Session Isolation**: Only meta-cognitive system that spawns independent agent sessions per component, preventing context explosion
2. **Tool Agnostic**: Works with multiple AI platforms via pluggable runtime adapters
3. **Production-Grade Testing**: Automatic test pyramid generation (unit/integration/system)
4. **Cost Efficient**: 60-80% lower token costs vs. single-context approaches
5. **Scalable**: Can build apps with 50+ components without degradation
6. **Restartable**: Pause/resume anywhere without data loss
7. **Self-Documenting**: Generates internal notes, public docs, and architecture reviews

---

## 🔮 Roadmap

### ✅ Phase 1 (Current): Session Isolation & Testing
- True multi-agent architecture with isolated sessions
- Tool agnosticism (Codex CLI, Copilot, Claude)
- Comprehensive testing pyramid (unit/integration/system)
- Parallel LEGO execution

### 🚧 Phase 2 (Next): Agent Tuning & Problem Evolution
- Adaptive agent profiles that learn from previous runs
- Problem-solving feedback loop
- Hypothesis testing and validation
- Domain knowledge injection

### 🔭 Phase 3 (Future): Production Monitoring
- Observability LEGO for deployed apps
- Production telemetry feedback loop
- Automatic reassessment when systems drift
- SLI/SLO monitoring and alerting

---

## 🤝 Contributing

This is a meta-cognitive template system. To use it:

1. **Fork this repo**
2. **Edit `app_intent.md`** for your specific application
3. **Run the meta-orchestrator**
4. **Keep `AGENTS.md`, `principles.md`, `intent.md`** stable (they define the engine)

To improve the meta-orchestrator itself:
- Submit PRs to `AGENTS.md`, `principles.md`, or runtime adapters
- Add new LEGO types to `TESTING_STRATEGY.md`
- Create adapters for new AI tools

---

## 📄 License

MIT License - See LICENSE file

---

## 🙋 Support

**Issues**: Open a GitHub issue describing the problem
**Docs**: All behavior is defined in `AGENTS.md` and supplemental `.md` files
**Community**: [Link to Discord/Slack if applicable]

---

**Built with meta-cognitive AI orchestration. No human wrote the code—agents did.**
