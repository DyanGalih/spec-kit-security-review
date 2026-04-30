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

# --- Test: All prompt files exist ---
echo ""
echo "Test: All prompt files exist"

EXPECTED_PROMPTS=(
  "security-review.prompt.md"
  "security-review-staged.prompt.md"
  "security-review-branch.prompt.md"
  "security-review-plan.prompt.md"
  "security-review-tasks.prompt.md"
  "security-review-followup.prompt.md"
  "security-review-apply.prompt.md"
)

for prompt in "${EXPECTED_PROMPTS[@]}"; do
  assert_file_exists "$EXT_ROOT/prompts/$prompt" "prompt file: $prompt"
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

# --- Test: Prompts are self-contained (no external file references) ---
echo ""
echo "Test: Prompts are self-contained (no broken references)"

TESTS=$((TESTS + 1))
if grep -rl "Use the rules from" "$EXT_ROOT/prompts/" 2>/dev/null | grep -q .; then
  echo -e "  ${RED}✗${NC} Found prompts referencing external rule files"
  FAILURES=$((FAILURES + 1))
else
  echo -e "  ${GREEN}✓${NC} No prompts reference external rule files"
fi

# --- Test: Each prompt has frontmatter ---
echo ""
echo "Test: Each prompt has YAML frontmatter"

for prompt in "${EXPECTED_PROMPTS[@]}"; do
  assert_contains "$EXT_ROOT/prompts/$prompt" "^---" "frontmatter in $prompt"
done

# --- Test: Each prompt has output format ---
echo ""
echo "Test: Each prompt defines output format"

for prompt in "${EXPECTED_PROMPTS[@]}"; do
  assert_contains "$EXT_ROOT/prompts/$prompt" "Output Format" "output format in $prompt"
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
