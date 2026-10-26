# valetkey-claude

A [Claude Code](https://code.claude.com) plugin for valetkey,
which gives an agent a web browser that is logged in to one site and can reach only the hosts that
site needs. The plugin connects Claude Code to `valetkey mcp`.

## Install

Install and set up valetkey first, and check it with `valetkey doctor`. The valetkey README has the
steps: an Arch package built from the checkout, or `uv tool install .` elsewhere.

Then add this repository as a marketplace and install the plugin:

```fish
claude plugin marketplace add /path/to/valetkey-claude
claude plugin install valetkey@valetkey-plugins
```

Restart Claude Code. The `valetkey` server and its `browser_*` tools are then available.

The plugin starts valetkey through `bin/valetkey-mcp`. It looks for `valetkey` on `PATH`, then in
`~/.local/bin` and `/usr/bin`, and says how to install it if it finds none.

The plugin adds a skill that tells the agent how to use the browser tools safely, and a
`/valetkey-status` command that shows the open sessions and the sites you have set up. The command
asks for the status as JSON, which leaves out remote login links.

## Claude Desktop

Claude Desktop does not use the plugin. Build the bundle with `just mcpb` (it needs `npx`), then
install `dist/valetkey.mcpb` from Claude Desktop's extension settings. It starts valetkey the same
way the plugin does.

Or add the server to `claude_desktop_config.json` yourself:

```json
{"mcpServers": {"valetkey": {"command": "valetkey", "args": ["mcp"]}}}
```

In that case Claude Desktop needs `valetkey` on its `PATH`, or give the full path as the command.

## License

Apache License 2.0. See [LICENSE](LICENSE).
