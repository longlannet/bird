---
name: bird
description: X/Twitter CLI for reading, searching, and posting via bird. Use when the user wants to read tweets, search X, inspect threads, mentions, timelines, bookmarks, or post/reply on X/Twitter.
homepage: https://github.com/longlannet/bird
metadata:
  {
    "openclaw":
      {
        "emoji": "🐦",
        "requires":
          {
            "bins": ["bird"],
            "config": ["config.env"],
          },
        "install":
          [
            {
              "id": "node-bird",
              "kind": "node",
              "package": "@steipete/bird",
              "bins": ["bird"],
              "label": "Install bird (node)",
            },
          ],
      },
  }
---

# Bird

Use this skill for X/Twitter tasks through the local `bird` CLI.

## When to use
Use this skill when the user wants to:
- read a tweet or thread
- search X/Twitter
- inspect a user's tweets
- check mentions, bookmarks, likes, followers, or following
- post or reply on X

## Quick start
```bash
bash scripts/install.sh
source config.env && bird read <tweet-id-or-url> --json
source config.env && bird search "openclaw" --json
source config.env && bird mentions
```

## Workflow
1. Confirm authentication is working with `bird check` or `bird whoami`.
2. Run the smallest useful read/search command first.
3. Use `--json` or `--plain` when stable output matters.
4. Post or reply only when the user explicitly wants a write action.

## Notes
- `config.env` is runtime config and should not be committed.
- Run from the skill root so `config.env` is loaded correctly.
- Prefer `--json` for parsing and summarization.
- Re-run `scripts/install.sh` if `bird` is missing.
