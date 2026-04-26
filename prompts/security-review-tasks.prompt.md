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
- `contracts/`
- `quickstart.md`
- `docs/memory/`
- `specs/<feature>/memory.md`
- `specs/<feature>/memory-synthesis.md`
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

## Output Format

Produce a structured Markdown security review report with:

- Executive summary
- Tasks reviewed
- Vulnerability findings
- Confirmed secure patterns
