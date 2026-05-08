#!/usr/bin/env bash
# update-document-headers.sh
# Prepend YAML frontmatter with field summaries to existing security review documents.
# Usage: ./scripts/update-document-headers.sh <file> [<file> ...]
# Example: ./scripts/update-document-headers.sh docs/security-reviews/*.md
#
# The script detects review_type, assessment_date, and risk values from the document body
# and prepends a populated YAML frontmatter block. Documents that already have frontmatter
# are skipped unless --force is passed.

set -euo pipefail

FORCE=0
FILES=()

for arg in "$@"; do
  if [[ "$arg" == "--force" ]]; then
    FORCE=1
  else
    FILES+=("$arg")
  fi
done

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "Usage: $0 [--force] <file> [<file> ...]" >&2
  exit 1
fi

# Extract a value from a line matching a pattern (returns first capture group)
extract() {
  local pattern="$1"
  local file="$2"
  grep -oP "$pattern" "$file" 2>/dev/null | head -1 || echo ""
}

process_file() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    echo "SKIP (not found): $file" >&2
    return
  fi

  # Check if file already has YAML frontmatter
  local first_line
  first_line=$(head -1 "$file")
  if [[ "$first_line" == "---" && "$FORCE" -eq 0 ]]; then
    echo "SKIP (already has frontmatter, use --force to overwrite): $file"
    return
  fi

  echo "Processing: $file"

  # ── Detect review_type from title/content ───────────────────────────────
  local review_type="audit"
  if grep -qi "BRANCH\|pull request\|merge request" "$file" 2>/dev/null; then
    review_type="branch"
  elif grep -qi "STAGED CHANGES\|staged diff\|pre-commit" "$file" 2>/dev/null; then
    review_type="staged"
  elif grep -qi "PLAN REVIEW\|plan artifact\|design artifact" "$file" 2>/dev/null; then
    review_type="plan"
  elif grep -qi "TASK REVIEW\|task list\|task sequencing" "$file" 2>/dev/null; then
    review_type="tasks"
  elif grep -qi "FOLLOW.UP\|follow up\|remediation plan\|technical.debt" "$file" 2>/dev/null; then
    review_type="followup"
  fi

  # ── Detect assessment_date ───────────────────────────────────────────────
  local assessment_date
  assessment_date=$(extract '\*\*Assessment Date:\*\* \K[0-9]{4}-[0-9]{2}-[0-9]{2}' "$file")
  if [[ -z "$assessment_date" ]]; then
    assessment_date=$(extract '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$file")
  fi
  if [[ -z "$assessment_date" ]]; then
    assessment_date=$(date +%Y-%m-%d)
  fi

  # ── Detect codebase_analyzed ─────────────────────────────────────────────
  local codebase
  codebase=$(extract '\*\*Codebase Analyzed:\*\* \K.+' "$file")
  codebase="${codebase:-unknown}"

  # ── Detect overall_risk ──────────────────────────────────────────────────
  local overall_risk="INFORMATIONAL"
  if grep -qi "CRITICAL RISK\|Overall Security Posture:.*CRITICAL" "$file" 2>/dev/null; then
    overall_risk="CRITICAL"
  elif grep -qi "HIGH RISK\|Overall Security Posture:.*HIGH" "$file" 2>/dev/null; then
    overall_risk="HIGH"
  elif grep -qi "MODERATE RISK\|Overall Security Posture:.*MODERATE" "$file" 2>/dev/null; then
    overall_risk="MODERATE"
  elif grep -qi "LOW RISK\|Overall Security Posture:.*LOW" "$file" 2>/dev/null; then
    overall_risk="LOW"
  fi

  # ── Count findings by severity ───────────────────────────────────────────
  local critical_count high_count medium_count low_count informational_count
  critical_count=$(grep -c "^\| Critical" "$file" 2>/dev/null || true)
  high_count=$(grep -c "^\| High" "$file" 2>/dev/null || true)
  medium_count=$(grep -c "^\| Medium" "$file" 2>/dev/null || true)
  low_count=$(grep -c "^\| Low" "$file" 2>/dev/null || true)
  informational_count=$(grep -c "^\| Informational" "$file" 2>/dev/null || true)

  # Fall back to heading-based counting if table not found
  if [[ "$critical_count" -eq 0 && "$high_count" -eq 0 ]]; then
    critical_count=$(grep -c "^\### \[CRITICAL\]" "$file" 2>/dev/null || true)
    high_count=$(grep -c "^\### \[HIGH\]" "$file" 2>/dev/null || true)
    medium_count=$(grep -c "^\### \[MEDIUM\]" "$file" 2>/dev/null || true)
    low_count=$(grep -c "^\### \[LOW\]" "$file" 2>/dev/null || true)
    informational_count=$(grep -c "^\### \[INFORMATIONAL\]" "$file" 2>/dev/null || true)
  fi

  local total_findings=$(( critical_count + high_count + medium_count + low_count + informational_count ))

  # ── Collect OWASP categories ─────────────────────────────────────────────
  local owasp_raw owasp_list
  owasp_raw=$(grep -oP 'A(0[1-9]|10):2025' "$file" 2>/dev/null | sort -u | tr '\n' ',' || true)
  owasp_list="${owasp_raw%,}"  # strip trailing comma

  # Format as YAML list: [A01, A05, ...]
  local owasp_yaml="[]"
  if [[ -n "$owasp_list" ]]; then
    owasp_yaml="[$(echo "$owasp_list" | sed 's/,/, /g')]"
  fi

  # Collect short codes (A01, A05, ...) for INDEX.md row
  local owasp_codes
  owasp_codes=$(echo "$owasp_list" | grep -oP 'A(0[1-9]|10)' | sort -u | tr '\n' ',' | sed 's/,$//')

  # ── Collect CWE IDs ──────────────────────────────────────────────────────
  local cwe_raw cwe_yaml
  cwe_raw=$(grep -oP 'CWE-[0-9]+' "$file" 2>/dev/null | sort -u | tr '\n' ',' || true)
  cwe_raw="${cwe_raw%,}"
  if [[ -n "$cwe_raw" ]]; then
    cwe_yaml="[$(echo "$cwe_raw" | sed 's/,/, /g')]"
  else
    cwe_yaml="[]"
  fi

  # ── Build frontmatter block ───────────────────────────────────────────────
  local frontmatter
  frontmatter=$(cat <<YAML
---
document_type: security-review
review_type: ${review_type}
assessment_date: "${assessment_date}"
codebase_analyzed: ${codebase}
total_files_analyzed: 0
total_findings: ${total_findings}
overall_risk: ${overall_risk}
critical_count: ${critical_count}
high_count: ${high_count}
medium_count: ${medium_count}
low_count: ${low_count}
informational_count: ${informational_count}
owasp_categories: ${owasp_yaml}
cwe_ids: ${cwe_yaml}
field_summaries:
  document_type: "Always 'security-review'. Allows indexers to skip non-review documents."
  review_type: "Which command generated this document: audit, branch, staged, plan, tasks, or followup."
  assessment_date: "ISO 8601 date the review was performed (YYYY-MM-DD)."
  overall_risk: "Highest severity tier with active findings (CRITICAL, HIGH, MODERATE, LOW, INFORMATIONAL)."
  critical_count: "Number of Critical findings (CVSS 9.0-10.0)."
  high_count: "Number of High findings (CVSS 7.0-8.9)."
  medium_count: "Number of Medium findings (CVSS 4.0-6.9)."
  low_count: "Number of Low findings (CVSS 0.1-3.9)."
  informational_count: "Number of Informational findings."
  owasp_categories: "OWASP Top 10 2025 categories (A01-A10) that have at least one finding."
  cwe_ids: "CWE identifiers referenced in this document."
  finding_id: "Unique finding identifier (SEC-NNN) for cross-referencing and task linkage."
  location: "File path and line number of the vulnerable code (path/to/file.ext:line)."
  owasp_category: "OWASP Top 10 2025 category for this finding (AXX:2025-Name)."
  cwe: "Common Weakness Enumeration identifier with short name (CWE-NNN: Name)."
  cvss_score: "CVSS v3.1 base score (0.0-10.0). 9.0+=Critical, 7.0-8.9=High, 4.0-6.9=Medium, 0.1-3.9=Low."
  spec_kit_task: "Spec-Kit task ID for backlog tracking and remediation follow-up (TASK-SEC-NNN)."
---
YAML
)

  # ── Prepend frontmatter (replace existing if --force) ────────────────────
  local tmp
  tmp=$(mktemp)

  if [[ "$first_line" == "---" && "$FORCE" -eq 1 ]]; then
    # Strip existing frontmatter (everything up to and including the closing ---)
    local content_start
    content_start=$(awk 'NR>1 && /^---$/ { print NR+1; exit }' "$file")
    if [[ -n "$content_start" ]]; then
      printf '%s\n' "$frontmatter" > "$tmp"
      tail -n +"$content_start" "$file" >> "$tmp"
    else
      printf '%s\n' "$frontmatter" > "$tmp"
      cat "$file" >> "$tmp"
    fi
  else
    printf '%s\n' "$frontmatter" > "$tmp"
    cat "$file" >> "$tmp"
  fi

  # ── Append INDEX.md row hint if not already present ──────────────────────
  if ! grep -q "Memory Hub INDEX.md Row" "$tmp" 2>/dev/null; then
    printf '\n---\n\n## Memory Hub INDEX.md Row\n\nProposed routing row — paste into your `docs/memory/INDEX.md` Security Reviews table:\n\n```text\n| <relative-path-to-this-file> | %s | %s | %s | C:%s H:%s M:%s L:%s | %s |\n```\n' \
      "$review_type" "$assessment_date" "$overall_risk" \
      "$critical_count" "$high_count" "$medium_count" "$low_count" \
      "${owasp_codes:-none}" >> "$tmp"
  fi

  mv "$tmp" "$file"
  echo "  Done: frontmatter + INDEX.md row written."
}

for f in "${FILES[@]}"; do
  process_file "$f"
done
