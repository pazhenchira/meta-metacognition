# Trade-off Decision Matrix

Common trade-offs in software design, with guidance on when to choose each option. Every design decision involves trade-offs; this matrix helps make those choices explicit and consistent.

---

## 1. Simplicity vs Power

**Trade-off**: Simple, limited solution vs feature-rich, complex solution

| Choose SIMPLICITY When | Choose POWER When |
|------------------------|-------------------|
| Requirements are clear and modest | Complex requirements demand it |
| Team is small | Large team can handle complexity |
| Maintenance is priority | Performance/features are priority |
| MVP or prototype | Production system with diverse use cases |
| Internal tools | External product |

**Default**: **Simplicity** (KISS principle)

**Decision Rule**: Only add complexity when you can justify it.

**Wisdom**: Dijkstra (#3 Engineering), Rams (#1.10 Design - Minimal)

**Example**:
- Simple: Flat file configuration → Complex: Database-backed config system
- Simple: REST API → Complex: GraphQL API
- Choose Simple unless you have specific need for power

---

## 2. Speed vs Quality

**Trade-off**: Fast delivery with tech debt vs slower, more polished work

| Choose SPEED When | Choose QUALITY When |
|-------------------|---------------------|
| `r_and_d_mode = "fast"` | `r_and_d_mode = "thorough"` |
| Prototype or MVP | Production system |
| Experimenting to learn | Building critical infrastructure |
| Fast feedback needed | Long-term maintenance expected |
| Low cost of failure | High cost of failure |

**Default**: Depends on `r_and_d_mode` in `meta_config.json`

**Decision Rule**: Speed for experiments, quality for foundations.

**Wisdom**: Boyd (#2 Strategic - OODA Loop), Kahneman (#12 Strategic - System 1 vs 2)

**Example**:
- Speed: Prototype in 1 day, skip tests → Learn if idea works
- Quality: Critical auth system, comprehensive tests → Avoid security bugs

---

## 3. Build vs Buy (Custom vs Library)

**Trade-off**: Build custom solution vs use existing library/service

| Choose BUILD (Custom) When | Choose BUY (Library/Service) When |
|----------------------------|----------------------------------|
| Requirements are truly unique | Problem is common |
| Existing solutions don't fit | Mature solutions exist |
| Willing to maintain long-term | Want to focus on core business |
| Simple enough to build quickly | Complex (auth, crypto, payments) |
| Learning opportunity | Need it now |

**Default**: **Buy** (avoid NIH syndrome)

**Decision Rule**: Build only if existing solutions genuinely don't fit.

**Wisdom**: Brooks (#9 Engineering - No Silver Bullet), Bentley (#12 Engineering)

**Example**:
- Build: Custom workflow engine for unique business process
- Buy: Auth (use OAuth), Email (use SendGrid), Payments (use Stripe)

---

## 4. Monolith vs Microservices

**Trade-off**: Single deployable unit vs many small services

| Choose MONOLITH When | Choose MICROSERVICES When |
|----------------------|---------------------------|
| Small team (< 10 people) | Large team (> 20 people) |
| Simple domain | Complex, diverse domains |
| Starting new project | Scaling existing system |
| Tight coupling is OK | Need independent deployment |
| Shared database is fine | Different data models per service |

**Default**: **Monolith** (start simple, split later if needed)

**Decision Rule**: Monolith first, microservices only when scaling requires it.

**Wisdom**: Rams (#1.10 Design - Minimal), Taleb (#5 Strategic - Barbell)

**Example**:
- Monolith: Startup with 5 developers
- Microservices: Company with 50 teams, each needs independent releases

---

## 5. SQL vs NoSQL

**Trade-off**: Relational database vs document/key-value store

| Choose SQL When | Choose NoSQL When |
|-----------------|-------------------|
| Structured data | Unstructured or semi-structured |
| Complex queries needed | Simple key-value lookups |
| ACID transactions required | Eventual consistency OK |
| Relationships between entities | Hierarchical/nested data |
| Unknown query patterns | Known access patterns |

**Default**: **SQL** (Postgres/MySQL) unless specific need for NoSQL

**Decision Rule**: SQL for most apps; NoSQL for specific use cases.

**Wisdom**: Taleb (#13 Strategic - Lindy Effect, SQL is proven)

**Example**:
- SQL: E-commerce (products, orders, users with relationships)
- NoSQL: Session storage, caching, logs, analytics events

---

## 6. Normalize vs Denormalize (Database Design)

**Trade-off**: Normalized schema vs redundant, denormalized data

| Choose NORMALIZED When | Choose DENORMALIZED When |
|------------------------|--------------------------|
| Starting project | Proven performance bottleneck |
| Write-heavy workload | Read-heavy workload |
| Storage is expensive | Query performance critical |
| Data consistency matters most | Read latency matters most |
| Complex updates | Simple queries |

**Default**: **Normalized** (3rd normal form)

**Decision Rule**: Normalize first, denormalize only after profiling shows need.

**Wisdom**: Knuth (#2 Engineering - No Premature Optimization)

**Example**:
- Normalized: User table + Address table (separate)
- Denormalized: User table with embedded address JSON (if always queried together)

---

## 7. Sync vs Async (Operations)

**Trade-off**: Blocking operation vs background processing

| Choose SYNC When | Choose ASYNC When |
|------------------|-------------------|
| Fast operation (< 1 second) | Slow operation (> 5 seconds) |
| Result needed immediately | Result can be delayed |
| Simple error handling | Complex workflows |
| Low volume | High volume or spiky traffic |
| User expects immediate feedback | User can wait or be notified later |

**Default**: **Sync** for fast operations, **Async** for slow

**Decision Rule**: If operation takes > 5 seconds, make it async.

**Wisdom**: Boyd (#2 Strategic - OODA), Norman (#4.3 Design - Feedback)

**Example**:
- Sync: User login (fast, need result immediately)
- Async: Sending bulk emails, video processing, report generation

---

## 8. Push vs Pull (Communication)

**Trade-off**: Server pushes updates vs client polls for updates

| Choose PUSH When | Choose PULL When |
|------------------|------------------|
| Real-time updates needed | Periodic updates are fine |
| Low latency critical | Latency tolerance is high |
| Server knows when to update | Client knows when to update |
| WebSockets/SSE available | Simple HTTP sufficient |
| Persistent connections OK | Stateless preferred |

**Default**: **Pull** (simpler, more scalable)

**Decision Rule**: Push only if real-time requirements demand it.

**Wisdom**: Rams (#1.10 Design - Minimal)

**Example**:
- Push: Chat app, stock ticker, live dashboards
- Pull: Email sync, social media feed, weather updates

---

## 9. Optimistic vs Pessimistic (Concurrency)

**Trade-off**: Assume no conflicts vs assume conflicts will happen

| Choose OPTIMISTIC When | Choose PESSIMISTIC When |
|------------------------|-------------------------|
| Low contention | High contention |
| Read-heavy workload | Write-heavy workload |
| Conflicts are rare | Conflicts are common |
| Performance > consistency | Consistency > performance |
| Can retry on conflict | Must prevent conflicts |

**Default**: **Optimistic** (scales better)

**Decision Rule**: Optimistic for most; pessimistic for high-contention resources.

**Wisdom**: Taleb (#6 Risk - Antifragile)

**Example**:
- Optimistic: E-commerce inventory (check at checkout, retry if sold out)
- Pessimistic: Banking transactions (lock account during transfer)

---

## 10. Stateless vs Stateful (Services)

**Trade-off**: Server stores no session data vs server maintains session state

| Choose STATELESS When | Choose STATEFUL When |
|-----------------------|----------------------|
| Horizontal scaling needed | Single instance or sticky sessions |
| Load balancing across instances | Session affinity is fine |
| Cloud/containerized | Traditional deployment |
| REST API | WebSocket/persistent connections |
| Simple to reason about | Complex state machine |

**Default**: **Stateless** (more scalable)

**Decision Rule**: Stateless unless performance or simplicity demands stateful.

**Wisdom**: Rams (#1.5 Design - Unobtrusive)

**Example**:
- Stateless: REST API with JWT tokens
- Stateful: WebSocket server with connection state, game server

---

## 11. Centralized vs Distributed (Architecture)

**Trade-off**: Single coordinator vs autonomous nodes

| Choose CENTRALIZED When | Choose DISTRIBUTED When |
|-------------------------|-------------------------|
| Small scale | Large scale (geo-distributed) |
| Consistency is critical | Availability is critical |
| Simple to reason about | Fault tolerance required |
| Low latency possible | High latency between nodes |
| Single failure domain OK | No single point of failure |

**Default**: **Centralized** (simpler)

**Decision Rule**: Centralized unless scale or availability demands distribution.

**Wisdom**: Rams (#1.10 Design - Minimal), CAP theorem

**Example**:
- Centralized: Single PostgreSQL instance for startup
- Distributed: Multi-region data centers for global service

---

## 12. Vertical vs Horizontal Scaling

**Trade-off**: Bigger server vs more servers

| Choose VERTICAL When | Choose HORIZONTAL When |
|----------------------|------------------------|
| Easy quick win | Vertical limit reached |
| Stateful application | Stateless application |
| Single instance needed | Need redundancy |
| Cost-effective initially | Cost-effective at scale |
| Simpler operations | Can handle more complexity |

**Default**: **Vertical** first, then horizontal as needed

**Decision Rule**: Vertical until it's cheaper/better to go horizontal.

**Wisdom**: Rams (#1.10 Design - Minimal), Pike (#4 Engineering - Simple first)

**Example**:
- Vertical: Upgrade from 4GB → 16GB RAM
- Horizontal: Add more web servers behind load balancer

---

## 13. Dynamic vs Static (Typing)

**Trade-off**: Runtime type checking vs compile-time type checking

| Choose DYNAMIC When | Choose STATIC When |
|---------------------|-------------------|
| Rapid prototyping | Production system |
| Small codebase | Large codebase (> 10k LOC) |
| Frequent experimentation | Long-term maintenance |
| Single developer | Team of developers |
| Flexibility > safety | Safety > flexibility |

**Default**: **Static** (or gradually typed like Python type hints)

**Decision Rule**: Dynamic for prototypes, static for production.

**Wisdom**: Norman (#4.5 Design - Constraints prevent errors)

**Example**:
- Dynamic: Python without type hints, JavaScript
- Static: TypeScript, Python with mypy, Rust

---

## 14. Conservative vs Bold (Technology Choices)

**Trade-off**: Proven, boring tech vs new, exciting tech

| Choose CONSERVATIVE When | Choose BOLD When |
|--------------------------|------------------|
| Critical systems (auth, payments) | Experiments, prototypes |
| Production, high stakes | Internal tools, low stakes |
| Long-term maintenance | Short-term project |
| Large team needs stability | Small team can pivot |
| Failure cost is high | Failure cost is low |

**Default**: **Conservative** (Lindy Effect)

**Decision Rule**: Conservative for foundations, bold for experiments.

**Wisdom**: Taleb (#5 Strategic - Barbell Strategy), Taleb (#13 Strategic - Lindy)

**Example**:
- Conservative: PostgreSQL, Python, Django for core product
- Bold: Try new JS framework for internal dashboard

---

## 15. Generalization vs Specialization

**Trade-off**: One solution for many cases vs tailored solutions

| Choose GENERALIZATION When | Choose SPECIALIZATION When |
|----------------------------|----------------------------|
| Use cases are similar | Use cases are very different |
| Shared code reduces duplication | Coupling is problematic |
| Consistency matters | Performance matters |
| Can anticipate future needs | Current needs are clear |
| Reuse is valuable | Flexibility is valuable |

**Default**: **Specialization** initially, generalize after seeing patterns

**Decision Rule**: Rule of Three - generalize after 3rd use, not before.

**Wisdom**: Knuth (#2 Engineering - No Premature Optimization)

**Example**:
- Specialization: Separate handlers for different API endpoints
- Generalization: Generic CRUD framework after seeing pattern

---

## How to Use This Matrix

1. **Identify the trade-off**: Which decision are you facing?
2. **Consult the matrix**: Review factors for each option.
3. **Check the default**: Start with the default unless you have a reason to deviate.
4. **Apply decision rule**: Use the rule to make the call.
5. **Document the choice**: Explain why you chose one over the other in design docs.
6. **Revisit later**: Trade-offs change as systems evolve (monolith → microservices).

**Important**: These are guidelines, not laws. Context matters. Use wisdom, not dogma.
