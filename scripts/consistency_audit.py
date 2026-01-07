#!/usr/bin/env python3
"""Automated consistency audit for meta-orchestrator apps.

Exits non-zero if any errors are found. Warnings are printed but do not fail.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class Audit:
    def __init__(self) -> None:
        self.errors: list[str] = []
        self.warnings: list[str] = []

    def error(self, msg: str) -> None:
        self.errors.append(msg)

    def warn(self, msg: str) -> None:
        self.warnings.append(msg)

    def report(self) -> int:
        if self.errors:
            print("\nCONSISTENCY AUDIT: FAIL", file=sys.stderr)
            for msg in self.errors:
                print(f"- ERROR: {msg}", file=sys.stderr)
        if self.warnings:
            print("\nCONSISTENCY AUDIT: WARNINGS")
            for msg in self.warnings:
                print(f"- WARN: {msg}")
        if not self.errors:
            print("CONSISTENCY AUDIT: PASS")
        return 1 if self.errors else 0


def read_text(path: Path, audit: Audit) -> str:
    try:
        return path.read_text()
    except FileNotFoundError:
        audit.error(f"Missing required file: {path.as_posix()}")
        return ""


def detect_duplicate_keys(text: str) -> tuple[dict, set[str]]:
    dupes: set[str] = set()

    def hook(pairs):
        seen = set()
        d = {}
        for k, v in pairs:
            if k in seen:
                dupes.add(k)
            seen.add(k)
            d[k] = v
        return d

    data = json.loads(text, object_pairs_hook=hook)
    return data, dupes


def normalize_app_essence(text: str) -> str:
    lines = text.splitlines()
    # Drop generated mirror note if present
    lines = [line for line in lines if "generated mirror" not in line]
    # Trim leading blank lines
    while lines and not lines[0].strip():
        lines.pop(0)
    # Normalize blank lines directly after the title
    if lines and lines[0].startswith("#"):
        idx = 1
        while idx < len(lines) and not lines[idx].strip():
            idx += 1
        if idx > 2:
            lines = [lines[0], ""] + lines[idx:]
    return "\n".join(lines).strip()


def audit_meta_config(audit: Audit) -> dict | None:
    path = ROOT / "meta_config.json"
    if not path.exists():
        audit.error("meta_config.json missing")
        return None
    text = read_text(path, audit)
    try:
        data, dupes = detect_duplicate_keys(text)
    except Exception as exc:  # pylint: disable=broad-except
        audit.error(f"meta_config.json invalid JSON: {exc}")
        return None

    if dupes:
        audit.error(f"meta_config.json has duplicate keys: {', '.join(sorted(dupes))}")

    if "mcp_tool_timeout_seconds" not in data:
        audit.error("meta_config.json missing mcp_tool_timeout_seconds")
    if "coordination_mode" not in data:
        audit.error("meta_config.json missing coordination_mode")

    return data


def audit_mcp_timeouts(audit: Audit, config: dict) -> None:
    timeout = config.get("mcp_tool_timeout_seconds")
    if timeout is None:
        return

    toml_path = ROOT / ".app/runtime/codex_mcp_servers.toml"
    if not toml_path.exists():
        audit.warn(".app/runtime/codex_mcp_servers.toml missing (MCP timeout consistency not checked)")
        return

    text = read_text(toml_path, audit)
    values = [int(m.group(1)) for m in re.finditer(r"tool_timeout_sec\s*=\s*(\d+)", text)]
    if not values:
        audit.warn("No tool_timeout_sec values found in .app/runtime/codex_mcp_servers.toml")
        return

    mismatched = [v for v in values if v != timeout]
    if mismatched:
        audit.error(
            "MCP timeout mismatch: meta_config.json mcp_tool_timeout_seconds="
            f"{timeout}, toml has {sorted(set(values))}"
        )


def audit_mcp_role_workspaces(audit: Audit) -> None:
    toml_path = ROOT / ".app/runtime/codex_mcp_servers.toml"
    if not toml_path.exists():
        return

    text = read_text(toml_path, audit)
    cwd_values = [m.group(1) for m in re.finditer(r'^\s*cwd\s*=\s*["\\\']([^"\\\']+)["\\\']', text, re.M)]
    if not cwd_values:
        audit.warn("No cwd entries found in .app/runtime/codex_mcp_servers.toml")
        return

    for raw in cwd_values:
        normalized = raw.replace("\\\\", "/")
        if "/.app/runtime/mcp/" not in normalized:
            audit.error(
                "MCP server cwd must point to role workspace under .app/runtime/mcp/: "
                f"{raw}"
            )
            continue

        path = Path(raw)
        if not path.is_absolute():
            path = (ROOT / path).resolve()
        agents_path = path / "AGENTS.md"
        if not agents_path.exists():
            audit.error(f"Missing MCP role AGENTS.md: {agents_path.as_posix()}")


def audit_app_self_contained(audit: Audit) -> None:
    app_dir = ROOT / ".app"
    if not app_dir.exists():
        audit.error(".app/ is missing")
        return

    violations = []
    for path in app_dir.rglob("*.md"):
        text = read_text(path, audit)
        if ".meta/" in text or "../" in text:
            violations.append(path.relative_to(ROOT).as_posix())

    if violations:
        audit.error(".app/ contains engine-relative references (.meta/ or ../): " + ", ".join(violations))


def audit_app_agents(audit: Audit) -> None:
    agents_path = ROOT / ".app/AGENTS.md"
    text = read_text(agents_path, audit)
    is_system = "System Orchestrator" in text
    if is_system:
        required = [
            "coordination/repo_graph.json",
            "coordination/requests/",
            "coordination/events/",
            "coordination/index.json",
            "compatibility_matrix.json",
            "cross_repo_test_plan.md",
            "agent_context.json",
            "orchestrator_state.json",
            "meta_config.json",
            "Documentation Index",
            "Docs-first rule",
            "Subagent enforcement",
            "Identity confirmation",
            "SYSTEM_OVERRIDES_START",
        ]
    else:
        required = [
            "tracker.json",
            "orchestrator_state.json",
            "essence.md",
            "agent_context.json",
            "meta_config.json",
            ".app/roles/",
            "Documentation Index",
            "Docs-first rule",
            "Subagent enforcement",
            "Identity confirmation",
            "APP_OVERRIDES_START",
        ]
    missing = [req for req in required if req not in text]
    if missing:
        audit.error(".app/AGENTS.md missing required references: " + ", ".join(missing))


def audit_agent_context(audit: Audit) -> None:
    path = ROOT / ".app/agent_context.json"
    if not path.exists():
        audit.error(".app/agent_context.json missing")
        return
    text = read_text(path, audit)
    try:
        json.loads(text)
    except Exception as exc:  # pylint: disable=broad-except
        audit.error(f".app/agent_context.json invalid JSON: {exc}")


def audit_essence_mirror(audit: Audit) -> None:
    root_essence = ROOT / "essence.md"
    app_essence = ROOT / ".app/essence.md"
    if not root_essence.exists():
        audit.error("essence.md missing")
        return
    if not app_essence.exists():
        audit.error(".app/essence.md missing")
        return

    root_text = read_text(root_essence, audit).strip()
    app_text = normalize_app_essence(read_text(app_essence, audit))

    if root_text != app_text:
        audit.error(".app/essence.md does not match essence.md (mirror drift)")


def audit_sources_of_truth_docs(audit: Audit) -> None:
    for rel in ["README.md", "docs/user/README.md"]:
        path = ROOT / rel
        if not path.exists():
            audit.error(f"Missing doc: {rel}")
            continue
        text = read_text(path, audit)
        if "Sources of Truth" not in text:
            audit.error(f"Sources of Truth section missing in {rel}")


def audit_workspace_tracker(audit: Audit) -> None:
    tracker = ROOT / ".workspace/tracker.json"
    if not tracker.exists():
        audit.error(".workspace/tracker.json missing")
        return
    try:
        json.loads(tracker.read_text())
    except Exception as exc:  # pylint: disable=broad-except
        audit.error(f".workspace/tracker.json invalid JSON: {exc}")


def audit_orchestrator_state(audit: Audit) -> None:
    state = ROOT / "orchestrator_state.json"
    if not state.exists():
        audit.warn("orchestrator_state.json missing (role lock may not be enforced)")


def main() -> int:
    audit = Audit()

    config = audit_meta_config(audit)
    if config:
        audit_mcp_timeouts(audit, config)
    audit_mcp_role_workspaces(audit)

    audit_app_self_contained(audit)
    audit_app_agents(audit)
    audit_agent_context(audit)
    audit_essence_mirror(audit)
    audit_sources_of_truth_docs(audit)
    audit_workspace_tracker(audit)
    audit_orchestrator_state(audit)

    return audit.report()


if __name__ == "__main__":
    sys.exit(main())
