# Engineering Wisdom

Distilled principles from legendary engineers and computer scientists. Each principle includes:
- **Source**: Who said it and context
- **Principle**: The core wisdom
- **Application**: How the meta-orchestrator uses it
- **Trigger**: When this principle activates
- **Action**: What to do when triggered

---

## 1. Kernighan's Debugging Principle

**Source**: Brian Kernighan, "The Elements of Programming Style" (1974)

**Principle**:
> "Everyone knows that debugging is twice as hard as writing a program in the first place. So if you're as clever as you can be when you write it, how will you ever debug it?"

**Application**: Favor simple, readable code over clever optimizations.

**Trigger**:
- Cyclomatic complexity > 10
- Nesting depth > 3
- Function length > 50 lines
- Uses language tricks or obscure features
- Comments say "clever hack" or "magic number"

**Action**:
1. Flag during REVIEW phase
2. Ask: "Will this be debuggable in 6 months?"
3. If NO, reject and request simpler implementation
4. Suggest decomposition into smaller functions

---

## 2. Knuth's Premature Optimization

**Source**: Donald Knuth, "Structured Programming with go to Statements" (1974)

**Principle**:
> "Premature optimization is the root of all evil (or at least most of it) in programming."

**Application**: Defer performance work until basic functionality is validated.

**Trigger**:
- DESIGN or CODING phase mentions: "optimize", "cache", "parallel", "performance"
- BEFORE validation passes and tests confirm correctness
- No profiling data exists to justify optimization

**Action**:
1. Flag during REVIEW
2. Move optimization to "Future Improvements" section
3. Require validation phase to pass first
4. If performance IS a stated requirement, add performance tests to validation

---

## 3. Dijkstra's Simplicity

**Source**: Edsger Dijkstra, "The Humble Programmer" (1972)

**Principle**:
> "Simplicity is prerequisite for reliability."

**Application**: Every LEGO design must be as simple as possible.

**Trigger**:
- ALWAYS active in DESIGN and REVIEW phases
- Any LEGO with > 3 responsibilities
- Any interface with > 5 public methods
- Any module with > 10 dependencies

**Action**:
1. In every REVIEW, ask: "Can this be simpler?"
2. If YES, reject and regenerate
3. Challenge every dependency: "Is this necessary?"
4. Split complex LEGOs into smaller ones

---

## 4. Pike's Rule of Simplicity

**Source**: Rob Pike, "Notes on Programming in C" (1989)

**Principle**:
> "Fancy algorithms are slow when n is small, and n is usually small. Fancy algorithms have big constants. Until you know that n is frequently going to be big, don't get fancy."

**Application**: Use simple data structures and algorithms by default.

**Trigger**:
- DESIGN proposes: hash maps with custom hashers, red-black trees, skip lists
- BEFORE profiling shows simple approaches (arrays, dicts) are insufficient
- Mentions "scalability" without concrete scale requirements

**Action**:
1. Default to: arrays, dicts, simple loops
2. Require proof of scale need (e.g., "will process 10M records")
3. If scale is proven, document the requirement and benchmark

---

## 5. Thompson's Unix Philosophy

**Source**: Ken Thompson, summarized by Doug McIlroy (1978)

**Principle**:
> "Do one thing and do it well."

**Application**: Every LEGO has exactly one responsibility.

**Trigger**:
- LEGO name contains "and" (e.g., "auth_and_logging")
- LEGO description has multiple clauses (e.g., "handles X, Y, and Z")
- LEGO has > 3 public interfaces

**Action**:
1. Reject during LEGO discovery
2. Split into separate LEGOs
3. Each LEGO should complete the sentence: "This LEGO is responsible for ______."
4. If you need "and" to complete the sentence, split it

---

## 6. Kay's Message Passing

**Source**: Alan Kay, on Smalltalk and object-oriented design (1998)

**Principle**:
> "I thought of objects being like biological cells and/or individual computers on a network, only able to communicate with messages."

**Application**: LEGOs communicate via clear interfaces, not shared state.

**Trigger**:
- LEGO accesses another LEGO's internal state directly
- Global variables or singletons used for communication
- Tight coupling between LEGOs (e.g., importing internal modules)

**Action**:
1. Flag during DESIGN review
2. Require explicit interfaces (function calls, message queues, APIs)
3. Prohibit direct state access across LEGO boundaries
4. Use dependency injection for LEGO collaboration

---

## 7. Torvalds' Taste

**Source**: Linus Torvalds, TED Talk (2016) on "good taste" in code

**Principle**:
> "Good taste" in code means eliminating edge cases and special handling through elegant design.

**Application**: Designs should eliminate special cases, not accumulate them.

**Trigger**:
- Code has multiple `if` statements for edge cases
- Comments say "special case for X"
- Different code paths for similar operations

**Action**:
1. During REVIEW, identify edge cases
2. Ask: "Can we redesign so this isn't a special case?"
3. Prefer designs where edge cases are handled naturally
4. Example: Linked list removal without special "head node" case

---

## 8. Hoare's Null Reference

**Source**: Tony Hoare, "Null References: The Billion Dollar Mistake" (2009)

**Principle**:
> "I call it my billion-dollar mistake... the invention of the null reference."

**Application**: Avoid null/None when possible; use Optional types or empty objects.

**Trigger**:
- Functions return null/None to indicate "no result"
- Null checks scattered throughout code
- Language supports Optional/Maybe types but not used

**Action**:
1. In DESIGN, require explicit handling:
   - Use Optional[T] or Result[T, Error] types
   - Return empty collections instead of null
   - Throw exceptions for true errors, not "not found"
2. In REVIEW, flag bare null returns

---

## 9. Brooks' No Silver Bullet

**Source**: Fred Brooks, "No Silver Bullet" (1986)

**Principle**:
> "There is no single development, in either technology or management technique, which by itself promises even one order of magnitude improvement."

**Application**: Avoid over-reliance on any single tool, framework, or pattern.

**Trigger**:
- Design assumes a framework will "solve everything"
- Dependencies on heavyweight frameworks (e.g., full ORM for simple CRUD)
- User asks for "the best" without defining success criteria

**Action**:
1. During REQUIREMENTS, clarify actual needs vs perceived solutions
2. Start with minimal dependencies
3. Add complexity only when justified
4. Document why each dependency was chosen

---

## 10. Parnas' Information Hiding

**Source**: David Parnas, "On the Criteria To Be Used in Decomposing Systems" (1972)

**Principle**:
> "Modules should hide design decisions. Expose only what's necessary."

**Application**: LEGO interfaces should be minimal and stable.

**Trigger**:
- LEGO exposes internal data structures
- Public API has > 10 methods
- Interface includes "get_internal_state()" or similar

**Action**:
1. During DESIGN, minimize public interface
2. Hide implementation details (data structures, algorithms)
3. Expose behavior, not data
4. Use the "need to know" principle: if callers don't need it, don't expose it

---

## 11. Knuth's Literate Programming

**Source**: Donald Knuth, "Literate Programming" (1984)

**Principle**:
> "Let us change our traditional attitude to the construction of programs: Instead of imagining that our main task is to instruct a computer what to do, let us concentrate rather on explaining to human beings what we want a computer to do."

**Application**: Code should be readable and self-documenting.

**Trigger**:
- ALWAYS active in CODING and DOCUMENTATION phases
- Functions lack docstrings
- Variable names are abbreviated (x, tmp, data)
- No comments explaining "why" decisions were made

**Action**:
1. Require docstrings for all public functions
2. Enforce meaningful variable names
3. Comments explain "why", not "what"
4. Complex logic must have explanatory comments

---

## 12. Bentley's Rules

**Source**: Jon Bentley, "Programming Pearls" (1986)

**Principle**:
> "The cheapest, fastest, and most reliable components are those that aren't there."

**Application**: The best code is no code. Eliminate unnecessary features.

**Trigger**:
- Requirements include "nice to have" features
- LEGO includes functionality not in requirements
- User says "maybe we should also..."

**Action**:
1. During REQUIREMENTS, separate "must have" from "nice to have"
2. Implement only "must have" in initial build
3. Mark "nice to have" as future enhancements
4. Challenge every feature: "What if we don't build this?"

---

## 13. Liskov Substitution Principle

**Source**: Barbara Liskov, "Data Abstraction and Hierarchy" (1987)

**Principle**:
> "Objects of a superclass should be replaceable with objects of a subclass without breaking the application."

**Application**: Subtypes must honor the contracts of their base types.

**Trigger**:
- LEGO inheritance is used
- Subclass changes behavior unexpectedly
- Subtypes have stricter preconditions or weaker postconditions

**Action**:
1. During DESIGN, prefer composition over inheritance
2. If inheritance is used, validate substitutability
3. Ensure subclasses don't violate parent contracts
4. Consider using interfaces/protocols instead of inheritance

---

## 14. Wirth's Stepwise Refinement

**Source**: Niklaus Wirth, "Program Development by Stepwise Refinement" (1971)

**Principle**:
> "Start with high-level design and progressively refine it into detailed implementation."

**Application**: LEGO design should start abstract and become concrete iteratively.

**Trigger**:
- ALWAYS active during DESIGN phase
- Jump directly to implementation details
- No high-level design documented

**Action**:
1. Start DESIGN with high-level behavior
2. Refine progressively: interfaces → data flow → algorithms → implementation
3. Review after each refinement step
4. Ensure each level is complete before moving to next

---

## 15. Carmack's Functional Programming

**Source**: John Carmack, "Functional Programming in C++" (2012)

**Principle**:
> "Pure functions with no side effects are easier to reason about, test, and parallelize."

**Application**: Prefer pure functions where possible; isolate side effects.

**Trigger**:
- Function modifies global state
- Function has side effects not obvious from signature
- Function is difficult to unit test (requires complex setup)

**Action**:
1. During CODING, separate pure logic from I/O
2. Push side effects to edges of system
3. Core business logic should be pure functions
4. Makes testing easier and code more reliable

---

## How to Use This Wisdom

### During DESIGN Phase
- Consult principles 3, 4, 5, 6, 9, 10, 13, 14
- Ask: Is this simple? Does it do one thing? Is the interface minimal?

### During CODING Phase
- Consult principles 1, 2, 7, 8, 11, 12, 15
- Ask: Is this debuggable? Is it premature optimization? Is it readable?

### During REVIEW Phase
- Consult ALL principles
- Systematically check each principle
- Document which wisdom was applied
- **Check for outdated patterns**: If code references external APIs, packages, or frameworks:
  - Trigger web research (see `[P-WEB]` in `.meta/principles.md`)
  - Verify current versions, API signatures, security advisories
  - Flag deprecated patterns for update

### During VALIDATION Phase
- Verify that wisdom was followed
- Tests should validate simplicity and correctness
- Performance tests only if optimization was justified

---

## 16. Web Research Trigger (Current Information)

**Source**: Meta-orchestrator operational experience (2024)

**Principle**:
> "AI agents work with frozen training data. For external dependencies (APIs, packages, frameworks), always verify current information from official documentation."

**Application**: Consult online documentation when using external dependencies to ensure correctness and security.

**Trigger**:
- Code references external APIs (OpenAI, Anthropic, Azure, AWS, Google, etc.)
- Installing or upgrading packages (Python, npm, NuGet, etc.)
- Using framework-specific patterns (React, FastAPI, Django, etc.)
- Security-critical operations (authentication, cryptography, authorization)
- Cloud service configuration (Azure, AWS, GCP)

**Action**:
1. Search official documentation for current information:
   - API endpoints and authentication methods
   - Latest package versions and security advisories
   - Current framework best practices
   - Security guidance and CVEs
2. Verify sources are authoritative (official docs, package registries, security databases)
3. Document research in code comments and design docs:
   ```markdown
   ## Web Research (YYYY-MM-DD)
   - Source: [URL]
   - Current version: [version]
   - Key findings: [summary]
   ```
4. If information conflicts with training data, prefer current documentation
5. Flag if unable to verify currency (user should manually check)

**Related**: See `[P-WEB]` in `.meta/principles.md` for detailed guidance on when/what/how to search.

---

## 17. Self-Awareness & Rathole Prevention

**Source**: Meta-orchestrator operational experience (2024-2025)

**Principle**:
> "When deep in problem-solving, agents can lose sight of the bigger picture. Every change must be validated against architectural principles before implementation. If you've been focused on one issue for 3+ iterations without resolution, STOP and reassess."

**Application**: Prevent tunnel vision that leads to changes misaligned with KISS, LEGO principles, and the app's core essence.

**Trigger**:
- More than 3 failed attempts to solve the same problem
- Solution complexity exceeds the problem complexity
- Fix requires changes to 5+ unrelated files
- Solution introduces new dependencies to "solve" a local issue
- Agent has been focused on one issue for extended period
- Proposed change contradicts earlier architectural decisions
- "Quick fix" that violates established patterns
- Growing scope during implementation ("while I'm here, I'll also...")

**Action**:
1. **STOP and Surface**: When any trigger fires, pause immediately
2. **Zoom Out**: Re-read `essence.md` and `AGENTS.md` - what's the core purpose?
3. **Architectural Check**: Does this solution align with:
   - KISS (simplest correct solution?)
   - LEGO principles (single responsibility maintained?)
   - Thompson #5 (does each component still do one thing well?)
   - Control flow (does data still flow cleanly?)
   - Existing patterns (or are we inventing new ones unnecessarily?)
4. **Rathole Detection**: Ask:
   - "Am I solving the original problem or a symptom?"
   - "Is this fix proportional to the problem?"
   - "Would a fresh perspective see an obvious simpler approach?"
   - "Am I adding complexity to avoid admitting the design is wrong?"
5. **Reset if Needed**: If >3 iterations without resolution:
   - Document what was tried and why it failed
   - Step back to the last known-good state
   - Consider if the requirement itself needs clarification
   - Ask: "Is this problem solvable within current architecture?"
6. **Seek Higher Context**: If architectural misalignment detected:
   - Flag for discussion before proceeding
   - Document the tension between current approach and principles
   - Propose architectural revision if warranted

**Self-Awareness Checkpoints**:
- Every 3 implementation iterations, run architectural alignment check
- Before committing any change, verify it doesn't violate established patterns
- When adding workarounds, flag as technical debt (don't normalize)
- If justifying complexity with "edge cases", reconsider the design

**Red Flags** (immediate STOP):
- "This is the only way" (usually isn't)
- "It's complicated because the requirements are complicated" (often solvable differently)
- "Just this one exception" (exceptions breed exceptions)
- "I'll refactor later" (you won't)
- "The tests will catch issues" (tests test what you write, not what you should write)

---

## 18. Control Flow & Data Flow Awareness

**Source**: Structured programming principles (Dijkstra, Hoare, Parnas)

**Principle**:
> "Every system has two fundamental flows: control flow (who decides what happens) and data flow (what information moves where). All architectural decisions must consider both. A beautiful control flow with chaotic data flow is still a mess."

**Application**: When designing, implementing, or reviewing, explicitly trace both control flow and data flow.

**Trigger**:
- ALWAYS during DESIGN phase
- When adding new features
- When debugging unexpected behavior
- When reviewing code changes
- When data appears in unexpected places
- When control logic becomes convoluted

**Action**:

### Control Flow Analysis
1. **Map Decision Points**: Who decides what happens?
   - Entry points (API routes, CLI commands, event handlers)
   - Branching logic (if/else, switches, polymorphism)
   - Error handling (try/catch, Result types, fallbacks)
   - Concurrency (async, threads, queues)
   
2. **Validate Control Flow Principles**:
   - Single entry/single exit per function (where practical)
   - Clear ownership (one component owns each decision)
   - No hidden control (callbacks calling callbacks calling callbacks)
   - Fail-fast at boundaries (validate inputs early)

### Data Flow Analysis  
1. **Trace Data Movement**: Where does data originate, transform, terminate?
   - Sources (user input, API responses, database reads, config)
   - Transformations (parsing, validation, enrichment, aggregation)
   - Sinks (database writes, API calls, UI rendering, logs)
   
2. **Validate Data Flow Principles**:
   - Data immutability (prefer transformations over mutations)
   - Clear ownership (one component owns each data type)
   - No hidden data paths (side effects, global state, implicit caching)
   - Validation at boundaries (never trust external data)

### Combined Analysis
1. **Map Interactions**: Where do control and data flows intersect?
   - Data-driven branching (content determines path)
   - Control-driven data access (path determines what data)
   - Error data propagation (how errors carry context)
   
2. **Identify Smells**:
   - Control flow depending on data internals (violates encapsulation)
   - Data transformed based on control path (should be explicit)
   - Hidden side effects (control looks simple but data changes unexpectedly)

**Documentation Template**:
```
## Control Flow: {Feature}
Entry: [where it starts]
Decision Points: [key branches]
Exit: [where it ends, including error paths]

## Data Flow: {Feature}
Source: [where data originates]
Transformations: [what changes]
Sink: [where data ends up]

## Flow Interaction Notes:
[Any non-obvious interactions between control and data]
```

**Wisdom Applied**:
- Thompson #5: Each LEGO should have clear control boundaries
- Dijkstra #3: Simple control flow enables reliability
- Parnas #6: Information hiding requires clean data flow boundaries

---

## Adding Your Own Wisdom

To add new engineering wisdom:

1. Identify the source and context
2. State the principle concisely
3. Define clear triggers (when does this apply?)
4. Specify concrete actions (what should the meta-orchestrator do?)
5. Test with real examples

Engineering wisdom should be:
- **Timeless**: True regardless of technology trends
- **Actionable**: Clear what to do when triggered
- **Falsifiable**: Can be tested/verified
- **General**: Applies across domains and languages
