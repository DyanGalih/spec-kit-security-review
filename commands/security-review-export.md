---
description: "Export security review findings as a formal Executive and Technical Pentest Report."
---

# Security Review — Formal Export (Whitebox Pentest Style)

## User Input

$ARGUMENTS

## Objective

Synthesize one or more security review reports, follow-up plans, or finding lists into a formal, professional **Whitebox Security Assessment Report**. This report is designed for both stakeholders (Executive) and developers (Technical).

## Scope

Read and analyze the following artifacts when present:

- **Source Findings**: The latest security review report(s) or findings provided in `$ARGUMENTS`.
- **Durable Context**: `.specify/memory/security_constitution.md` and `docs/memory/`.
- **Implementation Context**: `plan.md`, `tasks.md`, and relevant `spec.md` files.

### Optimizer-Aware Flow

When `.specify/extensions/memory-md/config.yml` has `optimizer.enabled: true` and the CLI is available:

1. **Refresh Cache**: Execute `npx speckit-memory refresh-memory`.
2. **Context Search**: Execute `npx speckit-memory search-memory "security decisions architecture constraints remediation"`.
3. **Read Synthesis**: Read `specs/<feature>/memory-synthesis.md` to identify the "Why" behind the current design.

## Output Format

Produce a structured Markdown report with the following mandatory sections. Use a professional, authoritative, and objective tone.

---

# [PROJECT NAME] — WHITEBOX SECURITY ASSESSMENT REPORT

## 1. EXECUTIVE SUMMARY

### 1.1 Assessment Overview
[1 paragraph summary of what was tested, when, and by whom (AI Security Auditor). Explicitly mention this was a Whitebox assessment with full source and memory hub access.]

### 1.2 Risk Posture
**Overall Risk Rating: [CRITICAL|HIGH|MODERATE|LOW]**

| Severity | Count | Primary Categories |
| --- | --- | --- |
| Critical | X | [e.g. A05:Injection] |
| High | X | [e.g. A07:Authentication] |
| Medium | X | [e.g. A02:Misconfiguration] |
| Low | X | [e.g. A09:Logging] |

### 1.3 Key Findings & Strategic Impact
[2-3 paragraphs summarizing the most critical risks in business terms. What is the impact on data privacy, customer trust, or system availability? Highlight systemic patterns identified.]

### 1.4 Remediation Roadmap
[High-level summary of the implementation priorities. Which fixes should be fast-tracked? What long-term architectural changes are needed?]

---

## 2. ASSESSMENT METHODOLOGY

### 2.1 Scope of Work
- **Codebase**: [e.g. src/api, src/auth]
- **Documentation**: Spec-Kit Feature Specs, Implementation Plans, Security Constitution.
- **Historical Memory**: Durable repository memory (Memory Hub).

### 2.2 Testing Approach
This was a **Whitebox Security Assessment**. Unlike a blackbox pentest, the auditor had full access to:
- Source code logic and internal data flows.
- Architectural decision records (ADRs) and design intent.
- Historical bug patterns and security constraints preserved in the memory hub.

The assessment evaluated the codebase against **OWASP Top 10 (2025)**, **CWE/SANS Top 25**, and project-specific security standards.

---

## 3. TECHNICAL FINDINGS

[For each finding, provide the following detail:]

### [FINDING_ID] — [Finding Title]
**Severity**: [CRITICAL|HIGH|MODERATE|LOW]
**OWASP Category**: AXX:2025-Category
**CWE**: CWE-XXX
**CVSS v3.1**: X.X

#### 3.X.1 Description
[Concise technical description of the vulnerability and why it exists.]

#### 3.X.2 Evidence (Affected Code)
**File**: `path/to/file.ext:line`

```[language]
[Snippet of vulnerable code]
```

#### 3.X.3 Exploit Scenario
[Step-by-step technical walk-through of how an attacker would exploit this in the context of the application.]

#### 3.X.4 Impact
[Technical impact: e.g. Unauthorized access to PII, arbitrary code execution, etc.]

#### 3.X.5 Remediation Guidance
[Specific, actionable steps to resolve the finding.]

**Proposed Fix**:
```[language]
[Snippet of secure implementation]
```

---

## 4. ARCHITECTURAL DRIFT & SYSTEMIC RISKS

[Identify risks that aren't single-line bugs but rather systemic failures or deviations from the Security Constitution / Memory Hub intent.]

- **Pattern A**: [e.g. Inconsistent use of authorization middleware]
- **Pattern B**: [e.g. Implicit trust of internal microservice communication]

---

## 5. APPENDICES

### 5.1 CVSS Scoring Rubric
- **9.0 - 10.0**: Critical
- **7.0 - 8.9**: High
- **4.0 - 6.9**: Medium
- **0.1 - 3.9**: Low

### 5.2 Tooling Context
- **Orchestrator**: Spec-Kit Security Review Extension
- **Memory Optimization**: [SQLite-enabled / Markdown-only]
- **Date of Generation**: [YYYY-MM-DD]

---

## Final Instructions

1. **Consolidate**: Combine findings from all provided reports. Avoid duplicate entries.
2. **Categorize**: Group findings by OWASP category in the technical section.
3. **Professionalism**: Use formal language (e.g., "The assessment identified..." instead of "I found...").
4. **Actionable**: Ensure every remediation step is compatible with the Spec-Kit `plan.md` style.
5. **Durable Memory**: If systemic findings are found, suggest running `/speckit.memory-md.capture` after the export.
