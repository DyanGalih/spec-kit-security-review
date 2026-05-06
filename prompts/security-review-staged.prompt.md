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
   - Broken access control or missing authorization checks
   - Cryptographic failures (weak algorithms, hardcoded keys)
   - Security misconfiguration
   - Input validation gaps
   - Authentication or session weaknesses
   - Insecure data handling
   - Vulnerable or newly added dependencies
   - Supply chain risks in newly added packages
3. **Report Findings**: For each finding, report severity, location, OWASP category, description, remediation, and Spec-Kit task.
4. **Action Plan**: Provide a prioritized action plan for fixing findings.

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
