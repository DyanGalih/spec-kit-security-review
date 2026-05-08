# Contributing to Security Review

Thank you for your interest in contributing!

## Repository Structure

```
extension.yml          ← Extension manifest
commands/              ← Spec Kit command definitions (single source of truth)
config-template.yml    ← Team brief template (not auto-read by the extension)
docs/                  ← Design, installation, and usage documentation
examples/              ← Example output reports
assets/                ← Visual assets for documentation
scripts/               ← Shell/PowerShell scripts for file detection and maintenance
```

## Development Workflow

### Command Changes

If you want to modify security review rules or detection logic:

1. Update the relevant file in `commands/`. Each command file is self-contained with its full rules, steps, and output format.
2. Run `./scripts/test-install.sh` to verify consistency.
3. If you add a new command, register it in `extension.yml` under `provides.commands`.

### Testing

Run the smoke tests:

```bash
./scripts/test-install.sh
```

## Guidelines

- **Self-Contained Commands**: Every command file must carry its full rules, steps, and output format inline. Do not reference external files except for scripts via `{SCRIPT}`.
- **Evidence-Based Reporting**: Every finding must include location (file:line) and evidence from the codebase.
- **OWASP Alignment**: Categorize all findings according to the current OWASP Top 10.
- **Actionable Remediation**: Provide concrete, code-level remediation guidance for every finding.

## Pull Requests

1. Fork the repository.
2. Create your feature branch.
3. Commit your changes.
4. Run `./scripts/test-install.sh` to verify.
5. Submit a PR with a clear description of what changed and why.

## Release Process

See the Release Checklist in the README for version bump procedures.
