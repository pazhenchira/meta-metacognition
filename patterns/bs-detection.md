# BS Detection Pattern Library

Codified patterns of work that looks complete but lacks substance.

---

## Why This Exists

Experienced execs can "smell" when something is off even when boxes are checked. This library codifies those patterns so they can be detected and addressed.

---

## Pattern Categories

### 1. Generic Boilerplate

**What it looks like**: Language and structure that could apply to any project.

**Detection signals**:
- Replace project name with "FooBar" - still makes sense?
- No context-specific decisions visible
- Could be copy-pasted from a template without modification
- "Best practices" cited without fit justification

**Probing question**: "What's specific to OUR situation that shaped this?"

**Example (Bad)**:
> "We will use a microservices architecture for scalability and maintainability."

**Example (Good)**:
> "We chose microservices because our payment and inventory teams deploy on different schedules, and last quarter's monolith deployment blocked inventory for 3 days."

---

### 2. Complexity Theater

**What it looks like**: Impressive diagrams, extensive documentation, sophisticated architecture - but unclear what it actually DOES.

**Detection signals**:
- Can't explain it simply in 30 seconds
- Many components but unclear data flow
- Sophisticated patterns without clear problem they solve
- "Future-proofing" without current need

**Probing question**: "Show me the simplest thing that would work. Why isn't that enough?"

---

### 3. Cargo Cult Design

**What it looks like**: Patterns adopted because "that's how X company does it" without understanding why.

**Detection signals**:
- "Netflix/Google/Amazon does this"
- Pattern doesn't fit our scale/context
- No understanding of trade-offs
- Copying structure without understanding forces

**Probing question**: "What problem did this pattern solve for THEM? Do we have that problem?"

---

### 4. Activity Without Output

**What it looks like**: Lots of meetings, documents, discussions - but nothing shippable.

**Detection signals**:
- Many status updates, few demos
- "We're making progress" without artifacts
- Blocked by external factors (always)
- Research that never concludes

**Probing question**: "What can I see/touch/run today that I couldn't last week?"

---

### 5. Missing "Why"

**What it looks like**: Decisions made but rationale invisible.

**Detection signals**:
- "We decided to use X" without why
- Alternatives not mentioned
- Trade-offs not discussed
- Confident assertion without evidence

**Probing question**: "What alternatives did you reject? Why?"

---

### 6. Shallow Iteration

**What it looks like**: Claims of revision/improvement but essentially same work.

**Detection signals**:
- v1 and v2 are nearly identical
- Feedback addressed superficially
- Core issues remain
- "I updated it" without substantive change

**Probing question**: "What's fundamentally different between this version and the last?"

---

### 7. Premature Certainty

**What it looks like**: High confidence without proportional evidence.

**Detection signals**:
- No hedging or uncertainty expressed
- Estimates without ranges
- "This will definitely work"
- No failure modes considered

**Probing question**: "What would prove you wrong? What's your confidence level and why?"

---

### 8. Process Over Progress

**What it looks like**: Extensive process artifacts, minimal actual work.

**Detection signals**:
- Beautiful Gantt charts, no code
- Detailed requirements, no prototype
- Risk registers without mitigations executed
- Meetings about meetings

**Probing question**: "Show me what shipped, not what's planned."

---

## Detection Heuristics

Quick checks for reviewers:

| Check | What to Look For |
|-------|------------------|
| **Specificity** | Context-specific details vs. generic language |
| **Trade-offs** | Alternatives considered and rejected |
| **Evidence** | Data/demos vs. assertions |
| **Surprise** | What they learned vs. what they assumed |
| **Struggle** | Where they got stuck and unstuck |
| **Simplest** | Why simple solution isn't sufficient |

---

## Using This Library

### For App Orchestrators (Verification)
- After role output, check against these patterns
- If patterns detected, probe with questions before accepting
- Include pattern check in verification

### For Testers
- Consult before approving significant work
- Use probing questions to dig deeper
- Call out patterns by name in review

### For Roles (Self-Check)
- Before claiming completion, self-check against patterns
- Preemptively address "why" and trade-offs
- Show evidence, not just assertions

---

## Adding New Patterns

When you spot a new BS pattern:
1. Name it clearly
2. Describe detection signals
3. Provide probing question
4. Give good/bad examples
5. Add to this library

---

**Version**: 1.0  
**Last Updated**: 2026-02-02
