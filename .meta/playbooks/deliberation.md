# Deliberation Playbook

Use this for significant decisions requiring multiple perspectives.

## Checklist

- [ ] **Frame**: State the decision as a clear question
- [ ] **Context**: Document relevant facts, constraints, options
- [ ] **Select Perspectives**: Choose which of the 8 to invoke (minimum 3)
- [ ] **Invoke Skeptic**: Challenge assumptions (always include)
- [ ] **Invoke Others**: Get 2+ additional perspectives
- [ ] **Tally**: Count Support / Conditional / Oppose
- [ ] **Synthesize**: Combine insights into recommendation
- [ ] **Decide**: Make the call
- [ ] **Document**: Record decision with rationale in appropriate location

## Perspective Quick Reference

| Perspective | Key Question |
|-------------|--------------|
| Skeptic | "What evidence supports this? What could be wrong?" |
| Pragmatist | "What's the MVP? Can we ship sooner?" |
| Systems Thinker | "Is this LEGO-compliant? KISS?" |
| Operator | "How do we deploy, monitor, debug this?" |
| Economist | "What's the cost/benefit? ROI?" |
| Adversary | "How could this be attacked or abused?" |
| Visionary | "Where does this lead in 2-3 years?" |
| Customer Advocate | "What does the user actually need?" |

## Output Format

```
## Decision: [Question]

### Context
[Facts, constraints, options]

### Perspectives
| Perspective | Position | Key Point |
|-------------|----------|-----------|
| Skeptic | Support/Conditional/Oppose | ... |
| ... | ... | ... |

### Vote: X Support, Y Conditional, Z Oppose

### Recommendation
[Synthesized recommendation with rationale]

### Decision
[Final decision and next steps]
```
