# SPDX-License-Identifier: Apache-2.0

default:
    @just --list

# Lint the JSON and the shell scripts.
check:
    jq empty .claude-plugin/plugin.json .claude-plugin/marketplace.json
    shellcheck bin/* tests/*.sh
    shfmt -d bin/* tests/*.sh

# Validate the plugin and check the skill against valetkey's tools.
test:
    tests/skill-tools.sh
    claude plugin validate .
