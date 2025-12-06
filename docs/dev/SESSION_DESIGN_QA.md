# Meta-Orchestrator v2.0 Design Q&A Session Summary

**Date**: 2025-12-06  
**Participants**: User (Product Owner), Claude (Meta-Orchestrator Maintenance Agent)  
**Outcome**: Complete architectural design for v2.0 refactor

---

## Session Overview

**Goal**: Redesign meta-orchestrator for true idempotency, auto-documentation, and workspace-centric execution.

**Key Problems Solved**:
1. ❌ **v1.x Issue**: State scattered across root directory, hard to restart
   - ✅ **v2.0 Solution**: Centralized `.workspace/` with explicit state management
2. ❌ **v1.x Issue**: Agent brain can be tampered with during execution
   - ✅ **v2.0 Solution**: `.app/` frozen except during engine upgrades
3. ❌ **v1.x Issue**: Specs can be modified after approval (no immutability)
   - ✅ **v2.0 Solution**: `specs/` is read-only (chmod 444), changes require new work item
4. ❌ **v1.x Issue**: Code is source of truth, docs drift
   - ✅ **v2.0 Solution**: LEGO docs are complete specs, can regenerate code
5. ❌ **v1.x Issue**: No clear workflow for discovered work items
   - ✅ **v2.0 Solution**: `.workspace/tracker.json` tracks backlog/active/complete

---

## Design Decisions (Q&A Format)

### **Q1: Directory Structure Philosophy**

**User**: "Should the app's durable structure be flat or hierarchical?"

**Decision**: Hierarchical with clear separation:
- `.meta/` = ENGINE (stable, only changed during upgrades)
- `.app/` = FROZEN BRAIN (read-only except upgrades)
- `.workspace/` = EPHEMERAL (deleted after work item completion)
- `legos/` = SELF-DOCUMENTING (docs can regenerate code)
- `specs/` = IMMUTABLE (read-only after approval)

**Rationale**: Separation of concerns prevents tampering and makes responsibilities explicit.

---

### **Q2: Work Item Lifecycle**

**User**: "Should `.workspace/tracker.json` track state transitions with timestamps?"

**Decision**: YES - `tracker.json` is global log that survives workspace deletion.

**Schema**:
```json
{
  "work_items": [
    {
      "id": "WI-001",
      "state": "COMPLETE",
      "created": "2025-12-06T10:00:00Z",
      "completed": "2025-12-06T14:30:00Z",
      "state_transitions": [
        {"from": "BACKLOG", "to": "ACTIVE", "timestamp": "..."},
        {"from": "ACTIVE", "to": "IN_REVIEW", "timestamp": "..."}
      ]
    }
  ]
}
```

**Rationale**: Audit trail for debugging, analytics, and restart context.

---

### **Q3: Review Approval Model**

**User**: "When PM creates FR-001, who approves?"

**Decision**: **Option A - All 5 reviewers must explicitly approve (blocking)**

**Reviewers**: Architect, Developer, Tester, Writer, Orchestrator

**Process**:
1. PM completes draft → marks todo
2. Orchestrator switches to each reviewer role sequentially
3. Each writes feedback to `.workspace/WI-001/reviews/FR-001_reviews.md`
4. If **all approve** → promote to `specs/features/FR-001.md` (immutable)
5. If **any reject** → PM addresses feedback, re-submit

**Rationale**: Multi-stakeholder review prevents rework downstream (e.g., Tester catches untestable requirement before implementation).

---

### **Q4: Workspace Cleanup**

**User**: "When WI-001 completes, delete immediately or archive?"

**Decision**: **Delete immediately after git commit** (git history is enough)

**Process**:
```bash
git add -A
git commit -m "Complete WI-001: Sentiment analysis"
rm -rf .workspace/WI-001/
```

**Rationale**: Git is source of truth. No need for duplicate archives.

---

### **Q5: LEGO Interface Changes (Breaking)**

**User**: "If `signal_generator` interface changes (breaking), what happens?"

**Decision**: **Just break and discover through tests** (no deprecation, no versioning)

**Process**:
1. Update `legos/signal_generator/interface.md` (breaking change)
2. Bump `_manifest.json` version: `1.0.0 → 2.0.0`
3. Tests break (intentionally show affected callers)
4. Update affected callers (`report_generator`, `alert_system`)
5. Tests pass → breaking change complete

**Rationale**: Fast feedback loop, no technical debt, clear ownership via dependency graph.

---

### **Q6: Auto-Documentation Scope**

**User**: "What does 'auto-documentation' mean?"

**Decision**: **Both inline comments + LEGO doc sync + generated API docs**

**Components**:
1. **Inline code comments** (comprehensive docstrings)
2. **LEGO doc sync** (README.md updated when code changes, verified in review)
3. **Generated API docs** (Sphinx/pdoc from docstrings → `docs/user/api-reference.md`)

**Not Auto-Documentation**:
- Architectural decisions (manual ADRs)
- User guides (manual, by Writer)
- Trade-off rationale (manual, in APP_ORCHESTRATION.md)

**Rationale**: Code and docs stay in sync through review gates, public API is always current.

---

### **Q7: External Input Lifecycle**

**User**: "Who decides when to delete `external_input/` files?"

**Decision**: **User manages lifecycle** (agent never deletes)

**Process**:
- User uploads `competitor_analysis.pdf` → references in work item
- User adds note: `external_input/README.md` → "Delete after WI-003"
- User deletes when ready

**Rationale**: User knows best when external context is no longer needed.

---

### **Q8: Role Switching Mechanism**

**User**: "How should orchestrator activate role-specific context?"

**Decision**: **Orchestrator wears different hats autonomously**

**Process**:
1. Orchestrator reads `.workspace/WI-001/todos.md` (identifies current task: "PM: Review DD-001")
2. Switches to PM role: Reads **ONLY** `.app/roles/product_manager.md`
3. PM executes review (writes feedback)
4. Orchestrator steps back (checks if all reviewers done)
5. Repeats for next role

**Critical**: Never loads multiple role contexts simultaneously. One role at a time.

**Rationale**: Context isolation prevents role confusion, wisdom stays relevant.

---

### **Q9: LEGO Regeneration Trigger**

**User**: "When should code be regenerated from LEGO docs?"

**Decision**: **When implementation needs complete overhaul**

**Scenarios**:
- Different algorithm (polling → webhooks)
- Different data source (REST → GraphQL)
- Architectural refactor (split monolith → 3 LEGOs)

**Process**:
1. Update `legos/my_lego/README.md` (new strategy)
2. Update `interface.md`, `workflows.md` (if changed)
3. Delete `src/` (old implementation)
4. Regenerate from docs
5. Multi-role review
6. Approve → commit

**Not Regeneration**:
- Bug fixes (fix code, not regenerate)
- Refactoring (improve quality, same behavior)
- Performance optimization (better implementation, same algorithm)

**Rationale**: Docs are source of truth for "what", code is "how". Regenerate when "what" fundamentally changes.

---

### **Q10: Documentation Structure**

**User**: "Should internal docs be in `docs/` or separate?"

**Decision**: **Industry standard pattern - `docs/user/` and `docs/dev/`**

**Structure**:
```
docs/
├── README.md          # Navigation guide
├── user/              # EXTERNAL (customer-facing)
│   ├── getting-started.md
│   ├── user-guide.md
│   └── api-reference.md
└── dev/               # INTERNAL (developer/agent-facing)
    ├── architecture.md
    ├── design-decisions.md
    └── testing-strategy.md
```

**Rationale**: Used by Kubernetes, React, Django, Rails. Clear audience separation.

---

## Core Principles Established

1. **`.app/` is frozen** - Only modified during engine upgrades (prevents tampering)
2. **`.workspace/` is ephemeral** - Deleted after work item completion (git is source of truth)
3. **`specs/` is immutable** - Changes require new work item + new spec (chmod 444)
4. **`legos/` are regenerable** - Docs contain complete specification (README + interface + workflows)
5. **Multi-role blocking approval** - All 5 roles approve before artifact promotion
6. **Git-enabled by default** - All changes versioned, no extra archives needed
7. **Role context isolation** - Orchestrator reads one role file at a time
8. **Breaking changes fail fast** - Tests discover affected callers immediately
9. **Auto-documentation = quality** - Inline comments + LEGO sync + generated API docs
10. **User manages external input** - Agent never deletes user-provided context

---

## Idempotent Restart Model

**Scenario**: Copilot session ends mid-work-item. How to resume?

**Restart Procedure**:
1. Orchestrator reads `.workspace/tracker.json` → identifies active: `WI-001`
2. Reads `.workspace/WI-001/README.md` → understands context
3. Reads `.workspace/WI-001/todos.md` → identifies current task: "PM: Review DD-001"
4. Switches to PM role
5. Executes review
6. Updates todos
7. Continues pipeline

**No Context Loss**:
- `tracker.json` = global state
- `WI-001/README.md` = work item context
- `WI-001/todos.md` = progress tracking
- `WI-001/reviews/` = review history

---

## Work Item States

| State | `.workspace/WI-XXX/` | `tracker.json` | Meaning |
|-------|---------------------|----------------|---------|
| **BACKLOG** | ❌ No | ✅ Yes | Queued |
| **ACTIVE** | ✅ Yes | ✅ Yes | In progress |
| **IN_REVIEW** | ✅ Yes | ✅ Yes | Awaiting approval |
| **APPROVED** | ✅ Yes | ✅ Yes | Promoting artifacts |
| **COMPLETE** | ❌ No (deleted) | ✅ Yes | Done |

---

## Next Steps

### Phase 1: Implementation Planning
- [ ] Create detailed task breakdown for v2.0 refactor
- [ ] Identify breaking changes from v1.x
- [ ] Design migration path for existing apps

### Phase 2: Core Implementation
- [ ] Refactor `.meta/AGENTS.md` for workspace-centric execution
- [ ] Create `.meta/generators/` templates
- [ ] Update `.meta/roles/` with v2.0 responsibilities
- [ ] Update `.meta/workflows/` with review gates

### Phase 3: Testing
- [ ] Build sample app (OptionsTrader) with v2.0
- [ ] Test idempotent restart (kill session mid-work-item)
- [ ] Validate LEGO regeneration from docs
- [ ] Test breaking change detection

### Phase 4: Documentation
- [ ] Update README.md (v2.0 features)
- [ ] Update CHANGELOG.md (v2.0.0 entry)
- [ ] Create UPGRADING.md (v1.x → v2.0 migration guide)
- [ ] Update all wisdom files for v2.0 patterns

### Phase 5: Release
- [ ] Version bump: `1.10.0 → 2.0.0`
- [ ] Tag release: `git tag v2.0.0`
- [ ] Announce breaking changes
- [ ] Publish migration guide

---

## Key Takeaways

1. **Workspace-centric execution** enables true idempotency (all state in files)
2. **Frozen `.app/` brain** prevents tampering during execution
3. **Immutable specs** enforce discipline (changes require new work item)
4. **LEGO docs as source of truth** enable code regeneration
5. **Multi-role approval** catches issues early (reduces rework)
6. **Git integration** eliminates need for custom archival
7. **Role context isolation** keeps wisdom relevant and focused
8. **Breaking changes fail fast** via test-driven discovery
9. **Auto-documentation** means quality, not just logging
10. **User-managed external input** respects user knowledge

---

**Status**: ✅ Design Complete - Ready for Implementation

**Approval**: User confirmed all design decisions

**Next Action**: Implement in `.meta/AGENTS.md` and supporting files
