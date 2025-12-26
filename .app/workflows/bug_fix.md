# Workflow: Bug Fix

## Overview

This workflow covers fixing a defect where implementation deviates from specification.

**Key Principle**: A bug is a deviation from spec. The spec (FR-XXX) is correct; the implementation is wrong. Fix the implementation, not the spec.

**Review Model**: Bug fixes have lighter review gates (speed matters) but still require verification. See `REVIEW_GATES.md` for criteria.

**Execution Rule**: If runtime supports sub-agents or agent profiles, each phase MUST be executed by the corresponding role agent. Otherwise, role-switch sequentially in a single session.

---

## Role Insertions (Conditional + Required)

- **Strategy Owner**: Insert if bug impacts decision framework or benchmarks.
- **Essence Analyst**: Only if the bug undermines the core value proposition or success metrics.
- **Designer**: If fix affects UX, accessibility, or interaction flows.
- **Operations (REQUIRED)**: Gate 6 before production deploy (or explicit release equivalent).
- **Writer**: If bug fix changes user-facing behavior or documentation.
- **Product Manager (Optional)**: Only for user impact, priority, and acceptance criteria; does not gate technical triage.

## Decision-Critical Guardrail

If the app is **decision-critical** and the bug impacts decision logic, benchmarks, or risk limits:
- **Strategy Owner is REQUIRED**.
- **Gate 0 must be completed** before PM triage proceeds.
- If not applicable, record **"Gate 0 N/A"** with a brief rationale.

## What Is a Bug?

A bug is when:
- Implementation does NOT match specification (FR-XXX)
- Implementation does NOT match design (DD-XXX)
- Behavior differs from documented acceptance criteria

A bug is NOT:
- User requesting new feature (that's Enhancement or New Feature)
- Spec was wrong from the start (that's a spec issue, handled differently)
- User doesn't like how it works (that may be Enhancement)

## Bug vs Incident Triage

Before role selection, classify:

- **Bug**: Deviation from spec or previously working behavior → Dev/Test lead; PM optional for impact/priority.
- **Incident**: Operational failure (auth, delivery, integrations, outages) → Ops + Dev lead for containment; PM only for comms/priority.

---

## Phase 0.5: Strategy Check (Strategy Owner) — Conditional

### Trigger
- Bug affects or undermines the domain decision framework

### Activities
1. Validate whether strategy still meets benchmarks
2. Update STR-XXX if the decision logic is flawed
3. Provide revised evaluation criteria if needed

### Artifacts Produced
- Updated `specs/strategy/STR-XXX-{name}.md` (new version, immutable)

### Exit Criteria
- Strategy alignment confirmed or updated

### Handoff
- **To**: Product Manager and Tester (via App Orchestrator)
- **Review Gate**: See `REVIEW_GATES.md` Gate 0 (Strategy Owner → PM)

---
## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           BUG DISCOVERY                                      │
│                     (Tester, User, Developer)                                │
│                                                                              │
│  Identify deviation → Compare to spec → Document                            │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ BUG-XXX created
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                      BUG/INCIDENT TRIAGE                                     │
│                 (App Orchestrator + Ops/Dev)                                 │
│                                                                              │
│  Classify bug vs incident → Assess severity → Prioritize                    │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ Priority assigned
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          ROOT CAUSE ANALYSIS                                 │
│                           (Developer)                                        │
│                                                                              │
│  Reproduce → Identify cause → Determine fix scope                           │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ Cause identified
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              FIX                                             │
│                           (Developer)                                        │
│                                                                              │
│  Write failing test → Fix code → Verify test passes                         │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ Fix implemented
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          VERIFICATION                                        │
│                            (Tester)                                          │
│                                                                              │
│  Verify fix → Check for regressions                                         │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ Bug verified
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    DOCUMENTATION & VERSIONING                                │
│                        (Writer, PM optional)                                 │
│                                                                              │
│  Update docs → Bump version                                                  │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ Release candidate ready
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                   OPERATIONS REVIEW (If Applicable)                          │
│                             (Operations)                                     │
│                                                                              │
│  Deployability → Monitoring → Runbooks                                       │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ Ops signoff (required)
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                     FINAL ACCEPTANCE                                         │
│                         (App Orchestrator)                                   │
│                                                                              │
│  Confirm value restored → Accept or reject                                  │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Bug Discovery

### Trigger
- Tester finds issue during validation
- User reports unexpected behavior
- Developer notices problem during development
- Monitoring detects error

### Activities

1. **Identify the Deviation**:
   - What is the expected behavior? (from FR-XXX)
   - What is the actual behavior?
   - What is the difference?

2. **Gather Evidence**:
   - Steps to reproduce
   - Screenshots/logs
   - Environment details

3. **Create Bug Report**:
   - File: `specs/bugs/BUG-{NNN}-{short-description}.md`
   - MUST reference FR-XXX (what it should do)
   - Follows bug report template

### Bug Report Template

```markdown
# Bug Report: BUG-XXX-{short-description}

**Date Reported**: YYYY-MM-DD
**Reported By**: {Role/Name}
**Status**: New | Confirmed | In Progress | Fixed | Verified | Closed

## References
- **Specification**: FR-XXX (what it should do)
- **Design**: DD-XXX (how it should work)
- **Component**: {Affected LEGO}

## Summary
{One sentence describing the bug}

## Expected Behavior
{From FR-XXX, what should happen}

> Quote from FR-XXX acceptance criteria:
> "AC-X: {The relevant acceptance criterion}"

## Actual Behavior
{What actually happens}

## Steps to Reproduce
1. {Step 1}
2. {Step 2}
3. {Step 3}
4. Observe: {The bug manifests}

## Evidence
- Screenshot: {link}
- Log snippet:
```
{relevant log output}
```
- Error message: {exact error}

## Environment
- Version: {app version}
- Platform: {OS, browser, etc.}
- Configuration: {relevant config}

## Severity Assessment
- **Severity**: Critical | High | Medium | Low
- **Justification**: {Why this severity}

## Impact Assessment
- **User Impact**: {How users are affected}
- **Business Impact**: {Revenue, compliance, trust, risk exposure}
- **Workaround**: {If any, describe}
```

### Exit Criteria
- BUG-XXX created with all required fields
- Steps to reproduce are clear
- Expected behavior is from spec

---

## Phase 2: Bug / Incident Triage (App Orchestrator + Ops/Dev)

### Trigger
- BUG-XXX created

### Activities

1. **Classify**:
   - Compare to FR-XXX specification
   - Is implementation wrong, or was spec wrong?
   - Is this a bug, a feature request, or an incident?

2. **Assess Severity**:
   | Severity | Definition |
   |----------|------------|
   | Critical | System unusable, data loss, security breach |
   | High | Major feature broken, no workaround |
   | Medium | Feature broken, workaround exists |
   | Low | Minor issue, cosmetic, edge case |

3. **Assign Priority**:
   | Priority | Definition |
   |----------|------------|
   | P1 | Fix immediately (drop everything) |
   | P2 | Fix in current sprint |
   | P3 | Fix in next sprint |
   | P4 | Fix when convenient |

4. **Confirm Impact** (PM optional for comms/priority):
   - Customer impact documented
   - Business impact documented (revenue, compliance, trust, risk)

5. **Assign to Ops/Dev**:
   - Based on component ownership
   - Based on availability

### Decision Tree

```
Is behavior in spec (FR-XXX)?
├── YES, but implementation differs → BUG (proceed)
├── NO, user wants new behavior → ENHANCEMENT (not a bug)
├── NO, spec was wrong → SPEC ISSUE (see below)
└── Operational failure (auth/delivery/integrations) → INCIDENT (Ops+Dev lead)
```

**If Spec Was Wrong**:
- This is NOT a bug in the implementation
- Create FR-YYY to correct the spec
- Original FR-XXX was the error
- Follow New Feature workflow for the correction

### Exit Criteria
- Confirmed as bug (not feature request)
- Severity assessed
- Priority assigned
- Customer value + business impact documented
- Developer assigned

### Handoff
- **To**: Developer
- **Artifact**: BUG-XXX (triaged)

### ⮕ REVIEW GATE: Triage → Ops/Developer
Developer reviews before accepting:
- [ ] Bug is reproducible with provided steps
- [ ] Expected behavior is clear from spec
- [ ] Severity/priority is reasonable

**Gate Outcome**: Accept / Request Clarification

---

## Phase 3: Root Cause Analysis (Developer)

### Trigger
- Bug assigned to Developer

### Activities

1. **Reproduce the Bug**:
   - Follow steps in BUG-XXX
   - Confirm it fails
   - Document reproduction environment

2. **Identify Root Cause**:
   - Trace through code
   - Find where behavior deviates from spec
   - Document the cause

3. **Determine Fix Scope**:
   - Is this a local fix?
   - Are there related issues?
   - Will fix require design change?

4. **Update Bug Report**:
   - Add root cause analysis
   - Add fix scope
   - Flag if design change needed (escalate to Architect)

### Root Cause Update Template

```markdown
## Root Cause Analysis

**Analyzed By**: {Developer}
**Date**: YYYY-MM-DD

### Root Cause
{Description of why the bug occurs}

### Location
- File: {path}
- Function: {function name}
- Line: {approximate line}

### Fix Scope
- **Type**: Local fix | Multi-file fix | Design change needed
- **Files Affected**: {list}
- **Risk Assessment**: Low | Medium | High

### If Design Change Needed
{Escalate to Architect, explain why}
```

### Exit Criteria
- Bug reproduced
- Root cause identified
- Fix scope determined
- Escalated if design change needed

---

## Phase 4: Fix (Developer)

### Trigger
- Root cause identified
- (If design change: DD-YYY approved)

### Activities

1. **Write Failing Test FIRST**:
   - Test captures the bug
   - Test fails before fix
   - Test based on FR-XXX expected behavior

2. **Implement Fix**:
   - Minimal change to fix the bug
   - Don't refactor unrelated code (separate concern)
   - Follow existing patterns

3. **Verify Fix**:
   - New test passes
   - All existing tests pass
   - No regressions

4. **Code Review**:
   - Peer review
   - Focus on correctness and scope

### Commit Message Format

```
Fix: BUG-XXX - {short description}

Root cause: {brief explanation}
Fix: {what was changed}

References: FR-XXX, DD-XXX
```

### Exit Criteria
- Failing test written (now passes)
- Fix implemented
- All tests pass
- Code review approved

### Handoff
- **To**: Tester
- **Artifact**: Fix implementation

### ⮕ REVIEW GATE: Developer → Tester (Bug Fix)
Tester reviews before verifying:
- [ ] Failing test exists for this bug
- [ ] Fix is minimal (not over-engineered)
- [ ] All tests pass

**Gate Outcome**: Accept / Request Changes

---

## Phase 5: Verification (Tester)

### Trigger
- Fix implemented and reviewed

### Activities

1. **Verify Original Issue**:
   - Follow steps from BUG-XXX
   - Confirm expected behavior now occurs
   - Confirm against FR-XXX spec

2. **Regression Testing**:
   - Run related test suite
   - Check for side effects
   - Verify no new issues

3. **Update Bug Report**:
   - Mark as Verified
   - Document verification steps

4. **Close Bug**:
   - If verified: Close as Fixed
   - If not: Reopen with details

### Verification Update Template

```markdown
## Verification

**Verified By**: {Tester}
**Date**: YYYY-MM-DD
**Version**: {Version with fix}

### Verification Steps
1. {Step 1}
2. {Step 2}
3. Observed: {Correct behavior}

### Regression Check
- [ ] Related tests pass
- [ ] No new issues observed

### Result
- [x] VERIFIED - Bug is fixed
- [ ] NOT VERIFIED - Reopening (see notes)
```

### Exit Criteria
- Fix verified
- Regression check passed
- Bug closed

---

## Phase 6: Documentation & Versioning (Writer, PM optional)

### Trigger
- Bug verified

### Activities
1. **Update Docs** (if user-visible):
   - Update README or docs to clarify behavior
2. **Update app_intent.md** (if behavior/requirements changed)
3. **Bump APP_VERSION** per P-VERSIONING (patch)

### Exit Criteria
- Docs and intent updated (when applicable)
- APP_VERSION bumped

---

## Phase 6.5: Operations Review (Required)

**Trigger**: Always (production deployment required). If app is not deployable, define release equivalent with Sponsor approval.

**Activities**:
- Review deployment plan and rollback
- Verify monitoring/alerting coverage
- Validate runbooks and operational notes
- Confirm capacity/SLO impact

### Exit Criteria
- Ops readiness confirmed
- Gate 6 approval recorded (or issues returned)

### Handoff
- **To**: App Orchestrator (Final Acceptance)
- **Artifact**: Release candidate + ops readiness confirmation

### ⮕ REVIEW GATE 6: Operations Review (Required)
See `REVIEW_GATES.md` for full criteria. Operations reviews:
- [ ] Deployment plan exists with rollback
- [ ] Monitoring and alerting configured
- [ ] Runbooks updated
- [ ] No expected SLO impact

**Gate Outcome**: Approve / Approve with Conditions / Reject

---

## Phase 7: App Orchestrator Final Acceptance (Bug Fix)

**Trigger**: Bug verified and docs/versioning complete

**Activities**:
1. Confirm BUG-XXX restores FR-XXX behavior
2. Verify customer value + business impact restored
3. Record acceptance in BUG-XXX (PM optional for comms/priority)

### Exit Criteria
- Acceptance recorded
- Gate 7 approval recorded

### ⮕ REVIEW GATE 7: Final Acceptance (Bug Fix)
See `REVIEW_GATES.md` for full criteria. App Orchestrator confirms:
- [ ] Bug fix matches FR-XXX spec
- [ ] Acceptance criteria pass
- [ ] Customer value + business impact restored
- [ ] No unauthorized scope changes

**Gate Outcome**: ACCEPTED / REJECTED

---

## Severity and Priority Matrix

| Severity | User Impact | Examples |
|----------|-------------|----------|
| Critical | Cannot use system | Crash on startup, data corruption, security breach |
| High | Major feature unusable | Core feature broken, no workaround |
| Medium | Feature impaired | Feature partially works, workaround available |
| Low | Minor inconvenience | Cosmetic, edge case, typo |

| Priority | Response Time | Resolution Time |
|----------|---------------|-----------------|
| P1 | Immediate | Hours |
| P2 | Same day | Days |
| P3 | This week | 1-2 weeks |
| P4 | Backlog | When convenient |

---

## Artifact Relationships

```
Original Feature:
  FR-XXX (immutable) ────────────────────────┐
       │                                     │
       ▼                                     │
  DD-XXX (immutable)                         │
       │                                     │
       ▼                                     │
  Implementation v1 ◄── BUG: doesn't match ──┘
       │
       │
Bug Fix:                                     
  BUG-YYY (immutable) ◄─── references FR-XXX
       │
       ▼
  Implementation v2 (fixes bug)
       │
       ▼
  Regression test (captures bug, now passes)
```

---

## Special Cases

### Case: Spec Was Wrong

When investigation reveals the spec (FR-XXX) was incorrect:
1. BUG-XXX is NOT a bug (implementation was correct to spec)
2. Create FR-YYY: "Correct specification for {feature}"
3. FR-YYY references FR-XXX: "Original spec FR-XXX incorrectly stated..."
4. Follow New Feature workflow for FR-YYY

### Case: Design Was Wrong

When bug requires design change:
1. Developer identifies need during root cause analysis
2. Escalate to Architect
3. Architect creates DD-YYY-bugfix-{name}.md
4. DD-YYY references DD-XXX and BUG-XXX
5. Developer implements per DD-YYY

### Case: Multiple Related Bugs

When one root cause explains multiple bugs:
1. Create master BUG-XXX for root cause
2. Link related bugs: "Related to BUG-XXX"
3. Fix master bug
4. Verify all related bugs resolved
5. Close all together

### Case: Can't Reproduce

When bug cannot be reproduced:
1. Request more information from reporter
2. Try different environments
3. If still can't reproduce:
   - Mark as "Cannot Reproduce"
   - Leave open for monitoring
   - Close after no recurrence (30 days)

---

## Documentation Update

After bug fix:
- **CHANGELOG**: Add bug fix entry
- **Known Issues**: Remove if documented there
- **User Docs**: Update if bug affected documented behavior
