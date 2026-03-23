# Playbooks

Structured checklists for common workflows. Load playbooks into your TODO tracker.

## Available Playbooks

| Playbook | When to Use |
|----------|-------------|
| `new-feature.md` | Adding new functionality |
| `bug-fix.md` | Fixing defects |
| `enhancement.md` | Improving existing features |
| `deliberation.md` | Significant decisions requiring multiple perspectives |
| `reorganization.md` | Component restructuring before parallelization or after antipattern detection |

## Usage

1. Identify task type
2. Read playbook: `view('.meta/playbooks/<playbook>.md')`
3. Load checklist into `update_todo()`
4. Check off items as you complete
5. **Never report done until all items checked**
