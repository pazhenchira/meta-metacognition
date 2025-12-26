# Review Gates and Handoff Criteria

## Overview

Reviews happen at **handoffs between roles**. Each receiving role reviews what they receive before accepting and proceeding. This is not a separate "Reviewer" role—it's a responsibility embedded in each handoff.

**Key Principle**: The receiving role is the reviewer. They have the expertise and incentive to catch issues relevant to their work.

---

## Review Gate Model

```
┌─────────────┐                    ┌─────────────┐
│   SENDER    │ ───── Artifact ───►│  RECEIVER   │
│   (Role A)  │                    │  (Role B)   │
└─────────────┘                    └──────┬──────┘
                                          │
                                   ┌──────▼──────┐
                                   │   REVIEW    │
                                   │    GATE     │
                                   └──────┬──────┘
                                          │
                              ┌───────────┴───────────┐
                              │                       │
                        ┌─────▼─────┐          ┌─────▼─────┐
                        │  APPROVE  │          │  REJECT   │
                        │ (Proceed) │          │ (Return)  │
                        └───────────┘          └───────────┘
```

---

## The Review Gates (Gate 0 is conditional)

### Gate 0: Strategy Owner → PM (Decision-Critical Only)

**Artifact**: Strategy Specification (STR-XXX)

**PM Reviews For**:

| Criterion | Question | Red Flags |
|-----------|----------|-----------|
| **Correctness** | Is the decision framework logically sound? | Undefined logic, hand-waving, contradictions |
| **Benchmarks** | Are benchmarks clear and measurable? | "Good" or "best" without thresholds |
| **Risk Limits** | Are risk constraints explicit? | Missing limits, unclear risk ownership |
| **Inputs/Outputs** | Are inputs/outputs defined? | Missing data sources, undefined outputs |
| **Operationalization** | Can we encode this into acceptance criteria? | No way to test or verify |

**Approval Criteria**:
- [ ] Decision framework is explicit and logically coherent
- [ ] Benchmarks are measurable and testable
- [ ] Risk limits and constraints are explicit
- [ ] Inputs/outputs are clearly defined
- [ ] Strategy can be encoded into FR-XXX acceptance criteria

**Rejection Response**:
Return to Strategy Owner with specific concerns:
- "Benchmark X is subjective—define the measurable threshold"
- "Risk limit Y is missing—what is the maximum drawdown?"
- "Input source Z is undefined—where does the data come from?"

---

### Gate 1: PM → Architect

**Artifact**: Feature Specification (FR-XXX)

**Architect Reviews For**:

| Criterion | Question | Red Flags |
|-----------|----------|-----------|
| **Clarity** | Can I understand exactly what to build? | Vague requirements, "etc.", "as needed" |
| **Completeness** | Are all requirements stated? | Missing edge cases, undefined behaviors |
| **Feasibility** | Can this be built with reasonable effort? | Impossible constraints, contradictions |
| **Testability** | Are acceptance criteria verifiable? | "Fast", "easy", "intuitive" (subjective) |
| **Scope** | Is scope bounded? | Open-ended requirements, feature creep |

**Approval Criteria**:
- [ ] All requirements are clear and unambiguous
- [ ] Acceptance criteria are testable (pass/fail)
- [ ] No technical impossibilities
- [ ] Scope is bounded and reasonable
- [ ] Essence Triangle is satisfied

**Rejection Response**:
Return to PM with specific questions:
- "Requirement X is unclear—does it mean A or B?"
- "Acceptance criterion Y is subjective—what's the measurable threshold?"
- "Requirements X and Y contradict—which takes priority?"

---

### Gate 2: Architect → Developer

**Artifact**: Design Decision (DD-XXX)

**Developer Reviews For**:

| Criterion | Question | Red Flags |
|-----------|----------|-----------|
| **Implementability** | Can I actually build this? | Missing details, hand-waving |
| **Clarity** | Do I know exactly what code to write? | Ambiguous interfaces, unclear responsibilities |
| **Dependencies** | Are dependencies available/stable? | Unavailable libraries, unproven tech |
| **Testability** | Can components be tested in isolation? | Tight coupling, hidden dependencies |
| **Effort** | Is the estimate realistic? | Underestimated complexity |

**Approval Criteria**:
- [ ] All components have clear responsibilities
- [ ] Interfaces are fully specified (inputs, outputs, errors)
- [ ] Dependencies are available and appropriate
- [ ] Each component is testable in isolation
- [ ] Effort estimate is realistic

**Rejection Response**:
Return to Architect with specific concerns:
- "Interface for component X is unclear—what's the expected input format?"
- "Component Y has too many responsibilities—can we split?"
- "Dependency Z is unmaintained—is there an alternative?"

---

### Gate 3: Developer → Tester

**Artifact**: Implementation (code + unit tests)

**Tester Reviews For**:

| Criterion | Question | Red Flags |
|-----------|----------|-----------|
| **Spec Fidelity** | Does code match FR-XXX requirements? | Deviations, missing features |
| **Design Fidelity** | Does code match DD-XXX design? | Different architecture, skipped components |
| **Test Coverage** | Are critical paths tested? | Low coverage, missing edge cases |
| **Testability** | Can I write tests against this? | No test hooks, hard-coded dependencies |
| **Documentation** | Can I understand how to test? | Missing API docs, unclear behaviors |

**Approval Criteria**:
- [ ] All FR-XXX requirements are implemented
- [ ] Implementation matches DD-XXX design
- [ ] Unit test coverage >80%
- [ ] Code is testable (mockable dependencies, clear interfaces)
- [ ] API/behavior is documented enough to test

**Rejection Response**:
Return to Developer with specific issues:
- "Requirement X from FR-XXX is not implemented"
- "Component Y deviates from DD-XXX—was this intentional?"
- "Cannot test feature Z—no way to inject test data"

---

### Gate 4: Tester → Technical Writer

**Artifact**: Validated implementation + test results

**Technical Writer Reviews For**:

| Criterion | Question | Red Flags |
|-----------|----------|-----------|
| **Stability** | Is the feature stable enough to document? | Pending changes, known bugs |
| **Completeness** | Is the feature complete? | Missing functionality, partial implementation |
| **Understandability** | Can I explain this to users? | Confusing behavior, inconsistent UX |
| **Documentability** | Are there docs to reference? | No API docs, no comments, no specs |

**Approval Criteria**:
- [ ] All tests pass
- [ ] No known critical/high bugs
- [ ] Feature is functionally complete
- [ ] API/behavior is stable (no pending changes)
- [ ] Sufficient technical documentation exists

**Rejection Response**:
Return to Tester/Developer with concerns:
- "Tests are failing—cannot document unstable feature"
- "Bug X affects core functionality—needs fix first"
- "Feature appears incomplete—missing capability Y"

---

### Gate 5: Technical Writer → Release

**Artifact**: Complete documentation

**Release Review (All Roles) For**:

| Criterion | Reviewer | Question |
|-----------|----------|----------|
| **Value Delivery** | PM | Does this deliver promised customer value? |
| **Technical Quality** | Architect | Does this meet architectural standards? |
| **Code Quality** | Developer | Is the code maintainable? |
| **Test Quality** | Tester | Are we confident it works? |
| **Doc Quality** | Writer | Can users understand and use this? |
| **Operational Readiness** | Operations | Can we run this in production? |

**Approval Criteria**:
- [ ] All acceptance criteria from FR-XXX pass
- [ ] No critical/high bugs open
- [ ] Documentation is complete and accurate
- [ ] Operational requirements met (if applicable)
- [ ] All roles sign off

**Rejection Response**:
Identify blocking issues, assign to responsible role, iterate.

---

### Gate 6: Operations Review (Required)

**For all deliverables.** If the app is not deployable (e.g., library/CLI), define and document the release equivalent with Sponsor approval.

**Artifact**: Release candidate

**Operations Reviews For**:

| Criterion | Question | Red Flags |
|-----------|----------|-----------|
| **Deployability** | Can we deploy this safely? | No rollback plan, breaking changes |
| **Observability** | Can we monitor this? | No logs, no metrics, no alerts |
| **Reliability** | Will this affect uptime? | No circuit breakers, no retries |
| **Runbooks** | Do we know how to operate it? | No runbooks, no incident procedures |
| **Capacity** | Can infrastructure handle it? | No load testing, unclear resource needs |

**Approval Criteria**:
- [ ] Deployment plan exists with rollback
- [ ] Monitoring and alerting configured
- [ ] Runbooks updated
- [ ] Load testing completed (if needed)
- [ ] No SLO impact expected
- [ ] Production deploy completed OR release equivalent documented

---

### Gate 7: Final Acceptance (Required)

**The bookend gate.** For new features/enhancements, PM confirms it matches the spec.
For bugs/incidents, the App Orchestrator confirms restored behavior (PM optional for comms/priority).

**Artifact**: Complete, tested, documented feature ready for release

**PM Reviews For** (features/enhancements):

| Criterion | Question | Red Flags |
|-----------|----------|-----------|
| **Spec Fidelity** | Does this match FR-XXX exactly? | Missing requirements, changed behavior |
| **Essence Alignment** | Does this deliver the promised value? | Technical success but user value missing |
| **Acceptance Criteria** | Do all criteria pass? | Partial implementation, edge cases skipped |
| **User Experience** | Would a user recognize this as the feature? | Over-engineered, confusing, different from spec |
| **Scope Creep** | Did we add things not in spec? | Gold plating, unauthorized enhancements |

**Approval Criteria**:
- [ ] All FR-XXX requirements are implemented as specified
- [ ] All acceptance criteria pass (verified by Tester)
- [ ] Feature delivers the Customer Value promised in spec
- [ ] Feature delivers the Business Impact promised in spec
- [ ] No unauthorized scope additions
- [ ] User can achieve stated goals

**PM Final Acceptance Statement** (features/enhancements):
```markdown
## PM Final Acceptance: FR-XXX

**Date**: YYYY-MM-DD
**PM**: {Name}
**Verdict**: ACCEPTED / REJECTED

### Verification
- [ ] Reviewed FR-XXX requirements
- [ ] Verified each acceptance criterion passes
- [ ] Confirmed essence alignment (customer value + business impact)
- [ ] Validated with stakeholder demo (if applicable)

### Findings
{Any observations, minor issues for future enhancement}

### Acceptance
I confirm this feature matches the specification FR-XXX and delivers
the intended value. Ready for release.

Signed: {PM}
```

**App Orchestrator Acceptance Statement** (bugs/incidents):
```markdown
## Final Acceptance: BUG/INCIDENT

**Date**: YYYY-MM-DD
**App Orchestrator**: {Name}
**Verdict**: ACCEPTED / REJECTED

### Verification
- [ ] Restored expected behavior (per FR-XXX / previous working behavior)
- [ ] Acceptance criteria for “fixed” satisfied
- [ ] Regression checks pass
- [ ] Ops readiness confirmed (if applicable)

### Findings
{Any observations, follow-ups, or residual risk}

### Acceptance
I confirm the bug/incident is resolved and the app behavior is restored.

Signed: {App Orchestrator}
```

**Rejection Response**:
Return to appropriate role with specific deviations:
- "Requirement X from FR-XXX is not implemented correctly"
- "Acceptance criterion AC-3 is not passing"
- "This delivers feature Y, but spec asked for feature Z"

**Why This Gate Matters**:
- PM owns the spec, PM confirms it was built correctly
- Prevents "technically complete but wrong" releases
- Ensures feature delivers actual user value, not just code
- Creates accountability loop (PM specifies → PM accepts)

---

## Review Outcomes

Every review gate has three possible outcomes:

### 1. Approve
- Artifact meets all criteria
- Proceed to next phase
- Document approval (who, when)

### 2. Approve with Conditions
- Artifact is mostly acceptable
- Minor issues can be fixed in parallel
- Document conditions and deadline

### 3. Reject
- Artifact has blocking issues
- Return to sender with specific feedback
- Sender must address and resubmit

---

## Review Anti-Patterns

### ❌ Rubber-Stamping
**Problem**: Approving without actually reviewing
**Fix**: Require specific checklist completion, document findings

### ❌ Scope Creep in Review
**Problem**: Reviewer adds new requirements
**Fix**: Reviewer can only validate against existing spec, new requirements go through PM

### ❌ Blocking on Perfection
**Problem**: Rejecting for minor issues that don't block
**Fix**: Use "Approve with Conditions" for non-blocking issues

### ❌ Vague Rejections
**Problem**: "This doesn't look right" without specifics
**Fix**: Every rejection must cite specific criterion and specific issue

### ❌ Skipping Reviews
**Problem**: Rushing to delivery, skipping gates
**Fix**: Make review gates mandatory checkpoints, no exceptions

---

## Review Timing Guidelines

| Review Gate | Target Duration | Max Duration |
|-------------|-----------------|--------------|
| Strategy Owner → PM | 1 day | 2 days |
| PM → Architect | 1 day | 2 days |
| Architect → Developer | 1 day | 2 days |
| Developer → Tester | 2 hours | 1 day |
| Tester → Writer | 1 day | 2 days |
| Writer → Release | 1 day | 2 days |
| Operations Review | 1 day | 2 days |

**Principle**: Reviews should not be bottlenecks. If review is taking too long, escalate.

---

## Self-Review (Before Handoff)

Every role should self-review before handing off:

### PM Self-Review
- [ ] Essence Triangle is satisfied
- [ ] Requirements are clear and testable
- [ ] Scope is bounded
- [ ] Stakeholders are aligned

### Strategy Owner Self-Review
- [ ] Decision framework is explicit and consistent
- [ ] Benchmarks are measurable and testable
- [ ] Risk limits are explicit and acceptable
- [ ] Inputs/outputs are fully defined

### Architect Self-Review
- [ ] Design follows KISS principle
- [ ] Design follows LEGO principle
- [ ] Control flow is clear
- [ ] Data flow is clear
- [ ] Trade-offs are documented

### Developer Self-Review
- [ ] Code matches design
- [ ] Tests pass
- [ ] Coverage >80%
- [ ] Code is readable
- [ ] No obvious bugs

### Tester Self-Review
- [ ] All acceptance criteria tested
- [ ] Edge cases tested
- [ ] E2E scenarios tested
- [ ] No critical bugs remain

### Writer Self-Review
- [ ] Documentation matches implementation
- [ ] All user tasks covered
- [ ] Examples work
- [ ] No broken links

### Operations Self-Review
- [ ] Deployment plan tested
- [ ] Monitoring in place
- [ ] Runbooks complete
- [ ] Team trained

---

## Integration with Workflows

Each workflow document should reference this review gates document:

```markdown
### Handoff: Strategy Owner → PM

**Artifact**: STR-XXX
**Review Gate**: See `REVIEW_GATES.md` Gate 0 (Strategy Owner → PM)
**Approval Required Before**: PM creates FR-XXX

### Handoff: PM → Architect

**Artifact**: FR-XXX
**Review Gate**: See `REVIEW_GATES.md` Gate 1 (PM → Architect)
**Approval Required Before**: Architect begins design
```

---

## Summary

| Gate | Sender | Receiver | Primary Question |
|------|--------|----------|------------------|
| 0 | Strategy Owner | PM | "Is the decision framework correct and testable?" |
| 1 | PM | Architect | "Is this buildable?" |
| 2 | Architect | Developer | "Is this implementable?" |
| 3 | Developer | Tester | "Is this testable?" |
| 4 | Tester | Writer | "Is this documentable?" |
| 5 | Writer | Release | "Is this releasable?" |
| 6 | All | Operations | "Is this operable?" |
| **7** | **All** | **PM** | **"Is this what we specified?"** |

**The PM Bookend**: PM starts the feature (writes spec) and PM ends it (accepts delivery). This creates accountability and ensures the feature delivers actual value, not just code.

**Remember**: The receiving role is the reviewer. They accept responsibility when they approve.
