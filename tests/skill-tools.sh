#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# Fail when what this repository says about valetkey's tools differs from valetkey.
#
# - The skill and the command may name only tools that valetkey has.
# - The bundle manifest lists exactly valetkey's tools, each with the first sentence of valetkey's
#   description (tools/dump_tools.py).
#
# The tools come from the checkout in $VALETKEY_SRC (default ~/dev/valetkey). With a virtualenv
# in it, the server is asked what it offers (tools/dump_tools.py). Without one, only the names
# are read, from mcp_server.py. Skipped, with a note, when there is no checkout.
# `just sync-tools` rewrites the manifest's tool list from the same source.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
checkout=${VALETKEY_SRC:-$HOME/dev/valetkey}
src=$checkout/src/valetkey/mcp_server.py
python=$checkout/.venv/bin/python

if [ ! -f "$src" ]; then
	echo "skip: $src not found (set VALETKEY_SRC to a valetkey checkout)"
	exit 0
fi

status=0
if [ -x "$python" ]; then
	live=$("$python" "$root/tools/dump_tools.py")
	known=$(printf '%s\n' "$live" | jq -r '.[].name')
else
	live=
	# Tool names are the keys of the DESCRIPTIONS table.
	known=$(sed -n '/^DESCRIPTIONS = {/,/^}/p' "$src" | grep -o '^    "browser_[a-z_]*"' | tr -d ' "')
fi
[ -n "$known" ] || {
	echo "fail: found no tools in $src"
	exit 1
}

names=$(grep -rhoE '\bbrowser_[a-z_]+' "$root/skills" "$root/commands" 2>/dev/null | sort -u || true)
for name in $names; do
	if ! printf '%s\n' "$known" | grep -qx "$name"; then
		echo "fail: $name is not a valetkey tool"
		status=1
	fi
done

listed=$(jq -r '.tools[].name' "$root/mcpb/manifest.json" | sort)
if [ "$listed" != "$(printf '%s\n' "$known" | sort)" ]; then
	echo "fail: mcpb/manifest.json lists other tools than valetkey has"
	status=1
fi

if [ -n "$live" ]; then
	want=$(printf '%s\n' "$live" | jq -S 'sort_by(.name)')
	have=$(jq -S '.tools | sort_by(.name)' "$root/mcpb/manifest.json")
	if [ "$want" != "$have" ]; then
		echo "fail: mcpb/manifest.json descriptions differ from valetkey's first sentences; run: just sync-tools"
		status=1
	fi
fi

[ "$status" -eq 0 ] && echo "ok: tools match valetkey"
exit "$status"
