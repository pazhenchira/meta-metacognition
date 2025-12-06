# Meta-Orchestrator v2.0 Implementation Plan

**Version**: 2.0.0 (Major Refactor)  
**Status**: Design Complete → Implementation Planning  
**Target Date**: TBD  
**Breaking Changes**: YES (requires migration from v1.x)

---

## Executive Summary

**What We're Building**: A workspace-centric, self-documenting, idempotent orchestration engine that can restart without context loss and maintains true separation between engine, agent brain, and active work.

**Why v2.0 (Not v1.11)**:
- Breaking changes to directory structure (`.app/`, `.workspace/`, `legos/`)
- Breaking changes to workflow model (work items, multi-role approval)
- Breaking changes to state management (tracker.json, todos.md)
- Apps built with v1.x require migration (not backward compatible)

**Key Value Propositions**:
1. **True Idempotency**: Restart at any point without context loss
2. **Tamper-Proof Brain**: `.app/` frozen except during upgrades
3. **Immutable Specs**: `specs/` is read-only after approval
4. **Self-Documenting LEGOs**: Docs can regenerate code completely
5. **Audit Trail**: All decisions logged in git history

---

## Implementation Phases

### **Phase 0: Pre-Implementation** ✅ COMPLETE

**Deliverables**:
- [x] Design Q&A session (SESSION_DESIGN_QA.md)
- [x] Final directory structure (FINAL_STRUCTURE.md)
- [x] Proposed workflows (PROPOSED_WORKFLOWS.md)
- [x] User approval of all design decisions

**Output**: Complete architectural blueprint

---

### **Phase 1: Core Engine Refactor** (Est: 3-5 days)

**Goal**: Update `.meta/AGENTS.md` with v2.0 orchestration logic

#### 1.1: State Management System
- [ ] Design `tracker.json` schema (work item states, transitions, timestamps)
- [ ] Design `todos.md` format (role tasks, review gates, checkboxes)
- [ ] Design `reviews/*.md` format (multi-role approval records)
- [ ] Implement state persistence logic (read/write tracker.json)
- [ ] Implement restart detection (identify active work item from tracker)
- [ ] Implement resume logic (read todos.md, identify current task)

#### 1.2: Workspace Management
- [ ] Implement work item creation (`mkdir .workspace/WI-XXX/`)
- [ ] Implement role workspace creation (`mkdir .workspace/WI-XXX/pm/`)
- [ ] Implement artifact promotion (move draft → specs/)
- [ ] Implement workspace cleanup (delete after completion)
- [ ] Implement git integration (commit before delete)

#### 1.3: Role Switching Mechanism
- [ ] Implement role detection (parse todos.md for current role)
- [ ] Implement role activation (read `.app/roles/{role}.md` ONLY)
- [ ] Implement role execution (run role-specific tasks)
- [ ] Implement role handoff (update todos, switch to next role)
- [ ] Implement orchestrator stepping back (check all reviewers done)

#### 1.4: Multi-Role Approval System
- [ ] Implement review request (orchestrator asks role to review)
- [ ] Implement review submission (role writes to reviews/*.md)
- [ ] Implement approval aggregation (check all 5 roles approved)
- [ ] Implement promotion logic (move artifact if all approved)
- [ ] Implement rejection handling (PM addresses feedback, re-submit)

#### 1.5: LEGO Management
- [ ] Design `legos/_manifest.json` schema (dependencies, versions, interfaces)
- [ ] Implement LEGO creation (generate README, interface, workflows)
- [ ] Implement dependency graph analysis (which LEGOs affected by change)
- [ ] Implement breaking change detection (interface hash comparison)
- [ ] Implement code regeneration (from README + interface + workflows)

**Deliverables**:
- Updated `.meta/AGENTS.md` (v2.0 orchestration logic)
- State management utilities
- Workspace management utilities
- Role switching utilities
- LEGO management utilities

**Success Criteria**:
- Can create work item with proper structure
- Can switch roles and execute role-specific tasks
- Can track state across session restarts
- Can promote artifacts after multi-role approval
- Can manage LEGO dependencies and detect breaking changes

---

### **Phase 2: Generator System** (Est: 2-3 days)

**Goal**: Create templates for generating `.app/` folder

#### 2.1: Templates
- [ ] Create `.meta/generators/app_agents.template.md` (self-contained orchestrator)
- [ ] Create `.meta/generators/role.template.md` (role-specific instructions)
- [ ] Create `.meta/generators/workflow.template.md` (workflow definitions)
- [ ] Create `.meta/generators/lego_readme.template.md` (LEGO documentation)
- [ ] Create `.meta/generators/lego_interface.template.md` (interface contract)
- [ ] Create `.meta/generators/lego_workflows.template.md` (inter-LEGO interactions)

#### 2.2: Generator Logic
- [ ] Implement template variable replacement ({APP_NAME}, {ENGINE_VERSION}, etc.)
- [ ] Implement wisdom inlining (copy relevant principles to .app/wisdom/)
- [ ] Implement role adaptation (select roles based on app type)
- [ ] Implement workflow adaptation (select workflows based on formality)
- [ ] Implement validation (ensure no .meta/ references in generated files)

**Deliverables**:
- Complete template library in `.meta/generators/`
- Generator utilities in `.meta/AGENTS.md`
- Validation logic

**Success Criteria**:
- Can generate `.app/` folder from templates
- Generated `.app/AGENTS.md` has zero `.meta/` references
- Generated role files contain inlined wisdom
- Generated workflows match app requirements

---

### **Phase 3: Role Refactor** (Est: 2-3 days)

**Goal**: Update `.meta/roles/` with v2.0 responsibilities

#### 3.1: Role Definitions
- [ ] Update `product_manager.md` (essence alignment, feature specs, review duties)
- [ ] Update `architect.md` (LEGO impact analysis, design docs, control flow)
- [ ] Update `developer.md` (LEGO doc creation, TDD, code quality)
- [ ] Update `tester.md` (test plan creation, edge case hunting, spec validation)
- [ ] Update `writer.md` (user docs, API docs, progressive disclosure)
- [ ] Update `operations.md` (optional: reliability, observability, runbooks)

#### 3.2: Review Responsibilities
- [ ] Define what each role reviews (e.g., PM reviews designs for feasibility)
- [ ] Define review criteria (what to look for, red flags)
- [ ] Define approval format (APPROVED ✅ / APPROVED WITH CONDITIONS / REJECT ❌)
- [ ] Define feedback format (actionable, specific, constructive)

**Deliverables**:
- Updated role files in `.meta/roles/`
- Review gate definitions
- Approval criteria

**Success Criteria**:
- Each role has clear responsibilities
- Each role knows what to review and why
- Review criteria are objective and actionable

---

### **Phase 4: Workflow Refactor** (Est: 2-3 days)

**Goal**: Update `.meta/workflows/` with workspace-centric execution

#### 4.1: New Feature Workflow
- [ ] Update `new_feature.md` (workspace creation, role switching, approval gates)
- [ ] Add LEGO creation steps (docs first, then code)
- [ ] Add multi-role review cycles
- [ ] Add artifact promotion logic

#### 4.2: Enhancement Workflow
- [ ] Update `enhancement.md` (reference original spec, version bumps)
- [ ] Add LEGO modification steps (docs + code sync)
- [ ] Add breaking change detection
- [ ] Add affected caller updates

#### 4.3: Bug Fix Workflow
- [ ] Update `bug_fix.md` (root cause analysis, spec deviation)
- [ ] Add distinction: "spec was correct" vs "spec was wrong"
- [ ] Add test case addition (prevent regression)

#### 4.4: Review Gates
- [ ] Update `REVIEW_GATES.md` (receiving role is reviewer)
- [ ] Add detailed criteria per gate (PM→Architect, Architect→Developer, etc.)
- [ ] Add anti-patterns (rubber-stamping, scope creep)
- [ ] Add timing guidelines (reviews within X hours)

**Deliverables**:
- Updated workflow files in `.meta/workflows/`
- Complete review gate documentation

**Success Criteria**:
- Workflows clearly define role transitions
- Review gates have objective criteria
- Anti-patterns are identified and avoidable

---

### **Phase 5: Documentation Update** (Est: 1-2 days)

**Goal**: Update all user-facing and developer-facing documentation

#### 5.1: User Documentation
- [ ] Update `README.md` (v2.0 features, new directory structure)
- [ ] Add "Quick Start" section (new workflow)
- [ ] Add "Migration Guide" section (v1.x → v2.0)
- [ ] Update examples (OptionsTrader with v2.0 structure)

#### 5.2: Developer Documentation
- [ ] Update `CHANGELOG.md` (v2.0.0 entry with breaking changes)
- [ ] Create `UPGRADING.md` (detailed migration instructions)
- [ ] Update `AGENTS.md` (root router with mode detection)
- [ ] Update `FINAL_STRUCTURE.md` (if needed after implementation)

#### 5.3: Internal Documentation
- [ ] Update `.meta/intent.md` (v2.0 philosophy)
- [ ] Update `.meta/principles.md` (if new principles added)
- [ ] Update wisdom files (if new patterns discovered)

**Deliverables**:
- Updated README.md
- Complete CHANGELOG.md entry
- Detailed UPGRADING.md guide
- All internal docs current

**Success Criteria**:
- Users can understand v2.0 benefits
- Users can migrate from v1.x
- Developers understand new architecture

---

### **Phase 6: Testing** (Est: 3-5 days)

**Goal**: Validate v2.0 with real app builds

#### 6.1: New App Test (OptionsTrader)
- [ ] Create fresh app with v2.0
- [ ] Verify directory structure matches FINAL_STRUCTURE.md
- [ ] Verify work item lifecycle (BACKLOG → ACTIVE → COMPLETE)
- [ ] Verify multi-role approval gates work
- [ ] Verify LEGO docs are complete (can regenerate code)
- [ ] Verify artifact immutability (specs are read-only)

#### 6.2: Idempotency Test
- [ ] Start work item WI-001
- [ ] Kill session mid-work-item (e.g., during PM review)
- [ ] Restart session
- [ ] Verify orchestrator resumes from correct point
- [ ] Verify no context loss (reads tracker.json, todos.md)
- [ ] Complete work item successfully

#### 6.3: Breaking Change Test
- [ ] Modify LEGO interface (breaking change)
- [ ] Verify tests break (show affected callers)
- [ ] Update affected callers
- [ ] Verify tests pass
- [ ] Verify `_manifest.json` updated (version bump, breaking change log)

#### 6.4: LEGO Regeneration Test
- [ ] Update LEGO docs (README, interface, workflows)
- [ ] Delete src/ (old implementation)
- [ ] Regenerate code from docs
- [ ] Verify code matches spec
- [ ] Verify tests pass

#### 6.5: Migration Test (v1.x → v2.0)
- [ ] Take existing v1.x app
- [ ] Run upgrade to v2.0
- [ ] Verify migration completes without errors
- [ ] Verify app still functions
- [ ] Verify new v2.0 features available

**Deliverables**:
- Test report (all scenarios pass)
- Bug fixes (if issues found)
- Performance baseline (time to build app)

**Success Criteria**:
- Can build complete app with v2.0
- Can restart without context loss
- Can detect and handle breaking changes
- Can regenerate code from LEGO docs
- Can migrate v1.x apps to v2.0

---

### **Phase 7: Release** (Est: 1 day)

**Goal**: Publish v2.0.0 release

#### 7.1: Version Bump
- [ ] Update `.meta/VERSION` (2.0.0)
- [ ] Update `README.md` version badge
- [ ] Update all templates with v2.0.0 version

#### 7.2: Git Tagging
- [ ] Commit all v2.0 changes
- [ ] Tag release: `git tag -a v2.0.0 -m "Meta-Orchestrator v2.0.0: Workspace-centric, self-documenting, idempotent"`
- [ ] Push tag: `git push origin v2.0.0`

#### 7.3: Announcement
- [ ] Write release notes (breaking changes, migration guide)
- [ ] Update GitHub releases page
- [ ] Notify users (if applicable)

**Deliverables**:
- Tagged v2.0.0 release
- Published release notes
- Migration guide available

**Success Criteria**:
- v2.0.0 is tagged and published
- Breaking changes clearly documented
- Migration path available for v1.x users

---

## Breaking Changes Summary

**For Users**:
1. **Directory structure changed**: `.app/`, `.workspace/`, `legos/`, `docs/user/`, `docs/dev/`
2. **Workflow changed**: Work items, multi-role approval, workspace lifecycle
3. **State management changed**: `tracker.json`, `todos.md`, `reviews/`
4. **LEGO structure changed**: Docs (README, interface, workflows) required
5. **Migration required**: v1.x apps must upgrade to v2.0 (not automatic)

**For Engine Developers**:
1. **Orchestration logic rewritten**: Workspace-centric execution
2. **Role switching mechanism new**: One role at a time, isolated context
3. **Generator system new**: Templates for `.app/` folder
4. **State persistence new**: File-based state management
5. **Review gate system new**: Multi-role blocking approval

---

## Risk Mitigation

### **Risk 1: Migration Complexity**
- **Mitigation**: Detailed UPGRADING.md with step-by-step instructions
- **Mitigation**: Test migration with sample app (OptionsTrader v1.x → v2.0)
- **Mitigation**: Provide rollback instructions (git tag v1-backup)

### **Risk 2: Performance Degradation**
- **Mitigation**: Benchmark v2.0 vs v1.x (time to build app)
- **Mitigation**: Optimize state file reads (cache tracker.json)
- **Mitigation**: Parallelize role reviews (if possible)

### **Risk 3: Incomplete Documentation**
- **Mitigation**: Comprehensive FINAL_STRUCTURE.md
- **Mitigation**: Detailed workflows in PROPOSED_WORKFLOWS.md
- **Mitigation**: Q&A session documented in SESSION_DESIGN_QA.md

### **Risk 4: Breaking Change Fatigue**
- **Mitigation**: Clear value proposition (true idempotency, tamper-proof brain)
- **Mitigation**: One-time migration (v2.0 stable for long term)
- **Mitigation**: Backward compatibility not feasible (clean break better than half-measures)

---

## Success Metrics

**Functional**:
- [ ] Can build complete app with v2.0 ✅
- [ ] Can restart without context loss ✅
- [ ] Can detect breaking changes ✅
- [ ] Can regenerate code from docs ✅
- [ ] Can migrate v1.x apps ✅

**Quality**:
- [ ] All tests pass ✅
- [ ] No antipatterns detected ✅
- [ ] Documentation complete ✅
- [ ] Performance acceptable ✅

**User Experience**:
- [ ] Workflow is intuitive ✅
- [ ] Error messages are clear ✅
- [ ] Migration guide is helpful ✅
- [ ] Users understand v2.0 benefits ✅

---

## Timeline Estimate

| Phase | Duration | Dependencies |
|-------|----------|--------------|
| Phase 0: Pre-Implementation | Complete | - |
| Phase 1: Core Engine Refactor | 3-5 days | Phase 0 |
| Phase 2: Generator System | 2-3 days | Phase 1 |
| Phase 3: Role Refactor | 2-3 days | Phase 1 |
| Phase 4: Workflow Refactor | 2-3 days | Phase 1, 3 |
| Phase 5: Documentation Update | 1-2 days | Phase 1-4 |
| Phase 6: Testing | 3-5 days | Phase 1-5 |
| Phase 7: Release | 1 day | Phase 6 |

**Total Estimate**: 14-22 days (2-4 weeks)

**Critical Path**: Phase 1 (Core Engine) → Phase 6 (Testing) → Phase 7 (Release)

---

## Next Actions

**Immediate** (Today):
1. Review this implementation plan with user
2. Get approval to proceed
3. Create GitHub milestone: "v2.0.0 Release"
4. Create GitHub issues for each phase

**Short-Term** (Next Week):
1. Start Phase 1: Core Engine Refactor
2. Implement state management (tracker.json, todos.md)
3. Implement workspace management (create, promote, cleanup)

**Medium-Term** (2-3 Weeks):
1. Complete Phases 2-5
2. Begin Phase 6: Testing
3. Iterate on bugs and issues

**Long-Term** (4 Weeks):
1. Complete testing
2. Finalize documentation
3. Release v2.0.0

---

**Status**: ✅ Design Complete → ⏳ Awaiting Implementation Approval

**Next Step**: User approval to proceed with Phase 1 implementation
