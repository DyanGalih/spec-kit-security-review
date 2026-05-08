---
description: 'Apply approved security follow-up items into Spec-Kit planning artifacts'
---

# Security Review - Apply Follow-Ups

## User Input

$ARGUMENTS

## Objective

Apply approved security follow-up items into the local Spec-Kit planning artifacts without changing the broader project implementation.

Use this command when you want to:

- turn security findings into concrete backlog updates
- add new security tasks to `tasks.md`
- update `plan.md` only when a security decision, acceptance criterion, or sequencing rule must change
- preserve the existing Spec-Kit flow instead of replacing it

Treat the latest security review findings or the follow-up plan as the source of truth. If the user does not provide one, look for a recent security review report, a follow-up plan, or the current backlog context.

When project memory exists, use it as design context. Compare the requested updates against the project memory hub, architecture decisions, and any repository-native memory artifacts the team uses to preserve intent.

## Scope

Before applying updates, check the Spec-Kit memory hub context.

### Optimizer-Aware Flow

When `.specify/extensions/memory-md/config.yml` has `optimizer.enabled: true` and the CLI is available:

1. **Refresh Cache**: Execute `npx speckit-memory refresh-memory` to ensure the local SQLite cache is up to date.
2. **Targeted Security Search**: Execute `npx speckit-memory search-memory "security constraints vulnerabilities authentication authorization data-leakage"` to retrieve relevant durable memory entries.
3. **Synthesis Refresh**: Execute `npx speckit-memory synthesize --feature specs/<feature>` to update the concise working summary.
4. **Read Synthesis**: Read `specs/<feature>/memory-synthesis.md` (or the search results) first.

### Markdown-Only Flow

When the optimizer is disabled or unavailable, you **MUST** read these files explicitly using your file-reading tools (absolute or relative paths). Do not rely solely on workspace search or semantic indexers, as these files are often in `.gitignore`:

- latest security review findings or follow-up plan
- `tasks.md`
- `plan.md`
- `spec.md`
- `research.md`
- `data-model.md`
- `contracts/`
- `quickstart.md`
- `docs/memory/INDEX.md`
- `docs/memory/`
- `specs/<feature>/memory.md`
- `specs/<feature>/memory-synthesis.md`
- `.github/copilot-instructions.md`
- Other project memory or architecture notes

## What to Check

- New security tasks are not already covered by an existing task
- Security tasks are added in a way that preserves existing task sequencing
- High-severity issues remain prioritized for immediate remediation
- Deferred items stay clearly marked as technical debt when appropriate
- `plan.md` only changes when the security design or sequencing needs to change
- The resulting artifacts remain testable and reviewable
- The update preserves the intent of the memory hub context and the current implementation

## Apply Rules

1. Prefer updating `tasks.md` over `plan.md` unless the plan itself needs a security correction.
2. Keep changes minimal and scoped to the security follow-up items.
3. Preserve existing formatting, headings, and task numbering style.
4. Add only the backlog entries that are necessary for the approved security items.
5. If the user asks for a dry run or preview, do not edit files; instead prepare the proposed changes in the response.
6. If more than one candidate task or plan artifact exists, ask the user which one to update before proceeding.

## Steps

1. Read the latest security review findings or follow-up plan provided in `$ARGUMENTS`.
2. Read `tasks.md`, `plan.md`, and related planning artifacts to understand the current backlog.
3. Compare the findings against the current task backlog and memory hub context.
4. Identify which items should become new tasks, which belong in technical debt, and which are already covered.
5. Update `tasks.md` with any approved security tasks.
6. Update `plan.md` only if the security design or sequencing needs to change.
7. Summarize the files changed and the rationale for each change.

## Output Format

Produce a structured Markdown update summary with:

- Executive summary
- Files reviewed
- Files changed
- Security items added or updated
- Deferred items left unchanged
- Confirmed secure patterns

## Task Format

When adding security tasks, keep them compatible with the existing Spec-Kit security task style:

- `TASK-SEC-[NNN]`
- severity
- category or OWASP mapping
- location or source finding
- description
- acceptance criteria
- references or related artifacts

If a finding is deferred instead of applied, record it as technical debt in the follow-up output but do not silently discard it.

Begin by reviewing the current backlog and the approved security follow-up items.
