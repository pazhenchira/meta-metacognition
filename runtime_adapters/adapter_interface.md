# Agent Runtime Adapter Interface

This document defines the **standard interface** that all agent runtime adapters must implement.

The meta-orchestrator uses these adapters to spawn and manage agent sessions in a tool-agnostic way.

---

## Purpose

- **Abstraction**: Decouple the meta-orchestrator from specific tools (Codex CLI, Copilot, Claude, etc.)
- **Extensibility**: Add new agent runtimes without modifying core orchestration logic
- **Portability**: Switch between tools based on availability, cost, or capability

---

## Adapter Contract

Each adapter is a **shell script** (or executable) that implements these commands:

### 1. `spawn`

**Purpose**: Start a new agent session

**Input**:
- `$1` - Brief file path (markdown file describing the task)
- `$2` - State file path (JSON file for session state persistence)
- `$3` - Initial prompt (string)

**Output**:
- Stdout: Session ID (string)
- Exit code: 0 on success, non-zero on failure

**Example**:
```bash
./codex_cli_adapter.sh spawn session_auth_brief.md lego_state_auth.json "Act as LEGO-Orchestrator for Auth"
# Output: session_12345
```

---

### 2. `resume`

**Purpose**: Resume an existing agent session

**Input**:
- `$1` - Session ID (from previous spawn)
- `$2` - State file path
- `$3` - Resume prompt (string)

**Output**:
- Stdout: Success/failure message
- Exit code: 0 on success, non-zero on failure

**Example**:
```bash
./codex_cli_adapter.sh resume session_12345 lego_state_auth.json "Continue with validation substep"
```

---

### 3. `check_status`

**Purpose**: Check if a session is active, completed, or failed

**Input**:
- `$1` - Session ID

**Output**:
- Stdout: One of `pending`, `active`, `completed`, `failed`
- Exit code: 0 on success, non-zero if session not found

**Example**:
```bash
./codex_cli_adapter.sh check_status session_12345
# Output: active
```

---

### 4. `capabilities`

**Purpose**: Report runtime capabilities (used to decide sub-agent strategy)

**Input**: none

**Output**:
- Stdout: JSON string
- Exit code: 0 on success

**Example Output**:
```json
{
  "supports_subagents": true,
  "subagent_style": "mcp",
  "supports_agent_profiles": true,
  "supports_handoffs": true,
  "supports_parallel_sessions": true,
  "supports_resume": true
}
```

---

### 5. `spawn_subagent` (optional)

**Purpose**: Start a nested sub-agent (role-specific) when the runtime supports subagents

**Input**:
- `$1` - Role name (e.g., `architect`, `tester`)
- `$2` - Brief file path
- `$3` - State file path
- `$4` - Initial prompt

**Output**:
- Stdout: Sub-agent session ID
- Exit code: 0 on success, non-zero on failure

**Example**:
```bash
./codex_cli_adapter.sh spawn_subagent architect session_arch_brief.md lego_state_arch.json "Review design for KISS"
# Output: subagent_98765
```

---

### 6. `start_mcp_server` (optional)

**Purpose**: Start an MCP server when required by the runtime (e.g., Codex CLI MCP)

**Input**:
- `$1` - Server command (string) or config file path

**Output**:
- Stdout: PID or session identifier
- Exit code: 0 on success

---

## File-Based Communication

Adapters communicate with sessions via **files only**:

### Session Brief (Input)
`session_<lego>_brief.md`:
```markdown
# LEGO: Authentication
## Responsibility
Handle user authentication and session management.
## Dependencies
- Database LEGO (completed)
## Success Criteria
- Tests pass
- Review complete
```

### Session State (Output)
`lego_state_<lego>.json`:
```json
{
  "lego_name": "auth",
  "status": "in-progress",
  "current_substep": "coding",
  "completed_substeps": ["design", "tests"],
  "failure_count": 0,
  "artifacts": ["src/auth.py", "tests/test_auth.py"]
}
```

---

## Adapter Implementation Guidelines

1. **Idempotency**: Calling `spawn` with the same brief multiple times should be safe
2. **State Persistence**: Always read/write state files for resumability
3. **Error Handling**: Return meaningful error messages via stderr
4. **Timeout**: Respect `timeout_minutes` from `agent_runtime.json`
5. **Cleanup**: Optionally clean up temp files based on config
6. **Logging**: Write logs to `sessions/<session_id>/adapter.log`

---

**Sub-agent Notes**:
- Some runtimes (e.g., Claude Code) use **file-based sub-agent definitions** under `.claude/agents/`.
- Some runtimes (e.g., Copilot) use **agent profiles** in `.github/agents/`.
- Some runtimes are **UI-first** (e.g., Cursor) and may not expose stable CLI sub-agent commands.

---

## Supported Runtimes

See `agent_runtime.json` for currently supported runtimes:
- `codex-cli-mcp` - OpenAI Codex CLI with MCP sub-agents
- `codex-cli` - OpenAI Codex CLI
- `github-copilot` - GitHub Copilot Chat (agent profiles)
- `claude-code-subagents` - Anthropic Claude Code subagents
- `cursor-multi-agent` - Cursor multi-agent

To add a new runtime:
1. Create an adapter script implementing this interface
2. Add runtime config to `agent_runtime.json`
3. Test with a simple LEGO
