---
name: "skill-selector"
description: "Routes work stages to appropriate quality protocols"
version: "0.1.0"
---

# Skill Selector — meta-metacognition

> **Purpose**: Map work stages to skills so Atlas and agents know which quality protocols to invoke, and when.

---

## How to Use

Before entering a work stage, check this selector. If a trigger matches the current situation, read the linked skill file and follow its protocol. Skills are procedures — follow the steps, fill in the output format, then continue with the work.

**Routing flow**:
```
Work arrives → Identify STAGE → Check this selector → Invoke matched skill → Continue
```

Skills are invoked BY agents, not dispatched TO. Any agent can invoke any skill at the matching stage.

---

## Process Skills (Always Check First)

These skills fire based on the **stage of work**, not the topic. Before beginning any work stage listed below, check whether the trigger conditions match.

### [`investigation-framing`](investigation-framing.skill.md)

Validates the question before executing analysis. Prevents thorough answers to the wrong question by forcing agents to articulate the decision context, scope boundary, and "good enough" criteria before diving in.

**Triggers**: Agent is about to investigate, research, analyze, perform root-cause analysis, or compare options.

### [`pre-ship-review`](pre-ship-review.skill.md)

Chain-of-Verification on any deliverable before it ships. Checks claims against evidence, applies type-appropriate checklists, and renders a SHIP / REVISE / BLOCK verdict.

**Triggers**: A deliverable is ready — agent is presenting results, declaring done, committing code, or submitting a recommendation.

### [`structured-challenge`](structured-challenge.skill.md)

Stress-tests high-stakes recommendations through adversarial questioning. Applies steel-man, pre-mortem, failure mode analysis, and reversibility checks to surface blind spots before commitment.

**Triggers**: A recommendation has significant blast radius, is irreversible or hard to reverse, or will be directly acted on by stakeholders.

### [`problem-reframing`](problem-reframing.skill.md)

Breaks out of unproductive problem formulations by re-examining the problem from multiple angles. Uses 5 Whys, constraint interrogation, and cross-domain analogies to unlock progress.

**Triggers**: Two or more direct solution attempts have failed, the Analyst is inconclusive, or the team is going in circles on the same approach.

### [`strategic-synthesis`](strategic-synthesis.skill.md)

Validates that strategic recommendations include the reasoning chain stakeholders need — tradeoffs, cascading choices, concrete next actions, and time-horizon tensions.

**Triggers**: Agent is producing strategic guidance, making recommendations with cascading downstream choices, or advising on direction.

### [`stakeholder-lens`](stakeholder-lens.skill.md)

Ensures final output matches the primary stakeholder's quality bar, format expectations, and decision needs — not just technical correctness.

**Triggers**: Final output is being prepared for sponsor or stakeholder consumption, or an artifact will leave the team boundary.

---

## Routing Table

| Work Stage | Trigger | Skill | Required? |
|---|---|---|---|
| **Before analysis** | Investigation, research, analysis, root cause, comparison | [`investigation-framing`](investigation-framing.skill.md) | Recommended |
| **Before shipping** | Deliverable ready, presenting, declaring done | [`pre-ship-review`](pre-ship-review.skill.md) | **Required** |
| **Before high-stakes decision** | Significant blast radius, irreversible, will be acted on | [`structured-challenge`](structured-challenge.skill.md) | **Required** |
| **When stuck** | 2+ failed approaches, Analyst inconclusive | [`problem-reframing`](problem-reframing.skill.md) | Recommended |
| **Before strategic advice** | Strategic guidance, cascading choices | [`strategic-synthesis`](strategic-synthesis.skill.md) | Recommended |
| **Before presenting to stakeholder** | Final output for sponsor consumption | [`stakeholder-lens`](stakeholder-lens.skill.md) | Recommended |

---

## Required vs. Recommended

- **Required**: Atlas MUST invoke this skill at this stage. Skipping is a process violation. No exceptions without an explicit override from the sponsor.
- **Recommended**: Atlas SHOULD invoke this skill. May skip if context clearly doesn't warrant it (e.g., trivial deliverable for `pre-ship-review`). Log the skip reason when omitting.

---

## Anti-Triggers (When NOT to Use)

Not every work stage warrants a skill. Over-application wastes effort and trains agents to treat skills as ceremony rather than protection.

| Skill | Do NOT invoke when... |
|---|---|
| `investigation-framing` | Simple lookups or factual retrieval ("what's in file X?", "read the config") |
| `pre-ship-review` | Intermediate work products — drafts, WIP artifacts, internal notes still in progress |
| `structured-challenge` | Low-risk, easily reversible decisions with limited blast radius |
| `problem-reframing` | First attempt at a problem — only invoke after direct approaches have failed |
| `strategic-synthesis` | Tactical or implementation-level decisions that don't cascade |
| `stakeholder-lens` | Internal-only artifacts — status updates, team notes, working documents |

---

## Customization

meta-metacognition can extend this selector with project-specific skills and triggers.

**To add a project-specific skill**:
1. Create `{skill-name}.skill.md` in the `skills/` directory following the skill specification format
2. Add a row to the **Routing Table** above with the trigger conditions and Required/Recommended designation
3. Done — Atlas already checks this selector, so new skills are discovered automatically

**To adjust existing skills**:
- Change **Required** ↔ **Recommended** to match meta-metacognition's risk tolerance
- Add project-specific trigger language to existing rows
- Add project-specific anti-triggers to prevent over-application

**Example custom entry**:

| Work Stage | Trigger | Skill | Required? |
|---|---|---|---|
| **Before API changes** | Modifying public API surface, changing contracts | `api-validation` | **Required** |
