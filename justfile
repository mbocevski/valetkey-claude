# SPDX-License-Identifier: Apache-2.0

default:
    @just --list

# Lint the JSON and the shell scripts.
check:
    jq empty .claude-plugin/plugin.json .claude-plugin/marketplace.json
    shellcheck bin/*
    shfmt -d bin/*

# Validate the plugin and the marketplace with Claude Code.
test:
    claude plugin validate .
