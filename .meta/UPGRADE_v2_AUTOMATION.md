# v2.0 Upgrade Automation Steps

**For use by `.meta/AGENTS.md` when upgrading apps from v1.x to v2.0**

This file contains the complete automated migration logic executed by the orchestrator.

---

## Pre-Upgrade Validation

```bash
# Check git status is clean
if [ -n "$(git status --porcelain)" ]; then
  echo "ERROR: Uncommitted changes detected. Commit or stash first."
  exit 1
fi

# Verify backup tag exists
if ! git tag -l | grep -q "v1-backup\|backup"; then
  echo "CRITICAL: No backup tag found!"
  echo "Create backup: git tag v1-backup"
  echo "Then retry upgrade."
  exit 1
fi

echo "✅ Pre-upgrade validation passed"
```

---

## Phase 1: Create v2.0 Directory Structure

```bash
mkdir -p .workspace
mkdir -p legos
mkdir -p specs/features
mkdir -p specs/design
mkdir -p specs/test_plans
mkdir -p docs/user
mkdir -p docs/dev
mkdir -p external_input

echo "✅ Directory structure created"
```

Create `APP_VERSION` if missing:
```bash
if [ ! -f APP_VERSION ]; then
  echo "0.1.0" > APP_VERSION
fi
```

---

## Phase 2: Initialize State Files

**`.workspace/tracker.json`**:
```json
{
  "work_items": [],
  "backlog": [],
  "active": [],
  "current_work_item": null,
  "version": "2.0.0",
  "created": "2025-12-06T03:00:00Z"
}
```

**`legos/_manifest.json`** (populated in Phase 4)

**`external_input/README.md`**:
```markdown
# External Input

Place user-provided context files here (PDFs, API specs, etc.).

You manage the lifecycle of these files - delete when no longer needed.
```

---

## Phase 3: Migrate Source Code to LEGOs

For each source module (e.g., `config_validator.py`):

### 3.1: Create LEGO Folder

```bash
mkdir -p legos/config_validator/src/tests
```

### 3.2: Generate `README.md`

Analyze code to extract:
- Purpose & Responsibility (from docstring)
- Dependencies (from imports)
- Implementation Strategy (from code structure)
- Error Handling (from try/except)
- Testing Strategy (from existing tests)

**Template**:
```markdown
# {LEGO_NAME} LEGO

## Purpose & Responsibility
{EXTRACTED_FROM_DOCSTRING}

## Dependencies
{ANALYZED_IMPORTS}

## Interface Contract
See `interface.md` for detailed API specification.

## Implementation Strategy
{EXTRACTED_FROM_CODE_STRUCTURE}

## Error Handling
{EXTRACTED_FROM_TRY_EXCEPT}

## Testing Strategy
{EXTRACTED_FROM_TESTS}

## Usage Examples
```python
{EXTRACTED_FROM_CODE_OR_TESTS}
```

## Performance Characteristics
{ESTIMATED_FROM_CODE_ANALYSIS}
```

### 3.3: Generate `interface.md`

Extract from function signatures and docstrings:

**Template**:
```python
def {function_name}({args_with_types}) -> {return_type}:
    """
    {DOCSTRING}
    
    Args:
        {EXTRACTED_FROM_DOCSTRING}
    
    Returns:
        {EXTRACTED_FROM_DOCSTRING}
    
    Raises:
        {EXTRACTED_FROM_DOCSTRING}
    
    Side Effects:
        {ANALYZED_FROM_CODE: file I/O, network, state mutations}
    
    Thread Safety: {ANALYZED: read-only or mutating}
    Performance: {ESTIMATED: O(n) complexity}
    """
```

### 3.4: Generate `workflows.md`

Analyze imports across codebase:

**Template**:
```markdown
## Callers
{MODULES_THAT_IMPORT_THIS}

## Callees
{MODULES_THIS_IMPORTS}

## Normal Flow
{TYPICAL_CALL_SEQUENCE}

## Error Flow
{ERROR_PROPAGATION}

## Data Flow
{DATA_MOVEMENT_BETWEEN_LEGOS}
```

### 3.5: Move Files

```bash
# Move source
mv src/config_validator.py legos/config_validator/src/

# Move tests
mv tests/unit/test_config_validator.py legos/config_validator/src/tests/
```

---

## Phase 4: Populate LEGO Manifest

Analyze all LEGOs to build dependency graph:

```json
{
  "version": "2.0.0",
  "legos": [
    {
      "name": "config_validator",
      "version": "1.0.0",
      "dependencies": [],
      "interface_hash": "sha256:{COMPUTED_FROM_INTERFACE_MD}",
      "breaking_changes": []
    },
    {
      "name": "signal_generator",
      "version": "1.0.0",
      "dependencies": ["market_data_fetcher", "greeks_calculator"],
      "interface_hash": "sha256:{COMPUTED}",
      "breaking_changes": []
    }
  ],
  "dependency_graph": {
    "signal_generator": ["market_data_fetcher", "greeks_calculator"],
    "market_data_fetcher": [],
    "greeks_calculator": [],
    "config_validator": []
  }
}
```

---

## Phase 5: Separate Documentation

### 5.1: Generate `docs/README.md`

```markdown
# {APP_NAME} Documentation

## For Users
See `user/` folder for:
- Getting started guide
- User manual
- API reference
- Troubleshooting
- FAQ

## For Developers
See `dev/` folder for:
- Architecture overview
- Design decisions
- Contributing guide
- Testing strategy
- Deployment notes
```

### 5.2: Generate/Move User Docs

```bash
# Extract from README quickstart
# → docs/user/getting-started.md

# Move existing
mv docs/user_guide.md docs/user/user-guide.md
mv docs/api_reference.md docs/user/api-reference.md

# Generate from docstrings (using pdoc or similar)
# → docs/user/api-reference.md

# Extract troubleshooting from README
# → docs/user/troubleshooting.md

# Generate FAQ from comments/issues
# → docs/user/faq.md
```

### 5.3: Generate/Move Dev Docs

```bash
# Generate from LEGO dependency graph
# → docs/dev/architecture.md

# Extract design decisions from comments
# → docs/dev/design-decisions.md

# Template
# → docs/dev/contributing.md

# Extract from test patterns
# → docs/dev/testing-strategy.md

# Extract from existing deployment docs
# → docs/dev/deployment.md
```

---

## Phase 6: Update Import Paths

Scan all files and update imports:

```bash
# Find old imports
grep -r "from src\." .

# Update to new structure
# Old: from src.config_validator import validate_config
# New: from legos.config_validator.src.config_validator import validate_config

# Update test imports
# Old: from src.signal_generator import generate_signals
# New: from legos.signal_generator.src.signal_generator import generate_signals
```

**Update PYTHONPATH** (if needed):
```bash
export PYTHONPATH="${PYTHONPATH}:legos/config_validator/src:legos/signal_generator/src"
```

---

## Phase 7: Commit Migration

```bash
git add -A
git commit -m "Upgrade to meta-orchestrator v2.0.0 - AUTOMATED MIGRATION

Folders created:
- .workspace/ (work item tracking)
- legos/ (self-documenting LEGO blocks)
- specs/ (immutable specifications)
- docs/user/ + docs/dev/ (separated documentation)
- external_input/ (user-provided context)

State files initialized:
- .workspace/tracker.json (work item log)
- legos/_manifest.json (LEGO registry with dependencies)

Source code migrated:
- src/*.py → legos/*/src/*.py
- LEGO documentation generated (README, interface, workflows)
- Tests co-located: legos/*/src/tests/

Documentation separated:
- docs/user/ (customer-facing: getting-started, user-guide, API reference)
- docs/dev/ (developer-facing: architecture, design-decisions, testing)

Import paths updated for new structure

Version: .meta-version → 2.0.0

Rollback: git reset --hard v1-backup
"
```

---

## Phase 8: Validation

```bash
# Check folders exist
test -d .workspace || echo "ERROR: .workspace/ missing"
test -d legos || echo "ERROR: legos/ missing"
test -d specs || echo "ERROR: specs/ missing"
test -d docs/user || echo "ERROR: docs/user/ missing"
test -d docs/dev || echo "ERROR: docs/dev/ missing"

# Verify state files
test -f .workspace/tracker.json || echo "ERROR: tracker.json missing"
test -f legos/_manifest.json || echo "ERROR: _manifest.json missing"
python -m json.tool .workspace/tracker.json > /dev/null || echo "ERROR: Invalid JSON in tracker.json"
python -m json.tool legos/_manifest.json > /dev/null || echo "ERROR: Invalid JSON in _manifest.json"

# Verify each LEGO has docs
for lego in legos/*/; do
    test -f "$lego/README.md" || echo "ERROR: Missing README: $lego"
    test -f "$lego/interface.md" || echo "ERROR: Missing interface: $lego"
    test -f "$lego/workflows.md" || echo "ERROR: Missing workflows: $lego"
done

# Check for old import patterns
if grep -r "from src\." . --exclude-dir=.git; then
    echo "WARNING: Old import patterns still exist"
fi

# Run tests
pytest || npm test || make test || echo "WARNING: Tests failed - may need import path fixes"

# If all validations pass
echo "2.0.0" > .meta-version
echo "2.0.0" > .app/.engine-version

echo "✅ Validation complete"
```

---

## Phase 9: Post-Upgrade Report

```markdown
# Upgrade to v2.0.0 Complete! ✅

## Summary

**Folders Created**:
- .workspace/ (work item tracking)
- legos/ ({COUNT} LEGOs migrated)
- specs/ (immutable specifications)
- docs/user/ (customer-facing docs)
- docs/dev/ (developer-facing docs)
- external_input/ (user context)

**Files Migrated**:
- {COUNT} source files → legos/*/src/
- {COUNT} test files → legos/*/src/tests/
- {COUNT} doc files → docs/user/ + docs/dev/

**Documentation Generated**:
- {COUNT} LEGO READMEs (complete specs)
- {COUNT} interface contracts
- {COUNT} workflow docs

**State Files Initialized**:
- .workspace/tracker.json (empty, ready for work items)
- legos/_manifest.json ({COUNT} LEGOs registered)

## New Workflow

v1.x: Edit code directly, commit

v2.0: Create work item → multi-role approval → promote artifacts → delete workspace

## LEGOs are Self-Documenting

Example: `legos/config_validator/README.md` contains complete spec to regenerate code.

## Rollback (If Needed)

```bash
git reset --hard v1-backup
```

## Next Steps

1. Test app thoroughly
2. Run full test suite
3. Try creating a work item: "Add feature X"
4. Experience multi-role approval workflow
5. Push to production when confident

## Questions?

See UPGRADING.md for detailed documentation.
```

---

## Error Handling

If any phase fails:

1. **Stop immediately** - don't continue to next phase
2. **Show error message** with specific failure point
3. **Instruct user to rollback**: `git reset --hard v1-backup`
4. **Provide debugging info**: Which phase failed, what was expected vs actual
5. **Suggest fixes**: Common issues and solutions
6. **Offer to retry**: After user fixes issue manually

**Never leave app in partially migrated state - all-or-nothing upgrade.**

---

## Orchestrator Implementation Notes

When implementing this in `.meta/AGENTS.md`:

1. **Show upgrade plan first**: List all phases, folders to create, files to migrate
2. **Ask for approval**: "Proceed with automated upgrade? (y/n)"
3. **Execute phases sequentially**: One phase at a time, validate after each
4. **Provide progress updates**: "Phase 3/9: Migrating source code..."
5. **Halt on errors**: Don't continue if validation fails
6. **Commit atomically**: All changes in single commit (easy rollback)
7. **Validate thoroughly**: Check folders, files, JSON, imports, tests
8. **Report completion**: Show summary of what changed

**Remember**: User already created backup tag (v1-backup) before upgrade started.
