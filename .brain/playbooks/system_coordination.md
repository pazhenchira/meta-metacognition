# System Coordination Workflow

## Purpose
Coordinate cross-repo work in a system-of-systems without violating KISS or LEGO boundaries.

## Applies To
- `coordination_mode: tracked | governed`
- Cross-repo changes (shared components, interface contracts, multi-app flows)

## Inputs
- `coordination/repo_graph.json`
- `coordination/requests/*.json`
- `coordination/events/*.jsonl`
- `coordination/index.json`
- `compatibility_matrix.json`
 - Templates: `coordination_request.template.json`, `coordination_response.template.json`

## Outputs
- Per-repo work packets (inbox)
- Response packets (outbox)
- Updated compatibility matrix
- Cross-repo test plan + results

## State Model (Append-Only)
```
PROPOSED → ACCEPTED → IN_PROGRESS → DELIVERED → VERIFIED → CLOSED
                         ↘︎ BLOCKED
```

## Steps

1. **Register Request**
   - Create request in system repo (`coordination/requests/REQ-*.json`).
   - Append `REQUEST_CREATED` event to `coordination/events/*.jsonl`.
   - Update `coordination/index.json`.

2. **Route to Targets**
   - Create per-repo inbox packet (same request ID).
   - If transport is git/CI, open PRs to target repos.
   - If `agent_context.json` indicates git push/PR permissions, dispatch automatically.
   - If permissions are missing or unknown, ask Sponsor and record decision.

3. **Local Execution (App/Component Repos)**
   - App Orchestrator creates a local work item linked to the request ID.
   - Implement changes on a `req/REQ-...` branch.
   - Write response packet to `outbox/`.

4. **Ingest Responses**
   - System Orchestrator ingests outbox responses.
   - Append `DELIVERED` events and update index.

5. **Verify**
   - Run contract + cross-repo tests.
   - Update compatibility matrix as needed.
   - Append `VERIFIED` event; move to `CLOSED` on sponsor approval.

## Guardrails
- Requests are immutable after creation; updates are events only.
- App repos may do local work without system coordination if no contracts change.
- Breaking changes require explicit sponsor approval.
