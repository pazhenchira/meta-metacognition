# .app/ Folder Generation

## Overview

This document describes how the meta-orchestrator ENGINE generates the `.app/` folder for an application. The `.app/` folder is SELF-CONTAINED—once generated, the app can be maintained without any reference to `.meta/`.

---

## Generation Triggers

| Trigger | Action |
|---------|--------|
| `.app/` doesn't exist | CREATE: Generate full `.app/` folder |
| `.app/.engine-version` < `.meta/VERSION` | UPGRADE: Regenerate with new engine features |
| User requests regeneration | REGENERATE: Rebuild `.app/` preserving customizations |

---

## Generated Structure

```
.app/
├── AGENTS.md                    # SELF-CONTAINED app orchestrator
├── essence.md                   # App's value proposition (from discovery)
├── roles/                       # App-specific role definitions
│   ├── _manifest.md             # Which roles this app uses
│   ├── product_manager.md       # If applicable (adapted from template)
│   ├── architect.md             # If applicable
│   ├── developer.md             # Always included
│   └── ...                      # Other roles as needed
├── workflows/                   # App-specific workflows
│   ├── _manifest.md             # Which workflows this app uses
│   └── ...                      # Adapted workflows
├── wisdom/                      # INLINED subset of wisdom
│   └── core_principles.md       # Key principles for this app
├── patterns/                    # INLINED relevant patterns
│   └── relevant_patterns.md     # Antipatterns + success patterns for this app
└── .engine-version              # Which .meta/VERSION generated this
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
team_size: 1 | small | medium | large
formality: minimal | light | standard | full
decision_critical: true | false
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
| needs_uptime | Operations |
| needs_pricing | Monetization Strategist |
| needs_growth | Growth Marketer |
| needs_evangelism | Evangelist |

### Step 3: Adapt Role Templates

For each selected role:
1. Copy from `.meta/roles/{role}.md`
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

### Step 6: Generate Self-Contained AGENTS.md

The generated `.app/AGENTS.md` must:
- ❌ NOT reference `.meta/` anywhere
- ❌ NOT use `../` paths to engine files
- ✅ Include all context inline
- ✅ Be fully functional if `.meta/` is deleted

### Step 7: Write .engine-version

```
1.9.0
Generated: 2024-12-04T22:53:00Z
Source: meta-metacognition v1.9.0
```

---

## Self-Containment Rules

### What Gets INLINED (copied into .app/)

| Source | Destination | Why |
|--------|-------------|-----|
| Relevant role definitions | `.app/roles/` | App needs these at runtime |
| Relevant workflows | `.app/workflows/` | App needs these at runtime |
| Core principles | `.app/wisdom/` | Referenced by AGENTS.md |
| Relevant patterns | `.app/patterns/` | Referenced by AGENTS.md |
| Essence | `.app/essence.md` | Core to app identity |

### What Gets REFERENCED (pointer only)

Nothing. The `.app/` folder must be fully self-contained.

### What Stays in .meta/ Only

| Content | Why Not Copied |
|---------|----------------|
| Full wisdom library | Too large, most not relevant |
| All role templates | App only uses selected roles |
| Engine orchestrator | Only needed for create/upgrade |
| Generator scripts | Only needed for create/upgrade |

---

## Upgrade Process

When `.app/.engine-version` < `.meta/VERSION`:

### Step 1: Detect Upgrade

```
Current .app/.engine-version: 1.8.0
Current .meta/VERSION: 1.9.0
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

For each file in `.app/`:
- If user-modified: SKIP (preserve)
- If generated: REGENERATE with new template

### Step 5: Merge Additions

Add new capabilities:
- New roles added to manifest
- New workflows available
- Updated wisdom inlined

### Step 6: Update Version

Write new `.engine-version` with upgrade timestamp.

---

## Template: .app/AGENTS.md (Self-Contained)

See `app_agents.template.md` for the full template.

Key requirements:
1. PERSONA section with identity enforcement
2. Pre-flight checklist (NO .meta/ references)
3. Full app context inline
4. Wisdom principles inline (not referenced)
5. Role summaries inline (not referenced)
6. Workflow summaries inline (not referenced)

---

## Validation

After generation, validate:

- [ ] `.app/AGENTS.md` contains no `.meta/` references
- [ ] `.app/AGENTS.md` contains no `../` paths
- [ ] All wisdom references are inline text
- [ ] All role references point to `.app/roles/`
- [ ] All workflow references point to `.app/workflows/`
- [ ] `.app/.engine-version` matches `.meta/VERSION`
- [ ] App would function if `.meta/` were deleted
