# Meta-Metacognition

**Version 3.1.1** | [Changelog](CHANGELOG.md) | [Deployment Guide](DEPLOYMENT_GUIDE.md)

---

This repository is where I explore how intelligent systems reason about their own reasoning, especially in environments that are ambiguous, distributed, and consequential in the real world.

The core question is not how to produce more code or make a single agent smarter, but how collections of limited agents can:
- form beliefs under uncertainty,
- coordinate decisions without centralized control,
- and restrain themselves from acting when action would cause harm.

The software here is the concrete substrate for that inquiry. It implements a hierarchical, multi-agent orchestration engine (the "meta-orchestrator") to study emergent coordination, leverage, and restraint in practice.

The focus is less on task completion and more on how decisions are formed, revised, and governed over time. It is not a finished product or a production framework; it is a thinking space.

---

If you want to use the system to build an app, start here: [docs/GETTING_STARTED.md](docs/GETTING_STARTED.md).

---

## What this repository contains

- The engine itself in `.brain/` and root directories (principles, wisdom, patterns, templates).
- Documentation on how the engine thinks and operates.
- A minimal entry point (`app_intent.md`) for describing the app you want it to build.

### Quick orientation

```
meta-metacognition/
|- .brain/            # Engine brain (playbooks, roles, wisdom, principles)
|- patterns/          # Antipatterns and success patterns
|- templates/         # Templates for generated artifacts
|- app_intent.md      # You edit this to describe the app you want
|- meta_config.json   # Optional behavior flags
|- docs/              # Guides and deeper explanations
`- README.md          # This file
```

---

## System-of-Systems Coordination

The engine can coordinate **multiple repos** as a system-of-systems. A single **system repo** provides:
- the repo dependency graph,
- compatibility contracts,
- and cross-repo validation.

Coordination scales by need (KISS):
- `standalone` → no cross-repo coordination
- `federated` → contracts + compatibility tests
- `tracked` → light ledger + repo graph
- `governed` → full request ledger + cross-repo validation

For system repos, the engine defaults to `tracked` unless you choose otherwise.

---

## Sources of Truth

- `app_intent.md` → app intent
- `essence.md` → essence + success metrics
- `APP_ORCHESTRATION.md` → orchestration decisions
- `meta_config.json` → engine configuration

---

## Where to go next

- **Getting started**: [docs/GETTING_STARTED.md](docs/GETTING_STARTED.md)
- **Engine intent**: [.brain/context/intent.md](.brain/context/intent.md)
- **Orchestration logic**: [.brain/playbooks/build-from-intent.md](.brain/playbooks/build-from-intent.md)
- **Wisdom system**: [INTUITION.md](INTUITION.md)
- **Upgrade guide**: [UPGRADING.md](UPGRADING.md)
- **Testing philosophy**: [TESTING_STRATEGY.md](TESTING_STRATEGY.md)

---

## License

MIT License - See [LICENSE](LICENSE) file

---

## Questions?

- Issues: [Open a GitHub issue](https://github.com/pazhenchira/meta-metacognition/issues)
- Discussions: [GitHub Discussions](https://github.com/pazhenchira/meta-metacognition/discussions)

---

**Current Version**: 3.1.1 (February 27, 2026)
