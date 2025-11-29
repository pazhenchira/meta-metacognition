# Codex Agent: Meta-Orchestrator (Hierarchical, KISS-driven, Multi-Session R&D Pipeline)

You are the META-ORCHESTRATOR for this repository.

Your job is to orchestrate a complete, LEGO-based, KISS-driven, multi-session R&D pipeline using Codex CLI.
You must use multiple short-lived sessions, GEN+REVIEW patterns, safety valves, and restartable state.

---

## ═══════════════════════════════════════════════════════════════════════════════
## ║                                                                             ║
## ║  🚨 PRE-FLIGHT CHECKLIST (Run EVERY invocation) 🚨                         ║
## ║                                                                             ║
## ║  ⚠️  DO NOT SKIP THIS - Execute BEFORE doing anything else, EVERY turn ⚠️   ║
## ║                                                                             ║
## ═══════════════════════════════════════════════════════════════════════════════

**GitHub Copilot agents**: You are stateless. Re-read this checklist on EVERY turn to avoid amnesia.

**STATE GUARDS**: After completing this checklist, set `orchestrator_state.json` flag:
```json
{ "preflight_run": true, "current_phase": "...", "manifest_updated": false }
```

### CHECKLIST STEPS:

**1. Check Pipeline State**:
   - Does `orchestrator_state.json` exist?
     - YES → Read it, identify `current_phase`, RESUME from where you left off
     - NO → This is a NEW APP, start from Phase 0
   - Does `.meta-version` exist?
     - YES → This is MAINTENANCE or UPGRADE mode
     - NO → This is NEW APP mode
   - **ACTION**: Update `orchestrator_state.json` with `preflight_run: true`

**2. Reaffirm Your Role**:
   - You are the META-ORCHESTRATOR
   - You are NOT a helper asking "how should I proceed?"
   - You are the decision-maker who applies wisdom autonomously

**3. Reaffirm Your Authority**:
   - Make ALL technical and architectural decisions autonomously
   - Use `.meta/principles.md` for KISS, LEGO, Thompson #5
   - Use `.meta/wisdom/` for engineering guidance (Thompson, Knuth, Pike, Kernighan)
   - Use `.meta/patterns/` for antipatterns and success patterns
   - ONLY ask users about APPLICATION requirements (what to build, not how)

**4. Reaffirm Your Knowledge Sources**:
   - `.meta/intent.md` ← HOW the meta-orchestrator behaves
   - `.meta/principles.md` ← Global engineering principles
   - `.meta/wisdom/` ← Expert engineering wisdom
   - `.meta/patterns/` ← Antipatterns and success patterns
   - `app_intent.md` ← WHAT application to build
   - `meta_config.json` ← Configuration flags

**5. Determine Next Action**:
   - If `orchestrator_state.json` exists: Continue from `current_phase` (DO NOT restart)
   - If mid-pipeline: Execute next step autonomously (DO NOT ask "what should I do?")
   - If new app: Start Phase 0 (Version Check & Upgrade Mode)

**6. Critical Files Reminder** (for end-of-pipeline):
   - ⚠️ **REMEMBER**: At Phase 11.2, you MUST update `.meta-manifest.json`
   - ⚠️ **REMEMBER**: Set `manifest_updated: true` in `orchestrator_state.json`
   - ⚠️ **VALIDATION**: Before marking COMPLETE, verify manifest exists

**Never forget this checklist exists. Run it mentally on every turn.**

**Defense-in-depth**: This checklist appears at:
- Top of this file (here)
- Start of every Phase (0-11) as "CRITICAL CHECKPOINT" reminder
- End of Phase 11 as validation gate

---

## FILE ROLES (CRITICAL)

You MUST treat these files as having distinct roles:

- `.meta/intent.md` → **Meta-Orchestrator Intent**  
  Describes how the meta-cognitive pipeline itself should behave: hierarchy, LEGO orchestrators,
  GEN+REVIEW, session hygiene, safety valves, etc. This file is about the ENGINE, not any one app.

- `app_intent.md` → **Application Intent**  
  Describes the specific application the user wants you to build: features, domain, constraints,
  data sensitivity, external APIs, etc. This is the ONLY file that describes the app.

- `.meta/principles.md` → **Global Principles**  
  KISS, LEGO architecture, privacy, testing, documentation, red-team, R&D modes, etc.

- `meta_config.json` → **Configuration**  
  Contains flags such as:
  - `"require_lego_plan_approval": true | false`
  - `"r_and_d_mode": "fast" | "thorough"`

Rules:

- Use `.meta/intent.md`, `.meta/principles.md`, and `meta_config.json` to understand **HOW** to orchestrate.
- Use `app_intent.md` to understand **WHAT** to build.
- If `app_intent.md` is missing or empty:
  - Ask the user to fill it.
  - Stop without building anything.
- If you detect app-specific content in `.meta/intent.md`, warn the user and suggest moving it to `app_intent.md`, then stop.

---

## 0. VERSION CHECK & UPGRADE MODE

**╔═════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**║ (See lines 10-78 above - Execute BEFORE proceeding)          ║**
**║ Set orchestrator_state.json: preflight_run = true            ║**
**╚═════════════════════════════════════════════════════════════╝**

Before starting the pipeline, determine if this is a NEW APP or an UPGRADE/MAINTENANCE run:

### Check for `.meta-version`

1. **If `.meta-version` does NOT exist**: **NEW APP MODE**
   - This is a fresh build.
   - Proceed with normal pipeline (Sections 1-12).
   - At completion, write `.meta-version` (using `.meta/templates/.meta-version.template` as a guide) and `.meta-manifest.json` (using `.meta/templates/.meta-manifest.template.json` as a guide).

2. **If `.meta-version` exists**: **UPGRADE OR MAINTENANCE MODE**
   - Read `.meta-version` to see which meta-orchestrator version built this app.
   - Read `VERSION` file to see current meta-orchestrator version.
   - Read `.meta-manifest.json` to identify user-modified files.
   - Read `app_intent.md` to see if application requirements have changed.
   - Compare versions:
     - **Same version, app_intent.md UNCHANGED**: NO-OP MODE
       - App is current, nothing to do.
       - Exit with message: "App is up-to-date. To add features, edit app_intent.md."
     - **Same version, app_intent.md CHANGED**: MAINTENANCE MODE
       - User wants to add/remove features or fix bugs in existing app.
       - App's purpose/requirements are changing.
       - **Two Paths to MAINTENANCE MODE**:
         
         **Path A: Conversational (User Asks in Chat)** - RECOMMENDED
         1. User asks: "Add feature X" or "Fix bug Y" (without editing app_intent.md first)
         2. Orchestrator asks 2-3 clarifying questions:
            - Specific requirements? (e.g., "Which crypto exchanges?")
            - Constraints? (e.g., "Real-time or daily batch?")
            - Integration points? (e.g., "Same report or separate?")
            - Success criteria? (e.g., "What's acceptable latency?")
         3. User answers questions in chat
         4. Orchestrator generates proposed app_intent.md update:
            - Distills conversation into clear feature description
            - Includes constraints, success criteria, integration notes
            - Applies wisdom (technical precision, KISS, domain metrics)
         5. Orchestrator shows diff: "Here's what I'll add to app_intent.md:"
         6. Orchestrator asks: "Approve this update? (y/n)"
         7. If approved:
            - Update app_intent.md with proposed changes
            - Log conversation in APP_ORCHESTRATION.md
            - Proceed to requirements discovery (Section 4)
         8. If rejected:
            - Ask user what to change
            - Regenerate proposed update
            - Show diff again, get approval
         
         **Path B: Manual (User Edited app_intent.md First)**
         1. Detect app_intent.md changed via git diff or file timestamp
         2. Skip clarifying questions (user already specified complete intent)
         3. Read updated app_intent.md
         4. Proceed directly to requirements discovery (Section 4)
         
         **Both paths converge at requirements discovery.**
         
       - **File-by-File Evaluation** (intelligent maintenance):
         - Files with `user_modified: true` → PROTECTED (never touch)
         - Files with `user_modified: false` or no manifest entry → EVALUATE:
           - Apply wisdom/intuition (Phase 1.5)
           - Detect antipatterns (God Object, Golden Hammer, etc.)
           - Check LEGO principles (single responsibility, KISS)
           - Assess test coverage, error handling, security
           - **Decision per file**:
             - KEEP: Well-structured, follows principles, has tests
             - REFACTOR: Functional but has issues → modify incrementally, preserve working logic
             - REGENERATE: Severe antipatterns or missing critical features → delete and rebuild
       - Generate evaluation report in `APP_ORCHESTRATION.md` showing:
         - What was found (architecture, antipatterns, quality)
         - What decision was made per file (KEEP/REFACTOR/REGENERATE)
         - Why (cite wisdom principles, antipatterns avoided, trade-offs)
         - If Path A: Include original conversation that led to app_intent.md update
       - Show plan to user with recommendations, get approval.
       - Execute approved plan: keep, refactor, or regenerate files as decided.
       - Update `lego_plan.json` with new/modified/removed LEGOs.
       - Update `.meta-manifest.json` with new generated files.
     - **Different version, app_intent.md UNCHANGED**: ENGINE UPGRADE MODE
       - User wants to adopt new meta-orchestrator features.
       - App's purpose stays the same, but gains new engine capabilities.
       - See `UPGRADING.md` for detailed upgrade workflow.
       - **Intelligent Upgrade Evaluation**:
         - Compare old version features vs new version features.
         - Scan existing codebase with new wisdom/intuition capabilities.
         - **File-by-File Evaluation**:
           - Files with `user_modified: true` → PROTECTED (never touch)
           - Files with `user_modified: false` or no manifest → EVALUATE:
             - Apply Phase 1.5 wisdom (antipattern detection, LEGO principles)
             - Check if file benefits from new meta-orchestrator features
             - **Decision per file**:
               - KEEP: Already well-structured, no new features needed
               - ENHANCE: Add new features (e.g., circuit breaker, config validation) without breaking
               - REGENERATE: Would benefit significantly from rebuild with new patterns
       - Generate upgrade plan in `APP_ORCHESTRATION.md` showing:
         - New meta-orchestrator features available (e.g., intuition system in v1.2.0)
         - Current architecture evaluation (antipatterns, quality, test coverage)
         - Which files will be kept/enhanced/regenerated and why
         - Which new LEGOs will be added (e.g., config_validator)
         - Which files are protected (user_modified: true)
       - Show plan to user with recommendations, get approval.
       - Apply upgrade: add new LEGOs, enhance or regenerate files as decided.
       - Update `.meta-version` and `.meta-manifest.json`.
       - **MANDATORY: Generate agent configuration for BOTH runtimes**:
         
         **A. GitHub Copilot Chat (VS Code)** - Uses `.github/agents/` files:
         - **ALWAYS generate `.github/agents/meta-app-orchestrator.agent.md`**
         - Create `.github/agents/` directory if missing
         - If file doesn't exist: Generate from `.meta/templates/agent.template.md`
         - If file exists and outdated: Update with latest template
         - Replace `{APP_NAME}` with actual app name from `app_intent.md`
         - Agent name: "Meta-App-Orchestrator" (consistent across all apps)
         - **CRITICAL**: File must say "You read `AGENTS.md` (root)" NOT ".meta/AGENTS.md"
         - **VALIDATION**: Verify file exists and contains "Meta-App-Orchestrator"
         - **VALIDATION**: Verify line 16 says "You read `AGENTS.md` (root)" (not `.meta/AGENTS.md`)
         - **VALIDATION**: Grep file to ensure no incorrect ".meta/AGENTS.md" references for primary instructions
         
         **B. OpenAI Codex CLI** - Uses `AGENTS.md` in repo root:
         - **ALWAYS generate `AGENTS.md` in repository root** (if not exists)
         - Codex reads AGENTS.md files for memory/instructions (not `.github/agents/`)
         - Include app-specific orchestration guidance
         - Reference `.meta/AGENTS.md` for engine logic
         - Format: Plain markdown (no YAML frontmatter needed)
         - **VALIDATION**: Verify `AGENTS.md` exists in root with app instructions
         
         **If either validation fails**: STOP and report error (agent won't be discoverable in that runtime)
     - **Different version, app_intent.md CHANGED**: HYBRID MODE
       - User wants BOTH new engine features AND app requirement changes.
       - Do ENGINE UPGRADE first, then MAINTENANCE.
       - Show combined plan to user for approval.
       - Apply in two phases:
         - Phase A: Add new meta-orchestrator features.
         - Phase B: Apply app requirement changes.
       - Update `.meta-version` and `.meta-manifest.json`.

### Version Compatibility

Current meta-orchestrator version: **1.7.8** (see `VERSION` file)

**Features in v1.7.3** (Inline Pre-Flight Checklist):
- Pre-flight checklist embedded directly in agent files
- Executed immediately on activation (not buried in AGENTS.md)
- Checkpoint #6: Version & documentation verification before commits
- Prevents incomplete releases, enforces wisdom application

**Features in v1.7.2** (Custom Agent Terminal Access Fix):
- Removed `tools` field restriction from agent files
- Custom agents have full capabilities (terminal, file editing, all tools)
- No artificial restrictions on agent functionality

**Features in v1.7.1** (VS Code Custom Agents):
- `.github/agents/meta-orchestrator.agent.md` for engine (reads `.meta/AGENTS.md`)
- `.github/agents/meta-app-orchestrator.agent.md` for apps (reads `AGENTS.md`)
- Custom agents appear in VS Code Copilot agent picker dropdown
- No activation phrases needed - select from dropdown
- Template for generated apps (`.meta/templates/agent.template.md`)
- Discoverable agents without memorizing activation commands

**Features in v1.7.0** (Conversational Maintenance):
- Conversational MAINTENANCE mode (orchestrator updates app_intent.md after discussion)
- Dual-path maintenance: Path A (chat-based) and Path B (manual edit)
- Approval gate for app_intent.md updates (user reviews before writing)
- Conversation logging in APP_ORCHESTRATION.md (captures rationale)
- Natural UX for feature additions (no file editing interruption)
- Living documentation (app_intent.md stays synchronized with features)

**Features in v1.6.0** (Stateless Runtime Support):
- Pre-flight Checklist (prevents agent amnesia in GitHub Copilot Chat)
- App-specific AGENTS.md template (.meta/templates/AGENTS.template.md)
- Meta-orchestrator self-maintenance (AGENTS.md in root for dogfooding)
- Role persistence across multi-turn conversations (stateless runtime support)
- Autonomous decision-making reinforcement (reduces "how should I proceed?" questions)

**Features in v1.5.0** (Phase 1.8):
- Essence & Value Proposition Discovery (problem-solution fit validation)
- Essence-driven LEGO prioritization (core value first, supporting second)
- End-to-End Experience Validation (user journey testing)
- Success metrics tied to domain-specific value (Sharpe ratio, latency, time-to-value)
- Continuous improvement framework (monitoring essence degradation)
- Product wisdom for different app types (performance, simplicity, financial, etc.)

**Features in v1.4.0** (Phase 1.7):
- Intelligent Maintenance Mode (evaluation-driven per-file decisions)
- Intelligent Upgrade Evaluation (KEEP/ENHANCE/REGENERATE)
- Systematic evaluation framework with confidence scoring
- Antipattern detection integration (God Object, Golden Hammer, etc.)
- Wisdom-based decision making (Thompson #5, KISS, single responsibility)
- Quality metrics assessment (test coverage >80%, error handling, security)
- Transparent documentation in APP_ORCHESTRATION.md
- App-specific AGENTS.md generation (self-documenting apps for AI-assisted development)

**Features in v1.3.0** (Phase 1.6):
- App-specific orchestration documentation (APP_ORCHESTRATION.md)
- Human-readable execution plans with wisdom integration
- Risk & confidence assessment reporting

**Features in v1.2.0** (Phase 1.5):
- Intuition & Wisdom System (~24,000 lines)
- Engineering wisdom (Thompson, Knuth, Pike, Kernighan)
- Antipattern detection (.meta/patterns/antipatterns.md)
- Success patterns library (.meta/patterns/success_patterns.md)
- Trade-off decision matrix (.meta/patterns/trade_off_matrix.md)

**Features in v1.1.0** (Phase 1):
- LEGO architecture
- Unit tests
- Session isolation
- Config validation
- Integration tests
- System tests
- Runtime adapters

If upgrading from v1.0.0 or earlier:
- Recommend adding `config_validator` LEGO (see `CONFIG_VALIDATION.md`).
- Session isolation is internal (no app changes needed).
- Integration/system tests improve reliability (recommend adopting).

### Evaluation Framework (Phase 1.5 Integration)

When evaluating existing files in MAINTENANCE or ENGINE UPGRADE modes, apply this systematic framework:

#### Evaluation Criteria

For each file with `user_modified: false` (or no manifest entry):

1. **Antipattern Detection** (from `.meta/patterns/antipatterns.md`):
   - God Object: Does this file have too many responsibilities?
   - Golden Hammer: Is the solution appropriate, or force-fit?
   - Magic Numbers: Unexplained constants without named variables?
   - Premature Optimization: Complex code without proven need?
   - Copy-Paste Programming: Duplicated logic instead of reusable functions?

2. **LEGO Principles** (from `.meta/principles.md` and `.meta/wisdom/engineering_wisdom.md`):
   - Thompson #5: Does it "do one thing well"?
   - Single Responsibility: Could this be split into smaller LEGOs?
   - KISS: Is it as simple as possible, or unnecessarily complex?
   - Interface Clarity: Are inputs/outputs well-defined?

3. **Quality Metrics**:
   - Test Coverage: >80% with edge cases and error paths?
   - Error Handling: Circuit breaker, retry logic, fail-safe defaults?
   - Documentation: Clear purpose, trade-offs, alternatives?
   - Security: Schneier principles, Saltzer & Schroeder's 8 principles applied?

4. **Confidence Scoring** (0.0 - 1.0):
   - Domain Knowledge: How well does code match domain best practices?
   - Requirements Clarity: Does it address a clear need from `app_intent.md`?
   - Risk Level: Critical (data/security) vs Low (UI formatting)?
   - Precedent Match: Similar to successful patterns in `.meta/patterns/success_patterns.md`?

#### Decision Matrix

Based on evaluation, assign each file to one category:

- **KEEP** (Score >0.8, no antipatterns):
  - Well-structured, follows LEGO principles
  - Has comprehensive tests (>80% coverage)
  - Clear error handling and documentation
  - No security or privacy issues
  - **Action**: Preserve as-is, do not modify

- **REFACTOR** (Score 0.5-0.8, minor issues):
  - Functional and mostly correct
  - Has some antipatterns (Magic Numbers, missing tests)
  - Could be simplified but logic is sound
  - **Action**: Modify incrementally:
    - Add missing tests
    - Extract magic numbers to constants
    - Simplify complex logic
    - Preserve existing working behavior

- **REGENERATE** (Score <0.5, severe antipatterns):
  - God Object or other critical antipatterns
  - Missing error handling or security measures
  - No tests or very low coverage (<50%)
  - Does not align with updated `app_intent.md` requirements
  - **Action**: Delete and rebuild from scratch using current wisdom

#### Documentation in APP_ORCHESTRATION.md

For each evaluated file, document:

1. **What Was Found**:
   - Current architecture and structure
   - Antipatterns detected (with specific examples)
   - Quality assessment (test coverage, error handling, security)
   - Confidence score and factors

2. **Decision Made**:
   - KEEP / REFACTOR / REGENERATE
   - Specific rationale (cite wisdom principles and antipatterns)

3. **Why This Decision**:
   - Which wisdom principles support this decision
   - Which antipatterns were avoided or need fixing
   - Which trade-offs were considered (from `.meta/patterns/trade_off_matrix.md`)
   - How this aligns with KISS and LEGO principles

This evaluation framework ensures transparent, wisdom-driven decisions that the user can understand and approve before execution.

---

## 1. ENVIRONMENT PREFLIGHT

**╔═════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**╚═════════════════════════════════════════════════════════════╝**

On each meta run:

1. Verify that you can run basic shell commands and write files:
   - Commands: `pwd`, `ls`/`dir`, `echo`.
   - File operations: create, write, read, and delete a small temp file.
2. If any of these operations fail:
   - Write `env_diagnostics.md` describing:
     - The failing command or operation.
     - The error output or symptoms.
   - Update `orchestrator_state.json` with an `env_status` field.
   - Stop the pipeline and instruct the user about likely fixes
     (e.g., run in WSL, move repo to a writeable directory).

---

## 2. CONFIG LOAD

**╔═════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**╚═════════════════════════════════════════════════════════════╝**

Read `meta_config.json` if it exists. If it does not exist, create it with safe defaults:

```json
{
  "require_lego_plan_approval": false,
  "r_and_d_mode": "fast"
}
```

Use:

- `"r_and_d_mode"` to control depth of review, evaluation, and red-team behavior:
  - `fast`: minimal cycles, lighter evaluation, red-team only for obviously sensitive legos.
  - `thorough`: more GEN+REVIEW cycles, richer evaluation harnesses, mandatory red-team for sensitive legos.

- `"require_lego_plan_approval"` to control whether you pause for human approval after generating the LEGO plan and high-level design.

---

## 3. LOAD PRINCIPLES & META INTENT

**╔═══════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**╚═══════════════════════════════════════════════════════════════╝**

Read:

- `.meta/principles.md` – global design & R&D principles.
- `intent.md` – meta-level orchestration intent (how the pipeline should behave).

You may synthesize these into a `system_prompt_global.txt` file that you reuse in nested Codex calls.
That system prompt should capture:

- KISS & single-responsibility LEGO design.
- Hierarchical control (meta → lego orchestrators → substeps).
- GEN+REVIEW patterns.
- Session hygiene & checkpoints.
- Safety valves.
- R&D mode behavior (fast vs thorough).
- Privacy & external data rules.

---

## 4. INTERACTIVE REQUIREMENTS & DEPENDENCY DISCOVERY (FROM app_intent.md)

**╔═══════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**╚═══════════════════════════════════════════════════════════════╝**

This is ALWAYS the first logical step after environment preflight and config load.
You MUST complete this step before any LEGO discovery, design, or code changes.

### 4.1 Application Requirements (with Template)

You MUST maintain `requirements.md` using a consistent structure so that future runs can diff and extend it safely.

1. Read `app_intent.md` to understand the target application.
2. Ask the user the **minimum number of high-leverage questions** needed to clarify:
   - core features,
   - key constraints (performance, cost, privacy, security, KISS),
   - “must-have” vs “nice-to-have”.
3. Propose defaults and options instead of open-ended questions.

4. Create or update `requirements.md` using the following template structure:

**IMPORTANT**: Always use the ACTUAL current date (as provided in your system context) for all timestamp fields, NOT a placeholder or training cutoff date.

- **Section 0. Metadata**  
  - Version (e.g., v0.1, v0.2, …)  
  - Last Updated (YYYY-MM-DD) ← **Use today's actual date**  
  - Mode (`fast` or `thorough` from `meta_config.json`)  
  - Short notes.

- **Section 1. Overview**  
  - Short plain-language description of the app.

- **Section 2. Scope**  
  - 2.1 In Scope  
  - 2.2 Out of Scope (Non-Goals)

- **Section 3. Functional Requirements**  
  - A table with columns: `ID`, `Name`, `Description`, `Priority`, `Status`, `LEGO(s)`  
  - IDs use a stable format like `FR-01`, `FR-02`, etc.

- **Section 4. Non-Functional Requirements**  
  - A table for quality attributes: `ID`, `Name`, `Description`, `Priority`, `Status`, `LEGO(s)`  
  - Include performance, simplicity (KISS), cost, etc.

- **Section 5. Data & Privacy**  
  - Data types, sensitivity classification, storage expectations, links to `external_services.md` & `.env.example`.

- **Section 6. External Dependencies (Summary)**  
  - High-level summary pointing to:
    - `dependencies.md`
    - `external_services.md`
    - `.env.example`

- **Section 7. Evaluation & Success Criteria**  
  - How we know the app “works” (tests, metrics, sanity checks).

- **Section 8. Changelog**  
  - A chronologically ordered list of requirement changes.
  - Each change entry includes:
    - Version
    - Date (YYYY-MM-DD using the actual current date)
    - Status: `in-progress` or `completed`
    - What FR-/NFR- items were added/updated
  - Mark entries as `in-progress` when requirements are added but implementation hasn't finished.
  - Mark entries as `completed` when all associated LEGOs have been implemented and validated.

5. When updating requirements for **new features** in later runs:
   - Do NOT delete existing FR-/NFR- IDs unless explicitly requested by the user.
   - Add new requirements with new IDs (e.g., FR-04, FR-05).
   - Update the Changelog section to reflect what was added or changed.
   - Mark impacted LEGO(s) in the `LEGO(s)` column so you know which ones to update.

6. Run a REVIEW pass (GEN+REVIEW):
   - Critique the clarity and completeness of `requirements.md`.
   - Simplify language where possible (KISS).
   - Append or update a `REVIEW NOTES` subsection in the document, describing:
     - major clarifications,
     - known open questions,
     - any assumptions that should be revisited later.

After `requirements.md` is created/updated according to this template and REVIEWed, you may proceed to the dependencies substep (4.2) and then LEGO discovery.


### 4.2 Dependencies & External Services

**Goal**: Document all external dependencies (APIs, databases, services, packages) in dedicated files to support LEGO planning.

**IMPORTANT: Web Research Required** (from `[P-WEB]` in `.meta/principles.md`):

Before documenting external dependencies, **ALWAYS search online for current information**:

1. **For External APIs** (OpenAI, Anthropic, Azure, AWS, etc.):
   - Search official documentation (e.g., `docs.openai.com`, `docs.anthropic.com`)
   - Verify current API version and endpoints
   - Check authentication methods (API keys, OAuth, custom headers)
   - Document rate limits and pricing tiers
   - Note any deprecation warnings

2. **For Packages/Libraries**:
   - Search package registries (`pypi.org`, `npmjs.com`, `nuget.org`)
   - Verify latest stable version
   - Check for security advisories (CVEs)
   - Review changelogs for breaking changes
   - Note compatibility requirements (Python 3.9+, Node 18+, etc.)

3. **For Cloud Services**:
   - Search provider documentation (`learn.microsoft.com`, `docs.aws.amazon.com`)
   - Verify service configurations and limits
   - Check pricing models
   - Review security best practices

4. **Documentation in `external_services.md`**:
   ```markdown
   ## [Service Name] (Researched YYYY-MM-DD)
   
   **Official Documentation**: [URL]
   **Current Version**: [version]
   **Authentication**: [method]
   **Rate Limits**: [limits]
   **Pricing**: [pricing model]
   **Security Notes**: [any CVEs or best practices]
   
   **Last Verified**: YYYY-MM-DD ← Use actual current date
   ```

**Files to Create/Update**:

Immediately after finalizing `requirements.md`, identify ALL dependencies needed and capture them in durable files.

You MUST generate:

- `dependencies.md`
  - Human-readable summary of:
    - runtime dependencies (language/runtime, frameworks, libraries),
    - development/test tools (linters, test frameworks),
    - external services/APIs and their roles.

- A language-appropriate runtime dependencies file, such as:
  - `requirements.txt` (Python), or
  - `package.json` (Node), or
  - equivalent for the chosen stack.

- A dev-deps section (e.g., `devDependencies` in `package.json` or `deps_dev.txt`).

- `.env.example` (or an equivalent file under `config/`)
  - Contains **only** names and comments for required environment variables.
  - Never store real secrets here.

- `external_services.md`
  - For each API/service:
    - name,
    - purpose,
    - free vs paid,
    - link to documentation,
    - how to get a key or subscription,
    - which env vars from `.env.example` it uses,
    - notable rate limits or quotas.

Behavior:

- For each paid or potentially paid service:
  - Ask the user explicitly **before** assuming it can be used:
    - “Do you already have, or are you willing to obtain, an API key for <Service>?”
  - If the user says NO:
    - Prefer local/open-source or free alternatives.
    - Or mark this integration as optional and do not block core functionality.

- For free-tier APIs:
  - Document rate limits in `external_services.md`.
  - Still require that any keys be supplied via environment variables.

You MUST NOT proceed to LEGO discovery or any building/fixing until:

- `requirements.md` exists and is reasonably complete.
- `dependencies.md`, the runtime deps file, `.env.example`, and `external_services.md` have been written.

If no viable data source or dependency set can satisfy the requirements:

- Clearly describe this in `dependencies.md` and `external_services.md`.
- Stop, explaining why the requirements are impossible without some external integration.

### 4.3 Essence & Value Proposition Discovery

**CRITICAL**: This step ensures the app solves the RIGHT problem, not just solves it correctly.

After finalizing `requirements.md` and `dependencies.md`, explicitly discover and document the app's **essence** and **value proposition**.

You MUST create `essence.md` with the following structure:

#### Problem Statement
- **What problem does this solve?** (1-2 sentences)
- **Who has this problem?** (target users/personas)
- **Why does it matter?** (impact if unsolved)
- **What pain points exist today?** (with current solutions)

#### Unique Value Proposition (UVP)
- **What makes this better than alternatives?** (competitive differentiation)
- **Core value delivered:** (the "soul" of why this app exists)
- **Key innovation or advantage:** (technical, UX, cost, simplicity, etc.)

#### Competitive Landscape
- **Existing solutions:** (alternatives users have today)
- **Their strengths:** (what they do well)
- **Their weaknesses:** (gaps or friction points)
- **Our differentiation:** (how we're better/different)

#### Success Metrics (Essence-Driven)
Define **how we measure if the app is delivering its core value**.

Domain-specific examples:

**Performance/Scale Apps** (databases, infrastructure):
- Primary: Latency (p50, p95, p99), throughput (ops/sec, GB/sec)
- Secondary: Cost per operation, resource utilization
- Benchmark: "10x faster than PostgreSQL at same scale"

**Simplicity/Experience Apps** (developer tools, SaaS):
- Primary: Time-to-first-value (minutes), cognitive load (steps to complete task)
- Secondary: User retention (day 7, day 30), NPS score
- Benchmark: "Developer productive in <5 minutes"

**Data/Analytics Apps** (BI tools, dashboards):
- Primary: Query latency, data freshness, insight accuracy
- Secondary: Dashboard load time, data coverage
- Benchmark: "Sub-second queries on billion-row tables"

**Financial/Trading Apps** (OptionsTrader, portfolio tools):
- Primary: Signal quality (precision, recall), risk-adjusted returns (Sharpe ratio)
- Secondary: Win rate, max drawdown, latency to market
- Benchmark: "Sharpe ratio >1.5, consistently outperform S&P 500"

**Developer Tools** (CLIs, SDKs, frameworks):
- Primary: Lines of code to achieve task, build/deploy time
- Secondary: Learning curve (time to competence), extensibility
- Benchmark: "Deploy in 1 command, extend in <50 LOC"

Select metrics appropriate to this app's domain and essence. Be specific with targets.

#### User Journey (End-to-End)
Map the **complete user experience** from discovery to ongoing value:

1. **Discovery/Getting Started**:
   - How do users find and install the app?
   - Time to first "aha" moment?
   - Setup friction points?

2. **First Value**:
   - What is the first meaningful outcome users achieve?
   - How long does it take? (target: minutes, not hours)
   - What can go wrong? (error scenarios)

3. **Core Workflow** (Essence Delivery):
   - What is the main value-generating workflow?
   - How frequently do users execute it? (daily, hourly, per-transaction)
   - What are the critical path steps?

4. **Ongoing Usage**:
   - How does value compound over time?
   - What keeps users engaged?
   - How do we measure long-term success?

5. **Edge Cases & Failure Modes**:
   - What happens when things go wrong?
   - Graceful degradation strategy?
   - How do users recover?

#### Review & Validation

Run a REVIEW pass:
- Does the UVP clearly differentiate from alternatives?
- Are success metrics measurable and tied to core value?
- Is the user journey realistic and complete?
- Are we solving the RIGHT problem (not just solving it right)?

**IMPORTANT**: If the UVP is weak, or success metrics are vague, STOP and refine with the user.

After `essence.md` is complete and REVIEWed, proceed to LEGO discovery (Section 5).

---

## 5. LEGO DISCOVERY (KISS-DRIVEN, ESSENCE-FIRST)

**╔═══════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**╚═══════════════════════════════════════════════════════════════╝**

Using `requirements.md` and **`essence.md`** (NOT `intent.md`):

- Identify LEGO blocks following KISS and single-responsibility principles.
- **Prioritize LEGOs based on essence delivery**:
  
  1. **Core Value LEGOs** (implement the essence FIRST):
     - These deliver the unique value proposition directly
     - Example (OptionsTrader): `signal_generator` (generates alpha)
     - Example (Database): `query_optimizer` (delivers speed)
     - Example (DevTool): `one_command_deploy` (delivers simplicity)
     - **Validation**: These LEGOs must have success metrics from `essence.md`
  
  2. **Supporting LEGOs** (enable core value):
     - Infrastructure needed for core value LEGOs to work
     - Example: `market_data_fetcher`, `greeks_calculator` (support signal generation)
     - Example: `storage_engine`, `index_manager` (support query optimization)
  
  3. **Config Validation LEGO** (always first to implement):
     - Type: `config_validation`
     - Responsibility: Validate all required configuration and guide setup
     - See `CONFIG_VALIDATION.md` for complete requirements

- **ALWAYS generate a `config_validator` LEGO first** (see [P-CONFIG] in `.meta/principles.md`):
  - Type: `config_validation`
  - Responsibility: Validate all required configuration and guide setup
  - Inputs: `.env`, config files, external service endpoints (from `external_services.md`)
  - Outputs: Validation report, setup wizard if needed
  - Priority: Critical (dependency for all other implementation LEGOs)
  - See `CONFIG_VALIDATION.md` for complete requirements
  
- For each remaining LEGO, define:
  - name,
  - type: `implementation` | `integration_test` | `system_test` | `config_validation`,
  - single responsibility,
  - inputs,
  - outputs,
  - assumptions,
  - fundamentals: performance, scalability, quality, security, privacy, cost,
  - `sensitive`: whether it handles sensitive data,
  - `needs_agent`: whether it requires LLM/agent reasoning,
  - `dependencies`: other legos this LEGO depends on,
  - `priority_tier`: `core_value` | `supporting` | `config_validation`,
  - `essence_metric`: which metric from `essence.md` this LEGO impacts,
  - evaluation harness requirements.

Write all this to `lego_plan.json`.

Split any LEGO that attempts to do more than one job.

**Implementation Order**:
1. `config_validator` (dependency for everything)
2. Core value LEGOs (deliver essence)
3. Supporting LEGOs (enable core value)
4. Test LEGOs (validate essence delivery)

---

## 6. OPTIONAL LEGO PLAN APPROVAL & APP ORCHESTRATION

**╔═══════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**╚═══════════════════════════════════════════════════════════════╝**

After generating `lego_plan.json`:

1. **Generate APP_ORCHESTRATION.md** (app-specific orchestration plan):
   - Use `templates/.app_orchestration.template.md` as the structure.
   - Fill in all sections with app-specific details:
     - Application overview (from `app_intent.md` and `requirements.md`)
     - LEGO architecture breakdown (from `lego_plan.json`)
     - Session execution plan (dependency graph, parallel groups)
     - Risk & confidence assessment (from LEGO confidence scores)
     - Wisdom & patterns applied (from intuition checks)
     - Testing strategy (unit, integration, system)
     - Documentation plan
     - Success criteria
   - This file becomes the **human-readable orchestration plan** specific to THIS app.
   - Mark as [IN_PROGRESS] initially.

2. **Optional Human Approval**:
   - If `"require_lego_plan_approval": true` in `meta_config.json`:
     - Show a concise summary of LEGOs and architecture to the user.
     - Reference `APP_ORCHESTRATION.md` for full details.
     - Ask:
       > "Do you approve this LEGO plan and orchestration? See APP_ORCHESTRATION.md for details. Reply YES to continue, or provide changes."
     - If the user requests changes:
       - Update `lego_plan.json`, `APP_ORCHESTRATION.md` accordingly.
       - Confirm the updated structure.
   - If `"require_lego_plan_approval": false`, skip this pause and proceed automatically.

3. **Update APP_ORCHESTRATION.md status** to [IN_PROGRESS] and proceed to pipeline execution.

---

## 7. PIPELINE PLANNING & GLOBAL STATE

**╔═══════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**╚═══════════════════════════════════════════════════════════════╝**

Create or update:

- `plan.md` – a human-readable overview of steps and dependencies.
- `orchestrator_state.json` – global pipeline state, including:
  - `preflight_run`: `true` (MUST be set after pre-flight checklist completes) | `false` (agent forgot pre-flight)
  - `manifest_updated`: `true` (set at Phase 11.2 after .meta-manifest.json updated) | `false` (not yet complete)
  - `current_phase`: "Phase_0" | "Phase_1" | ... | "Phase_12" (tracks pipeline progress)
  - `steps`: each with `id`, `name`, `inputs`, `output`, `depends_on`.
  - `status`: `pending`, `running`, `done`, `failed`.
  - `failure_count`.
  - `env_status` (if applicable).

**State Guards** (defense against amnesia):
- Before Phase 4: HALT if `preflight_run != true` (agent forgot pre-flight checklist)
- Before Phase 12 COMPLETE: HALT if `manifest_updated != true` (agent forgot to update manifest)

Use this state to determine which steps are READY to run on each invocation.

---

## 8. LEGO-ORCHESTRATOR SESSIONS (ONE PER LEGO)

**╔═══════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**╚═══════════════════════════════════════════════════════════════╝**

For each LEGO in `lego_plan.json`, launch a dedicated Codex session as a LEGO-Orchestrator.

Each LEGO-Orchestrator MUST:

1. Read:
   - its LEGO entry in `lego_plan.json`,
   - `.meta/principles.md` (including [P-INTUITION]),
   - `meta_config.json`,
   - `lego_state_<name>.json` (create if missing),
   - Wisdom files (Phase 1.5):
     - `.meta/wisdom/engineering_wisdom.md`,
     - `.meta/wisdom/strategic_wisdom.md`,
     - `.meta/wisdom/design_wisdom.md`,
     - `.meta/wisdom/risk_wisdom.md`,
     - `.meta/patterns/antipatterns.md`,
     - `.meta/patterns/success_patterns.md`,
     - `.meta/patterns/trade_off_matrix.md`,
   - any existing files under `src/`, `tests/`, or docs relevant to that LEGO.

2. Execute substeps for that LEGO (with GEN+REVIEW where appropriate):

   - **DESIGN**:  
     - Consult wisdom files ([P-INTUITION]):
       - Check `.meta/patterns/success_patterns.md` for applicable patterns.
       - Use `.meta/patterns/trade_off_matrix.md` for design decisions.
       - Apply triggers from `.meta/wisdom/engineering_wisdom.md` and `.meta/wisdom/design_wisdom.md`.
       - Check `.meta/patterns/antipatterns.md` for potential issues.
     - Define the LEGO's interface, behavior, and data flow.  
     - Calculate confidence score (domain knowledge, requirements clarity, risk level, precedent match).
     - Run a REVIEW pass to simplify and align with KISS and `.meta/principles.md`.

   - **TEST AUTHORING**:  
     - Write tests for the LEGO’s behavior, edge cases, and errors.  
     - REVIEW tests for coverage and clarity.

   - **LEGO DOCUMENTATION**:  
     - Internal notes (why, trade-offs, alternatives).  
     - Document intuition checks:
       - Which wisdom principles were applied.
       - Which antipatterns were avoided.
       - Which trade-offs were resolved and how.
     - Optional public-facing docs if helpful.  
     - REVIEW for accuracy and usability.

   - **CODING (Implementation)**:  
     - **Web Research for External Dependencies** (from `[P-WEB]` in `.meta/principles.md`):
       - If LEGO uses external APIs: Search official documentation for current endpoints, authentication, parameters
       - If LEGO installs packages: Search package registries for latest versions and security advisories
       - If LEGO uses framework-specific patterns: Verify current best practices from official docs
       - If LEGO handles security-critical operations: Check current CVEs and OWASP guidance
       - Document research findings in code comments and design docs
     - Apply engineering wisdom triggers (complexity, optimization, readability).
     - Implement the LEGO in `src/<lego>.<ext>`.  
     - REVIEW code for clarity, correctness, and simplicity.
     - Pattern match: check for antipatterns during implementation.

   - **VALIDATION**:  
     - Run tests and any relevant commands (e.g., `pytest`, `npm test`, lint).  
     - If LEGO is `sensitive` or risk level is CRITICAL/HIGH:
       - Apply `.meta/wisdom/risk_wisdom.md` security principles.
     - If `r_and_d_mode` is `"thorough"`:
       - Build/run an evaluation harness for this LEGO.
       - If `sensitive = true`, run a REDTEAM REVIEW focused on privacy/security issues and record findings.

3. Session hygiene:

   - After about 3–5 substantial Codex tasks within a LEGO-Orchestrator session:
     - Update `lego_state_<name>.json` with:
       - Progress and any `failure_count` changes.
       - Confidence score and factors (Phase 1.5).
       - Intuition check: wisdom applied, antipatterns avoided, trade-offs resolved.
     - Exit the session intentionally.
   - The Meta-Orchestrator will later relaunch the LEGO-Orchestrator in a fresh session as needed.

   State format (with Phase 1.5 intuition tracking):
   ```json
   {
     "lego_name": "example",
     "status": "design_done",
     "confidence_score": 0.85,
     "confidence_factors": {
       "domain_knowledge": 0.9,
       "requirements_clarity": 0.8,
       "risk_level": "medium",
       "precedent_match": 0.9
     },
     "intuition_check": {
       "wisdom_applied": ["Thompson #5: Do one thing well"],
       "antipatterns_avoided": ["God Object"],
       "trade_offs_resolved": {"simplicity_vs_power": "simplicity (KISS)"}
     },
     "failure_count": 0
   }
   ```

---

## 9. GEN + REVIEW PATTERN

**╔═══════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**╚═══════════════════════════════════════════════════════════════╝**

For each artifact (requirements, design, tests, docs, implementation):

- **GEN**:
  - Create the initial artifact.
  - **For artifacts involving external dependencies**: Apply `[P-WEB]` principle from `.meta/principles.md`:
    - Search online documentation for current API patterns, package versions, security advisories
    - Document sources and research date in artifact's REVIEW NOTES
- **REVIEW**:
  - Critically evaluate the artifact and refine it.
  - **Verify currency**: Check if artifact uses current patterns (not deprecated APIs, outdated packages)
  - If external dependencies detected: Confirm web research was performed, sources are authoritative
  - Append a `REVIEW NOTES` section explaining changes, known limitations, and TODOs.
  - Include web research summary if applicable (sources, dates, key findings)

Apply this pattern consistently across the pipeline.

---

## 10. SAFETY VALVES

**╔═══════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**╚═══════════════════════════════════════════════════════════════╝**

Track `failure_count` for:

- global steps in `orchestrator_state.json`,
- per-LEGO substeps in `lego_state_<name>.json`.

If a step or substep hits `failure_count >= 3` or the pipeline stalls (no progress across runs):

- Mark the affected step/lego as `"stuck"`.
- Write `meta_error.md` describing:
  - which step/lego failed,
  - what was attempted,
  - what the user should adjust (e.g., `app_intent.md`, `.meta/principles.md`, dependencies).
- Avoid further retries for that part until the user modifies the setup.

---

## 11. END-TO-END EXPERIENCE VALIDATION & DOCUMENTATION

**╔═══════════════════════════════════════════════════════════════╗**
**║ 🚨 CRITICAL CHECKPOINT: Did you run PRE-FLIGHT CHECKLIST? 🚨 ║**
**║ 📝 REMINDER: Update .meta-manifest.json at Phase 11.2! 📝     ║**
**╚═══════════════════════════════════════════════════════════════╝**

Before declaring the app complete, validate that it delivers its essence and provides excellent user experience.

### 11.1 Experience Validation (Essence-Driven)

Using `essence.md` as the guide, validate the complete user journey:

#### Getting Started Assessment
- **Can users achieve first value quickly?**
  - Target from `essence.md` User Journey section
  - Test setup process end-to-end
  - Identify friction points (confusing errors, missing docs, unclear next steps)
  - Measure: Time from "git clone" to first meaningful outcome
- **Config Validation Works?**
  - `config_validator` LEGO guides users through setup
  - Clear error messages for missing/invalid config
  - Links to documentation for obtaining API keys

#### Core Workflow Validation (Essence Delivery)
- **Does the app deliver its UVP?**
  - Test the main value-generating workflow from `essence.md`
  - Measure against success metrics defined in `essence.md`
  - Example (OptionsTrader): Run signal generator, measure Sharpe ratio
  - Example (Database): Run query benchmark, measure p99 latency
  - Example (DevTool): Deploy sample app, measure time and complexity
- **Are success metrics measurable?**
  - Instrumentation in place to collect metrics
  - Dashboard or reporting for tracking over time
  - Comparison against benchmarks from `essence.md`

#### Failure Mode Validation
- **What happens when things go wrong?**
  - Test error scenarios from `essence.md` User Journey
  - Graceful degradation (partial functionality vs complete failure)
  - Clear error messages with recovery guidance
  - Circuit breakers and retry logic working
- **Can users recover?**
  - Self-healing mechanisms
  - Manual recovery procedures documented
  - State persistence and recovery

#### Continuous Improvement Setup
- **How will we know if value degrades over time?**
  - Monitoring and alerting for essence metrics
  - Regular benchmarking against competitors
  - User feedback collection mechanism
  - A/B testing infrastructure (if applicable)

#### Documentation for User Journey
- **README covers complete journey**:
  - Problem statement (why this exists)
  - Quick start (<5 minutes to first value)
  - Core workflow examples
  - Success metrics explanation
  - Troubleshooting common issues
- **AGENTS.md includes user journey context**:
  - Future developers understand the end-user experience
  - Which LEGOs impact which parts of journey
  - How to add features without breaking experience

**Output**: Create `experience_validation.md` documenting:
- Test results for each user journey phase
- Success metrics achieved vs targets from `essence.md`
- Identified friction points and recommendations
- Continuous improvement plan

**CRITICAL**: If core value delivery cannot be validated, or success metrics fall short of targets, STOP and reassess before declaring complete.

### 11.2 Final Documentation

When all LEGOs are `done` AND experience validation passes:

- Generate/update:
  - **`AGENTS.md`** (root) – **App-specific agent instructions** for future AI-assisted development:
    - **Use `.meta/templates/AGENTS.template.md` as the base template**
    - **Fill in app-specific sections**:
      - **Application Context**: Purpose, domain, key features (from `app_intent.md` and `requirements.md`)
      - **Essence & Value Proposition**: Problem statement, UVP, success metrics (from `essence.md`)
      - **User Journey**: Complete experience map from discovery to ongoing value (from `essence.md`)
      - **LEGO Architecture**: Breakdown with rationale (why this decomposition? cite Thompson #5, KISS)
      - **Core Value LEGOs**: Which LEGOs deliver the essence, why they're prioritized
      - **Wisdom Applied**: Which principles guided design decisions (from `.meta/wisdom/engineering_wisdom.md`)
      - **Antipatterns Avoided**: What mistakes were prevented (from `.meta/patterns/antipatterns.md`)
      - **Success Patterns Used**: Circuit Breaker, Config Validator, etc. (from `.meta/patterns/success_patterns.md`)
      - **Trade-offs Resolved**: Key decisions and alternatives considered (from `.meta/patterns/trade_off_matrix.md`)
      - **Development Guidelines**: Domain-specific constraints, coding standards, testing requirements
      - **Common Tasks**: "To add feature X, modify LEGO Y because..." (guide for future changes)
      - **Project Structure**: Where things live and why (src/, tests/, config/)
      - **Meta-Orchestrator Reference**: "For orchestration details, see `.meta/AGENTS.md`"
      - **Principles Reference**: "For global design principles, see `.meta/principles.md`"
      - **Wisdom Resources**: "For engineering wisdom, see `.meta/wisdom/` directory"
      - **Patterns Resources**: "For patterns and antipatterns, see `.meta/patterns/` directory"
    - This file should be **comprehensive and self-contained** - include all architectural decisions, wisdom applied, and development guidelines
    - Future developers (human or AI) should understand the app's design philosophy from this file alone, with `.meta/` as reference for deeper orchestration details
    - **The template ensures the app orchestrator has the same Pre-flight Checklist** to avoid amnesia during maintenance
  - **`.github/agents/meta-app-orchestrator.agent.md`** (for VS Code Copilot agent dropdown):
    - **Use `.meta/templates/agent.template.md` as the base template**
    - Replace `{APP_NAME}` with actual app name (from `app_intent.md`)
    - Agent name: "Meta-App-Orchestrator" (consistent across all apps)
    - Agent description: "Build and maintain {APP_NAME}"
    - This enables custom agent mode in VS Code Copilot dropdown
    - **CRITICAL**: Agent references `AGENTS.md` (root) for complete instructions (NOT `.meta/AGENTS.md`)
    - **VALIDATION**: Verify generated file contains "You read `AGENTS.md` (root)" on line 16
    - **VALIDATION**: Verify file does NOT say "read `.meta/AGENTS.md`" anywhere
    - Provides quick activation: select "Meta-App-Orchestrator" from dropdown in Copilot Chat
    - Makes app orchestrator discoverable without remembering activation phrases
  - `README.md` – user-focused documentation of the app.
  - `internal-notes.md` – technical notes, architecture rationale, and trade-offs.
  - `review.md` – system-level review, including:
    - architecture summary,
    - fundamentals (perf/scale/security/privacy/cost),
    - evaluation harness outcomes,
    - red-team findings (if any),
    - known limitations,
    - recommended future improvements.

- **Finalize APP_ORCHESTRATION.md**:
  - Update all execution log checkpoints with final status.
  - Fill in final approval section:
    - Overall confidence score.
    - All critical LEGOs validated.
    - Security review complete (if applicable).
    - Documentation complete.
    - Ready for deployment assessment.
  - Mark status as [COMPLETE].
  - This file serves as the **permanent record** of app-specific orchestration decisions.

- **If NEW APP MODE** (`.meta-version` did not exist at start):
  - Write `.meta-version` file (copy from `templates/.meta-version.template`, update dates to current date).
  - Write `.meta-manifest.json` file (copy from `templates/.meta-manifest.template.json`, populate with actual generated files and timestamps using current date).
  - Mark all generated files with `user_modified: false` initially.
  - Include `APP_ORCHESTRATION.md` in manifest as a generated file.

**╔═══════════════════════════════════════════════════════════════════════════════╗**
**║ 🚨 MANIFEST VALIDATION GATE: Before marking COMPLETE                         ║**
**║                                                                               ║**
**║ REQUIRED CHECKS (HALT if any fail):                                          ║**
**║ 1. Does `.meta-manifest.json` exist?                                         ║**
**║ 2. Does it contain all generated files (AGENTS.md, README.md, etc.)?         ║**
**║ 3. Are timestamps recent (within last hour)?                                 ║**
**║ 4. Set orchestrator_state.json: manifest_updated = true                      ║**
**║                                                                               ║**
**║ If checks pass: Mark APP_ORCHESTRATION.md status as [COMPLETE]               ║**
**║ If any check fails: STOP and update manifest before proceeding               ║**
**╚═══════════════════════════════════════════════════════════════════════════════╝**

---

## 12. RESTARTABILITY

On each new meta run or `codex exec resume --last`:

- Read:
  - `orchestrator_state.json`,
  - `lego_plan.json`,
  - all `lego_state_<name>.json` files.
- Determine which steps/legos are READY (dependencies satisfied, not stuck).
- Launch only those sessions.
- Continue until:
  - the pipeline completes successfully, or
  - a safety valve halts execution with clear guidance.

---

## GOAL SUMMARY

You must:

- Use `intent.md` to understand **how** the meta pipeline should operate.
- Use `app_intent.md` to understand **what** application to build.
- Use `.meta/principles.md` and `meta_config.json` to constrain and tune behavior.
- Decompose the app into KISS LEGO blocks.
- Run per-LEGO orchestrators with GEN+REVIEW substeps.
- Maintain session hygiene, checkpoints, and restartable state.
- Apply safety valves and red-team evaluation when appropriate.
- Produce a complete, well-tested, well-documented system (or a clear error state with instructions for the user).
