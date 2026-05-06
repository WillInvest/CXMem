---
type: decisions-log
status: live
---

# Decisions

## D1-scope

ID: D1-scope

Date: 2026-05-06

Topic: Scope of this `/claudex:think` session's spec.

Decision: Option (A) — kickoff scaffolding only.

Rationale: This is multi-session work; existing `claude-memory/` research must be reconciled rather than silently bypassed; project-local `CLAUDE.md` plus a decisions log have outsized early value because they let future post-`/clear` agents catch up.

Codex 2nd-opinion verdict: AGREE.

## D2-roadmap

ID: D2-roadmap

Date: 2026-05-06

Topic: ROADMAP.md contents, ordering, and status tags.

Decision: Eight sub-specs in order R1, R3, R4, R5, R6, R7, R2, R8 with status tags `next` / `later` / `maybe-not`.

Rationale: Vault refactor (R2) goes near the end because R3's schema dictates whether vault folders need reshaping; R2 is tagged `maybe-not` because prior `claude-memory/best-practices.md` recommends fewer moving parts.

Codex 2nd-opinion verdict: AGREE.

## D3-layout-rules-branch

ID: D3-layout-rules-branch

Date: 2026-05-06

Topic: `projects/claudex/mem/` layout, project-local `CLAUDE.md` rules, and `mem` branch creation policy.

Decision: Layout as drawn: eight scaffold files; nine `CLAUDE.md` rules approved as listed; build phase auto-creates `mem` branch with preflight asserting clean tree and halting if `mem` already exists locally. D7-relocate later supersedes the path/branch portions of this decision, now `${HOME}/CXMem/` on `main`.

Rationale: Cold-read recovery plus branch hygiene.

Codex 2nd-opinion verdict: ANGLE-MISSED on Q3 — Codex flagged that the preflight assertion is required regardless of whether branch creation is manual or automatic; folded into the decision.

## D4-approach

ID: D4-approach

Date: 2026-05-06

Topic: Helper-infrastructure scope of the build phase.

Decision: Approach 2 — scaffold the eight markdown files plus a reusable `mem/bin/preflight.sh` helper, post-D7 `${HOME}/CXMem/bin/preflight.sh`.

Rationale: Preflight is the only piece with reuse value across seven future sub-spec build phases.

Codex 2nd-opinion verdict: AGREE.

## D5-design-approved

ID: D5-design-approved

Date: 2026-05-06

Topic: Final design approval.

Decision: Approved as a whole; design becomes the canonical input to Stage 4 spec write. Specifically accepted: halt-not-overwrite build idempotence; provisional glossary entries with `> [!warning] Definition may evolve in R3/R4` callout; five success criteria including the cold-read 2-minute test and the preflight smoke test; out-of-scope list.

Rationale: The approved design is narrow, auditable, and sufficient for kickoff without pre-designing later R-items.

Codex 2nd-opinion verdict: AGREE.

## D7-relocate

ID: D7-relocate

Date: 2026-05-06

Topic: Relocate project from `vault/projects/claudex/mem/` to a separate git repo at `${HOME}/CXMem/`.

Decision: Standalone repo on default branch `main`; supersedes D3 layout root path, D3 branch policy, D3 rules 4 + 5, and D4 preflight semantics. Keeps D1 scope, D2 roadmap, D4 approach choice, D5 design pillars, and all nine `CLAUDE.md` rules in spirit, with paths in rules 1, 4, 7, and 9 updated mechanically.

Rationale: Bootstrap-preflight is trivially simple in a single-purpose repo; mem development and vault cleanup become independently schedulable; eventual portability; vault stays "notes + tiny code".

Codex 2nd-opinion verdict: not applicable — D7 is a post-decisions spec revision arising from the Q6 dialogue, not a Codex-challenged decision.
