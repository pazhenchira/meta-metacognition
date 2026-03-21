# Investigation Framing

> Validate the question before executing analysis.

## Why This Skill Exists

The most common analytical failure: executing substantial analysis on the wrong question. The investigation is thorough but doesn't answer what was actually asked. This skill prevents that by validating the question BEFORE dispatching.

## Protocol

### Step 1 — Restate the Question

Write the investigation question in ONE sentence. If you can't, the question isn't clear enough to investigate.

### Step 2 — Classify the Question Type

| Type | Signal | Required Framing |
|------|--------|-----------------|
| **Descriptive** | "What is X?" | Define scope and depth. What counts as a complete answer? |
| **Diagnostic** | "Why did X happen?" | Identify proximate vs root causes. What evidence would confirm? |
| **Differential** | "Why is X worse than Y?" | **MANDATORY**: Identify BOTH populations. Analysis must explain the gap, not just describe one side. |
| **Evaluative** | "Should we do X?" | Define criteria. Against what standard? |
| **Predictive** | "What will happen if X?" | Identify assumptions. What variables matter most? |

### Step 3 — Define Sufficiency

**"What would a complete answer look like?"** Be specific. If you cannot describe what a complete answer looks like, you don't understand the question well enough to investigate.

### Step 4 — Differential Check (MANDATORY for all comparisons)

If comparing two things:
1. **Name both populations explicitly**
2. **State the differential**: quantified gap
3. **Pre-check categories**: If analysis categories apply equally to both populations, they don't explain the gap

## Output Format

```
### Investigation Frame
- **Question**: [one sentence]
- **Type**: [Descriptive/Diagnostic/Differential/Evaluative/Predictive]
- **Sufficient answer**: [what complete looks like]
- **Populations** (if differential): [A] vs [B], gap = [quantified]
- **Methodology**: [approach]
- **Known limitations**: [what this can't tell us]
```
