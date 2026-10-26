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

## License

Apache License 2.0. See [LICENSE](LICENSE).
