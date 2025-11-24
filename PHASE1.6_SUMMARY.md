# Phase 1.6: App-Specific Orchestration Documentation

**Date**: November 24, 2025  
**Version**: 1.3.0  
**Status**: ✅ Complete

---

## What Was Added

Phase 1.6 introduces **app-specific orchestration documentation** through the `APP_ORCHESTRATION.md` file.

**Problem Solved**: Previously, `AGENTS.md` was a generic, universal meta-orchestrator engine file copied into every app. There was no app-specific document explaining the orchestration plan for a particular application.

**Solution**: Generate `APP_ORCHESTRATION.md` - a human-readable orchestration plan specific to each app, documenting LEGOs, dependencies, session execution, risks, wisdom applied, and testing strategy.

---

## Key Distinction

### Before Phase 1.6

```
my-app/
├── .meta/
│   ├── AGENTS.md              # UNIVERSAL engine (same for all apps)
│   ├── principles.md          # UNIVERSAL principles
│   └── ...
├── app_intent.md              # App-specific (user writes)
├── lego_plan.json             # App-specific (machine-readable)
└── requirements.md            # App-specific (generated)
```

**Issue**: No human-readable app-specific orchestration plan.

### After Phase 1.6

```
my-app/
├── .meta/
│   ├── AGENTS.md              # UNIVERSAL engine (how to orchestrate ANY app)
│   ├── principles.md          # UNIVERSAL principles
│   └── ...
├── app_intent.md              # App-specific (user writes THIS app's requirements)
├── APP_ORCHESTRATION.md       # App-specific (orchestration plan for THIS app) ✨ NEW
├── lego_plan.json             # App-specific (machine-readable LEGO breakdown)
└── requirements.md            # App-specific (refined requirements)
```

**Solution**: `APP_ORCHESTRATION.md` documents the orchestration strategy for THIS specific app.

---

## What APP_ORCHESTRATION.md Contains

### 1. Application Overview
- Purpose and domain
- Risk level (CRITICAL/HIGH/MEDIUM/LOW)
- Complexity score

### 2. LEGO Architecture
- Complete LEGO breakdown table
- Dependency graph (visual)
- Parallelizable groups
- Critical path
- Per-LEGO details:
  - Responsibility
  - Risk assessment
  - Inputs/outputs
  - Confidence score
  - Wisdom applied
  - Antipatterns avoided
  - Trade-offs resolved

### 3. Session Execution Plan
- Session hierarchy (Meta → LEGO orchestrators)
- Execution phases (sequential vs parallel)
- Session isolation strategy

### 4. Risk & Confidence Assessment
- High-risk LEGOs table
- Low-confidence LEGOs table
- Critical external dependencies
- Data sensitivity summary

### 5. Wisdom & Patterns Applied
- Engineering wisdom used
- Strategic wisdom used
- Antipatterns detected and avoided
- Trade-offs resolved with rationale

### 6. Testing Strategy
- Unit test coverage targets
- Integration test scenarios
- System test end-to-end flows
- Non-functional test criteria

### 7. Documentation Plan
- User-facing docs (README, API, CONFIGURATION)
- Developer docs (ARCHITECTURE, CONTRIBUTING)
- Operational docs (DEPLOYMENT, MONITORING, RUNBOOK)

### 8. Evaluation & Success Criteria
- Functional success (all tests passing)
- Non-functional success (performance, security, reliability)
- Process success (session isolation working, red-team complete)

### 9. Known Limitations & Future Work
- Current limitations
- Technical debt
- Future enhancements

### 10. Execution Log
- Checkpoint 1: Requirements Discovery
- Checkpoint 2: LEGO Plan Approval
- Checkpoint 3: Implementation
- Checkpoint 4: Testing
- Checkpoint 5: Documentation & Review

### 11. Final Approval
- Overall confidence score
- All critical LEGOs validated
- Security review complete
- Ready for deployment (YES/NO/WITH_CAVEATS)

---

## File Lifecycle

### Generation (Section 6 of AGENTS.md)

After `lego_plan.json` is created:

1. Meta-orchestrator reads `.app_orchestration.template.md`
2. Fills in all sections with app-specific data:
   - From `app_intent.md`: purpose, domain
   - From `requirements.md`: requirements, constraints
   - From `lego_plan.json`: LEGO breakdown, dependencies
   - From confidence scores: risk assessment
   - From wisdom files: patterns and principles applied
3. Writes `APP_ORCHESTRATION.md` with status `[IN_PROGRESS]`
4. (Optional) Shows to user for approval if `require_lego_plan_approval: true`

### Updates During Execution

As pipeline executes:
- **Execution Log** section updated at each checkpoint
- **LEGO Details** updated with actual wisdom applied, antipatterns avoided
- **Testing Strategy** updated with test results

### Finalization (Section 11 of AGENTS.md)

When all LEGOs are complete:

1. Update all execution log checkpoints to `COMPLETE`
2. Fill in **Final Approval** section:
   - Calculate overall confidence score
   - Verify all critical LEGOs validated
   - Confirm security review complete (if applicable)
   - Confirm documentation complete
   - Set "Ready for Deployment" status
3. Mark `APP_ORCHESTRATION.md` status as `[COMPLETE]`
4. Add to `.meta-manifest.json` as a generated file

---

## Benefits

### 1. Clear Separation of Concerns

- **`AGENTS.md`** (in `.meta/`): Universal engine, describes HOW to orchestrate ANY app
- **`APP_ORCHESTRATION.md`** (in app root): App-specific plan, describes WHAT THIS app does and WHY

### 2. Human-Readable Orchestration

- **`lego_plan.json`**: Machine-readable LEGO breakdown
- **`APP_ORCHESTRATION.md`**: Human-readable orchestration plan with rationale

### 3. Auditability

Documents:
- Which wisdom principles were consulted
- Which antipatterns were avoided
- Which trade-offs were made and why
- Confidence scores for each design decision

### 4. Onboarding & Maintenance

New developers can read `APP_ORCHESTRATION.md` to understand:
- Why the app is structured this way
- What the risks are
- What the testing strategy is
- What trade-offs were considered

### 5. Upgrade Safety

When upgrading meta-orchestrator version:
- `APP_ORCHESTRATION.md` documents original decisions
- Helps determine if re-generation is safe
- Preserves rationale for user-modified LEGOs

---

## Integration with Version Management

`APP_ORCHESTRATION.md` is tracked in `.meta-manifest.json`:

```json
{
  "files": [
    {
      "path": "APP_ORCHESTRATION.md",
      "type": "orchestration",
      "generated_by": "meta-orchestrator",
      "generated_at": "2025-11-24T10:30:00Z",
      "user_modified": false
    }
  ]
}
```

**UPGRADE MODE** behavior:
- If `user_modified: false`: Regenerate with new features
- If `user_modified: true`: Preserve user changes, append upgrade notes

---

## Example: Stock Analyzer App

### Generated APP_ORCHESTRATION.md Structure

```markdown
# Application Orchestration Plan

**Application**: Stock Market Analyzer  
**Meta-Orchestrator Version**: 1.3.0  
**Generated**: 2025-11-24  
**Status**: [COMPLETE]

## 1. Application Overview

**Purpose**: CLI tool that analyzes stock market data and generates investment reports.

**Domain**: Finance

**Risk Level**: MEDIUM (external API dependencies, financial data)

## 2. LEGO Architecture

Total LEGOs: 6

| LEGO Name | Type | Responsibility | Risk Level | Dependencies | Confidence |
|-----------|------|---------------|------------|--------------|------------|
| config_validator | config_validation | Validate Yahoo Finance API key | CRITICAL | (none) | 0.95 |
| stock_fetcher | implementation | Fetch real-time stock prices | HIGH | config_validator | 0.85 |
| technical_analyzer | implementation | Calculate RSI, MACD, MA | MEDIUM | (none) | 0.90 |
| database | implementation | Store historical data in PostgreSQL | HIGH | config_validator | 0.88 |
| report_generator | implementation | Generate PDF reports | LOW | technical_analyzer, database | 0.82 |
| integration_tests | integration_test | Test end-to-end flows | MEDIUM | all impl LEGOs | 0.85 |

### Dependency Graph

```
config_validator (Priority: CRITICAL)
    ↓
stock_fetcher → database → report_generator
    ↓              ↓
technical_analyzer (parallel)
    ↓
integration_tests
```

## 3. Session Execution Plan

**Phase 1**: config_validator (sequential, CRITICAL)
**Phase 2**: stock_fetcher, technical_analyzer, database (parallel)
**Phase 3**: report_generator (after Phase 2)
**Phase 4**: integration_tests (after Phase 3)

## 4. Risk & Confidence Assessment

**High-Risk LEGOs**:
- stock_fetcher: External API dependency (Yahoo Finance)
  - Mitigation: Circuit breaker, retry with exponential backoff, rate limiting

**Critical Dependencies**:
- Yahoo Finance API: Free tier, 500 requests/day limit
  - Env var: YAHOO_FINANCE_API_KEY
  - Circuit breaker: Open after 3 consecutive failures

## 5. Wisdom & Patterns Applied

**Engineering Wisdom**:
- Thompson #5: Each LEGO does one thing well
- Knuth #2: No premature optimization (defer PDF generation optimization)

**Success Patterns**:
- Circuit Breaker: Applied to stock_fetcher (external API)
- Repository Pattern: Applied to database (centralized data access)

**Antipatterns Avoided**:
- God Object: Split initial "stock_analyzer" into 4 LEGOs
- NIH Syndrome: Use existing PDF library (ReportLab) instead of custom

**Trade-offs**:
- SQL vs NoSQL: SQL (structured data, need ACID for financial data)
- Sync vs Async: Sync (simplicity, CLI tool, no concurrency needed)

## 6. Testing Strategy

**Unit Tests**:
- stock_fetcher: Mock Yahoo Finance API responses
- technical_analyzer: Test calculations with known inputs
- database: Test CRUD operations with in-memory SQLite

**Integration Tests**:
- End-to-end: Fetch stock → Calculate indicators → Store in DB → Generate report

## 11. Final Approval

- Overall Confidence: 0.87
- All Critical LEGOs: VALIDATED
- Security Review: COMPLETE (no sensitive data)
- Documentation: COMPLETE
- Ready for Deployment: YES
```

---

## Files Changed

**New Files** (2):
- `.app_orchestration.template.md` - Template structure
- `PHASE1.6_SUMMARY.md` - This file

**Modified Files** (3):
- `AGENTS.md` - Section 6 (add APP_ORCHESTRATION.md generation), Section 11 (finalize)
- `DEPLOYMENT_GUIDE.md` - Document APP_ORCHESTRATION.md in file structure
- `VERSION` - Updated from 1.2.0 → 1.3.0

---

## Summary

Phase 1.6 completes the separation between:
- **Universal Meta-Orchestrator Engine** (`.meta/AGENTS.md`) - How to orchestrate ANY app
- **App-Specific Orchestration Plan** (`APP_ORCHESTRATION.md`) - WHAT THIS app does and WHY

This improves:
- ✅ Clarity (engine vs app concerns separated)
- ✅ Auditability (documents all decisions)
- ✅ Maintainability (new devs understand why)
- ✅ Upgrade safety (original decisions preserved)

**Status**: Ready for testing with new app builds.
