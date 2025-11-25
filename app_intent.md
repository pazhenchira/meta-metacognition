# Application Intent

**👋 START HERE**: This is where you describe what you want to build.

The meta-orchestrator will read this file, ask clarifying questions, and build your complete app.

---

## What Do You Want To Build?

Describe your app idea in plain English (3-10 sentences):

- What problem does it solve?
- Who will use it?
- What are the main features?

**Example** (replace this with your own idea):

> I want to build a stock options signal generator that analyzes real-time options data 
> and identifies profitable trading opportunities. It should calculate Greeks (delta, gamma, 
> theta, vega), apply technical indicators, and generate buy/sell signals with risk metrics. 
> The goal is to achieve a Sharpe ratio >1.5 (risk-adjusted returns). It should work with 
> free-tier market data APIs and run on my laptop.

---

## Constraints & Priorities

What matters most? What are your limits?

**Performance**:
- Response time expectations?
- Data volume?

**Privacy / Security**:
- Sensitive data handling?
- Compliance requirements?

**Cost**:
- Free APIs only?
- Cloud budget limits?

**Complexity**:
- Keep it simple (KISS)?
- Need advanced features?

**Example**:
```
- Must use free-tier APIs (Alpha Vantage, Yahoo Finance)
- No cloud costs (runs locally)
- Privacy: No user data leaves local machine
- KISS: Simple algorithms preferred over complex ML
- Speed: Signals ready in <5 minutes before market open
```

---

## What's NOT In Scope (For Now)

Help the meta-orchestrator focus by saying what you DON'T need:

**Example**:
```
- No web UI (CLI is fine for v1)
- No real-time streaming (daily batch is enough)
- No machine learning (use proven technical indicators)
- No multi-user support (just me)
```

---

## Known Integrations or APIs (Optional)

List any specific services/APIs you know you want to use:

**Example**:
```
Data Sources:
- Alpha Vantage (free tier, 5 calls/min)
- Yahoo Finance (backup)

Authentication:
- None (local app)

Storage:
- SQLite (local, no cloud DB)
```

---

## Success Criteria

How will you know if the app works well?

**Example**:
```
Primary Success Metrics:
- Sharpe ratio >1.5 (risk-adjusted returns)
- Win rate >60%
- Max drawdown <15%

Usability:
- Time-to-first-signal <5 minutes
- Clear, actionable output (no jargon)
- Works reliably every day

Benchmark:
- Outperform S&P 500 by 20%+ annually
```

---

## Additional Context (Optional)

Anything else the meta-orchestrator should know?

- Your technical background?
- Existing code to integrate with?
- Specific design preferences?

**Example**:
```
- I'm a retail trader (not institutional)
- I know basic Python (intermediate level)
- I prefer functional programming style
- I have a Raspberry Pi I might deploy to later
```

---

## Ready?

Once you've filled this out, run:

```bash
@workspace Act as the meta-orchestrator in .meta/AGENTS.md and build this app
```

The meta-orchestrator will:
1. Ask 2-3 clarifying questions
2. Discover the "essence" of your app (what makes it unique)
3. Design the architecture (LEGO components)
4. Build everything in parallel
5. Test it thoroughly
6. Validate it actually works

You'll get a complete, working app in 15-45 minutes. 🚀
