---
name: "investigation-framing"
description: "Validate and frame the investigation question before executing analysis"
argument-hint: "The investigation question or problem statement to be analyzed"
stage: "before-analysis"
version: "0.1.0"
---

# Skill: Investigation Framing

## Why This Skill Exists

Agents jump straight into analysis without validating whether the question is well-formed, answerable, or even the right question. This produces thorough answers to wrong questions — high effort, low value.

In meta-metacognition's context, this prevents engine analysis that doesn't address the actual problem — e.g., analyzing the build pipeline's architecture when the real question is about a downstream app's upgrade path.

Three failure modes this skill prevents:

1. **Answering the wrong question**. An agent is asked "why did X happen?" but the real decision is "should we invest in Y?" The analysis is technically correct but doesn't inform the actual decision.
2. **Unbounded scope**. Without defining what "good enough" looks like, investigation expands until time runs out. The agent collects everything instead of what matters.
3. **Tool-data mismatch**. The agent picks an analysis approach before checking whether the needed data actually exists or whether the available tools can answer the question. This wastes cycles on dead-end methods.

## Protocol

### Step 1: Restate the Question

State the investigation question in ONE clear sentence. Strip ambiguity. If the original question contains multiple sub-questions, identify the primary one.

- **Input**: The raw question as received
- **Output**: One sentence, specific and falsifiable
- **Gate**: The restated question must be answerable — if it's a vague topic ("tell me about X"), reframe into a specific question before proceeding

### Step 2: Classify the Question Type

Determine which type of question this is:

| Type | Definition | Example |
|------|-----------|---------|
| **Descriptive** | What is the current state? | "What does our error rate look like?" |
| **Diagnostic** | Why did something happen? | "Why did latency spike last Tuesday?" |
| **Differential** | How do two things compare? | "How does option A compare to option B?" |
| **Evaluative** | Is something good/bad/sufficient? | "Is our test coverage adequate?" |
| **Predictive** | What will happen if...? | "What happens if we double the load?" |

The classification determines which protocol branches apply. Differential questions trigger the mandatory differential check (Step 4).

### Step 3: Define Sufficiency

Answer: **"What would a complete answer look like?"**

- What specific outputs does the requester need?
- What level of confidence is required? (Directional estimate vs. precise measurement)
- When do we stop? (Define the boundary explicitly)
- Who decides based on this analysis, and what are they deciding?

### Step 4: Differential Check (MANDATORY for Differential Questions)

IF the question is a comparison ("A vs. B", "before vs. after", "us vs. them"), this step is **mandatory**:

1. **Name BOTH populations** explicitly — what exactly is being compared?
2. **State the gap hypothesis** — what difference are we expecting or testing?
3. **Pre-check categories** — list the dimensions of comparison before analyzing (prevents cherry-picking dimensions that confirm a narrative)

IF the question is NOT differential, note "N/A — not a comparison" and proceed.

### Step 5: Tool and Data Fitness

Before starting analysis, verify the approach will work:

1. **What data source answers this question?** Name it specifically.
2. **Does the data source have the fields/dimensions needed?** Check schema or documentation.
3. **What's the time range or scope of available data?** Does it cover the period in question?
4. **Are there known gaps, biases, or limitations?** State them upfront.

IF the data doesn't fit → STOP. Reframe the question to match available data, or identify what data needs to be acquired first.

### Step 6: Validation Gate

All checks must pass before proceeding to analysis:

- [ ] Question is restated as one specific, falsifiable sentence
- [ ] Question type is classified
- [ ] Sufficiency criteria are defined (what "done" looks like)
- [ ] Differential check completed (if applicable)
- [ ] Data source identified and confirmed fit

**IF all pass** → Proceed to analysis with the validated frame.
**IF any fail** → Reframe the question and repeat from the failing step.

## Output Format

```markdown
## Investigation Frame

### Question (Restated)
[One sentence — specific, falsifiable]

### Classification
[Descriptive / Diagnostic / Differential / Evaluative / Predictive]

### Decision Context
- **Who decides**: [Role/person]
- **What they're deciding**: [Specific decision]
- **Sufficiency**: [What a complete answer looks like]

### Differential Check
[If applicable: both populations, gap hypothesis, comparison dimensions]
[If not applicable: "N/A — not a comparison"]

### Method
- **Data source**: [What data answers this]
- **Fitness**: [Confirmed fit / gaps identified]
- **Approach**: [2-3 sentence method description]

### Validation
- [x] Question restated
- [x] Type classified
- [x] Sufficiency defined
- [x] Differential check: [Pass / N/A]
- [x] Data fitness: [Confirmed / Gaps noted]

**Proceed**: Yes / No (reframe needed)
```

## Activation Triggers

- An agent is about to investigate, research, or analyze a non-trivial question
- The question involves data analysis, root cause investigation, or comparison
- Someone asks "why did X happen?" or "how does A compare to B?"

**Anti-triggers** (do NOT invoke this skill):
- Simple lookups ("what's the value of config X?")
- Questions that require no analysis (fact retrieval)
- When the investigation frame was already established in a prior step
