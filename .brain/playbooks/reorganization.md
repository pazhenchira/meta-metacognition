# Reorganization Playbook

Use this when component boundaries need adjustment before parallelization or after detecting structural issues.

## Checklist

- [ ] **Identify Symptoms**: Document what triggered reorganization need
- [ ] **Map Current State**: List all affected components and their responsibilities
- [ ] **Evaluate Against LEGO Principles**: Check single-responsibility, clear interfaces
- [ ] **Architect Proposal**: Request architect to propose reorganization
- [ ] **Review Proposal**: Verify proposal addresses symptoms without over-engineering
- [ ] **Deliberate (if significant)**: Run 8-perspective review if >3 components affected
- [ ] **Approve Plan**: Orchestrator approves final reorganization plan
- [ ] **Execute**: Developer implements with comprehensive tests
- [ ] **Validate**: Tester confirms no regressions, new boundaries are clean
- [ ] **Update Docs**: Update lego_plan.json, architecture docs, AGENTS.md

## Symptom Detection

| Symptom | Indicates | Likely Action |
|---------|-----------|---------------|
| Component has 5+ public methods doing unrelated things | God Object | **Split** |
| Adding feature requires changes to 3+ components | Tangled dependencies | **Extract** shared concern |
| Two components always change together | Hidden coupling | **Merge** or **Extract** interface |
| Same logic copy-pasted in multiple places | Missing abstraction | **Extract** to shared LEGO |
| "Where does X belong?" is hard to answer | Unclear ownership | **Relocate** or **Split** |
| Component name includes "And" or "Manager" | Multiple responsibilities | **Split** |
| Tests require mocking 5+ dependencies | Over-coupling | **Split** or simplify |

## Architect Proposal Template

```markdown
## Reorganization Proposal: {Title}

### Trigger
[What symptom/antipattern was detected?]

### Current State
| Component | Current Responsibilities | Issues |
|-----------|-------------------------|--------|
| [Name] | [List] | [Problems] |

### Proposed Changes
| Action | From | To | Rationale |
|--------|------|-----|-----------|
| Split | ComponentA | ComponentA1, ComponentA2 | [Why] |
| Merge | ComponentB, ComponentC | ComponentBC | [Why] |
| Extract | ComponentD.method() | SharedLEGO | [Why] |
| Relocate | ComponentE.feature | ComponentF | [Why] |

### New Structure
[Diagram or list of resulting components and their responsibilities]

### Interface Changes
| Interface | Change | Migration |
|-----------|--------|-----------|
| [API/Contract] | [What changes] | [How to migrate] |

### Risk Assessment
- **Breaking changes**: [Yes/No, what]
- **Test coverage**: [What needs new tests]
- **Rollback plan**: [How to undo if needed]

### LEGO Principle Compliance
- [ ] Each resulting component has single responsibility
- [ ] Interfaces are explicit and minimal
- [ ] No circular dependencies introduced
- [ ] Component names clearly describe purpose
```

## Deliberation Integration

For significant reorganizations (>3 components), invoke these perspectives:

| Perspective | Key Question for Reorganization |
|-------------|--------------------------------|
| **Skeptic** | "Is this reorganization necessary? What if we don't do it?" |
| **Pragmatist** | "Can we do a smaller reorganization that solves 80% of the problem?" |
| **Systems Thinker** | "Does this improve or complicate the overall architecture?" |
| **Operator** | "How will this affect deployment, monitoring, debugging?" |

Minimum: Skeptic + Pragmatist + Systems Thinker

## Before Parallelization Checklist

Run this before spawning workstream orchestrators:

- [ ] Each component has clear, single owner
- [ ] Interfaces between components are documented
- [ ] No shared mutable state between components
- [ ] Integration points are identified
- [ ] Conflict resolution owner is designated

## Anti-Patterns in Reorganization

| Anti-Pattern | Description | Avoid By |
|--------------|-------------|----------|
| **Premature Split** | Splitting before understanding full requirements | Wait for 3+ symptoms |
| **Big Bang Refactor** | Changing everything at once | Incremental changes |
| **Abstraction Astronaut** | Creating layers for "flexibility" | YAGNI - solve today's problem |
| **Rename and Declare Victory** | Renaming without restructuring | Verify responsibility changes |

## Output

After reorganization:
1. Updated `lego_plan.json` with new component structure
2. Updated architecture documentation
3. Migration notes if interfaces changed
4. Test coverage report for new structure
