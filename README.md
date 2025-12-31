# Meta-Metacognition

**Version 2.0.32** | [Changelog](CHANGELOG.md) | [Deployment Guide](DEPLOYMENT_GUIDE.md)

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

- The engine itself in `.meta/` (principles, wisdom, patterns, templates).
- Documentation on how the engine thinks and operates.
- A minimal entry point (`app_intent.md`) for describing the app you want it to build.

### Quick orientation

```
meta-metacognition/
|- .meta/             # Engine (edit only when improving the engine)
|- app_intent.md      # You edit this to describe the app you want
|- meta_config.json   # Optional behavior flags
|- docs/              # Guides and deeper explanations
`- README.md          # This file
```

---

## Where to go next

- **Getting started**: [docs/GETTING_STARTED.md](docs/GETTING_STARTED.md)
- **Engine intent**: [.meta/intent.md](.meta/intent.md)
- **Orchestration logic**: [.meta/AGENTS.md](.meta/AGENTS.md)
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

**Current Version**: 2.0.32 (December 29, 2025)
