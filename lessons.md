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

## Domain
- The meta-orchestrator's highest-leverage decision is calibrating depth of analysis to the problem. Routing without thinking is dispatching; routing with calibrated thinking is orchestration (v0.9.5).
