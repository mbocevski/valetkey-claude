---
description: Show the open valetkey browser sessions and the sites that are set up
allowed-tools: Bash(valetkey status --json), Bash(valetkey sites --json)
---

<!-- SPDX-License-Identifier: Apache-2.0 -->

Open sessions and login windows (JSON; login links are left out on purpose):

!`valetkey status --json`

Sites that are set up:

!`valetkey sites --json`

Summarise this for the user in a few lines: which sessions are open and since when, and each site
with its start host and whether it has a saved login. Run no other command. If a command above
failed, say what it printed.
