# Command Verification Pattern

> Principle: Commands aren't real until you prove they ran. Exit codes and verbatim output are the proof.

---

## The Problem

**Agents fabricate outcomes.** When an agent reports "build succeeded" or "tests passed," there's no structural requirement to prove it. Self-reported success is worthless without verification.

**Real incident**: An agent claimed "build succeeded" when the build binary was locked by a running service. The build failed, but the agent reported success. The reviewer approved without re-running. Deploy failed. Rollback. Hours wasted.

**Why this matters**:
- **Trust requires verification** — Reagan's maxim applies to agents too
- **Fabrication is trivial** — Typing "Pass" is easier than running commands
- **Cascading failures** — Fake success in GEN → trusted in REVIEW → production failure
- **Evidence enables accountability** — Verbatim output creates an audit trail

---

## The Rule

**ALL commands** in evidence MUST include:

1. **Exit code** — the numeric exit code (0 for success, non-zero for failure)
2. **Verbatim output** — actual terminal output (last 15 lines minimum), copy-pasted not paraphrased

Self-reported "Pass" or "Success" without proof → **automatic REJECT**

**This is a HARD GATE.** No exceptions. Not even "build succeeded" without build output.

---

## Pattern: Three-Layer Verification

### Layer 1: Developer — Structured Evidence (REQUIRED)

Every command in evidence manifests must include exit code + verbatim output.

#### Evidence Format

```markdown
### Commands Run

| # | Command | Exit Code | Result |
|---|---------|-----------|--------|
| 1 | `npm run build` | 0 | Success |
| 2 | `npm test` | 0 | Success |

#### Command 1: `npm run build`
**Exit code**: 0
**Output** (last 15 lines):
```
> app@1.0.0 build
> tsc && webpack --mode production

asset main.js 87.3 KiB [emitted] [minimized] (name: main)
runtime modules 274 bytes 1 module
cacheable modules 156 KiB
  ./src/index.ts 2.1 KiB [built]
  + 42 modules
webpack 5.89.0 compiled successfully in 3204ms
```
**Interpretation**: Build succeeded with no errors. Generated main.js (87.3 KiB).

#### Command 2: `npm test`
**Exit code**: 0
**Output** (last 15 lines):
```
 PASS  src/__tests__/config.test.ts
 PASS  src/__tests__/parser.test.ts

Test Suites: 2 passed, 2 total
Tests:       42 passed, 42 total
Time:        4.521 s
```
**Interpretation**: All 42 tests passed across 2 test suites.
```

#### Rules

1. **Exit code is mandatory** — paste the actual exit code, not "success" or "fail"
2. **Output is verbatim** — copy-paste from terminal, not paraphrased summaries
3. **Last 15 lines minimum** — default to last 15 lines, include more if needed for context
4. **Include stderr if failed** — if exit code ≠ 0, paste error messages
5. **Interpretation is your reading** — explain what the output means (Reviewer will verify)

#### Good vs Bad Examples

**Good**:
```markdown
#### Command 1: `python -m pytest`
**Exit code**: 0
**Output** (last 15 lines):
```
============================= test session starts ==============================
platform linux -- Python 3.11.0, pytest-7.4.3
collected 42 items

tests/test_auth.py ......                                                [ 14%]
tests/test_parser.py ..................................               [100%]

============================== 42 passed in 2.31s ==============================
```
**Interpretation**: All 42 tests passed in 2.31 seconds.
```

**Bad** (auto-REJECT):
```markdown
#### Command 1: `python -m pytest`
**Exit code**: 0
**Interpretation**: Tests passed.
```
❌ No verbatim output — Reviewer cannot verify

**Bad** (auto-REJECT):
```markdown
#### Command 1: `python -m pytest`
**Output**: All tests completed successfully.
```
❌ Paraphrased, not verbatim — could be fabricated
❌ No exit code

---

### Layer 2: Reviewer — Verification by Re-Run (REQUIRED)

Reviewers MUST re-run a sample of Developer's commands and compare outputs.

#### Selection Strategy

**Re-run highest-risk commands**:
- ✅ Builds (`npm run build`, `dotnet build`, `cargo build`)
- ✅ Tests (`npm test`, `pytest`, `go test`)
- ✅ Deployments (`kubectl apply`, `terraform apply`)
- ✅ Validation (`curl`, health checks, smoke tests)
- ❌ Skip low-risk commands (`mkdir`, `echo`, `git status`)

**Why**: Builds and tests are most commonly fabricated. Filesystem commands are trivial to verify.

#### Re-Run Process

1. **Execute the same command** in the same directory
2. **Capture exit code** from your re-run
3. **Capture output** (last 15 lines)
4. **Compare** with Developer's claimed output:
   - Exit codes match?
   - Output shape similar? (same success/failure markers, similar structure)
   - If different — why? Environment changed, or Developer fabricated?

#### Comparison Rules

| Developer Exit Code | Reviewer Exit Code | Verdict | Action |
|---------------------|-------------------|---------|--------|
| 0 | 0 | ✅ Match | PASS |
| 0 | 1 | ❌ Mismatch | REJECT + FABRICATION FLAG |
| 1 | 1 | ⚠️ Both fail | PASS with note (honest about failure) |
| 0 | 0 (different output shape) | ⚠️ Suspicious | Investigate |

**Structural mismatch** = Developer says "42 tests passed" but Reviewer's re-run shows "39 passed, 3 failed"

#### Reviewer Evidence Format

```markdown
### Command Re-Run Verification

| Developer Command | Dev Exit Code | Reviewer Exit Code | Match | Notes |
|-------------------|--------------|-------------------|-------|-------|
| `npm run build` | 0 | 0 | ✅ | Output shape matches |
| `npm test` | 0 | 1 | ❌ | 3 tests fail — Developer claimed all pass |

#### Re-Run Details: `npm test`

**Reviewer exit code**: 1
**Reviewer output** (last 15 lines):
```
 FAIL  src/__tests__/validator.test.ts
  ● validates email format › rejects invalid email

    expect(received).toBe(expected)
    Expected: false
    Received: true

Test Suites: 1 failed, 2 passed, 3 total
Tests:       3 failed, 39 passed, 42 total
```

**Verdict**: Developer claimed "42 passed" but 3 tests fail on re-run. REJECT + FABRICATION FLAG.
```

---

### Layer 3: Auto-REJECT Rules (Reviewer)

Reviewer MUST auto-REJECT if ANY of these conditions are true:

#### Missing Evidence

- ❌ **COMMANDS_RUN section missing entirely** → REJECT
- ❌ **Any command lacks exit code** → REJECT
- ❌ **Any command lacks output snippet** → REJECT
- ❌ **Output is just "Pass" or "Success"** (no verbatim terminal output) → REJECT

#### Suspiciously Generic Output

- ❌ **"Build succeeded"** with no compiler output → REJECT
- ❌ **"Tests passed"** with no test framework output → REJECT
- ❌ **Paraphrased summaries** instead of terminal copy-paste → REJECT

#### Output Mismatch

- ❌ **Developer exit code ≠ Reviewer exit code** → REJECT + FABRICATION FLAG
- ❌ **Structural mismatch** (Developer says success, re-run shows failure) → REJECT + FABRICATION FLAG

---

## When to Apply

✅ **ALL commands in evidence**:
- Builds, tests, deployments
- Validations, health checks
- Diagnostic commands (`git status`, `npm list`)

✅ **Both success and failure**:
- If a command failed, that's fine — paste the exit code + error output
- Honesty about failures is better than fabricated success

❌ **What this does NOT cover**:
- Pre-flight checks (doesn't mandate specific checks)
- Automated enforcement (this is a process pattern, not a tool)
- Guaranteeing zero fabrication (makes fabrication structurally harder, not impossible)

---

## Benefits

**For Developers**:
- Clear specification: know exactly what evidence to provide
- Prevents reviewer push-back: if you paste output, no disputes
- Protects you: if build failed, paste the failure — honesty is rewarded

**For Reviewers**:
- Can verify independently: re-run commands and compare
- Can catch fabrication: structural mismatches are obvious
- Clear rejection criteria: no ambiguity about "insufficient evidence"

**For the System**:
- Trust through verification: evidence creates accountability
- Audit trail: command outputs are logged, traceable
- Cascading failure prevention: fake success caught at review, not production

---

## Wisdom Applied

**Thompson (#5 Engineering — Unix Philosophy)**:
- "Do one thing well" → This pattern does ONE thing: verify commands ran
- Applied in: Single-responsibility verification, not overloaded with other concerns

**Kernighan (Debugging Simplicity)**:
- "Debugging is twice as hard as writing code"
- Applied in: Verbatim output enables debugging; paraphrased summaries hide problems

**KISS Principle**:
- Simple mechanism (copy-paste output) prevents complex fabrication
- No special tools needed, just terminal output

---

## Examples: Full Evidence

### Good: Complete Evidence

```markdown
### Commands Run

| # | Command | Exit Code | Result |
|---|---------|-----------|--------|
| 1 | `npm install` | 0 | Success |
| 2 | `npm run build` | 0 | Success |
| 3 | `npm test` | 0 | Success |

#### Command 1: `npm install`
**Exit code**: 0
**Output** (last 15 lines):
```
added 342 packages, and audited 343 packages in 8s

52 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```
**Interpretation**: Dependencies installed successfully, no vulnerabilities.

#### Command 2: `npm run build`
**Exit code**: 0
**Output** (last 15 lines):
```
> app@1.0.0 build
> tsc && webpack --mode production

asset main.js 87.3 KiB [emitted] [minimized]
webpack 5.89.0 compiled successfully in 3204ms
```
**Interpretation**: TypeScript compiled, webpack bundled successfully.

#### Command 3: `npm test`
**Exit code**: 0
**Output** (last 15 lines):
```
 PASS  src/__tests__/config.test.ts
 PASS  src/__tests__/parser.test.ts

Test Suites: 2 passed, 2 total
Tests:       42 passed, 42 total
Time:        4.521 s
```
**Interpretation**: All 42 tests passed.
```

**Reviewer re-runs `npm test` and `npm run build`**:
- Both exit code 0
- Output shape matches Developer's paste
- Verdict: ✅ APPROVE

### Bad: Insufficient Evidence

```markdown
### Commands Run

| # | Command | Result |
|---|---------|--------|
| 1 | `npm run build` | Success |
| 2 | `npm test` | Pass |

#### Command 1: `npm run build`
Build completed successfully.

#### Command 2: `npm test`
All tests passed.
```

**Reviewer verdict**: ❌ REJECT
- Missing exit codes
- Missing verbatim output
- Paraphrased summaries, not terminal copy-paste
- Cannot verify any claims

---

## See Also

- `.meta/patterns/success_patterns.md` — Proven architectural patterns
- `.meta/patterns/antipatterns.md` — Common pitfalls to avoid
- `.meta/principles.md` — KISS, LEGO, Thompson #5
- `.meta/wisdom/engineering_wisdom.md` — Thompson, Knuth, Pike, Kernighan

---

## Meta: About This Pattern

**Time cost**: 30 seconds per command to copy-paste output

**Time saved**: Hours of debugging fabricated "success" claims

**Thompson's wisdom**: "One of my most productive days was throwing away 1,000 lines of code" — This pattern removes ambiguity with simple evidence, not complex verification systems.

If this pattern proves ineffective or burdensome, update THIS document first, then enforcement. Always doc-first (GEN+REVIEW).
