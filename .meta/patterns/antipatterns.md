# Antipatterns

Common mistakes in software development, with historical precedents, symptoms, and remedies. Learn from others' failures.

---

## 1. God Object / God LEGO

**Description**: A single class or module that knows too much or does too much.

**Historical Precedent**:
- Microsoft COM objects in the 1990s (monolithic, hard to test)
- Java EE "enterprise beans" that did everything
- WordPress's global `$wpdb` object

**Symptoms**:
- LEGO has > 3 responsibilities
- LEGO has > 1000 lines of code
- LEGO name contains "and" (e.g., `auth_and_logging_and_validation`)
- Many LEGOs depend on this one
- Difficult to test in isolation

**Why It Fails**:
- High coupling (change ripples everywhere)
- Hard to understand (too much to hold in head)
- Difficult to test (too many dependencies)
- Violates Single Responsibility Principle

**Remedy**:
1. Split into smaller LEGOs, each with one responsibility
2. Extract interfaces for different concerns
3. Use composition over inheritance
4. Follow Unix philosophy: "Do one thing well"

**Wisdom**: Dijkstra (#3 Engineering), Thompson (#5 Engineering)

---

## 2. Golden Hammer

**Description**: Using the same solution for every problem ("If all you have is a hammer, everything looks like a nail").

**Historical Precedent**:
- Overuse of XML in early 2000s for everything
- Blockchain hype (2017-2021): "We need blockchain for X!"
- Microservices for every project (2015+)

**Symptoms**:
- Every problem solved with same technology
- "Let's use our favorite framework" before understanding requirements
- Forcing a pattern where it doesn't fit
- Justifying technology before analyzing problem

**Why It Fails**:
- Not every problem is the same
- Technologies have trade-offs
- Overhead of wrong tool can exceed benefits

**Remedy**:
1. Start with requirements, not solutions
2. Evaluate multiple approaches
3. Match tool to problem, not problem to tool
4. Document why technology was chosen

**Wisdom**: Brooks (#9 Engineering - "No Silver Bullet")

---

## 3. Premature Optimization

**Description**: Optimizing code before it's proven necessary.

**Historical Precedent**:
- Hand-optimized assembly in 1980s (hard to maintain, compiler optimizations beat it later)
- Complex caching logic that wasn't needed
- "Scalable" microservices for 10 users/day

**Symptoms**:
- Complex code with no performance tests
- "We'll need to scale" without usage data
- Mentions "optimize", "cache", "parallel" in DESIGN phase
- Code is hard to read "for performance"

**Why It Fails**:
- Wastes time on non-bottlenecks
- Makes code harder to maintain
- Actual bottlenecks are often surprising (measure first!)
- "Clever" code is hard to debug (Kernighan)

**Remedy**:
1. Make it work first, then make it fast (if needed)
2. Profile before optimizing (identify real bottlenecks)
3. Set performance SLOs, measure against them
4. Optimize only proven hotspots

**Wisdom**: Knuth (#2 Engineering), Kernighan (#1 Engineering)

---

## 4. Not Invented Here (NIH) Syndrome

**Description**: Rejecting existing solutions in favor of building your own.

**Historical Precedent**:
- Companies building custom databases instead of using PostgreSQL/MySQL
- Rolling custom auth instead of using OAuth
- Custom logging frameworks instead of standard libraries

**Symptoms**:
- "Let's build our own X"
- Distrust of external libraries
- Large custom framework for common problems
- Many internal tools that duplicate open source

**Why It Fails**:
- Underestimating complexity (auth, crypto, databases are HARD)
- Maintenance burden of custom code
- Missing edge cases that OSS has solved
- Team time spent on non-core features

**Remedy**:
1. Default to established libraries
2. Custom code only if:
   - Existing solutions don't fit
   - Requirements are truly unique
   - Maintenance cost is justified
3. Document why custom was needed

**Wisdom**: Bentley (#12 Engineering - "Components that aren't there")

---

## 5. Cargo Cult Programming

**Description**: Using patterns/code without understanding why, just because "it's best practice".

**Historical Precedent**:
- Factories creating factories in Java (AbstractSingletonProxyFactoryBean)
- Design patterns overuse in 2000s
- Copy-pasting Stack Overflow without understanding

**Symptoms**:
- Code includes patterns "just in case"
- "That's how it's done" without explanation
- Layers of abstraction with no purpose
- Following "best practices" blindly

**Why It Fails**:
- Unnecessary complexity
- Code doesn't match actual needs
- Hard to maintain (no one knows why it's there)
- Violates KISS

**Remedy**:
1. Understand *why* before applying pattern
2. Challenge "best practices": "Why is this best?"
3. Prefer simple, direct solutions
4. Document reasoning for patterns used

**Wisdom**: Rams (#1.10 Design - "As little design as possible")

---

## 6. Magic Numbers and Strings

**Description**: Hard-coded values with no explanation.

**Historical Precedent**:
- Ancient C code with `if (status == 3)` (what's 3?)
- Configuration scattered in code
- Database queries with hard-coded IDs

**Symptoms**:
- Numbers/strings embedded in code
- No constants or enums
- `if (x == "active")` instead of `if (x == Status.ACTIVE)`
- Duplicate values across codebase

**Why It Fails**:
- Meaning is lost (what's 86400?)
- Changes require finding all instances
- Typos cause bugs (`"activ"` vs `"active"`)
- No type safety

**Remedy**:
1. Use named constants: `SECONDS_PER_DAY = 86400`
2. Enums for states: `Status.ACTIVE`, `Status.INACTIVE`
3. Configuration files for environment-specific values
4. Type systems to catch errors

**Wisdom**: Knuth (#11 Engineering - Literate Programming)

---

## 7. Stringly Typed

**Description**: Using strings where structured types should be used.

**Historical Precedent**:
- PHP's loose typing causing security issues
- JavaScript before TypeScript
- XML/JSON configs parsed manually

**Symptoms**:
- `user_role: str` instead of `user_role: UserRole`
- Parsing strings repeatedly
- String matching instead of type checking
- Runtime errors for typos

**Why It Fails**:
- No compile-time checks
- Typos cause runtime errors
- Hard to refactor (find all uses)
- IDEs can't help (no autocomplete)

**Remedy**:
1. Use type systems: enums, unions, ADTs
2. Parse once at boundaries, use types internally
3. Type hints in Python, TypeScript instead of JavaScript
4. Validation at API boundaries

**Wisdom**: Norman (#4.5 Design - Constraints)

---

## 8. Big Ball of Mud

**Description**: No coherent architecture; everything depends on everything.

**Historical Precedent**:
- Legacy enterprise codebases
- PHP websites before frameworks
- Spreadsheet-as-database applications

**Symptoms**:
- Circular dependencies
- Can't change one thing without breaking ten others
- No clear module boundaries
- Global state everywhere

**Why It Fails**:
- Impossible to reason about
- Can't test in isolation
- Changes have unpredictable effects
- Teams step on each other's toes

**Remedy**:
1. Define clear module boundaries (LEGOs)
2. Dependencies flow one direction (DAG)
3. Interfaces between modules
4. Eliminate global state

**Wisdom**: Alexander (#6 Engineering - Information Hiding), Kay (#6 Engineering - Message Passing)

---

## 9. Leaky Abstractions

**Description**: Abstraction that exposes underlying implementation details.

**Historical Precedent**:
- ORMs that require knowing SQL
- "Platform independent" code that needs OS-specific tweaks
- REST APIs that expose database structure

**Symptoms**:
- Users need to know implementation to use abstraction
- Documentation says "but sometimes you need to..."
- Abstraction doesn't hide what it should
- Inconsistent behavior across use cases

**Why It Fails**:
- Abstraction doesn't actually simplify
- Users need to learn two things (abstraction + implementation)
- Defeats purpose of abstraction

**Remedy**:
1. Redesign abstraction to hide implementation
2. Accept that some abstractions leak (Joel Spolsky's Law)
3. Document the leaks clearly
4. Or: don't abstract (sometimes worse than raw implementation)

**Wisdom**: Parnas (#10 Engineering - Information Hiding)

---

## 10. Analysis Paralysis

**Description**: Overthinking design instead of building and learning.

**Historical Precedent**:
- UML modeling for months before coding
- Perfect architecture meetings that never end
- "We need to consider every edge case first"

**Symptoms**:
- Weeks of planning, no code
- Endless design debates
- "But what if..." scenarios multiply
- No prototypes or experiments

**Why It Fails**:
- Requirements will change anyway
- Best designs emerge from feedback
- Perfect plan doesn't survive first contact
- Delays learning

**Remedy**:
1. Time-box design (e.g., 1 day max for LEGO design)
2. Build prototype to test assumptions
3. Iterate based on feedback
4. Boyd's OODA: fast cycles beat perfection

**Wisdom**: Boyd (#2 Strategic - OODA Loop), Boyd (#14 Strategic - Rapid Tempo)

---

## 11. Resume-Driven Development

**Description**: Choosing technologies to learn them, not because they fit.

**Historical Precedent**:
- Blockchain for internal tools
- Kubernetes for 3-person team
- GraphQL for simple CRUD app

**Symptoms**:
- "Let's use X because it's hot"
- Overcomplicated stack for problem size
- Technology doesn't match requirements
- Team unfamiliar with chosen tech

**Why It Fails**:
- Learning curve delays delivery
- Complexity exceeds benefit
- Tech doesn't actually solve problem
- Team fights tooling instead of building product

**Remedy**:
1. Choose tech based on requirements
2. Favor team's existing skills (faster)
3. Trendy tech only if it solves specific problem
4. Experiments in side projects, not production

**Wisdom**: Taleb (#13 Strategic - Lindy Effect), Brooks (#9 Engineering - No Silver Bullet)

---

## 12. Shotgun Surgery

**Description**: One change requires modifying many unrelated places.

**Historical Precedent**:
- Copy-pasted code across codebase
- No shared constants or functions
- Scattered business logic

**Symptoms**:
- Bug fix requires touching 10 files
- Feature requires changes in 20 places
- Hard to find all instances of a pattern
- Duplicate code everywhere

**Why It Fails**:
- Easy to miss a place (bugs)
- Tedious and error-prone
- Indicates poor abstraction
- Refactoring becomes impossible

**Remedy**:
1. DRY: Don't Repeat Yourself
2. Extract shared logic to common functions/modules
3. Single source of truth for each concept
4. Refactor before it gets worse

**Wisdom**: Bentley (#12 Engineering), Parnas (#10 Engineering)

---

## 13. Lava Flow

**Description**: Dead code that no one dares to remove.

**Historical Precedent**:
- Ancient C code with `#ifdef` for systems that don't exist
- Commented-out code "just in case"
- Unused imports and functions

**Symptoms**:
- Code with comments "don't touch this"
- Functions that are never called
- Imports that aren't used
- "I don't know what this does, but I'm afraid to delete it"

**Why It Fails**:
- Increases cognitive load
- Misleads developers
- Makes codebase larger and slower
- Risk of accidentally using dead code

**Remedy**:
1. Delete unused code (version control remembers)
2. If unsure, add deprecation warning and monitor usage
3. Regular cleanup: find unused functions, delete them
4. Tests give confidence to delete

**Wisdom**: Taleb (#10 Strategic - Via Negativa)

---

## 14. Inner Platform Effect

**Description**: Building a generic, configurable system that reimplements the platform it runs on.

**Historical Precedent**:
- Custom DSLs that are worse than the host language
- XML-based "programming languages"
- Over-abstracted frameworks that reinvent loops, functions, etc.

**Symptoms**:
- System is "fully configurable"
- Configuration is Turing-complete
- Invented a mini-language
- Solving problems the platform already solves

**Why It Fails**:
- Poorly implemented platform features
- Adds complexity instead of reducing it
- Users need to learn your mini-platform
- Violates KISS

**Remedy**:
1. Use the platform's features directly
2. Configuration should be data, not code
3. If you need a language, use an existing one
4. Avoid "make everything configurable" mindset

**Wisdom**: Rams (#1.10 Design), Bentley (#12 Engineering)

---

## 15. No Tests / Too Many Tests

**Description**: Either no tests (fragile) or tests that are brittle and slow (maintenance burden).

**Historical Precedent**:
- 2000s: No tests, "just test manually"
- 2010s: 100% coverage including trivial getters
- Brittle integration tests that fail randomly

**Symptoms**:
- **No tests**: Fear of refactoring, bugs in production
- **Too many tests**: Hours to run, break on every change

**Why It Fails**:
- No tests: No confidence, regression bugs
- Too many tests: Slows development, false failures

**Remedy**:
1. Test pyramid: More unit, fewer integration, fewest E2E
2. Test behavior, not implementation
3. Critical paths well-tested, trivial code less so
4. Fast tests (< 1 minute total), reliable tests (no flakes)

**Wisdom**: TESTING_STRATEGY.md in this repo

---

## How to Use Antipatterns

### During REQUIREMENTS Phase
- Watch for #11 (Resume-Driven Development)

### During LEGO Discovery
- Avoid #1 (God LEGO), #8 (Big Ball of Mud)

### During DESIGN Phase
- Avoid #2 (Golden Hammer), #3 (Premature Optimization), #4 (NIH), #5 (Cargo Cult), #14 (Inner Platform)

### During CODING Phase
- Avoid #6 (Magic Numbers), #7 (Stringly Typed)

### During REVIEW Phase
- Check for #9 (Leaky Abstractions), #12 (Shotgun Surgery), #13 (Lava Flow)

### During VALIDATION Phase
- Ensure #15 (appropriate test coverage)

---

## Adding New Antipatterns

To document a new antipattern:

1. **Name it**: Short, memorable name
2. **Historical precedent**: Real-world examples
3. **Symptoms**: How to recognize it
4. **Why it fails**: Root causes
5. **Remedy**: How to fix or avoid
6. **Wisdom link**: Which principles it violates

---

## 16. Fabrication Antipattern

**Description**: Agent claims work is complete without providing verifiable evidence. Says "done" without showing artifacts.

**Historical Precedent**:
- LLM systems claiming "I verified" but showing no verification output
- CI/CD reports claiming "tests pass" but failing to include logs
- Code reviews claiming "looks good" without citing specific checks
- Deployment scripts claiming success but not showing deployment state

**Symptoms**:
- Agent says "I verified" but shows no verification output
- Agent says "tests pass" but doesn't paste test output
- Agent claims file exists but it doesn't
- Agent describes changes that don't match actual diffs
- Agent says "completed successfully" without evidence manifest

**Root Cause**: 
- LLM optimization for helpfulness/completion over accuracy
- No enforcement of evidence requirements
- Trust-based rather than verify-based workflows

**Why It Fails**:
- Cannot distinguish real completion from hallucinated completion
- Downstream work built on false assumptions
- Debugging becomes impossible (what actually happened?)
- Erodes trust in automation

**Prevention**:
- Require structured evidence manifests for all work
- Independent verification by orchestrator (don't trust self-reported completion)
- "Show me" posture: no evidence = no accept
- Automated checks for file existence, test output, command success

**Remedy**: 
Implement evidence manifests and verification gates. Treat missing evidence as automatic rejection.

**Wisdom**: Norman (#4.5 Design — Constraints make errors impossible), Schneier (#3 Security — Don't trust, verify)
