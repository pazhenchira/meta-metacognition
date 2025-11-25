# Strategic Wisdom

Distilled principles from military strategists, decision theorists, and systems thinkers. Each principle helps the meta-orchestrator make better strategic decisions about architecture, trade-offs, and resource allocation.

---

## 1. Sun Tzu's Know Yourself

**Source**: Sun Tzu, "The Art of War" (~5th century BC)

**Principle**:
> "If you know the enemy and know yourself, you need not fear the result of a hundred battles. If you know yourself but not the enemy, for every victory gained you will also suffer a defeat. If you know neither the enemy nor yourself, you will succumb in every battle."

**Application**: Understand constraints and capabilities before committing to approach.

**Trigger**:
- REQUIREMENTS phase
- User provides vague goals ("build a scalable system")
- External dependencies not yet investigated
- Performance/cost/scale requirements unclear

**Action**:
1. Ask clarifying questions about:
   - Available resources (time, budget, skills)
   - Known constraints (performance, compliance, scale)
   - External dependencies (APIs, services, data sources)
2. Document assumptions explicitly in `requirements.md`
3. If critical unknowns remain, stop and request information
4. Do NOT proceed with ambiguous requirements

---

## 2. Boyd's OODA Loop

**Source**: John Boyd, "Patterns of Conflict" (1976) - OODA: Observe, Orient, Decide, Act

**Principle**:
> "The side that can complete the OODA loop faster wins. Speed of decision-making matters more than perfection."

**Application**: Fast feedback loops beat slow perfection.

**Trigger**:
- `r_and_d_mode = "fast"`
- Prototyping or MVP scenarios
- Rapid iteration needed
- High uncertainty about requirements

**Action**:
1. Shorten feedback cycles:
   - Build → Test → Review → Iterate
   - Deploy smallest testable increment
2. Prioritize learning over completeness
3. Use evaluation harnesses to validate quickly
4. Accept "good enough" over "perfect"
5. BUT: maintain quality for critical LEGOs (auth, data)

**Counter-Trigger** (`r_and_d_mode = "thorough"`):
- Slow down for high-risk systems
- Thorough review and red-team evaluation

---

## 3. Clausewitz's Friction

**Source**: Carl von Clausewitz, "On War" (1832)

**Principle**:
> "Everything in war is very simple, but the simplest thing is difficult. The difficulties accumulate and end by producing a kind of friction that is inconceivable unless one has experienced war."

**Application**: Plans will encounter unexpected difficulties. Build in resilience and margins.

**Trigger**:
- Complex multi-LEGO systems
- External dependencies (APIs, databases, third-party services)
- Distributed systems or async workflows
- Any integration with external systems

**Action**:
1. Add error handling and retries by default
2. Implement timeouts for all external calls
3. Include monitoring/observability LEGOs
4. Build with graceful degradation (fallbacks, circuit breakers)
5. Add safety valves (max retries, failure counts)
6. Budget extra time for integration issues

---

## 4. Taleb's Antifragility

**Source**: Nassim Taleb, "Antifragile: Things That Gain from Disorder" (2012)

**Principle**:
> "Some things benefit from shocks; they thrive and grow when exposed to volatility, randomness, disorder, and stressors. Antifragile systems get stronger from adversity."

**Application**: Design systems that improve under stress, not just tolerate it.

**Trigger**:
- Production/critical systems
- Systems handling external input (APIs, user data)
- Services with high availability requirements
- Any LEGO marked `sensitive = true`

**Action**:
1. Add chaos/stress tests to evaluation harness
2. Implement exponential backoff for retries (learns from failures)
3. Use circuit breakers that "heal" automatically
4. Add rate limiting that adapts to load
5. Log failures for learning (build failure catalog)
6. Make validation stricter when errors increase

**Examples**:
- Rate limiter that reduces traffic when errors spike
- Validator that adds checks after seeing malformed input
- Cache that warms based on access patterns

---

## 5. Taleb's Barbell Strategy

**Source**: Nassim Taleb, "The Black Swan" (2007)

**Principle**:
> "Take maximum risk in areas where there's potential for large upside, and be extremely conservative in areas where failure is catastrophic. Avoid the middle ground."

**Application**: Be bold on experiments, conservative on critical systems.

**Trigger**:
- LEGO discovery and design phase
- Evaluating technology choices
- Balancing innovation vs reliability

**Action**:
1. **Conservative** (high risk of catastrophic failure):
   - Authentication & authorization
   - Payment processing
   - Data storage & backup
   - Security & privacy
   - Use proven, boring technology
   - Thorough testing and red-team review
   
2. **Bold** (low cost of failure, high potential upside):
   - UI/UX experiments
   - Internal tools
   - Prototypes and MVPs
   - Developer tooling
   - Try new approaches, iterate fast

3. **Avoid middle ground**:
   - Don't use "stable" tech for experiments (over-engineering)
   - Don't use experimental tech for critical systems (under-engineering)

---

## 6. Sun Tzu's Terrain

**Source**: Sun Tzu, "The Art of War" - Chapter on Terrain

**Principle**:
> "Ground may be classified as accessible, entangling, temporizing, narrow, precipitous, or distant. Know the terrain and adapt strategy accordingly."

**Application**: Choose architecture based on deployment environment and constraints.

**Trigger**:
- LEGO discovery and architecture design
- Deployment planning
- Technology selection

**Action**:
1. **Accessible terrain** (cloud, modern stack):
   - Use standard patterns (REST APIs, microservices if justified)
   - Leverage managed services
   - Deploy frequently
   
2. **Entangling terrain** (legacy systems, tight coupling):
   - Minimize dependencies
   - Use adapters and facades
   - Isolate legacy interactions
   
3. **Narrow terrain** (resource constraints, embedded):
   - Minimize dependencies
   - Optimize for size and memory
   - Simple, efficient algorithms
   
4. **Precipitous terrain** (high security, compliance):
   - Conservative technology choices
   - Comprehensive auditing
   - Red-team evaluation mandatory
   
5. **Distant terrain** (distributed, multi-region):
   - Async messaging
   - Eventual consistency
   - Regional failover

---

## 7. Boyd's Schwerpunkt (Main Effort)

**Source**: John Boyd, synthesizing German military doctrine

**Principle**:
> "Concentrate effort on the decisive point. Everything else is secondary."

**Application**: Identify the most critical LEGO and prioritize it.

**Trigger**:
- LEGO discovery phase
- Multiple LEGOs with dependencies
- Limited resources or tight deadlines

**Action**:
1. Identify the "critical path" LEGO:
   - What's the core value proposition?
   - What has the most dependencies?
   - What's the highest risk?
2. Allocate best resources to critical LEGO
3. Build critical LEGO first, validate thoroughly
4. Other LEGOs can have lighter validation if non-critical
5. Be explicit: mark LEGOs as "critical" or "supporting"

---

## 8. Clausewitz's Center of Gravity

**Source**: Carl von Clausewitz, "On War" - concept of center of gravity

**Principle**:
> "The center of gravity is the hub of all power and movement, on which everything depends. Strike at the center of gravity."

**Application**: Identify and protect the system's core dependency.

**Trigger**:
- Architecture review
- Dependency analysis
- Failure mode analysis

**Action**:
1. Identify center of gravity:
   - What LEGO or service, if it fails, brings everything down?
   - Database? Auth service? External API?
2. Protect center of gravity:
   - Redundancy (backups, replicas)
   - Comprehensive testing
   - Monitoring and alerting
   - Graceful degradation if possible
3. Document as "Critical Dependency" in `dependencies.md`
4. Red-team evaluation focused on this component

---

## 9. Sun Tzu's Deception & Misdirection

**Source**: Sun Tzu, "The Art of War"

**Principle**:
> "All warfare is based on deception. When able, feign inability; when active, inactivity."

**Application**: Don't expose internal implementation details or system capabilities.

**Trigger**:
- API design
- Error messages
- Security-sensitive LEGOs
- External-facing interfaces

**Action**:
1. APIs: Minimal, opaque interfaces
   - Don't leak implementation details in endpoint names
   - Generic error messages ("Invalid request", not "User table locked")
2. Security: Defense in depth
   - Don't reveal what security measures exist
   - Don't confirm or deny usernames in login errors
3. Performance: Don't expose internal timing
   - Constant-time comparisons for secrets
   - Rate limiting with jitter

---

## 10. Taleb's Via Negativa

**Source**: Nassim Taleb, "Antifragile"

**Principle**:
> "The greatest and most robust contribution to knowledge consists in removing what we think is wrong. Subtraction, not addition."

**Application**: Remove code, features, and dependencies rather than adding them.

**Trigger**:
- Requirements review
- Dependency analysis
- Code review
- Feature requests

**Action**:
1. Default answer to new features: "What if we don't build this?"
2. Regularly ask: "What can we remove?"
3. Each dependency is a liability:
   - Can we do without it?
   - Can we replace N dependencies with 1?
4. Code deletion is progress:
   - Celebrate removing code
   - Track "negative lines of code" as a metric
5. Features are liabilities:
   - Every feature has maintenance cost
   - "Nice to have" = "probably shouldn't have"

---

## 11. Boyd's Implicit Guidance & Control

**Source**: John Boyd, "Patterns of Conflict"

**Principle**:
> "Use implicit guidance and control through shared understanding rather than explicit commands. Teams that understand intent can adapt faster."

**Application**: LEGOs should understand their purpose, not just their interface.

**Trigger**:
- LEGO documentation phase
- Multi-LEGO collaboration
- Complex workflows

**Action**:
1. Document "why" not just "what":
   - Why does this LEGO exist?
   - What problem does it solve?
   - What are the design trade-offs?
2. LEGO-orchestrators should understand:
   - The LEGO's role in the system
   - Upstream and downstream dependencies
   - Success criteria beyond tests passing
3. Enable adaptation:
   - LEGOs can suggest improvements
   - REVIEW phase can question design
   - Safety valves allow re-planning

---

## 12. Kahneman's System 1 vs System 2

**Source**: Daniel Kahneman, "Thinking, Fast and Slow" (2011)

**Principle**:
> "System 1 is fast, intuitive, automatic. System 2 is slow, deliberate, analytical. Use the right system for the right task."

**Application**: Fast iteration for low-risk decisions, careful analysis for high-risk.

**Trigger**:
- ALL design and implementation decisions

**Action**:
1. **System 1** (fast, intuitive) for:
   - Variable naming
   - Function decomposition
   - Code formatting
   - Non-critical implementation details
   - Low-risk LEGOs (logging, formatting, internal tools)
   
2. **System 2** (slow, analytical) for:
   - Architecture decisions
   - Security design
   - Data model design
   - External API contracts
   - High-risk LEGOs (auth, payments, data storage)
   - Red-team evaluation
   
3. Map to `r_and_d_mode`:
   - `"fast"`: More System 1, less review overhead
   - `"thorough"`: More System 2, comprehensive review

---

## 13. Taleb's Lindy Effect

**Source**: Nassim Taleb, "Antifragile"

**Principle**:
> "The longer something has survived, the longer it's likely to survive. Old ideas/technologies are more robust than new ones."

**Application**: Prefer proven, boring technology for critical systems.

**Trigger**:
- Technology selection
- Dependency choices
- Critical LEGOs (auth, data, security)

**Action**:
1. For critical systems:
   - Prefer established libraries (5+ years old)
   - Prefer stable languages and frameworks
   - Avoid "hot" new technologies
2. For experiments/prototypes:
   - Try new approaches
   - Evaluate emerging tools
   - Document learnings
3. Ask: "Would I bet the company on this technology?"
   - YES: Use it for critical systems
   - NO: Use only for non-critical experiments

**Examples**:
- Critical: PostgreSQL (stable), Express (proven), Python (mature)
- Experimental: New database, new framework, new language

---

## 14. Boyd's Blitzkrieg (Rapid Tempo)

**Source**: John Boyd, synthesizing German WWII tactics

**Principle**:
> "High tempo and rapid exploitation of success can overwhelm the opponent's ability to respond."

**Application**: When validation passes, move quickly to next phase.

**Trigger**:
- VALIDATION phase completes successfully
- All tests pass
- Review finds no blockers

**Action**:
1. Don't delay: proceed immediately to next LEGO
2. Maintain momentum when things work
3. Document and move on (don't over-optimize working code)
4. Fast success compounds:
   - Each completed LEGO enables downstream LEGOs
   - Velocity builds confidence
5. BUT: slow down immediately when validation fails
   - Safety valves prevent runaway failures

---

## 15. Eisenhower's Urgent/Important Matrix

**Source**: Dwight D. Eisenhower, decision-making framework

**Principle**:
> "What is important is seldom urgent, and what is urgent is seldom important."

**Application**: Prioritize LEGOs by importance, not urgency.

**Trigger**:
- LEGO prioritization
- Resource allocation
- User requests for features

**Action**:
1. **Important + Urgent**: Critical bugs, security issues
   - Do immediately
   
2. **Important + Not Urgent**: Architecture, testing, documentation
   - Schedule and protect this time
   - Don't skip for urgent/unimportant work
   
3. **Not Important + Urgent**: Interruptions, some requests
   - Delegate or defer
   - Challenge: "Is this really needed now?"
   
4. **Not Important + Not Urgent**: Nice-to-haves
   - Eliminate or backlog
   - Revisit only if time permits

Apply to LEGO prioritization:
- Auth/security: Important + Urgent
- Core business logic: Important + Not Urgent (do early)
- Polish/UI: Not Important + Not Urgent (do last or skip)

---

## How to Use Strategic Wisdom

### During REQUIREMENTS Phase
- Principles 1, 7, 8, 10, 15
- Know constraints, identify critical path, eliminate non-essential

### During LEGO Discovery
- Principles 5, 6, 7, 8, 13
- Apply barbell strategy, understand terrain, identify center of gravity

### During DESIGN Phase
- Principles 3, 4, 6, 9, 11
- Build for friction, design antifragile systems, hide implementation

### During Implementation
- Principles 2, 12, 14
- Fast feedback loops, match effort to risk, maintain tempo

### During REVIEW Phase
- Principles 10, 12, 13
- Remove unnecessary complexity, apply System 2 thinking to critical systems

---

## Adding Your Own Strategic Wisdom

To add new strategic principles:

1. Identify source and historical context
2. State principle concisely
3. Map to software engineering scenarios
4. Define clear triggers
5. Specify concrete actions

Strategic wisdom should be:
- **Timeless**: True across contexts and eras
- **Actionable**: Clear what to do when triggered
- **Balanced**: Consider trade-offs and context
- **Battle-tested**: Proven through real-world experience
