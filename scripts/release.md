# Release Process

## Versioning Scheme

| Type | Pattern | When to use | Example |
|------|---------|-------------|---------|
| **Patch** | `v1.6.X` | Bugfixes, typos, small updates, dependency bumps | `v1.6.2` |
| **Minor** | `v1.X.0` | New features, new commands, significant changes | `v1.7.0` |
| **Major** | `vX.0.0` | Reserved for v2+ (breaking changes, full rewrites) | `v2.0.0` |

## Quick Reference

```bash
# Patch release (bugfix)
./scripts/release.sh 1.6.2 --title "Fix scenario timeout handling"

# Minor release (new feature)
./scripts/release.sh 1.7.0 --title "New Feature Name"
```

## What the Script Does

```
[1/6] Create release branch (release/X.Y.Z)
[2/6] Bump versions:
      → .claude-plugin/plugin.json  (version field)
      → README.md                   (version badge)
      → GUIDE.md                    (version badge)
[3/6] Pause for doc review:
      → Shows changelog since last tag
      → Prompts you to review README.md, GUIDE.md, EXAMPLES.md, CONTRIBUTING.md
      → You can edit in another terminal, then continue
[4/6] Commit all release changes
[5/6] Push branch + create PR against master
[6/6] Wait for your "merge" confirmation:
      → Merges PR
      → Tags the merge commit
      → Creates GitHub release with auto-generated notes
```

## Pre-Release Checklist

Before running the script, verify:

- [ ] All tests pass
- [ ] No uncommitted changes in working tree
- [ ] You're on the `master` branch
- [ ] `gh` CLI is authenticated

## Doc Review Guide

At step [3/6], the script pauses and shows the changelog. Review these files:

### README.md
- **Version badge** (auto-updated by script)
- **Commands table** — any new commands added?
- **Quick Decision Guide** — new use cases?
- **Repository Structure** — new files in the tree?
- **FAQ** — new questions from issues/discussions?

### GUIDE.md
- **Version badge** (must match release version)
- **Command Reference** — any new commands or flags?
- **Domain Scenarios** — new domain examples to add?
- **Command Chains** — new chain patterns possible?
- **Metric Cheat Sheet** — new verify commands to add?

### EXAMPLES.md
- **Version tags in headers** — e.g., `(v1.7.0)` for new features
- **New command examples** — did you add a new `/autoresearch:*` command?
- **New domain examples** — any real-world examples to add?
- **Flag documentation** — new flags for existing commands?

### CONTRIBUTING.md
- **Repository Structure** — does the tree reflect new files?
- **What Each File Does** — any new files to document?
- **Adding a New Sub-Command** — steps still accurate?
- **High-Value Contributions** — new contribution types?

### Tips
- Edit docs in another terminal while the script is paused
- Type `skip` at the prompt to continue without doc changes
- The script stages any doc changes automatically (README.md, GUIDE.md, EXAMPLES.md, CONTRIBUTING.md)

## Abort and Resume

If you type `abort` at the merge prompt:
```bash
# The PR stays open. Merge later with:
gh pr merge <PR_URL> --merge --delete-branch

# Or clean up:
git checkout master && git branch -D release/X.Y.Z
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| "Working tree is dirty" | Commit or stash changes first |
| "Must be on master branch" | `git checkout master` |
| "gh CLI not found" | Install from https://cli.github.com |
| PR merge conflicts | Resolve on the PR, then re-run merge step manually |
| Forgot to update docs | Edit on the PR branch, push, then merge |
