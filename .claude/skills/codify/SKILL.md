---
name: codify
description: Extract one lesson from recent work and propose where it belongs (CLAUDE.md, rule, docs, test, or skill). Use after finishing a task or fixing a mistake.
allowed-tools: Bash(git *), Read, Edit
---

## Inputs (auto-injected)
- Diff: !`git diff origin/main...HEAD`
- Existing path-scoped rules: !`ls .claude/rules/ 2>/dev/null`

## Workflow
1. Identify the single most impactful lesson from this work
2. Classify it as hard rule | scoped rule | docs entry | test | skill
3. Propose the exact diff. Wait for approval before applying
4. If approved, apply, then suggest pruning anything in CLAUDE.md this supersedes
