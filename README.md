# Meta Metacognition Pipeline (Codex CLI)

This repository defines a **hierarchical, LEGO-based, KISS-driven, meta-cognitive R&D pipeline** orchestrated through **Codex CLI**, supporting **both Bash (macOS/Linux)** and **PowerShell (Windows)**.

You run **one command**, and Codex:

- Performs environment preflight  
- Extracts requirements interactively  
- Designs LEGO modules  
- Optionally pauses for architecture approval  
- Spawns one Codex session per LEGO block  
- Executes design, tests, docs, code, validation  
- Applies GEN + REVIEW at every step  
- Uses restartable pipeline state  
- Enforces session hygiene  
- Checks safety valves  
- Supports FAST vs THOROUGH R&D modes  

---

# 📁 Files YOU must create before running

Inside the repository root (e.g., `meta-metacognition/`), create:

```
intent.md
principles.md
AGENTS.md
meta_config.json   (optional)
README.md          (this file)
```

Codex will generate everything else.

---

# 🚀 How to Run (Bash + PowerShell instructions)

Codex CLI works on macOS, Linux, and Windows.  
Below are **equivalent commands** for both environments.

---

## 🚀 1. **Initial Kickoff – Meta-Orchestrator Run**

### **Bash (macOS/Linux)**

```bash
cd meta-metacognition
codex exec "Act as the meta-orchestrator described in AGENTS.md. Read intent.md, principles.md, and meta_config.json. Perform environment preflight, minimal interactive requirement extraction, discover LEGO blocks, generate the pipeline, and execute all LEGO substeps using nested Codex CLI sessions with checkpoints and safety valves."
```

### **PowerShell (Windows)**

```powershell
cd meta-metacognition
codex exec "Act as the meta-orchestrator described in AGENTS.md. Read intent.md, principles.md, meta_config.json. Perform environment preflight, minimal interactive requirement extraction, discover LEGO blocks, generate the pipeline, and execute all LEGO substeps using nested Codex CLI sessions with checkpoints and safety valves."
```

Both commands do the same thing—Windows just doesn’t need line continuation characters.

---

## 🔁 2. **Resume Later**

If Codex gets interrupted OR you want to continue the pipeline:

### **Bash**

```bash
codex exec resume --last "Continue the meta-orchestrator pipeline."
```

### **PowerShell**

```powershell
codex exec resume --last "Continue the meta-orchestrator pipeline."
```

Same invocation for both.

---

# 🧱 What Codex Will Generate

During execution, Codex CLI automatically creates:

```
requirements.md
lego_plan.json
plan.md
system_prompt_global.txt
orchestrator_state.json
lego_state_<name>.json
src/<lego_name>.<ext>
tests/<lego_name>_tests.<ext>
internal-notes.md
review.md
env_diagnostics.md    (if environment/permissions fail)
meta_error.md         (if safety valve triggers)
```

---

# 🧠 How the Pipeline Works (Step-by-Step)

## 1. **Environment Preflight**

Codex tests whether it can:

- Run shell commands (`pwd`, `ls/dir`, `echo`).  
- Write/read files in the repo.  

If not → it logs details in **`env_diagnostics.md`**.

---

## 2. **Interactive Requirement Extraction**  
*(Minimal questions, maximum inference)*

Codex asks a handful of strategic questions:

- “What is the main purpose of this app?”  
- “Any important constraints?”  
- “Any external APIs?”  
- “Is any data sensitive?”

Then Codex:

- Writes `requirements.md` (GEN)  
- Performs a REVIEW step with a nested Codex call  

After this: **no more questions** unless truly blocked.

---

## 3. **LEGO Discovery (KISS)**

Codex breaks the app into **single-purpose LEGO blocks**, creating:

- `lego_plan.json`

Each block has:

- One responsibility  
- Inputs/Outputs  
- Sensitivity classification  
- Agent/LLM needs  
- Fundamentals (perf/scale/security/privacy/cost)

---

## 4. **Optional Architecture Approval**

If `meta_config.json` contains:

```json
"require_lego_plan_approval": true
```

Codex pauses and asks:

> “Do you approve this lego plan and high-level design?”

Default = **no pause**.

---

## 5. **LEGO-Orchestrator Sessions**

Codex launches new sessions such as:

```
codex exec "Act as the LEGO-Orchestrator for <lego_name>..."
```

Each session handles (GEN+REVIEW):

1. Design  
2. Tests  
3. Documentation  
4. Coding  
5. Validation (tests, lint, behavior checks, red-team if sensitive)

Session hygiene:  
After ~3–5 tasks, each LEGO orchestrator:

- Saves `lego_state_<name>.json`
- Exits
- Allows clean resume later

---

## 6. **Safety Valves**

Codex halts safely if:

- A step fails ≥ 3 times  
- Progress stalls  
- Requirements are contradictory  

It writes details to:

- `meta_error.md`

---

## 7. **Finalization**

When all LEGO blocks are complete:

Codex produces:

- Updated `README.md` (project-level)
- `internal-notes.md`
- `review.md` summarizing:
  - Architecture  
  - Fundamentals  
  - Evaluation  
  - Red-team findings  
  - Risks  
  - Recommendations  

Your system is now complete.

---

# 🧩 Example: Full Workflow

Suppose `intent.md` says:

> Build a receipt uploader + OCR total extractor with privacy safeguards.

### Run the pipeline:

### **Bash**

```bash
codex exec "Act as the meta-orchestrator described in AGENTS.md..."
```

### **PowerShell**

```powershell
codex exec "Act as the meta-orchestrator described in AGENTS.md..."
```

Codex will:

- Ask 3–6 clarifying questions  
- Generate `requirements.md`  
- Create `lego_plan.json`  
- Build each LEGO in nested sessions  
- Produce all code, tests, docs, final review

After restarting or returning later:

```bash
codex exec resume --last
```

```powershell
codex exec resume --last
```

Codex resumes from exact state.

---

# 📦 Using This Repo as a Template

To build a new system:

1. Copy this entire repo into a new folder  
2. Edit `intent.md` to describe the new app  
3. Update `principles.md` or `meta_config.json` if needed  
4. Run:

### **Bash**

```bash
codex exec "Act as the meta-orchestrator described in AGENTS.md..."
```

### **PowerShell**

```powershell
codex exec "Act as the meta-orchestrator described in AGENTS.md..."
```

---

# 🆘 Troubleshooting

### Codex cannot run shell commands  
Check:
- Codex CLI permissions
- Windows security policies  
See `env_diagnostics.md` for details.

### Pipeline stuck  
Check `meta_error.md` for the LEGO/step that failed and suggested fixes.

### Need deep R&D mode  
Set `"r_and_d_mode": "thorough"` in `meta_config.json`.

### Want architecture approval before coding  
Set `"require_lego_plan_approval": true`.

---

# 🎉 Summary

This repository is a **universal agentic R&D engine**.

With **one command**, Codex will:

- Extract requirements  
- Build a LEGO architecture  
- Generate tests, docs, code  
- Perform evaluation/red-team  
- Maintain state  
- Produce a complete, KISS-driven software system  

All with full support for **Bash and PowerShell** workflows.
