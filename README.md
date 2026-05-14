# CXMem

Memory scaffolding for keeping auto-research grounded across reasoning rounds and across time.

## What we're trying to build

CXMem is the memory half of a longer auto-research stack: a system that can take a hard question, work it through over many passes, survive interruptions, and continue without losing why earlier conclusions were reached. The ambition is not just longer transcripts. It is multi-day and multi-session research that can keep state, inspect its own trail, and resume with enough structure that the next round starts from evidence instead of vibes.

That goal fails in two common ways. A model can drift while reasoning inside a single run, or it can drift over time as old context becomes too large, too stale, or too compressed to trust. CXMem exists for the second problem, and it is designed to work beside [ClaudeX][claudex], which targets the first.

## Failure mode #1: drift across reasoning

Reasoning drift happens when one model's working assumptions harden as the conversation continues. An early guess becomes a premise. A partial plan becomes a constraint. The model gets better at defending the path it is already on than at noticing whether the path still matches the problem.

[ClaudeX][claudex] attacks that failure by putting reflection in tandem with execution. Separate critique and synthesis passes make it harder for a single stream of thought to silently promote guesses into facts. That matters for auto-research because the costliest errors are often not local mistakes; they are unexamined assumptions that shape every later move.

CXMem does not replace that reasoning check. It gives the tandem something stable to return to after the current window, current session, or current agent state has moved on.

## Failure mode #2: drift across time

Time drift is different. It appears when the work is too long for one useful context window, or when a project pauses and resumes days later. Keeping the whole transcript is expensive and noisy. Replacing it with a short summary is cheap, but lossy. After enough compression, the system may remember the conclusion while forgetting the evidence, the rejected alternatives, or the caveats that made the conclusion valid.

For multi-day research, that tradeoff is fatal. The system needs small surfaces for quick orientation, but those surfaces must still point back to raw detail when a claim becomes important again. CXMem treats memory as a pointer hierarchy rather than a flat transcript or a single rolling summary.

## The tandem

ClaudeX and CXMem are complementary. [ClaudeX][claudex] reduces drift across reasoning by making the current thinking answerable to critique. CXMem reduces drift across time by making prior thinking addressable after the live context has changed.

Together, they aim at a research loop where an agent can think, record, compress, resume, and drill down without pretending that a summary is the source of truth. The current round can stay focused, while older rounds remain reachable when the work needs auditability.

## CXMem in six lines

```text
project-memory.md
└─ sessions/<slug>/
   ├─ session-memory.md
   └─ rounds/round-<n>.md
```

`project-memory.md` is the cross-session catch-up surface. It holds the current project state and points down to the active or relevant session.

`sessions/<slug>/session-memory.md` is the session-level memory. It compresses what happened during one continuous line of work and points down to the rounds that carry the details.

`sessions/<slug>/rounds/round-<n>.md` is the raw round record. It keeps the concrete trail for one interaction round, including the material needed to reconstruct why the higher summaries say what they say.

The higher tiers are intentionally cheap to read. They are not meant to contain everything. They are pointers with enough summary to orient the next agent, plus enough structure to drill down into raw round detail on demand. The diagrams in [img/](img/) sketch this pointer shape visually, but the core idea is the same: summary above, evidence below.

## What's in this repo

This repository ships the scaffolding for CXMem, not a shared live memory database. Real project memory lives under `projects/<X>/`, which is per-user and gitignored so local research state does not become repository content.

| Path | Purpose |
| --- | --- |
| [CLAUDE.md](CLAUDE.md) | Operating protocol and source of truth for how agents orient and record. |
| [docs/project-memory-template.md](docs/project-memory-template.md) | Bootstrap shape for a new project's top-level memory file. |
| [bin/preflight.sh](bin/preflight.sh) | Repository preflight helper used by the local workflow. |
| [img/](img/) | Diagrams and visual notes for the memory model. |
| `projects/<X>/` | Per-user, gitignored project memory written during real work. |

[claudex]: https://github.com/WillInvest/ClaudeX
