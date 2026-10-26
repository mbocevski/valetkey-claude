#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# Fail when a skill or command names a browser_* tool that valetkey does not have.
# The tool names come from valetkey's mcp_server.py: $VALETKEY_SRC, or ~/dev/valetkey.
# Skipped, with a note, when that checkout is not there.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
src=${VALETKEY_SRC:-$HOME/dev/valetkey}/src/valetkey/mcp_server.py

if [ ! -f "$src" ]; then
	echo "skip: $src not found (set VALETKEY_SRC to a valetkey checkout)"
	exit 0
fi

# Tool names are the keys of the DESCRIPTIONS table.
known=$(sed -n '/^DESCRIPTIONS = {/,/^}/p' "$src" | grep -o '^    "browser_[a-z_]*"' | tr -d ' "')
[ -n "$known" ] || {
	echo "fail: found no tools in $src"
	exit 1
}

status=0
names=$(grep -rhoE '\bbrowser_[a-z_]+' "$root/skills" "$root/commands" 2>/dev/null | sort -u || true)
for name in $names; do
	if ! printf '%s\n' "$known" | grep -qx "$name"; then
		echo "fail: $name is not a valetkey tool"
		status=1
	fi
done
[ "$status" -eq 0 ] && echo "ok: every tool named in skills and commands exists"
exit "$status"
