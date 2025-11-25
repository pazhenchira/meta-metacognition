# Phase 1.5: Intuition & Wisdom System

## Overview

Phase 1.5 adds **intuition and judgment capabilities** to the meta-orchestrator through accumulated wisdom from legendary engineers, strategists, designers, and risk theorists.

**Goal**: Enable the meta-orchestrator to make better decisions by consulting distilled principles, recognizing patterns, and avoiding common pitfalls.

**Status**: ✅ Complete

**Version**: 1.2.0 (November 24, 2025)

---

## What Was Added

### 1. Wisdom Libraries (`.meta/wisdom/`)

Distilled principles from historical figures with actionable triggers:

- **`engineering_wisdom.md`** (15 principles)
  - Kernighan, Knuth, Dijkstra, Pike, Kay, Torvalds, Hoare, Brooks, Parnas, Bentley, Liskov, Wirth, Carmack
  - Examples: "Debugging is twice as hard as writing" (Kernighan), "Premature optimization is evil" (Knuth), "Simplicity is prerequisite for reliability" (Dijkstra)

- **`strategic_wisdom.md`** (15 principles)
  - Sun Tzu, Boyd (OODA loop), Clausewitz, Taleb, Kahneman
  - Examples: "Know yourself and the enemy" (Sun Tzu), "Fast OODA loops win" (Boyd), "Build antifragile systems" (Taleb)

- **`design_wisdom.md`** (8 principles, 10 sub-principles)
  - Dieter Rams (10 Principles of Good Design), Christopher Alexander (Pattern Language), Don Norman (Design of Everyday Things)
  - Examples: "Good design is as little design as possible" (Rams), "Affordances suggest usage" (Norman)

- **`risk_wisdom.md`** (12 principles + 8 security sub-principles)
  - Taleb (Black Swan, Antifragile), Kahneman (Thinking Fast and Slow), Schneier (Security Mindset), Saltzer & Schroeder (Protection Principles)
  - Examples: "Plan for unknown-unknowns" (Taleb), "Security requires adversarial thinking" (Schneier), "Least privilege" (Saltzer)

**Total**: 50+ principles with triggers and actions

### 2. Pattern Libraries (`.meta/patterns/`)

- **`antipatterns.md`** (15 antipatterns)
  - God Object, Golden Hammer, Premature Optimization, NIH Syndrome, Cargo Cult, Magic Numbers, Stringly Typed, Big Ball of Mud, Leaky Abstractions, Analysis Paralysis, Resume-Driven Development, Shotgun Surgery, Lava Flow, Inner Platform Effect, Test imbalances
  - Each with: historical precedent, symptoms, why it fails, remedy

- **`success_patterns.md`** (15 patterns)
  - LEGO Architecture, Repository, Circuit Breaker, API Gateway, Adapter, Saga, Event Sourcing, Feature Flags, Strangler Fig, CQRS, Bulkhead, Retry with Backoff, Idempotent Operations, Health Checks, Immutable Infrastructure
  - Each with: problem, solution, when to use, benefits, trade-offs

- **`trade_off_matrix.md`** (15 trade-offs)
  - Simplicity vs Power, Speed vs Quality, Build vs Buy, Monolith vs Microservices, SQL vs NoSQL, Normalize vs Denormalize, Sync vs Async, Push vs Pull, Optimistic vs Pessimistic, Stateless vs Stateful, Centralized vs Distributed, Vertical vs Horizontal Scaling, Dynamic vs Static Typing, Conservative vs Bold Tech, Generalization vs Specialization
  - Each with: decision matrix, defaults, decision rules

### 3. Intuition Framework (`.meta/principles.md` [P-INTUITION])

New section added to `.meta/principles.md`:

- **When to Apply Wisdom**: Maps wisdom to pipeline phases (REQUIREMENTS, DESIGN, CODING, REVIEW, VALIDATION)
- **Decision Framework**: Conservative vs Bold (when to favor proven approaches vs experimentation)
- **Risk Assessment Matrix**: Critical/High/Medium/Low risk levels with required actions
- **Trade-off Resolution Defaults**: 7 common trade-offs with defaults
- **Confidence Scoring**: 4-factor confidence calculation (domain knowledge, requirements clarity, precedent match, team familiarity)
- **Heuristic Triggers**: Automatic checks during DESIGN and REVIEW
- **Pattern Matching**: Success patterns vs antipatterns
- **Intuition Documentation**: How to track intuition checks in LEGO state

### 4. Updated `.meta/AGENTS.md`

Section 8 (LEGO-Orchestrator Sessions) enhanced to:
- Read wisdom files before starting work
- Consult wisdom during DESIGN phase
- Calculate confidence scores
- Check for antipatterns
- Document intuition checks in `lego_state_<name>.json`
- Apply wisdom triggers during CODING and VALIDATION

**State Format** (extended):
```json
{
  "lego_name": "example",
  "status": "design",
  "confidence_score": 0.85,
  "confidence_factors": {
    "domain_knowledge": 0.9,
    "requirements_clarity": 0.8,
    "precedent_match": 0.9,
    "team_familiarity": 0.8
  },
  "intuition_check": {
    "wisdom_applied": ["Kernighan: Keep it debuggable"],
    "antipatterns_avoided": ["God Object"],
    "trade_offs_resolved": {
      "simplicity_vs_power": "simplicity (KISS)"
    }
  }
}
```

---

## How It Works

### During REQUIREMENTS Phase
1. Consult `.meta/wisdom/strategic_wisdom.md` (Sun Tzu #1: "Know yourself and the enemy")
2. Use `.meta/wisdom/risk_wisdom.md` for risk assessment

### During LEGO Discovery
3. Check `patterns/antipatterns.md` to avoid God LEGOs
4. Apply Thompson's Unix Philosophy (#5 Engineering: "Do one thing well")

### During DESIGN Phase
5. Consult `patterns/success_patterns.md` for applicable patterns
6. Use `patterns/trade_off_matrix.md` for design decisions
7. Calculate confidence score (4 factors)
8. Apply wisdom from all categories
9. Check for antipatterns

### During CODING Phase
10. Apply `.meta/wisdom/engineering_wisdom.md` triggers (complexity, optimization, etc.)
11. Follow `.meta/wisdom/design_wisdom.md` (readable code, meaningful names)

### During REVIEW Phase
12. Pattern matching: success patterns vs antipatterns
13. Trust intuition: "Does this feel right?" (Alexander #3 Design)

### During VALIDATION Phase
14. Apply `.meta/wisdom/risk_wisdom.md` for sensitive LEGOs
15. Red-team if critical

---

## Benefits

**Better Decisions**:
- 50+ principles guide design choices
- Trade-off matrix provides defaults
- Pattern libraries offer templates

**Avoid Common Mistakes**:
- 15 antipatterns documented with remedies
- Historical precedents teach lessons
- Triggers catch issues early

**Consistent Quality**:
- Same wisdom applied across all LEGOs
- Confidence scoring identifies uncertainty
- Intuition tracking creates learning trail

**Learning System**:
- Documents why decisions were made
- Builds institutional knowledge
- Enables future improvements

---

## Examples

### Example 1: LEGO Discovery
**Without Intuition**:
```json
{
  "name": "auth_and_logging_and_session",
  "responsibility": "Handle auth, logging, and sessions"
}
```

**With Intuition**:
- Trigger: Thompson #5 Engineering ("Do one thing well")
- Antipattern detected: God Object
- Action: Split into 3 LEGOs: `auth`, `logging`, `session`

### Example 2: Design Decision
**Without Intuition**:
```python
# Implements custom caching with complex eviction logic
```

**With Intuition**:
- Trigger: Knuth #2 Engineering ("Premature optimization")
- Check: Has profiling data? NO
- Action: Defer optimization, use simple dict for now
- Document: "Optimize after profiling shows need"

### Example 3: Security Review
**Without Intuition**:
```python
def login(username, password):
    return db.query(f"SELECT * FROM users WHERE name='{username}' AND pass='{password}'")
```

**With Intuition**:
- Trigger: Schneier #8 Risk ("Security mindset")
- Antipattern: SQL injection vulnerability
- Wisdom: Saltzer #9.4 ("Complete mediation"), #9.3 ("Economy of mechanism")
- Action: Use parameterized queries, hash passwords
- Red-team: Flag for security review

---

## Usage

### For Users

When running meta-orchestrator, it will automatically:
1. Consult wisdom files during each phase
2. Check for antipatterns and suggest fixes
3. Calculate confidence scores for designs
4. Document intuition checks in LEGO state files

No action needed - wisdom is applied transparently.

### For Meta-Orchestrator

Read wisdom files at appropriate phases:
- REQUIREMENTS: strategic wisdom, risk wisdom
- LEGO Discovery: engineering wisdom, antipatterns
- DESIGN: all wisdom, trade-off matrix, success patterns
- CODING: engineering wisdom, design wisdom
- REVIEW: all wisdom, pattern matching
- VALIDATION: risk wisdom, security principles

### For Adding New Wisdom

To add a new principle to any wisdom file:
1. Identify source and historical context
2. State principle concisely (1-2 sentences)
3. Define clear trigger (when does this apply?)
4. Specify concrete action (what should meta-orchestrator do?)
5. Provide example if helpful
6. Test with real scenarios

Format:
```markdown
## N. [Name]

**Source**: [Person], [Work] ([Year])

**Principle**:
> "[Quote]"

**Application**: [How meta-orchestrator uses it]

**Trigger**:
- [When this activates]

**Action**:
1. [What to do]
```

---

## Future Enhancements (Phase 2+)

**Phase 2 (Agent Tuning & Problem Evolution)**:
- Reflective learning: Extract patterns from completed projects
- Failure catalog: Learn from mistakes
- Success catalog: Recognize what works
- Dynamic heuristic tuning based on outcomes

**Phase 3 (Production Monitoring)**:
- Telemetry feedback: Update wisdom from production data
- Drift detection: Identify when patterns change
- Continuous improvement: Refine heuristics over time

---

## Files Changed

**New Files** (7):
- `.meta/wisdom/engineering_wisdom.md`
- `.meta/wisdom/strategic_wisdom.md`
- `.meta/wisdom/design_wisdom.md`
- `.meta/wisdom/risk_wisdom.md`
- `.meta/patterns/antipatterns.md`
- `.meta/patterns/success_patterns.md`
- `.meta/patterns/trade_off_matrix.md`

**Modified**:
- `.meta/principles.md` (added [P-INTUITION] section)
- `.meta/AGENTS.md` (Section 8 enhanced with wisdom consultation)

**Total**: 9 files, ~8000+ lines of wisdom and patterns

---

## Acknowledgments

Wisdom distilled from:

**Engineering**: Brian Kernighan, Donald Knuth, Edsger Dijkstra, Rob Pike, Alan Kay, Linus Torvalds, Tony Hoare, Fred Brooks, David Parnas, Jon Bentley, Barbara Liskov, Niklaus Wirth, John Carmack

**Strategy**: Sun Tzu, John Boyd, Carl von Clausewitz, Nassim Taleb, Daniel Kahneman

**Design**: Dieter Rams, Christopher Alexander, Don Norman

**Security & Risk**: Nassim Taleb, Daniel Kahneman, Bruce Schneier, Jerome Saltzer, Michael Schroeder

---

Phase 1.5 transforms the meta-orchestrator from a procedural pipeline into a **judgment-enabled system** that makes decisions based on accumulated human wisdom.
