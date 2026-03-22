> **This is meta-metacognition's skills directory.** Skills were imported from MetaAgent's reference implementation and adapted for meta-metacognition context.
> Atlas agents ARE the reference implementation — implement first, propagate second.

# Skills — meta-metacognition

## What Are Skills?

Skills are **procedural protocols** — step-by-step checklists that any agent follows at specific work stages to ensure consistent quality. They are not agents, not roles, and not identities. A skill is a procedure an agent *executes*, not an entity that *decides*.

**In one sentence**: Skills ensure consistent quality regardless of which agent does the work.

## How Skills Differ From Agents

| Dimension | Skill | Agent |
|-----------|-------|-------|
| **What it is** | A checklist / procedure | An identity with decision rights |
| **Has identity?** | No — "Pre-ship review" is a procedure | Yes — "Reviewer" has judgment and expertise |
| **Invocation** | Invoked BY an agent | Dispatched TO by Atlas |
| **Output** | Structured template (fill-in-the-blanks) | Open-ended deliverable |

- ✅ "Analyst invokes `investigation-framing` before starting research" — correct
- ❌ "Dispatch `investigation-framing` to analyze the problem" — wrong, skills are not dispatched

## How to Use Skills

### 1. Check the Selector

Before a work stage, check `skills/selector.md`. If a trigger matches your current situation, invoke the corresponding skill.

### 2. Follow the Protocol

Read the `.skill.md` file. Follow the numbered steps in the Protocol section. Each step has inputs, outputs, and gates — don't skip gates.

### 3. Fill In the Output Format

Every skill has an Output Format section with a structured template. Fill it in with your results. This becomes part of your deliverable.

### 4. Continue Your Work

Skills are pre-work and post-work protocols, not the work itself. After completing the skill protocol, proceed with your actual task.

## Included Skills

| Skill | Stage | Purpose |
|-------|-------|---------|
| **[investigation-framing](investigation-framing.skill.md)** | before-analysis | Validate the question before executing analysis — prevents answering the wrong question |
| **[pre-ship-review](pre-ship-review.skill.md)** | before-shipping | Chain-of-Verification on deliverables — catches unexamined assumptions and hollow claims |
| **[structured-challenge](structured-challenge.skill.md)** | before-strategy | Stress-test recommendations through steel-manning, failure modes, and pre-mortem analysis |
| **[problem-reframing](problem-reframing.skill.md)** | when-stuck | Reframe problems through constraint interrogation and multiple perspectives when direct approaches fail |
| **[strategic-synthesis](strategic-synthesis.skill.md)** | before-strategy | Ensure strategic advice includes cascading choices, explicit tradeoffs, and concrete actions |
| **[stakeholder-lens](stakeholder-lens.skill.md)** | before-presenting | Apply the stakeholder's quality bar and learned preferences before delivering output |

## How to Customize

### Adding a New Skill

1. Create `{skill-name}.skill.md` following the file format:
   - YAML frontmatter: `name`, `description`, `argument-hint`, `stage`, `version`
   - Sections: Why This Skill Exists, Protocol, Output Format, Activation Triggers
2. Add a routing entry to `selector.md` with trigger condition and stage
3. Done — Atlas already checks the selector, so new skills are discovered automatically

### Modifying an Existing Skill

After scaffolding, your project owns these files. You can:

- Add project-specific failure examples to "Why This Skill Exists"
- Add, remove, or reorder protocol steps
- Add project-specific sections to the output format
- Tune activation triggers to your project's work patterns
- Change Required/Recommended status in the selector

### What Must Stay Fixed

These conventions enable framework compatibility:

- File naming: `{name}.skill.md`
- Frontmatter fields: `name`, `description`, `argument-hint`, `stage`, `version`
- Required sections: Why, Protocol, Output Format, Activation Triggers
- Selector file at `skills/selector.md`
- Skills are invoked by agents, never dispatched to

## Integration With Atlas

Atlas checks the selector at stage boundaries — it does NOT memorize skill protocols. The integration points are:

| Orchestrator Action | Skill Check |
|---------------------|------------|
| Delegating analysis work | Check selector for `before-analysis` triggers |
| Accepting a deliverable | Check selector for `before-shipping` triggers |
| High-stakes recommendation | Check selector for `before-strategy` triggers |
| Agent reports being stuck | Check selector for `when-stuck` triggers |
| Presenting to stakeholder | Check selector for `before-presenting` triggers |
