# Lessons

> Accumulated operational knowledge from session corrections. Read at session start. Update when corrected.

## Quality
- Compliance statements don't improve compliance — 48% failure rate measured (v0.9.4). Use concrete tool actions instead.
- Self-reported "Pass" without verbatim terminal output is unreliable. Always require exit code + output.

## Process
- Pre-flight checklists on every turn waste ~3,000 lines of context per session. Run at session start, re-orient periodically via status.md + lessons.md (v0.9.4).
- Work isn't done until pushed to origin. Don't report "done" until changes are on remote (v0.9.4).
- Merging code without internalizing its intent is mechanical, not intelligent. Read what you merge (v0.9.5).

## Architecture
- Annotations saying "consider doing X" are technical debt if the engine still does the old thing. Apply learnings immediately or don't merge them (v0.9.5).
- One source of truth, not four copies. The self-upgrade protocol lives in `.brain/playbooks/build-from-intent.md` Phase 0. Templates point there — they don't duplicate it (v0.9.5).
- A 168-line shell script to avoid one sentence to the orchestrator is the opposite of KISS. Delete the script, trust the orchestrator (v0.9.5).
- 175-line "quick reference" is not quick. If the upgrade is one sentence, the doc should be too (v0.9.5).

## Domain
- The meta-orchestrator's highest-leverage decision is calibrating depth of analysis to the problem. Routing without thinking is dispatching; routing with calibrated thinking is orchestration (v0.9.5).
- Skills are procedural protocols attached to work stages, not roles. They fill the gap between habits (too high-level) and role specs (role-focused). Any role can invoke any skill. (v0.9.9+ concept from MetaAgent/TA)
- Turn Report is structural enforcement of verification — can't fill in Evidence fields without having actually verified. More reliable than behavioral "you should verify" instructions. (MetaAgent v0.9.8)
- Two-Strike Rule: if the same approach fails twice, switch approaches. Don't iterate on a failing method more than twice. (MetaAgent v0.9.9)
