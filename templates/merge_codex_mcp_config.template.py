#!/usr/bin/env python3
"""Merge app-specific MCP server blocks into ~/.codex/config.toml safely.

Updates only:
- [mcp_servers.{app_slug}__*]
- [profiles.{app_slug}]

All other sections are preserved verbatim.
"""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Iterable


def parse_section_header(line: str) -> str | None:
    stripped = line.strip()
    if stripped.startswith("[["):
        return None
    if stripped.startswith("[") and stripped.endswith("]"):
        return stripped[1:-1].strip()
    return None


def extract_sections(text: str) -> dict[str, str]:
    sections: dict[str, list[str]] = {}
    current: str | None = None
    for line in text.splitlines():
        header = parse_section_header(line)
        if header is not None:
            current = header
            sections.setdefault(current, [])
            sections[current].append(line.rstrip())
            continue
        if current is not None:
            sections[current].append(line.rstrip())
    return {name: "\n".join(lines).rstrip() for name, lines in sections.items()}


def iter_target_sections(sections: dict[str, str]) -> dict[str, str]:
    targets = {}
    for name, block in sections.items():
        if name.startswith("mcp_servers.") or name.startswith("profiles."):
            targets[name] = block
    return targets


def merge_blocks(config_text: str, targets: dict[str, str]) -> str:
    if not config_text.strip():
        merged = "\n\n".join(targets.values()).rstrip()
        return merged + "\n"

    lines = config_text.splitlines()
    output: list[str] = []
    replaced: set[str] = set()
    i = 0
    while i < len(lines):
        header = parse_section_header(lines[i])
        if header is not None and header in targets:
            if header not in replaced:
                output.extend(targets[header].splitlines())
                replaced.add(header)
            i += 1
            while i < len(lines):
                if parse_section_header(lines[i]) is not None:
                    break
                i += 1
            continue
        output.append(lines[i].rstrip())
        i += 1

    missing = [name for name in targets.keys() if name not in replaced]
    if missing:
        if output and output[-1] != "":
            output.append("")
        output.append("# App-specific MCP blocks (merged)")
        for name in missing:
            output.extend(targets[name].splitlines())
            output.append("")

    return "\n".join(output).rstrip() + "\n"


def main(argv: Iterable[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--app-toml",
        default=".app/runtime/codex_mcp_servers.toml",
        help="Path to app MCP servers TOML",
    )
    parser.add_argument(
        "--config",
        default="~/.codex/config.toml",
        help="Path to Codex config",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print merged config to stdout instead of writing",
    )
    parser.add_argument(
        "--backup",
        action="store_true",
        help="Write a .bak copy of the existing config before updating",
    )
    args = parser.parse_args(argv)

    app_toml = Path(args.app_toml).expanduser()
    if not app_toml.exists():
        raise SystemExit(f"App MCP TOML not found: {app_toml}")
    app_text = app_toml.read_text()
    targets = iter_target_sections(extract_sections(app_text))
    if not targets:
        raise SystemExit(f"No MCP sections found in {app_toml}")

    config_path = Path(args.config).expanduser()
    config_text = config_path.read_text() if config_path.exists() else ""

    merged = merge_blocks(config_text, targets)

    if args.dry_run:
        print(merged)
        return 0

    if args.backup and config_path.exists():
        backup_path = config_path.with_suffix(config_path.suffix + ".bak")
        backup_path.write_text(config_text)

    config_path.parent.mkdir(parents=True, exist_ok=True)
    config_path.write_text(merged)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
