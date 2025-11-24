#!/bin/bash
# Codex CLI Agent Runtime Adapter
# Implements the standard agent runtime interface for OpenAI Codex CLI

set -euo pipefail

COMMAND="${1:-}"
shift || true

# Load runtime config
RUNTIME_CONFIG="agent_runtime.json"
SESSION_DIR="sessions"
MAX_RETRIES=3

# Logging helper
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

# Create session directory if needed
mkdir -p "$SESSION_DIR"

case "$COMMAND" in
    spawn)
        BRIEF_FILE="${1:-}"
        STATE_FILE="${2:-}"
        PROMPT="${3:-}"
        
        if [[ -z "$BRIEF_FILE" ]] || [[ -z "$STATE_FILE" ]] || [[ -z "$PROMPT" ]]; then
            log "ERROR: spawn requires brief_file, state_file, and prompt"
            exit 1
        fi
        
        # Generate unique session ID
        SESSION_ID="session_$(date +%s)_$$"
        SESSION_PATH="$SESSION_DIR/$SESSION_ID"
        mkdir -p "$SESSION_PATH"
        
        # Copy brief to session directory
        cp "$BRIEF_FILE" "$SESSION_PATH/brief.md"
        
        # Initialize state if not exists
        if [[ ! -f "$STATE_FILE" ]]; then
            echo '{"status": "pending", "failure_count": 0}' > "$STATE_FILE"
        fi
        
        # Link state file to session
        ln -sf "$(realpath "$STATE_FILE")" "$SESSION_PATH/state.json"
        
        log "Spawning Codex session: $SESSION_ID"
        log "Brief: $BRIEF_FILE"
        log "State: $STATE_FILE"
        log "Prompt: $PROMPT"
        
        # Execute Codex CLI
        # NOTE: This is a placeholder. Actual Codex CLI invocation depends on the tool's API.
        # For now, we simulate by creating session metadata.
        {
            echo "SESSION_ID=$SESSION_ID"
            echo "BRIEF=$BRIEF_FILE"
            echo "STATE=$STATE_FILE"
            echo "PROMPT=$PROMPT"
            echo "STATUS=active"
            echo "STARTED=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        } > "$SESSION_PATH/metadata.txt"
        
        # In a real implementation, you would:
        # codex exec -f "$SESSION_PATH/brief.md" --state "$STATE_FILE" "$PROMPT" \
        #     > "$SESSION_PATH/output.log" 2> "$SESSION_PATH/error.log" &
        # CODEX_PID=$!
        # echo "$CODEX_PID" > "$SESSION_PATH/pid"
        
        echo "$SESSION_ID"
        ;;
        
    resume)
        SESSION_ID="${1:-}"
        STATE_FILE="${2:-}"
        RESUME_PROMPT="${3:-}"
        
        if [[ -z "$SESSION_ID" ]] || [[ -z "$STATE_FILE" ]]; then
            log "ERROR: resume requires session_id and state_file"
            exit 1
        fi
        
        SESSION_PATH="$SESSION_DIR/$SESSION_ID"
        
        if [[ ! -d "$SESSION_PATH" ]]; then
            log "ERROR: Session not found: $SESSION_ID"
            exit 1
        fi
        
        log "Resuming Codex session: $SESSION_ID"
        log "Prompt: $RESUME_PROMPT"
        
        # In a real implementation:
        # codex exec resume --last --state "$STATE_FILE" "$RESUME_PROMPT" \
        #     >> "$SESSION_PATH/output.log" 2>> "$SESSION_PATH/error.log"
        
        echo "Session $SESSION_ID resumed"
        ;;
        
    check_status)
        SESSION_ID="${1:-}"
        
        if [[ -z "$SESSION_ID" ]]; then
            log "ERROR: check_status requires session_id"
            exit 1
        fi
        
        SESSION_PATH="$SESSION_DIR/$SESSION_ID"
        
        if [[ ! -d "$SESSION_PATH" ]]; then
            echo "not_found"
            exit 1
        fi
        
        # Check if session has state file
        if [[ -f "$SESSION_PATH/state.json" ]]; then
            STATUS=$(jq -r '.status // "active"' "$SESSION_PATH/state.json")
            echo "$STATUS"
        else
            echo "pending"
        fi
        ;;
        
    *)
        log "ERROR: Unknown command: $COMMAND"
        log "Usage: $0 {spawn|resume|check_status} [args...]"
        exit 1
        ;;
esac
