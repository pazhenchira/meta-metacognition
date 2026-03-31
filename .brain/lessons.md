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
- Conventions and enforcement must have the same lifecycle. Splitting quality rules (meta-metacognition) from the runtime that hosts agents (nexus) means they drift apart — producing the exact inconsistency they were designed to prevent. OpenClaw doesn't have this problem because the gateway IS the convention enforcer. (2026-03-30, OpenClaw analysis)
- Solution-spamming is not analysis. Proposing four contradictory architectures in four turns (don't merge → dual-stack → merge → OpenClaw-style) without deeply understanding the problem is throwing darts, not orchestrating. When the sponsor is still exploring the problem space, help them understand — don't short-circuit with premature recommendations. Understand first, recommend once. (2026-03-30, sponsor correction)
- Meta-metacognition is a FACTORY, not a content repository. It produces agent systems that own projects/products — the 12-phase pipeline, templates, generators, and roles work together as a generative system that takes intent and outputs a fully-staffed agent team for a new project. Treating it as "files to extract into a package" misses the core capability. A factory is a system, not a folder of content. The factory's essence is NOT just "engineering CTO" — it produces any type of agent system: engineering projects, advisory systems (ta), financial advisors, traders. Each with its own soul/essence. (2026-03-30, sponsor corrections)
- Upgrade instructions must be self-sufficient — a project orchestrator told "upgrade" must be able to fully self-migrate without the sponsor hand-holding. Don't write passive checklists ("verify X exists"); write actionable steps ("create X with this content if missing"). The sponsor shouldn't need to relay instructions project-by-project. (2026-03-30, sponsor correction)
