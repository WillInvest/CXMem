---
type: roadmap
status: confirmed
---

# ROADMAP

| ID | Title | Order | Status | Notes |
|----|-------|-------|--------|-------|
| R1 | Reconcile with prior `claude-memory/` research | 1 | next | |
| R3 | Memory hierarchy schema | 2 | later | |
| R4 | Per-round recording protocol | 3 | later | |
| R5 | Codex auditor protocol | 4 | later | |
| R6 | Mechanism choice (hooks / tools / skills / hybrid) | 5 | later | |
| R7 | Native auto-memory integration | 6 | later | |
| R2 | Vault structure refactor | 7 | maybe-not | |
| R8 | Rollout plan | 8 | later | |

## Rationale

R2 is `maybe-not` because the prior `claude-memory/best-practices.md` recommends fewer moving parts; vault refactor is high-blast-radius and should not be treated as prerequisite scaffolding.

R2 appears at order 7 because R3's schema dictates whether top-level vault folders need reshaping at all.
