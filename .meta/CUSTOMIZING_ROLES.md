# Customizing Roles and Workflows

## These Are Templates, Not Prescriptions

The roles and workflows in `.meta/roles/` and `.meta/workflows/` are **starting points**—templates that should be adapted based on your app's specific needs.

---

## Why Templates?

Different apps have different needs:

| App Type | Likely Roles | Likely Workflows |
|----------|--------------|------------------|
| CLI Tool | PM, Developer, Writer | New Feature, Bug Fix |
| Web Service | All 6 roles | All workflows |
| Library/SDK | PM, Developer, Writer, Tester | New Feature, Enhancement |
| Prototype | PM, Developer | Simplified New Feature |
| Internal Tool | PM, Developer, Tester | New Feature, Bug Fix |

**One size does NOT fit all.**

---

## Role Selection Guide

### Always Required
- **Essence Analyst**: Defines and protects the core value proposition (REQUIRED for all apps)
- **Product Manager**: Someone must define WHAT to build and WHY
- **Developer**: Someone must build it

### Usually Required
- **Architect**: For apps with >3 components or complex interactions
- **Tester**: For apps with users who depend on correctness

### Sometimes Required
- **Technical Writer**: For apps with external users who need docs
- **Operations**: For apps deployed to production with uptime needs
- **Monetization Strategist**: ONLY when pricing/revenue model is required
- **Growth Marketer**: ONLY when acquisition/retention loops are a requirement
- **Evangelist**: ONLY when community, demos, or launch assets are required

### Decision Matrix

| Question | If YES → Include Role |
|----------|----------------------|
| Does it have 3+ interacting components? | Architect |
| Do users depend on it working correctly? | Tester |
| Do external users need to understand it? | Technical Writer |
| Does it run in production with uptime needs? | Operations |
| Does it have compliance/security requirements? | Operations + enhanced Tester |
| Does it need a pricing/revenue model? | Monetization Strategist |
| Does it need growth loops or acquisition strategy? | Growth Marketer |
| Does it need community/launch materials? | Evangelist |

---

## Workflow Selection Guide

### New Feature Workflow
**Use when**: Building something that doesn't exist yet
**Simplify when**: Prototype or internal tool (skip formal specs)

### Enhancement Workflow  
**Use when**: Modifying existing functionality
**Simplify when**: Minor changes (may skip formal EN-XXX spec)

### Bug Fix Workflow
**Use when**: Implementation differs from spec
**Simplify when**: Obvious fixes (may skip formal BUG-XXX for typos)

### Workflow Formality Spectrum

```
Informal ◄──────────────────────────────────────► Formal

Personal    Internal    Team         Production   Regulated
Tool        Tool        Project      Service      System
   │            │           │             │           │
   └── Minimal ─┴─── Light ─┴── Standard ─┴── Full ──┘
       specs        specs        specs        specs
```

---

## Customization Examples

### Example 1: Simple CLI Tool

**Roles Used**: PM (light), Developer, Writer (README only)

**Role Adaptations**:
- PM: Skip formal FR-XXX, use README as spec
- Developer: Standard role applies
- Writer: README.md only, no full docs/

**Workflow Adaptation**:
- New Feature: Skip formal spec, use issue description
- Skip Enhancement workflow (everything is just "change")
- Bug Fix: GitHub issue → Fix → Close

### Example 2: Production Web Service

**Roles Used**: All 6

**Role Adaptations**:
- All roles: Use full templates
- Operations: Add runbooks, SLOs, on-call rotation
- Tester: Add load testing, security testing

**Workflow Adaptation**:
- Use full workflows
- Add deployment stage to New Feature workflow
- Add incident workflow for production issues

### Example 3: Internal Business Tool

**Roles Used**: PM, Architect, Developer, Tester

**Role Adaptations**:
- PM: Lighter evidence requirements (stakeholders are known)
- Architect: Standard, but document for handoff
- Writer: Skip (users are internal, can ask questions)
- Operations: Skip (IT handles infrastructure)

**Workflow Adaptation**:
- New Feature: Formal specs but lighter approval process
- Enhancement: Full workflow (changes affect users)
- Bug Fix: Full workflow (correctness matters)

---

## How to Customize

### Step 1: During Initial Planning

PM and Architect discuss:
1. What type of app is this?
2. Who are the users?
3. What are the reliability needs?
4. What roles are needed?

Document decisions in `AGENTS.md` or `architecture.md`.

### Step 2: Create App-Specific Role Docs

For each role you're using, you may:

**Option A**: Reference the template directly
```markdown
## Roles

See `.meta/roles/` for role definitions. We use:
- Product Manager (full)
- Developer (full)
- Tester (light - unit tests only)
```

**Option B**: Copy and adapt
```markdown
## Developer Role (Adapted)

Based on `.meta/roles/developer.md` with these changes:
- Skip formal DD-XXX reference (we use issue descriptions)
- Lighter test coverage target (60% for this prototype)
```

**Option C**: Create app-specific role doc
```markdown
# roles/developer.md

Our developer role for this app...
[Custom content]
```

### Step 3: Document Your Workflow

In `AGENTS.md` or `CONTRIBUTING.md`:

```markdown
## Our Workflow

Based on `.meta/workflows/new_feature.md` with adaptations:

1. **Discovery**: Issue discussion in GitHub
2. **Design**: For complex changes, create design doc
3. **Implementation**: PR with tests
4. **Review**: Code review required
5. **Deploy**: Merge to main → auto-deploy

We skip formal FR-XXX specs for this internal tool.
```

---

## Artifact Formality Guide

### When to Use Formal Specs (FR-XXX, DD-XXX)

✅ **Use formal specs when**:
- Multiple stakeholders need to agree
- Decisions need audit trail
- Handoffs between different people/teams
- Regulated or compliance requirements
- Complex features with many acceptance criteria

❌ **Skip formal specs when**:
- Solo developer, same person decides and builds
- Prototype or throwaway code
- Trivial changes (typos, minor tweaks)
- Team agrees specs are overhead for this project

### Spectrum of Formality

| Level | Spec Format | When to Use |
|-------|-------------|-------------|
| None | No spec | Personal tools, scripts |
| Minimal | Issue description | Internal tools, prototypes |
| Light | Issue with acceptance criteria | Small team projects |
| Standard | FR-XXX with key sections | Team projects, handoffs |
| Full | FR-XXX complete template | Production, regulated |

---

## Role Responsibilities May Shift

In smaller teams, one person may wear multiple hats:

| Team Size | Role Distribution |
|-----------|-------------------|
| 1 person | All roles (light versions) |
| 2-3 people | PM+Architect combo, Developer+Tester combo |
| 4-6 people | Distinct roles, some overlap |
| 7+ people | Full role separation |

**The principles still apply**, even when one person does everything:
- Still ask PM questions (is this valuable?)
- Still apply Architect thinking (is this simple?)
- Still test (does it work?)

---

## Template Modification Guidelines

### What You CAN Customize

✅ **Freely adapt**:
- Which roles to include
- Level of formality for specs
- Approval requirements
- Specific templates and formats
- Role combinations

### What You SHOULD Preserve

⚠️ **Keep the core principles**:
- Essence Triangle thinking (even informally)
- Separation of WHAT vs HOW
- Test before ship
- Document for future maintainers
- Immutable history for important decisions

### What You SHOULD NOT Do

❌ **Don't skip entirely**:
- Thinking about value (PM mindset)
- Thinking about structure (Architect mindset)
- Verifying correctness (Tester mindset)

Even in the lightest workflow, these perspectives matter.

---

## Recording Your Customizations

In your app's `AGENTS.md`:

```markdown
## Role Configuration

This app uses the following roles from `.meta/roles/`:

| Role | Used | Formality | Notes |
|------|------|-----------|-------|
| Product Manager | ✅ | Light | GitHub issues as specs |
| Architect | ✅ | Standard | Design docs for major features |
| Developer | ✅ | Standard | Full TDD |
| Tester | ✅ | Light | Unit tests, manual E2E |
| Technical Writer | ❌ | - | README only |
| Operations | ❌ | - | Runs locally |

## Workflow Configuration

| Workflow | Used | Formality | Notes |
|----------|------|-----------|-------|
| New Feature | ✅ | Light | Issue → PR → Merge |
| Enhancement | ✅ | Light | Same as new feature |
| Bug Fix | ✅ | Minimal | Fix → PR → Merge |

## Artifact Configuration

| Artifact | Used | Location |
|----------|------|----------|
| Feature Specs | ❌ | GitHub issues instead |
| Design Decisions | ✅ | docs/decisions/ |
| Test Plans | ❌ | Tests are self-documenting |
| Bug Reports | ❌ | GitHub issues |
```

---

## Summary

1. **Templates are starting points** - adapt to your needs
2. **Role selection depends on app type** - not all apps need all roles
3. **Workflow formality is a spectrum** - match to project needs
4. **Principles matter more than formats** - keep the thinking, adapt the paperwork
5. **Document your choices** - so future maintainers understand the rules
