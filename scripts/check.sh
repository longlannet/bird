#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_FILE="$BASE_DIR/config.env"
GLOBAL_NPM_PREFIX="${GLOBAL_NPM_PREFIX:-/root/.openclaw/workspace/.npm-global}"
GLOBAL_BIRD_BIN="$GLOBAL_NPM_PREFIX/bin/bird"
RUN_SMOKE="${RUN_SMOKE:-1}"

log() { printf '[bird] %s\n' "$*"; }
fail() { printf '[bird] ERROR: %s\n' "$*" >&2; exit 1; }

resolve_bird() {
  if [ -n "${BIRD_BIN:-}" ] && [ -x "${BIRD_BIN}" ]; then
    printf '%s\n' "$BIRD_BIN"
    return 0
  fi
  if command -v bird >/dev/null 2>&1; then
    command -v bird
    return 0
  fi
  for candidate in \
    "$GLOBAL_BIRD_BIN" \
    "/root/.openclaw/workspace/.npm-global/bin/bird"
  do
    if [ -x "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

smoke_test() {
  log "running smoke test"
  (
    cd "$BASE_DIR"
    set -a
    source "$CONFIG_FILE"
    set +a
    "$BIRD_BIN" check >/tmp/bird-skill-check-smoke.txt
  ) || fail "smoke test failed"
  log "smoke test: OK"
}

log "base dir: $BASE_DIR"
[ -f "$CONFIG_FILE" ] || fail "runtime config not found: $CONFIG_FILE"
log "runtime config: OK"
[ -f "$BASE_DIR/SKILL.md" ] || fail "missing SKILL.md"
[ -f "$BASE_DIR/README.md" ] || fail "missing README.md"
[ -f "$BASE_DIR/scripts/install.sh" ] || fail "missing scripts/install.sh"
[ -f "$BASE_DIR/scripts/check.sh" ] || fail "missing scripts/check.sh"

BIRD_BIN="$(resolve_bird || true)"
[ -n "$BIRD_BIN" ] || fail "bird not found. Run install.sh first or export BIRD_BIN"
log "bird: OK ($BIRD_BIN)"
log "shared bird prefix: $GLOBAL_NPM_PREFIX"

if [ "$RUN_SMOKE" = "1" ]; then
  smoke_test
fi

log "check complete"
