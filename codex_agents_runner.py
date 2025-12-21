import argparse
import asyncio
import os
import shutil

from dotenv import load_dotenv

from agents import Agent, Runner, set_default_openai_api
from agents.mcp import MCPServerStdio


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--role", required=True)
    parser.add_argument("--brief", required=True)
    parser.add_argument("--state", required=True)
    parser.add_argument("--prompt", default="")
    return parser.parse_args()


async def main() -> None:
    args = parse_args()

    load_dotenv(override=True)
    set_default_openai_api(os.getenv("OPENAI_API_KEY"))

    with open(args.brief, "r", encoding="utf-8") as handle:
        brief = handle.read().strip()

    prompt = args.prompt.strip() or "Execute the role brief."
    instructions = f"{brief}\n\n{prompt}".strip()

    if shutil.which("codex"):
        params = {"command": "codex", "args": ["mcp-server"]}
    else:
        params = {"command": "npx", "args": ["-y", "codex", "mcp"]}

    async with MCPServerStdio(
        name="Codex CLI",
        params=params,
        client_session_timeout_seconds=360000,
    ) as codex_mcp_server:
        agent = Agent(
            name=args.role,
            instructions=instructions,
            mcp_servers=[codex_mcp_server],
        )
        await Runner.run(agent, prompt)


if __name__ == "__main__":
    asyncio.run(main())
