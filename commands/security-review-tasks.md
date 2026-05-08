---
description: 'Security review of Spec-Kit task artifacts and implementation sequencing'
---

# Security Review — Task Review

## User Input

$ARGUMENTS

## Objective

Review the current Spec-Kit task list before implementation begins. Focus on task sequencing, security coverage, dependency ordering, and whether the plan has been converted into secure, testable, and reviewable work items.

When project memory exists, use it as design context. Compare the task list against the project memory hub, architecture decisions, and any repository-native memory artifacts the team uses to preserve intent.

## Scope

Review the following artifacts when present:

- `tasks.md`
- `plan.md`
- `spec.md`
- `research.md`
- `data-model.md`
- `.specify/memory/security_constitution.md`
- `contracts/`
- `quickstart.md`
- `docs/memory/`
- `specs/<feature>/memory.md`
- `specs/<feature>/memory-synthesis.md`
- `specs/<feature>/security-constraints.md`
- `.github/copilot-instructions.md`
- Other project memory or architecture notes

## What to Check

- Security-related tasks exist for authentication, authorization, validation, logging, secrets, and hardening
- High-risk changes are sequenced so secure foundations come first
- Tests are written before risky implementation where appropriate
- Task dependencies do not hide security work in later phases
- Parallel tasks do not bypass security prerequisites
- Negative tests, abuse cases, and hardening checks are included where needed
- Sensitive features have explicit security checkpoints
- The task list preserves the intent of the memory hub context and plan

## Steps

1. Locate the active Spec-Kit feature directory for the current work.
2. If more than one candidate task artifact exists, ask the user which one to review before proceeding.
3. Read `tasks.md` and the related planning artifacts.
4. Compare the tasks against the plan and memory hub context.
5. Report sequencing issues, missing security tasks, or any task ordering changes needed before implementation.

## Document Header

Before writing the report body, emit a YAML frontmatter block at the very start of the output document. Populate all values from your analysis. Copy the `field_summaries` section verbatim — it is static schema documentation that enables any LLM or indexer reading only the header to understand the full field schema without parsing the report body.

````yaml
---
document_type: security-review
review_type: tasks
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

Produce a structured Markdown security review report with:

- Executive summary
- Tasks reviewed
- Vulnerability findings
- Confirmed secure patterns

---

## Memory Hub INDEX.md Row

After the report, output the following proposed routing row for the user to paste into their `docs/memory/INDEX.md`. This enables LLM-based filtering without loading the full document.

```text
| <relative path where this doc is saved> | tasks | <assessment_date> | <overall_risk> | C:<critical_count> H:<high_count> M:<medium_count> L:<low_count> | <owasp_categories comma-separated> |
```

Example:

```text
| docs/security-reviews/2026-05-07-auth-tasks.md | tasks | 2026-05-07 | MODERATE | C:0 H:1 M:2 L:1 | A01,A07 |
```

See `docs/field-registry.md` in the security-review-extension for the full INDEX.md table format and SQLite Phase 1 column mapping.
