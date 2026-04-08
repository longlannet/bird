#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_FILE="$BASE_DIR/config.env"
GLOBAL_NPM_PREFIX="${GLOBAL_NPM_PREFIX:-/root/.openclaw/workspace/.npm-global}"
GLOBAL_BIRD_BIN="$GLOBAL_NPM_PREFIX/bin/bird"

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

install_global_bird() {
  command -v npm >/dev/null 2>&1 || fail "npm not found, cannot auto-install bird"
  mkdir -p "$GLOBAL_NPM_PREFIX"
  log "bird not found, installing shared bird into: $GLOBAL_NPM_PREFIX"
  npm install -g @steipete/bird --prefix "$GLOBAL_NPM_PREFIX"
  [ -x "$GLOBAL_BIRD_BIN" ] || fail "shared bird install failed: $GLOBAL_BIRD_BIN not found"
  printf '%s\n' "$GLOBAL_BIRD_BIN"
}

log "base dir: $BASE_DIR"
BIRD_BIN="$(resolve_bird || true)"
if [ -z "$BIRD_BIN" ]; then
  BIRD_BIN="$(install_global_bird)"
fi
[ -x "$BIRD_BIN" ] || fail "bird unavailable even after install attempt"
log "bird bin: $BIRD_BIN"
log "shared bird prefix: $GLOBAL_NPM_PREFIX"

[ -f "$CONFIG_FILE" ] || fail "runtime config not found: $CONFIG_FILE"
log "runtime config: OK"

log "running smoke test"
(
  cd "$BASE_DIR"
  set -a
  source "$CONFIG_FILE"
  set +a
  "$BIRD_BIN" check >/tmp/bird-skill-smoke.txt
) || fail "smoke test failed"
log "smoke test: OK"

log "install complete"
