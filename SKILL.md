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

Core bird installation is upstream at `https://bird.fast/`.
This skill uses a local wrapper install path around the `bird` CLI for OpenClaw workflows.

## Workflow
1. Confirm authentication is working with `bird check` or `bird whoami`.
2. Run the smallest useful read/search command first.
3. Use `--json` or `--plain` when stable output matters.
4. Post or reply only when the user explicitly wants a write action.

## Notes
- Core bird installation is upstream at `https://bird.fast/`; if upstream setup changes, follow upstream.
- `scripts/install.sh` installs or resolves the local `bird` CLI and runs a smoke test, but it does not install Node.js/npm or create fresh auth cookies for you.
- `config.env` is runtime config and should not be committed.
- When migrating to another machine, reinstall `bird` there and copy `config.env` only between machines you control.
- Run from the skill root so `config.env` is loaded correctly.
- Prefer `--json` for parsing and summarization.
- Re-run `scripts/install.sh` if `bird` is missing.

## Install pitfalls
- The npm package is `@steipete/bird`; `@aspect-build/bird` is a different/nonexistent package name and returns npm `E404 Not Found`.
- If `npm: command not found`, install Node.js/npm first, then install Bird. On Debian servers, use NodeSource or distro packages, then run `npm install -g @steipete/bird`.
- `npm warn Unknown global config "--init.module"` is usually a benign npmrc warning; it is not the cause of Bird install failure when the actual error is `E404`.
- If `npm install -g @steipete/bird` succeeds but `bird: command not found`, inspect `npm prefix -g` and add `<prefix>/bin` to `PATH` (common with panel-managed Node under `/www/server/nodejs/...`) or symlink the generated bin into `/usr/local/bin`.
- The `bird.fast` homepage may foreground a private macOS universal tarball release. For Linux VPS installs, use the npm package (`@steipete/bird`) or build from source with Node 24 + pnpm + Bun; do not follow the macOS tarball commands on Debian.
- On headless servers, `bird check` usually cannot find browser cookies. Configure `AUTH_TOKEN` and `CT0`, flags, or `~/.config/bird/config.json5`; treat those cookie values as secrets and never paste them into chat.

See `references/linux-node-path-and-auth.md` for the Linux/VPS diagnosis and fix sequence.
