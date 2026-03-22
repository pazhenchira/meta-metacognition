---
name: "strategic-synthesis"
description: "Validate strategic recommendations have cascading choices, tradeoffs, and concrete actions"
argument-hint: "The strategic question, recommendation, or decision requiring synthesis"
stage: "before-strategy"
version: "0.1.0"
---

# Skill: Strategic Synthesis

## Why This Skill Exists

Strategic recommendations arrive as conclusions without the reasoning chain. The agent says "do X" without making explicit what you gain, what you lose, what downstream choices X forces, or what concrete action follows. Decision-makers need tradeoffs and "so what" — not just a recommendation.

Three failure modes this skill prevents:

1. **Conclusion without reasoning chain**. "We recommend migrating to microservices." Why? Compared to what? What does it cost? What does it force? The recommendation sounds decisive but gives the decision-maker no basis for judgment.
2. **False binary framing**. The recommendation presents two options when there are five. Or presents "do X vs. do nothing" when partial approaches exist. Integrative thinking is skipped because the binary frame wasn't challenged.
3. **Strategy without action bridge**. The strategic insight is brilliant. The "so what" is missing. Nobody knows what to do on Monday morning. Strategy without the bridge to action is philosophy, not strategy.

## Protocol

### Step 1: Frame the Decision

Before synthesizing, ensure the decision itself is well-defined:

- **The specific choice**: State it as a decision, not a topic. "Whether to adopt approach X" not "thoughts on approach X."
- **Stakes**: What's at risk? What's the blast radius of getting this wrong?
- **Timeline**: When must this decision be made? What's the cost of delay?
- **Reversibility**: Can this be undone? At what cost? Over what timeframe?

- **Input**: The strategic question or recommendation
- **Output**: Crisply framed decision with stakes, timeline, and reversibility
- **Gate**: If it's not a decision (just information or analysis), this skill doesn't apply — reframe as a decision or use an analysis protocol instead

### Step 2: Cascading Choices Check

Strategic choices don't exist in isolation. Check the cascade:

1. **Aspiration**: What is the overarching goal this serves? (Does this choice align with it?)
2. **Where to play**: What scope/domain does this constrain us to? (Markets, segments, capabilities)
3. **How to win**: What is our theory of competitive advantage? (Does this choice support it?)
4. **Capabilities required**: What must we be able to do? (Do we have them or must we build them?)
5. **Management systems**: What processes/structures support this? (Are they in place?)

**All 5 must be answered.** A strategy that answers "how" without "where" is incomplete. A strategy that states "what to build" without "what capabilities we need" will fail on execution.

If any level is unanswered, flag it explicitly: "Cascading gap: [level] is unaddressed."

### Step 3: Opportunity Cost and Tradeoff Declaration

For every strategic recommendation, make explicit:

**What we're choosing TO do:**
- [Action/investment/commitment 1]
- [Action/investment/commitment 2]

**What we're choosing NOT to do** (opportunity cost):
- [Alternative foregone 1] — and what we lose by not doing it
- [Alternative foregone 2] — and what we lose by not doing it

**Key tradeoffs:**

| Dimension | What We Gain | What We Give Up |
|-----------|-------------|-----------------|
| [Dimension 1] | [Gain] | [Loss] |
| [Dimension 2] | [Gain] | [Loss] |

**Rule**: If the tradeoff table shows only gains and no losses, the analysis is incomplete. Every real strategy involves giving something up.

### Step 4: Integrative Thinking Check

Challenge the framing of the choice itself:

- **Is this a false either/or?** Can we get the benefits of multiple options through creative combination?
- **What would a "both" approach look like?** Even if impractical, describe it — it may reveal a partial integration.
- **Are the options truly in tension?** Sometimes apparent conflicts dissolve when examined closely.
- **Is there a sequencing solution?** Can we do A first, then B, avoiding the tradeoff?

If the binary is real, state why: "These options are genuinely in tension because [mechanism of conflict]."

### Step 5: So-What Bridge

Every strategic insight must connect to specific action. For each element of the recommendation:

| Insight | → | Concrete Action | Owner | Timeline |
|---------|---|----------------|-------|----------|
| [Strategic insight 1] | → | [What to do specifically] | [Who] | [When] |
| [Strategic insight 2] | → | [What to do specifically] | [Who] | [When] |

**Quality test**: Could someone read ONLY the action column and know what to do? If the actions are vague ("align on strategy," "explore options"), they're not actions.

## Output Format

```markdown
## Strategic Synthesis Result

### Decision Frame
- **Choice**: [Specific decision statement]
- **Stakes**: [What's at risk]
- **Timeline**: [Decision deadline]
- **Reversibility**: [Can it be undone? At what cost?]

### Cascading Choices
| Level | Status | Detail |
|-------|--------|--------|
| Aspiration | ✅ / ❌ | [Alignment with overarching goal] |
| Where to play | ✅ / ❌ | [Scope/domain definition] |
| How to win | ✅ / ❌ | [Competitive advantage theory] |
| Capabilities | ✅ / ❌ | [Required capabilities assessment] |
| Systems | ✅ / ❌ | [Supporting structures] |

### Tradeoffs
| Dimension | Gain | Loss |
|-----------|------|------|
| ... | ... | ... |

**Opportunity cost**: [What we're NOT doing and what we lose]

### Integrative Thinking
[False binary? Sequencing possible? "Both" approach?]

### So-What Bridge
| Insight | Action | Owner | Timeline |
|---------|--------|-------|----------|
| ... | ... | ... | ... |

### Recommendation
[Final synthesized recommendation with reasoning chain]
```

## Activation Triggers

- An agent is producing strategic guidance with cascading implications
- A recommendation involves choosing between approaches with significant tradeoffs
- The output will influence resource allocation, direction, or priorities
- Someone says "we should do X" about a consequential choice

**Anti-triggers** (do NOT invoke this skill):
- Tactical or implementation-level decisions ("which library to use")
- Decisions with obvious right answers and no real tradeoff
- Information gathering or analysis (use an analysis protocol instead)
- When the decision has already been made and can't be revisited
