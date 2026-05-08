---
description: "Initialize or update the Security Constitution for the project."
---

# Security Review Initialization

You are initializing or refining the **Security Constitution** for this project.

The Security Constitution is the "source of truth" for all security audits. It defines the trust boundaries, authentication standards, and data isolation rules that the AI auditor will enforce.

## Step 1 — Detect Existing Security Rules

Check for the existence of:

* `.specify/memory/security_constitution.md`
* `constitution.md` (root, `.specify/memory/`, or `docs/memory/`)

### If `security_constitution.md` exists:

1. Analyze the current rules.
2. Ask:
   ```text
   The Security Constitution already exists. Would you like to:
   - Refine existing trust boundaries
   - Update authentication/authorization standards
   - Add specific compliance requirements (SOC2, PCI, HIPAA, etc.)
   - Audit current rules for gaps
   ```

### If ONLY `constitution.md` exists:

1. Identify any security-related sections in the general constitution.
2. Propose moving/copying them into a dedicated `.specify/memory/security_constitution.md`.
3. Explain the benefits of a dedicated security file for deeper auditing.

### If NO security rules exist:

Start the **Security Discovery Interview**.

---

# Security Discovery Interview

Ask the following questions in a conversational way (do not dump all at once).

## 1. Trust Boundaries & Attack Surface

*   "What are the primary entry points for users and external systems?"
*   "Are there internal services or databases that must remain completely isolated from the public web?"
*   "Does the application handle multi-tenant data that must be strictly isolated at the database or application level?"

## 2. Identity & Access

*   "What is the primary authentication mechanism? (e.g., JWT, Session, OAuth2, OpenID Connect)"
*   "How are permissions managed? (e.g., RBAC, ABAC, or simple Admin/User roles)"
*   "Are there specific sensitive actions that require multi-factor authentication (MFA) or step-up auth?"

## 3. Data Sensitivity & Compliance

*   "What types of sensitive data does the project handle? (e.g., PII, PHI, Financial, Secrets, IP)"
*   "Are there specific compliance frameworks you need to adhere to? (e.g., OWASP Top 10, SOC2, GDPR)"
*   "What is the data retention and disposal policy for sensitive information?"

## 4. Secrets & Infrastructure

*   "How are secrets (API keys, DB credentials) managed and injected? (e.g., Vault, AWS Secrets Manager, Environment Variables)"
*   "Are there specific security headers or TLS requirements that must be enforced project-wide?"

---

# Output Format

Once enough context is gathered, generate the final document.

**File Path**: `.specify/memory/security_constitution.md`

## Required Structure

1. **Trust Boundaries**: Definition of what is "trusted" vs "untrusted".
2. **Authentication & Authorization Standards**: Specific patterns to be used in code.
3. **Data Isolation & Privacy Rules**: Rules for handling tenant or sensitive data.
4. **Secrets Management Policy**: How and where secrets are stored.
5. **Secure-by-Design Patterns**: Required security patterns (e.g., "All DB queries must use parameterization").
6. **API & Integration Security**: Rules for external communication.
7. **Audit, Logging & Monitoring**: Requirements for security-relevant events.
8. **Compliance Mapping**: (Optional) How these rules map to SOC2/OWASP etc.

---

# Guardrails

*   **Actionable**: Rules must be specific enough for an AI to audit code against them (e.g., "Use `Auth::user()`" is better than "Be secure").
*   **Enforceable**: Avoid vague statements like "Security is a priority."
*   **Decoupled**: Do not assume a specific cloud provider unless the user specifies one.
*   **Non-Destructive**: Never overwrite an existing constitution without explicit user approval.

---

## Final Instruction

After generating the file, remind the user:
"The Security Constitution is now live. You can now run `/speckit.security-review.audit` to verify your implementation against these rules."
