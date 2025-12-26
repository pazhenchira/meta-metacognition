#!/usr/bin/env bash
set -euo pipefail

# Auto-generated wrapper to enable MCP servers for a single app profile.
# Allows additional parameters to be passed through to Codex.

APP_SLUG="{APP_SLUG}"
APP_PROFILE="{APP_PROFILE}"
CODEX_BIN="${CODEX_BIN:-codex}"

# MCP enable flags (generated from .app/runtime/codex_mcp_servers.toml)
MCP_FLAGS=(
{MCP_ENABLE_FLAGS}
)

exec "$CODEX_BIN" --profile "$APP_PROFILE" "${MCP_FLAGS[@]}" "$@"
