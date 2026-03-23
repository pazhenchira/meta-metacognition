# Design Wisdom

Distilled principles from legendary designers and architects. These principles help the meta-orchestrator create intuitive, elegant, and user-centered systems.

---

## 1. Rams' Good Design Principles

**Source**: Dieter Rams, Industrial Designer (Braun, 1970s)

**Principle**: Ten Principles of Good Design

### 1.1 Good Design is Innovative
> "Innovation should not just be about technology, but about improving user experience."

**Application**: New features must improve usability, not just add complexity.

**Trigger**:
- New feature requests
- Technology choices
- LEGO design phase

**Action**:
1. Ask: "Does this improve user experience?"
2. Reject features that add complexity without clear benefit
3. Prefer innovations that solve real problems

---

### 1.2 Good Design Makes a Product Useful
> "A product is bought to be used. It has to satisfy certain criteria, not only functional, but also psychological and aesthetic."

**Application**: Every LEGO must have clear utility; remove unused features.

**Trigger**:
- Feature planning
- API design
- LEGO interface design

**Action**:
1. Require clear use case for every feature
2. Remove functionality that hasn't been used in 6 months
3. APIs should expose only what users need

---

### 1.3 Good Design is Aesthetic
> "The aesthetic quality of a product is integral to its usefulness."

**Application**: Code and interfaces should be clean and pleasant to read/use.

**Trigger**:
- Code review
- API design
- User-facing interfaces

**Action**:
1. Enforce consistent formatting (linters, formatters)
2. Require meaningful names (no `x`, `tmp`, `data`)
3. UI should be visually clean and uncluttered
4. Code should "look right" (good taste, per Torvalds)

---

### 1.4 Good Design Makes a Product Understandable
> "It clarifies the product's structure. Better still, it can make the product talk."

**Application**: System architecture and APIs should be self-explanatory.

**Trigger**:
- Architecture design
- API naming
- Documentation phase

**Action**:
1. Names should reveal intent:
   - `authenticate_user()` not `auth()`
   - `EmailValidator` not `EV`
2. Architecture should be obvious from file structure
3. RESTful APIs should be predictable
4. Error messages should explain what went wrong and how to fix it

---

### 1.5 Good Design is Unobtrusive
> "Products fulfilling a purpose are like tools. They are neither decorative objects nor works of art."

**Application**: Infrastructure should be invisible to users; don't show internals.

**Trigger**:
- User-facing features
- API responses
- Error messages

**Action**:
1. Hide implementation details:
   - Don't expose database IDs in URLs unless necessary
   - Don't show stack traces to end users
   - Internal service names shouldn't leak into UI
2. Infrastructure LEGOs (logging, monitoring) should be silent when working

---

### 1.6 Good Design is Honest
> "It does not make a product more innovative, powerful or valuable than it really is."

**Application**: Don't oversell capabilities; be explicit about limitations.

**Trigger**:
- Documentation
- API contracts
- Feature descriptions

**Action**:
1. Document limitations clearly:
   - "Supports up to 1000 users"
   - "Rate limited to 100 requests/minute"
2. APIs should fail predictably, not silently
3. Don't promise features not yet implemented

---

### 1.7 Good Design is Long-lasting
> "It avoids being fashionable and therefore never appears antiquated."

**Application**: Avoid trendy patterns; use timeless approaches.

**Trigger**:
- Technology selection
- Architecture decisions
- Design patterns

**Action**:
1. Prefer established patterns (MVC, REST, pub/sub)
2. Avoid framework-specific magic (stay portable)
3. Use standard protocols (HTTP, JSON, SQL)
4. Lindy Effect: proven tech over trendy tech

---

### 1.8 Good Design is Thorough Down to the Last Detail
> "Nothing must be arbitrary or left to chance."

**Application**: Every detail should be intentional, especially edge cases.

**Trigger**:
- Code review
- Testing phase
- Error handling

**Action**:
1. Handle all edge cases:
   - Empty lists, null values, network errors
2. Every function should define behavior for invalid input
3. Tests should cover edge cases, not just happy path
4. Error messages should be precise

---

### 1.9 Good Design is Environmentally Friendly
> "Design makes an important contribution to the preservation of the environment."

**Application**: Efficient use of resources (compute, memory, energy).

**Trigger**:
- Performance-critical systems
- High-traffic services
- Resource-constrained environments

**Action**:
1. Optimize for efficiency when scale matters:
   - Use appropriate data structures (O(1) vs O(n))
   - Cache expensive computations
   - Batch operations where possible
2. BUT: only after profiling shows need (no premature optimization)

---

### 1.10 Good Design is as Little Design as Possible
> "Less, but better – because it concentrates on the essential aspects."

**Application**: Minimalism. Remove unnecessary code, features, abstractions.

**Trigger**:
- ALWAYS active
- Design review
- Refactoring

**Action**:
1. Default to simplest solution
2. Challenge every abstraction: "Do we need this?"
3. Remove unused code immediately
4. Prefer composition over inheritance
5. KISS principle: "Can this be simpler?"

---

## 2. Alexander's Pattern Language

**Source**: Christopher Alexander, "A Pattern Language" (1977), "The Timeless Way of Building" (1979)

**Principle**:
> "Good design emerges from patterns that can be composed. Patterns should name solutions to recurring problems."

**Application**: Build reusable design patterns for common problems.

**Trigger**:
- Recurring design problems
- Similar LEGOs across projects
- Pattern identification

**Action**:
1. Document recurring patterns in `patterns/success_patterns.md`
2. Name patterns clearly (e.g., "Circuit Breaker", "Repository Pattern")
3. Each pattern should have:
   - Problem it solves
   - Context where it applies
   - Solution structure
   - Consequences and trade-offs
4. Reuse patterns before creating new solutions

---

## 3. Alexander's Quality Without a Name

**Source**: Christopher Alexander, "The Timeless Way of Building"

**Principle**:
> "There is a central quality which is the root criterion of life and spirit in a system. It is a quality which cannot be named."

**Application**: Trust intuition about design elegance; systems should "feel right".

**Trigger**:
- Design review
- Code review
- Architecture evaluation

**Action**:
1. Ask: "Does this feel right?"
2. If design feels awkward, investigate why:
   - Too complex?
   - Wrong abstraction?
   - Missing something?
3. Good design has a sense of inevitability ("Of course it works that way")
4. If multiple team members feel "something's off", listen to that intuition

---

## 4. Norman's Design Principles

**Source**: Don Norman, "The Design of Everyday Things" (1988)

### 4.1 Affordances
> "The design should suggest how to use it. A door handle affords pulling; a button affords pushing."

**Application**: APIs and interfaces should suggest their usage.

**Trigger**:
- API design
- Function naming
- Interface design

**Action**:
1. Names should suggest usage:
   - `is_valid()` → returns boolean
   - `get_users()` → returns list
   - `create_session()` → creates and returns session
2. Function signatures should be self-documenting
3. RESTful verbs (GET, POST, PUT, DELETE) afford their semantics

---

### 4.2 Signifiers
> "Signifiers communicate where the action should take place. They indicate what part of the system to interact with."

**Application**: Make critical functions and entry points obvious.

**Trigger**:
- Module organization
- API documentation
- Entry point design

**Action**:
1. Main entry points should be prominent:
   - `main.py`, `index.js`, `app.py`
   - Clear `README.md` pointing to getting started
2. Critical functions should be in obvious places:
   - Auth functions in `auth/` module
   - Validation in `validators/`
3. Documentation should highlight key workflows

---

### 4.3 Feedback
> "The system should provide continuous feedback about what it's doing."

**Application**: System should communicate state clearly.

**Trigger**:
- Long-running operations
- External API calls
- User interactions

**Action**:
1. Provide progress indicators for long operations
2. Log important state transitions
3. Return meaningful status codes and messages:
   - `201 Created` with resource URL
   - `400 Bad Request` with specific error
4. Add observability LEGOs (metrics, tracing)

---

### 4.4 Conceptual Models
> "People form mental models of how systems work. Design should match those models."

**Application**: Follow conventions; don't surprise users.

**Trigger**:
- API design
- Data modeling
- System architecture

**Action**:
1. Use standard conventions:
   - REST APIs follow REST semantics
   - SQL databases use normalized schemas
   - JSON follows standard formatting
2. Don't invent new patterns when existing ones work
3. Match user expectations:
   - `/users/:id` for user detail
   - `DELETE` means delete, not "soft delete"

---

### 4.5 Constraints
> "Design should limit possible actions to prevent errors."

**Application**: Use types, validation, and constraints to prevent invalid states.

**Trigger**:
- Data modeling
- Input validation
- Type system usage

**Action**:
1. Use type systems:
   - `age: int` not `age: any`
   - `status: Enum["active", "inactive"]` not `status: str`
2. Database constraints:
   - NOT NULL for required fields
   - FOREIGN KEY for relationships
   - UNIQUE for identifiers
3. Validation at boundaries:
   - Input validation on all API endpoints
   - Output validation for external services

---

### 4.6 Mappings
> "The relationship between controls and their effects should be obvious."

**Application**: Function names should map clearly to their effects.

**Trigger**:
- Function naming
- API design
- Event naming

**Action**:
1. Clear cause-effect mapping:
   - `delete_user(id)` → user is deleted
   - `POST /sessions` → session is created
2. Avoid surprising side effects:
   - `get_user()` should NOT create user
   - Read operations should be side-effect free
3. Commands vs Queries (CQRS when appropriate):
   - `get_` → query (no side effects)
   - `create_`, `update_`, `delete_` → commands (side effects)

---

### 4.7 Consistency
> "Similar things should look similar; different things should look different."

**Application**: Consistent patterns across codebase and APIs.

**Trigger**:
- ALWAYS active
- Code review
- API design

**Action**:
1. Naming conventions:
   - All "fetch from external API" functions use same pattern
   - All validators follow same structure
2. Error handling:
   - Same exception types for same error classes
   - Consistent error response format
3. Code structure:
   - All LEGOs follow same file organization
   - All modules have similar structure

---

## 5. Norman's Gulf of Execution and Evaluation

**Source**: Don Norman, "The Design of Everyday Things"

**Principle**:
> "Gulf of Execution: the gap between intention and action. Gulf of Evaluation: the gap between action and understanding result."

**Application**: Make it easy to do things and understand outcomes.

**Trigger**:
- API design
- Error messages
- User workflows

**Action**:
1. **Narrow Gulf of Execution**:
   - Make common tasks easy: `client.send_email(to, subject, body)`
   - Provide clear documentation and examples
   - Sensible defaults
   
2. **Narrow Gulf of Evaluation**:
   - Clear success/failure indicators
   - Detailed error messages
   - Useful logs and observability

---

## 6. Alexander's "Alive" vs "Dead" Patterns

**Source**: Christopher Alexander, "The Nature of Order" (2002)

**Principle**:
> "Living structures have wholeness and recursively beautiful substructures. Dead structures are mechanical and fragmented."

**Application**: Systems should have organic coherence, not mechanical assembly.

**Trigger**:
- Architecture review
- System feels brittle or fragmented

**Action**:
1. Look for coherence:
   - Do LEGOs fit together naturally?
   - Are boundaries in the right places?
2. Each LEGO should be "whole" (complete, not fragmented)
3. System should compose elegantly:
   - LEGOs plug together simply
   - Minimal glue code needed
4. If system feels "dead" (rigid, brittle):
   - Consider restructuring boundaries
   - Look for misaligned abstractions

---

## 7. Rams' "Weniger, aber besser"

**Source**: Dieter Rams, design motto

**Principle**:
> "Less, but better."

**Application**: Quality over quantity. Remove relentlessly.

**Trigger**:
- ALWAYS active
- Feature requests
- Code review

**Action**:
1. For every addition, ask: "What can we remove?"
2. Prefer doing less, extremely well
3. One great feature beats five mediocre features
4. Applies to code, features, documentation, everything

---

## 8. Norman's Discoverability

**Source**: Don Norman, "The Design of Everyday Things"

**Principle**:
> "Users should be able to discover what actions are possible and how to perform them."

**Application**: System capabilities should be discoverable.

**Trigger**:
- API design
- Documentation
- User onboarding

**Action**:
1. Self-documenting code:
   - Clear function names
   - Type hints
   - Docstrings
2. Discoverable APIs:
   - `GET /` returns available endpoints
   - OpenAPI/Swagger documentation
3. Clear README:
   - Quick start guide
   - Common workflows
   - Link to full docs

---

## How to Use Design Wisdom

### During REQUIREMENTS Phase
- Principles 1.2 (Useful), 1.6 (Honest), 4.4 (Conceptual Models)
- Ensure requirements match user needs and mental models

### During LEGO Discovery
- Principles 1.10 (Minimal), 2 (Patterns), 7 (Less but better)
- Minimal LEGOs, reuse patterns

### During DESIGN Phase
- Principles 1.1-1.10 (Rams), 4.1-4.7 (Norman), 2, 3, 6
- Apply all design principles systematically

### During CODING Phase
- Principles 1.3 (Aesthetic), 1.4 (Understandable), 1.8 (Thorough)
- Clean, understandable, thorough implementation

### During DOCUMENTATION Phase
- Principles 1.4 (Understandable), 4.2 (Signifiers), 4.3 (Feedback), 8 (Discoverability)
- Clear, discoverable, helpful documentation

### During REVIEW Phase
- Principle 3 (Quality Without a Name)
- Trust intuition: "Does this feel right?"

---

## Adding Your Own Design Wisdom

To add new design principles:

1. Identify source and context
2. State principle concisely
3. Map to software design scenarios
4. Define clear triggers
5. Specify concrete actions

Design wisdom should be:
- **User-centered**: Focus on user experience
- **Holistic**: Consider the whole system
- **Timeless**: True regardless of technology
- **Aesthetic**: Beauty and function together
