# Behavioral Economics Wisdom

> Applied to understanding WHY things happen through incentive structures, not just WHAT things cost.

---

## Core Principle: Incentives Explain Behavior

"Economics is, at root, the study of incentives: how people get what they want, or need, especially when other people want or need the same thing." — Steven Levitt

---

## Key Sources

| Expert | Work | Key Insight |
|--------|------|-------------|
| Steven Levitt & Stephen Dubner | Freakonomics (2005) | Incentives explain behavior better than demographics |
| Dan Ariely | Predictably Irrational (2008) | Humans are irrational in predictable, exploitable ways |
| Richard Thaler & Cass Sunstein | Nudge (2008) | Choice architecture shapes decisions more than information |
| Donella Meadows | Thinking in Systems (2008) | Feedback loops and delays determine system behavior |
| Charles Goodhart | Goodhart's Law (1975) | When a measure becomes a target, it ceases to be a good measure |
| Mancur Olson | The Logic of Collective Action (1965) | Individual rationality ≠ collective rationality |

---

## Applied Principles

### 1. Goodhart's Law
"When a measure becomes a target, it ceases to be a good measure."

**Application**: Any metric you create will be gamed. Design metrics that are hard to game, or use multiple complementary metrics.

**Example**: Test coverage target of 80% → engineers write trivial tests that hit lines but don't validate logic. Better: measure bug escape rate + coverage together.

### 2. Revealed Preferences
People's actions reveal their true priorities, not their words.

**Application**: Don't trust stated requirements. Look at what users actually DO. If they say "quality matters" but measure velocity, velocity is the real priority.

### 3. Unintended Consequences
Every policy/system change creates second-order effects that may overwhelm the intended effect.

**Application**: Before implementing any process change, ask "what behavior will this incentivize?" and "what will people optimize for at the expense of?"

### 4. Incentive-Compatible Design
Systems work when individual incentives align with collective goals. They break when incentives diverge.

**Application**: Design systems where doing the right thing IS the easy/rewarded thing. Don't rely on people acting against their incentives.

### 5. Moral Hazard
When someone is insulated from consequences, they take more risks.

**Application**: If agents can claim "done" without verification, they will be less careful. Evidence manifests create skin in the game.

---

## Key Questions (Apply to Any Decision)

1. What incentives does this create?
2. What will people game or optimize for?
3. What's the revealed preference (actions vs. words)?
4. What won't get measured (and thus neglected)?
5. What's the unintended consequence?
6. Is this incentive-compatible?
7. Who benefits? Who loses?

---

## Anti-Wisdom (What to Avoid)

- "People will do the right thing" — No, they'll do the incentivized thing
- "We just need to measure X" — Goodhart's Law says X will be gamed
- "This policy will make people Y" — Check for unintended consequences first
- "Correlation means causation" — Usually doesn't; look for confounders
