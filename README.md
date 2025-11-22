# Meta Metacognition Pipeline (Codex CLI)

This repository defines a **hierarchical, LEGO-based, KISS-driven, meta-cognitive R&D pipeline** orchestrated through **Codex CLI**, for both **Bash** (macOS/Linux) and **PowerShell** (Windows).

You run **one command**, and Codex:

- Performs environment preflight  
- Extracts application requirements (from `app_intent.md`) with minimal questions  
- Designs a LEGO architecture (from `requirements.md`)  
- Optionally pauses for architecture approval (from `meta_config.json`)  
- Spawns one Codex session per LEGO  
- Executes design, tests, docs, code, validation per LEGO  
- Applies GEN + REVIEW patterns  
- Maintains restartable state and session hygiene  
- Enforces safety valves  

## Files You Provide

In the repo root:

- `intent.md` – meta-orchestrator intent (how the engine behaves)  
- `app_intent.md` – application intent (what app you want)  
- `principles.md` – global principles (KISS, LEGO, privacy, tests, etc.)  
- `AGENTS.md` – behavior contract for meta + LEGO orchestrators  
- `meta_config.json` – flags for R&D mode and approval  
- `README.md` – this file  

## How to Run

### Bash

```bash
cd meta-orchestrator
codex exec "Act as the meta-orchestrator described in AGENTS.md. Read intent.md (meta intent), app_intent.md (application intent), principles.md, and meta_config.json. Then run the full pipeline."
```

### PowerShell

```powershell
cd meta-orchestrator
codex exec "Act as the meta-orchestrator described in AGENTS.md. Read intent.md (meta intent), app_intent.md (application intent), principles.md, meta_config.json, then run the full pipeline."
```

### Resume

```bash
codex exec resume --last "Continue the meta-orchestrator pipeline."
```

```powershell
codex exec resume --last "Continue the meta-orchestrator pipeline."
```

Codex will read state files and resume building the app.

(See our previous conversation for the detailed behavior; this README is a minimal quick-start.)
