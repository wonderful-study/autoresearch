<div align="center">

# The Complete Guide to Claude Autoresearch

**By [Udit Goenka](https://udit.co)**

*Everything you need to master autonomous iteration — from first run to advanced multi-command chains.*

[![Version](https://img.shields.io/badge/version-1.6.2-blue.svg)](https://github.com/uditgoenka/autoresearch/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## Table of Contents

- [What is Autoresearch?](#what-is-autoresearch)
- [Installation](#installation)
- [Your First Run](#your-first-run)
- [Core Concepts](#core-concepts)
- [Command Reference](#command-reference)
  - [/autoresearch — The Loop](#autoresearch--the-loop)
  - [/autoresearch:plan — Setup Wizard](#autoresearchplan--setup-wizard)
  - [/autoresearch:debug — Bug Hunter](#autoresearchdebug--bug-hunter)
  - [/autoresearch:fix — Error Crusher](#autoresearchfix--error-crusher)
  - [/autoresearch:security — Security Auditor](#autoresearchsecurity--security-auditor)
  - [/autoresearch:ship — Shipping Workflow](#autoresearchship--shipping-workflow)
  - [/autoresearch:scenario — Scenario Explorer](#autoresearchscenario--scenario-explorer)
- [Scenarios by Domain](#scenarios-by-domain)
  - [Software Engineering](#software-engineering)
  - [Debugging & Bug Fixing](#debugging--bug-fixing)
  - [Sales & Lead Generation](#sales--lead-generation)
  - [SEO & Content Marketing](#seo--content-marketing)
  - [Marketing & Growth](#marketing--growth)
  - [Web Scraping & Data Collection](#web-scraping--data-collection)
  - [Research & Analysis](#research--analysis)
  - [DevOps & Infrastructure](#devops--infrastructure)
  - [Data Science & ML](#data-science--ml)
  - [Design & Accessibility](#design--accessibility)
  - [HR & People Operations](#hr--people-operations)
- [Command Chains & Combinations](#command-chains--combinations)
  - [The Debug → Fix Pipeline](#the-debug--fix-pipeline)
  - [The Scenario → Debug → Fix Pipeline](#the-scenario--debug--fix-pipeline)
  - [The Plan → Loop → Ship Pipeline](#the-plan--loop--ship-pipeline)
  - [The Security → Fix → Ship Pipeline](#the-security--fix--ship-pipeline)
  - [The Full Development Lifecycle](#the-full-development-lifecycle)
- [Advanced Patterns](#advanced-patterns)
  - [Guard Commands](#guard-commands)
  - [Bounded vs Unbounded](#bounded-vs-unbounded)
  - [Custom Verification Scripts](#custom-verification-scripts)
  - [Using with MCP Servers](#using-with-mcp-servers)
  - [CI/CD Integration](#cicd-integration)
- [Writing Great Metrics](#writing-great-metrics)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

---

## What is Autoresearch?

Autoresearch turns [Claude Code](https://docs.anthropic.com/en/docs/claude-code) into an autonomous improvement engine. Based on [Karpathy's autoresearch](https://github.com/karpathy/autoresearch), it follows one simple idea:

**Set a goal. Define a metric. Let Claude loop until it's done.**

Each iteration: make ONE change → measure → keep if better → revert if worse → repeat. Every improvement stacks. Every failure auto-reverts. Everything is logged.

This isn't limited to code. Autoresearch works on anything with a measurable outcome — sales emails, marketing copy, SEO content, test coverage, bundle size, API performance, security posture, and more.

### The 7 Principles

| # | Principle | What It Means |
|---|-----------|---------------|
| 1 | **Constraint = Enabler** | Bounded scope + single metric + time budget = autonomy |
| 2 | **Separate Strategy from Tactics** | You set the GOAL (what/why). Claude handles the HOW |
| 3 | **Metrics Must Be Mechanical** | Numbers only. No "looks good." Pass/fail, measurable, deterministic |
| 4 | **Verification Must Be Fast** | Fast checks = more experiments = better results |
| 5 | **Iteration Cost Shapes Behavior** | 5-min verify = 100 experiments/night. 10-sec verify = 360/hour |
| 6 | **Git as Memory** | Every experiment committed. Claude reads history to learn patterns |
| 7 | **Honest Limitations** | Know what the system can and cannot do |

**Meta-principle:** *Autonomy scales when you constrain scope, clarify success, mechanize verification, and let agents optimize tactics while humans optimize strategy.*

---

## Installation

### Option A — Plugin Install (Recommended)

In Claude Code, run:
```
/plugin marketplace add uditgoenka/autoresearch
/plugin install autoresearch@autoresearch
```

Then run `/reload-plugins` or restart Claude Code. All 7 commands are immediately available.

### Option B — Manual Install (Project-Level)

```bash
git clone https://github.com/uditgoenka/autoresearch.git

# Copy to your project
cp -r autoresearch/skills/autoresearch .claude/skills/autoresearch
cp -r autoresearch/commands/autoresearch .claude/commands/autoresearch
```

### Option C — Manual Install (Global)

```bash
git clone https://github.com/uditgoenka/autoresearch.git

# Copy globally (available in all projects)
cp -r autoresearch/skills/autoresearch ~/.claude/skills/autoresearch
cp -r autoresearch/commands/autoresearch ~/.claude/commands/autoresearch
```

> **Important:** The `commands/` directory is required for subcommands (`/autoresearch:plan`, `/autoresearch:ship`, etc.) to work.

### Verify Installation

Type `/autoresearch` in Claude Code. If you see the interactive setup wizard asking about your goal, you're ready.

---

## Your First Run

### The 60-Second Start

```
/autoresearch
Goal: Increase test coverage from 72% to 90%
Scope: src/**/*.test.ts, src/**/*.ts
Metric: coverage % (higher is better)
Verify: npm test -- --coverage | grep "All files"
```

That's it. Claude reads all files, establishes a baseline, and starts iterating. Walk away.

### The Guided Start (No Config Needed)

Just type:
```
/autoresearch
```

Claude will ask you smart questions based on your codebase:

1. **What's your goal?** — "Increase test coverage", "Reduce bundle size", etc.
2. **Which files can be modified?** — Suggests globs based on your project structure
3. **What metric tells you it's better?** — Suggests metrics from detected tooling
4. **Higher or lower is better?** — Direction of improvement
5. **What command produces the metric?** — Suggests commands, dry-runs to confirm
6. **Any guard command?** — Optional safety net to prevent regressions
7. **Ready to go?** — Launch unlimited, with iteration limit, or cancel

### Don't Know What Metric to Use?

```
/autoresearch:plan
Goal: Make the API respond faster
```

The plan wizard walks you through 5 steps, dry-runs your verify command, and hands you a ready-to-paste configuration.

---

## Core Concepts

### The Loop

Every autoresearch run follows the same cycle:

```
LOOP:
  1. Review — Read current state + git history + results log
  2. Ideate — Pick next change based on past results
  3. Modify — Make ONE focused change
  4. Commit — Git commit (before verification)
  5. Verify — Run mechanical metric
  6. Guard — Run safety command (if set)
  7. Decide — Keep / Discard / Rework
  8. Log — Record result in TSV
  9. Repeat
```

### Metric vs Guard

| | Metric (Verify) | Guard |
|--|-----------------|-------|
| **Purpose** | "Did we improve?" | "Did we break anything?" |
| **Required** | Yes | No (optional) |
| **Example** | `coverage %`, `bundle size KB` | `npm test`, `tsc --noEmit` |
| **On failure** | Revert change | Rework the change (max 2 attempts) |

**When to use Guard:** When your metric is NOT your test suite. If you're optimizing bundle size, performance, or Lighthouse score — set `Guard: npm test` to prevent regressions.

### Results Log

Every iteration is tracked in TSV format:

```tsv
iteration  commit   metric  delta   guard  status    description
0          a1b2c3d  85.2    0.0     -      baseline  initial state
1          b2c3d4e  87.1    +1.9    pass   keep      add auth edge case tests
2          -        86.5    -0.6    -      discard   refactor helpers (broke 2 tests)
3          c3d4e5f  88.3    +1.2    pass   keep      add error handling tests
```

Every 10 iterations, Claude prints a progress summary. Bounded loops print a final summary.

### Bounded vs Unbounded

| Mode | Syntax | Behavior |
|------|--------|----------|
| **Unbounded** | No `Iterations:` | Loops forever until you press `Ctrl+C` |
| **Bounded** | `Iterations: 25` | Loops exactly 25 times, then prints summary |

**When to use what:**

| Scenario | Mode |
|----------|------|
| Overnight improvement run | Unbounded |
| Quick 30-min session | `Iterations: 10` |
| Targeted fix, known scope | `Iterations: 5` |
| Exploratory — testing approach | `Iterations: 15` |
| CI/CD pipeline | `Iterations: N` (based on time budget) |

---

## Command Reference

### /autoresearch — The Loop

The core command. Runs the autonomous modify → verify → keep/discard loop.

**Full syntax:**
```
/autoresearch
Goal: <what you want to improve>
Scope: <file globs that can be modified>
Metric: <what number to track> (<direction>)
Verify: <shell command that outputs the metric>
Guard: <optional command that must always pass>
Iterations: <optional number, omit for unlimited>
```

**Examples:**

```
# Unlimited — loops forever
/autoresearch
Goal: Increase test coverage to 95%
Scope: src/**/*.ts, src/**/*.test.ts
Metric: coverage % (higher is better)
Verify: npm test -- --coverage | grep "All files"
Guard: tsc --noEmit

# Bounded — exactly 20 iterations
/autoresearch
Iterations: 20
Goal: Reduce bundle size below 200KB
Scope: src/**/*.tsx, src/**/*.ts
Metric: bundle size in KB (lower is better)
Verify: npm run build 2>&1 | grep "gzipped"
Guard: npm test

# Refactoring — reduce code while keeping tests green
/autoresearch
Iterations: 15
Goal: Reduce lines of code in utils module by 30%
Scope: src/utils/**/*.ts
Metric: total LOC (lower is better)
Verify: wc -l src/utils/**/*.ts | tail -1
Guard: npm test
```

**What happens during each iteration:**
1. Claude reads the codebase, git history, and past results
2. Picks the highest-impact change based on what worked before
3. Makes ONE atomic change (explainable in one sentence)
4. Commits it (so rollback is clean)
5. Runs your verify command, extracts the metric
6. Runs the guard (if set)
7. If improved + guard passed → keep. If worse → `git revert`. If guard failed → rework (max 2 tries)
8. Logs the result, moves to next iteration

---

### /autoresearch:plan — Setup Wizard

Converts a plain-language goal into a validated, ready-to-execute autoresearch configuration.

**When to use:** You know WHAT you want to improve but aren't sure about scope, metric, or verify command.

**Usage:**
```
/autoresearch:plan
Goal: Make the API respond faster

/autoresearch:plan Increase test coverage to 95%

/autoresearch:plan Reduce bundle size below 200KB
```

**What it does:**
1. Captures your goal
2. Scans your codebase for tooling (test runners, build tools, linters)
3. Suggests scope (file globs), validates they resolve to real files
4. Suggests mechanical metrics, validates they output a number
5. Determines direction (higher/lower is better)
6. Constructs verify command, **dry-runs it** on your current codebase
7. Presents ready-to-paste `/autoresearch` config

**Critical gates:**
- Metric MUST be mechanical (outputs a parseable number)
- Verify command MUST pass a dry run before accepting
- Scope MUST resolve to at least 1 file

---

### /autoresearch:debug — Bug Hunter

Autonomous bug-hunting using scientific method. Doesn't stop at one bug — iteratively hunts ALL bugs.

**When to use:** Something is broken, behaving unexpectedly, or you want a thorough bug sweep.

**Usage:**
```
# Interactive — Claude asks what's broken
/autoresearch:debug

# With context
/autoresearch:debug
Scope: src/api/**/*.ts
Symptom: API returns 500 on POST /users
Iterations: 20

# With auto-fix after finding bugs
/autoresearch:debug --fix
Scope: src/**/*.ts
Iterations: 15
```

**7-Phase process per iteration:**
1. **Gather** — Collect symptoms (run tests, lint, typecheck)
2. **Recon** — Map error surface, trace call chains
3. **Hypothesize** — Form falsifiable, testable hypothesis
4. **Test** — ONE experiment per iteration (binary search, trace execution, minimal reproduction, differential debugging, pattern search, working backwards, rubber duck)
5. **Classify** — Bug confirmed / Hypothesis disproven / Inconclusive / New lead
6. **Log** — Record to `debug-results.tsv` with severity (Critical/High/Medium/Low)
7. **Repeat** — Next hypothesis or new lead

**Every finding requires code evidence** — file:line + reproduction steps. No theoretical fluff.

**Flags:**

| Flag | Purpose |
|------|---------|
| `--fix` | After hunting, auto-switch to `/autoresearch:fix` to repair found bugs |
| `--scope <glob>` | Limit investigation to specific files |
| `--symptom "<text>"` | Pre-fill the symptom description |
| `--severity <level>` | Minimum severity to report (critical, high, medium, low) |

**Output:** Creates `debug/{date}-{slug}/` with `findings.md`, `eliminated.md`, `debug-results.tsv`, `summary.md`

---

### /autoresearch:fix — Error Crusher

Takes a broken state and iteratively repairs it. ONE fix per iteration. Atomic, committed, verified, auto-reverted on failure.

**When to use:** Tests failing, type errors, lint errors, build broken — you want everything green.

**Usage:**
```
# Auto-detect what's broken and fix everything
/autoresearch:fix

# Fix only test failures
/autoresearch:fix --category test
Iterations: 20

# Fix with a guard to prevent regressions
/autoresearch:fix
Guard: npm run build
Iterations: 15

# Chain from debug session — fix what was found
/autoresearch:fix --from-debug
Iterations: 30

# Fix specific target
/autoresearch:fix --target "npm run typecheck"
Iterations: 10
```

**How it works:**
1. **Detect** — Auto-detect failures (build → tests → types → lint → warnings)
2. **Prioritize** — Blockers first (build), then required (tests, types), then polish (lint)
3. **Fix ONE thing** — Atomic change per iteration
4. **Commit** → **Verify** → **Guard** → **Keep/Revert**
5. **Stops automatically** when error count hits zero (even in unbounded mode)

**Flags:**

| Flag | Purpose |
|------|---------|
| `--target <command>` | Explicit verify command |
| `--guard <command>` | Safety command that must always pass |
| `--category <type>` | Only fix specific type: `test`, `type`, `lint`, `build` |
| `--from-debug` | Read findings from latest debug session |

**Anti-patterns it avoids:**
- Never adds `@ts-ignore` or `eslint-disable`
- Never uses `any` type to bypass type errors
- Never deletes failing tests
- Never suppresses lint warnings
- Never uses empty `catch` blocks

**Output:** Creates `fix/{date}-{slug}/` with `fix-results.tsv`, `summary.md`, `blocked.md`

---

### /autoresearch:security — Security Auditor

Comprehensive security audit using STRIDE threat modeling, OWASP Top 10, and red-team adversarial analysis with 4 hostile personas.

**When to use:** Before shipping, during security reviews, for compliance, or regular security hygiene.

**Usage:**
```
# Full audit — keep finding vulnerabilities until interrupted
/autoresearch:security

# Bounded audit
/autoresearch:security
Iterations: 10

# Focused on auth flows
/autoresearch:security
Scope: src/api/**/*.ts, src/middleware/**/*.ts
Focus: authentication and authorization
Iterations: 15

# Delta mode — only audit files changed since last audit
/autoresearch:security --diff

# Auto-fix Critical/High findings after audit
/autoresearch:security --fix
Iterations: 15

# CI/CD gate — fail if any Critical findings exist
/autoresearch:security --fail-on critical
Iterations: 10
```

**7-Phase architecture:**
1. **Codebase Recon** — Scan tech stack, dependencies, configs, routes
2. **Asset Identification** — Catalog data stores, auth, APIs, user inputs
3. **Trust Boundary Mapping** — Browser↔Server, Public↔Auth, User↔Admin
4. **STRIDE Threat Model** — Spoofing, Tampering, Repudiation, Info Disclosure, DoS, Elevation of Privilege
5. **Attack Surface Map** — Entry points, data flows, abuse paths
6. **Autonomous Loop** — Iteratively test each vector, validate with code evidence
7. **Final Report** — Severity-ranked findings with mitigations

**4 Red-Team Personas:**
- **Security Adversary** — Auth bypass, injection, data exposure
- **Supply Chain Attacker** — Dependency vulns, CI/CD weaknesses
- **Insider Threat** — Privilege escalation, data exfiltration
- **Infrastructure Attacker** — Container escape, network segmentation

**Flags:**

| Flag | Purpose |
|------|---------|
| `--diff` | Only audit files changed since last audit |
| `--fix` | Auto-fix confirmed Critical/High findings |
| `--fail-on <severity>` | Exit non-zero for CI/CD gating |

**Output:** Creates `security/{date}-{slug}/` with 7 structured reports + TSV log

---

### /autoresearch:ship — Shipping Workflow

Ship anything through 8 phases: Identify → Inventory → Checklist → Prepare → Dry-run → Ship → Verify → Log.

**When to use:** Ready to deploy, publish, merge, send, or release something.

**Usage:**
```
# Auto-detect and ship (interactive)
/autoresearch:ship

# Ship code PR with auto-approve
/autoresearch:ship --auto

# Dry-run a deployment
/autoresearch:ship --type deployment --dry-run

# Ship with post-deploy monitoring
/autoresearch:ship --monitor 10

# Just check if something is ready
/autoresearch:ship --checklist-only

# Ship a blog post
/autoresearch:ship --type content
Target: content/blog/my-new-post.md

# Rollback a bad deployment
/autoresearch:ship --rollback
```

**9 supported types:**

| Type | Ship Action |
|------|-------------|
| `code-pr` | Create PR with full description |
| `code-release` | Git tag + GitHub release |
| `deployment` | CI/CD trigger, kubectl, deploy branch |
| `content` | Publish via CMS, content branch |
| `marketing-email` | Send via ESP (SendGrid, Mailchimp) |
| `marketing-campaign` | Activate ads, launch landing page |
| `sales` | Send proposal, share deck |
| `research` | Upload, submit paper |
| `design` | Export assets, share with stakeholders |

**Flags:**

| Flag | Purpose |
|------|---------|
| `--dry-run` | Validate without shipping |
| `--auto` | Auto-approve if no errors |
| `--force` | Skip non-critical items (blockers enforced) |
| `--rollback` | Undo last ship action |
| `--monitor N` | Post-ship monitoring for N minutes |
| `--type <type>` | Override auto-detection |
| `--checklist-only` | Only generate checklist |

---

### /autoresearch:scenario — Scenario Explorer

Autonomous scenario exploration engine. Takes a seed scenario and generates situations across 12 dimensions — discovering edge cases manual analysis misses.

**When to use:** Feature planning, test case generation, threat modeling, UX research, business analysis.

**Usage:**
```
# Interactive — Claude asks about your scenario
/autoresearch:scenario

# With full context
/autoresearch:scenario
Scenario: User attempts checkout with multiple payment methods
Domain: software
Depth: standard
Iterations: 25

# Quick edge case scan
/autoresearch:scenario --depth shallow --focus edge-cases
Scenario: File upload feature

# Security-focused
/autoresearch:scenario --domain security
Scenario: OAuth2 login flow
Iterations: 30

# Generate test scenarios
/autoresearch:scenario --format test-scenarios
Scenario: REST API pagination with filtering
```

**12 exploration dimensions:**

| # | Dimension | What It Explores |
|---|-----------|-----------------|
| 1 | Happy path | Normal successful flows |
| 2 | Error | Expected failure modes |
| 3 | Edge case | Boundary conditions, limits |
| 4 | Abuse | Malicious/unintended usage |
| 5 | Scale | High volume, large data |
| 6 | Concurrent | Race conditions, parallel access |
| 7 | Temporal | Timing, scheduling, timeouts |
| 8 | Data variation | Different formats, encodings, types |
| 9 | Permission | Access control, roles |
| 10 | Integration | Third-party interactions |
| 11 | Recovery | Crash recovery, retry logic |
| 12 | State transition | State machine edge cases |

**5 domains:** software, product, business, security, marketing — each with tailored dimension priorities.

**Flags:**

| Flag | Purpose |
|------|---------|
| `--domain <type>` | software, product, business, security, marketing |
| `--depth <level>` | shallow (10), standard (25), deep (50+) |
| `--scope <glob>` | Limit to specific files/features |
| `--format <type>` | use-cases, user-stories, test-scenarios, threat-scenarios |
| `--focus <area>` | edge-cases, failures, security, scale |

---

## Scenarios by Domain

### Software Engineering

#### Increase Test Coverage

```
/autoresearch
Goal: Increase test coverage from 72% to 90%
Scope: src/**/*.test.ts, src/**/*.ts
Metric: coverage % (higher is better)
Verify: npm test -- --coverage | grep "All files"
Iterations: 30
```

Claude adds tests one-by-one. Each iteration: write test → run coverage → keep if % increased → discard if not.

#### Reduce Bundle Size

```
/autoresearch
Goal: Reduce production bundle size below 200KB
Scope: src/**/*.tsx, src/**/*.ts
Metric: bundle size in KB (lower is better)
Verify: npm run build 2>&1 | grep "gzipped"
Guard: npm test
Iterations: 20
```

Claude tree-shakes, lazy-loads, code-splits — one optimization per iteration, never breaking tests.

#### Improve API Performance

```
/autoresearch
Goal: Reduce p95 API response time to under 100ms
Scope: src/api/**/*.ts, src/middleware/**/*.ts
Metric: p95 latency in ms (lower is better)
Verify: npm run bench:api | grep "p95"
Guard: npm test
Iterations: 25
```

#### Reduce Technical Debt

```
/autoresearch
Goal: Eliminate all TypeScript 'any' types
Scope: src/**/*.ts
Metric: count of 'any' occurrences (lower is better)
Verify: grep -r "any" src/ --include="*.ts" | wc -l
Guard: tsc --noEmit
Iterations: 40
```

#### Refactor Large Module

```
/autoresearch
Goal: Reduce utils module from 800 to under 300 LOC
Scope: src/utils/**/*.ts
Metric: total LOC (lower is better)
Verify: wc -l src/utils/**/*.ts | tail -1
Guard: npm test
Iterations: 20
```

#### Improve Lighthouse Score

```
/autoresearch
Goal: Achieve Lighthouse performance score of 95+
Scope: src/components/**/*.tsx, src/pages/**/*.tsx
Metric: Lighthouse performance score (higher is better)
Verify: npx lighthouse http://localhost:3000 --output=json --quiet | jq '.categories.performance.score * 100'
Guard: npm test
Iterations: 15
```

---

### Debugging & Bug Fixing

#### Find All Bugs in a Module

```
/autoresearch:debug
Scope: src/api/**/*.ts
Symptom: Multiple 500 errors in production logs
Iterations: 20
```

#### Debug Then Auto-Fix

```
/autoresearch:debug --fix
Scope: src/auth/**/*.ts
Symptom: Login fails intermittently
Iterations: 30
```

This runs debug first to find all bugs, then automatically switches to fix mode.

#### Fix All Test Failures

```
/autoresearch:fix
Iterations: 25
```

Auto-detects failing tests, fixes them one-by-one, stops when all pass.

#### Fix Only Type Errors

```
/autoresearch:fix --category type
Guard: npm test
Iterations: 15
```

#### Fix Build Failures

```
/autoresearch:fix --target "npm run build"
Iterations: 10
```

#### Fix from Debug Findings

```
# Step 1: Find bugs
/autoresearch:debug
Scope: src/**/*.ts
Iterations: 15

# Step 2: Fix what was found
/autoresearch:fix --from-debug
Iterations: 30
```

---

### Sales & Lead Generation

#### Optimize Cold Email Response Rate

```
/autoresearch
Goal: Increase cold email reply rate from 3% to 8%
Scope: emails/cold-outreach/**/*.md
Metric: reply rate % (higher is better)
Verify: python scripts/email-metrics.py --campaign cold-q1 | grep "reply_rate"
Iterations: 25
```

Claude iterates on subject lines, opening hooks, CTAs, personalization — one change per version.

#### Improve Sales Proposal Win Rate

```
/autoresearch
Goal: Increase proposal close rate by improving clarity and value prop
Scope: proposals/template.md, proposals/pricing.md
Metric: word count of value-prop section / total word count ratio (higher is better)
Verify: python scripts/proposal-metrics.py | grep "value_density"
Iterations: 15
```

#### Optimize Follow-Up Sequences

```
/autoresearch
Goal: Reduce average days-to-response in follow-up sequence
Scope: emails/followup-sequence/**/*.md
Metric: average response time in days (lower is better)
Verify: python scripts/sequence-metrics.py | grep "avg_days"
Iterations: 20
```

#### Ship a Sales Deck

```
/autoresearch:ship --type sales
Target: decks/q1-enterprise-proposal.pdf
```

Checklist: prospect name correct, pricing current, contact info accurate, branding consistent, CTA clear, case studies current.

#### Generate Sales Scenarios

```
/autoresearch:scenario --domain business
Scenario: Enterprise customer evaluates our SaaS vs competitors during procurement
Depth: deep
Iterations: 30
```

Explores: happy path (buy), error (wrong pricing), edge case (legal objections), abuse (competitor sabotage), temporal (budget cycle timing), permission (multi-stakeholder approval).

---

### SEO & Content Marketing

#### Improve Blog Post SEO Score

```
/autoresearch
Goal: Achieve SEO readability score of 90+ for all blog posts
Scope: content/blog/**/*.md
Metric: average readability score (higher is better)
Verify: python scripts/seo-readability.py | grep "avg_score"
Iterations: 30
```

#### Increase Content Word Count & Depth

```
/autoresearch
Goal: Increase average blog post depth score
Scope: content/blog/pillar-posts/**/*.md
Metric: content depth score (higher is better)
Verify: python scripts/content-depth.py --dir content/blog/pillar-posts | grep "depth_score"
Iterations: 20
```

#### Optimize Meta Descriptions

```
/autoresearch
Goal: Ensure all meta descriptions are under 160 chars and contain target keyword
Scope: content/**/*.md
Metric: compliant meta descriptions count (higher is better)
Verify: python scripts/meta-audit.py | grep "compliant"
Iterations: 15
```

#### Ship Blog Content

```
/autoresearch:ship --type content
Target: content/blog/ultimate-guide-to-autoresearch.md
```

Checklist: title present, no broken links, images have alt text, meta description <160 chars, no placeholder text, grammar check passes.

#### Explore Content Scenarios

```
/autoresearch:scenario --domain marketing
Scenario: User discovers our product through a Google search for "autonomous code improvement"
Depth: standard
Iterations: 20
```

---

### Marketing & Growth

#### Optimize Email Campaign Click Rate

```
/autoresearch
Goal: Increase email click-through rate from 2.1% to 4%
Scope: campaigns/email/**/*.html
Metric: predicted click-through rate (higher is better)
Verify: python scripts/email-score.py --template campaigns/email/launch.html | grep "predicted_ctr"
Iterations: 25
```

#### Improve Landing Page Conversion

```
/autoresearch
Goal: Improve landing page conversion copy
Scope: pages/landing/**/*.md, pages/landing/**/*.tsx
Metric: conversion score (higher is better)
Verify: python scripts/conversion-audit.py | grep "score"
Guard: npm test
Iterations: 20
```

#### Optimize Ad Copy

```
/autoresearch
Goal: Maximize ad copy engagement score
Scope: campaigns/ads/**/*.md
Metric: engagement score (higher is better)
Verify: python scripts/ad-score.py | grep "engagement"
Iterations: 30
```

#### Ship Marketing Campaign

```
/autoresearch:ship --type marketing-campaign
```

Checklist: creative assets finalized, tracking pixels configured, audience segmented, budget approved, landing page live, A/B variants set.

#### Ship Marketing Email

```
/autoresearch:ship --type marketing-email
Target: campaigns/email/product-launch.html
```

Checklist: subject line <60 chars, preview text set, links working + tracked, unsubscribe link present, physical address (CAN-SPAM), responsive on mobile.

---

### Web Scraping & Data Collection

#### Improve Scraper Success Rate

```
/autoresearch
Goal: Increase scraper success rate from 85% to 99%
Scope: scrapers/**/*.py
Metric: success rate % (higher is better)
Verify: python scripts/scraper-test.py --sample 100 | grep "success_rate"
Guard: python -m pytest tests/scrapers/
Iterations: 25
```

Claude iterates on retry logic, selector resilience, timeout handling, rate limiting — one improvement per iteration.

#### Reduce Scraping Time

```
/autoresearch
Goal: Reduce average scrape time per page from 3s to 1s
Scope: scrapers/**/*.py
Metric: avg time per page in seconds (lower is better)
Verify: python scripts/scraper-bench.py | grep "avg_time"
Guard: python -m pytest tests/scrapers/
Iterations: 20
```

#### Debug Scraper Failures

```
/autoresearch:debug
Scope: scrapers/**/*.py
Symptom: Scraper fails on paginated results after page 5
Iterations: 10
```

#### Explore Scraping Edge Cases

```
/autoresearch:scenario --domain software --focus edge-cases
Scenario: Web scraper encounters various anti-bot measures and dynamic content
Iterations: 25
```

Explores: CAPTCHAs, rate limiting, IP blocking, JavaScript rendering, infinite scroll, login walls, A/B test variants, geo-blocking.

---

### Research & Analysis

#### Improve Research Paper Clarity

```
/autoresearch
Goal: Improve research paper readability and structure
Scope: papers/draft/**/*.md
Metric: readability score (higher is better)
Verify: python scripts/readability.py papers/draft/ | grep "score"
Iterations: 20
```

#### Ship Research Paper

```
/autoresearch:ship --type research
Target: papers/final/autonomous-iteration-patterns.pdf
```

Checklist: abstract present, citations formatted, data sources linked, methodology complete, figures labeled, conclusion addresses hypothesis.

#### Systematic Literature Review

```
/autoresearch:scenario --domain product --format use-cases
Scenario: Researcher surveys autonomous iteration techniques across ML, software engineering, and content optimization
Depth: deep
Iterations: 40
```

---

### DevOps & Infrastructure

#### Reduce Deployment Time

```
/autoresearch
Goal: Reduce CI/CD pipeline time from 12 min to under 5 min
Scope: .github/workflows/**/*.yml, Dockerfile, docker-compose.yml
Metric: pipeline duration in minutes (lower is better)
Verify: gh run list --limit 1 --json databaseId -q '.[0].databaseId' | xargs -I{} gh run view {} --json updatedAt,createdAt --jq 'def diff: ((.updatedAt|fromdate) - (.createdAt|fromdate)) / 60; diff'
Iterations: 15
```

#### Improve Container Image Size

```
/autoresearch
Goal: Reduce Docker image size below 100MB
Scope: Dockerfile, .dockerignore
Metric: image size in MB (lower is better)
Verify: docker build -t app:test . && docker images app:test --format '{{.Size}}'
Guard: docker run app:test npm test
Iterations: 10
```

#### Fix CI/CD Pipeline Failures

```
/autoresearch:fix --target "gh workflow run ci.yml && sleep 60 && gh run list --limit 1 --json conclusion -q '.[0].conclusion'"
Iterations: 10
```

#### Security Audit Infrastructure

```
/autoresearch:security
Scope: .github/workflows/**/*.yml, Dockerfile, docker-compose.yml, k8s/**/*.yaml
Focus: CI/CD security, container security, secrets management
Iterations: 15
```

#### Ship a Deployment

```
/autoresearch:ship --type deployment --monitor 10
```

Runs all checks, deploys, then monitors for 10 minutes post-deploy.

---

### Data Science & ML

#### Improve Model Accuracy

```
/autoresearch
Goal: Improve validation accuracy from 0.87 to 0.93
Scope: train.py, model.py, data_utils.py
Metric: val_accuracy (higher is better)
Verify: python train.py --epochs 5 --quick-eval | grep "val_accuracy"
Iterations: 50
```

This is the classic Karpathy use case — overnight autonomous model improvement.

#### Reduce Inference Time

```
/autoresearch
Goal: Reduce inference time below 10ms
Scope: model.py, inference.py
Metric: inference time in ms (lower is better)
Verify: python benchmark.py | grep "avg_inference_ms"
Guard: python -m pytest tests/model/
Iterations: 20
```

#### Optimize Data Pipeline

```
/autoresearch
Goal: Reduce data processing time for 1M rows
Scope: pipeline/**/*.py
Metric: processing time in seconds (lower is better)
Verify: python pipeline/benchmark.py | grep "total_seconds"
Guard: python -m pytest tests/pipeline/
Iterations: 15
```

---

### Design & Accessibility

#### Improve Accessibility Score

```
/autoresearch
Goal: Achieve WCAG AA compliance (0 violations)
Scope: src/components/**/*.tsx
Metric: accessibility violations count (lower is better)
Verify: npx axe-cli http://localhost:3000 --exit | grep "violations"
Guard: npm test
Iterations: 25
```

#### Improve Color Contrast

```
/autoresearch
Goal: All text meets 4.5:1 contrast ratio
Scope: src/styles/**/*.css, src/components/**/*.tsx
Metric: contrast failures count (lower is better)
Verify: npx pa11y http://localhost:3000 --standard WCAG2AA | grep -c "WCAG2AA"
Iterations: 15
```

#### Ship Design Assets

```
/autoresearch:ship --type design
Target: design/v2-dashboard-mockups/
```

Checklist: all formats exported, responsive variants, color contrast WCAG AA, no placeholder images, source files organized, brand guidelines followed.

---

### HR & People Operations

#### Optimize Job Description Clarity

```
/autoresearch
Goal: Improve job description clarity score
Scope: recruiting/descriptions/**/*.md
Metric: clarity score (higher is better)
Verify: python scripts/jd-score.py | grep "avg_clarity"
Iterations: 15
```

#### Improve Onboarding Documentation

```
/autoresearch
Goal: Reduce onboarding doc average reading time
Scope: docs/onboarding/**/*.md
Metric: estimated reading time in minutes (lower is better)
Verify: python scripts/reading-time.py docs/onboarding/ | grep "avg_minutes"
Iterations: 20
```

#### Explore Hiring Scenarios

```
/autoresearch:scenario --domain business
Scenario: Senior engineer candidate goes through our 4-stage interview process
Depth: deep
Iterations: 25
```

---

## Command Chains & Combinations

The real power of autoresearch comes from chaining commands together. Each command's output feeds the next.

### The Debug → Fix Pipeline

**Use when:** Something is broken and you want it found AND fixed.

```
# Step 1: Find all bugs (15 iterations of investigation)
/autoresearch:debug
Scope: src/**/*.ts
Symptom: Multiple test failures after dependency upgrade
Iterations: 15

# Step 2: Fix everything found (30 iterations of repairs)
/autoresearch:fix --from-debug
Guard: npm test
Iterations: 30
```

**Or use the shortcut:**
```
/autoresearch:debug --fix
Scope: src/**/*.ts
Iterations: 30
```

This automatically transitions from debug to fix mode after finding bugs.

### The Scenario → Debug → Fix Pipeline

**Use when:** You want to discover edge cases, then find bugs in them, then fix them.

```
# Step 1: Discover edge cases (25 iterations)
/autoresearch:scenario --domain software --focus edge-cases
Scenario: User uploads files through the drag-and-drop interface
Iterations: 25

# Step 2: Hunt bugs in discovered scenarios (15 iterations)
/autoresearch:debug
Scope: src/upload/**/*.ts
Symptom: Edge cases from scenario exploration — concurrent uploads, large files, network interruptions
Iterations: 15

# Step 3: Fix what was found (20 iterations)
/autoresearch:fix --from-debug
Guard: npm test
Iterations: 20
```

### The Plan → Loop → Ship Pipeline

**Use when:** Starting a new improvement initiative from scratch.

```
# Step 1: Figure out the right config
/autoresearch:plan
Goal: Improve API response times across all endpoints

# Step 2: Run the loop (plan wizard gives you the exact config)
/autoresearch
Iterations: 50
Goal: Reduce p95 API response time to under 100ms
Scope: src/api/**/*.ts
Metric: p95 latency in ms (lower is better)
Verify: npm run bench:api | grep "p95"
Guard: npm test

# Step 3: Ship the improvements
/autoresearch:ship --type code-pr --auto
```

### The Security → Fix → Ship Pipeline

**Use when:** Pre-release security hardening.

```
# Step 1: Find vulnerabilities (15 iterations)
/autoresearch:security
Scope: src/**/*.ts
Iterations: 15

# Step 2: Auto-fix Critical and High findings (20 iterations)
/autoresearch:fix --from-debug
Guard: npm test
Iterations: 20

# Step 3: Re-audit to confirm fixes (10 iterations)
/autoresearch:security --diff
Iterations: 10

# Step 4: Ship when clean
/autoresearch:ship --type code-release
```

**Or use the shortcut:**
```
# Combined: audit + auto-fix + CI gate
/autoresearch:security --fix --fail-on critical
Iterations: 25
```

### The Full Development Lifecycle

**Use when:** Building a feature from conception to shipping.

```
# 1. Explore scenarios and edge cases
/autoresearch:scenario --domain software --depth deep
Scenario: New payment processing feature with multiple providers
Iterations: 30

# 2. Plan the improvement approach
/autoresearch:plan
Goal: Implement payment processing with 95%+ test coverage

# 3. Build iteratively with test coverage as metric
/autoresearch
Iterations: 50
Goal: Increase payment module test coverage to 95%
Scope: src/payments/**/*.ts, src/payments/**/*.test.ts
Metric: coverage % (higher is better)
Verify: npm test -- --coverage --collectCoverageFrom='src/payments/**' | grep "All files"

# 4. Security audit the payment code
/autoresearch:security
Scope: src/payments/**/*.ts
Focus: Payment processing, PCI DSS, data encryption
Iterations: 15

# 5. Fix any security findings
/autoresearch:fix --from-debug
Guard: npm test
Iterations: 20

# 6. Ship it
/autoresearch:ship --type code-pr
```

### More Chain Patterns

| Chain | When to Use |
|-------|-------------|
| `plan → loop` | Starting a new metric improvement |
| `debug → fix` | Bug is known, needs finding and fixing |
| `scenario → debug` | Feature works but you want edge case coverage |
| `security → fix → security` | Harden, fix, verify fixes |
| `loop → ship` | Optimization complete, time to deploy |
| `scenario → loop` | Discover use cases, then optimize for them |
| `debug → fix → ship` | Production issue: find, fix, deploy |
| `plan → loop → security → ship` | Full feature lifecycle |
| `scenario → security` | Threat modeling from user scenarios |
| `fix → loop → ship` | Fix blockers, then improve, then deploy |

---

## Advanced Patterns

### Guard Commands

Guards prevent regressions while you optimize a different metric.

```
# Optimize bundle size WITHOUT breaking tests
/autoresearch
Goal: Reduce bundle size
Verify: npm run build 2>&1 | grep "gzipped"
Guard: npm test

# Optimize performance WITHOUT breaking types
/autoresearch
Goal: Reduce response time
Verify: npm run bench | grep "p95"
Guard: tsc --noEmit && npm test

# Optimize Lighthouse WITHOUT breaking e2e tests
/autoresearch
Goal: Improve Lighthouse performance to 95+
Verify: npx lighthouse http://localhost:3000 --output=json --quiet | jq '.categories.performance.score * 100'
Guard: npx playwright test
```

**How guard recovery works:**
1. Metric improves, but guard fails
2. Claude reverts the change
3. Reads guard output to understand what broke
4. Reworks the optimization to avoid the regression (max 2 attempts)
5. If 2 attempts fail → discard and move on

### Custom Verification Scripts

For complex metrics, write a custom script:

```python
#!/usr/bin/env python3
# scripts/verify-coverage.py
import subprocess, re, sys

result = subprocess.run(
    ["npm", "test", "--", "--coverage"],
    capture_output=True, text=True
)

match = re.search(r'All files\s*\|\s*([\d.]+)', result.stdout)
if match:
    print(f"coverage: {match.group(1)}")
    sys.exit(0)
else:
    print("coverage: 0")
    sys.exit(1)
```

Then use it:
```
/autoresearch
Verify: python scripts/verify-coverage.py | grep "coverage"
```

**Rules for custom verify scripts:**
- Must output a parseable number
- Must be deterministic (same input = same output)
- Must be fast (<30 seconds)
- Must exit 0 on success, non-zero on failure

### Using with MCP Servers

Any MCP server configured in Claude Code is available during the loop.

```
# Database-aware optimization — query real data during iterations
/autoresearch
Goal: Reduce average query time for dashboard queries
Scope: src/queries/**/*.sql, src/api/dashboard/**/*.ts
Metric: avg query time in ms (lower is better)
Verify: psql -c "SELECT avg(duration_ms) FROM query_log WHERE created_at > now() - interval '5 min'" | grep -oP '\d+\.\d+'
Guard: npm test

# Analytics-driven content optimization
/autoresearch
Goal: Improve top 10 blog posts by engagement score
Scope: content/blog/**/*.md
Metric: avg engagement score (higher is better)
Verify: python scripts/analytics-score.py --top 10 | grep "avg_engagement"
```

### CI/CD Integration

```yaml
# .github/workflows/autoresearch-security.yml
name: Security Gate
on: [pull_request]
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Security audit
        run: |
          claude "/autoresearch:security --fail-on critical --diff"
          # Exits non-zero if Critical findings exist
```

```yaml
# .github/workflows/autoresearch-fix.yml
name: Auto-Fix
on:
  workflow_dispatch:
    inputs:
      iterations:
        description: 'Number of fix iterations'
        default: '20'
jobs:
  fix:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Auto-fix
        run: |
          claude "/autoresearch:fix Iterations: ${{ inputs.iterations }}"
```

---

## Writing Great Metrics

The quality of your metric determines the quality of your results. Here's how to write metrics that work.

### The 4 Rules

1. **Mechanical** — Outputs a parseable number. No "looks good"
2. **Deterministic** — Same input = same output. No randomness
3. **Fast** — Under 30 seconds. Faster = more experiments
4. **Extractable** — Can be piped through grep/awk/jq to get the number

### Metric Cheat Sheet

| Domain | Metric | Direction | Verify Command |
|--------|--------|-----------|----------------|
| Testing | Coverage % | Higher | `npm test -- --coverage \| grep "All files"` |
| Testing | Passing tests count | Higher | `npm test 2>&1 \| grep "Tests:"` |
| Bundle | Size in KB | Lower | `npm run build 2>&1 \| grep "gzipped"` |
| Performance | p95 latency ms | Lower | `npm run bench \| grep "p95"` |
| Performance | Lighthouse score | Higher | `npx lighthouse URL --output=json \| jq '.categories.performance.score * 100'` |
| Code quality | `any` count | Lower | `grep -r "any" src/ --include="*.ts" \| wc -l` |
| Code quality | Lint errors | Lower | `npx eslint src/ 2>&1 \| grep "problems"` |
| Code quality | LOC | Lower | `wc -l src/**/*.ts \| tail -1` |
| Code quality | Complexity | Lower | `npx complexity-report src/ \| grep "avg"` |
| Build | Build time (s) | Lower | `time npm run build 2>&1 \| grep real` |
| Content | Readability score | Higher | `python scripts/readability.py \| grep "score"` |
| Content | Word count | Higher | `wc -w content/**/*.md \| tail -1` |
| SEO | Meta compliance count | Higher | `python scripts/meta-audit.py \| grep "compliant"` |
| Accessibility | Violations count | Lower | `npx axe-cli URL \| grep "violations"` |
| Docker | Image size MB | Lower | `docker images app:test --format '{{.Size}}'` |
| CI/CD | Pipeline duration min | Lower | Custom script via `gh` CLI |
| Security | OWASP coverage % | Higher | Composite (built-in to security command) |
| ML | Validation accuracy | Higher | `python train.py --eval \| grep "val_acc"` |
| ML | Inference time ms | Lower | `python benchmark.py \| grep "avg_ms"` |

### Bad Metrics (Avoid These)

| Bad Metric | Why It's Bad | Better Alternative |
|------------|--------------|-------------------|
| "Code looks cleaner" | Subjective, not mechanical | Lint error count (lower) |
| "Feels faster" | No number, not verifiable | p95 latency in ms |
| "Better test quality" | Can't measure quality directly | Coverage %, mutation score |
| "More readable" | Subjective | Readability score (Flesch-Kincaid) |
| Random test output | Non-deterministic | Retry 3x, take median |

---

## Troubleshooting

### Common Issues

| Problem | Cause | Fix |
|---------|-------|-----|
| "Verify command failed" | Command doesn't work on current codebase | Run the command manually first. Use `/autoresearch:plan` to validate |
| Metric doesn't improve | Scope too narrow, or already near optimal | Expand scope, lower the goal, or try a different approach |
| Guard keeps failing | Changes are breaking existing behavior | Make scope more targeted, or add the broken tests to scope |
| "5+ consecutive discards" | Stuck in local minimum | Claude will automatically try radical changes. If still stuck, expand scope |
| Loop seems slow | Verify command takes too long | Optimize verify command (use `--quick-eval`, reduce test scope) |
| Wrong metric extracted | Verify output format changed | Check verify command output manually, adjust grep pattern |

### When Stuck

If Claude has 5+ consecutive discards, it automatically:
1. Re-reads ALL in-scope files
2. Re-reads original goal
3. Reviews entire results log for patterns
4. Tries combining 2-3 successful changes
5. Tries the OPPOSITE of what hasn't worked
6. Tries radical architectural change

### Crash Recovery

| Failure Type | Automatic Response |
|--------------|-------------------|
| Syntax error | Fix immediately, don't count as iteration |
| Runtime error | Attempt fix (max 3 tries), then move on |
| Resource exhaustion | Revert, try smaller variant |
| Infinite loop / hang | Kill after timeout, revert |
| External dependency failure | Skip, log, try different approach |

---

## FAQ

**Q: I don't know what metric to use.**
A: Run `/autoresearch:plan` — it analyzes your codebase, suggests metrics, and dry-runs the verify command before you launch.

**Q: Does this work with any project?**
A: Yes. Any language, framework, or domain. If you can measure it with a command, autoresearch can optimize it.

**Q: How do I stop the loop?**
A: `Ctrl+C` or add `Iterations: N` for bounded runs. Claude commits before verifying, so your last successful state is always in git.

**Q: Can I use this for non-code tasks?**
A: Absolutely. Sales emails, marketing copy, HR policies, research papers — anything with a measurable metric.

**Q: Does /autoresearch:security modify my code?**
A: No. It's read-only. Use `--fix` to opt into auto-remediation of confirmed Critical/High findings.

**Q: Can I chain commands?**
A: Yes. Run `debug → fix → ship`, or `plan → loop → ship`, or `scenario → debug → fix`. Each command's output feeds the next. See [Command Chains](#command-chains--combinations).

**Q: What's the difference between Metric and Guard?**
A: Metric = "did we improve?" (the goal). Guard = "did we break anything?" (safety net). If metric improves but guard fails, Claude reworks the change.

**Q: Can I use MCP servers during the loop?**
A: Yes. Any MCP server configured in Claude Code is available — databases, analytics, APIs, etc.

**Q: How many iterations should I run?**
A: Depends on scope. 5-10 for targeted fixes. 15-25 for moderate improvements. 50+ for deep optimization. Unlimited for overnight runs.

**Q: Does it work in CI/CD?**
A: Yes. Use `--fail-on` (security) or bounded iterations. See [CI/CD Integration](#cicd-integration).

**Q: What if Claude makes things worse?**
A: Every change is committed before verification. If worse, it's instantly `git revert`ed. Your codebase is always in a known-good state.

**Q: Can I run it overnight?**
A: Yes. That's the intended use case for unbounded mode. Run `/autoresearch` without `Iterations:`, walk away, review results in the morning.

**Q: What languages are supported?**
A: All of them. The loop is language-agnostic. The verify command adapts to your tooling (npm, pytest, cargo, go test, etc.).

---

<div align="center">

**Built by [Udit Goenka](https://udit.co)** | [GitHub](https://github.com/uditgoenka/autoresearch) | [Follow @iuditg](https://x.com/iuditg)

*"Set the GOAL → Claude runs the LOOP → You wake up to results"*

</div>
