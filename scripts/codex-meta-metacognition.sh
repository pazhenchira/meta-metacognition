#!/usr/bin/env bash
set -euo pipefail

CODEX_BIN="${CODEX_BIN:-codex}"
APP_PROFILE="meta-metacognition"

MCP_FLAGS=(
  -c "mcp_servers.meta-metacognition__essence_analyst.enabled=true"
  -c "mcp_servers.meta-metacognition__product_manager.enabled=true"
  -c "mcp_servers.meta-metacognition__architect.enabled=true"
  -c "mcp_servers.meta-metacognition__developer.enabled=true"
  -c "mcp_servers.meta-metacognition__tester.enabled=true"
  -c "mcp_servers.meta-metacognition__tech_writer.enabled=true"
  -c "mcp_servers.meta-metacognition__operations.enabled=true"
  -c "mcp_servers.meta-metacognition__monetization_strategist.enabled=true"
  -c "mcp_servers.meta-metacognition__growth_marketer.enabled=true"
  -c "mcp_servers.meta-metacognition__evangelist.enabled=true"
)

exec "$CODEX_BIN" --profile "$APP_PROFILE" "${MCP_FLAGS[@]}" "$@"
