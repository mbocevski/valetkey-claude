# SPDX-License-Identifier: Apache-2.0
"""Print the name and first sentence of the description of every tool valetkey offers, as JSON.

Run it with the Python of a valetkey checkout (``.venv/bin/python``): it builds the server and
lists its tools without a daemon, so what it prints comes from what a client is told. The first
sentence is what the bundle manifest shows before install. Clients get the full text from the
server at runtime.
"""

import asyncio
import json
import sys

from valetkey import mcp_server


def first_sentence(text: str) -> str:
    """Return the text up to and including its first full stop followed by a space."""
    end = text.find(". ")
    return text if end < 0 else text[: end + 1]


def main() -> None:
    server = mcp_server.build_server(None)  # no daemon is asked
    tools = asyncio.run(server.list_tools())
    listed = [
        {"name": tool.name, "description": first_sentence(tool.description or "")}
        for tool in tools
    ]
    json.dump(listed, sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
