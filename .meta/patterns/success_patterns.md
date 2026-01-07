# Success Patterns

Proven architectural and design patterns that consistently lead to good outcomes. Use these as templates for common problems.

---

## 1. LEGO Architecture (Single Responsibility Modules)

**Problem**: Large, monolithic code is hard to understand, test, and modify.

**Solution**: Break system into small, single-purpose modules with clear interfaces.

**When to Use**: Always. Default architecture for this meta-orchestrator.

**Structure**:
```
project/
├── lego_auth/
│   ├── __init__.py
│   ├── interface.py     # Public API
│   ├── implementation.py
│   └── tests/
├── lego_data/
│   ├── __init__.py
│   ├── interface.py
│   └── ...
```

**Benefits**:
- Easy to test in isolation
- Clear boundaries
- Reusable across projects
- Parallel development

**Wisdom**: Thompson (#5 Engineering - Unix Philosophy)

---

## 2. Repository Pattern

**Problem**: Database access logic scattered throughout code.

**Solution**: Centralize data access in repository modules.

**When to Use**: Any app with database

**Structure**:
```python
class UserRepository:
    def get_by_id(self, user_id: int) -> User: ...
    def create(self, user: User) -> User: ...
    def update(self, user: User) -> User: ...
    def delete(self, user_id: int) -> None: ...
```

**Benefits**:
- Swappable implementations (Postgres → MongoDB)
- Easier testing (mock repository)
- Single place for query optimization

**Wisdom**: Parnas (#10 Engineering - Information Hiding)

---

## 3. Circuit Breaker

**Problem**: External service failures cascade to your system.

**Solution**: Automatically stop calling failing services.

**When to Use**: Any external API/service dependency

**Structure**:
```python
class CircuitBreaker:
    state = CLOSED  # CLOSED → OPEN → HALF_OPEN
    
    def call(self, func):
        if state == OPEN:
            raise CircuitOpenError()
        try:
            result = func()
            on_success()  # Reset failure count
            return result
        except:
            on_failure()  # Increment, maybe open circuit
            raise
```

**Benefits**:
- Prevents cascading failures
- Fast-fail when service is down
- Automatic recovery

**Wisdom**: Taleb (#6 Risk - Antifragile), Clausewitz (#3 Strategic - Friction)

---

## 4. API Gateway / Facade

**Problem**: Multiple microservices, clients need simple interface.

**Solution**: Single entry point that routes to appropriate services.

**When to Use**: Microservices, multiple LEGOs with external APIs

**Structure**:
```python
class APIGateway:
    def get_user_profile(self, user_id):
        user = user_service.get(user_id)
        prefs = preference_service.get(user_id)
        return {**user, **prefs}
```

**Benefits**:
- Simplifies client code
- Centralized auth/rate limiting
- Can aggregate/transform responses

---

## 5. Bug/Feature/Incident Triage Gate

**Problem**: Work items get routed through the wrong roles, slowing bugs/incidents or skipping PM rigor for new capabilities.

**Solution**: Classify each request before role selection:
- **Bug** → Dev/Test first; PM only for impact/priority/acceptance.
- **Feature/Enhancement** → PM required (goals, metrics, scope, trade-offs) before design.
- **Incident** → Ops + Dev first for containment; PM only for comms/priority.

**When to Use**: Always, before selecting sub-agents or opening a work item.

**Benefits**:
- Faster recovery for incidents
- Less bureaucracy for bug fixes
- Proper discovery for new behavior

**Wisdom**: KISS + Thompson #5 (do one thing well; don’t force irrelevant gates)

**Wisdom**: Parnas (#10 Engineering), Norman (#4.4 Design - Conceptual Models)

---

## 6. Contract Registry + Compatibility Gates

**Problem**: Cross-repo changes cause breakages because interfaces drift.

**Solution**: Maintain explicit contracts (schemas/APIs) and enforce compatibility with automated tests.

**When to Use**: Any system-of-systems or shared component environment.

**Structure**:
```
contracts/
  onboarding_v2.json
tests/
  contract_compatibility.test.ts
```

**Benefits**:
- Prevents silent breakages
- Enables parallel development with clear boundaries
- Makes compatibility expectations explicit

**Wisdom**: Thompson (#5 Engineering), Parnas (#10 Engineering - Information Hiding)

---

## 7. Append-Only Coordination Ledger

**Problem**: Cross-repo requests get lost or overwritten, breaking restartability.

**Solution**: Immutable request packets + append-only event logs + explicit state transitions.

**When to Use**: Tracked or governed coordination modes.

**Structure**:
```
coordination/requests/REQ-YYYYMMDD-0001.json
coordination/events/REQ-YYYYMMDD-0001.jsonl
coordination/index.json
```

**Benefits**:
- Full audit trail
- Safe restartability
- No stomping or silent edits

**Wisdom**: KISS + Thompson #5 (single responsibility), Kernighan (debugging simplicity)

---

## 8. Adapter Pattern (External Services)

**Problem**: External APIs have different interfaces; hard to swap providers.

**Solution**: Create adapter layer with consistent interface.

**When to Use**: Multiple providers for same service (payment, email, cloud)

**Structure**:
```python
class EmailAdapter:
    def send(self, to, subject, body): ...

class SendGridAdapter(EmailAdapter):
    def send(self, to, subject, body):
        sendgrid.api.send(...)

class MailgunAdapter(EmailAdapter):
    def send(self, to, subject, body):
        mailgun.messages.create(...)
```

**Benefits**:
- Swappable implementations
- Consistent interface
- Easier testing (mock adapter)

**Wisdom**: This repo's runtime adapters (codex/copilot/claude)

---

## 6. Saga Pattern (Distributed Transactions)

**Problem**: Need transactions across multiple services/databases.

**Solution**: Choreographed sequence of local transactions with compensating actions.

**When to Use**: Distributed systems, multi-step workflows

**Structure**:
```python
def book_trip(user_id, flight, hotel):
    try:
        flight_res = book_flight(flight)
        hotel_res = book_hotel(hotel)
        payment = charge_user(user_id, total)
        return TripConfirmation(...)
    except:
        if hotel_res: cancel_hotel(hotel_res)
        if flight_res: cancel_flight(flight_res)
        raise
```

**Benefits**:
- Consistency in distributed systems
- Graceful rollback
- No distributed locks

**Wisdom**: Clausewitz (#3 Strategic - Friction)

---

## 7. Event Sourcing

**Problem**: Need full audit trail; hard to reconstruct state history.

**Solution**: Store events, not just current state. State is derived from events.

**When to Use**: Audit requirements, time-travel debugging, compliance

**Structure**:
```python
events = [
    UserCreated(id=1, name="Alice"),
    EmailChanged(id=1, new_email="alice@example.com"),
    UserDeleted(id=1),
]

def get_user_state(user_id, at_time=None):
    events_for_user = [e for e in events if e.id == user_id and e.time <= (at_time or now)]
    return apply_events(events_for_user)
```

**Benefits**:
- Complete audit trail
- Time-travel queries
- Can replay events to fix bugs

**Trade-offs**:
- More complex
- Larger storage
- Need event versioning

**Wisdom**: Taleb (#1 Risk - Black Swan, helps with unknown unknowns)

---

## 8. Feature Flags

**Problem**: Want to deploy code without activating features; need gradual rollouts.

**Solution**: Runtime toggles for features.

**When to Use**: Gradual rollouts, A/B testing, risk mitigation

**Structure**:
```python
if feature_flags.is_enabled("new_algorithm", user_id):
    return new_algorithm(data)
else:
    return old_algorithm(data)
```

**Benefits**:
- Deploy != activate
- Gradual rollouts (1% → 10% → 100%)
- Fast rollback (flip flag)
- A/B testing

**Wisdom**: Kahneman (#5 Risk - Loss Aversion, easy rollback)

---

## 9. Strangler Fig Pattern

**Problem**: Need to replace legacy system without big-bang rewrite.

**Solution**: Gradually replace old system, piece by piece.

**When to Use**: Legacy modernization, large refactoring

**Structure**:
1. New system sits alongside old
2. Route new features to new system
3. Gradually migrate old features
4. Eventually remove old system

**Benefits**:
- Continuous delivery during migration
- Lower risk than big-bang rewrite
- Can abort if new system doesn't work

**Wisdom**: Taleb (#5 Strategic - Barbell, conservative + bold)

---

## 10. CQRS (Command Query Responsibility Segregation)

**Problem**: Read and write patterns are very different; optimize separately.

**Solution**: Separate models for commands (writes) and queries (reads).

**When to Use**: Read-heavy or write-heavy workloads, complex domains

**Structure**:
```python
# Command side
class CreateUserCommand:
    def execute(self, name, email):
        user = User(name, email)
        db.save(user)
        event_bus.publish(UserCreated(user))

# Query side
class UserQueryService:
    def get_user_summary(self, user_id):
        return read_model.get(user_id)  # Optimized for reads
```

**Benefits**:
- Optimize reads and writes independently
- Scale them separately
- Clear separation of concerns

**Trade-offs**:
- More complex
- Eventual consistency

**Wisdom**: Thompson (#5 Engineering - Do One Thing Well)

---

## 11. Bulkhead Pattern

**Problem**: One failing component brings down entire system.

**Solution**: Isolate resources (threads, connections) so failures are contained.

**When to Use**: High-availability systems, multi-tenant

**Structure**:
```python
# Separate thread pools for different services
email_pool = ThreadPoolExecutor(max_workers=5)
api_pool = ThreadPoolExecutor(max_workers=20)

# Email slowdown doesn't affect API calls
email_pool.submit(send_email, ...)
api_pool.submit(call_external_api, ...)
```

**Benefits**:
- Failures contained
- Predictable resource usage
- Easier to reason about load

**Wisdom**: Saltzer & Schroeder (#9.7 Risk - Least Common Mechanism)

---

## 12. Retry with Exponential Backoff

**Problem**: Transient failures; retrying immediately hammers failing service.

**Solution**: Retry with increasing delays.

**When to Use**: Any external service call

**Structure**:
```python
def call_with_retry(func, max_retries=3):
    for attempt in range(max_retries):
        try:
            return func()
        except TransientError:
            if attempt == max_retries - 1:
                raise
            delay = (2 ** attempt) + random.uniform(0, 1)
            time.sleep(delay)
```

**Benefits**:
- Handles transient failures
- Doesn't overwhelm recovering service
- Jitter prevents thundering herd

**Wisdom**: Taleb (#4 Risk - Antifragile, gets stronger from stress)

---

## 13. Idempotent Operations

**Problem**: Network failures mean operations might be retried; must not duplicate effects.

**Solution**: Design operations to have same effect if called once or many times.

**When to Use**: Any operation that might be retried (APIs, message processing)

**Structure**:
```python
# BAD (not idempotent)
def increment_balance(user_id, amount):
    user.balance += amount

# GOOD (idempotent)
def apply_transaction(transaction_id, user_id, amount):
    if not transaction_exists(transaction_id):
        user.balance += amount
        record_transaction(transaction_id)
```

**Benefits**:
- Safe to retry
- Simpler error handling
- Prevents duplicates

**Wisdom**: Saltzer & Schroeder (#9.4 Risk - Complete Mediation)

---

## 14. Health Checks & Readiness Probes

**Problem**: Don't know if service is healthy; load balancer sends traffic to failing instances.

**Solution**: Expose health/readiness endpoints.

**When to Use**: Always (production services)

**Structure**:
```python
@app.route("/health")
def health():
    # Quick check: is service alive?
    return {"status": "ok"}

@app.route("/ready")
def ready():
    # Thorough check: can service handle traffic?
    if db.is_connected() and redis.is_connected():
        return {"status": "ready"}
    else:
        return {"status": "not_ready"}, 503
```

**Benefits**:
- Load balancers route around failures
- Monitoring knows service state
- Graceful startup/shutdown

**Wisdom**: Norman (#4.3 Design - Feedback)

---

## 15. Immutable Infrastructure

**Problem**: Servers drift from known configurations; hard to reproduce.

**Solution**: Never modify running servers; deploy new versions, destroy old.

**When to Use**: Cloud deployments, containerized apps

**Structure**:
- Build image with all dependencies
- Deploy new instances from image
- Switch traffic to new instances
- Destroy old instances

**Benefits**:
- Reproducible deployments
- Easy rollback (redeploy old image)
- No configuration drift

**Wisdom**: Rams (#1.6 Design - Honest, what you deploy is what you built)

---

## How to Use Success Patterns

1. **Identify the problem**: What specific issue are you solving?
2. **Check patterns**: Does one of these patterns fit?
3. **Understand trade-offs**: Every pattern has costs.
4. **Apply appropriately**: Don't force patterns where they don't fit.
5. **Document choice**: Explain why this pattern was used.

**Adding Patterns**:

To document a new success pattern:
1. Name and problem it solves
2. Solution structure
3. When to use (and when NOT to use)
4. Benefits and trade-offs
5. Code example
6. Link to relevant wisdom
