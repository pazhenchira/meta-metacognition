# Phase 1.6 Quick Reference

**Version**: 1.3.0  
**Date**: November 24, 2025  
**Status**: ✅ Complete

---

## What Changed

Added **app-specific orchestration documentation** via `APP_ORCHESTRATION.md`.

---

## Key Distinction

### AGENTS.md (Universal Engine)
- **Location**: `.meta/AGENTS.md`
- **Purpose**: Describes **HOW** to orchestrate **ANY** app
- **Reusable**: Same file copied to every app
- **Content**: Meta-orchestrator pipeline, LEGO sessions, GEN+REVIEW patterns

### APP_ORCHESTRATION.md (App-Specific Plan)
- **Location**: App root (e.g., `my-app/APP_ORCHESTRATION.md`)
- **Purpose**: Describes **WHAT THIS app** does and **WHY**
- **Unique**: Generated per app based on `app_intent.md`
- **Content**: LEGO breakdown, dependencies, risks, wisdom applied, testing strategy

---

## Structure

```
my-app/
├── .meta/                       # Universal engine
│   ├── AGENTS.md                # HOW to orchestrate (any app)
│   ├── principles.md
│   ├── wisdom/
│   └── patterns/
│
├── app_intent.md                # YOUR requirements
├── APP_ORCHESTRATION.md         # Orchestration plan (THIS app) ✨
├── lego_plan.json               # Machine-readable LEGOs
├── requirements.md              # Refined requirements
├── src/                         # Generated code
└── tests/                       # Generated tests
```

---

## What APP_ORCHESTRATION.md Contains

1. **Application Overview** - Purpose, domain, risk level, complexity
2. **LEGO Architecture** - Table, dependency graph, parallelizable groups, per-LEGO details
3. **Session Execution Plan** - Session hierarchy, execution phases, isolation strategy
4. **Risk & Confidence Assessment** - High-risk LEGOs, low-confidence LEGOs, critical dependencies
5. **Wisdom & Patterns Applied** - Which principles, antipatterns avoided, trade-offs resolved
6. **Testing Strategy** - Unit/integration/system test scope
7. **Documentation Plan** - User/developer/operational docs
8. **Evaluation & Success Criteria** - Functional/non-functional/process success
9. **Known Limitations & Future Work** - Current limitations, technical debt, enhancements
10. **Execution Log** - Checkpoints at each phase
11. **Final Approval** - Overall confidence, deployment readiness

---

## Lifecycle

### Generation (Section 6 of AGENTS.md)
- After `lego_plan.json` created
- Uses `.app_orchestration.template.md`
- Fills with app-specific data
- Writes with status `[IN_PROGRESS]`
- (Optional) Shows to user for approval

### Updates During Execution
- Execution log updated at checkpoints
- LEGO details updated with wisdom applied
- Testing strategy updated with results

### Finalization (Section 11 of AGENTS.md)
- All checkpoints marked `COMPLETE`
- Final approval section filled
- Status changed to `[COMPLETE]`
- Added to `.meta-manifest.json`

---

## Benefits

✅ **Separation**: Engine (AGENTS.md) vs App Plan (APP_ORCHESTRATION.md)  
✅ **Auditability**: Documents all decisions and rationale  
✅ **Onboarding**: New devs understand app structure and why  
✅ **Upgrade Safety**: Original decisions preserved during engine upgrades  
✅ **Human-Readable**: Complements machine-readable `lego_plan.json`

---

## Files Changed

**New**:
- `.app_orchestration.template.md` (template)
- `PHASE1.6_SUMMARY.md` (documentation)

**Modified**:
- `AGENTS.md` (Sections 6, 11)
- `DEPLOYMENT_GUIDE.md` (file structure)
- `VERSION` (1.2.0 → 1.3.0)

---

**Status**: Ready for testing with new app builds.
