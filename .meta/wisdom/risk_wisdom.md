# Risk & Security Wisdom

Distilled principles from risk theorists, security experts, and decision scientists. These principles help the meta-orchestrator make better decisions under uncertainty and design secure, robust systems.

---

## PART 1: RISK & DECISION MAKING (Taleb, Kahneman)

## 1. Taleb's Black Swan

**Source**: Nassim Taleb, "The Black Swan" (2007)

**Principle**:
> "Rare, high-impact events are underestimated and can't be predicted. Systems must be robust to the unknown."

**Application**: Design for unknown-unknowns, not just known risks.

**Trigger**:
- Critical systems (auth, payments, data)
- External dependencies
- Production systems

**Action**:
1. **Assume the unexpected will happen**:
   - API will return malformed data
   - Database will go down at worst time
   - Rate limits will be hit
   
2. **Build defensive systems**:
   - Input validation on ALL external data
   - Circuit breakers for external services
   - Fallback mechanisms
   - Comprehensive logging for post-mortems
   
3. **Don't rely on historical data alone**:
   - "It's never failed before" is not a safety guarantee
   - Past performance ≠ future safety

---

## 2. Taleb's Skin in the Game

**Source**: Nassim Taleb, "Skin in the Game" (2018)

**Principle**:
> "Those who make decisions should bear the consequences. Don't trust advice from those with no downside."

**Application**: Those who build the system should support it in production.

**Trigger**:
- Production deployments
- Architecture decisions
- Technology choices

**Action**:
1. **Ownership**: The team that builds a LEGO owns it in production
2. **Observability**: Must include logging, metrics, alerts
3. **On-call**: Code authors should be on-call for their code (encourages defensive programming)
4. **Post-mortems**: Learn from failures and update design

---

## 3. Kahneman's Availability Heuristic

**Source**: Daniel Kahneman, "Thinking, Fast and Slow" (2011)

**Principle**:
> "People overestimate the likelihood of events that are easy to recall (recent, dramatic, emotional)."

**Application**: Don't over-react to recent incidents; analyze data objectively.

**Trigger**:
- After security incidents
- After outages
- When prioritizing work

**Action**:
1. **Don't over-index on recent events**:
   - One SQL injection doesn't mean "rewrite everything in Rust"
   - Recent outage doesn't require full rewrite
   
2. **Use data, not emotion**:
   - What's the actual frequency of this issue?
   - What's the real impact?
   
3. **Balanced response**:
   - Fix the immediate issue
   - Document learnings
   - Make proportional improvements

---

## 4. Kahneman's Overconfidence Bias

**Source**: Daniel Kahneman, "Thinking, Fast and Slow"

**Principle**:
> "People are systematically overconfident in their predictions and judgments."

**Application**: Be humble about estimates and designs; plan for being wrong.

**Trigger**:
- Time estimates
- Architecture decisions
- "This will definitely work" statements

**Action**:
1. **Add buffer to estimates**:
   - Developer says "2 hours" → Budget 4 hours
   - Hofstadter's Law: "It always takes longer than you expect, even when you take into account Hofstadter's Law"
   
2. **Pre-mortem technique**:
   - Before starting, imagine project failed
   - Ask: "What went wrong?"
   - Address those risks proactively
   
3. **Safety valves**:
   - Failure count limits
   - Timeout mechanisms
   - Rollback procedures

---

## 5. Kahneman's Loss Aversion

**Source**: Daniel Kahneman, Prospect Theory (1979)

**Principle**:
> "Losses loom larger than gains. People will work harder to avoid losses than to achieve equivalent gains."

**Application**: Breaking existing functionality is worse than missing new features.

**Trigger**:
- Refactoring
- Upgrades
- API changes

**Action**:
1. **Backward compatibility by default**:
   - Don't break existing APIs without versioning
   - Deprecate, don't delete (with warnings)
   - Provide migration paths
   
2. **Comprehensive regression testing**:
   - Test that old functionality still works
   - Integration tests for existing workflows
   
3. **Gradual rollouts**:
   - Feature flags
   - Canary deployments
   - Easy rollback

---

## 6. Taleb's Fragile, Robust, Antifragile

**Source**: Nassim Taleb, "Antifragile" (2012)

**Principle**:
> "Fragile things break under stress. Robust things tolerate stress. Antifragile things get stronger from stress."

**Application**: Build systems that improve when stressed, not just tolerate it.

**Trigger**:
- Production systems
- High-traffic services
- Critical infrastructure

**Action**:
1. **Fragile** (avoid):
   - Single point of failure
   - No error handling
   - Assumes everything works
   
2. **Robust** (minimum):
   - Redundancy (backups, replicas)
   - Error handling
   - Timeouts and retries
   
3. **Antifragile** (ideal):
   - Circuit breakers that learn
   - Rate limiters that adapt
   - Caches that warm from traffic patterns
   - Validators that strengthen after seeing bad input
   - Monitoring that alerts on anomalies

---

## 7. Taleb's Fat Tails

**Source**: Nassim Taleb, "The Black Swan"

**Principle**:
> "In fat-tailed distributions, extreme events are more common than normal distributions predict."

**Application**: For critical systems, plan for extreme scenarios.

**Trigger**:
- Load planning
- Error handling
- Resource allocation

**Action**:
1. **Don't assume normal distribution**:
   - Traffic can spike 100x suddenly
   - Error rates can jump from 0.1% to 50%
   - Latency can go from 10ms to 10s
   
2. **Design for extremes**:
   - Rate limiting (protect against 100x spike)
   - Timeouts (protect against 10s latency)
   - Error budgets (graceful degradation)
   
3. **Test extreme scenarios**:
   - Load testing at 10x expected traffic
   - Chaos engineering (inject failures)
   - Red-team attacks

---

## PART 2: SECURITY (Schneier, Saltzer & Schroeder)

## 8. Schneier's Security Mindset

**Source**: Bruce Schneier, "Secrets and Lies" (2000)

**Principle**:
> "Security requires thinking like an attacker. Look for ways to break the system."

**Application**: Red-team evaluation for sensitive LEGOs.

**Trigger**:
- `sensitive = true` LEGOs
- Authentication & authorization
- Payment processing
- Data storage
- External APIs

**Action**:
1. **Mandatory red-team review**:
   - How could an attacker abuse this?
   - What assumptions can be violated?
   - What's the worst case scenario?
   
2. **Adversarial testing**:
   - Try malicious inputs
   - Test authentication bypass attempts
   - SQL injection, XSS, CSRF tests
   
3. **Document threat model**:
   - What are we protecting?
   - Who are the attackers?
   - What are their capabilities?

---

## 9. Saltzer & Schroeder's Principles (1975)

**Source**: Jerome Saltzer and Michael Schroeder, "The Protection of Information in Computer Systems"

### 9.1 Least Privilege
> "Every program and user should operate with the least set of privileges necessary."

**Application**: Grant minimum permissions needed.

**Trigger**:
- Authentication & authorization
- API key creation
- Database access
- Service accounts

**Action**:
1. **Default deny**:
   - Start with no permissions
   - Add only what's needed
   
2. **Scoped credentials**:
   - API keys for specific resources only
   - Database users with limited privileges (SELECT vs ALL)
   
3. **Time-limited tokens**:
   - JWTs with expiration
   - Refresh tokens for long-lived access

---

### 9.2 Fail-Safe Defaults
> "Default to lack of access. Deny unless explicitly granted."

**Application**: Security defaults; require explicit permission grants.

**Trigger**:
- Authorization logic
- API access control
- Feature flags

**Action**:
1. **Default deny**:
   - `if user.has_permission(X):` not `if not user.lacks_permission(X):`
   
2. **Explicit grants**:
   - Whitelist, not blacklist
   - Require explicit role assignment
   
3. **Fail securely**:
   - If auth check errors, deny access
   - If rate limiter fails, reject requests

---

### 9.3 Economy of Mechanism
> "Keep the design simple. Complexity increases attack surface."

**Application**: Simple security designs are easier to verify.

**Trigger**:
- Auth system design
- Cryptography usage
- Security-critical code

**Action**:
1. **Use standard libraries**:
   - Don't roll your own crypto
   - Use OAuth2/OIDC, don't invent auth
   
2. **Simple logic**:
   - Minimize branches in auth code
   - Clear permission model
   
3. **Auditable**:
   - Security code should be easy to review

---

### 9.4 Complete Mediation
> "Every access must be checked. Don't cache security decisions."

**Application**: Validate permissions on every request.

**Trigger**:
- API endpoints
- Data access
- Resource operations

**Action**:
1. **No caching of auth decisions**:
   - Check permissions on every request
   - Don't assume "user was authorized 5 seconds ago"
   
2. **Middleware pattern**:
   - Centralized auth checks
   - Every route goes through auth
   
3. **Server-side validation**:
   - Never trust client
   - Validate on server even if client validated

---

### 9.5 Open Design
> "Security should not depend on secrecy of design. Only keys should be secret."

**Application**: Assume attackers know your system design.

**Trigger**:
- Security architecture
- Cryptography usage
- Auth design

**Action**:
1. **Kerckhoffs's principle**:
   - System should be secure even if everything except keys is public
   - Don't rely on "security through obscurity"
   
2. **Public review**:
   - Security code can be open source
   - More eyes = more bugs found
   
3. **Only secrets are secret**:
   - API keys, passwords, tokens are secret
   - Algorithms, architecture, code are not

---

### 9.6 Separation of Privilege
> "Require multiple conditions for access. No single point of failure."

**Application**: Critical operations require multiple checks.

**Trigger**:
- High-value operations (payments, admin actions)
- Data deletion
- Privilege escalation

**Action**:
1. **Multi-factor auth**:
   - Password + OTP for admin access
   - 2FA for payment changes
   
2. **Approval workflows**:
   - Deployments require 2 approvals
   - Database migrations require review
   
3. **Defense in depth**:
   - Multiple security layers
   - No single point of failure

---

### 9.7 Least Common Mechanism
> "Minimize shared resources. Isolation reduces attack surface."

**Application**: Isolate tenants, users, and environments.

**Trigger**:
- Multi-tenant systems
- Shared resources
- Database design

**Action**:
1. **Tenant isolation**:
   - Separate schemas or databases
   - Row-level security
   
2. **Environment isolation**:
   - Dev, staging, prod are separate
   - No shared credentials
   
3. **User data isolation**:
   - Users can't access each other's data
   - Queries filtered by user ID

---

### 9.8 Psychological Acceptability
> "Security mechanisms should be easy to use correctly and hard to use incorrectly."

**Application**: Make the secure path the easy path.

**Trigger**:
- API design
- Developer experience
- Security tooling

**Action**:
1. **Secure by default**:
   - HTTPS by default
   - Parameterized queries (no raw SQL)
   - CSRF protection enabled
   
2. **Hard to misuse**:
   - Type system prevents common mistakes
   - Linters catch security issues
   
3. **Clear errors**:
   - "This API key lacks permission X" not "Forbidden"

---

## 10. Schneier's Attack Trees

**Source**: Bruce Schneier, "Attack Trees" (1999)

**Principle**:
> "Model attacks as trees: root is attacker's goal, branches are ways to achieve it."

**Application**: Systematically identify attack vectors.

**Trigger**:
- Red-team evaluation
- Security design review
- Threat modeling

**Action**:
1. **Define attacker goals**:
   - Steal user data
   - Bypass authentication
   - Cause service outage
   
2. **Enumerate attack paths**:
   - SQL injection → database access → data theft
   - Brute force → credential stuffing → account takeover
   
3. **Prioritize mitigations**:
   - Address highest-likelihood, highest-impact paths first
   - Document residual risks

---

## 11. Schneier's Defense in Depth

**Source**: Bruce Schneier, security principle

**Principle**:
> "Use multiple layers of security. If one fails, others still protect."

**Application**: Never rely on a single security control.

**Trigger**:
- ALWAYS for sensitive LEGOs
- Auth, data, payments

**Action**:
1. **Layer security controls**:
   - Input validation
   - Authentication
   - Authorization
   - Rate limiting
   - Logging & monitoring
   - Encryption at rest
   - Encryption in transit
   
2. **Fail gracefully**:
   - If one layer fails, others compensate
   
3. **Assume breach**:
   - What if attacker gets through first layer?
   - What damage can they do?

---

## 12. Schneier's Insider Threats

**Source**: Bruce Schneier, "Secrets and Lies"

**Principle**:
> "The biggest security threat often comes from inside the organization."

**Application**: Audit and limit internal access.

**Trigger**:
- Admin access
- Database access
- Production deployments

**Action**:
1. **Least privilege for employees**:
   - Admins only for those who need it
   - Time-limited elevated access
   
2. **Audit logs**:
   - Log all admin actions
   - Immutable audit trail
   - Regular review
   
3. **Separation of duties**:
   - No single person can deploy + approve
   - Code review required

---

## How to Use Risk & Security Wisdom

### During REQUIREMENTS Phase
- Principles 1 (Black Swan), 7 (Fat Tails), 10 (Attack Trees)
- Identify risks, threat model, extreme scenarios

### During LEGO Discovery
- Principles 2 (Skin in the Game), 6 (Antifragile), 9.1-9.8 (Security Principles)
- Identify sensitive LEGOs, design for ownership

### During DESIGN Phase
- Principles 3-5 (Kahneman's biases), 8-12 (Security)
- Apply security principles, avoid cognitive biases

### During CODING Phase
- Principles 9.3 (Economy), 9.4 (Complete Mediation), 9.8 (Psychological Acceptability)
- Simple, secure code that's hard to misuse

### During REVIEW Phase
- Principles 4 (Overconfidence), 8 (Security Mindset), 10 (Attack Trees)
- Challenge assumptions, red-team thinking

### During VALIDATION Phase
- Principles 7 (Fat Tails), 11 (Defense in Depth)
- Test extremes, validate layered defenses

---

## Adding Your Own Risk & Security Wisdom

To add new principles:

1. Identify source and context
2. State principle concisely
3. Map to software security/risk scenarios
4. Define clear triggers
5. Specify concrete actions

Risk & security wisdom should be:
- **Adversarial**: Think like an attacker
- **Paranoid**: Assume things will fail
- **Pragmatic**: Balance security with usability
- **Evidence-based**: Learn from past incidents
