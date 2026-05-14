# CLAUDE.md

## Orient

Resolve the active project first:
- If `CXMEM_PROJECT` env is set and valid (regex `^[A-Za-z0-9._-]+$`, the dir `${HOME}/CXMem/projects/<X>/` exists, and the dir is not a symlink escape), use that as `<X>`.
- Else walk up from `$PWD` until an ancestor matches `${HOME}/CXMem/projects/<X>/`; use `<X>`.
- Else escalate: tell the user "I'm running outside any `${HOME}/CXMem/projects/<X>/` and `CXMEM_PROJECT` is unset; cd into a project root or set `CXMEM_PROJECT=<name>`, then re-run." Halt before reading or writing anything.

Once `<X>` is resolved, read `${HOME}/CXMem/projects/<X>/project-memory.md`. It is the cross-session catch-up surface — current state, roadmap, decisions index, sessions log, open questions. If its State block names an active session (`Active session: <slug>, ...`), then list `projects/<X>/sessions/<slug>/rounds/` to find the highest-numbered `round-<n>.md` and read both `projects/<X>/sessions/<slug>/session-memory.md` and that latest round file before responding. The directory listing is the authoritative source for the latest round; the pointer's `last round` field is informational.

If `projects/<X>/project-memory.md` doesn't exist (first run in a brand-new project), the next /claudex:think or /claudex:build invocation auto-bootstraps a stub from `${HOME}/CXMem/docs/project-memory-template.md`; no manual creation required.

## Record this session

For every round (one `UserPromptSubmit` to the next), the round file `${HOME}/CXMem/projects/<X>/sessions/<slug>/rounds/round-<n>.md` MUST exist on disk before the assistant delivers any user-visible response. Concretely: after each tool batch (if any), append the corresponding records (idempotent on retry); and **before delivering any user-visible response, ensure the round file contains at least the user prompt and the verbatim assistant output to be delivered**, AND update `projects/<X>/project-memory.md`'s `Active session:` pointer line in the same atomic step. Rounds with no tool batch (clarifying-only, decision-only) still get a sparse record (user prompt + assistant output, no tool records). If the final consolidation write fails, surface the failure to the user and DO NOT silently deliver the response — recovery requires either a retry or an explicit note in the next round.

Slug = `YYYY-MM-DD-HHMM-<topic>`; round counter is monotonic from 1 within the session. On the first record of a new session, claim the slug atomically with `mkdir projects/<X>/sessions/<slug>/`; on collision retry with `-2`, `-3`. Immediately after claim, write `projects/<X>/sessions/<slug>/.session-meta` with `{slug, started_at, project: <X>, uuid?}`. Every append uses tmpfile-and-rename, is keyed by a structural heading (idempotent on retry), and uses record IDs `<round>.<seq>[<letter>]` that apply batch-collapse: same-tool same-purpose batch = 1 record; different-tool batch = 1 record per tool.

At the next `UserPromptSubmit` (round close), append a `## Round close` block to the same round file with the round-end summary, and promote that summary upward into `projects/<X>/sessions/<slug>/session-memory.md`. The `## Round close` block is idempotent: if already present, no-op.

At session close (assistant-inferred or user-marked), finalize `session-memory.md`, append a row to `projects/<X>/project-memory.md`'s Sessions log. Sessions are sealed, never deleted.

If the assistant's in-conversation slug context is lost (e.g. after `/clear`), read the most-recent unsealed `projects/<X>/sessions/<slug>/` directory as a heuristic; if multiple unsealed sessions exist, ask the user before writing.

## Record codex sub-agent rounds

This protocol applies only to `claudex-build` SPEC, PLAN, and IMPLEMENT codex execs. `claudex-think` 2nd-opinion calls are out of scope here: their AGREE/DISAGREE/ANGLE-MISSED verdict is projected inline into the parent Claude main round as `[Codex 2nd opinion]: <verdict>`, with raw output preserved at `RUN_DIR/.last-2nd-opinion.raw`. Do not write a separate codex round file for think.

Codex sub-agent round files are named `projects/<X>/sessions/<slug>/rounds/round-<N>-codex-<stage>-r<n>.md`, where `<N>` is the parent Claude main round, `<stage>` is `spec`, `plan`, or `impl`, and `<n>` is `1`, `2`, `fix1`, or `fix2`.

Each file is rendered in this order: frontmatter with `type: round-memory`, `session-id`, `project`, `round`, and `created`; an H1 title using a one-line summary, falling back to `Codex CXMem emissions` when empty; `## Codex prompt (rendered)` with the verbatim bytes handed to `codex exec`, fenced as `text`; `## Codex output (verbatim)` with the verbatim bytes of clean codex stdout, fenced as `text`; `## Reviewer 2nd-opinion` with the first-line verdict `ready-to-execute`, `fix-and-proceed`, `re-review-needed`, `escalate`, `skipped: <stub>`, or `unavailable: <reason>`, followed by the full review body for `--reviewer-review`; then `## Index`, `## Records`, `## Summary`, and deferred `## Round close`.

Writes use whole-file tmpfile-and-rename. If the rendered bytes match the existing target, skip the rename and report `ok: unchanged`.

`## Round close` is appended at parent main-round close by `append-codex-round-close.sh`. This is idempotent: a file already containing a top-level `## Round close` heading is left unchanged; the same heading inside a fenced code block does not count.

`promote-codex-round.sh` extracts `## Round close` for `session-memory.md` promotion, with `## Summary` as the legacy fallback. Emit one warning per fallback file.

Codex sub-agent rounds do not update `Active session:` in `project-memory.md`. Only Claude main rounds do.

When the reviewer is skipped (`fix-and-proceed` no-re-review under stage protocol), the `## Reviewer 2nd-opinion` first line is `skipped: <one-line summary of what r1 asked to fix>`. When reviewer dispatch fails, the first line is `unavailable: <reason>`. Write the round file either way. The synthesized close paragraph uses `fix accepted under stage protocol` for skipped reviewer or `reviewer unavailable: <reason>` for unavailable reviewer, joined with other close-body pieces by one U+0020 space.

## Design changes route through /claudex:think

When a change involves multi-file work, ambiguous requirements, or architecture-level rethinking, invoke `/claudex:think` rather than designing in chat. Approved specs land in `projects/<X>/specs/r<N>/` and are indexed by `projects/<X>/specs/README.md`; per-run audit dialogues live at `projects/<X>/sessions/<slug>/runs/<run-id>/` (session-active) or `projects/<X>/runs/<run-id>/` (sessionless within the project).
