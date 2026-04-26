# Security Review Extension for Spec-Kit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Spec-Kit Version](https://img.shields.io/badge/Spec--Kit-%3E%3D0.1.0-blue)](https://github.com/github/spec-kit)
[![Version](https://img.shields.io/badge/version-1.2.0-green.svg)](https://github.com/DyanGalih/spec-kit-security-review)

## Overview

The Security Review extension adds security review commands to a Spec-Kit project. It is installed with the `specify` CLI and executed through registered slash commands.

It is designed for secure-by-design development: use the full-project audit to re-review an implementation against the project memory hub and design notes, and use the scoped commands to review staged changes or branch, pull request, or merge request diffs.

If you also install [spec-kit-memory-hub](https://github.com/DyanGalih/spec-kit-memory-hub), the audit, plan, task, and follow-up prompts can use `docs/memory/`, `specs/<feature>/memory.md`, `specs/<feature>/memory-synthesis.md`, and `.github/copilot-instructions.md` as additional design context.

If your Spec-Kit catalog includes the community extension, you can install it directly with `specify extension add security-review`.

Command split:

- `/speckit.security-review.audit` reviews the whole project
- `/speckit.security-review.staged` reviews only staged changes
- `/speckit.security-review.branch` reviews a branch, pull request, or merge request diff
- `/speckit.security-review.plan` reviews the implementation plan and design artifacts
- `/speckit.security-review.tasks` reviews the generated task list and sequencing
- `/speckit.security-review.followup` turns findings into remediation tasks or technical debt

The command reviews application code, configuration, dependencies, and infrastructure files to surface:

- OWASP Top 10 (2025) issues
- Secure coding weaknesses
- Architecture and trust-boundary risks
- Supply-chain and dependency concerns
- DevSecOps configuration gaps

## How It Fits Spec-Kit

Spec-Kit uses the `specify` CLI to install and manage extensions. Once installed, this extension registers full-project, staged, branch, plan, task, and follow-up security review commands for your agent.

```text
specify extension add ...              # install/manage the extension
/speckit.security-review.audit         # full-project security review
/speckit.security-review.staged        # staged-changes review
/speckit.security-review.branch <target> [base]  # branch, pull request, or merge request diff review
/speckit.security-review.plan          # plan/security review
/speckit.security-review.tasks         # task/security review
/speckit.security-review.followup      # finding follow-up planning
```

### Workflow Integration

```text
┌─────────────────────────────────────────────────────────────┐
│                    Spec-Kit Workflow                        │
├─────────────────────────────────────────────────────────────┤
│  /speckit.requirements          → Requirements Phase        │
│  /speckit.plan                  → Planning Phase            │
│  /speckit.security-review.plan  → Plan Review               │
│  /speckit.tasks                 → Task Generation           │
│  /speckit.security-review.tasks → Task Review               │
│  /speckit.analyze               → Cross-Artifact Analysis   │
│  /speckit.implement             → Implementation Phase      │
│  /speckit.security-review.audit → Security Review           │
│  /speckit.security-review.followup → Follow-Up Planning     │
└─────────────────────────────────────────────────────────────┘
```

The upstream Spec-Kit command flow documented on speckit.org ends at `/speckit.implement`; this extension layers security review and follow-up commands around that flow without adding `test` or `deploy` slash commands.

## Installation

Run installation from a Spec-Kit project directory.

### Install from the Community Catalog

```bash
cd /path/to/spec-kit-project

specify extension add security-review
```

If you want a pinned release instead, install from the release archive:

```bash
specify extension add security-review --from \
  https://github.com/DyanGalih/spec-kit-security-review/archive/refs/tags/v1.2.0.zip
```

### Install a Local Checkout for Development

```bash
cd /path/to/spec-kit-project

specify extension add --dev /path/to/spec-kit-security-review
```

### Verify Registration

```bash
specify extension list
ls .claude/commands/speckit.security-review.*
```

If registration succeeded, open your agent session in the same Spec-Kit project and run:

```text
/speckit.security-review.audit
```

Detailed setup and troubleshooting steps are in [docs/installation.md](docs/installation.md).

## Usage

Use the registered slash command from your Spec-Kit agent session.

### Basic Review

```text
/speckit.security-review.audit
```

This is the full audit command for the current project.
Use it after `/speckit.plan` and `/speckit.tasks` when you want a code-level re-review against the planned design.

### Scoped Review

The command file accepts free-form user input via `$ARGUMENTS`, so you can narrow the review scope in natural language.

```text
/speckit.security-review.audit focus on authentication, secrets handling, and payment flows
/speckit.security-review.audit review only the api and worker directories
/speckit.security-review.audit prioritize OWASP Top 10 and dependency risk
```

### Staged Changes Review

Review only files staged with `git add` — ideal as a pre-commit check.

```text
/speckit.security-review.staged
/speckit.security-review.staged focus on secrets and injection
```

Use this when you want the review to stay limited to your staged diff.

### Branch / PR Review

Review only the diff between a feature branch and a base branch — ideal as a pre-merge check, or for reviewing a branch, pull request, or merge request diff.

```text
/speckit.security-review.branch feature/payment-gateway
/speckit.security-review.branch feature/payment-gateway develop
```

Use this when you want the review to focus on branch differences instead of the whole repository.
It is also the right command for a branch, pull request, or merge request diff.

### Plan Review

Review the implementation plan and related design artifacts before implementation begins.

```text
/speckit.security-review.plan
```

Use this right after `/speckit.plan` when you want to re-check the plan for secure-by-design coverage.
After the task list is generated with `/speckit.tasks`, run `/speckit.security-review.tasks` to review sequencing and security coverage.

### Task Review

Review the generated task list and sequencing before implementation begins.

```text
/speckit.security-review.tasks
```

Use this right after `/speckit.tasks` when you want to confirm the tasks preserve the security intent of the plan.

### Follow-Up Planning

Turn findings into concrete remediation tasks or technical-debt items.

```text
/speckit.security-review.followup
```

Use this after `/speckit.security-review.audit`, `/speckit.security-review.staged`, or `/speckit.security-review.branch` when you want the findings converted into tasks instead of only reported.
Use it when you want to defer an issue as technical debt with a clear revisit trigger, or when you want the command to check whether an incomplete finding is already covered by an existing task.
The follow-up output is backlog-ready and includes source finding references so incomplete security work can be tracked cleanly.

The review commands produce structured Markdown reports, and the follow-up command turns those findings into remediation tasks or technical debt.

Detailed examples are in [docs/usage.md](docs/usage.md) and [examples/example-output.md](examples/example-output.md).

## Release Checklist

Use this checklist before creating a new Git tag to keep release metadata consistent.

1. Update `extension.version` in `extension.yml`.
2. Update `README.md` badge and install URL.
3. Update `docs/installation.md` install URLs.
4. Update `docs/usage.md` reinstall URL (if present).
5. Update `examples/example-output.md` footer version (if present).
6. Add a new section in `CHANGELOG.md` for the target version and date.
7. Verify there are no stale version strings:

```bash
grep -RIn "version: 'OLD_VERSION'\|vOLD_VERSION.zip\|version-OLD_VERSION\|Extension vOLD_VERSION" .
```

8. Commit and tag the release:

```bash
git add extension.yml README.md CHANGELOG.md docs/design.md docs/installation.md docs/usage.md examples/example-output.md config-template.yml prompts/security-review-*.prompt.md
git commit -m "release: vX.Y.Z"
git tag vX.Y.Z
git push origin main --tags
```

9. Validate install from tag in a Spec-Kit project:

```bash
specify extension add security-review --from \
  https://github.com/DyanGalih/spec-kit-security-review/archive/refs/tags/vX.Y.Z.zip
specify extension list
```

## Example Output

Running `/speckit.security-review.audit` produces a report like this:

```markdown
# SECURITY REVIEW REPORT

## Executive Summary

**Overall Security Posture:** MODERATE RISK
**Total Findings:** 23

- Critical: 2
- High: 5
- Medium: 8
- Low: 6
- Informational: 2

## Vulnerability Findings

### [CRITICAL] SQL Injection in User Authentication

**Location:** `src/auth/login.js:45`
**OWASP Category:** A05:2025-Injection
**Description:** User input is concatenated directly into SQL query...
**Exploit Scenario:** Attacker could bypass authentication by...
**Remediation:** Use parameterized queries or ORM...
**Spec-Kit Task:** TASK-SEC-001

### [HIGH] Missing Authentication on Admin Endpoints

**Location:** `src/api/admin/routes.js`
**OWASP Category:** A01:2025-Broken Access Control
...
```

## Security Coverage

### OWASP Top 10 (2025)

- A01: Broken Access Control _(includes SSRF)_
- A02: Security Misconfiguration
- A03: Software Supply Chain Failures
- A04: Cryptographic Failures
- A05: Injection
- A06: Insecure Design
- A07: Authentication Failures
- A08: Software or Data Integrity Failures
- A09: Security Logging & Alerting Failures
- A10: Mishandling of Exceptional Conditions

### Additional Coverage

- Input validation and output encoding
- Secrets management and cryptographic handling
- Session and API security
- Trust boundaries and attack surface review
- Dependency, build, and CI/CD risk analysis

## Repository Structure

```text
.
├── extension.yml
├── config-template.yml
├── prompts/
│   ├── security-review.prompt.md
│   ├── security-review-staged.prompt.md
│   └── security-review-branch.prompt.md
├── docs/
├── examples/
└── assets/
```

## Contributing

Contributions should follow the upstream Spec-Kit extension conventions.

- Use the manifest schema described in the Spec-Kit Extension Development Guide
- Keep the registered command name in the `speckit.<extension>.<command>` format
- Preserve command-file frontmatter and Markdown structure
- Test local installs with `specify extension add --dev /path/to/extension`
- Verify registration with `specify extension list` and `.claude/commands/`

Reference guide: [Spec-Kit Extension Development Guide](https://github.com/github/spec-kit/blob/main/extensions/EXTENSION-DEVELOPMENT-GUIDE.md)

## Support

- Documentation: [docs/](docs/)
- Examples: [examples/](examples/)
- Issues: [GitHub Issues](https://github.com/DyanGalih/spec-kit-security-review/issues)
- Discussions: [GitHub Discussions](https://github.com/DyanGalih/spec-kit-security-review/discussions)

## License

This extension is released under the [MIT License](LICENSE).
