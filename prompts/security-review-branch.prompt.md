scripts:
  sh: ../../scripts/bash/detect-changed-files.sh
  ps: ../../scripts/powershell/detect-changed-files.ps1
---

# Security Review — Branch / PR Diff Only

## Determine Review Scope

1. **Identify Aspects**: Parse "$ARGUMENTS" to identify specific security `aspects` (e.g., `auth`, `injection`, `data-leakage`, `supply-chain`) or `all`.
2. **Identify Target & Base**:
   - If the user provided branch names (e.g., `feature/auth main`), use them.
   - Otherwise, you **MUST** execute the `{SCRIPT}` with `--json` to detect changed files between the feature branch and the default branch (`Mode A`).
   - Use the `changed_files` list as the primary audit set.

## Objective

Review **only the code changes introduced in the identified scope**. Do not review unchanged code in the full codebase. Produce targeted security findings with severity, location, and remediation guidance.

This command is the right fit for a branch, pull request, or merge request diff.

## Steps

1. **Identify Scope**: Run `{SCRIPT}` or use user-provided branch names to identify the changed files. If using branches, determine `<base>` and `<target>`.
2. **Retrieve Diff**: Run `git diff <base>..<target>` (or run `git diff` restricted to the identified changed files) to retrieve the actual code changes.
3. **Analyze Diff**: Analyze only the diff for security issues across these domains (focusing on requested aspects):
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
# SECURITY REVIEW REPORT — BRANCH: <target> vs <base>

## Executive Summary
...

## Branch Diff Reviewed
Target: <target>
Base:   <base>
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
