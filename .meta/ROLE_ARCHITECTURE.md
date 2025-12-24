# Role-Based Architecture

## Overview

The meta-orchestrator v1.9.0 introduces a role-based model that mirrors how real software teams operate. Instead of a single "super-agent," the system now orchestrates distinct roles with specific responsibilities, artifacts, and handoff points.

**Important**: These are TEMPLATES, not prescriptions. See `CUSTOMIZING_ROLES.md` for guidance on which roles and workflows your app actually needs.

---

## Orchestration Layer & Sponsor (Human Owner)

These are not peer roles to PM/Architect/Developer; they sit **above** the role pool.

| Role | Purpose | Interaction Rule |
|------|---------|------------------|
| **Meta-Orchestrator (engine)** | Builds/upgrades apps by running the engine pipeline | Interacts with the **Sponsor** during engine operations |
| **App Orchestrator (app owner)** | Owns delivery of a specific app by sequencing roles and integrating outputs | **Only role that communicates with the Sponsor** |
| **Sponsor (human owner)** | Provides app intent, constraints, and approvals | Communicates **only** with the App Orchestrator |

**Key Principle**: The App Orchestrator is accountable for essence alignment and integration quality. Roles produce artifacts; the App Orchestrator integrates and enforces gates.

---

## Sub-Agent Mapping (MCP / Parallel Runtimes)

- **Primary session**: App Orchestrator (coordinates, integrates, gates)
- **Sub-agents**: Every active role in the role pool (Essence Analyst, PM, Architect, Designer, Developer, Tester, Writer, Operations, and any active GTM roles)
- **Sponsor**: Human owner (never a sub-agent)

**Tool-Agnostic Rule**: Role definitions are tool-agnostic. Any tools mentioned are optional examples, not requirements.

---

## Core Roles

**Note**: These are TEMPLATES. See `CUSTOMIZING_ROLES.md` for guidance on which roles your app needs.

**Decision-Critical Role**:
- **Strategy Owner (Domain Expert)** is REQUIRED when the app’s value depends on a domain decision framework (finance, medical, legal, safety, etc.).

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         META-ORCHESTRATOR                                    │
│                      (Coordinates All Roles)                                 │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
        ▼                      ▼                      ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│   PRODUCT     │    │   ARCHITECT   │    │   DEVELOPER   │
│   MANAGER     │    │               │    │               │
└───────┬───────┘    └───────┬───────┘    └───────┬───────┘
        │                    │                    │
        │                    │                    │
        ▼                    ▼                    ▼
┌───────────────┐    ┌───────────────┐
│    TESTER     │    │  TECHNICAL    │
│               │    │    WRITER     │
└───────────────┘    └───────────────┘
```

### Role Summary

| Role | Primary Question | Key Artifacts |
|------|------------------|---------------|
| **Product Manager** | "Are we building the RIGHT thing?" | Feature Specs (FR-XXX) |
| **Architect** | "Is the design SOUND?" | Design Decisions (DD-XXX) |
| **Developer** | "Is the implementation CORRECT?" | Source Code, Unit Tests |
| **Tester** | "Does it WORK as specified?" | Test Plans (TP-XXX), Bug Reports (BUG-XXX) |
| **Technical Writer** | "Can users UNDERSTAND it?" | Documentation |

---

## Extended Role Pool (Optional)

These roles are used **only when the app requires them**:

- **Essence Analyst**: Defines and protects the core value proposition (REQUIRED)
- **Strategy Owner (Domain Expert)**: Defines the decision framework and benchmarks (REQUIRED for decision-critical apps)
- **Monetization Strategist**: Pricing and value capture
- **Growth Marketer**: Acquisition, activation, retention
- **Evangelist**: Narrative, demos, community assets

## The Essence Triangle (Product Manager's Core Model)

Every product decision must satisfy THREE constraints:

```
                    CUSTOMER VALUE
                    (Desirability)
                          ▲
                         / \
                        /   \
                       /     \
                      /       \
                     /         \
    BUSINESS IMPACT ───────────── PRODUCT BUILDING
       (Viability)               (Feasibility)
```

- **Customer Value**: What do users get? Is there evidence they want it?
- **Business Impact**: What does the business get? How is value captured?
- **Product Building**: Can we build it? With what effort and risk?

**All three must be true, or the feature should not proceed.**

---

## Artifact Lifecycle

### Immutable Artifacts (Append-Only History)

Once approved, these artifacts are NEVER modified. Changes create NEW artifacts that reference the old.

| Artifact | Pattern | Owner | Purpose |
|----------|---------|-------|---------|
| Feature Spec | `specs/features/FR-XXX-*.md` | PM | What to build and why |
| Enhancement Spec | `specs/enhancements/EN-XXX-*.md` | PM | Changes to existing features |
| Strategy Spec | `specs/strategy/STR-XXX-*.md` | Strategy Owner | Decision framework + benchmarks |
| Design Decision | `specs/designs/DD-XXX-*.md` | Architect | How to build it |
| Test Plan | `specs/tests/TP-XXX-*.md` | Tester | How to verify it |
| Bug Report | `specs/bugs/BUG-XXX-*.md` | Tester | Deviations from spec |

**Why Immutable?**
- Audit trail: Why was this built?
- No spec drift: Reality matches documentation
- Clear references: New work references old decisions
- Accountability: Approvals are meaningful

### Living Artifacts (Current State of Truth)

These evolve with the system:

| Artifact | Location | Owner | Purpose |
|----------|----------|-------|---------|
| Source Code | `src/` | Developer | Implementation |
| Tests | `tests/` | Developer/Tester | Verification |
| Documentation | `docs/` | Writer | User guidance |
| Architecture | `architecture.md` | Architect | Current structure |
| Component Plan | `lego_plan.json` | Architect | Current components |

---

## Three Workflows

### 1. New Feature Workflow
```
Essence Validation (Essence Analyst) → 
Strategy Definition (Strategy Owner, if decision-critical) → 
PM Discovery → Architect Design → Developer Implementation → 
Tester Validation → Writer Documentation → Ops Review (if applicable) → 
PM Final Acceptance → Release
```

### 2. Enhancement Workflow
```
Essence Validation (Essence Analyst) → 
Strategy Check (Strategy Owner, if decision logic changes) → 
PM Enhancement Spec (references original) → 
Architect Delta Design (references original) → 
Developer Implementation (preserve + extend) → 
Tester Regression + New Tests → 
Writer Update Docs → Ops Review (if applicable) → 
PM Final Acceptance
```

### 3. Bug Fix Workflow
```
Tester/User Discovery → PM/Architect Triage → 
Developer Root Cause + Fix → 
Tester Verification → 
Writer/PM Update Docs + Version → 
Ops Review (if applicable) → 
PM Final Acceptance → Close
```

---

## Directory Structure (Generated Apps)

```
my-app/
├── .meta/                     # Engine (from meta-metacognition)
│   ├── roles/                 # Role definitions
│   ├── workflows/             # Workflow definitions
│   ├── artifacts/             # Artifact templates
│   ├── principles.md          # Global principles
│   └── wisdom/                # Engineering wisdom
│
├── specs/                     # IMMUTABLE specifications
│   ├── features/              # FR-XXX feature specs
│   │   ├── FR-001-user-auth.md
│   │   └── FR-002-reporting.md
│   ├── strategy/              # STR-XXX strategy specs
│   │   └── STR-001-trading-strategy.md
│   ├── enhancements/          # EN-XXX enhancement specs
│   │   └── EN-001-enhance-reporting.md
│   ├── designs/               # DD-XXX design decisions
│   │   ├── DD-001-auth-approach.md
│   │   └── DD-002-report-format.md
│   ├── tests/                 # TP-XXX test plans
│   │   └── TP-001-auth-tests.md
│   └── bugs/                  # BUG-XXX bug reports
│       └── BUG-001-login-timeout.md
│
├── src/                       # LIVING implementation
├── tests/                     # LIVING test code
├── docs/                      # LIVING documentation
│
├── essence.md                 # Core value proposition
├── architecture.md            # Current architecture
├── lego_plan.json            # Current components
├── requirements.md            # Index of all FR-XXX
└── AGENTS.md                  # App orchestrator
```

---

## Role Handoffs

```
┌─────────┐    FR-XXX     ┌───────────┐    DD-XXX    ┌───────────┐
│   PM    │ ───────────► │ Architect │ ───────────► │ Developer │
└─────────┘               └───────────┘              └─────┬─────┘
     ▲                                                     │
     │                                                     │ Code
     │ BUG-XXX                                             ▼
┌─────────┐                                          ┌───────────┐
│ Tester  │ ◄─────────────────────────────────────── │  Review   │
└────┬────┘                                          └───────────┘
     │
     │ Verified
     ▼
┌─────────┐
│ Writer  │ ───► Documentation
└─────────┘
```

---

## Key Principles by Role

### Product Manager
- **Essence Triangle**: All three constraints must be satisfied
- **Evidence Over Opinion**: Data beats intuition
- **Scope Is a Lever**: Cutting scope is skill, not failure
- **Specs Are Promises**: Immutable once approved

### Architect  
- **Simplicity Over Flexibility**: Build for today, document scaling path
- **Trade-offs Are Explicit**: Document what you sacrificed
- **10-Minute Test**: If you can't explain it quickly, it's too complex
- **Control + Data Flow**: Both must be clean

### Developer
- **Implement the Spec**: Your job is DD-XXX, not your ideas
- **Test First**: TDD forces interface thinking
- **YAGNI**: Don't build what's not specified
- **Debugging is 2x Hard**: Write simple code

### Tester
- **Spec Is Truth**: Test against FR-XXX, not assumptions
- **Edge Cases Live Here**: Happy paths are developer-tested
- **Reproducibility**: If you can't reproduce, you can't prove
- **Independence**: Think differently than developers

### Technical Writer
- **Audience First**: Write for readers, not yourself
- **Task-Oriented**: "How to X" not "The X feature"
- **Test Your Docs**: Follow your own guide
- **Maintenance Is Writing**: Docs need updates

---

## Migration from v1.8.x

### For New Apps
- Automatic: New apps use role-based structure
- `specs/` directory created with subdirectories
- Role templates available

### For Existing Apps
1. Create `specs/` directory structure
2. Migrate existing requirements to FR-XXX format
3. Create DD-XXX for major design decisions
4. Update AGENTS.md with role awareness

### Backward Compatibility
- Existing apps continue to work
- Role-based structure is additive
- No breaking changes to existing artifacts

---

## Benefits

1. **Clarity**: Each role knows their job and artifacts
2. **Traceability**: Every line of code traces to a spec
3. **Quality**: Role-specific review criteria
4. **History**: Immutable specs create audit trail
5. **Maintenance**: Bug fixes and enhancements reference originals
6. **Team Alignment**: Clear handoffs, explicit expectations
7. **AI-Ready**: Roles map to agent specializations
