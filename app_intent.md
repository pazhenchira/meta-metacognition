# Application Intent

This file describes the **specific application** you want the meta-orchestrator to build.

You should edit THIS file for each new app you build.  
Do **not** mix application details into `intent.md` (that file is only about how the meta-engine works).

---

## Example Template

### 1. High-Level Description

Describe the app in 3–10 sentences:

- What does the app do?
- Who is it for?
- What major features are required?

### 2. Constraints & Priorities

List the the most important constraints:

- Performance expectations
- Privacy / security requirements
- Cost constraints
- UX/complexity constraints (KISS, minimal features, etc.)

### 3. Non-Goals / Out of Scope

Clarify what is **NOT** required in the first version.

### 4. Known Integrations or APIs (Optional)

List any APIs/services you know you want to use.

---

## How This File Is Used

The Meta-Orchestrator will:

1. Read `app_intent.md` to understand **what** to build.
2. Ask you a small number of clarifying questions (requirements extraction).
3. Generate `requirements.md`, `lego_plan.json`, and `plan.md` based on this.
4. Build and orchestrate all LEGO blocks and substeps according to your intent.

You can change `app_intent.md` at any time and re-run the meta-orchestrator to adapt to a new app.
