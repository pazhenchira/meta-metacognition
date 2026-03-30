# Project Structure Generation

## Overview

This document describes how the meta-orchestrator ENGINE generates the project structure for an application. The generated structure is SELF-CONTAINED—once generated, the app can be maintained without any reference to the engine's source files.

---

## Generation Triggers

| Trigger | Action |
|---------|--------|
| `.github/agents/` doesn't exist | CREATE: Generate full project structure |
| `.brain/config.yaml` version < engine version | UPGRADE: Regenerate with new engine features |
| User requests regeneration | REGENERATE: Rebuild structure preserving customizations |

---

## Generated Structure

```
project-root/
├── .github/agents/{orchestrator}.agent.md  # Project orchestrator
├── .brain/
│   ├── config.yaml          # Project metadata (nexus-compatible)
│   ├── roles/               # App-specific role definitions
│   ├── playbooks/           # App-specific workflows  
│   ├── wisdom/              # Inlined wisdom subset
│   ├── principles.md        # Core principles for this app
│   ├── lessons.md           # Accumulated corrections
│   └── status.md            # Session state
├── patterns/                # Relevant antipatterns
├── essence.md               # App's value proposition
└── skills/                  # Quality protocols (optional)
```

---

## Generation Process

### Step 1: Discover App Characteristics

From `app_intent.md` and PM discovery, determine:

```yaml
app_type: web_service | cli_tool | library | internal_tool | prototype
has_users: true | false
needs_correctness: true | false
needs_uptime: true | false
has_external_deps: true | false
has_ui: true | false
needs_pricing: true | false
needs_growth: true | false
needs_evangelism: true | false
gtm_agents_available: true | false
gtm_opt_out: true | false
team_size: 1 | small | medium | large
formality: minimal | light | standard | full
decision_critical: true | false
system_of_systems: true | false
repo_role: system | app | shared
coordination_mode: standalone | federated | tracked | governed
```

### Step 2: Select Roles

Based on characteristics:

| Characteristic | Roles Included |
|---------------|----------------|
| Always | Essence Analyst, Product Manager (light), Developer |
| has_users + needs_correctness | Tester |
| has_ui | Designer |
| decision_critical | Strategy Owner |
| 3+ components | Architect |
| external users needing docs | Technical Writer |
| Always | Operations (required; scope scales by app type) |
| needs_pricing | Monetization Strategist |
| needs_growth | Growth Marketer |
| needs_evangelism | Evangelist |
| gtm_agents_available + not gtm_opt_out | Monetization Strategist, Growth Marketer, Evangelist |

### Step 3: Adapt Role Templates

For each selected role:
1. Copy from `.brain/roles/{role}.md`
2. Remove sections not applicable to this app
3. Inline any referenced principles
4. Customize examples for this app's domain
5. Preserve **App/Sponsor Overrides** block (APP_OVERRIDES) for future upgrades

### Step 4: Select and Adapt Workflows

Based on formality level:

| Formality | Workflows |
|-----------|-----------|
| minimal | Simplified new feature only |
| light | New feature, bug fix (simplified) |
| standard | All three workflows |
| full | All workflows with formal specs |

If `repo_role = system` and `coordination_mode` is `tracked` or `governed`, include `system_coordination`.

### Step 5: Inline Wisdom

Extract and inline ONLY the wisdom relevant to this app:

```markdown
# Core Principles for {APP_NAME}

## From Thompson's Unix Philosophy
- "Do one thing well" - Each component has single responsibility

## From KISS
- Simplest correct solution
- No premature abstraction

## From Kernighan
- "Debugging is twice as hard as writing code"
- Write simple code you can debug

[Only include principles that apply to this specific app]
```

### Step 6: Generate Self-Contained Orchestrator Agent

The generated `.github/agents/{orchestrator}.agent.md` must:
- ❌ NOT reference engine source paths anywhere
- ❌ NOT use `../` paths to engine files
- ✅ Include all context inline
- ✅ Be fully functional independently

If `repo_role = system`, generate from `generators/system_agents.template.md`.

### Step 6.2: Generate Agent Context

Create `.brain/context/agent_context.json` from `templates/agent_context.template.json` and fill:
- repo host/provider
- repo type (system/app/component/monorepo/multi-repo)
- cloud provider (if any)
- permissions (git push/PR, deploy, cloud changes)

This file is the canonical operational context for all agents.

### Step 6.5: Sync Essence

`essence.md` (root) is the canonical value proposition. Generated projects use `essence.md` at root
directly for self-contained orchestration.

### Step 6.6: Generate MCP Role Workspaces (Codex MCP)

To prevent role drift, each MCP role server must start in a role-specific workspace that
contains its own `AGENTS.md`.

**Outputs** (one per role server):
- `runtime/mcp/<role>/AGENTS.md`

**Template**:
- `templates/mcp_role_agent.template.md`

**Notes**:
- Each role workspace must be inside the app root (so all files remain accessible).
- `codex_mcp_servers.toml` must set each server `cwd` to the matching role workspace.

### Step 6.7: Generate MCP Config Merge Helper (App Root)

Create a helper script so upgrades can merge MCP blocks into `~/.codex/config.toml`
without overwriting unrelated settings.

**Output**:
- `scripts/merge_codex_mcp_config.py` (create `scripts/` if missing)

**Template**:
- `templates/merge_codex_mcp_config.template.py`

### Step 7: Generate MCP Profile Wrapper Script (App Root)

Codex CLI currently does **not** apply profile-scoped MCP enablement to `mcp list`,
so per-app MCP servers can appear disabled unless explicitly enabled via `-c` flags.
To keep top-level `enabled = false` while still enabling only the target app’s servers,
generate a small wrapper script in the app root.

**Output**:
- `scripts/codex-{APP_SLUG}.sh` (create `scripts/` if missing)

**Template**:
- `templates/codex_mcp_profile_wrapper.template.sh`

**How to populate placeholders**:
- `{APP_SLUG}`: `meta_config.json.app_slug`
- `{APP_PROFILE}`: slug for `--profile` (default: `APP_SLUG` with `_` replaced by `-`)
- `{MCP_ENABLE_FLAGS}`: one `-c "mcp_servers.{server}.enabled=true"` entry per server
  parsed from `runtime/codex_mcp_servers.toml`.

Example injected lines:
```
  -c "mcp_servers.trade_engine__essence_analyst.enabled=true"
  -c "mcp_servers.trade_engine__product_manager.enabled=true"
```

**Notes**:
- The wrapper must pass through all additional CLI args via `"$@"`.
- Mark script executable (`chmod +x`).

### Step 7: Write config.yaml version

The project version is recorded in `.brain/config.yaml` under the `project.version` field.

```yaml
project:
  version: "1.9.0"
  generated: "2024-12-04T22:53:00Z"
  source: "meta-metacognition v1.9.0"
```

---

## Self-Containment Rules

### What Gets INLINED (copied into project)

| Source | Destination | Why |
|--------|-------------|-----|
| Relevant role definitions | `.brain/roles/` | App needs these at runtime |
| Relevant workflows | `.brain/playbooks/` | App needs these at runtime |
| Core principles | `.brain/wisdom/` | Referenced by orchestrator agent |
| Relevant patterns | `patterns/` | Referenced by orchestrator agent |
| Essence | `essence.md` (root) | Core to app identity |

### What Gets REFERENCED (pointer only)

Nothing. The generated project must be fully self-contained.

### What Stays in Engine Only

| Content | Why Not Copied |
|---------|----------------|
| Full wisdom library | Too large, most not relevant |
| All role templates | App only uses selected roles |
| Engine orchestrator | Only needed for create/upgrade |
| Generator scripts | Only needed for create/upgrade |

---

## Upgrade Process

When `.brain/config.yaml` version < engine version:

### Step 1: Detect Upgrade

```
Current .brain/config.yaml version: 1.8.0
Current engine version: 1.9.0
→ UPGRADE NEEDED
```

### Step 2: Identify Changes

Compare engine versions to determine what's new:
- New roles?
- New workflows?
- Updated principles?
- New patterns?

### Step 3: Preserve Customizations

Mark files that user has modified:
- Check git history or file hashes
- Files with user changes are PROTECTED
- Only update generated content

### Step 4: Regenerate

For each generated file:
- If user-modified: SKIP (preserve)
- If generated: REGENERATE with new template

### Step 5: Merge Additions

Add new capabilities:
- New roles added to manifest
- New workflows available
- Updated wisdom inlined
- Wrapper script generated for MCP profile enablement (if missing or template changed)

### Step 6: Update Version

Write new version to `.brain/config.yaml` with upgrade timestamp.

---

## Template: Orchestrator Agent (Self-Contained)

See `app_agents.template.md` for the full template.

Key requirements:
1. PERSONA section with identity enforcement
2. Pre-flight checklist (NO stale `.meta/` or `.app/` references)
3. Full app context inline
4. Wisdom principles inline (not referenced)
5. Role summaries inline (not referenced)
6. Workflow summaries inline (not referenced)

---

## Validation

After generation, validate:

- [ ] `.github/agents/{orchestrator}.agent.md` contains no stale `.meta/` or `.app/` references
- [ ] `.github/agents/{orchestrator}.agent.md` contains no `../` paths
- [ ] All wisdom references are inline text
- [ ] All role references point to `.brain/roles/`
- [ ] All workflow references point to `.brain/playbooks/`
- [ ] `.brain/config.yaml` version matches engine version
- [ ] App would function independently of engine source

---

## Nexus Runtime Integration

### Overview

Generated projects are designed to be hosted by the **nexus runtime gateway**, which provides:
- Content-aware preamble (reads essence.md + principles.md)
- Cross-session memory (LessonStore per project)
- Goal tracking (GoalStore per session)
- Quality enforcement in code (not just prompts)
- Multi-channel access (CLI, Slack, API)

### Nexus-Required Structure

In addition to the structure above, generated projects MUST include these files at project root for nexus compatibility:

| File | Source | Notes |
|------|--------|-------|
| `essence.md` | Generated by Phase 1.8 (Essence Discovery) | Canonical project identity |
| `.brain/config.yaml` | Generated from brain-config.template.yaml (Step 1) | Must contain: `project.name`, `project.version`, `orchestrator.name` |
| `.github/agents/{orchestrator}.agent.md` | Generated from agent template (Step 6) | Nexus project-loader requires `.github/` directory AND this agent file |
| `.brain/lessons.md` | Generated from lessons.template.md (Step 1) | Empty initially; populated through use |
| `.brain/status.md` | Generated from status.template.md (Step 1) | Session re-entrancy state |
| `.brain/principles.md` | Inlined from engine's principles (Step 1) | Domain-adapted for the project |
| `skills/selector.md` | Generated if quality protocols needed | Maps work stages to skills |

### Generation Step: Nexus Registration Prep

After generating the project structure, also generate:
1. A `docs/nexus-registration.md` from `templates/nexus-registration.template.md`
2. Populate placeholders with project name, slug, path, and orchestrator name

### Post-Generation: Nexus Registration

The factory does NOT automatically register projects with nexus (nexus config is outside factory scope). Instead:
1. Generate the registration guide (above)
2. Inform the sponsor: "To host this project through nexus, follow docs/nexus-registration.md"
3. The sponsor (or nexus's own agents) handles the actual config update

### Validation (Extended)

In addition to existing validation checks, verify:
- [ ] `essence.md` exists at project root
- [ ] `.brain/config.yaml` exists with required fields
- [ ] `.github/` directory exists with at least one agent.md
- [ ] `.brain/lessons.md` exists (can be empty template)
- [ ] `.brain/status.md` exists (can be empty template)
