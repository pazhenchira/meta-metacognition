# Session Isolation & Multi-Agent Architecture

**NOTE**: This document supplements `.meta/AGENTS.md` Section 8 with detailed implementation guidance for true session isolation.

---

## Overview

In Phase 1 (Session Isolation), the Meta-Orchestrator operates as a **pure coordinator**, never implementing LEGOs directly. Instead, it spawns independent agent sessions (via runtime adapters) that work in isolation.

This architecture prevents context explosion and enables true parallelism.

---

## Architecture Diagram

```
┌──────────────────────────────────────────────────────────┐
│          Meta-Orchestrator (Session 0)                   │
│  Role: CTO - Strategy, Coordination, Dependency Management│
└───────────┬──────────────────────────────────────────────┘
            │
            ├──────────────────────────────────────────────┐
            │                                              │
    ┌───────▼────────┐                           ┌────────▼───────┐
    │ LEGO-Orch: Auth│                           │ LEGO-Orch: Data│
    │  (Session 3)   │                           │  (Session 4)   │
    │ Role: Tech Lead│                           │ Role: Tech Lead│
    └───────┬────────┘                           └────────┬───────┘
            │                                              │
      ┌─────┼─────┬─────┬─────┐                     (same pattern)
      │     │     │     │     │
   Design  Test  Doc  Code  Val
  (3.1)  (3.2) (3.3) (3.4) (3.5)
```

---

## Session Brief Template

For each LEGO, the Meta-Orchestrator generates `sessions/session_<lego>_brief.md`:

```markdown
# LEGO-Orchestrator Brief: <LEGO_NAME>

## Role
You are a LEGO-Orchestrator, acting as a Tech Lead responsible for delivering this LEGO component.

## LEGO Definition
- **Name**: <name>
- **Responsibility**: <single responsibility>
- **Inputs**: <inputs>
- **Outputs**: <outputs>
- **Dependencies**: <list of completed LEGOs>
- **Sensitive**: <true/false>
- **Needs Agent**: <true/false>

## Context Files (Read these first)
1. `.meta/principles.md` - Global engineering principles
2. `meta_config.json` - Configuration (R&D mode, flags)
3. `lego_plan.json` - Full LEGO plan (you are: <name>)
4. Dependency artifacts:
   - <list of files from completed dependency LEGOs>

## Your Mission
Execute these substeps with GEN+REVIEW:

### 1. DESIGN
- Define interface contract (inputs/outputs/errors)
- Specify behavior and data flow
- Document assumptions and constraints
- REVIEW for KISS alignment

### 2. TEST AUTHORING
- Write unit tests for all behavior
- Cover edge cases and error conditions
- REVIEW for coverage and clarity

### 3. LEGO DOCUMENTATION
- Create `docs/<lego>_internal.md` (rationale, trade-offs)
- Create `docs/<lego>_public.md` if external-facing
- REVIEW for accuracy

### 4. CODING
- Implement in `src/<lego>.<ext>`
- Follow language idioms and KISS
- REVIEW for clarity and correctness

### 5. VALIDATION
- Run tests: `<test_command>`
- Run lint: `<lint_command>`
- If r_and_d_mode=thorough: evaluation harness
- If sensitive=true: REDTEAM REVIEW

## State Management
Update `lego_state_<lego>.json` after each substep:

```json
{
  "lego_name": "<name>",
  "status": "in-progress" | "done" | "failed",
  "current_substep": "design" | "test_authoring" | "documentation" | "coding" | "validation",
  "completed_substeps": ["design", ...],
  "failure_count": 0,
  "artifacts": ["src/auth.py", ...]
}
```

Mark status as `"done"` when all substeps pass.
Mark status as `"failed"` if any substep fails 3 times.

## Exit Criteria
- All substeps completed
- All tests passing
- State file updated
- Artifacts written to correct locations
```

---

## Meta-Orchestrator Spawn Logic

```python
# Pseudocode for Meta-Orchestrator

def spawn_lego_orchestrator(lego):
    # 1. Load runtime configuration
    runtime_config = load_json("agent_runtime.json")
    runtime_type = runtime_config["runtime"]  # e.g., "codex-cli"
    adapter_path = runtime_config["runtimes"][runtime_type]["adapter"]
    
    # 2. Prepare session brief
    brief_path = f"sessions/session_{lego['name']}_brief.md"
    create_session_brief(lego, brief_path)
    
    # 3. Initialize state file
    state_path = f"lego_state_{lego['name']}.json"
    if not exists(state_path):
        write_json(state_path, {
            "lego_name": lego["name"],
            "status": "pending",
            "failure_count": 0
        })
    
    # 4. Spawn isolated session via runtime adapter
    session_id = run_command(
        f"{adapter_path} spawn {brief_path} {state_path} " +
        f"\"Act as LEGO-Orchestrator for {lego['name']}\""
    )
    
    # 5. Register session
    register_session(session_id, lego["name"], "active")
    
    return session_id
```

---

## Session Registry Structure

`session_registry.json`:

```json
{
  "meta_session_id": "meta_1732400000",
  "sessions": [
    {
      "session_id": "session_1732400123_12345",
      "lego": "auth",
      "status": "active",
      "started": "2025-11-24T10:00:00Z",
      "updated": "2025-11-24T10:15:00Z",
      "current_substep": "coding",
      "failure_count": 0
    },
    {
      "session_id": "session_1732400456_67890",
      "lego": "data_layer",
      "status": "completed",
      "started": "2025-11-24T10:05:00Z",
      "completed": "2025-11-24T10:30:00Z",
      "failure_count": 0
    }
  ],
  "queue": [
    {
      "lego": "api_gateway",
      "waiting_for": ["auth", "data_layer"],
      "priority": 1
    }
  ]
}
```

---

## Dependency Resolution

Before spawning a LEGO-Orchestrator:

1. Check `lego_plan.json` for dependencies
2. For each dependency, verify `lego_state_<dep>.json` shows `"status": "done"`
3. Only spawn if all dependencies are satisfied
4. Copy dependency artifacts to session brief context

---

## Parallelism Control

From `meta_config.json`:

```json
{
  "max_parallel_sessions": 3
}
```

Meta-Orchestrator logic:

```python
def coordinate_sessions():
    active_count = count_sessions_with_status("active")
    
    if active_count < config["max_parallel_sessions"]:
        # Find ready LEGOs (dependencies satisfied)
        ready_legos = get_ready_legos()
        
        for lego in ready_legos[:(config["max_parallel_sessions"] - active_count)]:
            spawn_lego_orchestrator(lego)
```

---

## Benefits

✅ **No context explosion**: Each LEGO-Orchestrator sees only its brief + minimal context
✅ **True parallelism**: Build 3+ LEGOs simultaneously
✅ **Cost efficient**: Smaller contexts = lower token usage
✅ **Fault isolation**: One LEGO failure doesn't affect others
✅ **Scalability**: Can build apps with 50+ LEGOs
✅ **Realistic workflow**: Mimics real engineering teams

---

## Integration with .meta/AGENTS.md

This document **extends** .meta/AGENTS.md Section 8. When implementing:

1. Follow .meta/AGENTS.md for overall pipeline flow
2. Use this document for session isolation implementation details
3. Refer to `runtime_adapters/adapter_interface.md` for tool-specific spawning
