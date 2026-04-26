---
description: 'Security review of Spec-Kit plan artifacts and supporting design docs'
---

# Security Review — Plan Review

## User Input

$ARGUMENTS

## Objective

Review the current Spec-Kit plan artifact before implementation begins. Focus on the planning documents, not source code, and identify any design choices that would weaken security, create ambiguity, or make secure implementation harder later.

When project memory exists, use it as design context. Compare the plan against the project memory hub, architecture decisions, and any repository-native memory artifacts the team uses to preserve intent.

## Scope

Review the following artifacts when present:

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

- Security requirements are reflected in the plan
- Trust boundaries and threat assumptions are documented
- Authentication, authorization, and session decisions are safe
- Data flow, privacy, and minimization concerns are addressed
- Dependency and platform choices do not create avoidable risk
- Validation, logging, and error handling expectations are explicit
- Secrets handling and deployment hardening are considered
- The plan can be implemented without introducing ambiguous security decisions later

## Steps

1. Locate the active Spec-Kit feature directory for the current work.
2. If more than one candidate plan artifact exists, ask the user which one to review before proceeding.
3. Read `plan.md` and any related design artifacts.
4. Compare the plan against the project memory hub context.
5. Report secure-by-design gaps, unsafe assumptions, and any follow-up changes needed before implementation.

## Output Format

Produce a structured Markdown security review report with:

- Executive summary
- Plan artifacts reviewed
- Vulnerability findings
- Confirmed secure patterns
