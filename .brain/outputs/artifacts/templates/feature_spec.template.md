# Artifact: Feature Specification

**Type**: Immutable
**Owner**: Product Manager
**File Pattern**: `specs/features/FR-{NNN}-{short-name}.md`

## Purpose

A Feature Specification (FR) documents WHAT to build and WHY. It is the contract between stakeholders, Product Manager, and the development team.

## Lifecycle

1. **Draft**: PM creates initial spec
2. **Review**: Stakeholders, Architect review
3. **Approved**: Locked, becomes immutable
4. **Implemented**: Design and code reference this
5. **Verified**: Tester validates against acceptance criteria

**Once approved, the spec is IMMUTABLE.** Changes require a new spec (Enhancement or new FR).

## Template

```markdown
# Feature Specification: FR-{NNN}-{short-name}

**Date**: YYYY-MM-DD
**Author**: {PM name}
**Status**: Draft | In Review | Approved | Implemented | Verified
**Version**: 1.0

---

## 1. Executive Summary

{One paragraph describing what this feature does and why it matters}

---

## 2. The Essence Triangle

### 2.1 Customer Value (Desirability)

#### Problem Statement
**Who**: {Specific user persona or segment}
**Situation**: {When/where does this problem occur?}
**Pain**: {What is the negative consequence? Quantify if possible}
**Frequency**: {How often? Per day/week/transaction?}

#### Solution Value
**Outcome**: {What tangible benefit does the user get?}
**Measurement**: {How do we know they received the value?}
**Alternative Comparison**: {How much better than current state/alternatives?}

#### Evidence of Need
- [ ] Customer interviews (N={count})
- [ ] Usage data from related features
- [ ] Competitor analysis
- [ ] Support ticket analysis
- [ ] Other: {specify}

**Evidence Summary**: {Brief description of evidence}

### 2.2 Business Impact (Viability)

#### Business Value
**Primary Impact Type**: Revenue | Cost Reduction | Risk Mitigation | Strategic Positioning | Retention
**Quantification**: {Estimated $ or % impact}
**Timeframe**: {When does value realize? Immediate/3mo/6mo/1yr}

#### Value Capture
**Mechanism**: {How does business capture this value?}
**Dependencies**: {What else must be true for value capture?}
**Sustainability**: {Ongoing cost vs. ongoing benefit}

#### Priority Context
**Urgency**: {Market window? Competitive pressure? Customer deadline?}
**Opportunity Cost**: {What are we NOT doing to build this?}

### 2.3 Product Building (Feasibility)

#### Technical Assessment
**Approach Summary**: {High-level how}
**Precedent**: {Have we or industry done similar? Reference if yes}
**Key Unknowns**: {Technical uncertainties}
**Proof Required**: {Prototype/spike needed before committing?}

#### Effort Estimate
**Size**: S | M | L | XL
**Effort Range**: {X-Y person-days/weeks}
**Calendar Time**: {Elapsed time with dependencies}
**Team Needs**: {Skills/roles required}

#### Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| {Risk 1} | H/M/L | H/M/L | {Plan} |
| {Risk 2} | H/M/L | H/M/L | {Plan} |

---

## 3. Functional Requirements

### 3.1 User Stories

**US-1**: As a {persona}, I want to {action} so that {benefit}.
**US-2**: As a {persona}, I want to {action} so that {benefit}.

### 3.2 Acceptance Criteria

| ID | Criterion | Testable | Priority |
|----|-----------|----------|----------|
| AC-1 | {Given/When/Then or clear statement} | Yes | Must |
| AC-2 | {Given/When/Then or clear statement} | Yes | Must |
| AC-3 | {Given/When/Then or clear statement} | Yes | Should |

**Acceptance Criteria Format**:
- Given {precondition}
- When {action}
- Then {expected result}

---

## 4. Scope

### 4.1 In Scope
- {Capability 1}
- {Capability 2}
- {Capability 3}

### 4.2 Out of Scope (Explicit)
- {What we are NOT building}
- {What might be assumed but isn't included}
- {Future considerations deferred}

### 4.3 Dependencies
- {Dependency 1}: {Status}
- {Dependency 2}: {Status}

---

## 5. User Experience

### 5.1 User Journey
{Description or diagram of user flow}

### 5.2 Key Interactions
{Important UI/UX considerations}

### 5.3 Error Handling
| Error Scenario | User Experience |
|----------------|-----------------|
| {Scenario 1} | {What user sees/can do} |
| {Scenario 2} | {What user sees/can do} |

---

## 6. Success Metrics

| Metric | Current | Target | Measurement Method |
|--------|---------|--------|-------------------|
| {Metric 1} | {Baseline} | {Goal} | {How measured} |
| {Metric 2} | {Baseline} | {Goal} | {How measured} |

---

## 7. Non-Functional Requirements

### 7.1 Performance
- {Response time requirements}
- {Throughput requirements}

### 7.2 Security
- {Security requirements}
- {Compliance requirements}

### 7.3 Reliability
- {Availability requirements}
- {Recovery requirements}

---

## 8. Approvals

| Role | Name | Date | Decision |
|------|------|------|----------|
| Product Manager | {Name} | YYYY-MM-DD | Proposed |
| Stakeholder | {Name} | YYYY-MM-DD | Approved/Rejected |
| Architect | {Name} | YYYY-MM-DD | Feasible/Concerns |

---

## 9. References

- Related Features: {FR-XXX if any}
- Market Research: {Link if any}
- Customer Feedback: {Link if any}

---

## 10. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | {Name} | Initial specification |
```

---

## Validation Checklist

Before marking as "Approved":

### Essence Triangle
- [ ] Customer value clearly articulated
- [ ] Evidence of need documented
- [ ] Business impact quantified
- [ ] Feasibility assessed by Architect

### Completeness
- [ ] All acceptance criteria are testable
- [ ] Out of scope is explicit
- [ ] Dependencies identified
- [ ] Success metrics defined

### Quality
- [ ] No jargon or ambiguity
- [ ] Examples provided where helpful
- [ ] Stakeholder review complete
- [ ] Approval signatures obtained

---

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Vague acceptance criteria | Can't test, arguments later | Use Given/When/Then format |
| No evidence of need | Building on assumptions | Require evidence section |
| Missing "out of scope" | Scope creep | Explicit exclusions |
| No success metrics | Can't prove value delivered | Define before approval |
| Solution in spec | Constrains design unnecessarily | Describe WHAT, not HOW |
