import asyncio
import shutil

from agents.mcp import MCPServerStdio


async def main() -> None:
    if shutil.which("codex"):
        params = {"command": "codex", "args": ["mcp-server"]}
    else:
        params = {"command": "npx", "args": ["-y", "codex", "mcp"]}

    async with MCPServerStdio(
        name="Codex CLI",
        params=params,
        client_session_timeout_seconds=360000,
    ) as codex_mcp_server:
        print("Codex MCP server started.")
        await codex_mcp_server.wait()


if __name__ == "__main__":
    asyncio.run(main())
