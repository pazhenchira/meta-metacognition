# Application Intent

This file describes the **specific application** you want the meta-orchestrator to build.

You should edit THIS file for each new app you build.  
Do **not** mix application details into `intent.md` (that file is only about how the meta-engine works).

Below is a template you can fill in.

---

## 1. High-Level Description

Describe the app in 3–10 sentences:

- What does the app do?
- Who is it for?
- What major features are required?

Example (replace with your own later):

> I want to build a stock analysis engine that processes a small set of user-selected tickers
> and produces a daily summary report with basic technical indicators, anomaly detection,
> and a human-readable summary. The app should be simple, modular, and easy to extend.

---

## 2. Constraints & Priorities

List the most important constraints:

- Performance expectations
- Privacy / security requirements
- Cost constraints
- UX/complexity constraints (KISS, minimal features, etc.)

---

## 3. Non-Goals / Out of Scope

Clarify what is **not** required in the first version, so Codex doesn’t overbuild.

---

## 4. Known Integrations or APIs (Optional)

List any services/APIs you know you want to use, or constraints about them:

- Data APIs
- Authentication providers
- Storage services
- Third-party SaaS

---

## 5. Output Expectations

Describe how you’d like the app to present its results:

- CLI output? JSON? Markdown? Web UI?
- What fields or sections should be present?
- Any formatting constraints?

---

## 6. Operational Mode

Describe how you intend to run this app in v1:

- Manually from CLI?
- On a schedule (cron/job)?
- Single-user vs multi-user?

---

## How This File Is Used

The Meta-Orchestrator will:

1. Read `app_intent.md` to understand **what** to build.
2. Ask you a small number of clarifying questions (requirements extraction).
3. Generate durable artifacts like `requirements.md`, `dependencies.md`, `external_services.md`, `.env.example`, and `lego_plan.json`.
4. Build and orchestrate all LEGO blocks and substeps according to this intent.

You can change `app_intent.md` at any time and re-run the meta-orchestrator to adapt to a new app.
