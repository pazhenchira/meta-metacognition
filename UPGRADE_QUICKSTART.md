# Upgrade Quick Reference

Tell your app orchestrator:

```
Upgrade the meta-orchestrator engine to the latest version
```

**First time?** If `engine_source` isn't set yet:
```
Upgrade the engine from https://github.com/pazhenchira/meta-metacognition.git
```

**Manual fallback** (v4.x):
1. Copy `.brain/`, `patterns/`, `templates/`, `skills/`, `generators/` from engine repo
2. Copy `.github/agents/atlas.agent.md` and `.github/copilot-instructions.md`
3. Update `.brain/config.yaml` with your project details

**Nexus integration** (optional):
1. Ensure `essence.md`, `.brain/config.yaml`, and `.github/` exist in your project
2. Register in `nexus.config.yaml` (see `templates/nexus-registration.template.md`)

**Rollback**: `git reset --hard pre-upgrade-backup`

See **UPGRADING.md** for full details.
