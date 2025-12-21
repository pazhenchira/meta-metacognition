#!/bin/bash
# Cursor Multi-Agent Runtime Adapter (stub)
# Implements the standard agent runtime interface

set -euo pipefail

COMMAND="${1:-}"
shift || true

SESSION_DIR="sessions"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

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

        SESSION_ID="cursor_$(date +%s)_$$"
        SESSION_PATH="$SESSION_DIR/$SESSION_ID"
        mkdir -p "$SESSION_PATH"

        cp "$BRIEF_FILE" "$SESSION_PATH/brief.md"
        ln -sf "$(realpath "$STATE_FILE")" "$SESSION_PATH/state.json"

        {
            echo "SESSION_ID=$SESSION_ID"
            echo "STATUS=active"
            echo "STARTED=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        } > "$SESSION_PATH/metadata.txt"

        echo "$SESSION_ID"
        ;;

    spawn_subagent)
        ROLE="${1:-}"
        BRIEF_FILE="${2:-}"
        STATE_FILE="${3:-}"
        PROMPT="${4:-}"

        if [[ -z "$ROLE" ]] || [[ -z "$BRIEF_FILE" ]] || [[ -z "$STATE_FILE" ]] || [[ -z "$PROMPT" ]]; then
            log "ERROR: spawn_subagent requires role, brief_file, state_file, and prompt"
            exit 1
        fi

        SESSION_ID="cursor_sub_$(date +%s)_$$"
        SESSION_PATH="$SESSION_DIR/$SESSION_ID"
        mkdir -p "$SESSION_PATH"

        cp "$BRIEF_FILE" "$SESSION_PATH/brief.md"
        ln -sf "$(realpath "$STATE_FILE")" "$SESSION_PATH/state.json"

        {
            echo "SESSION_ID=$SESSION_ID"
            echo "ROLE=$ROLE"
            echo "STATUS=active"
            echo "STARTED=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        } > "$SESSION_PATH/metadata.txt"

        echo "$SESSION_ID"
        ;;

    resume)
        SESSION_ID="${1:-}"
        STATE_FILE="${2:-}"
        RESUME_PROMPT="${3:-}"

        log "Resuming Cursor session: $SESSION_ID"
        echo "Session $SESSION_ID resumed"
        ;;

    capabilities)
        cat << 'JSON'
{"supports_subagents": true, "subagent_style": "cursor-multi-agent", "supports_agent_profiles": true, "supports_handoffs": true, "supports_parallel_sessions": true, "supports_resume": true}
JSON
        ;;

    check_status)
        SESSION_ID="${1:-}"
        SESSION_PATH="$SESSION_DIR/$SESSION_ID"

        if [[ ! -d "$SESSION_PATH" ]]; then
            echo "not_found"
            exit 1
        fi

        if [[ -f "$SESSION_PATH/state.json" ]]; then
            STATUS=$(jq -r '.status // "active"' "$SESSION_PATH/state.json")
            echo "$STATUS"
        else
            echo "pending"
        fi
        ;;

    *)
        log "ERROR: Unknown command: $COMMAND"
        exit 1
        ;;
esac
