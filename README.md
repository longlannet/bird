# bird

X/Twitter reading, search, and posting through the `bird` CLI.

## What it does

- read tweets, threads, replies, and timelines
- search X/Twitter and inspect accounts
- check mentions, bookmarks, likes, followers, and following
- post tweets or replies when authenticated

## Install

```bash
bash scripts/install.sh
```

## Validate

```bash
bash scripts/check.sh
```

## Quick commands

```bash
source config.env && bird read <tweet-id-or-url> --json
source config.env && bird search "openclaw" --json
source config.env && bird user-tweets <handle>
source config.env && bird mentions
```

## Notes

- `config.env` is runtime config and should not be committed.
- Run from the skill root so `config.env` is loaded correctly.
- Re-run `scripts/install.sh` if `bird` is missing.
