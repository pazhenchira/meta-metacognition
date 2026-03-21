# Structured Challenge

> Steel-man, then stress-test recommendations before they reach the user.

## Why This Skill Exists

Superficial challenge is worse than no challenge — it creates false confidence. The most valuable step (understanding the position before attacking it) is the most commonly skipped. This skill enforces the full protocol.

## Protocol

### Step 1 — Classify the Stakes

| Blast Radius | Protocol | Examples |
|-------------|----------|----------|
| **High** — irreversible, cross-org | Full protocol (all steps) | Investment decisions, architecture commitments |
| **Medium** — significant but reversible | Steps 2-3 (skip pre-mortem) | Technical approach choices, priority changes |
| **Low** — contained, easily corrected | Quick sniff test (Step 2 only) | Minor scope adjustments |

### Step 2 — Steel Man the Position

Before any critique, articulate the STRONGEST version of the recommendation.

- What is the recommendation in its best light?
- What is the strongest evidence FOR it?
- What does it get RIGHT?

**Quality test**: Would the person who made this recommendation recognize your characterization? If not, you're attacking a straw man.

### Step 3 — Identify Specific Failure Modes

"This might not work" is not a challenge. Name the specific conditions under which it fails.

For each failure mode:
- **Fails when**: [specific condition]
- **Because**: [specific mechanism]
- **Evidence this could happen**: [data/precedent]
- **Likelihood**: [High/Medium/Low]

### Step 4 — Pre-Mortem (High-Stakes Only)

Assume the recommendation was implemented and failed. It's 6 months later. What happened?

- Most likely reason it failed
- Warning signs we should have seen
- What we would do differently

### Step 5 — Verdict with Constructive Path

```
### Challenge Verdict
- **Steel man quality**: [demonstrates understanding?]
- **Failure modes**: [N total, N high-likelihood]
- **Recommendation survives?**: [Yes with modifications / Yes as-is / No]
- **Modifications recommended**: [specific changes]
- **What to watch**: [early warning signals]
```
