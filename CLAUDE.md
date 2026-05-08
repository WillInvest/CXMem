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

## Design changes route through /claudex:think

When a change involves multi-file work, ambiguous requirements, or architecture-level rethinking, invoke `/claudex:think` rather than designing in chat. Approved specs land in `projects/<X>/specs/r<N>/` and are indexed by `projects/<X>/specs/README.md`; per-run audit dialogues live at `projects/<X>/sessions/<slug>/runs/<run-id>/` (session-active) or `projects/<X>/runs/<run-id>/` (sessionless within the project).
