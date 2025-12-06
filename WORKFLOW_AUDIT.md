# v2.0 Workflow Quick Reference

**Purpose**: Zero-ambiguity guide to every action, outcome, hand-off, and cleanup in v2.0

**Date**: 2025-12-06  
**Roles**: PM, Designer, Architect, Developer, Tester, Writer, Orchestrator

---

## Quick Navigation

- [New Feature Flow](#new-feature-complete-flow)
- [Role Responsibilities](#role-responsibilities-summary)
- [Hand-off Checklist](#hand-off-checklist)
- [Git Workflow](#git-workflow)
- [Cleanup Rules](#cleanup-rules)

---

## New Feature: Complete Flow

**User says**: `"Add sentiment analysis to trading signals"`

### Phase 1: Work Item Creation (Orchestrator)

**Actions**:
```bash
# 1. Generate ID
WI_ID="WI-001"  # Next available from tracker.json

# 2. Create entry in tracker.json
{
  "id": "WI-001",
  "type": "new_feature",
  "state": "BACKLOG",
  "created": "2025-12-06T10:00:00Z"
}

# 3. Transition to ACTIVE
state: BACKLOG → ACTIVE

# 4. Create workspace
mkdir -p .workspace/WI-001/{pm,designer,architect,developer,tester,writer,reviews}

# 5. Create README.md and todos.md
```

**Outcomes**:
- ✅ tracker.json updated (WI-001 in "active" array)
- ✅ .workspace/WI-001/ created
- ✅ User sees: "Created WI-001, starting work..."

**Next**: PM Phase

---

### Phase 2: PM Phase

**Actor**: Orchestrator (wearing PM hat)

**Reads ONLY**: `.app/roles/product_manager.md`

**Actions**:
```bash
# 1. Write feature spec
cat > .workspace/WI-001/pm/FR-001-draft.md << 'EOF'
# Feature Spec: Sentiment Analysis (FR-001)

## Problem Statement
[User problem clearly stated]

## User Story
As a [user], I want [feature], so I can [benefit]

## Success Criteria
- [Measurable criterion 1]
- [Measurable criterion 2]

## Scope
[In scope / Out of scope]

## Dependencies
[External dependencies]

## Essence Alignment
[How this aligns with app's core value proposition]
EOF

# 2. Mark todo complete
sed -i 's/\[ \] PM: Write FR-001/[x] PM: Write FR-001/' .workspace/WI-001/todos.md
```

**Outcomes**:
- ✅ File: `.workspace/WI-001/pm/FR-001-draft.md`
- ✅ Todo marked: `[x] PM: Write FR-001`
- ⚠️ NOT promoted yet (still draft)

**Next**: Multi-Role Review

---

### Phase 3: Multi-Role Review (FR-001)

**Actor**: Orchestrator (switching hats: Designer, Architect, Developer, Tester, Writer, then Orchestrator)

**For EACH role**:

```bash
# Switch to role (e.g., Designer)
# Read ONLY .app/roles/designer.md

# Review FR-001
# Check role-specific criteria

# Write review
cat >> .workspace/WI-001/reviews/FR-001_reviews.md << 'EOF'
## Designer Review (2025-12-06T10:30:00Z)

**Status**: APPROVED ✅

**Feedback**:
- [Specific feedback]
- [Suggestions]

**Conditions for Approval**:
- [Any conditions]

**Verdict**: APPROVED ✅
EOF
```

**Possible Outcomes**:

1. **All 6 roles approve** → Mark todo, proceed
2. **Any role rejects** → PM addresses feedback, re-submit (clear reviews, repeat)

**When All Approve**:
```bash
# Mark todo
sed -i 's/\[ \] All roles review FR-001/[x] All roles review FR-001/' .workspace/WI-001/todos.md
```

**Outcomes**:
- ✅ File: `.workspace/WI-001/reviews/FR-001_reviews.md`
- ✅ All 6 roles written "APPROVED ✅"
- ✅ Todo marked
- ⚠️ FR-001-draft.md still in pm/ folder (not promoted yet)

**Next**: Designer Phase

---

### Phase 4: Designer Phase

**Actor**: Orchestrator (wearing Designer hat)

**Reads ONLY**: `.app/roles/designer.md`

**Actions**:
```bash
# 1. User research
cat > .workspace/WI-001/designer/UR-001-draft.md << 'EOF'
# User Research: [Feature] (UR-001)

## Research Goals
[What we want to learn]

## Methodology
[Interviews, surveys, competitive analysis]

## Key Findings
1. [Finding with evidence]
2. [Finding with evidence]

## Design Implications
[How findings inform design]
EOF

# 2. Wireframes
cat > .workspace/WI-001/designer/WF-001-draft.md << 'EOF'
# Wireframes: [Feature] (WF-001)

## Screen Flow
[Login] → [Dashboard] → [Detail]

## Screen: Dashboard
```
+------------------------------------+
| [ASCII art wireframe]              |
+------------------------------------+
```

## Interaction Notes
[Click behaviors, states]
EOF

# 3. Visual design
cat > .workspace/WI-001/designer/VD-001-draft.md << 'EOF'
# Visual Design: [Feature] (VD-001)

## Colors
- Primary: #HEX
- Success: #HEX

## Typography
- Headings: [Font, weight]

## Components
[Design system components]

## Accessibility
- Color contrast: WCAG AA
- Keyboard navigation: Full support
EOF

# 4. Mark todos
sed -i 's/\[ \] Designer: Create UR-001/[x] Designer: Create UR-001/' .workspace/WI-001/todos.md
[repeat for WF-001, VD-001]
```

**Outcomes**:
- ✅ Files: UR-001-draft.md, WF-001-draft.md, VD-001-draft.md
- ✅ Todos marked
- ⚠️ Still in designer/ folder (not promoted)

**Next**: Multi-Role Review (design)

---

### Phase 5: Multi-Role Review (Design)

**Same as Phase 3, but reviewing design artifacts**

**Outcomes**:
- ✅ All roles approved design
- ✅ Todo marked: `[x] All roles review UR-001 + WF-001 + VD-001`

**Next**: Architect Phase

---

### Phase 6: Architect Phase

**Actor**: Orchestrator (wearing Architect hat)

**Reads ONLY**: `.app/roles/architect.md`

**Actions**:
```bash
# Write design doc
cat > .workspace/WI-001/architect/DD-001-draft.md << 'EOF'
# Design Doc: [Feature] (DD-001)

## Architecture Overview
[Diagram showing LEGOs and data flow]

## New LEGOs
### LEGO: sentiment_analyzer
**Responsibility**: [Single responsibility]
**Dependencies**: [List]
**Interface**: [High-level API]

## Modified LEGOs
[Which existing LEGOs change and how]

## Data Flow
[Step-by-step data flow]

## Performance Requirements
[Latency, throughput]

## Error Handling
[How errors propagate]

## Security
[Security considerations]

## Testing Strategy
[Unit, integration, e2e tests]
EOF

# Mark todo
sed -i 's/\[ \] Architect: Write DD-001/[x] Architect: Write DD-001/' .workspace/WI-001/todos.md
```

**Outcomes**:
- ✅ File: DD-001-draft.md
- ✅ Todo marked
- ⚠️ Still in architect/ folder

**Next**: Multi-Role Review (DD-001)

---

### Phase 7: Multi-Role Review (DD-001)

**Same process**

**Next**: Developer Phase

---

### Phase 8: Developer Phase

**Actor**: Orchestrator (wearing Developer hat)

**Reads ONLY**: `.app/roles/developer.md`

**Actions**:
```bash
# Create LEGO structure
mkdir -p .workspace/WI-001/developer/sentiment_analyzer/src/tests

# 1. README.md (complete spec - can regenerate code from this)
cat > .workspace/WI-001/developer/sentiment_analyzer/README.md << 'EOF'
# Sentiment Analyzer LEGO

## Purpose & Responsibility
[Single responsibility statement]

## Dependencies
- External: [APIs, services]
- Internal: [Other LEGOs]

## Interface Contract
See `interface.md` for detailed API

## Implementation Strategy
[High-level approach]

## Error Handling
[How errors are handled]

## Testing Strategy
[Test coverage plan]

## Performance Characteristics
[Time/space complexity]

## Usage Examples
```python
[Code examples]
```
EOF

# 2. interface.md (executable contract)
cat > .workspace/WI-001/developer/sentiment_analyzer/interface.md << 'EOF'
# Sentiment Analyzer Interface

```python
def get_sentiment(symbol: str) -> SentimentScore:
    """
    [Full docstring]
    
    Args:
        symbol: [Description with constraints]
    
    Returns:
        [Return type and structure]
    
    Raises:
        [All exceptions]
    
    Side Effects:
        - [File I/O]
        - [Network calls]
        - [State mutations]
    
    Thread Safety: [Thread-safe or not]
    Performance: [O(n) complexity]
    Cost: [API costs if applicable]
    """
```
EOF

# 3. workflows.md (inter-LEGO interactions)
cat > .workspace/WI-001/developer/sentiment_analyzer/workflows.md << 'EOF'
# Sentiment Analyzer Workflows

## Callers
- [Which LEGOs call this]

## Callees
- [Which LEGOs this calls]

## Normal Flow
1. [Step-by-step normal execution]

## Error Flow
1. [Step-by-step error handling]

## Data Flow
[What data moves where]
EOF

# 4. Implement code
cat > .workspace/WI-001/developer/sentiment_analyzer/src/sentiment_analyzer.py << 'EOF'
"""Sentiment analyzer implementation."""
[Full implementation matching interface.md]
EOF

# 5. Write tests
cat > .workspace/WI-001/developer/sentiment_analyzer/src/tests/test_sentiment_analyzer.py << 'EOF'
"""Tests for sentiment analyzer."""
[Comprehensive tests: happy path, edge cases, errors]
EOF

# Mark todos
sed -i 's/\[ \] Developer: Create LEGO docs/[x] Developer: Create LEGO docs/' .workspace/WI-001/todos.md
sed -i 's/\[ \] Developer: Implement code/[x] Developer: Implement code/' .workspace/WI-001/todos.md
```

**Outcomes**:
- ✅ LEGO created with complete docs
- ✅ Code implemented
- ✅ Tests written
- ⚠️ Still in developer/ folder

**Next**: Multi-Role Review (LEGO)

---

### Phase 9: Multi-Role Review (LEGO)

**Same process**

**Next**: Tester Phase

---

### Phase 10: Tester Phase

**Actor**: Orchestrator (wearing Tester hat)

**Reads ONLY**: `.app/roles/tester.md`

**Actions**:
```bash
# Write test plan
cat > .workspace/WI-001/tester/TP-001-draft.md << 'EOF'
# Test Plan: [Feature] (TP-001)

## Test Strategy
[Unit, integration, e2e, performance, security]

## Test Cases

### TC-001: Happy Path
**Given**: [Precondition]
**When**: [Action]
**Then**: [Expected result]

### TC-002: Edge Case
[...]

### TC-003: Error Handling
[...]

## Performance Tests
[Load, stress, latency]

## Security Tests
[Input validation, auth, rate limiting]

## Accessibility Tests
[Keyboard nav, screen reader, color contrast]

## Test Data
[What data is needed]

## Pass/Fail Criteria
[When to consider test passed]
EOF

# Write additional tests (beyond what Developer wrote)
cat >> .workspace/WI-001/developer/sentiment_analyzer/src/tests/test_edge_cases.py << 'EOF'
"""Edge case tests."""
[Additional test scenarios]
EOF

# Mark todos
sed -i 's/\[ \] Tester: Write TP-001/[x] Tester: Write TP-001/' .workspace/WI-001/todos.md
sed -i 's/\[ \] Tester: Write tests/[x] Tester: Write tests/' .workspace/WI-001/todos.md
```

**Outcomes**:
- ✅ Test plan written
- ✅ Additional tests written
- ⚠️ Still in tester/ folder

**Next**: Multi-Role Review (tests)

---

### Phase 11: Multi-Role Review (Tests)

**Same process**

**Next**: Writer Phase

---

### Phase 12: Writer Phase

**Actor**: Orchestrator (wearing Writer hat)

**Reads ONLY**: `.app/roles/tech_writer.md`

**Actions**:
```bash
# Write user documentation
cat > .workspace/WI-001/writer/user_guide_draft.md << 'EOF'
# Using Sentiment Analysis

## What is Sentiment Analysis?
[Explain feature in user terms]

## How to Use It
1. [Step 1 with screenshot]
2. [Step 2 with screenshot]

## Understanding Sentiment Scores
- 0-30: Negative [red icon]
- 30-70: Neutral [amber icon]
- 70-100: Positive [green icon]

## Troubleshooting
**Q**: What if sentiment shows "N/A"?
**A**: [Explanation]

## Tips for Success
[Best practices]
EOF

# Update API docs
cat >> .workspace/WI-001/writer/api_reference_draft.md << 'EOF'
# Sentiment API

## get_sentiment(symbol)

**Description**: [User-friendly explanation]

**Parameters**:
- symbol (string): Stock ticker (e.g., "AAPL")

**Returns**: Sentiment score with trend

**Example**:
```python
score = get_sentiment("AAPL")
print(score.value)  # 78
```

**Common Errors**:
- "Invalid symbol": [How to fix]
EOF

# Mark todos
sed -i 's/\[ \] Writer: Write user docs/[x] Writer: Write user docs/' .workspace/WI-001/todos.md
```

**Outcomes**:
- ✅ User docs written
- ✅ API docs updated
- ⚠️ Still in writer/ folder

**Next**: Multi-Role Review (docs)

---

### Phase 13: Multi-Role Review (Docs)

**Same process**

**Outcome**: All artifacts approved

**Next**: Promotion

---

### Phase 14: Artifact Promotion (Orchestrator)

**Actor**: Orchestrator

**Actions**:
```bash
# 1. Transition state
jq "(.work_items[] | select(.id == \"WI-001\") | .state) = \"IN_REVIEW\"" .workspace/tracker.json > temp && mv temp .workspace/tracker.json

# 2. Check all reviews approved
grep -q "APPROVED ✅" .workspace/WI-001/reviews/*.md || { echo "Not all approved"; exit 1; }

# 3. Transition to APPROVED
jq "(.work_items[] | select(.id == \"WI-001\") | .state) = \"APPROVED\"" .workspace/tracker.json > temp && mv temp .workspace/tracker.json

# 4. Promote artifacts
# PM artifacts → specs/features/
mv .workspace/WI-001/pm/FR-001-draft.md specs/features/FR-001.md
chmod 444 specs/features/FR-001.md  # Read-only

# Designer artifacts → specs/design/ (or archive)
mv .workspace/WI-001/designer/UR-001-draft.md specs/design/UR-001.md
mv .workspace/WI-001/designer/WF-001-draft.md specs/design/WF-001.md
mv .workspace/WI-001/designer/VD-001-draft.md specs/design/VD-001.md
chmod 444 specs/design/*-001.md

# Architect artifacts → specs/design/
mv .workspace/WI-001/architect/DD-001-draft.md specs/design/DD-001.md
chmod 444 specs/design/DD-001.md

# Developer artifacts → legos/
mv .workspace/WI-001/developer/sentiment_analyzer legos/sentiment_analyzer

# Tester artifacts → specs/test_plans/
mv .workspace/WI-001/tester/TP-001-draft.md specs/test_plans/TP-001.md
chmod 444 specs/test_plans/TP-001.md

# Writer artifacts → docs/user/ and docs/dev/
# (Merge into existing docs, don't replace)
cat .workspace/WI-001/writer/user_guide_draft.md >> docs/user/user-guide.md
cat .workspace/WI-001/writer/api_reference_draft.md >> docs/user/api-reference.md

# 5. Update LEGO manifest
jq ".legos += [{
  \"name\": \"sentiment_analyzer\",
  \"version\": \"1.0.0\",
  \"dependencies\": [],
  \"interface_hash\": \"$(sha256sum legos/sentiment_analyzer/interface.md | cut -d' ' -f1)\",
  \"breaking_changes\": []
}]" legos/_manifest.json > temp && mv temp legos/_manifest.json

# 6. Update dependency graph
jq ".dependency_graph.sentiment_analyzer = []" legos/_manifest.json > temp && mv temp legos/_manifest.json

# 7. Git commit (ATOMIC)
git add -A
git commit -m "Complete WI-001: Add sentiment analysis to trading signals

Artifacts promoted:
- specs/features/FR-001.md (feature spec, immutable)
- specs/design/UR-001.md, WF-001.md, VD-001.md, DD-001.md (design, immutable)
- specs/test_plans/TP-001.md (test plan, immutable)
- legos/sentiment_analyzer/ (new LEGO with docs + code + tests)
- docs/user/user-guide.md (updated)
- docs/user/api-reference.md (updated)

All artifacts reviewed and approved by 6 roles.
Tests pass. Ready for production.
"

# 8. Delete workspace
rm -rf .workspace/WI-001/

# 9. Transition to COMPLETE
jq "(.work_items[] | select(.id == \"WI-001\") | .state) = \"COMPLETE\"" .workspace/tracker.json > temp && mv temp .workspace/tracker.json
jq "(.work_items[] | select(.id == \"WI-001\") | .completed) = \"$(date -Iseconds)\"" .workspace/tracker.json > temp && mv temp .workspace/tracker.json
jq ".active -= [\"WI-001\"]" .workspace/tracker.json > temp && mv temp .workspace/tracker.json
jq ".current_work_item = null" .workspace/tracker.json > temp && mv temp .workspace/tracker.json

# 10. Update CHANGELOG (optional but recommended)
cat >> CHANGELOG.md << 'EOF'
## [Unreleased]

### Added
- Sentiment analysis feature (WI-001, FR-001)
  - Real-time sentiment scores on signal dashboard
  - Sentiment filter for signals
  - Integration with Twitter API
EOF
```

**Outcomes**:
- ✅ All artifacts promoted to permanent locations
- ✅ Specs are immutable (chmod 444)
- ✅ LEGO in `legos/` folder
- ✅ Docs updated in `docs/user/`
- ✅ Git committed (atomic)
- ✅ `.workspace/WI-001/` DELETED
- ✅ tracker.json updated (state: COMPLETE)
- ✅ CHANGELOG updated

**User Sees**:
```
WI-001 complete! 🎉

Artifacts:
- Feature spec: specs/features/FR-001.md
- Design docs: specs/design/UR-001.md, WF-001.md, VD-001.md, DD-001.md
- LEGO: legos/sentiment_analyzer/
- Test plan: specs/test_plans/TP-001.md
- User docs: docs/user/user-guide.md (updated)

Total time: 4h 30m
Next: Check backlog for WI-002
```

**Repository State After WI-001**:
```
my-app/
├── .workspace/
│   └── tracker.json           # WI-001 marked COMPLETE
├── legos/
│   ├── _manifest.json         # Updated with sentiment_analyzer
│   └── sentiment_analyzer/    # NEW
│       ├── README.md          # Complete spec
│       ├── interface.md       # Executable contract
│       ├── workflows.md       # Inter-LEGO interactions
│       └── src/
│           ├── sentiment_analyzer.py
│           └── tests/
│               ├── test_sentiment_analyzer.py
│               └── test_edge_cases.py
├── specs/
│   ├── features/
│   │   └── FR-001.md          # NEW, immutable (chmod 444)
│   ├── design/
│   │   ├── UR-001.md          # NEW, immutable
│   │   ├── WF-001.md          # NEW, immutable
│   │   ├── VD-001.md          # NEW, immutable
│   │   └── DD-001.md          # NEW, immutable
│   └── test_plans/
│       └── TP-001.md          # NEW, immutable
├── docs/
│   └── user/
│       ├── user-guide.md      # UPDATED
│       └── api-reference.md   # UPDATED
└── CHANGELOG.md               # UPDATED
```

**NO clutter in root**: All temp files deleted, git history preserves decisions.

---

## Role Responsibilities Summary

| Role | Creates | Reviews | Hand-off To |
|------|---------|---------|-------------|
| **PM** | FR-XXX (feature specs) | All artifacts for feasibility | Designer |
| **Designer** | UR-XXX, WF-XXX, VD-XXX, ID-XXX, AA-XXX | All artifacts for UX | Architect, Developer |
| **Architect** | DD-XXX (design docs) | All artifacts for technical feasibility | Developer |
| **Developer** | LEGO docs + code | All artifacts for implementability | Tester |
| **Tester** | TP-XXX (test plans) + tests | All artifacts for testability | Writer |
| **Writer** | User docs, API docs | All artifacts for documentability | Orchestrator |
| **Orchestrator** | Work items, state management | All artifacts for completeness | User (delivery) |

---

## Hand-off Checklist

### PM → Designer
- [ ] Feature spec complete (FR-XXX)
- [ ] Success criteria measurable through UI
- [ ] User problem clearly defined

### Designer → Architect
- [ ] User research complete (UR-XXX)
- [ ] Wireframes show all screens (WF-XXX)
- [ ] Visual design specifies design system (VD-XXX)
- [ ] Performance requirements specified (<1s page load)

### Architect → Developer
- [ ] Design doc complete (DD-XXX)
- [ ] LEGO structure defined
- [ ] Dependencies identified
- [ ] Performance requirements specified

### Developer → Tester
- [ ] LEGO docs complete (README, interface, workflows)
- [ ] Code implemented
- [ ] Unit tests written
- [ ] Test data provided

### Tester → Writer
- [ ] Test plan complete (TP-XXX)
- [ ] All test cases pass
- [ ] Edge cases documented
- [ ] Performance validated

### Writer → Orchestrator
- [ ] User docs complete
- [ ] API docs complete
- [ ] Terminology consistent
- [ ] Screenshots/diagrams included

---

## Git Workflow

**During Work Item (WI-001 ACTIVE)**:
```bash
# Workspace IS committed (preserves decisions)
git add .workspace/WI-001/
git commit -m "WI-001: PM completed FR-001"

git add .workspace/WI-001/
git commit -m "WI-001: Designer completed UR-001, WF-001, VD-001"

# Continue committing workspace changes
```

**After Promotion (WI-001 COMPLETE)**:
```bash
# Final atomic commit
git add -A
git commit -m "Complete WI-001: [title]

Artifacts:
- specs/features/FR-001.md
- legos/sentiment_analyzer/
[...]
"

# Workspace deleted (but preserved in git history)
rm -rf .workspace/WI-001/

# Can still see workspace history
git log --all -- .workspace/WI-001/
git show HEAD~1:.workspace/WI-001/reviews/FR-001_reviews.md
```

**Benefit**: Full audit trail, can replay any decision.

---

## Cleanup Rules

### After WI-001 COMPLETE

**DELETE** (Ephemeral):
```bash
.workspace/WI-001/  # ALL contents
```

**PRESERVE** (Permanent):
```bash
specs/features/FR-001.md           # Immutable
specs/design/UR-001.md, WF-001.md, VD-001.md, DD-001.md
specs/test_plans/TP-001.md
legos/sentiment_analyzer/          # Self-documenting
docs/user/user-guide.md            # Updated
```

**PRESERVE** (Git History):
```bash
git log -- .workspace/WI-001/      # All decisions preserved
```

### NO Clutter in Root

**Orchestrator NEVER creates**:
- ❌ Temp scripts
- ❌ Summary files
- ❌ Work logs
- ❌ Notes

**Orchestrator ONLY updates**:
- ✅ CHANGELOG.md (append new entry)
- ✅ APP_ORCHESTRATION.md (append high-level decision, NOT work item details)

---

## State Transitions

```
BACKLOG     No .workspace/WI-XXX/ folder
   ↓
ACTIVE      .workspace/WI-XXX/ created, work in progress
   ↓
IN_REVIEW   All artifacts created, awaiting reviews
   ↓
APPROVED    All roles approved, promoting artifacts
   ↓
COMPLETE    .workspace/WI-XXX/ DELETED, artifacts promoted
```

**State Change Authority**: Orchestrator ONLY (automated based on conditions)

---

## Summary

**Key Principle**: All WIP in `.workspace/`, deleted after promotion. Git history preserves everything. Root stays clean.

**Roles**: 6 roles, each reviews all others. Multi-stakeholder approval prevents rework.

**Artifacts**: Immutable after approval (specs/ is chmod 444). LEGOs self-documenting (docs can regenerate code).

**Git**: Workspace committed during work, deleted after completion. Full audit trail.

**Cleanup**: Zero clutter in root. Only permanent, well-organized files.

---

**For complete details, see**:
- WORK_ITEM_TRACKER.md (tracker.json spec)
- PROPOSED_WORKFLOWS.md (detailed workflows)
- .meta/roles/*.md (role responsibilities)
