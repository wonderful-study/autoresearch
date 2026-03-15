# Security Workflow — /autoresearch:security

Autonomous security auditing that uses the autoresearch loop to iteratively discover, validate, and report vulnerabilities. Combines STRIDE threat modeling, OWASP Top 10 sweeps, and red-team adversarial analysis into a single autonomous loop.

**Output:** A severity-ranked security report with threat model, findings, mitigations, and iteration log.

## Trigger

- User invokes `/autoresearch:security`
- User says "security audit", "run a security sweep", "threat model this codebase", "find vulnerabilities"
- User says "red-team this app", "OWASP audit", "STRIDE analysis"

## Loop Support

Works with both unbounded and bounded modes:

```
# Unlimited — keep finding vulnerabilities until interrupted
/autoresearch:security

# Bounded — run exactly N security sweep iterations
/loop 10 /autoresearch:security

# With target scope
/autoresearch:security
Scope: src/api/**/*.ts, src/middleware/**/*.ts
Focus: authentication and authorization flows
```

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                  SETUP PHASE (once)                         │
│                                                             │
│  1. Scan codebase → identify tech stack, frameworks, APIs   │
│  2. Map assets → data stores, auth, external services       │
│  3. Identify trust boundaries → client/server, API/DB       │
│  4. Generate STRIDE threat model                            │
│  5. Build attack surface map                                │
│  6. Create security-audit-results.tsv log                   │
│  7. Establish baseline (count known issues)                 │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                  AUTONOMOUS LOOP                            │
│                                                             │
│  Each iteration: pick ONE attack vector from the threat     │
│  model, attempt to find/validate the vulnerability,         │
│  log the result, move to next vector.                       │
│                                                             │
│  LOOP (FOREVER or N times):                                 │
│    1. Review: threat model + past findings + results log    │
│    2. Select: pick next untested attack vector              │
│    3. Analyze: deep-dive into target code for the vector    │
│    4. Validate: construct proof (code path, input, output)  │
│    5. Classify: severity + OWASP category + STRIDE category │
│    6. Log: append to results log                            │
│    7. Repeat                                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Setup Phase — Threat Model Generation

### Step 1: Codebase Reconnaissance

Scan the project to build context:

```
READ:
  - package.json / requirements.txt / go.mod (dependencies)
  - .env.example / config files (secrets handling)
  - Dockerfile / docker-compose.yml (infrastructure)
  - API route files (attack surface)
  - Auth/middleware files (trust boundaries)
  - Database schemas/models (data assets)
  - CI/CD configs (supply chain)
```

### Step 2: Asset Identification

Catalog every asset that has security relevance:

| Asset Type | Examples | Priority |
|------------|----------|----------|
| **Data stores** | Database, Redis, file storage, cookies, localStorage | Critical |
| **Authentication** | Login, OAuth, JWT, sessions, API keys | Critical |
| **API endpoints** | REST routes, GraphQL resolvers, webhooks | High |
| **External services** | Payment APIs, email providers, CDN, analytics | High |
| **User input surfaces** | Forms, URL params, headers, file uploads | High |
| **Configuration** | Environment variables, feature flags, CORS settings | Medium |
| **Static assets** | Public files, uploaded content, generated files | Low |

### Step 3: Trust Boundary Mapping

Identify where trust levels change:

```
Trust Boundaries:
  ├── Browser ←→ Server (client-side vs server-side)
  ├── Server ←→ Database (application vs data layer)
  ├── Server ←→ External APIs (internal vs third-party)
  ├── Public routes ←→ Authenticated routes
  ├── User role ←→ Admin role (privilege levels)
  ├── CI/CD ←→ Production (deployment boundary)
  └── Container ←→ Host (infrastructure boundary)
```

### Step 4: STRIDE Threat Model

For each asset + trust boundary combination, analyze threats using STRIDE:

| Threat | Question | Example Findings |
|--------|----------|------------------|
| **S**poofing | Can an attacker impersonate a user/service? | Weak auth, missing CSRF, forged JWTs |
| **T**ampering | Can data be modified in transit or at rest? | Missing input validation, SQL injection, prototype pollution |
| **R**epudiation | Can actions be denied without evidence? | Missing audit logs, unsigned transactions |
| **I**nformation Disclosure | Can sensitive data leak? | Error messages expose internals, PII in logs, debug endpoints |
| **D**enial of Service | Can the service be disrupted? | Missing rate limiting, regex DoS, resource exhaustion |
| **E**levation of Privilege | Can a user gain unauthorized access? | IDOR, broken access control, path traversal |

Output the threat model as a structured table in the security report.

### Step 5: Attack Surface Map

Generate an attack surface map showing:

```
Attack Surface:
  ├── Entry Points
  │   ├── GET /api/users/:id          → IDOR risk (user enumeration)
  │   ├── POST /api/auth/login        → Brute force, credential stuffing
  │   ├── POST /api/upload            → File upload, path traversal
  │   ├── WebSocket /ws               → Auth bypass, injection
  │   └── Webhook /api/webhooks/*     → Signature verification
  ├── Data Flows
  │   ├── User input → DB query       → Injection risk
  │   ├── JWT → route handler          → Token validation
  │   └── File upload → storage        → Malicious file execution
  └── Abuse Paths
      ├── Rate limit bypass → account takeover
      ├── IDOR chain → data exfiltration
      └── SSRF → internal service access
```

### Step 6: Baseline

Count existing security issues before the loop starts:
- Run any existing security linting (`npm audit`, `eslint-plugin-security`, `bandit`, etc.)
- Count issues as baseline metric
- Record in results log as iteration #0

## The Security Loop

### Iteration Protocol

Each iteration follows the autoresearch pattern but adapted for security:

#### Phase 1: Review (Select Attack Vector)

Priority order for selecting the next vector to test:

1. **Critical STRIDE threats** not yet tested
2. **OWASP Top 10 categories** not yet covered
3. **High-severity attack paths** from the surface map
4. **Dependency vulnerabilities** (supply chain)
5. **Configuration weaknesses** (headers, CORS, CSP)
6. **Business logic flaws** (race conditions, state manipulation)
7. **Information disclosure** (error handling, debug modes)

Track coverage in the results log. The goal is comprehensive coverage.

#### Phase 2: Analyze (Deep Dive)

For the selected vector:
1. Read all relevant code files
2. Trace data flow from entry point to data store
3. Identify missing validation, sanitization, or access checks
4. Look for known vulnerability patterns

#### Phase 3: Validate (Proof Construction)

For each potential finding, construct proof:

```
Finding Proof Structure:
  ├── Vulnerable code location (file:line)
  ├── Attack scenario (step-by-step)
  ├── Input that triggers the vulnerability
  ├── Expected vs actual behavior
  ├── Impact assessment
  └── Confidence level (Confirmed / Likely / Possible)
```

**Validation Rules:**
- **Confirmed** — Code path clearly allows the attack, no guards present
- **Likely** — Guards exist but are bypassable or incomplete
- **Possible** — Theoretical risk, depends on configuration or runtime conditions

Do NOT report findings without supporting code evidence.

#### Phase 4: Classify

Assign severity and categories:

**Severity (CVSS-inspired):**

| Severity | Criteria |
|----------|----------|
| **Critical** | RCE, auth bypass, SQL injection, data breach, admin takeover |
| **High** | XSS (stored), SSRF, privilege escalation, mass data exposure |
| **Medium** | CSRF, open redirect, info disclosure, missing rate limits |
| **Low** | Missing headers, verbose errors, weak session config |
| **Info** | Best practice suggestions, hardening recommendations |

**OWASP Top 10 (2021) mapping:**

| ID | Category |
|----|----------|
| A01 | Broken Access Control |
| A02 | Cryptographic Failures |
| A03 | Injection |
| A04 | Insecure Design |
| A05 | Security Misconfiguration |
| A06 | Vulnerable Components |
| A07 | Auth & Identification Failures |
| A08 | Software & Data Integrity Failures |
| A09 | Security Logging & Monitoring Failures |
| A10 | Server-Side Request Forgery |

**STRIDE mapping:** Tag each finding with the applicable STRIDE category.

#### Phase 5: Log

Append to security-audit-results.tsv:

```tsv
iteration	vector	severity	owasp	stride	confidence	location	description
0	-	-	-	-	-	-	baseline — 3 npm audit warnings
1	IDOR	High	A01	EoP	Confirmed	src/api/users.ts:42	GET /api/users/:id returns any user data without ownership check
2	XSS	Medium	A03	Tampering	Likely	src/components/comment.tsx:18	User input rendered via dangerouslySetInnerHTML
3	rate-limit	Medium	A05	DoS	Confirmed	src/api/auth.ts:15	POST /login has no rate limiting — brute force possible
```

#### Phase 6: Repeat

- **Unbounded:** Keep finding vulnerabilities. Never stop. Never ask.
- **Bounded (/loop N):** After N iterations, generate final report and stop.
- **Coverage tracking:** Every 5 iterations, print coverage summary.

### Coverage Summary Format

```
=== Security Audit Progress (iteration 10) ===
STRIDE Coverage: S[✓] T[✓] R[✗] I[✓] D[✓] E[✓] — 5/6
OWASP Coverage: A01[✓] A02[✗] A03[✓] A04[✗] A05[✓] A06[✓] A07[✓] A08[✗] A09[✗] A10[✗] — 5/10
Findings: 4 Critical, 2 High, 3 Medium, 1 Low
Confirmed: 7 | Likely: 2 | Possible: 1
```

## Final Report Structure

Generated at loop completion (bounded) or on interrupt (unbounded):

```markdown
# Security Audit Report

## Executive Summary
- **Date:** {date}
- **Scope:** {files/directories scanned}
- **Iterations:** {N}
- **Total Findings:** {count} ({critical} Critical, {high} High, {medium} Medium, {low} Low)

## Threat Model

### Assets
{table of identified assets}

### Trust Boundaries
{diagram of trust boundaries}

### STRIDE Analysis
{threat model table}

### Attack Surface Map
{entry points, data flows, abuse paths}

## Findings (Descending Severity)

### [CRITICAL] Finding 1: {title}
- **OWASP:** {category}
- **STRIDE:** {category}
- **Location:** `{file}:{line}`
- **Confidence:** Confirmed / Likely / Possible
- **Description:** {what's wrong}
- **Attack Scenario:** {step-by-step exploitation}
- **Code Evidence:**
  ```{lang}
  {vulnerable code snippet}
  ```
- **Mitigation:**
  ```{lang}
  {fixed code snippet}
  ```
- **References:** {CWE, CVE if applicable}

### [HIGH] Finding 2: ...
...

## Coverage Matrix

| OWASP Category | Tested | Findings |
|----------------|--------|----------|
| A01 Broken Access Control | ✓ | 2 |
| A02 Cryptographic Failures | ✓ | 0 |
| ... | ... | ... |

| STRIDE Category | Tested | Findings |
|-----------------|--------|----------|
| Spoofing | ✓ | 1 |
| Tampering | ✓ | 2 |
| ... | ... | ... |

## Dependency Audit
{npm audit / pip audit / go vulnerabilities}

## Security Headers Check
{CSP, HSTS, X-Frame-Options, etc.}

## Recommendations (Priority Order)
1. {Critical fix 1}
2. {Critical fix 2}
...

## Iteration Log
{full TSV content}
```

## OWASP Checks Reference

Detailed checks to perform for each OWASP category:

### A01 — Broken Access Control
- [ ] IDOR on all parameterized routes (`:id`, `:slug`)
- [ ] Missing authorization middleware on protected routes
- [ ] Horizontal privilege escalation (user A accessing user B's data)
- [ ] Vertical privilege escalation (user accessing admin functions)
- [ ] Directory traversal on file operations
- [ ] CORS misconfiguration allowing unauthorized origins
- [ ] Missing function-level access control

### A02 — Cryptographic Failures
- [ ] Sensitive data in plaintext (passwords, tokens, PII)
- [ ] Weak hashing algorithms (MD5, SHA1 for passwords)
- [ ] Hardcoded secrets/API keys in source
- [ ] Missing encryption at rest / in transit
- [ ] Weak random number generation for security tokens
- [ ] Exposed .env files or config with secrets

### A03 — Injection
- [ ] SQL/NoSQL injection in database queries
- [ ] Command injection in shell executions (exec, spawn)
- [ ] XSS (stored, reflected, DOM-based)
- [ ] Template injection (SSTI)
- [ ] LDAP injection
- [ ] Path injection in file operations
- [ ] Header injection (CRLF)

### A04 — Insecure Design
- [ ] Missing rate limiting on sensitive endpoints
- [ ] No account lockout after failed login attempts
- [ ] Predictable resource identifiers
- [ ] Race conditions in critical operations
- [ ] Missing CSRF protection on state-changing operations
- [ ] Insecure direct object references in design

### A05 — Security Misconfiguration
- [ ] Debug mode enabled in production
- [ ] Default credentials / admin pages exposed
- [ ] Verbose error messages exposing internals
- [ ] Missing security headers (CSP, HSTS, X-Content-Type-Options)
- [ ] Unnecessary HTTP methods enabled
- [ ] Directory listing enabled
- [ ] Stack traces in error responses

### A06 — Vulnerable and Outdated Components
- [ ] Known CVEs in dependencies (npm audit, pip audit)
- [ ] Outdated frameworks with security patches available
- [ ] Unmaintained dependencies
- [ ] Dependencies with known prototype pollution

### A07 — Identification and Authentication Failures
- [ ] Weak password policies
- [ ] Missing multi-factor authentication for admin
- [ ] Session fixation vulnerabilities
- [ ] JWT vulnerabilities (none algorithm, weak secret, no expiry)
- [ ] Insecure password reset flows
- [ ] Missing session invalidation on logout/password change

### A08 — Software and Data Integrity Failures
- [ ] Missing integrity checks on CI/CD pipelines
- [ ] Unsigned or unverified updates/dependencies
- [ ] Insecure deserialization
- [ ] Missing CSP or SRI for external scripts
- [ ] Unsigned webhooks / API callbacks

### A09 — Security Logging and Monitoring Failures
- [ ] Missing audit logs for security events
- [ ] No logging of failed authentication attempts
- [ ] Sensitive data in logs (passwords, tokens)
- [ ] Missing alerting on suspicious activity
- [ ] Log injection vulnerabilities

### A10 — Server-Side Request Forgery (SSRF)
- [ ] Unvalidated URLs in server-side requests
- [ ] DNS rebinding vulnerabilities
- [ ] Missing allowlist for external service calls
- [ ] Proxy/redirect endpoints without validation

## Red-Team Adversarial Lenses

Adapted from the plan red-team workflow for security context:

### Security Adversary (Primary)
**Mindset:** "I'm a hacker trying to breach this system"
- Focus: auth bypass, injection, data exposure, privilege escalation
- Method: trace every input to its sink, find missing guards
- Priority: exploitable findings over theoretical risks

### Supply Chain Attacker
**Mindset:** "I'm compromising dependencies or build pipeline"
- Focus: dependency vulnerabilities, CI/CD weaknesses, unsigned artifacts
- Method: audit dependency tree, check for typosquatting, verify integrity
- Priority: dependencies with known CVEs, build pipeline access

### Insider Threat
**Mindset:** "I'm a malicious employee or compromised account"
- Focus: privilege escalation, data exfiltration, access control gaps
- Method: check what a low-privilege user can access, find horizontal movement
- Priority: admin bypass, bulk data export, missing audit trails

### Infrastructure Attacker
**Mindset:** "I'm attacking the deployment, not the code"
- Focus: container escape, exposed services, network segmentation
- Method: check Docker configs, K8s manifests, exposed ports, env vars
- Priority: secrets in environment, overly permissive configs

## Strix-Inspired Patterns

Learned from Strix (AI-powered security testing platform):

### Proof-of-Concept Validation
Never report a finding without proof. For each vulnerability:
1. Identify the exact code path
2. Construct a concrete exploit input
3. Trace execution through the vulnerability
4. Show the impact (data leaked, access gained, etc.)

### Multi-Agent Attack Collaboration
When using `/loop`, each iteration should build on prior findings:
- Iteration 1 finds open endpoint → Iteration 2 chains with IDOR
- Iteration 3 finds missing rate limit → Iteration 4 tests brute force feasibility
- Findings compound. Each iteration reads past findings for chaining opportunities.

### Dynamic Analysis Verification
Where possible, suggest or construct verification commands:
```bash
# Test for missing rate limiting
for i in {1..100}; do curl -s -o /dev/null -w "%{http_code}" https://app/api/login; done

# Test for IDOR
curl -H "Authorization: Bearer USER_A_TOKEN" https://app/api/users/USER_B_ID

# Test for XSS
curl https://app/search?q=%3Cscript%3Ealert(1)%3C/script%3E
```

### Comprehensive Vulnerability Categories (from Strix)
- **Access Control** — IDOR, privilege escalation, auth bypass
- **Injection Attacks** — SQL, NoSQL, command injection
- **Server-Side** — SSRF, XXE, deserialization flaws
- **Client-Side** — XSS, prototype pollution, DOM vulnerabilities
- **Business Logic** — Race conditions, workflow manipulation
- **Authentication** — JWT vulnerabilities, session management
- **Infrastructure** — Misconfigurations, exposed services

## Metric for the Loop

The security audit uses a **coverage + finding count** composite metric:

```
metric = (owasp_categories_tested / 10) * 50 + (stride_categories_tested / 6) * 30 + min(finding_count, 20)
```

- **Direction:** higher is better (more coverage + more findings = more thorough)
- **Maximum theoretical:** 50 + 30 + 20 = 100
- **Baseline:** 0 (nothing tested yet)

This incentivizes the loop to cover ALL categories before going deep on any one.

## Error Recovery

| Error | Recovery |
|-------|----------|
| Can't determine tech stack | Ask user for framework/language |
| No API routes found | Scan for all exported functions with HTTP-like patterns |
| Dependency audit fails | Skip, note in report, continue with code analysis |
| Code too large for context | Focus on files matching attack surface (API, auth, DB) |
| False positive suspected | Mark as "Possible" confidence, include caveats |

## Anti-Patterns

- **Do NOT report theoretical risks without code evidence** — every finding needs a file:line reference
- **Do NOT skip categories** — the loop should aim for 100% OWASP + STRIDE coverage
- **Do NOT auto-fix vulnerabilities** — report only, user decides what to fix
- **Do NOT test against live production** — analyze code statically, suggest dynamic tests
- **Do NOT report the same finding twice** — check results log for duplicates before logging
- **Do NOT prioritize quantity over quality** — 5 confirmed critical > 50 theoretical lows

## Report Output — Structured Folder

Every `/autoresearch:security` run creates a dedicated folder inside a `security/` directory at the project root (similar to how `/plan --hard` creates plan directories).

### Folder Structure

```
{project_root}/
└── security/
    ├── 260315-0945-stride-owasp-full-audit/
    │   ├── overview.md                    ← Executive summary + links to all reports
    │   ├── threat-model.md                ← STRIDE threat model (assets, boundaries, threats)
    │   ├── attack-surface-map.md          ← Entry points, data flows, abuse paths
    │   ├── findings.md                    ← All findings ranked by severity (Critical → Low)
    │   ├── owasp-coverage.md              ← OWASP Top 10 coverage matrix + per-category results
    │   ├── dependency-audit.md            ← npm audit / pip audit / go vuln results
    │   ├── recommendations.md             ← Prioritized mitigations with code snippets
    │   └── security-audit-results.tsv     ← Iteration log (every vector tested)
    │
    ├── 260320-1430-auth-api-focused-audit/
    │   ├── overview.md
    │   ├── threat-model.md
    │   ├── ...
    │   └── security-audit-results.tsv
    │
    └── ...                                ← One subfolder per audit run
```

### Folder Naming Convention

```
security/{YYMMDD}-{HHMM}-{audit-type-slug}/
```

| Component | Source | Example |
|-----------|--------|---------|
| `YYMMDD` | Current date | `260315` |
| `HHMM` | Current time (24h) | `0945` |
| `audit-type-slug` | Inferred from scope/focus | `stride-owasp-full-audit` |

**Slug generation rules:**
- If no scope/focus specified → `stride-owasp-full-audit`
- If scope is auth-related → `auth-authorization-audit`
- If scope is API-related → `api-security-audit`
- If scope is infra-related → `infrastructure-security-audit`
- If user provides a focus string → kebab-case it (e.g., "payment flow" → `payment-flow-audit`)

### File Descriptions

#### overview.md
```markdown
# Security Audit — {audit-type}

**Date:** {YYYY-MM-DD HH:MM}
**Scope:** {files/directories}
**Focus:** {user-provided focus or "comprehensive"}
**Iterations:** {N completed} ({bounded or unlimited})
**Duration:** {approximate time}

## Summary

- **Total Findings:** {count}
  - Critical: {n} | High: {n} | Medium: {n} | Low: {n} | Info: {n}
- **STRIDE Coverage:** {n}/6 categories tested
- **OWASP Coverage:** {n}/10 categories tested
- **Confirmed:** {n} | Likely: {n} | Possible: {n}

## Top 3 Critical Findings

1. [{title}]({findings.md#finding-1}) — {one-line description}
2. [{title}]({findings.md#finding-2}) — {one-line description}
3. [{title}]({findings.md#finding-3}) — {one-line description}

## Files in This Report

- [Threat Model](./threat-model.md) — STRIDE analysis, assets, trust boundaries
- [Attack Surface Map](./attack-surface-map.md) — entry points, data flows, abuse paths
- [Findings](./findings.md) — all findings ranked by severity
- [OWASP Coverage](./owasp-coverage.md) — per-category test results
- [Dependency Audit](./dependency-audit.md) — known CVEs in dependencies
- [Recommendations](./recommendations.md) — prioritized mitigations
- [Iteration Log](./security-audit-results.tsv) — raw data from every iteration
```

#### threat-model.md
Contains the full STRIDE analysis generated in the Setup Phase:
- Asset inventory table
- Trust boundary diagram
- STRIDE threat matrix (per asset × boundary)
- Risk ratings per threat

#### attack-surface-map.md
Contains the attack surface generated in the Setup Phase:
- Entry points (all API routes, webhooks, WebSocket endpoints)
- Data flows (input → processing → storage)
- Abuse paths (chained attack scenarios)

#### findings.md
All findings from the loop, in descending severity:
- Each finding uses the full proof structure (OWASP, STRIDE, location, evidence, mitigation)
- Findings are numbered and linkable via anchors (`#finding-1`, `#finding-2`)

#### owasp-coverage.md
Coverage matrix showing which OWASP categories were tested and results:
```markdown
| ID | Category | Tested | Findings | Status |
|----|----------|--------|----------|--------|
| A01 | Broken Access Control | ✓ | 2 | ⚠️ Issues found |
| A02 | Cryptographic Failures | ✓ | 0 | ✅ Clean |
| A03 | Injection | ✓ | 1 | ⚠️ Issues found |
| ... | ... | ... | ... | ... |
```

Also includes per-category detail: which specific checks were run and their results.

#### dependency-audit.md
Output of dependency security tools:
- `npm audit` / `yarn audit` (Node.js)
- `pip audit` / `safety check` (Python)
- `go vuln` (Go)
- `cargo audit` (Rust)
- Known CVEs, severity, affected versions, fix versions

#### recommendations.md
Prioritized action items with code fix snippets:
```markdown
## Priority 1 — Critical (Fix Immediately)

### 1. Restrict JWT Algorithm
**Finding:** [JWT Algorithm Confusion](./findings.md#finding-2)
**Effort:** 5 minutes
**Fix:**
\```typescript
// Before (vulnerable)
jwt.verify(token, secret);

// After (secure)
jwt.verify(token, secret, { algorithms: ['HS256'] });
\```

### 2. Add IDOR Protection
...

## Priority 2 — High (Fix This Sprint)
...

## Priority 3 — Medium (Plan for Next Sprint)
...
```

### Creation Protocol

1. At the **start** of `/autoresearch:security`, create the folder:
   ```
   mkdir -p security/{YYMMDD}-{HHMM}-{slug}
   ```

2. During the **Setup Phase**, write:
   - `threat-model.md` (after STRIDE analysis)
   - `attack-surface-map.md` (after surface mapping)
   - `security-audit-results.tsv` (header row + baseline iteration)

3. During the **Loop**, append to:
   - `security-audit-results.tsv` (after each iteration)

4. At **completion** (bounded loop end or interrupt), write:
   - `findings.md` (all findings consolidated)
   - `owasp-coverage.md` (coverage matrix)
   - `dependency-audit.md` (tool output)
   - `recommendations.md` (prioritized mitigations)
   - `overview.md` (executive summary — written LAST, links to all other files)

5. Print the folder path to the user:
   ```
   Security audit complete. Report saved to:
   security/260315-0945-stride-owasp-full-audit/overview.md
   ```

### Gitignore

Add to `.gitignore` (if not already present):
```
security-audit-results.tsv
```

The `.tsv` iteration log is a working file. The `.md` reports are meant to be committed and shared.
