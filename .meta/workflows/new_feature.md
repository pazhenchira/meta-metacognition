# Workflow: New Feature

## Overview

This workflow covers the complete lifecycle of a new feature from idea to production.

**Key Principle**: Each role completes their work and hands off to the next. Artifacts are immutable once approved—changes require new artifacts that reference the old.

**Review Model**: Each handoff is a review gate. The receiving role reviews and approves before proceeding. See `REVIEW_GATES.md` for detailed criteria.

**Execution Rule**: If runtime supports sub-agents or agent profiles, each phase MUST be executed by the corresponding role agent. Otherwise, role-switch sequentially in a single session.

---

## Role Insertions (Conditional + Required)

- **Strategy Owner**: Insert between Essence and PM when the app is decision-critical.
- **Designer**: Insert between PM and Architect when UX/UI is non-trivial; produces UX artifacts that shape design.
- **Operations (REQUIRED)**: Insert after Documentation and before PM Final Acceptance for deploy readiness (Gate 6). Early consult after Architect if reliability requirements are non-trivial.
- **Monetization Strategist**: Insert after Essence and before PM spec when pricing/value capture is in scope, OR when GTM agents are available/enabled.
- **Growth Marketer**: Insert after Essence and before PM spec when acquisition/retention loops are required, OR when GTM agents are available/enabled.
- **Evangelist**: Insert after Writer and before Release when demos/launch assets are needed, OR when GTM agents are available/enabled.

## Decision-Critical Guardrail

If the app is **decision-critical**:
- **Strategy Owner is REQUIRED**.
- **Gate 0 must be completed** before PM creates FR-XXX.
- If not applicable, record **"Gate 0 N/A"** with a brief rationale.

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ESSENCE VALIDATION                                   │
│                         (Essence Analyst)                                    │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ Essence aligned
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        STRATEGY DEFINITION                                   │
│                    (Strategy Owner - Conditional)                            │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ STR-XXX approved (if applicable)
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            DISCOVERY PHASE                                   │
│                           (Product Manager)                                  │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ FR-XXX approved
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                             DESIGN PHASE                                     │
│                              (Architect)                                     │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ DD-XXX approved
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          IMPLEMENTATION PHASE                                │
│                             (Developer)                                      │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ Code + unit tests complete
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           VALIDATION PHASE                                   │
│                              (Tester)                                        │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ All tests pass, bugs resolved
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          DOCUMENTATION PHASE                                 │
│                          (Technical Writer)                                  │
└─────────────────────────────────────────────────────────────────────────────┘
        │
        │ Docs complete
        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            RELEASE PHASE                                     │
│                          (All roles verify)                                  │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Phase 0: Essence Validation (Essence Analyst)

### Trigger
- Any new feature request

### Activities
1. Validate feature aligns with `essence.md`
2. Update `essence.md` if the core value proposition evolves
3. Confirm success metrics remain measurable

### Artifacts Produced
- Updated `essence.md` (LIVING)

### Exit Criteria
- Essence alignment confirmed

### Handoff
- **To**: Product Manager

---

## Phase 0.5: Strategy Definition (Strategy Owner) — Conditional

### Trigger
- Decision-critical apps (finance, medical, legal, safety)

### Activities
1. Define the decision framework and benchmarks
2. Specify inputs, constraints, and risk limits
3. Provide evaluation criteria and datasets

### Artifacts Produced
- `specs/strategy/STR-XXX-{name}.md` (IMMUTABLE)

### Exit Criteria
- Strategy spec approved
- Benchmarks and risk limits explicit

### Handoff
- **To**: Product Manager
- **Artifact**: STR-XXX
- **Expectation**: PM encodes benchmarks as acceptance criteria
- **Review Gate**: See `REVIEW_GATES.md` Gate 0 (Strategy Owner → PM)

---

## Phase 1: Discovery (Product Manager)

### Trigger
- User request
- Market opportunity
- Business need
- Technical enablement

### Activities

1. **Validate the Essence Triangle**:
   - Customer Value: What do users get? Is there evidence of need?
   - Business Impact: What does the business get? Is it worth it?
   - Feasibility: Can we build it? With what effort/risk?

2. **Create Feature Specification**:
   - File: `specs/features/FR-{NNN}-{short-name}.md`
   - Follows template from `.meta/artifacts/templates/feature_spec.template.md`
   - Immutable once approved

3. **Define Acceptance Criteria**:
   - Testable criteria (each becomes a test)
   - Clear pass/fail
   - No ambiguity

4. **Review Gate**:
   - Stakeholder review
   - Technical feasibility check (Architect input)
   - Approval documented

### Artifacts Produced
- `specs/features/FR-XXX-{name}.md` (IMMUTABLE)

### Exit Criteria
- FR-XXX approved by stakeholders
- Acceptance criteria are testable
- Essence Triangle satisfied

### Handoff
- **To**: Architect
- **Artifact**: FR-XXX
- **Expectation**: Create design that implements spec

### ⮕ REVIEW GATE 1: PM → Architect
See `REVIEW_GATES.md` for full criteria. Architect reviews:
- [ ] Requirements are clear and unambiguous
- [ ] Acceptance criteria are testable
- [ ] No technical impossibilities
- [ ] Scope is bounded

**Gate Outcome**: Approve / Approve with Conditions / Reject

---

## Phase 2: Design (Architect)

### Trigger
- FR-XXX approved

### Activities

1. **Analyze Requirements**:
   - Map acceptance criteria to components
   - Identify affected LEGOs
   - Identify new LEGOs needed

2. **Design Solution**:
   - Define component responsibilities
   - Map control flow
   - Map data flow
   - Identify trade-offs

3. **Create Design Decision**:
   - File: `specs/designs/DD-{NNN}-{short-name}.md`
   - References FR-XXX
   - Documents trade-offs and alternatives
   - Immutable once approved

4. **Update Living Documents**:
   - `lego_plan.json` if new components
   - `architecture.md` if system-level changes

5. **Review Gate**:
   - PM review (does it deliver value?)
   - Developer review (is it feasible?)
   - Self-review (KISS, LEGO principles)

### Artifacts Produced
- `specs/designs/DD-XXX-{name}.md` (IMMUTABLE)
- Updated `lego_plan.json` (LIVING)
- Updated `architecture.md` if needed (LIVING)

### Exit Criteria
- DD-XXX approved
- All FR-XXX requirements mapped to components
- Trade-offs documented

### Handoff
- **To**: Developer
- **Artifact**: DD-XXX
- **Expectation**: Implement as designed

### ⮕ REVIEW GATE 2: Architect → Developer
See `REVIEW_GATES.md` for full criteria. Developer reviews:
- [ ] Components have clear responsibilities
- [ ] Interfaces are fully specified
- [ ] Dependencies are available
- [ ] Each component is testable in isolation

**Gate Outcome**: Approve / Approve with Conditions / Reject

---

## Phase 3: Implementation (Developer)

### Trigger
- DD-XXX approved

### Activities

1. **Plan Implementation**:
   - Order by dependencies
   - Estimate per component
   - Identify test strategy

2. **Implement (TDD)**:
   - Write test first (from acceptance criteria)
   - Implement minimal code to pass
   - Refactor for clarity
   - Repeat for each component

3. **Self-Review**:
   - Spec fidelity (matches DD-XXX?)
   - Code quality (readable? simple?)
   - Test coverage (>80%?)

4. **Code Review**:
   - Peer review
   - Address feedback

### Artifacts Produced
- `src/` implementation (LIVING)
- `tests/unit/` tests (LIVING)
- `tests/integration/` if applicable (LIVING)

### Exit Criteria
- Code compiles and runs
- All unit tests pass
- Code review approved
- Coverage target met

### Handoff
- **To**: Tester
- **Artifact**: Implementation + tests
- **Expectation**: Validate against spec

### ⮕ REVIEW GATE 3: Developer → Tester
See `REVIEW_GATES.md` for full criteria. Tester reviews:
- [ ] All FR-XXX requirements are implemented
- [ ] Implementation matches DD-XXX design
- [ ] Unit test coverage >80%
- [ ] Code is testable

**Gate Outcome**: Approve / Approve with Conditions / Reject

---

## Phase 4: Validation (Tester)

### Trigger
- Implementation complete

### Activities

1. **Create Test Plan** (if not exists):
   - File: `specs/tests/TP-{NNN}-{name}.md`
   - Map acceptance criteria to tests
   - Identify edge cases
   - Plan E2E scenarios

2. **Execute Tests**:
   - Run unit tests (verify still pass)
   - Run integration tests
   - Run E2E tests
   - Run robustness tests

3. **Report Issues**:
   - File: `specs/bugs/BUG-{NNN}-{description}.md`
   - References FR-XXX and DD-XXX
   - Steps to reproduce
   - Evidence attached

4. **Verify Fixes**:
   - Re-test after Developer fix
   - Verify regression test added
   - Close resolved bugs

### Artifacts Produced
- `specs/tests/TP-XXX-{name}.md` (IMMUTABLE)
- `specs/bugs/BUG-XXX-*.md` if issues found (IMMUTABLE)
- `tests/e2e/` test code (LIVING)

### Exit Criteria
- All acceptance criteria tests pass
- No Critical/High bugs open
- E2E scenarios validated
- Coverage targets met

### Handoff
- **To**: Technical Writer
- **Artifact**: Validated feature
- **Expectation**: Document for users and developers

### ⮕ REVIEW GATE 4: Tester → Technical Writer
See `REVIEW_GATES.md` for full criteria. Writer reviews:
- [ ] All tests pass
- [ ] No critical/high bugs open
- [ ] Feature is functionally complete
- [ ] Sufficient technical docs exist

**Gate Outcome**: Approve / Approve with Conditions / Reject

---

## Phase 5: Documentation (Technical Writer)

### Trigger
- Validation complete

### Activities

1. **Identify Documentation Needs**:
   - User-facing docs needed?
   - Developer docs needed?
   - Operator docs needed?

2. **Write Documentation**:
   - Update README if user-facing
   - Create/update user guides
   - Update ARCHITECTURE.md if needed
   - Update API reference if applicable
   - Update `app_intent.md` to reflect the new feature
   - Bump `APP_VERSION`

3. **Review**:
   - Technical accuracy (Developer review)
   - Clarity (fresh eyes review)
   - Completeness (all use cases covered)

4. **Test Documentation**:
   - Follow guide on fresh environment
   - Verify examples work

### Artifacts Produced
- Updated `README.md` (LIVING)
- `docs/` updates (LIVING)
- Updated `CHANGELOG.md` (LIVING)

### Exit Criteria
- Documentation complete and reviewed
- Examples verified to work
- CHANGELOG updated

### Handoff
- **To**: Release (all roles verify)

### ⮕ REVIEW GATE 5: Technical Writer → Release
See `REVIEW_GATES.md` for full criteria. All roles review:
- [ ] PM: Feature delivers intended value
- [ ] Architect: Meets architectural standards
- [ ] Developer: Code is maintainable
- [ ] Tester: Confident it works
- [ ] Writer: Users can understand it
- [ ] Operations: Operational readiness (required)

**Gate Outcome**: Approve / Reject

---

## Phase 5b: Go-To-Market (GTM Roles)

**Trigger**: App intent requests monetization/growth/evangelism OR GTM agents are available/enabled.

**Roles**: Monetization Strategist, Growth Marketer, Evangelist (as applicable)

**Activities**:
- Monetization: Define pricing/value capture assumptions
- Growth: Define acquisition/activation/retention metrics
- Evangelism: Define narrative, demos, and launch assets

**Artifacts Produced**:
- `specs/monetization.md` or `docs/user/monetization.md` (if applicable)
- `specs/growth.md` or `docs/user/growth.md` (if applicable)
- `docs/user/evangelism.md` (if applicable)

**Exit Criteria**:
- GTM artifacts complete (if available/enabled)
- If GTM roles unavailable, record explicit skip with rationale

---

## Phase 5c: Operations Review (Required)

**Trigger**: Always (production deployment required). If app is not deployable, define release equivalent with Sponsor approval.

**Activities**:
- Review deployment plan and rollback
- Verify monitoring/alerting coverage
- Validate runbooks and operational docs
- Confirm capacity/SLO impact

### Artifacts Produced
- Updated `ops/runbooks/` or `DEPLOYMENT.md` (if needed)
- Ops readiness notes (if required)

### Exit Criteria
- Ops readiness confirmed
- Gate 6 approval recorded (or issues returned)

### Handoff
- **To**: PM (Final Acceptance)
- **Artifact**: Release candidate + ops readiness confirmation

### ⮕ REVIEW GATE 6: Operations Review (Required)
See `REVIEW_GATES.md` for full criteria. Operations reviews:
- [ ] Deployment plan exists with rollback
- [ ] Monitoring and alerting configured
- [ ] Runbooks updated
- [ ] No expected SLO impact

**Gate Outcome**: Approve / Approve with Conditions / Reject

---

## Phase 6: Release

### Trigger
- Documentation complete
 - Gate 6 complete (required)

### Activities

1. **PM Final Acceptance** (REQUIRED):
   - PM reviews against FR-XXX spec
   - Verifies all acceptance criteria pass
   - Confirms essence alignment (customer value + business impact)
   - Signs off or rejects with specific deviations

2. **Final Verification** (All Roles):
   - Architect: Implementation matches design
   - Developer: No known technical debt
   - Tester: All tests pass
   - Writer: Docs accurate and complete
   - Operations: Gate 6 signoff recorded (required)

3. **Release Preparation**:
   - Version bump (`APP_VERSION`) per P-VERSIONING (patch/minor/major)
   - CHANGELOG finalized
   - Release notes prepared

4. **Release**:
   - Merge to main
   - Deploy to production
   - Monitor for issues

### ⮕ REVIEW GATE 7: PM Final Acceptance
See `REVIEW_GATES.md` for full criteria. PM confirms:
- [ ] All FR-XXX requirements implemented as specified
- [ ] All acceptance criteria pass
- [ ] Feature delivers promised Customer Value
- [ ] Feature delivers promised Business Impact
- [ ] No unauthorized scope additions

**Gate Outcome**: ACCEPTED (release) / REJECTED (return to appropriate role)

### Exit Criteria
- PM Final Acceptance signed
- All roles verified
- Released to production
- Monitoring in place

---

## Artifact Immutability Rules

### Immutable (Never Modified After Approval)
| Artifact | Why Immutable |
|----------|---------------|
| `specs/features/FR-XXX-*.md` | Audit trail of what was requested |
| `specs/designs/DD-XXX-*.md` | Audit trail of design decisions |
| `specs/tests/TP-XXX-*.md` | Audit trail of test coverage |
| `specs/bugs/BUG-XXX-*.md` | Audit trail of issues found |

### Living (Updated as Needed)
| Artifact | Why Living |
|----------|------------|
| `src/**` | Implementation evolves |
| `tests/**` | Tests evolve with code |
| `docs/**` | Documentation tracks current state |
| `lego_plan.json` | Architecture evolves |
| `architecture.md` | Architecture evolves |
| `CHANGELOG.md` | Accumulates entries |

### What About Changes?

If a feature needs to change after FR-XXX is approved:
1. Create **new** spec: `FR-YYY-enhance-{original}.md`
2. Reference original: "This enhances FR-XXX by..."
3. Follow full workflow for the enhancement

This maintains audit trail while allowing evolution.

---

## Workflow Checkpoints

### Checkpoint 1: Discovery Complete
- [ ] Essence Triangle validated
- [ ] FR-XXX created and approved
- [ ] Stakeholder sign-off

### Checkpoint 2: Design Complete
- [ ] DD-XXX created and approved
- [ ] All requirements mapped
- [ ] Trade-offs documented

### Checkpoint 3: Implementation Complete
- [ ] Code implements DD-XXX
- [ ] Unit tests pass
- [ ] Code review approved
- [ ] Coverage target met

### Checkpoint 4: Validation Complete
- [ ] All acceptance criteria pass
- [ ] No Critical/High bugs
- [ ] E2E scenarios validated

### Checkpoint 5: Documentation Complete
- [ ] User docs updated
- [ ] Developer docs updated
- [ ] CHANGELOG updated

### Checkpoint 6: Release Complete
- [ ] All roles verified
- [ ] Released to production
- [ ] Monitoring active

---

## Timeline Expectations

| Phase | Typical Duration | Depends On |
|-------|------------------|------------|
| Discovery | 1-5 days | Clarity of need, stakeholder availability |
| Design | 1-3 days | Complexity of feature |
| Implementation | 2-10 days | Size of feature, number of LEGOs |
| Validation | 1-3 days | Test coverage needed, bugs found |
| Documentation | 1-2 days | Documentation scope |
| Release | < 1 day | CI/CD maturity |

**Total**: 7-24 days for typical feature

---

## Common Issues and Resolution

### Issue: Requirements Unclear
- **Symptom**: Developer/Architect asking many questions
- **Resolution**: PM clarifies FR-XXX, may need amendment FR-YYY

### Issue: Design Infeasible
- **Symptom**: Developer says "can't build as designed"
- **Resolution**: Architect revises DD-XXX, may need PM input on scope

### Issue: Bugs Found in Validation
- **Symptom**: Tester reports BUG-XXX
- **Resolution**: Developer fixes, Tester verifies, cycle until clean

### Issue: Documentation Gaps
- **Symptom**: Users confused despite feature working
- **Resolution**: Writer enhances docs, may need Developer input

### Issue: Post-Release Bug
- **Symptom**: Bug discovered in production
- **Resolution**: Follow Bug Fix workflow (reference original FR-XXX)
