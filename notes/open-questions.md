---
type: open-questions
status: live
---

# Open Questions

- ~~Should secret/personal-fact storage be inside `${HOME}/CXMem/` (and if so, gitignored or git-tracked) or kept entirely outside?~~ **Resolved 2026-05-06 (Hao):** personal-facts live inside the CXMem mem; the `${HOME}/CXMem/` repo will not be made public, so git-tracking is acceptable. R3/R4/R7 still own the concrete schema/path/redaction rules, but the storage-location question is settled.
- Should `${HOME}/vault/projects/claude-memory/` remain separate after R1, or be moved, linked, or otherwise integrated with `${HOME}/CXMem/`? (R1 will revisit.)
- Which mechanism should eventually record intention, tool call, summary, and next step: hooks, custom tools, skills, or a hybrid? (Hao's initial brief raised it; R6 territory.)
- Should the vault cleanup work (kill nested repos like `${HOME}/vault/knowledge/.git/`, retire untracked personal/project dirs, refactor structure) be added as a new roadmap entry — call it R0 or R-vault — or kept outside the CXMem roadmap entirely? (Hao raised this in the Q6 dialogue when proposing the relocation.)
