#!/usr/bin/env bash
# test-install.sh — Smoke tests for the security-review extension.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXT_ROOT="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TESTS=0
FAILURES=0

assert_file_exists() {
  TESTS=$((TESTS + 1))
  if [ -f "$1" ]; then
    echo -e "  ${GREEN}✓${NC} $2"
  else
    echo -e "  ${RED}✗${NC} $2 — file not found: $1"
    FAILURES=$((FAILURES + 1))
  fi
}

assert_contains() {
  TESTS=$((TESTS + 1))
  if grep -q "$2" "$1" 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} $3"
  else
    echo -e "  ${RED}✗${NC} $3 — pattern not found in $1"
    FAILURES=$((FAILURES + 1))
  fi
}

# --- Test: Repo has required files ---
echo ""
echo "Test: Repository structure is valid"

assert_file_exists "$EXT_ROOT/extension.yml" "extension.yml exists at root"
assert_file_exists "$EXT_ROOT/README.md" "README.md exists at root"
assert_file_exists "$EXT_ROOT/LICENSE" "LICENSE exists at root"
assert_file_exists "$EXT_ROOT/CONTRIBUTING.md" "CONTRIBUTING.md exists at root"
assert_file_exists "$EXT_ROOT/CHANGELOG.md" "CHANGELOG.md exists at root"
assert_file_exists "$EXT_ROOT/config-template.yml" "config-template.yml exists at root"

# --- Test: All command files exist ---
echo ""
echo "Test: All command files exist"

EXPECTED_COMMANDS=(
  "security-review.md"
  "security-review-staged.md"
  "security-review-branch.md"
  "security-review-plan.md"
  "security-review-tasks.md"
  "security-review-followup.md"
  "security-review-apply.md"
  "init.md"
)

for cmd in "${EXPECTED_COMMANDS[@]}"; do
  assert_file_exists "$EXT_ROOT/commands/$cmd" "command file: $cmd"
done

# --- Test: extension.yml references resolve ---
echo ""
echo "Test: extension.yml command files resolve"

while IFS= read -r line; do
  file_ref=$(echo "$line" | sed "s/.*file: *'\{0,1\}\([^']*\)'\{0,1\}/\1/")
  if [ -n "$file_ref" ]; then
    file_ref=$(echo "$file_ref" | tr -d '"' | tr -d "'")
    assert_file_exists "$EXT_ROOT/$file_ref" "extension.yml ref: $file_ref"
  fi
done < <(grep 'file:' "$EXT_ROOT/extension.yml")

# --- Test: Commands are self-contained (no external file references) ---
echo ""
echo "Test: Commands are self-contained (no broken references)"

TESTS=$((TESTS + 1))
if grep -rl "Use the rules from" "$EXT_ROOT/commands/" 2>/dev/null | grep -q .; then
  echo -e "  ${RED}✗${NC} Found commands referencing external rule files"
  FAILURES=$((FAILURES + 1))
else
  echo -e "  ${GREEN}✓${NC} No commands reference external rule files"
fi

# --- Test: Each command has frontmatter ---
echo ""
echo "Test: Each command has YAML frontmatter"

for cmd in "${EXPECTED_COMMANDS[@]}"; do
  assert_contains "$EXT_ROOT/commands/$cmd" "^---" "frontmatter in $cmd"
done

# --- Test: Each command has output format ---
echo ""
echo "Test: Each command defines output format"

for cmd in "${EXPECTED_COMMANDS[@]}"; do
  assert_contains "$EXT_ROOT/commands/$cmd" "Output Format" "output format in $cmd"
done

# --- Summary ---
echo ""
if [ "$FAILURES" -eq 0 ]; then
  echo -e "${GREEN}All $TESTS smoke tests passed.${NC}"
  exit 0
else
  echo -e "${RED}$FAILURES of $TESTS tests failed.${NC}"
  exit 1
fi
