# Developer Documentation

**Audience**: Developers, architects, and AI agents maintaining this application.

---

## Quick Navigation

### Architecture & Design
- [AGENTS.md](AGENTS.md) - Maintenance orchestrator instructions
- [FINAL_STRUCTURE.md](FINAL_STRUCTURE.md) - v2.0 architecture overview
- [SESSION_DESIGN_QA.md](SESSION_DESIGN_QA.md) - Design decisions and Q&A

### Workflows & Processes
- [WORKFLOW_AUDIT.md](WORKFLOW_AUDIT.md) - Complete workflow walkthrough
- [PROPOSED_WORKFLOWS.md](PROPOSED_WORKFLOWS.md) - Workflow patterns
- [WORK_ITEM_TRACKER.md](WORK_ITEM_TRACKER.md) - Work item lifecycle

### Configuration & Validation
- [CONFIG_VALIDATION.md](CONFIG_VALIDATION.md) - Configuration validation
- [INTUITION.md](INTUITION.md) - Wisdom system overview

### Testing & Deployment
- [TESTING_STRATEGY.md](TESTING_STRATEGY.md) - Testing philosophy
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Deployment instructions
- [SESSION_ISOLATION.md](SESSION_ISOLATION.md) - Multi-agent architecture

### Implementation & Planning
- [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md) - Development roadmap
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [RELEASE_SUMMARY_v2.0.0.md](RELEASE_SUMMARY_v2.0.0.md) - v2.0 release notes

---

## Documentation Standards

All developer documentation follows these standards:

### Structure
- **Purpose**: What problem this doc solves
- **Audience**: Who should read this
- **Context**: When to reference this doc
- **Details**: Deep technical information

### Maintenance
- **Update Frequency**: After significant changes
- **Version Control**: Git tracks all changes
- **Review Process**: Multi-role review for major docs

### Writing Style
- **Concise**: No unnecessary verbosity
- **Concrete**: Real examples, not abstractions
- **Complete**: Cover edge cases and errors
- **Consistent**: Same terminology across all docs


---

## Sponsor Interface (Human Owner)

- The **App Orchestrator is the only role that communicates with the Sponsor**.
- All other roles route questions/decisions through the App Orchestrator.
- Sponsor inputs: intent, constraints, approvals.
- Sponsor outputs: decisions, trade-offs, release notes.
- App/Sponsor-specific guardrails live in the **App/Sponsor Overrides** block in each role file (preserved on upgrade).
---

## Document Types

### Architecture Docs (FINAL_STRUCTURE.md, SESSION_DESIGN_QA.md)
- **Purpose**: Understand system design
- **When to Read**: Onboarding, major refactoring
- **Update Trigger**: Architectural changes

### Workflow Docs (WORKFLOW_AUDIT.md, PROPOSED_WORKFLOWS.md)
- **Purpose**: Understand development process
- **When to Read**: Before starting work items
- **Update Trigger**: Process changes

### Configuration Docs (CONFIG_VALIDATION.md, INTUITION.md)
- **Purpose**: Understand system behavior
- **When to Read**: Debugging, tuning
- **Update Trigger**: New config options

### Operational Docs (DEPLOYMENT_GUIDE.md, TESTING_STRATEGY.md)
- **Purpose**: Deploy and validate
- **When to Read**: Before deployment, CI/CD setup
- **Update Trigger**: Infrastructure changes

---

## For AI Agents

If you're an AI agent maintaining this application:

1. **Read AGENTS.md first** - Your primary instructions
2. **Reference WORKFLOW_AUDIT.md** - Step-by-step workflows
3. **Check WORK_ITEM_TRACKER.md** - Work item state machine
4. **Apply INTUITION.md** - Engineering wisdom

These docs enable you to maintain the application autonomously.

---

## For Human Developers

If you're a human developer:

1. **Start with FINAL_STRUCTURE.md** - Architecture overview
2. **Read WORKFLOW_AUDIT.md** - Development process
3. **Reference TESTING_STRATEGY.md** - Before writing tests
4. **Check CHANGELOG.md** - Version history

These docs help you understand the system without diving into code first.

---

## Document Lifecycle

### Creation
- Created during initial development or major refactoring
- Reviewed by all roles (PM, Designer, Architect, Developer, Tester, Writer)
- Committed to git

### Maintenance
- Updated when architecture/process changes
- Reviewed by affected roles
- Old versions preserved in git history

### Archival
- If doc becomes obsolete, move to `docs/dev/archive/`
- Add deprecation notice explaining replacement
- Keep in git history

---

## Related Documentation

- **User Documentation**: See `docs/user/` for customer-facing docs
- **Engine Documentation**: See root `.meta/` for meta-orchestrator engine
- **Specifications**: See `specs/` for immutable feature/design/test specs
- **LEGO Documentation**: See `legos/*/README.md` for component docs

---

## Contributing

When adding new developer documentation:

1. Follow the structure above (Purpose, Audience, Context, Details)
2. Add entry to this README.md
3. Reference from other docs if relevant
4. Get multi-role review
5. Commit with descriptive message

---

**Last Updated**: 2025-12-24  
**Maintainer**: Meta-Orchestrator v2.0.28
