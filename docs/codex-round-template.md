# Codex Round Template

This template is informational only; no script consumes or validates it. It mirrors the writer's render order so humans can inspect the codex sub-agent round-file shape in one place.

````markdown
---
type: round-memory
session-id: <slug>
project: <X>
round: <N>-codex-<stage>-r<n>
created: <timestamp>
---

# <one-line summary or Codex CXMem emissions>

## Codex prompt (rendered)

```text
<verbatim bytes of the prompt handed to codex exec>
```

## Codex output (verbatim)

```text
<verbatim bytes of clean codex stdout>
```

## Reviewer 2nd-opinion

<verdict>

<full review body for --reviewer-review, when present>

## Index

<markdown index>

## Records

<record material>

## Summary

<markdown summary>

## Round close

<appended later>
````

`## Round close` is appended later by `append-codex-round-close.sh` and is the source of truth for `session-memory.md` promotion.

The `## Reviewer 2nd-opinion` first line is one of `ready-to-execute`, `fix-and-proceed`, `re-review-needed`, `escalate`, `skipped: <stub>`, or `unavailable: <reason>`.
