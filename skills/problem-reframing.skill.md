---
name: "problem-reframing"
description: "Reframe problems that resist direct solution through constraint interrogation and multiple perspectives"
argument-hint: "The problem that resists direct solution, including approaches already tried"
stage: "when-stuck"
version: "0.1.0"
---

# Skill: Problem Reframing

## Why This Skill Exists

Teams hit a wall and keep pushing the same approach harder. The assumption is "we haven't tried hard enough" when the real issue is "we're solving the wrong problem." Reframing unlocks solutions that brute force misses — the problem isn't hard, it's misframed.

meta-metacognition's recurring failure mode is "designed but never operationalized" — concepts that exist in docs but no agent spec references them. Reframing often reveals the problem isn't the concept but the wiring.

Three failure modes this skill prevents:

1. **Persistence on a dead-end frame**. An agent tries the same category of solution three times, each more elaborate. The problem isn't that the solutions are weak — it's that the problem formulation is wrong. A well-framed problem often has an obvious solution.
2. **Assumed constraints that aren't real**. "We can't do X because of Y" — but nobody checked whether Y is actually true. The constraint was inherited from a prior context, stated by someone with partial information, or simply never questioned.
3. **Single-perspective lock-in**. The problem is framed only as a technical problem when it's really a coordination problem. Or only as a resource problem when it's really a knowledge problem. Single-frame thinking hides the actual leverage point.

## Protocol

### Step 1: State the Problem as Currently Understood

Capture the current state completely before reframing:

- **The problem**: State it in one sentence
- **Approaches tried**: List what's been attempted and why each failed or was insufficient
- **Assumed constraints**: List every constraint currently accepted as given
- **Current frame**: What type of problem is this being treated as? (Technical? Resource? Process? People?)

- **Input**: The stuck problem + history of attempts
- **Output**: Complete problem statement with context
- **Gate**: If approaches tried is empty, this skill is premature — try direct solution first

### Step 2: 5 Whys Upward — Find the Real Problem

Ask "Why does this matter?" five times, moving UP the causal chain to find the real goal behind the stated problem:

1. **Why does [stated problem] matter?** → Because [reason 1]
2. **Why does [reason 1] matter?** → Because [reason 2]
3. **Why does [reason 2] matter?** → Because [reason 3]
4. **Why does [reason 3] matter?** → Because [reason 4]
5. **Why does [reason 4] matter?** → Because [real goal]

The real goal at the top of the chain may suggest entirely different solution paths than the stated problem at the bottom.

**Quality check**: Each "why" must produce a genuinely higher-level concern, not a restatement. If you're going in circles, the chain is malformed.

### Step 3: Interrogate Every Constraint

Take each constraint from Step 1 and challenge it:

| Constraint | Is it real? | What if it didn't exist? | What if it were an advantage? |
|------------|-------------|-------------------------|-------------------------------|
| [Constraint 1] | [Yes: evidence / No: assumed] | [What opens up?] | [How could this help?] |
| [Constraint 2] | ... | ... | ... |

**Rules**:
- "Real" means externally imposed and verified (law, physics, confirmed technical limitation). Everything else is "assumed."
- For assumed constraints, describe what becomes possible if the constraint is removed.
- The "advantage" column forces creative inversion — sometimes constraints are features, not bugs.

### Step 4: Generate 3+ Alternative Frames

Restate the problem from at least three different perspectives:

**As a resource problem**: What's scarce? What would we do with unlimited [time/money/people/compute]? If we had the resource, would the problem disappear?

**As a knowledge problem**: What don't we know? If we knew [X], would the path be obvious? Who might already know this?

**As a coordination problem**: Who needs to align? Is the problem that capable people aren't connected? Would the problem dissolve if the right people were in the same room?

Additional frames to consider:
- **As a sequencing problem**: Are we doing things in the wrong order?
- **As a definition problem**: Are we measuring the wrong thing?
- **As a motivation problem**: Do the incentives point the wrong way?

### Step 5: Lateral Provocation

Force unexpected connections:

1. **Industry transfer**: How would a completely different industry solve this? (If a hospital had this problem... if a game studio faced this... if logistics companies dealt with this...)
2. **Inversion**: What if we solved the opposite problem? Instead of preventing X, what if we made X harmless? Instead of speeding up Y, what if Y didn't need to happen at all?
3. **Scale shift**: What if this problem were 10× bigger? 10× smaller? Does the solution approach change?

These provocations are not meant to produce direct solutions — they're meant to break fixation on the current frame.

### Step 6: Feasibility Gradient

Rate each reframed path from Steps 2–5:

| Path | Feasibility | Notes |
|------|-------------|-------|
| [Reframe / approach 1] | ✅ Fully feasible | [Can start immediately] |
| [Reframe / approach 2] | ⚠️ Feasible IF [condition] | [What needs to be true] |
| [Reframe / approach 3] | ❌ Infeasible BECAUSE [reason] | [Specific blocker] |

**Recommend the highest-feasibility path that addresses the real goal** (from Step 2), not just the stated problem.

## Output Format

```markdown
## Problem Reframing Result

### Problem as Currently Framed
[One sentence]

### Approaches Already Tried
1. [Approach] → [Why it failed]
2. [Approach] → [Why it failed]

### 5 Whys (Upward)
1. Why does [problem] matter? → [reason]
2. Why does [reason] matter? → [reason]
3. ...
**Real goal**: [The underlying goal revealed by the chain]

### Constraint Interrogation
| Constraint | Real? | Without it? | As advantage? |
|------------|-------|-------------|---------------|
| ... | ... | ... | ... |

### Alternative Frames
- **Resource frame**: [Problem restated]
- **Knowledge frame**: [Problem restated]
- **Coordination frame**: [Problem restated]

### Lateral Provocations
- **Industry transfer**: [Insight]
- **Inversion**: [Insight]

### Feasibility Gradient
| Path | Feasibility | Notes |
|------|-------------|-------|
| ... | ... | ... |

### Recommended Reframe
[The new problem statement that unlocks progress, with rationale]
```

## Activation Triggers

- A problem has resisted 2+ direct solution attempts
- An agent reports being stuck or inconclusive
- The same problem keeps recurring in different forms
- A solution feels unreasonably complex for what should be a simple problem

**Anti-triggers** (do NOT invoke this skill):
- First attempt at a problem (try direct solution first)
- Problems with known solutions that just need execution
- When the agent hasn't actually tried anything yet (effort before reframing)
