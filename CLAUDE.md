# CLAUDE.md

1. Read first, in order: `${HOME}/CXMem/STATE.md`, `${HOME}/CXMem/ROADMAP.md`, `${HOME}/CXMem/decisions.md`.
2. Do not redesign settled decisions; propose a revision such as `Dn-revisits-Dk`.
3. All design changes go through `/claudex:think` (specs land in `${HOME}/vault/projects/claudex/specs/` per skill convention).
4. All work happens on the `main` branch of `${HOME}/CXMem/` (its own git repo, separate from vault).
5. Commit prefix: `cxmem: <what>`. This repo is independent of vault, so vault commit conventions and the weekly digest do not apply.
6. Do not conflate this project with `${HOME}/vault/projects/claude-memory/`; R1 reconciles them.
7. Do not touch native auto-memory at `~/.claude/projects/-home-fao-vault/memory/`; R7 covers that.
8. No premature implementation; build phases produce files only until a sub-spec is approved.
9. When uncertain, write the open question into `${HOME}/CXMem/notes/open-questions.md`.

## Why each rule exists

Rule 1: Without this, future agents cold-read the wrong files first and miss the live state, roadmap order, or settled decisions.

Rule 2: Without this, agents silently reopen approved choices and erase decision history instead of recording an explicit revision.

Rule 3: Without this, design changes happen as freeform chat and never land in the canonical spec/audit trail.

Rule 4: Without this, work strays onto branches the build pipeline will not pick up, or worse, mixes with vault commits.

Rule 5: Without the prefix, `cxmem` commits get pulled into the vault weekly digest the user does not want them in.

Rule 6: Without this, future agents silently re-do or reverse the prior `claude-memory/` work instead of waiting for R1's reconciliation.

Rule 7: Without this, native auto-memory gets changed before R7 defines whether and how CXMem should integrate with it.

Rule 8: Without this, scaffolding sessions grow implementation code before the relevant sub-spec approves behavior and tests.

Rule 9: Without this, uncertainty is lost in chat context and later agents repeat the same unresolved questions.
