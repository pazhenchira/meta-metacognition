---
name: "stakeholder-lens"
description: "Pre-output check that applies the primary stakeholder's quality bar and preferences"
argument-hint: "The output about to be presented to sponsor"
stage: "before-presenting"
version: "0.1.0"
---

# Skill: Stakeholder Lens

## Why This Skill Exists

Agents optimize for completeness and correctness but miss what the stakeholder actually cares about. Output that is technically perfect but doesn't match the stakeholder's quality bar, communication style, or decision-making needs fails on delivery. This skill internalizes the stakeholder's perspective as a final quality gate.

In meta-metacognition, the sponsor's known patterns (from accumulated lessons) include: strong verification expectations ("always run tests/commands before claiming success"), autonomy preference ("don't ask me routine decisions — decide and proceed"), emphasis on completeness and root-cause fixes over patches ("trace to root cause, don't patch symptoms"), and a preference for generalization over specific fixes ("engine-level changes propagate to all applications"). The sponsor expects self-initiated verification — not waiting to be prompted — and considers it a failure when they are the one spotting protocol gaps.

Three failure modes this skill prevents:

1. **Technically correct, practically useless**. The analysis is thorough, the code is clean, the document is complete — but it doesn't answer the question the sponsor was actually asking. The agent optimized for their own quality standard, not the recipient's.
2. **Repeated corrections**. The sponsor gives the same feedback cycle after cycle: "too much detail," "where's the bottom line?", "I need options not recommendations." Without explicitly loading and applying learned patterns, the same mistakes recur.
3. **Missing the implicit bar**. Some stakeholders want bullet points, others want narrative. Some want certainty, others want explicit uncertainty. Some want the conclusion first, others want the reasoning. This isn't documented anywhere — it's learned through interaction. Without a mechanism to capture and apply these patterns, each output starts from zero.

## Protocol

### Step 1: Load Stakeholder Model

Before reviewing the output, build the stakeholder profile from available context:

**Sources to check** (in order of reliability):
1. **Correction history**: What has the sponsor corrected before? (Most reliable signal)
2. **Lessons file**: Documented preferences in meta-metacognition lessons or context files
3. **People/context files**: Stakeholder profiles, org context, working style documentation
4. **Interaction patterns**: How does the sponsor ask questions? What do they emphasize?

**Build the profile:**
- **Communication preference**: Bullet points vs. narrative? Detail vs. summary? Formal vs. informal?
- **Decision style**: Wants options or wants recommendations? Tolerates ambiguity or needs certainty?
- **Quality bar**: What does "good enough" mean to this person? Where are they picky?
- **Pet peeves**: What consistently draws negative feedback?

- **Input**: Available context about the sponsor + the output to review
- **Output**: Working stakeholder profile
- **Gate**: If no stakeholder context is available, apply core patterns (Step 2) only and note that stakeholder model is unloaded

### Step 2: Apply Core Patterns

Check the output against universal quality patterns that apply regardless of specific stakeholder:

| Pattern | Check | Fix |
|---------|-------|-----|
| **Verification** | Are all claims supported by evidence? | Flag unsupported claims |
| **Question-answer fit** | Does the output answer what was actually asked? | Realign to the question |
| **Accumulated learning** | Does this repeat a previously corrected mistake? | Apply the correction |
| **Autonomy** | Did the agent make reasonable decisions or punt everything? | Make the calls, flag only true judgment calls |
| **Reader experience** | Is this pleasant/easy to read cold? | Restructure for the reader, not the writer |
| **Completeness** | Is anything obviously missing that the reader would expect? | Add or flag the gap |

### Step 3: Apply Learned Patterns

Extract correction patterns from the sponsor's history that aren't covered by the core table:

- Review the last 3–5 corrections or feedback items from the sponsor
- Identify patterns: What keeps getting corrected?
- Check: Does the current output violate any of these patterns?

**Format each learned pattern as:**
- **Pattern**: [What the sponsor expects]
- **Source**: [Which correction/feedback revealed this]
- **Current output**: [Does it comply? If not, what needs to change?]

IF no correction history exists, note: "No learned patterns available — first interaction or new context."

### Step 4: Predict Specific Pushback

Before presenting, predict what the sponsor will object to:

1. **Most likely pushback**: [What will they say? Why?]
   - **Pre-fix**: [How to address this before presenting]
2. **Second most likely pushback**: [What else might they say?]
   - **Pre-fix**: [How to address this]

**Rule**: Fix predicted pushback BEFORE presenting, not after. The goal is to present output that needs no correction, not to predict corrections and present anyway.

If both pushback items can be fixed → fix them and note what was changed.
If a pushback item can't be fixed → flag it explicitly and explain why.

### Step 5: Scale by Complexity

Not every output needs the full protocol. Scale the review to match the output's complexity:

| Output Type | Protocol Scope |
|-------------|---------------|
| **Bare acknowledgment** ("Got it, will do") | Skip — no review needed |
| **Simple information** (fact, status update) | Quick pass — Steps 2 only (core patterns) |
| **Advice or recommendation** | Full protocol — Steps 1–4 |
| **Major deliverable** (design, strategy, analysis) | Full protocol + predict pushback + pre-fix |

Apply the minimum effective protocol. Over-reviewing trivial outputs wastes cycles and signals poor judgment about what matters.

## Output Format

```markdown
## Stakeholder Lens Result

### Stakeholder Profile
- **Communication preference**: [Style summary]
- **Decision style**: [Options vs. recommendations, etc.]
- **Quality bar**: [What matters most to them]
- **Known pet peeves**: [What to avoid]

### Core Pattern Check
| Pattern | Status | Notes |
|---------|--------|-------|
| Verification | ✅ / ⚠️ | [Detail] |
| Question-answer fit | ✅ / ⚠️ | [Detail] |
| Accumulated learning | ✅ / ⚠️ | [Detail] |
| Autonomy | ✅ / ⚠️ | [Detail] |
| Reader experience | ✅ / ⚠️ | [Detail] |
| Completeness | ✅ / ⚠️ | [Detail] |

### Learned Patterns Applied
| Pattern | Source | Compliant? |
|---------|--------|------------|
| [Pattern] | [Correction ref] | ✅ / ❌ [fix needed] |

### Predicted Pushback
1. **Most likely**: [Prediction] → **Pre-fix**: [Applied / Flagged]
2. **Second most likely**: [Prediction] → **Pre-fix**: [Applied / Flagged]

### Changes Made
- [Change 1: what was adjusted and why]
- [Change 2: what was adjusted and why]

### Verdict
[Ready to present / Needs revision before presenting]
```

## Activation Triggers

- Final output is being prepared for the primary stakeholder or sponsor
- A deliverable is transitioning from "internally reviewed" to "externally presented"
- An agent is formatting a response to the person who commissioned the work

**Anti-triggers** (do NOT invoke this skill):
- Internal-only artifacts (status updates between agents, working notes)
- Intermediate work products not yet ready for stakeholder eyes
- When the output consumer is another agent, not the stakeholder
