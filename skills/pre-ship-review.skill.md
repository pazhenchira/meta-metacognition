---
name: "pre-ship-review"
description: "Chain-of-Verification on any deliverable before it ships"
argument-hint: "The deliverable to review (code, document, recommendation, or design)"
stage: "before-shipping"
version: "0.1.0"
---

# Skill: Pre-Ship Review

## Why This Skill Exists

Deliverables ship with unexamined assumptions, missing edge cases, and hollow claims. Enthusiasm creates blind spots — the agent that built something is the worst judge of its completeness. Chain-of-Verification catches what self-review misses.

For meta-metacognition, this is critical because engine changes propagate to ALL applications built by the pipeline. A defective template, broken orchestrator habit, or incorrect upgrade instruction has blast radius across every app that uses the engine.

Three failure modes this skill prevents:

1. **Hollow claims**. A document says "this approach is more efficient" without evidence. The claim sounds right, passes casual reading, but is ungrounded. Recipients make decisions based on vibes, not verified facts.
2. **Completeness gaps**. The deliverable answers the stated question but misses aspects the requester assumed would be covered. "I asked for a design and got a design — but it doesn't address error handling."
3. **Producer blindness**. The agent who built something reads it with full context. The recipient reads it cold. What's obvious to the producer is opaque to the consumer. This gap ships silently without explicit consumer-perspective checking.

## Protocol

### Step 1: Restate the Original Ask

Before reviewing the deliverable, restate what was originally requested. This anchors the review to the actual requirement, not what the deliverable happens to contain.

- **Input**: The original task/request + the deliverable
- **Output**: One paragraph restating what was asked for
- **Gate**: If the original ask is unclear, clarify before reviewing

### Step 2: Decompose Into Verifiable Claims

Read the deliverable and extract every claim it makes — explicit and implicit. Include:

- **Structural claims**: "This design has 3 components" → verify there are exactly 3
- **Completeness claims**: "This covers all edge cases" → verify which cases were considered
- **Negative claims**: "There are no security implications" → verify this was actually checked
- **Causal claims**: "X causes Y" → verify the causal chain
- **Quantitative claims**: Any numbers, metrics, percentages → verify source

List each claim explicitly. Unlisted claims are unreviewed claims.

### Step 3: Independently Verify Each Claim

For EACH claim from Step 2, state what you checked and what you found:

- ✅ **Verified**: [What you saw that confirms the claim]
- ⚠️ **Partially verified**: [What's confirmed, what's still uncertain]
- ❌ **Unverified**: [What evidence is missing]
- 🔴 **Contradicted**: [What evidence contradicts the claim]

**Critical rule**: Describe WHAT YOU SAW, not just "verified." "Checked the test file and found 12 test cases covering the 4 stated scenarios" — not just "tests verified."

### Step 4: Check Completeness Against Original Ask

Compare the deliverable to the original request from Step 1:

- Does the deliverable address every aspect of the request?
- Are there aspects the requester would reasonably expect that are missing?
- Is anything included that wasn't requested (scope creep)?

### Step 5: Consumer Perspective Check

Read the deliverable as the recipient would — cold, without the context the producer had:

- Can someone unfamiliar with the work understand this?
- Are terms defined? Is context provided?
- Does the structure guide the reader or require them to already know the answer?
- Is the key takeaway clear within the first few lines?

### Step 6: Artifact-Type Checklist

Apply the checklist matching the deliverable type:

**Analysis**:
- [ ] MECE? (Mutually Exclusive, Collectively Exhaustive categories)
- [ ] Differential explained? (If comparing, are both sides fairly represented?)
- [ ] Fact vs. inference vs. assumption clearly distinguished?
- [ ] Synthesis provided, not just a data dump?

**Document**:
- [ ] Reader has context at every point? (No orphaned references)
- [ ] Standalone summary present? (Can someone get the gist without reading everything?)
- [ ] Structure works as an argument? (Flows logically, not just listed)
- [ ] Specific over abstract? (Concrete examples, not vague generalizations)

**Recommendation**:
- [ ] Decision clearly framed? (What exactly is being decided?)
- [ ] Cascading choices complete? (Downstream implications addressed)
- [ ] Tradeoffs named explicitly? (What you gain AND what you give up)
- [ ] Counter-indicator stated? (Under what conditions would this be the wrong choice?)

**Code**:
- [ ] Tests pass? (Verified, not assumed)
- [ ] Edge cases handled? (Empty inputs, boundaries, concurrent access)
- [ ] Error handling present? (Failures are caught and reported, not silent)
- [ ] Matches requirements? (Implements what was asked, not what was convenient)
- [ ] No regressions? (Existing functionality still works)

**Design**:
- [ ] Interfaces defined? (Clear contracts between components)
- [ ] Dependencies mapped? (What depends on what)
- [ ] Failure modes considered? (What happens when things go wrong)
- [ ] Extensibility addressed? (Can this grow without rewriting)

### Step 7: Verdict

Based on all checks above, render one verdict:

| Verdict | Meaning |
|---------|---------|
| **SHIP** | All claims verified, complete against original ask, consumer-ready |
| **REVISE** | Specific items need correction — list each item with what needs to change |
| **BLOCK** | Fundamental issue prevents shipping — state the blocking reason |

## Output Format

```markdown
## Pre-Ship Review Result

### Original Ask
[Restated from Step 1]

### Artifact Type
[Analysis / Document / Recommendation / Code / Design]

### Claim Verification
| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | [Claim text] | ✅ Verified | [What was seen] |
| 2 | [Claim text] | ⚠️ Partial | [What's confirmed/uncertain] |
| 3 | [Claim text] | ❌ Unverified | [What's missing] |

### Completeness Check
- [x] Addresses original ask fully
- [ ] Missing: [aspect not covered]

### Consumer Readability
[Assessment: clear / needs context / confusing]

### Artifact Checklist
[Completed checklist from Step 6 for the relevant type]

### Verdict: [SHIP / REVISE / BLOCK]
[If REVISE: specific items to fix]
[If BLOCK: blocking reason]
```

## Activation Triggers

- An agent has a deliverable ready to present, commit, or share
- Work product is moving from "in progress" to "done"
- Output will be consumed by someone other than the producer

**Anti-triggers** (do NOT invoke this skill):
- Intermediate work products (drafts, WIP, brainstorms)
- Internal notes not leaving the producing agent
- Trivial acknowledgments or status updates
