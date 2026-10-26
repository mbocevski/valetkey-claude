# SPDX-License-Identifier: Apache-2.0

default:
    @just --list

# Lint the JSON and the shell scripts.
check:
    jq empty .claude-plugin/plugin.json .claude-plugin/marketplace.json mcpb/manifest.json
    shellcheck bin/* tests/*.sh
    shfmt -d bin/* tests/*.sh

# Build the Claude Desktop bundle into dist/ and validate it.
mcpb:
    rm -rf dist/mcpb
    mkdir -p dist/mcpb/server
    cp mcpb/manifest.json dist/mcpb/
    cp bin/valetkey-mcp dist/mcpb/server/
    npx --yes @anthropic-ai/mcpb@2.1.2 validate dist/mcpb/manifest.json
    npx --yes @anthropic-ai/mcpb@2.1.2 pack dist/mcpb dist/valetkey.mcpb

# Validate the plugin and check the skill against valetkey's tools.
test:
    tests/skill-tools.sh
    claude plugin validate .
