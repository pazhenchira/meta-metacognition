# System-of-Systems Architecture: The Next Layer

> **Builds on**: `ECOSYSTEM_ARCHITECTURE.md` (Option D: Content-Aware Runtime)  
> **Author**: Systems Thinker (Architect perspective)  
> **Date**: 2025-07-19  
> **Status**: Proposal v1

---

## 0. What This Document Is

`ECOSYSTEM_ARCHITECTURE.md` established the **foundation**: three repos (factory, runtime, products), SOUL.md per domain, plugin taxonomy, cross-domain memory tiers, and quality-kit publishing. That document answers "what are the pieces?"

This document answers **"how do the pieces compose into a living system?"** — the system-of-systems layer that makes four autonomous domains behave like one coordinated organism.

---

## 1. The Human Life Analogy — Mapped Precisely

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  A PERSON organizing their life:        THE ECOSYSTEM equivalent:       │
│                                                                         │
│  ┌──────────────────────┐               ┌──────────────────────┐       │
│  │ SELF                 │               │ owner.yaml           │       │
│  │ core values          │               │ values, goals,       │       │
│  │ life goals           │               │ preferences,         │       │
│  │ temperament          │               │ risk posture          │       │
│  └──────────┬───────────┘               └──────────┬───────────┘       │
│             │                                      │                    │
│  ┌──────────▼───────────┐               ┌──────────▼───────────┐       │
│  │ BRAIN                │               │ nexus                │       │
│  │ connects all domains │               │ runtime + meta-layer │       │
│  │ transfers learning   │               │ cross-domain memory  │       │
│  │ enforces habits      │               │ quality enforcement  │       │
│  │ notices patterns     │               │ pattern recognition  │       │
│  └──────────┬───────────┘               └──────────┬───────────┘       │
│             │                                      │                    │
│  ┌──────────▼───────────────────────────────────────▼───────────────┐   │
│  │                                                                   │   │
│  │  LIFE DOMAINS                    PROJECT DOMAINS                   │   │
│  │                                                                   │   │
│  │  ┌─────────────┐                ┌──────────────────────────┐     │   │
│  │  │ WORK        │                │ ta (Technical Advisor)   │     │   │
│  │  │ career,     │                │ advisory, stewardship,   │     │   │
│  │  │ skills,     │                │ cross-domain coordinator │     │   │
│  │  │ reputation  │                │                          │     │   │
│  │  └─────────────┘                └──────────────────────────┘     │   │
│  │                                                                   │   │
│  │  ┌─────────────┐                ┌──────────────────────────┐     │   │
│  │  │ FINANCES    │                │ StocksTrader             │     │   │
│  │  │ investing,  │ ◄──────────►  │ equity portfolio engine   │     │   │
│  │  │ budgeting,  │                │                          │     │   │
│  │  │ tax planning│                ├──────────────────────────┤     │   │
│  │  └─────────────┘                │ OptionsTrader            │     │   │
│  │                                 │ options income engine    │     │   │
│  │                                 └──────────────────────────┘     │   │
│  │                                                                   │   │
│  │  ┌─────────────┐                ┌──────────────────────────┐     │   │
│  │  │ GROWTH      │                │ meta-metacognition       │     │   │
│  │  │ learning,   │                │ factory, engineering     │     │   │
│  │  │ creating,   │                │ discipline, creates new  │     │   │
│  │  │ building    │                │ domains                  │     │   │
│  │  └─────────────┘                └──────────────────────────┘     │   │
│  │                                                                   │   │
│  │  ┌─────────────┐                ┌──────────────────────────┐     │   │
│  │  │ FUTURE      │                │ (next domain the         │     │   │
│  │  │ whatever    │                │  factory creates)        │     │   │
│  │  │ comes next  │                │                          │     │   │
│  │  └─────────────┘                └──────────────────────────┘     │   │
│  │                                                                   │   │
│  └───────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  KEY PARALLELS:                                                         │
│                                                                         │
│  "I learned patience at work,       "ta learned Schwab API quirks;     │
│   it helps my relationships"         StocksTrader benefits from that"   │
│                                                                         │
│  "My values apply everywhere,        "Owner values (evidence > intuition)│
│   but each area has its own          apply everywhere; each domain has  │
│   priorities"                        its own SOUL"                      │
│                                                                         │
│  "I'm ONE person even though         "One nexus instance, one owner,   │
│   I wear different hats"             multiple domain contexts"          │
│                                                                         │
│  "I develop new interests —           "Factory creates new domains —    │
│   they get their own space            they get registered in nexus      │
│   but inherit my habits"              and inherit quality habits"       │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Where ta fits — the "Executive Function"

A crucial nuance: **ta is NOT just another domain**. In the human analogy, ta is the person's **executive function** — the part that:
- Looks across all domains and notices connections
- Makes recommendations to the owner
- Stewards the other domains (monitors health, triggers actions)
- Is the primary conversational interface for advisory work

```
nexus (infrastructure — the nervous system, involuntary processes)
  └── ta (executive function — conscious coordination, strategic advice)
       ├── StocksTrader (specialized function — equity execution)
       ├── OptionsTrader (specialized function — options execution)
       └── meta-metacognition (creative function — building new systems)
```

ta already does this. Its `.brain/context/domain.md` explicitly tracks StocksTrader and OptionsTrader health. Its orchestrator (Consul) stewards the trading apps' development. This isn't new behavior — it's acknowledging what already exists.

**Implication for the meta-layer**: The `service-meta-layer` should recognize ta's special role. When cross-domain routing asks "should I execute a trade based on this analysis?", the answer is: ta advises → StocksTrader/OptionsTrader executes. The meta-layer doesn't replace ta; it gives ta better visibility.

---

## 2. The Plugin Architecture — Concrete Design

### 2.1 Why plugins, and why NOW

The current `composition.ts` (453 lines) manually wires everything. Every new capability requires editing this file. The upcoming changes (SOUL injection, quality-kit resolution, cross-domain memory, lesson extraction) would each add 50-100 lines of tightly-coupled wiring.

Plugins solve this: each new capability is self-contained, testable, and independently deployable.

### 2.2 Plugin taxonomy — five types, mapped to nexus

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  NEXUS CORE (not pluggable — the skeleton)                          │
│                                                                     │
│  These are the bones. They exist today. They stay in src/.          │
│                                                                     │
│  SessionStore          TranscriptStore       SessionService         │
│  RuntimeBroker         ProcessSupervisor     ProjectRegistry        │
│  AuthService           Config/Schema         PluginManager (NEW)    │
│                                                                     │
│  Core provides the PluginApi surface — plugins extend it.           │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  PLUGIN TYPES                                                       │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  TYPE 1: CHANNELS                                           │   │
│  │                                                             │   │
│  │  Translates external messages ↔ nexus turns.                │   │
│  │  Each channel owns its auth, routing, and response format.  │   │
│  │                                                             │   │
│  │  Contract: ChannelPlugin                                    │   │
│  │    .name: string                                            │   │
│  │    .start(api): Promise<void>     // begin listening        │   │
│  │    .stop(): Promise<void>         // graceful shutdown      │   │
│  │                                                             │   │
│  │  Maps to existing:                                          │   │
│  │    src/interfaces/api/    → channel-api                     │   │
│  │    src/interfaces/cli/    → channel-cli                     │   │
│  │    src/interfaces/slack/  → channel-slack                   │   │
│  │                                                             │   │
│  │  Future: channel-teams, channel-discord, channel-email      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  TYPE 2: HOOKS                                              │   │
│  │                                                             │   │
│  │  Lifecycle interceptors that fire at defined points in      │   │
│  │  the turn pipeline. The PRIMARY extension point.            │   │
│  │                                                             │   │
│  │  Contract: HookHandler                                      │   │
│  │    (context: HookContext) => Promise<void>                  │   │
│  │                                                             │   │
│  │  Hook events (execution order within each phase):           │   │
│  │                                                             │   │
│  │  SESSION LIFECYCLE:                                         │   │
│  │    session-created     → session bound to project/runtime   │   │
│  │    session-expired     → session cleaned up                 │   │
│  │    session-resumed     → existing session reactivated       │   │
│  │                                                             │   │
│  │  TURN PIPELINE (ordered phases):                            │   │
│  │    preamble-compose    → build the system preamble          │   │
│  │    pre-turn            → after preamble, before LLM call    │   │
│  │    post-turn           → after LLM response received        │   │
│  │    turn-validated      → after protocol validation passes   │   │
│  │    turn-failed         → protocol validation exhausted      │   │
│  │                                                             │   │
│  │  SYSTEM EVENTS:                                             │   │
│  │    project-loaded      → project registered at startup      │   │
│  │    project-reloaded    → project config changed             │   │
│  │    plugin-loaded       → another plugin was loaded          │   │
│  │                                                             │   │
│  │  Maps to existing:                                          │   │
│  │    RuntimeBroker #applyProtocolEnforcement → hook           │   │
│  │    RuntimeBroker #checkProtocolCompliance  → hook           │   │
│  │    SessionRehydrator.buildProjectContext   → hook           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  TYPE 3: PROVIDERS                                          │   │
│  │                                                             │   │
│  │  LLM backends. Translate turn requests into LLM calls.      │   │
│  │                                                             │   │
│  │  Contract: ProviderPlugin                                   │   │
│  │    .name: string                                            │   │
│  │    .bind(session, projectPath, orchestrator): RuntimeBinding │   │
│  │    .release(bindingId): Promise<void>                       │   │
│  │                                                             │   │
│  │  Maps to existing:                                          │   │
│  │    src/runtime/acp/     → provider-copilot-acp (primary)    │   │
│  │    src/runtime/prompt/  → provider-copilot-prompt (fallback) │   │
│  │                                                             │   │
│  │  Future: provider-openai, provider-anthropic,               │   │
│  │          provider-local-llm                                 │   │
│  │                                                             │   │
│  │  NOTE: Only ONE provider is active per turn. RuntimeBroker  │   │
│  │  selects primary → fallback. Multiple providers = options,  │   │
│  │  not parallelism.                                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  TYPE 4: SERVICES                                           │   │
│  │                                                             │   │
│  │  Background processes that run alongside the turn pipeline. │   │
│  │  They don't intercept turns — they provide infrastructure.  │   │
│  │                                                             │   │
│  │  Contract: ServicePlugin                                    │   │
│  │    .name: string                                            │   │
│  │    .start(api): Promise<void>     // begin background work  │   │
│  │    .stop(): Promise<void>         // graceful shutdown      │   │
│  │    .health(): ServiceHealth       // for /health endpoint   │   │
│  │                                                             │   │
│  │  Maps to existing:                                          │   │
│  │    RetentionService → service-retention                     │   │
│  │                                                             │   │
│  │  New:                                                       │   │
│  │    service-meta-layer  → cross-domain routing + promotion   │   │
│  │    service-health      → aggregate health checks            │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  TYPE 5: TOOLS                                              │   │
│  │                                                             │   │
│  │  Extend agent capabilities with domain-specific tools.      │   │
│  │  These are MCP servers or tool definitions exposed to the   │   │
│  │  LLM runtime.                                               │   │
│  │                                                             │   │
│  │  Contract: ToolPlugin                                       │   │
│  │    .name: string                                            │   │
│  │    .description: string                                     │   │
│  │    .forDomains: string[] | '*'   // which domains use this  │   │
│  │    .register(api): void          // declare tool schemas    │   │
│  │                                                             │   │
│  │  No existing map — tools are currently Copilot CLI's domain.│   │
│  │  These would be project-specific MCP servers that nexus     │   │
│  │  ensures are running when a domain session is active.       │   │
│  │                                                             │   │
│  │  Future: tool-schwab-api, tool-graph-api, tool-market-data  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.3 The PluginManager — how plugins are discovered and loaded

```
PLUGIN RESOLUTION ORDER:
  1. Built-in plugins     → src/plugins/builtin/     (ship with nexus)
  2. Config-declared       → nexus.config.yaml        (per-project plugins)
  3. Project-local         → {projectPath}/plugins/   (domain-specific)

LOADING SEQUENCE (at startup):
  1. PluginManager.discover()   — scan all sources
  2. PluginManager.sort()       — topological sort by dependencies
  3. PluginManager.load()       — call register(api) on each
  4. PluginManager.start()      — call start() on channels + services
  
RELOAD (at runtime):
  POST /api/plugins/reload     — re-discover, diff, load new, unload removed
  File watcher on plugins/     — auto-reload on change (dev mode only)
```

### 2.4 The HookContext — what hooks can see and do

This is the most critical interface. It defines what a hook can access during the turn pipeline:

```typescript
interface HookContext {
  // Identity
  readonly sessionId: string;
  readonly projectName: string;
  readonly projectPath: string;
  readonly interfaceType: 'api' | 'cli' | 'slack';
  
  // Turn data (available in turn-pipeline hooks)
  readonly userMessage?: string;           // pre-turn, preamble-compose
  readonly assistantResponse?: string;     // post-turn, turn-validated
  
  // Preamble composition (available in preamble-compose)
  addPreambleSection(key: string, content: string, priority?: number): void;
  getPreambleSections(): Map<string, string>;
  
  // Stores (read/write access to nexus data)
  readonly sessions: SessionStore;
  readonly transcripts: TranscriptStore;
  readonly memory: ProjectMemoryStore;
  readonly lessons: LessonStore;
  readonly crossDomain: CrossDomainStore;
  readonly projects: ProjectRegistry;
  
  // Logging
  readonly logger: Logger;
  
  // Metadata (hooks can annotate turns)
  setMeta(key: string, value: unknown): void;
  getMeta(key: string): unknown;
}
```

### 2.5 Preamble composition order

The `preamble-compose` event fires before each turn. Hooks add sections with priority. Lower priority = earlier in preamble. The resulting preamble is:

```
PRIORITY  SECTION              SOURCE HOOK              CONTENT
────────  ───────────────────  ──────────────────────   ─────────────────────
  100     owner-values         hook-owner-values        owner.yaml values
  200     domain-soul          hook-soul-injection      SOUL.md
  300     quality-wisdom       hook-quality-kit         active wisdom from kit
  400     quality-skills       hook-quality-kit         active skill protocols
  500     cross-domain         hook-cross-domain        relevant lessons from 
                                                        other domains
  600     project-context      hook-project-context     recent session summaries
  700     active-goals         hook-goal-tracking       owner goals for domain
  800     domain-context       hook-domain-context      .brain/context/ files
  900     protocol             hook-protocol-enforce    PLAN/EXECUTE/REVIEW
```

**Token budget**: The `preamble-compose` phase has a configurable token budget (default: 4000 tokens). If the composed preamble exceeds it, sections are trimmed starting from the lowest priority (owner values and soul are never trimmed).

---

## 3. Per-Project SOUL — Where It Lives, What It Contains

### 3.1 The SOUL is NOT the agent file

This distinction matters:

| Concept | File | Scope | Who reads it |
|---------|------|-------|-------------|
| **SOUL** | `SOUL.md` (project root) | The domain's identity | nexus (injected into every turn) |
| **Agent** | `.github/agents/*.agent.md` | An agent's instructions | Copilot CLI (runtime) |
| **Essence** | `.brain/context/essence.md` or `essence.md` | What makes the domain valuable | Humans + orchestrator |

The SOUL.md is a **nexus-facing** file. It tells nexus who this domain is, what it values, and how it relates to other domains. Agent files tell the LLM how to behave. Essence files tell the builder what matters.

### 3.2 Relationship: SOUL → quality-kit → agent files

```
┌────────────────────────────────────────────────────────────────────┐
│                                                                    │
│  SOUL.md (domain identity — stable, rarely changes)                │
│    "I am a quality-compounder portfolio engine."                   │
│    "I value disciplined execution over intuition."                 │
│    "I provide portfolio status to ta."                             │
│    "I consume research from ta."                                   │
│                                                                    │
│  → Read by nexus at session-bind time                              │
│  → Injected into every turn preamble                               │
│  → The domain's constitutional document                            │
│                                                                    │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Quality Kit (shared standards — versioned, from factory)          │
│    "Use GEN+REVIEW pattern."                                       │
│    "Apply pre-ship-review before committing."                      │
│    "Detect antipatterns like God Object."                          │
│                                                                    │
│  → Resolved by nexus from .brain/kit.yaml version reference        │
│  → Injected into preamble per domain's active-skills selection     │
│  → The organization's operating manual                             │
│                                                                    │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  .github/agents/*.agent.md (agent instructions — operational)      │
│    "You are Kai, the orchestrator for StocksTrader."               │
│    "You dispatch to architect, developer, tester."                 │
│    "You read .brain/status.md on every session start."             │
│                                                                    │
│  → Read by Copilot CLI at runtime                                  │
│  → Domain-specific operational instructions                        │
│  → Can reference SOUL.md and quality-kit concepts                  │
│  → The employee's job description                                  │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### 3.3 SOUL.md template

```markdown
# SOUL: {Domain Name}

## Identity
{One paragraph. What this domain IS. Its fundamental purpose.}

## Values
{Ordered list. What this domain prioritizes. Most important first.}

## Boundaries  
{Hard limits. What this domain will NOT do. Prevents scope creep.}

## Relationship to Owner
{How this domain serves the owner. The nature of the relationship.}

## Cross-Domain Interface
{How this domain relates to other domains.}
- PROVIDES: {what} → {which domains}
- CONSUMES: {what} ← {which domains}
```

### 3.4 Where SOUL.md content comes from (extraction map)

Each project already has its identity scattered across files. SOUL.md consolidates it:

| Project | Identity source files | Extraction notes |
|---------|----------------------|-----------------|
| **ta** | `.brain/context/essence.md` ("take care of the sponsor"), `.brain/orchestrator/identity.yaml` (Consul's purpose), `README.md` (advisor definition) | Rich identity already. SOUL.md extracts the constitutional parts. |
| **mc-StocksTrader** | `essence.md` (quality-compounder identity), `app_intent.md` (systematic investing), `.brain/config.yaml` (project description) | Clear identity. SOUL values = disciplined execution, bias-free, long-term. |
| **mc-OptionsTrader** | `essence.md` (risk-managed options engine), `app_intent.md` (EOD execution), `.brain/config.yaml` | Clear identity. SOUL values = safety-first, risk-managed, automated. |
| **meta-metacognition** | `essence.md` (engineering CTO), `.github/agents/atlas.agent.md` (factory identity) | Dual identity: factory AND engine. SOUL captures both. |

### 3.5 How SOUL relates to existing `.brain/context/essence.md`

They are **different documents** serving different audiences:

- **essence.md** → For the builder/orchestrator. "Why does this project exist? What makes it valuable?" Used during build phases to validate that work aligns with intent.
- **SOUL.md** → For nexus. "Who is this domain? How does it relate to the owner and other domains?" Used at runtime to compose the preamble.

A project keeps both. essence.md is richer (problem statement, differentiators, success criteria). SOUL.md is focused (identity, values, boundaries, interfaces).

---

## 4. Cross-Domain Memory Architecture

### 4.1 The critical bug in current memory

Today's `ProjectMemoryStore` has ONE table with NO project discrimination:

```sql
-- Current schema (project-memory-store.ts:98-108)
CREATE TABLE session_summaries (
  session_id TEXT PRIMARY KEY,
  summary TEXT NOT NULL,
  topics TEXT NOT NULL DEFAULT '[]',
  created_at TEXT NOT NULL,
  turn_count INTEGER NOT NULL DEFAULT 0
);
```

`getRecentSummaries()` returns summaries from ANY project. When StocksTrader asks for context, it might get ta's financial advisory sessions mixed in. This is a **data contamination bug** in the current code.

### 4.2 Three-tier memory — concrete schema

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  TIER 1: DOMAIN MEMORY                                              │
│  Database: nexus-domain-{projectName}.sqlite (one per domain)       │
│  Scope: strictly one project                                        │
│                                                                     │
│  Tables:                                                            │
│                                                                     │
│  session_summaries (migrated from project-memory-store)             │
│    session_id TEXT PK                                               │
│    domain TEXT NOT NULL             ← NEW: "stocks", "options", etc │
│    summary TEXT NOT NULL                                            │
│    topics TEXT NOT NULL DEFAULT '[]'                                │
│    created_at TEXT NOT NULL                                         │
│    turn_count INTEGER NOT NULL DEFAULT 0                            │
│                                                                     │
│  domain_lessons                                                     │
│    id TEXT PK                       ← UUID                          │
│    content TEXT NOT NULL            ← the lesson                    │
│    source_session TEXT              ← which session produced it     │
│    source_turn INTEGER              ← which turn                    │
│    tags TEXT NOT NULL DEFAULT '[]'  ← JSON array of tags            │
│    confidence REAL DEFAULT 0.5      ← how confident (0-1)          │
│    access_count INTEGER DEFAULT 0   ← how often retrieved          │
│    created_at TEXT NOT NULL                                         │
│    last_accessed TEXT                                               │
│                                                                     │
│  Usage: SessionRehydrator injects recent summaries + lessons        │
│  into new sessions for this domain only.                            │
│                                                                     │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                    lesson promotion (tag-based)
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  TIER 2: CROSS-DOMAIN MEMORY                                        │
│  Database: nexus-cross-domain.sqlite (one global)                   │
│  Scope: all projects, filtered by relevance                         │
│                                                                     │
│  Tables:                                                            │
│                                                                     │
│  cross_lessons                                                      │
│    id TEXT PK                                                       │
│    source_domain TEXT NOT NULL      ← which domain learned this     │
│    source_lesson_id TEXT            ← FK to domain_lessons          │
│    content TEXT NOT NULL                                            │
│    tags TEXT NOT NULL DEFAULT '[]'                                  │
│    relevant_domains TEXT NOT NULL   ← JSON array of domain names    │
│    promoted_at TEXT NOT NULL                                        │
│    access_count INTEGER DEFAULT 0                                   │
│    last_accessed TEXT                                               │
│                                                                     │
│  domain_tag_registry                                                │
│    domain TEXT NOT NULL                                             │
│    tag TEXT NOT NULL                                                │
│    PRIMARY KEY (domain, tag)                                        │
│    -- Auto-populated from SOUL.md cross-domain interfaces           │
│    -- and from discovered tags in domain sessions                   │
│                                                                     │
│  Usage: hook-cross-domain-context queries this on every turn.       │
│  Finds lessons from OTHER domains that are tagged as relevant       │
│  to the CURRENT domain.                                             │
│                                                                     │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                    value alignment check
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  TIER 3: OWNER MEMORY                                               │
│  Source: nexus.config.yaml owner section (expanded)                  │
│  Scope: the owner — injected into every domain                      │
│                                                                     │
│  Content (from owner.yaml or nexus config):                         │
│                                                                     │
│  owner:                                                             │
│    values:                                                          │
│      - "Evidence over intuition"                                    │
│      - "Long-term thinking over short-term optimization"            │
│      - "KISS — simplest solution that works"                        │
│      - "Quality through verification, not trust"                    │
│    goals:                                                           │
│      - id: "financial-independence"                                 │
│        description: "Build toward financial independence"            │
│        relevant_domains: ["stocks", "options", "ta"]                │
│      - id: "engineering-excellence"                                 │
│        description: "Maintain high engineering quality"              │
│        relevant_domains: ["metacognition", "stocks", "options"]     │
│    preferences:                                                     │
│      risk_posture: "moderate-conservative"                          │
│      decision_style: "evidence-based"                               │
│                                                                     │
│  Usage: hook-owner-values injects owner values/goals into every     │
│  session preamble. Domains inherit owner values but express them    │
│  through their own SOUL.                                            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 4.3 How lessons flow between domains — concrete algorithm

```
LESSON EXTRACTION (post-turn hook):
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  1. Scan assistant response for extractable lessons              │
│     - Pattern: explicit statements of fact or discovery          │
│     - Pattern: corrections ("actually, the rate limit is...")    │
│     - Pattern: configuration values discovered                   │
│     - NOT: opinions, plans, questions                            │
│                                                                  │
│  2. For each candidate lesson:                                   │
│     a. Generate tags from content (keyword extraction)           │
│     b. Check for duplicates in DomainLessonStore                 │
│     c. If new: store in domain_lessons                           │
│     d. Set initial confidence = 0.5                              │
│                                                                  │
│  3. Confidence adjustment:                                       │
│     - Lesson confirmed again in later turn → +0.2               │
│     - Lesson contradicted → -0.3                                 │
│     - Lesson accessed and used → +0.1                            │
│     - Confidence < 0.2 → mark for review/deletion               │
│     - Confidence > 0.8 → eligible for cross-domain promotion    │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘

LESSON PROMOTION (service-meta-layer, periodic):
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  1. Scan all domain_lessons where confidence > 0.8               │
│     and not already in cross_lessons                             │
│                                                                  │
│  2. For each high-confidence lesson:                             │
│     a. Look up tags in domain_tag_registry                       │
│     b. Find OTHER domains that share those tags                  │
│     c. If overlap found → promote to cross_lessons               │
│        with relevant_domains = matching domains                  │
│                                                                  │
│  Example:                                                        │
│     Lesson from options: "Schwab OAuth token expires in 30 min"  │
│     Tags: [schwab, oauth, api, authentication]                   │
│     domain_tag_registry:                                         │
│       stocks → [schwab, api, portfolio, rebalance]               │
│       options → [schwab, api, options, greeks]                   │
│     Tag overlap: schwab, api → promote to cross_lessons          │
│     relevant_domains: ["stocks", "options"]                      │
│                                                                  │
│  3. Staleness: lessons not accessed in 60 days → demote          │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘

CROSS-DOMAIN INJECTION (pre-turn hook):
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  1. Query cross_lessons WHERE current domain is in               │
│     relevant_domains                                             │
│     ORDER BY access_count DESC, promoted_at DESC                 │
│     LIMIT 5                                                      │
│                                                                  │
│  2. Format as preamble section:                                  │
│     "[Cross-domain lessons]                                      │
│      From OptionsTrader: Schwab OAuth token expires in 30 min.   │
│      From ta: MSFT position is 35% of portfolio — overweight."   │
│                                                                  │
│  3. Update access_count + last_accessed on retrieved lessons     │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### 4.4 Domain isolation guarantees

Despite cross-domain memory, each domain is isolated:

| Boundary | Mechanism |
|----------|-----------|
| **Session state** | Sessions are keyed by `(owner, domain, interface_context)`. A stocks session never shares state with an options session. |
| **Transcript data** | Transcripts are per-session. No cross-reading. |
| **Domain lessons** | Stored in separate per-domain SQLite files. One domain cannot directly read another's lessons. |
| **Cross-domain lessons** | Read-only for consumers. Only the meta-layer service writes to `cross_lessons`. |
| **Runtime binding** | Each session binds to its own Copilot CLI process, running in its domain's project directory. |
| **SOUL injection** | Each session gets only its own domain's SOUL.md. Never another domain's. |
| **Agent files** | Copilot CLI reads `.github/agents/` from the domain's project directory. Domain A's agents are invisible to domain B's runtime. |

**The ONLY cross-domain paths are:**
1. Cross-domain lessons (promoted, read-only, injected into preamble)
2. Owner values/goals (shared, injected into every domain)
3. Domain routing (meta-layer routes a request to a different domain)

---

## 5. Cross-Domain Routing and Communication

### 5.1 How domains talk to each other

Domains do NOT directly communicate. All cross-domain flow goes through nexus:

```
USER: "Based on ta's analysis, should StocksTrader buy MSFT?"

FLOW:
  1. Message arrives in StocksTrader session (user is in stocks domain)
  2. hook-cross-domain-context fires (pre-turn)
     → injects relevant ta lessons ("MSFT overweight in portfolio")
  3. StocksTrader's agent answers within its domain context
     → "Based on cross-domain context from ta: portfolio is already
        35% MSFT. Adding more would increase concentration risk."

  The agent has CONTEXT from ta, but the ANSWER comes from
  StocksTrader's domain logic.
```

### 5.2 What about active cross-domain requests?

The user might say: "Ask ta to analyze MSFT before deciding."

This is a **domain switch**, not a cross-domain call:

```
FLOW:
  1. Message arrives in StocksTrader session
  2. Agent recognizes: "I can't do ta's analysis. That's ta's domain."
  3. Response: "I recommend switching to ta for MSFT analysis first.
     Use 'switch to ta' and ask for MSFT analysis."
     
  OR (with meta-layer routing):
  
  1. Meta-layer recognizes the cross-domain intent
  2. Creates a new session in ta domain with the analysis request
  3. ta produces the analysis
  4. Result is stored as a cross-domain lesson
  5. On the next StocksTrader turn, the analysis is available
```

**Decision: Start with option 1 (manual switch).** Automated cross-domain session creation (option 2) is powerful but complex. It requires:
- Request queuing
- Response collection
- Session lifecycle management across domains
- Error handling if ta's session fails

Build option 1 first. Add option 2 as `service-meta-layer` matures.

### 5.3 Meta-awareness — nexus-level insights

The `service-meta-layer` can surface patterns across domains:

```
PATTERN DETECTION (periodic, e.g., daily):
  1. Query cross_lessons for clusters
     → "Schwab API" appears in lessons from both stocks and options
     → "Same API issue in two domains" → surface to ta
  
  2. Query session_summaries across domains for failure patterns
     → "Both stocks and options sessions failed with auth errors
        on the same day" → surface to ta and owner
  
  3. Goal progress tracking
     → "financial-independence" goal touches stocks, options, ta
     → Aggregate: portfolio up 12%, options income on target,
        ta monitoring active

OUTPUT: service-meta-layer writes meta-observations to a 
  meta_insights table, surfaced via:
  - Injected into ta sessions (ta is the executive function)
  - Available via API: GET /api/meta/insights
  - Optionally pushed to Slack
```

---

## 6. Default Plugin Inventory

### 6.1 What ships with nexus (built-in)

These plugins are in `src/plugins/builtin/` and are always available:

| Plugin | Type | Purpose | Status |
|--------|------|---------|--------|
| **channel-api** | channel | REST API + SSE streaming | Extract from `src/interfaces/api/` |
| **channel-cli** | channel | Commander CLI over HTTP | Extract from `src/interfaces/cli/` |
| **channel-slack** | channel | Bolt Socket Mode adapter | Extract from `src/interfaces/slack/` |
| **provider-copilot-acp** | provider | Copilot `--acp --stdio` | Extract from `src/runtime/acp/` |
| **provider-copilot-prompt** | provider | Copilot `--prompt` fallback | Extract from `src/runtime/prompt/` |
| **hook-owner-values** | hook | Inject owner values at `preamble-compose` | NEW |
| **hook-soul-injection** | hook | Read + inject SOUL.md at `preamble-compose` | NEW |
| **hook-protocol-enforcement** | hook | PLAN/EXECUTE/REVIEW + validation + retry | Extract from `RuntimeBroker` |
| **hook-project-context** | hook | Recent session summaries at `preamble-compose` | Extract from `SessionRehydrator` |
| **hook-quality-kit** | hook | Resolve kit, inject wisdom/skills at `preamble-compose` | NEW |
| **hook-cross-domain-context** | hook | Inject cross-domain lessons at `pre-turn` | NEW |
| **hook-lesson-extraction** | hook | Extract lessons at `post-turn` | NEW |
| **hook-goal-tracking** | hook | Inject relevant goals at `preamble-compose` | NEW |
| **service-retention** | service | Session cleanup + summary generation | Extract from `RetentionService` |
| **service-meta-layer** | service | Lesson promotion + pattern detection | NEW |

### 6.2 What every project gets (regardless of domain)

Through the built-in plugins above, every domain automatically receives:
- Owner values injection
- SOUL injection
- Protocol enforcement (PLAN/EXECUTE/REVIEW)
- Session context from recent conversations
- Cross-domain lesson injection
- Post-turn lesson extraction
- Goal awareness

**No project-specific configuration needed for these.** They work if SOUL.md exists and `.brain/kit.yaml` is present.

### 6.3 What trading domains add

Declared in `nexus.config.yaml` per project:

```yaml
wrappedProjects:
  projects:
    - name: "ta"
      plugins:
        tools:
          - graph-api          # Microsoft Graph (email/calendar/tasks)
        hooks:
          - proactive-care     # periodically check on owner
          
    - name: "stocks"
      plugins:
        tools:
          - schwab-api         # brokerage integration
        hooks:
          - eod-report         # end-of-day portfolio summary
          
    - name: "options"
      plugins:
        tools:
          - schwab-api         # same broker, shared plugin
        hooks:
          - eod-report         # shared pattern
          - risk-monitor       # continuous risk checking
```

### 6.4 What the factory needs (meta-metacognition specific)

The factory domain doesn't need trading tools. Its domain-specific needs:
- Access to the 12-phase pipeline playbook (via quality-kit, already built-in)
- Template generation capabilities (these are in the factory repo, not nexus)
- No special nexus plugins — the factory's value is in its `.github/agents/` and repo content

### 6.5 What's extensible for future domains

The plugin architecture handles unknown future domains naturally:

```
Owner creates a "health-tracker" domain via the factory:
  1. Factory generates SOUL.md, .brain/, .github/agents/, app code
  2. Factory registers in nexus.config.yaml
  3. nexus loads the domain on next reload
  4. Built-in plugins (soul, quality-kit, cross-domain, protocol) 
     activate automatically
  5. If the domain needs special tools (e.g., Apple Health API),
     the factory generates a tool plugin in the project's plugins/ dir
```

---

## 7. Concrete File and Component Changes

### 7.1 Changes to nexus (`C:\Dev\nexus`)

```
PHASE 1: Plugin Infrastructure
──────────────────────────────

NEW FILES:
  src/plugins/
    plugin-api.ts              # NexusPluginApi interface
    plugin-manager.ts          # Discovery, loading, lifecycle
    plugin-types.ts            # ChannelPlugin, HookHandler, ProviderPlugin, 
                               # ServicePlugin, ToolPlugin contracts
    hook-context.ts            # HookContext implementation
    preamble-composer.ts       # Ordered preamble section composition

  src/plugins/builtin/
    hook-owner-values.ts       # Reads owner values from config
    hook-soul-injection.ts     # Reads SOUL.md from project path
    hook-protocol-enforcement.ts  # Extracted from RuntimeBroker
    hook-project-context.ts    # Extracted from SessionRehydrator

MODIFIED FILES:
  src/app/composition.ts       # Create PluginManager, register built-ins,
                               # load config-declared plugins
  src/runtime/runtime-broker.ts # Delegate preamble composition to hooks
                               # instead of inline #applyProtocolEnforcement
  src/config/schema.ts         # Add plugins section to project config,
                               # add owner.values/goals to schema

PHASE 2: Quality Kit Integration
─────────────────────────────────

NEW FILES:
  src/plugins/builtin/
    hook-quality-kit.ts        # Resolves quality-kit version, reads content,
                               # injects active wisdom + skills into preamble
  src/quality-kit/
    kit-resolver.ts            # Reads .brain/kit.yaml, locates kit content
    kit-loader.ts              # Reads and caches kit files

PHASE 3: Memory Architecture
─────────────────────────────

NEW FILES:
  src/sessions/
    domain-lesson-store.ts     # Per-domain lesson storage (SQLite)
    cross-domain-store.ts      # Cross-domain lesson storage (SQLite)
    lesson-extractor.ts        # Keyword extraction from assistant responses
    
  src/plugins/builtin/
    hook-lesson-extraction.ts  # Post-turn: extract + store domain lessons
    hook-cross-domain-context.ts  # Pre-turn: inject relevant cross-domain
    hook-goal-tracking.ts      # Preamble-compose: inject owner goals
    service-meta-layer.ts      # Background: lesson promotion, pattern 
                               # detection, cross-domain routing

MODIFIED FILES:
  src/sessions/project-memory-store.ts
    # Add domain column to session_summaries
    # Scope getRecentSummaries() to current domain
  
  src/sessions/session-rehydrator.ts
    # Pass domain name to getRecentSummaries()
    # Include domain lessons in context prompt
```

### 7.2 Changes to nexus config (`nexus.config.yaml`)

```yaml
# BEFORE (current)
owner:
  tokenSecret: "..."

# AFTER
owner:
  tokenSecret: "..."
  values:
    - "Evidence over intuition"
    - "Long-term thinking over short-term optimization"
    - "KISS — simplest solution that works"
    - "Quality through verification, not trust"
  goals:
    - id: "financial-independence"
      description: "Build toward financial independence"
      relevant_domains: ["stocks", "options", "ta"]
    - id: "engineering-excellence"
      description: "Maintain high engineering quality across all projects"
      relevant_domains: ["metacognition", "stocks", "options"]
  preferences:
    risk_posture: "moderate-conservative"
    decision_style: "evidence-based"

# Per-project plugins added:
wrappedProjects:
  projects:
    - name: "ta"
      path: "C:\\Dev\\ta"
      plugins:
        hooks: [proactive-care]
        tools: [graph-api]
      # protocolEnforcement REMOVED — handled by hook-protocol-enforcement
```

### 7.3 Changes to each project (apps)

```
EVERY PROJECT gets:
  /SOUL.md                     # NEW: domain identity (one-time extraction)

ta (C:\Dev\ta):
  /SOUL.md                     # Extracted from .brain/context/essence.md 
                               # + orchestrator/identity.yaml
  .brain/kit.yaml              # NEW: quality-kit version reference

mc-StocksTrader (C:\Dev\mc-StocksTrader):
  /SOUL.md                     # Extracted from essence.md + app_intent.md
  .brain/kit.yaml              # NEW: quality-kit version reference

mc-OptionsTrader (C:\Dev\mc-OptionsTrader):
  /SOUL.md                     # Extracted from essence.md + app_intent.md
  .brain/kit.yaml              # NEW: quality-kit version reference

meta-metacognition (C:\Dev\meta-metacognition):
  /SOUL.md                     # Extracted from essence.md + atlas.agent.md
  .brain/kit.yaml              # NEW: quality-kit version reference
  quality-kit/                 # NEW: the publishable kit artifact
    manifest.json              # Kit version, compatibility, contents
    wisdom/                    # Curated from .brain/wisdom/
    patterns/                  # Curated from patterns/
    skills/                    # Curated from skills/
    roles/                     # Curated from .brain/roles/
    playbooks/                 # Curated from .brain/playbooks/
```

### 7.4 What gets REMOVED from apps (Phase 4 — after system is proven)

After the quality-kit is working through nexus, apps can shed framework files:

```
EACH APP can remove (these now come from quality-kit via nexus):
  patterns/antipatterns.md            → from kit
  patterns/success_patterns.md        → from kit
  patterns/bs-detection.md            → from kit
  patterns/command_verification.md    → from kit
  patterns/trade_off_matrix.md        → from kit
  
  skills/ (generic protocols only):
    pre-ship-review.skill.md          → from kit
    structured-challenge.skill.md     → from kit
    investigation-framing.skill.md    → from kit
    (domain-specific skills STAY)
    
  .brain/wisdom/ (entire directory)   → from kit
  .brain/roles/ (generic roles)       → from kit

EACH APP keeps:
  SOUL.md                             → domain identity
  .brain/config.yaml                  → project metadata
  .brain/kit.yaml                     → kit version reference
  .brain/status.md                    → operational state
  .brain/lessons.md                   → domain lessons (migrated to LessonStore)
  .brain/context/                     → domain-specific context
  .github/agents/                     → domain-specific agents
  skills/ (domain-specific only)      → domain skills
  src/ or app code                    → the actual application
```

---

## 8. Implementation Sequence (Refined)

### Sprint 1: Fix the foundation (1-2 days)
1. Add `domain` column to `ProjectMemoryStore.session_summaries`
2. Scope `getRecentSummaries()` by domain
3. Update `SessionRehydrator` to pass domain name
4. Tests for domain isolation in memory

### Sprint 2: Plugin infrastructure (3-5 days)
1. Define `NexusPluginApi`, `HookContext`, plugin type contracts
2. Build `PluginManager` (discover, load, lifecycle)
3. Build `PreambleComposer` (ordered section composition)
4. Extract `hook-protocol-enforcement` from RuntimeBroker
5. Extract `hook-project-context` from SessionRehydrator
6. Wire into `composition.ts` — existing behavior, new architecture

### Sprint 3: SOUL + owner values (2-3 days)
1. Create SOUL.md for each project (one-time extraction)
2. Add owner values/goals to nexus config schema
3. Build `hook-soul-injection` (reads SOUL.md, adds to preamble)
4. Build `hook-owner-values` (reads owner config, adds to preamble)
5. Remove static preamble from `nexus.config.yaml` per-project configs
6. Verify: turns now compose preamble dynamically

### Sprint 4: Quality kit (3-5 days)
1. Create `quality-kit/` in meta-metacognition with manifest
2. Build `kit-resolver.ts` and `kit-loader.ts` in nexus
3. Build `hook-quality-kit` plugin
4. Add `.brain/kit.yaml` to each project
5. Verify: quality content injected from kit, not from project files

### Sprint 5: Cross-domain memory (3-5 days)
1. Build `DomainLessonStore` (per-domain SQLite)
2. Build `CrossDomainStore` (global SQLite)
3. Build `hook-lesson-extraction` (post-turn keyword extraction)
4. Build `hook-cross-domain-context` (pre-turn injection)
5. Build `service-meta-layer` (lesson promotion)
6. Verify: lesson learned in options appears in stocks session

### Sprint 6: Thin the apps (2-3 days, after everything proven)
1. Remove framework files from each app
2. Verify each app works through nexus (full quality)
3. Verify each app works standalone (graceful degradation)

---

## 9. Open Questions for Sponsor Decision

| # | Question | Options | Recommendation |
|---|----------|---------|----------------|
| 1 | Should ta have a special "executive function" role in the meta-layer, or be just another domain? | **A**: ta is special — meta-layer routes insights to ta first. **B**: All domains are equal — meta-layer distributes evenly. | **A** — ta already functions this way. Codify reality. |
| 2 | Should cross-domain routing support automated session creation (domain A requests work from domain B)? | **A**: Manual only — user switches domains. **B**: Automated — meta-layer creates cross-domain sessions. | **A first**, then B — automated cross-domain is powerful but complex. Start manual. |
| 3 | Should the quality-kit be an npm package or a local filesystem reference? | **A**: npm package (`@meta/quality-kit@4.0.0`). **B**: Filesystem symlink/copy. **C**: Git submodule. | **B first** — local filesystem. Upgrade to A when there are multiple consumers. |
| 4 | Lesson extraction — LLM-based or keyword heuristic? | **A**: LLM summarizes and tags lessons (accurate but token-expensive). **B**: Keyword/regex extraction (fast but misses nuance). | **B first** — keyword extraction. LLM extraction as a future upgrade when the pipeline is stable. |
| 5 | Should the plugin system support hot-reload in production? | **A**: Yes — file watcher + API reload. **B**: Restart required for plugin changes. | **B** with API reload (`POST /api/plugins/reload`). No file watcher in production. |

---

## 10. Risks and Mitigations (System-of-Systems Level)

| Risk | Severity | Mitigation |
|------|----------|------------|
| Preamble token bloat (SOUL + kit + cross-domain + goals + protocol) | **High** | PreambleComposer enforces token budget. Priority-based trimming. Measure actual token counts in Sprint 3. |
| Lesson extraction produces noise | **High** | Start with high confidence threshold (0.8) for promotion. Keyword extraction is conservative. Add LLM extraction later. |
| Plugin manager adds startup complexity | **Medium** | Strangler Fig: existing code stays in-place. Plugins wrap it. No big-bang migration. |
| Cross-domain lessons leak sensitive information | **Medium** | Lessons are factual (API rate limits, configuration values), not strategy or personal data. Tag-based promotion limits scope. |
| ta's "executive function" role creates a bottleneck | **Low** | ta is a routing preference, not a hard requirement. Owner can interact with any domain directly. |
| Quality-kit version mismatch across projects | **Low** | nexus logs a warning if projects reference different kit versions. Kit resolver falls back to latest available. |
| Single SQLite for cross-domain becomes a bottleneck | **Very Low** | Personal use = low volume. If needed, migrate to project-scoped cross-domain tables joined at query time. |
