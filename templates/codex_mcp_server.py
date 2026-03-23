import argparse
import shutil
import subprocess
import sys


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--role", default="", help="Optional role label for logging")
    return parser.parse_args()


def build_command() -> list[str]:
    if shutil.which("codex"):
        return ["codex", "mcp-server"]
    return ["npx", "-y", "codex", "mcp"]


def main() -> int:
    args = parse_args()
    cmd = build_command()
    role_label = f" [{args.role}]" if args.role else ""
    print(f"Starting Codex MCP server{role_label}: {' '.join(cmd)}", flush=True)

    proc = None
    try:
        proc = subprocess.Popen(cmd)
        proc.wait()
        return proc.returncode or 0
    except FileNotFoundError:
        print(
            "ERROR: Unable to start Codex MCP server. Install 'codex' or ensure 'npx' is available.",
            file=sys.stderr,
        )
        return 1
    except KeyboardInterrupt:
        if proc and proc.poll() is None:
            proc.terminate()
        return 130


if __name__ == "__main__":
    sys.exit(main())
