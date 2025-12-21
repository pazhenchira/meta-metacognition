# Workflow: Enhancement

## Overview

This workflow covers modifying or extending an existing feature that was delivered via FR-XXX.

**Key Principle**: Enhancements create NEW specs that REFERENCE the original. The original spec remains immutable, preserving the audit trail of what was originally built and why.

**Review Model**: Each handoff is a review gate. The receiving role reviews and approves before proceeding. See `REVIEW_GATES.md` for detailed criteria.

**Execution Rule**: If runtime supports sub-agents or agent profiles, each phase MUST be executed by the corresponding role agent. Otherwise, role-switch sequentially in a single session.

---

## When to Use This Workflow

Use Enhancement workflow when:
- Adding capability to existing feature
- Modifying behavior of existing feature
- Extending scope of existing feature

Do NOT use this workflow for:
- New unrelated feature (use New Feature workflow)
- Fixing bug (use Bug Fix workflow)
- Refactoring without behavior change (use Refactor workflow)

---

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ENHANCEMENT DISCOVERY                                │
│                          (Product Manager)                                   │
│                                                                              │
│  Read original FR-XXX → Understand delta → Validate Essence Triangle        │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ EN-XXX approved (references FR-XXX)
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ENHANCEMENT DESIGN                                   │
│                            (Architect)                                       │
│                                                                              │
│  Read original DD-XXX → Design delta → Validate compatibility               │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ DD-YYY approved (references DD-XXX)
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        IMPLEMENTATION                                        │
│                          (Developer)                                         │
│                                                                              │
│  Modify existing code → Preserve original behavior → Add new behavior       │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ Code + tests complete
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          VALIDATION                                          │
│                           (Tester)                                           │
│                                                                              │
│  Original tests still pass → New tests pass → Regression verified           │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ All tests pass
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        DOCUMENTATION                                         │
│                       (Technical Writer)                                     │
│                                                                              │
│  Update existing docs → Add enhancement docs → Changelog                    │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Phase 0: Essence Validation (Essence Analyst)

### Trigger
- Any enhancement request

### Activities
1. Validate enhancement aligns with `essence.md`
2. Update `essence.md` if the core value proposition evolves
3. Confirm success metrics remain measurable

### Artifacts Produced
- Updated `essence.md` (LIVING)

### Exit Criteria
- Essence alignment confirmed

### Handoff
- **To**: Product Manager

---

## Phase 1: Enhancement Discovery (Product Manager)

### Trigger
- User request to modify existing feature
- Business need to extend capability
- Technical enablement for new use case

### Activities

1. **Understand Original**:
   - Read original FR-XXX completely
   - Understand original value proposition
   - Identify what was in scope vs. out of scope

2. **Define Delta**:
   - What is changing?
   - What is staying the same?
   - What is the NEW value being added?

3. **Validate Essence Triangle for Enhancement**:
   - Customer Value: Does enhancement serve same users? New users?
   - Business Impact: Does enhancement strengthen original value?
   - Feasibility: Can we modify without breaking original?

4. **Create Enhancement Specification**:
   - File: `specs/enhancements/EN-{NNN}-enhance-{original-name}.md`
   - MUST reference original: `FR-XXX`
   - Clearly state delta (what's added/changed)
   - New acceptance criteria for delta only

### Enhancement Specification Template

```markdown
# Enhancement: EN-XXX-enhance-{feature}

**Date**: YYYY-MM-DD
**Enhances**: FR-XXX ({original feature name})
**Status**: Draft | Approved | Implemented | Verified

## Original Feature Summary
{Brief summary of what FR-XXX delivered}

## Enhancement Summary
{What this enhancement adds/changes}

## Rationale
**Why enhance now**: {Trigger for enhancement}
**Value added**: {New value delivered}
**Alignment with essence**: {How this strengthens core value}

## Changes

### Added
- {New capability 1}
- {New capability 2}

### Modified
- {Changed behavior 1}: was {X}, now {Y}

### Unchanged (Explicitly)
- {Behavior that must NOT change}

## Acceptance Criteria (New)
| ID | Criterion | Testable? |
|----|-----------|-----------|
| EN-AC-1 | {New criterion} | Yes |
| EN-AC-2 | {New criterion} | Yes |

## Backward Compatibility
- [ ] Existing functionality preserved
- [ ] Existing tests still pass
- [ ] No breaking changes for users

## Scope Guard
**Out of scope**: {What this enhancement does NOT do}
```

### Exit Criteria
- EN-XXX approved
- Original FR-XXX understood
- Delta clearly defined
- Backward compatibility assessed

### Handoff
- **To**: Architect
- **Artifacts**: EN-XXX + reference to FR-XXX

### ⮕ REVIEW GATE 1: PM → Architect (Enhancement)
See `REVIEW_GATES.md` for full criteria. Architect reviews:
- [ ] Original FR-XXX is understood
- [ ] Delta is clearly defined
- [ ] Enhancement doesn't break original value
- [ ] Backward compatibility is addressed

**Gate Outcome**: Approve / Approve with Conditions / Reject

---

## Phase 2: Enhancement Design (Architect)

### Trigger
- EN-XXX approved

### Activities

1. **Understand Original Design**:
   - Read DD-XXX (original design)
   - Understand current architecture
   - Identify affected components

2. **Design Delta**:
   - What components change?
   - What new components needed?
   - How to preserve original behavior?

3. **Compatibility Analysis**:
   - Control flow impact
   - Data flow impact
   - Interface changes (breaking?)

4. **Create Enhancement Design**:
   - File: `specs/designs/DD-{YYY}-enhance-{original-name}.md`
   - MUST reference original: `DD-XXX`
   - Document compatibility strategy

### Enhancement Design Template

```markdown
# Design Decision: DD-YYY-enhance-{feature}

**Date**: YYYY-MM-DD
**Enhances**: DD-XXX ({original design name})
**For**: EN-XXX
**Status**: Draft | Approved | Implemented

## Original Design Summary
{Brief summary of DD-XXX approach}

## Enhancement Approach
{How we're modifying the design}

## Component Changes

### Modified Components
| Component | Current | After Enhancement | Compatibility |
|-----------|---------|-------------------|---------------|
| {Name} | {Current behavior} | {New behavior} | {How preserved} |

### New Components
| Component | Responsibility | Dependencies |
|-----------|----------------|--------------|
| {Name} | {What it does} | {What it needs} |

## Control Flow Impact
{How control flow changes}

## Data Flow Impact
{How data flow changes}

## Interface Changes
| Interface | Change Type | Migration |
|-----------|-------------|-----------|
| {Name} | None/Additive/Breaking | {If breaking, how to migrate} |

## Backward Compatibility Strategy
{How we ensure original behavior preserved}

## Risks
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| {Risk} | H/M/L | H/M/L | {Plan} |
```

### Exit Criteria
- DD-YYY approved
- Compatibility strategy documented
- All EN-XXX requirements mapped

### Handoff
- **To**: Developer
- **Artifacts**: DD-YYY + reference to DD-XXX

### ⮕ REVIEW GATE 2: Architect → Developer (Enhancement)
See `REVIEW_GATES.md` for full criteria. Developer reviews:
- [ ] Enhancement design is implementable
- [ ] Compatibility strategy is clear
- [ ] Changes are minimal and surgical
- [ ] Original tests provide safety net

**Gate Outcome**: Approve / Approve with Conditions / Reject

---

## Phase 3: Implementation (Developer)

### Trigger
- DD-YYY approved

### Activities

1. **Understand Both Designs**:
   - Original: DD-XXX
   - Enhancement: DD-YYY
   - Compatibility requirements

2. **Verify Existing Tests**:
   - Run all tests for affected components
   - Document baseline (all should pass)

3. **Implement Enhancement (TDD)**:
   - Write new tests for EN-XXX acceptance criteria
   - Implement changes
   - Verify original tests still pass

4. **Code Review**:
   - Peer review
   - Focus on compatibility preservation

### Key Considerations

- **Preserve original behavior**: If original test breaks, that's a bug
- **Additive changes preferred**: Extend, don't replace
- **Feature flags if risky**: Allow rollback if needed

### Exit Criteria
- Original tests pass (no regression)
- New tests pass (enhancement works)
- Code review approved

### Handoff
- **To**: Tester
- **Artifacts**: Implementation

### ⮕ REVIEW GATE 3: Developer → Tester (Enhancement)
See `REVIEW_GATES.md` for full criteria. Tester reviews:
- [ ] Original tests still exist and pass
- [ ] New tests for enhancement exist
- [ ] Code is testable
- [ ] No obvious regressions

**Gate Outcome**: Approve / Approve with Conditions / Reject

---

## Phase 4: Validation (Tester)

### Trigger
- Implementation complete

### Activities

1. **Regression Testing**:
   - Run ALL original tests (from TP for FR-XXX)
   - Any failure = regression bug

2. **Enhancement Testing**:
   - Test EN-XXX acceptance criteria
   - Edge cases for new behavior

3. **Integration Testing**:
   - Original + enhanced behavior together
   - Verify no interference

4. **Report Issues**:
   - Regression bugs reference both FR-XXX and EN-XXX
   - New bugs reference EN-XXX

### Exit Criteria
- Zero regressions
- EN-XXX acceptance criteria pass
- Integration verified

### Handoff
- **To**: Technical Writer

### ⮕ REVIEW GATE 4: Tester → Technical Writer (Enhancement)
See `REVIEW_GATES.md` for full criteria. Writer reviews:
- [ ] No regressions found
- [ ] Enhancement tests pass
- [ ] Feature is stable for documentation

**Gate Outcome**: Approve / Approve with Conditions / Reject

---

## Phase 5: Documentation (Technical Writer)

### Trigger
- Validation complete

### Activities

1. **Update Existing Documentation**:
   - Add enhancement to existing feature docs
   - Mark what's new (e.g., "Added in v1.X")

2. **Changelog**:
   - Document enhancement
   - Reference EN-XXX

3. **Versioning & Intent**:
   - Update `app_intent.md` to reflect enhancement
   - Bump `APP_VERSION` per P-VERSIONING (minor unless breaking)
4. **Review**:
   - Verify accuracy
   - Verify original docs still accurate

### Exit Criteria
- Documentation updated
- No stale information

---

## Phase 5b: Go-To-Market (Optional Roles)

**Trigger**: App intent explicitly requests monetization, growth, or evangelism.

**Roles**: Monetization Strategist, Growth Marketer, Evangelist (as applicable)

**Activities**:
- Monetization: Update pricing/value capture assumptions
- Growth: Update acquisition/activation/retention metrics
- Evangelism: Update demos/launch assets

**Artifacts Produced**:
- `specs/monetization.md` or `docs/user/monetization.md` (if applicable)
- `specs/growth.md` or `docs/user/growth.md` (if applicable)
- `docs/user/evangelism.md` (if applicable)

**Exit Criteria**:
- GTM artifacts complete (if requested)

---

## Phase 6: Release (Enhancement)

### ⮕ REVIEW GATE 7: PM Final Acceptance (Enhancement)
PM confirms enhancement meets EN-XXX spec AND preserves original FR-XXX value:
- [ ] Original FR-XXX functionality still works
- [ ] All EN-XXX requirements implemented as specified
- [ ] Enhancement delivers promised additional value
- [ ] No regressions in original feature
- [ ] No unauthorized scope changes

**Gate Outcome**: ACCEPTED / REJECTED

---

## Artifact Relationships

```
Original Feature:
  FR-XXX (immutable) ─────────────────────────────┐
       │                                          │
       ▼                                          │
  DD-XXX (immutable) ─────────────────────────┐   │
       │                                      │   │
       ▼                                      │   │
  Implementation v1                           │   │
       │                                      │   │
       ▼                                      │   │
  TP-XXX (immutable)                          │   │
                                              │   │
Enhancement:                                  │   │
  EN-YYY (immutable) ◄─── references ─────────┼───┘
       │                                      │
       ▼                                      │
  DD-YYY (immutable) ◄─── references ─────────┘
       │
       ▼
  Implementation v2 (includes original + enhancement)
       │
       ▼
  TP-YYY (immutable) + TP-XXX still valid
```

---

## Common Issues

### Issue: Enhancement Breaks Original
- **Symptom**: Original tests fail
- **Root Cause**: Incompatible change
- **Resolution**: Fix implementation to preserve original behavior

### Issue: Scope Creep in Enhancement
- **Symptom**: EN-XXX keeps growing
- **Resolution**: Split into multiple ENs, or defer additions

### Issue: Original Spec Was Wrong
- **Symptom**: Enhancement reveals original FR-XXX was incorrect
- **Resolution**: Create bug report for original, may need new FR to "fix" original

### Issue: Can't Enhance Without Breaking
- **Symptom**: Technical constraints prevent compatible change
- **Resolution**: Document as breaking change, require migration path, consider major version
