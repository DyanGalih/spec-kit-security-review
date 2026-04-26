# Changelog

All notable changes to the Security Review extension will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- Integration with SAST tools (Semgrep, CodeQL)
- Support for custom security rules
- Compliance mapping (SOC2, ISO 27001, HIPAA)
- Multi-language support expansion
- Memory-hub-aware review guidance for teams that standardize additional project memory

## [1.2.0] - 2026-04-26

### Added

- `/speckit.security-review.plan` command for reviewing plan artifacts and design docs
- `/speckit.security-review.tasks` command for reviewing task artifacts and sequencing
- `/speckit.security-review.followup` command for turning findings into remediation tasks or technical debt
- Secure-by-design review guidance tied to Spec-Kit memory-hub context
- Branch, pull request, and merge request review wording across git platforms
- Direct community-catalog install guidance with `specify extension add security-review`

### Updated

- Extension manifest version to `1.2.0`
- Installation examples to reference the `v1.2.0` release archive
- Documentation to reflect the direct catalog install path

## [1.1.0] - 2026-04-03

### Added

- `/speckit.security-review.staged` command for reviewing staged changes only
- `/speckit.security-review.branch` command for reviewing branch diffs against a base branch

### Updated

- Extension manifest version to `1.1.0`
- Installation examples to reference the `v1.1.0` release archive

## [1.0.0] - 2026-04-02

### Added

- Initial release of the Security Review extension
- `/speckit.security-review.audit` command for comprehensive security audits
- OWASP Top 10 (2025) vulnerability detection
- Secure coding practices analysis
- Architecture security assessment
- Supply chain security review
- DevSecOps configuration audit
- STRIDE threat modeling support
- Spec-Kit task generation for remediation
- Severity classification (Critical, High, Medium, Low, Informational)
- Exploit scenario descriptions
- Fix recommendations with code examples
- Dependency risk analysis
- Secrets detection patterns
- Prompt-driven Markdown security report output
- Natural-language review scoping through command input

### Security Coverage

- **OWASP Top 10:** All 10 categories covered
- **Secure Coding:** Input validation, encoding, cryptography, secrets, sessions, API security
- **Architecture:** Trust boundaries, attack surface, privilege escalation, data flow
- **Supply Chain:** Dependencies, lockfiles, confusion attacks
- **DevSecOps:** Headers, CORS, rate limiting, logging, Docker, CI/CD

### Documentation

- Complete README with installation and usage instructions
- Usage guide with examples
- Installation guide with troubleshooting
- Design document explaining architecture
- Example output demonstrating report format

### Technical

- Guide-aligned extension manifest and prompt command file
- MIT License
- .gitignore for common development artifacts
- config-template.yml for customization
- Example output for reference

---

## Version History Summary

| Version | Release Date | Status |
| ------- | ------------ | ------ |
| 1.1.0   | 2026-04-03   | Stable |
| 1.0.0   | 2026-04-02   | Stable |

---

## Migration Guide

### From No Previous Version (First Install)

This is the initial release. Simply follow the installation instructions in README.md.

---

## Known Issues

None at this time. Please report any issues on our [GitHub Issues](https://github.com/DyanGalih/spec-kit-security-review/issues) page.

---

## Security Advisories

No security advisories at this time.

To report a security vulnerability in this extension, please email security@github.com instead of using public GitHub issues.

---

## Contributors

- Spec-Kit Security Team

For a complete list of contributors, see the [GitHub Contributors](https://github.com/DyanGalih/spec-kit-security-review/graphs/contributors) page.
