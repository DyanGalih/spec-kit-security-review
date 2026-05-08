---
description: "Security review of staged changes only (git diff --cached)"
scripts:
  sh: ../../scripts/bash/detect-changed-files.sh
  ps: ../../scripts/powershell/detect-changed-files.ps1
---

# Security Review — Staged Changes Only

## Determine Review Scope

1. **Identify Aspects**: Parse "$ARGUMENTS" to identify specific security `aspects` (e.g., `auth`, `injection`, `secrets`) or `all`.
2. **Identify Changed Files**:
   - You **MUST** execute the `{SCRIPT}` with `--json` to detect changed files in the working directory (`Mode B`).
   - Specifically focus on the `staged` (index) changes if the script provides that detail, or just the working directory set if appropriate.
   - Use the `changed_files` list as the primary audit set.

## Objective

Review **only the code that is currently staged for commit** (or uncommitted work in the current scope). Do not review the rest of the codebase. Produce targeted security findings with severity, location, and remediation guidance.

## Steps

1. **Identify Scope**: Run `{SCRIPT}` to identify the changed files.
2. **Retrieve Diff**: Run `git diff --cached` (or `git diff` on the identified files) to retrieve the actual code changes.
3. **Analyze Diff**: Analyze only the staged diff for security issues across these domains (focusing on requested aspects):
   - Injection vulnerabilities (SQL, NoSQL, command, template)
   - Hardcoded secrets or credentials
   - Compliance with the Spec-Kit memory hub context.

      #### Optimizer-Aware Flow

      When `.specify/extensions/memory-md/config.yml` has `optimizer.enabled: true` and the CLI is available:

      1. **Refresh Cache**: Execute `npx speckit-memory refresh-memory`.
      2. **Targeted Security Search**: Execute `npx speckit-memory search-memory "security constraints vulnerabilities authentication authorization data-leakage"`.
      3. **Synthesis Refresh**: If a feature scope is identified, execute `npx speckit-memory synthesize --feature specs/<feature>`.
      4. **Read Synthesis**: Read `specs/<feature>/memory-synthesis.md` (or the search results) first.

      #### Markdown-Only Flow

      When the optimizer is disabled or unavailable, you **MUST** read these files explicitly using your file-reading tools (absolute or relative paths). Do not rely solely on workspace search or semantic indexers, as these files are often in `.gitignore`:

      - `docs/memory/INDEX.md`
      - `docs/memory/`
      - `.specify/memory/security_constitution.md`
      - `specs/<feature>/memory.md`
      - `specs/<feature>/memory-synthesis.md`
      - `specs/<feature>/security-constraints.md`
      - `.github/copilot-instructions.md`
   - Broken access control or missing authorization checks
   - Cryptographic failures (weak algorithms, hardcoded keys)
   - Security misconfiguration
   - Input validation gaps
   - Authentication or session weaknesses
   - Insecure data handling
   - Vulnerable or newly added dependencies
   - Supply chain risks in newly added packages
4. **Report Findings**: For each finding, report severity, location, OWASP category, description, remediation, and Spec-Kit task.
5. **Action Plan**: Provide a prioritized action plan for fixing findings.
6. **Durable Memory Preservation**: If systemic vulnerabilities or reusable security patterns were identified, execute `/speckit.memory-md.capture` after providing the report to ensure these lessons are preserved in the project's durable memory.

## Document Header

Before writing the report body, emit a YAML frontmatter block at the very start of the output document. Populate all values from your analysis. Copy the `field_summaries` section verbatim — it is static schema documentation that enables any LLM or indexer reading only the header to understand the full field schema without parsing the report body.

````yaml
---
document_type: security-review
review_type: staged
assessment_date: <YYYY-MM-DD>
codebase_analyzed: <project name or path>
total_files_analyzed: <integer>
total_findings: <integer>
overall_risk: <CRITICAL|HIGH|MODERATE|LOW|INFORMATIONAL>
critical_count: <integer>
high_count: <integer>
medium_count: <integer>
low_count: <integer>
informational_count: <integer>
owasp_categories: [<A01>, <A05>, ...]
cwe_ids: [<CWE-89>, ...]
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
````

Then follow with the report body.

## Output Format

Use the same report structure as the full audit command:

```
# SECURITY REVIEW REPORT — STAGED CHANGES

## Executive Summary
...

## Staged Diff Reviewed
(show files changed)

## Vulnerability Findings
### [SEVERITY] Title
**Location:** file:line
**OWASP Category:** AXX:2025-...
**Description:** ...
**Remediation:** ...
**Spec-Kit Task:** TASK-SEC-NNN
...

## Confirmed Secure Patterns
...
```

---

## Memory Hub INDEX.md Row

After the report, output the following proposed routing row for the user to paste into their `docs/memory/INDEX.md`. This enables LLM-based filtering without loading the full document.

```text
| <relative path where this doc is saved> | staged | <assessment_date> | <overall_risk> | C:<critical_count> H:<high_count> M:<medium_count> L:<low_count> | <owasp_categories comma-separated> |
```

Example:

```text
| docs/security-reviews/2026-05-07-staged.md | staged | 2026-05-07 | MODERATE | C:0 H:1 M:2 L:1 | A02,A09 |
```

See `docs/field-registry.md` in the security-review-extension for the full INDEX.md table format and SQLite Phase 1 column mapping.
