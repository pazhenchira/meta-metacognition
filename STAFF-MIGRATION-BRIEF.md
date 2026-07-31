# Staff Migration Brief

> **Repository:** `pazhenchira/meta-metacognition`  
> **Prepared:** 2026-07-31
> **Purpose:** Give this repository enough current-state context to analyze its own migration from the legacy MetaAgent model to the Staff model.  
> **Status:** Migration analysis input. This is sufficient to begin alignment analysis, but not to claim completed alignment without the cross-repository evidence and behavioral validation defined below. It does not authorize deleting, moving, or rewriting existing assets.

## Executive direction

This repository was the owner's personal MetaAgent-style factory and research environment. It currently describes itself as a self-building MetaAgent v0.10 project, with Atlas as its orchestrator and `.brain/`, `.app/`, `.github/agents/`, and `skills/` providing a self-contained AI control plane.

The owner's current architecture no longer uses that pattern as the default:

- `staff` is the canonical home for role identity, orchestrators, sub-agents, skills, lessons, work items, playbooks, and engagement state.
- `me` is the canonical home for operator-private profile, people, voice, calibration, and sensitive data.
- Code repositories retain product or research source, tests, deployment/runtime configuration, technical documentation, and thin instructions needed by coding tools.
- Nexus launches roles from `staff/roles/<role>/` and provides runtime routing, sessions, routines, and agent-to-agent dispatch.

**Do not copy the Staff kernel or a full Staff role into this repository.** The migration goal is to preserve the repository's unique research and executable capabilities while removing duplicated development-control machinery after behavioral parity is demonstrated.

The default hypothesis is that `meta-metacognition` is a **retirement or research-preservation candidate**, not the current production factory. That is a hypothesis to test, not a deletion instruction.

## Important identity distinction

The MetaAgent project currently configured in the owner's runtime is a separate repository. The owner may supply its checkout, remote, or other access when comparison is required.

It is not this repository.

The owner reports that the private runtime still registers a MetaAgent factory project, and that bounded log evidence of recent factory activity is inconclusive. This is owner-supplied and does **not** prove the factory is unused. This repository must not assume it is the current factory, and neither repository should be retired until consumers and successor behavior are mapped.

Repository visibility does not determine whether two repositories should converge. The owner's personal and local repositories are owner-controlled. Some are intentionally separate, while others are converging. Classify their intended relationship and canonical responsibilities instead of inferring migration policy from whether a repository is public, private, local, or remote.

## Evidence and repository access

Begin with this repository. If owner-controlled sibling checkouts or remotes are available to the agent, use them read-only as evidence when relevant. Candidate sources include the current Staff tree, the active Nexus tree, and the upstream MetaAgent repository supplied by the owner.

Source locations are supplied at analysis time through the owner's invocation prompt or environment, not committed into this repository. Consume a source-location manifest with this shape:

```text
source label:
local path or remote:
expected role:
access mode: read-only | editable
```

If a required source has no supplied locator, report it as a prerequisite rather than searching arbitrary parent directories or fabricating a location. The `me` store is a destination classification, not a general evidence source. Do not quote, summarize, or copy its contents into this repository.

For every external source used, record:

- repository or store;
- branch and commit, where applicable;
- paths inspected;
- purpose of the comparison;
- whether the source is authoritative, historical, or a candidate successor.

Do not assume a source is inaccessible merely because it is outside this repository. Conversely, do not claim to have inspected a source that was not actually available. Where required evidence is unavailable, emit `UNKNOWN - requires owner-supplied input` and name the specific source needed.

Owner-controlled access does not authorize copying credentials, secrets, or employer-restricted source into another repository. Extract capability descriptions, owner-authored insights, decisions, and reusable behavior according to their actual classification and the intended repository topology.

## What this brief provides

This brief provides:

- the target Staff architectural model;
- the known legacy surfaces requiring classification;
- the migration decision paths and sequencing;
- the capability-manifest format;
- the validation and retirement gates.

This brief does **not** embed the contents of the current Staff, Nexus, `me`, or upstream MetaAgent sources. Therefore:

- it is sufficient to start a complete repository analysis;
- it is not, by itself, evidence that every internal capability or insight has already been replicated;
- completed alignment requires direct comparison with every available authoritative source, an explicit repository-topology map, and representative behavioral replay.

## Repository topology rule

For each related repository or store, classify:

```text
source:
owner / trust boundary:
intended relationship: converge | remain separate | mirror | retire
canonical responsibilities:
content or capabilities that should move:
content or capabilities that should remain:
synchronization or compatibility contract:
evidence:
confidence:
```

Repository separation and capability convergence are compatible. A code or research repository may remain independent while its generic AI control behavior converges into Staff. Likewise, owner-authored knowledge may be replicated into the repository that becomes canonical without merging the repositories themselves.

## What changed in the Staff model

### 1. AI identity moved out of code repositories

Legacy model:

```text
repository/
|- .brain/
|- .github/agents/
|- skills/
|- orchestrator state
`- product or research code
```

Current model:

```text
staff/
|- .github/copilot-instructions.md   # cross-role kernel
|- skills/                           # kernel and cross-role skills
`- roles/<role>/
   |- .github/copilot-instructions.md
   |- .github/agents/
   |- .github/skills/
   `- .brain/

code-or-research-repository/
|- source and tests
|- runtime/deployment configuration
|- technical and research documentation
`- thin coding-tool instructions
```

A code-owning Staff role records its repository relationship in `staff/roles/<role>/.brain/code-project.md`. The role operates on the code repository through tools while its identity and durable AI state remain in Staff.

Use the current `code-project.md` section schema:

```text
Location
Relationship
What "owning" looks like
Boundary
```

### 2. Shared process behavior became a kernel

Generic process protocols are no longer copied into every repository. Staff now provides common behavior such as:

- turn classification and workflow routing;
- investigation framing;
- planning and dispatch discipline;
- verification and evidence citation;
- adversarial review and Judge gates;
- lesson promotion;
- engagement continuity;
- autonomy and response-quality checks.

Repository-specific skills should contain only domain knowledge that is genuinely unique to the repository.

### 3. Loading became tiered and intentional

The Staff kernel and role wrapper are lightweight entry points. Personas, skills, lessons, work items, and private operator data load on demand rather than being copied into every prompt or repository.

### 4. Roles became independently addressable

Nexus resolves a role name to `staff/roles/<role>/` and launches the role there. Roles communicate through agent-to-agent dispatch rather than through copied role definitions inside every project.

### 5. Private state received a separate boundary

Operator-specific people, voice, preferences, calibration, and sensitive information belong in `me`, not in public or reusable framework repositories. This repository is public, so no private state should be introduced during migration.

### 6. Runtime and role identity are separate

Nexus the running service is code in its code repository. The Nexus Staff role is the AI identity that owns and reasons about that code. The same separation should be used if a continuing factory capability receives a Staff role.

## Current repository surfaces requiring classification

This repository contains multiple generations of control-plane material. Do not apply one blanket disposition to all of them.

| Surface | Current purpose | Proposed treatment |
|---|---|---|
| `README.md`, `essence.md`, `INTUITION.md`, research docs | Research purpose and design rationale | Preserve; update terminology after the repository's future identity is decided |
| Generators, templates, runtime adapters, MCP server, executable code, tests | Potential research or factory product | Preserve until executable consumers and behavioral coverage are established |
| `.brain/playbooks/`, `.brain/roles/`, `.brain/wisdom/`, `.brain/principles.md` | Legacy embedded control plane | Extract unique content; map generic content to Staff; retire duplicates only after parity |
| `.brain/lessons.md`, `.brain/status.md`, work state | Durable knowledge and session state | Classify each item as repository knowledge, role knowledge, operator-private knowledge, or obsolete state |
| `.github/agents/atlas.agent.md` | Legacy repository orchestrator | Extract unique factory/research behavior into a Staff role or skill if the capability continues |
| `.github/copilot-instructions.md`, `AGENTS.md` | Legacy full identity loader | Replace eventually with thin repository-local build/test/safety instructions |
| `skills/` | Generic quality protocols plus possible unique procedures | Map generic skills to Staff; retain only unique factory/research procedures |
| `.app/` | Generated app-orchestrator scaffold | Identify consumers; likely retire after consumer and parity gates |
| `app_intent.md`, `meta_config.json`, `APP_ORCHESTRATION.md` | Product intent, configuration, and historical orchestration decisions | Preserve decisions and intent; separate current product configuration from obsolete orchestration state |
| `orchestrator_state.json`, engine/framework version files, generation manifests | Legacy workflow/checkpoint state | Preserve for audit until migration completes; normally retire from the active surface afterward |
| `patterns/`, `templates/`, `generators/` | May be actual framework product, not merely AI state | Treat as product assets unless evidence proves otherwise |

## Capabilities that should not be copied

The following generic skills already have current Staff equivalents and should normally be mapped rather than duplicated:

| Legacy capability | Current Staff successor | Availability |
|---|---|---|
| Investigation framing | `investigate-and-answer` | Kernel |
| Pre-ship review | `ta-review`, composed with `proof-pack` | TA role-private + kernel |
| Structured challenge | `ta-challenge` | TA role-private |
| Problem reframing | `ta-reframe` | TA role-private |
| Strategic synthesis | `ta-strategize` | TA role-private |
| Stakeholder and audience review | `audience-aware-voice`, composed with `ta-review` | Kernel + TA role-private |
| Generic claim verification | `evidence-citation` and `proof-pack` | Kernel |
| Planning and work-execution loops | `turn-router`, `protocol-discipline`, and `ta-plan` | Kernel + TA role-private |

Before removing a legacy skill, record its Staff successor and replay at least one representative task that exercised the old behavior. A role-private successor is not automatically available to a new factory role. Either promote genuinely cross-role behavior to the kernel, create a factory-role-specific equivalent, or preserve the legacy capability until an accessible successor passes replay.

## Capabilities that require explicit preservation analysis

This repository may contain unique capabilities not supplied by Staff:

- intent-to-application generation;
- essence discovery and preservation;
- multi-phase application construction;
- framework upgrade or regeneration;
- system-of-systems repository coordination;
- generator/template production;
- role generation;
- application-specific runtime adapter generation;
- restraint, governance, and metacognitive research mechanisms.

For each capability, answer:

1. Is it executable behavior, documentation, or historical design?
2. What invokes it today?
3. Is the invocation local, CI-based, IDE-based, Nexus-based, or manual?
4. Which files are its canonical source?
5. What tests or representative tasks prove it works?
6. Does the upstream MetaAgent repository (identity supplied out of band), Staff, or another repository already provide a successor?
7. If retained, where should its AI owner live?
8. What permissions does it require?
9. What is the rollback plan if migration changes its behavior?

## Decision required: future repository identity

Analyze these three paths. Do not assume the answer from repository age or file similarity.

### Path A: preserve as a research/code repository

Use this path if the metacognition research, experiments, generators, or papers remain independently valuable.

- Keep unique source, experiments, tests, templates, and research documentation here.
- Assign ownership to an appropriate Staff role.
- Replace the embedded MetaAgent control plane with thin repository instructions.
- Update the README to describe the repository as research/code rather than the active personal factory.

### Path B: continue as a Staff-compatible factory

Use this path only if the owner still needs this repository's project-generation capability and it is meaningfully different from the upstream MetaAgent repository (identity supplied out of band).

- Create or designate a least-privilege Staff factory role.
- Keep factory implementation and tests here.
- Move the role's identity, agents, skills, lessons, work items, and engagement state into Staff.
- Generate Staff-compatible role wrappers and code-project relationships rather than copying MetaAgent scaffolding into new repositories.
- Integrate with Nexus through an explicit project registration and tested factory route.
- Define compatibility with the current Staff kernel and mandatory protocol enforcement.

### Path C: retire after preservation

Use this path if unique behavior is already superseded or no longer needed.

- Extract unique research, decisions, lessons, and reusable generator logic.
- Record successor mappings for every retained capability.
- Run representative task replays against the successor.
- Remove the repository from any runtime discovery or factory configuration.
- Disable Actions, webhooks, credentials, deploy keys, and external integrations.
- Create a tested encrypted Git bundle or bare mirror outside the GitHub account.
- Archive the GitHub repository only after zero remaining consumers are established.

Removing runtime registration, disabling repository integrations, creating an external backup, and archiving the repository are **owner actions**. Record them as gated prerequisites or requested actions; do not report them as performed.

## Recommended analysis workflow

### Phase 0: establish a trustworthy baseline

1. Fetch all branches and tags.
2. Record the current commit and branch state. Separately, record repository settings.
3. Inventory Actions, webhooks, deploy keys, packages, releases, and external references.
4. Create an encrypted rollback bundle outside the GitHub account and test restoration.

Repository settings in item 2, and the repository-administration or backup operations in items 3-4, may require access not granted to the agent. Treat only the unavailable operations as **owner actions**. Record them as prerequisites and their completion status; do not report them as performed. Recording the current commit and branch state in item 2 is within the agent's boundary and must be performed.

5. Do not mix migration work with unrelated changes.
6. Audit what is **already public**. Scan HEAD and full Git history for operator paths, usernames, hostnames, tokens, work-internal organization/repository/service names, and personal content, including `internal-notes.md`, `.brain/lessons.md`, `.brain/status.md`, `.brain/config.yaml`, and `templates/`. Also scan public GitHub surfaces that Git history does not cover: issues, pull request titles/bodies/comments, wiki, releases and release notes, and Actions run logs. Classify each finding as `safe`, `redact-at-HEAD`, `requires-history-rewrite`, or `rotate-credential`. If any finding is classified `rotate-credential`, **stop work and notify the owner immediately**; do not defer it to the phase report. Removing a file at HEAD does not remove it from public history. A published secret must be rotated, not merely deleted. History rewrite does not reach forks, cached orphaned commits, or third-party mirrors. For already-public non-credential exposure, rewrite reduces future discovery but does not undo disclosure; escalate to the owner for a disclosure decision. Report the scan boundary with every negative result: which surfaces, refs, and commit range were scanned, and by what method. A pattern scan that returns no matches is not proof of no exposure. Secret-scanning alerts were not retrievable at the access level used to prepare this brief. Do not infer whether the feature is enabled or disabled from that result, and never report unavailable alerts as zero alerts.

### Phase 1: map execution and consumers

1. Trace every script, workflow, agent, and external system that invokes factory behavior.
2. Inspect available owner-controlled sibling repositories and runtime configuration read-only. Record the exact search boundary. If a required source is unavailable, report `UNKNOWN - requires owner-supplied input` with the specific artifact needed.
3. Compare capabilities with the upstream MetaAgent repository when access is available. Otherwise report `UNKNOWN - requires owner-supplied input`.
4. Identify which paths are executable product and which are prompt/control state.
5. State the search boundary whenever reporting that no consumer was found.

### Phase 2: build a capability manifest

For every orchestrator, role, skill, playbook, lesson group, generator, routine, and state artifact, record:

```text
artifact:
capability:
current consumer:
canonical source:
required permissions:
Staff or product successor:
preservation requirement:
representative replay:
proposed disposition:
confidence:
```

### Phase 3: choose the target architecture

Decide whether the repository follows Path A, B, or C. If Path B is selected, decide whether the factory role owns this repository, the upstream MetaAgent repository, or both. Avoid two active factories with ambiguous ownership.

### Phase 4: migrate unique behavior

1. Move role identity and durable AI state to Staff.
2. Move private operator state to classified `me` storage.
3. Keep product/research implementation and technical documentation here.
4. Replace generic copied skills with references to Staff successors.
5. Add thin repository-local instructions for coding tools.
6. Correct stale terminology, paths, remotes, permissions, and version claims.

### Phase 5: validate behavior

Replay representative scenarios, including:

- create an application from intent;
- upgrade or regenerate an existing application;
- preserve essence across generation;
- perform independent generation and review;
- coordinate a multi-repository system;
- resume interrupted work without corrupting state;
- refuse or pause unsafe action where the framework promises restraint.

Run the old and proposed successor paths against the same scenarios. File-level similarity is not a substitute for behavioral comparison.

### Phase 6: cut over and retire legacy control surfaces

1. Run the successor in shadow mode.
2. Remove legacy runtime discovery before deleting files.
3. Confirm no external consumer fails.
4. Retire embedded control-plane assets that have proven successors.
5. Update the repository narrative and status.
6. Archive only if the chosen target is Path C.

## Expected repository-local output

Before making migration changes, produce a report containing:

1. **Recommended future identity:** Path A, B, or C, with evidence.
2. **Repository-topology map:** intended relationship and canonical responsibility for every related repository or store.
3. **Capability manifest:** complete disposition of the artifact categories above.
4. **Comparison with the upstream MetaAgent repository:** unique, duplicate, and missing capabilities, or `UNKNOWN - requires owner-supplied input` if access was not provided.
5. **Staff mapping:** proposed role, sub-agents, role-private skills, code-project pointer, and permissions.
6. **Consumer map:** internal and external callers, including the search boundary.
7. **Behavioral replay plan:** scenarios, success criteria, and rollback.
8. **Privacy review:** existing-exposure findings reported only as `file path + line/commit reference + finding category + disposition`. Never reproduce a found secret, token, credential, operator path, username, hostname, or work-internal organization/repository/service name verbatim in a file written to this repository. Verbatim values go to the owner out of band. Also confirm that no new operator-private or work-internal data enters this public repository.
9. **Migration sequence:** reversible steps before irreversible steps.
10. **Retirement gates:** explicit conditions that must pass before deleting or archiving anything.

## Non-negotiable guardrails

- Do not rebuild the complete Staff kernel inside this repository.
- Do not treat copied files as independent capabilities without testing behavior.
- Do not delete generators, templates, adapters, or research assets merely because their names resemble orchestration state.
- Do not assume this repository is the active Nexus factory.
- Do not assume absence from retained logs proves absence of dependency.
- Do not copy legacy permission flags into a new role.
- Do not introduce private operator data into this public repository.
- Do not assume deleting a file at HEAD removes it from this repository's public history.
- Do not run a mutating generation or deployment scenario without an isolated target and explicit authorization.
- Do not archive until runtime discovery, external consumers, credentials, and rollback have all been addressed.

## Definition of done

Migration is complete only when:

- the repository has one unambiguous purpose;
- its unique capabilities have an identified owner and canonical source;
- generic AI control behavior comes from Staff rather than copied scaffolding;
- product/research code remains independently buildable and testable;
- representative old-versus-new task replays pass;
- repository instructions are thin, accurate, and current;
- no ambiguous factory or Atlas identity remains active;
- private data boundaries and least-privilege permissions are enforced;
- rollback has been tested;
- any archival decision is supported by a complete consumer inventory.
