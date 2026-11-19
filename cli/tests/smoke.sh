#!/usr/bin/env bash
# AgentX CLI smoke tests. Uses the in-tree CLI and AGENTX_SOURCE so nothing
# is installed into system directories and no GitHub clone is required.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
AGENTX="$ROOT/cli/agentx"
export AGENTX_SOURCE="$ROOT"

if [[ ! -x "$AGENTX" ]]; then
  echo "missing executable $AGENTX" >&2
  exit 1
fi

PASS=0
FAIL=0
WORKDIR=""

cleanup() {
  if [[ -n "$WORKDIR" && -d "$WORKDIR" ]]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/agentx-smoke.XXXXXX")"

assert_ok() {
  local name="$1"
  shift
  local out rc
  set +e
  out="$("$@" 2>&1)"
  rc=$?
  set -e
  if [[ $rc -eq 0 ]]; then
    echo "ok  - $name"
    PASS=$((PASS + 1))
  else
    echo "FAIL - $name (exit $rc)"
    echo "$out" | sed 's/^/      /'
    FAIL=$((FAIL + 1))
  fi
}

assert_fail() {
  local name="$1"
  shift
  local out rc
  set +e
  out="$("$@" 2>&1)"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]]; then
    echo "ok  - $name"
    PASS=$((PASS + 1))
  else
    echo "FAIL - $name (expected non-zero exit)"
    echo "$out" | sed 's/^/      /'
    FAIL=$((FAIL + 1))
  fi
}

assert_contains() {
  local name="$1"
  local needle="$2"
  shift 2
  local out rc
  set +e
  out="$("$@" 2>&1)"
  rc=$?
  set -e
  if [[ $rc -eq 0 && "$out" == *"$needle"* ]]; then
    echo "ok  - $name"
    PASS=$((PASS + 1))
  else
    echo "FAIL - $name (exit $rc, missing: $needle)"
    echo "$out" | sed 's/^/      /'
    FAIL=$((FAIL + 1))
  fi
}

assert_ok "help exits 0" "$AGENTX" help
assert_contains "help lists doctor" "doctor" "$AGENTX" help
assert_contains "version prints 1.0.0" "1.0.0" "$AGENTX" version
assert_contains "list includes cursor" "cursor" "$AGENTX" list
assert_contains "list includes claude-code" "claude-code" "$AGENTX" list
assert_fail "unknown command exits non-zero" "$AGENTX" not-a-command
assert_fail "unknown IDE is rejected" "$AGENTX" doctor not-an-ide
assert_fail "install without an IDE exits non-zero" "$AGENTX" install --dry-run

EMPTY="$WORKDIR/empty"
mkdir -p "$EMPTY"
set +e
empty_out="$("$AGENTX" doctor --target "$EMPTY" 2>&1)"
empty_rc=$?
set -e
if [[ "$empty_out" == *"未检测到任何 IDE 配置"* && "$empty_out" == *"诊断结果"* && $empty_rc -ne 0 ]]; then
  echo "ok  - doctor on an empty directory reports a summary and exits non-zero"
  PASS=$((PASS + 1))
else
  echo "FAIL - doctor on an empty directory reports a summary and exits non-zero (exit $empty_rc)"
  echo "$empty_out" | sed 's/^/      /'
  FAIL=$((FAIL + 1))
fi

TARGET="$WORKDIR/project"
mkdir -p "$TARGET"
assert_contains "install cursor --dry-run mentions the target" "$TARGET" \
  "$AGENTX" install cursor --dry-run --target "$TARGET"
assert_ok "install cursor into a temp project" \
  "$AGENTX" install cursor --target "$TARGET"
assert_ok "doctor cursor on an installed temp project" \
  "$AGENTX" doctor cursor --target "$TARGET"
assert_contains "doctor cursor reports the Cursor checks passed" "主规则文件" \
  "$AGENTX" doctor cursor --target "$TARGET"
assert_contains "doctor names the missing-or-present rule file" ".cursorrules" \
  "$AGENTX" doctor cursor --target "$TARGET"

echo
echo "passed=$PASS failed=$FAIL"
if [[ $FAIL -ne 0 ]]; then
  exit 1
fi
