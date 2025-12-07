# External Input

**Purpose**: Place user-provided context files here during development.

---

## What Goes Here

Files the user provides to help the orchestrator understand requirements:
- 📄 PDF specifications
- 📄 API documentation (JSON, YAML, OpenAPI specs)
- 📄 Example data files (CSV, JSON)
- 📄 Design mockups (images, Figma exports)
- 📄 Compliance documents (security policies, GDPR requirements)
- 📄 Reference implementations (code from other projects)

---

## Lifecycle Management

**YOU (the user) manage these files**:
- ✅ Add files when starting a work item
- ✅ Reference them in work item description or todos
- ✅ Delete when no longer needed (after work item complete)

**Orchestrator NEVER deletes files from this folder** - only you know when they're no longer needed.

---

## Example Usage

### Scenario: Building Trading App with Specific API

1. User adds: `external_input/alpaca_api_spec.yaml`
2. User says: "Build trading app using Alpaca API (spec in external_input/)"
3. Orchestrator reads spec during PM phase
4. PM references spec in FR-001: "API contract: see external_input/alpaca_api_spec.yaml"
5. Architect references spec in DD-001: "API client must match external_input/ spec"
6. Developer implements to match spec
7. After WI-001 complete, user deletes spec (no longer needed)

---

## Best Practices

**DO**:
- ✅ Use descriptive filenames: `stripe_payment_api_v2.json`
- ✅ Add version numbers if applicable: `user_requirements_v3.pdf`
- ✅ Reference in work item description: "See external_input/design_mockup.png"
- ✅ Clean up after work complete

**DON'T**:
- ❌ Store generated code here (that goes in legos/)
- ❌ Store work-in-progress artifacts (that goes in .workspace/WI-XXX/)
- ❌ Store permanent docs (that goes in docs/ or specs/)
- ❌ Commit secrets or credentials (use environment variables)

---

## Folder Structure

```
external_input/
├── README.md                    # This file
├── api_specs/                   # Optional: organize by type
│   └── payment_gateway_api.yaml
├── designs/
│   └── dashboard_mockup.png
└── requirements/
    └── compliance_checklist.pdf
```

Or flat structure (simpler):
```
external_input/
├── README.md
├── payment_api.yaml
├── dashboard_mockup.png
└── compliance.pdf
```

**Your choice** - organize however makes sense for your project.

---

## Git Policy

**Recommendation**: Add `.gitignore` if these files are large or sensitive:

```
# .gitignore
external_input/*.pdf
external_input/*.png
external_input/secrets/
```

**Or**: Commit them if they're essential for understanding the project.

---

## Summary

- **Purpose**: Temporary reference materials during development
- **Managed By**: You (the user)
- **Lifecycle**: Add when needed, delete when done
- **Orchestrator**: Reads but never deletes

This folder keeps your context files separate from code, docs, and work items.
