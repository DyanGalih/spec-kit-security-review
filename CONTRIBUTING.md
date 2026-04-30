# Contributing to Security Review

Thank you for your interest in contributing!

## Repository Structure

```
extension.yml          ← Extension manifest
prompts/               ← Spec Kit command definitions (single source of truth)
config-template.yml    ← Team brief template (not auto-read by the extension)
docs/                  ← Design, installation, and usage documentation
examples/              ← Example output reports
assets/                ← Logo and branding
scripts/               ← Maintenance and verification scripts
```

## Development Workflow

### Prompt Changes

If you want to modify security review rules or detection logic:

1. Update the relevant file in `prompts/`. Each prompt file is self-contained with its full rules, steps, and output format.
2. Run `./scripts/test-install.sh` to verify consistency.
3. If you add a new command, register it in `extension.yml` under `provides.commands`.

### Adding OWASP Coverage

When updating OWASP categories or adding new security domains:

1. Update the main audit prompt (`prompts/security-review.prompt.md`).
2. Ensure the scoped commands (`staged`, `branch`) reference the same domains.
3. Update `README.md` coverage section if the domain list changes.

### Testing

Run the smoke tests:

```bash
./scripts/test-install.sh
```

## Guidelines

- **Self-Contained Prompts**: Every prompt file must carry its full rules, steps, and output format inline. Do not reference external files.
- **Actionable Findings**: Every finding must include severity, location, OWASP mapping, description, and remediation.
- **Non-Blocking by Default**: Findings are reported, not enforced. The `followup` and `apply` commands handle task creation.
- **Memory Hub Integration**: When project memory exists, use it as context — but never require it.

## Pull Requests

1. Fork the repository.
2. Create your feature branch.
3. Commit your changes.
4. Run `./scripts/test-install.sh` to verify.
5. Submit a PR with a clear description of what changed and why.

## Release Process

See the Release Checklist in the README for version bump procedures.
