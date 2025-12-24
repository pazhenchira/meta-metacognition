# Work Item Tracker Specification

**Note**: In app context, "Orchestrator" means the **App Orchestrator** (the app-level owner).

**File**: `.workspace/tracker.json`  
**Purpose**: Central log of all work items (past, present, future)  
**Owner**: App-Orchestrator  
**Lifecycle**: Permanent (survives workspace deletion)

---

## Schema

```json
{
  "work_items": [
    {
      "id": "WI-001",
      "type": "new_feature" | "enhancement" | "bug_fix",
      "title": "Add sentiment analysis to trading signals",
      "description": "User wants to incorporate market sentiment into signal generation",
      "source": "conversation" | "app_intent.md",
      "state": "COMPLETE",
      "created_by": "user",
      "created": "2025-12-06T10:00:00Z",
      "started": "2025-12-06T10:05:00Z",
      "completed": "2025-12-06T14:30:00Z",
      "state_transitions": [
        {"from": null, "to": "BACKLOG", "timestamp": "2025-12-06T10:00:00Z", "reason": "Created from user request"},
        {"from": "BACKLOG", "to": "ACTIVE", "timestamp": "2025-12-06T10:05:00Z", "reason": "Started by orchestrator"},
        {"from": "ACTIVE", "to": "IN_REVIEW", "timestamp": "2025-12-06T12:00:00Z", "reason": "All artifacts created, awaiting approvals"},
        {"from": "IN_REVIEW", "to": "APPROVED", "timestamp": "2025-12-06T13:30:00Z", "reason": "All 5 roles approved"},
        {"from": "APPROVED", "to": "COMPLETE", "timestamp": "2025-12-06T14:30:00Z", "reason": "Artifacts promoted, workspace deleted"}
      ],
      "artifacts": [
        "specs/features/FR-001.md",
        "specs/design/DD-001.md",
        "specs/test_plans/TP-001.md",
        "legos/sentiment_analyzer/"
      ],
      "related_work_items": ["WI-002"]
    }
  ],
  "backlog": ["WI-002", "WI-003"],
  "active": [],
  "current_work_item": null,
  "next_id": 4,
  "version": "2.0.0",
  "created": "2025-12-06T03:00:00Z",
  "last_updated": "2025-12-06T14:30:00Z"
}
```

---

## Work Item States

```
BACKLOG → ACTIVE → IN_REVIEW → APPROVED → COMPLETE
   ↑         ↓                      ↓
   └─────── BLOCKED ────────────────┘
```

| State | Meaning | `.workspace/WI-XXX/` exists? | Who can transition? |
|-------|---------|------------------------------|---------------------|
| **BACKLOG** | Queued, not started | ❌ No | App Orchestrator only |
| **ACTIVE** | Work in progress | ✅ Yes | App Orchestrator only |
| **IN_REVIEW** | Awaiting multi-role approval | ✅ Yes | Orchestrator (after artifacts complete) |
| **BLOCKED** | Waiting on external dependency | ✅ Yes | Orchestrator (when dependency detected) |
| **APPROVED** | All approvals received, promoting | ✅ Yes | Orchestrator (after all approvals) |
| **COMPLETE** | Done, workspace deleted | ❌ No | App Orchestrator only |

---

## Who Creates Work Items?

### **Primary: App Orchestrator (Automated)**

When user says "Add feature X" or edits `app_intent.md`:

```markdown
1. User: "Add sentiment analysis to trading signals"

2. App App Orchestrator detects new feature request

3. App Orchestrator creates work item:
   - Generates ID: "WI-001" (next available)
   - Type: "new_feature" (inferred from conversation)
   - Title: Extracted from user request
   - Description: Summarized from clarifying questions
   - State: "BACKLOG" initially
   - Source: "conversation"
   
4. Adds to tracker.json:
   - work_items array gets new entry
   - backlog array gets "WI-001"
   - next_id incremented to 2

5. App Orchestrator shows user:
   "Created WI-001: Add sentiment analysis to trading signals"
   "State: BACKLOG"
   "Starting work..."
```

### **Secondary: Discovered During Work (Automated)**

When Developer finds "need circuit breaker":

```markdown
1. Developer (as orchestrator in developer role): Working on WI-001

2. Realizes: "This LEGO needs a circuit breaker pattern"

3. App Orchestrator creates child work item:
   - ID: "WI-002"
   - Type: "enhancement"
   - Title: "Add circuit breaker to market_data_fetcher"
   - Description: "Protect against API failures during signal generation"
   - State: "BACKLOG"
   - Source: "discovered"
   - Related: "WI-001" (parent)

4. Adds to tracker.json backlog

5. Continues WI-001, will handle WI-002 after
```

### **Never: User Directly**

Users **do not edit tracker.json**. All modifications via orchestrator.

---

## Information Required for Work Item

**Minimum** (orchestrator can infer):
- User request: "Add feature X" OR edited `app_intent.md`

**Orchestrator extracts**:
- `id`: Auto-generated (WI-001, WI-002, ...)
- `type`: Inferred from request (new_feature, enhancement, bug_fix)
- `title`: Extracted from user request or app_intent.md
- `description`: Summarized after clarifying questions
- `source`: "conversation" or "app_intent.md"
- `created_by`: "user"
- `created`: Current timestamp
- `state`: "BACKLOG" initially

**Optional** (orchestrator may discover later):
- `related_work_items`: Links to parent/child work items
- `blocked_by`: External dependency description
- `estimated_complexity`: Low/Medium/High (from architect analysis)

---

## State Transitions (Who & When)

### **BACKLOG → ACTIVE**

**Who**: Orchestrator  
**When**: 
- No other work item is ACTIVE
- OR user explicitly says "Start WI-002"

**Action**:
```json
{
  "from": "BACKLOG",
  "to": "ACTIVE",
  "timestamp": "ISO8601",
  "reason": "Started by orchestrator (no other active work)"
}
```

**Side effects**:
- Create `.workspace/WI-XXX/` folder
- Create `README.md`, `todos.md` in workspace
- Remove from `backlog` array
- Add to `active` array
- Set `current_work_item` to this ID

---

### **ACTIVE → IN_REVIEW**

**Who**: Orchestrator  
**When**: All role artifacts completed (PM wrote spec, Architect wrote design, etc.)

**Condition**:
```markdown
Check .workspace/WI-001/todos.md:
- [x] PM: Write FR-001
- [x] Architect: Write DD-001
- [x] Developer: Create LEGO docs + code
- [x] Tester: Write TP-001 + tests
- [x] Writer: Write user docs
- [ ] PM: Review DD-001  ← Next task is REVIEW
```

**Action**:
```json
{
  "from": "ACTIVE",
  "to": "IN_REVIEW",
  "timestamp": "ISO8601",
  "reason": "All artifacts created, awaiting multi-role approvals"
}
```

**Side effects**:
- None (workspace stays, reviews happen)

---

### **IN_REVIEW → APPROVED**

**Who**: Orchestrator  
**When**: All 5 roles have approved all artifacts

**Condition**:
```markdown
Check .workspace/WI-001/reviews/:
- FR-001_reviews.md: All 5 roles say "APPROVED ✅"
- DD-001_reviews.md: All 5 roles say "APPROVED ✅"
- TP-001_reviews.md: All 5 roles say "APPROVED ✅"
- code_reviews.md: All 5 roles say "APPROVED ✅"
- docs_reviews.md: All 5 roles say "APPROVED ✅"
```

**Action**:
```json
{
  "from": "IN_REVIEW",
  "to": "APPROVED",
  "timestamp": "ISO8601",
  "reason": "All 5 roles approved all artifacts"
}
```

**Side effects**:
- Orchestrator begins promoting artifacts

---

### **APPROVED → COMPLETE**

**Who**: Orchestrator  
**When**: All artifacts promoted, workspace cleaned up

**Process**:
1. Promote artifacts:
   ```bash
   mv .workspace/WI-001/pm/FR-001-draft.md specs/features/FR-001.md
   chmod 444 specs/features/FR-001.md
   mv .workspace/WI-001/architect/DD-001-draft.md specs/design/DD-001.md
   chmod 444 specs/design/DD-001.md
   mv .workspace/WI-001/developer/sentiment_analyzer/ legos/sentiment_analyzer/
   mv .workspace/WI-001/tester/TP-001-draft.md specs/test_plans/TP-001.md
   chmod 444 specs/test_plans/TP-001.md
   # Update docs/user/ and docs/dev/ from .workspace/WI-001/writer/
   ```

2. Git commit:
   ```bash
   git add -A
   git commit -m "Complete WI-001: Add sentiment analysis to trading signals

   Artifacts:
   - specs/features/FR-001.md (immutable)
   - specs/design/DD-001.md (immutable)
   - specs/test_plans/TP-001.md (immutable)
   - legos/sentiment_analyzer/ (new LEGO)
   - docs/user/user-guide.md (updated)
   "
   ```

3. Delete workspace:
   ```bash
   rm -rf .workspace/WI-001/
   ```

4. Update tracker:
   ```json
   {
     "from": "APPROVED",
     "to": "COMPLETE",
     "timestamp": "ISO8601",
     "reason": "Artifacts promoted, workspace deleted, committed to git"
   }
   ```

**Side effects**:
- Remove from `active` array
- Set `current_work_item` to null
- Artifacts listed in work_item.artifacts array
- Workspace folder DELETED (git history preserves decisions)

---

### **ACTIVE → BLOCKED**

**Who**: Orchestrator or any role  
**When**: External dependency discovered

**Example**:
```markdown
Developer: "Can't implement sentiment_analyzer until we integrate Twitter API"

Orchestrator: "This work item is blocked by external dependency"
```

**Action**:
```json
{
  "from": "ACTIVE",
  "to": "BLOCKED",
  "timestamp": "ISO8601",
  "reason": "Blocked by external dependency: Twitter API integration required"
}
```

**Side effects**:
- Workspace preserved (`.workspace/WI-001/` stays)
- Remove from `active` array
- Add to `blocked` array (if exists)
- Orchestrator can start next work item from backlog

---

### **BLOCKED → ACTIVE**

**Who**: Orchestrator  
**When**: User resolves external dependency

**Example**:
```markdown
User: "Twitter API is integrated, WI-001 can resume"

Orchestrator: "Resuming WI-001"
```

**Action**:
```json
{
  "from": "BLOCKED",
  "to": "ACTIVE",
  "timestamp": "ISO8601",
  "reason": "External dependency resolved (Twitter API integrated)"
}
```

**Side effects**:
- Remove from `blocked` array
- Add to `active` array
- Set `current_work_item` to this ID
- Resume work from where it left off (read `todos.md`)

---

## Workspace Boundaries (What Lives Where)

### ✅ **INSIDE `.workspace/WI-XXX/`** (Ephemeral, deleted after COMPLETE)

**Allowed**:
- `README.md` (work item overview)
- `todos.md` (progress checklist)
- `pm/FR-001-draft.md` (artifacts IN PROGRESS)
- `architect/DD-001-draft.md`
- `developer/sentiment_analyzer/` (LEGO docs + code IN PROGRESS)
- `tester/TP-001-draft.md`
- `writer/user_guide_draft.md`
- `reviews/FR-001_reviews.md` (approval tracking)
- **Any temporary scripts, experiments, notes for this work item**

**Purpose**: All work-in-progress until approved and promoted.

---

### ❌ **OUTSIDE `.workspace/`** (Permanent, never deleted)

**NOT Allowed in Root**:
- ❌ `work_completion_summary.md` (should be in workspace or not exist)
- ❌ `temp_script.sh` (should be in workspace)
- ❌ `notes.txt` (should be in workspace)
- ❌ `scratch.md` (should be in workspace)

**Exception**: **Only these permanent files in root**:
- ✅ `app_intent.md` (user edits)
- ✅ `AGENTS.md` (router)
- ✅ `CHANGELOG.md` (auto-updated)
- ✅ `APP_ORCHESTRATION.md` (decision log - **high-level only**, no work item details)
- ✅ `.meta-version`
- ✅ `.gitignore`

**All work item details stay in `.workspace/WI-XXX/` until promoted to permanent locations** (`specs/`, `legos/`, `docs/`).

---

## APP_ORCHESTRATION.md (Decision Log)

**Purpose**: High-level architectural decisions, NOT work item tracking

**Contains**:
- ✅ "Why we chose LEGO architecture"
- ✅ "Trade-off: Simplicity vs Performance"
- ✅ "Decision: Use PostgreSQL over MongoDB (rationale: ...)"
- ❌ NOT: "WI-001 created on 2025-12-06"
- ❌ NOT: "PM reviewed FR-001, approved"

**Updated**:
- When major architectural decision made
- When trade-off resolved
- When design pattern chosen
- **NOT** for routine work item state changes

---

## Cleanup Rules

### **After WI-001 COMPLETE**:

**Delete**:
```bash
rm -rf .workspace/WI-001/  # ALL temporary work
```

**Preserve** (in git history):
```bash
git log -p  # Can see all decisions from deleted workspace
git show HEAD:.workspace/WI-001/reviews/FR-001_reviews.md  # Historic review
```

**Promote** (permanent locations):
```bash
specs/features/FR-001.md         # Immutable spec
specs/design/DD-001.md           # Immutable design
specs/test_plans/TP-001.md       # Immutable test plan
legos/sentiment_analyzer/        # Self-documenting LEGO
docs/user/user-guide.md          # Updated user docs
```

### **No Clutter in Root**:

Orchestrator **never creates** in root:
- ❌ Summary files
- ❌ Temp scripts
- ❌ Work logs
- ❌ Notes

**Only updates existing files**:
- ✅ `CHANGELOG.md` (append new version entry)
- ✅ `APP_ORCHESTRATION.md` (append high-level decision)

---

## Example: Complete Work Item Flow

```
1. User: "Add sentiment analysis"

2. Orchestrator:
   - Creates WI-001 in tracker.json (state: BACKLOG)
   - Shows: "Created WI-001, starting work..."

3. Orchestrator:
   - Transitions: BACKLOG → ACTIVE
   - Creates .workspace/WI-001/
   - Creates .workspace/WI-001/README.md, todos.md

4. PM role:
   - Writes .workspace/WI-001/pm/FR-001-draft.md
   - Marks todo: [x] PM: Write FR-001

5. Multi-role review (Architect, Developer, Tester, Writer):
   - Each writes to .workspace/WI-001/reviews/FR-001_reviews.md
   - All approve: "APPROVED ✅"

6. Orchestrator:
   - Sees all approved
   - Marks todo: [x] Orchestrator: Approve FR-001

7. Architect role:
   - Writes .workspace/WI-001/architect/DD-001-draft.md
   - Review cycle repeats...

8. Developer role:
   - Creates .workspace/WI-001/developer/sentiment_analyzer/
   - Writes README.md, interface.md, workflows.md, src/
   - Review cycle repeats...

9. Tester role:
   - Writes .workspace/WI-001/tester/TP-001-draft.md
   - Writes tests in .workspace/WI-001/developer/sentiment_analyzer/src/tests/
   - Review cycle repeats...

10. Writer role:
    - Writes .workspace/WI-001/writer/user_guide_draft.md
    - Review cycle repeats...

11. Orchestrator:
    - All artifacts complete, all approved
    - Transitions: ACTIVE → IN_REVIEW → APPROVED

12. Orchestrator:
    - Promotes:
      - .workspace/WI-001/pm/FR-001-draft.md → specs/features/FR-001.md (chmod 444)
      - .workspace/WI-001/architect/DD-001-draft.md → specs/design/DD-001.md (chmod 444)
      - .workspace/WI-001/tester/TP-001-draft.md → specs/test_plans/TP-001.md (chmod 444)
      - .workspace/WI-001/developer/sentiment_analyzer/ → legos/sentiment_analyzer/
      - .workspace/WI-001/writer/user_guide_draft.md → docs/user/user-guide.md (merge)
    - Git commit (atomic)
    - Deletes .workspace/WI-001/
    - Transitions: APPROVED → COMPLETE
    - Updates CHANGELOG.md: "Added sentiment analysis feature (WI-001)"

13. Orchestrator:
    - Shows: "WI-001 complete! 🎉"
    - Next: Check backlog for WI-002
```

**Total files in root after WI-001**: ZERO new clutter (all promoted to proper locations or deleted)

---

## Summary

**Work Item Creation**:
- ✅ Orchestrator creates (automated)
- ❌ User never edits tracker.json directly

**State Transitions**:
- ✅ App Orchestrator only (automated based on conditions)
- ❌ User cannot manually change states

**Workspace Boundaries**:
- ✅ All WIP in `.workspace/WI-XXX/` (temporary)
- ✅ Promoted to permanent locations after approval
- ❌ NO temp files/summaries/scripts in root

**tracker.json**:
- ✅ Survives workspace deletion (permanent log)
- ✅ Tracks all work items (past, present, future)
- ✅ Full audit trail (state transitions with timestamps)

**Clean Repository**:
- ✅ Only permanent, well-organized files in root
- ✅ All temporary work contained in `.workspace/`
- ✅ Git history preserves all decisions
- ✅ No clutter, no pollution