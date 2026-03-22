---
name: "structured-challenge"
description: "Stress-test recommendations through steel-manning, failure modes, and pre-mortem"
argument-hint: "The recommendation or decision being proposed"
stage: "before-strategy"
version: "0.1.0"
---

# Skill: Structured Challenge

## Why This Skill Exists

High-stakes recommendations get presented without adversarial testing. The agent that formulated a recommendation has confirmation bias — they've already convinced themselves. Peer review catches surface issues but rarely challenges the core thesis. Structured challenge applies deliberate adversarial pressure using a repeatable protocol.

In meta-metacognition, high-stakes decisions include: new engine concepts (like skills), orchestrator habit changes, and pipeline template modifications — all propagate to applications built by the engine.

Three failure modes this skill prevents:

1. **Confirmation bias surviving review**. The recommending agent presents evidence that supports their conclusion. Reviewers, lacking a structured adversarial protocol, accept the framing. The recommendation ships without anyone seriously asking "what if this is wrong?"
2. **Unexamined failure modes**. A recommendation is technically sound in the happy path but fragile under stress. Nobody asked "how does this fail?" because the question wasn't part of the process.
3. **Irreversible commitment without safeguards**. A decision is treated as low-risk because "we can always change it later" — but nobody checked whether that's actually true. Some decisions create lock-in that isn't apparent until too late.

## Protocol

### Step 1: Classify Stakes

Determine the level of scrutiny needed:

| Stakes | Criteria | Protocol Scope |
|--------|----------|----------------|
| **High** | Hard to reverse, large blast radius, affects many people/systems | Full protocol (Steps 2–5) |
| **Medium** | Moderately reversible, limited blast radius | Steps 2–3 only |
| **Low** | Easily reversible, contained impact | Step 2 only |

- **Input**: The recommendation + context about its impact
- **Output**: Stakes classification with justification
- **Gate**: If stakes are unclear, default to Medium

### Step 2: Steel-Man the Position

State the **strongest possible version** of the recommendation. This is NOT a summary — it's the most compelling case for why this recommendation is correct.

**Quality test**: Would the person who made this recommendation agree that your steel-man is their best argument? If they'd say "that's not quite what I mean," your steel-man is incomplete.

Then, state the **strongest counter-position** — the best argument AGAINST the recommendation. What would a thoughtful critic say?

- **Output**: Steel-man (for) + strongest counter-argument (against)
- **Gate**: Both positions must be genuinely strong. Straw-manning either side invalidates the challenge.

### Step 3: Identify Specific Failure Modes

List 3–5 concrete ways this recommendation could fail. For each failure mode, specify:

| Element | Description |
|---------|-------------|
| **Condition** | Under what circumstances does this fail? |
| **Mechanism** | How exactly does the failure happen? (The causal chain) |
| **Evidence** | What current evidence suggests this failure is plausible? |
| **Likelihood** | High / Medium / Low — with reasoning |

**Rules**:
- Failure modes must be specific, not vague. "It might not work" is not a failure mode. "Under peak load, the queue backs up because consumers can't keep pace with producers" is.
- Include at least one failure mode the recommender probably hasn't considered.
- Include at least one failure mode related to human/organizational factors, not just technical.

### Step 4: Pre-Mortem (High-Stakes Only)

**Skip this step for Medium and Low stakes.**

Assume it's 6 months from now and the recommendation was implemented but **failed**. Write the failure narrative:

- What went wrong?
- When did the first signs appear?
- What was the root cause?
- What could have been done differently?
- Who was affected?

The narrative should be specific and plausible — a story someone could read and say "yes, that could really happen." Generic failure narratives ("it didn't work because of unforeseen circumstances") are useless.

### Step 5: Verdict With Constructive Path

Based on Steps 2–4, render a verdict:

| Verdict | Meaning |
|---------|---------|
| **Survives challenge** | No critical failure modes; proceed as proposed |
| **Survives with modifications** | Core recommendation is sound; specific changes needed (list them) |
| **Requires safeguards** | Proceed, but with explicit monitoring/rollback plan for identified risks |
| **Reconsider** | Critical failure modes or irreversibility make this too risky; suggest alternatives |

For every verdict except "Survives challenge," provide:
- **Specific modifications** or safeguards needed
- **What to watch for** — early warning signs of identified failure modes
- **Reversal plan** — how to undo this if failure modes materialize

## Output Format

```markdown
## Structured Challenge Result

### Recommendation Under Challenge
[One-sentence summary of what's being challenged]

### Stakes Classification
[High / Medium / Low] — [Justification]

### Steel-Man
**For**: [Strongest case for the recommendation]
**Against**: [Strongest case against]

### Failure Modes
| # | Condition | Mechanism | Evidence | Likelihood |
|---|-----------|-----------|----------|------------|
| 1 | [When] | [How it fails] | [Why plausible] | [H/M/L] |
| 2 | ... | ... | ... | ... |

### Pre-Mortem (if High stakes)
[Failure narrative — specific, plausible, instructive]

### Verdict: [Survives / Survives with modifications / Requires safeguards / Reconsider]
**Modifications needed**: [If applicable]
**Watch for**: [Early warning signs]
**Reversal plan**: [How to undo if needed]
```

## Activation Triggers

- A recommendation has significant blast radius or is difficult to reverse
- A strategic choice will constrain future options
- Someone proposes a major architectural, process, or organizational change
- The cost of being wrong is substantially higher than the cost of checking

**Anti-triggers** (do NOT invoke this skill):
- Easily reversible, low-risk decisions (tool choices, formatting preferences)
- Decisions already made that can't be changed (challenge before commitment, not after)
- First-draft ideas still being explored (challenge solidified proposals, not brainstorms)
