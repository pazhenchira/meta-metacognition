import shutil
import subprocess
import sys


def build_command() -> list[str]:
    if shutil.which("codex"):
        return ["codex", "mcp-server"]
    return ["npx", "-y", "codex", "mcp"]


def main() -> int:
    cmd = build_command()
    print(f"Starting Codex MCP server: {' '.join(cmd)}", flush=True)

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
