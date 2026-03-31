# Upgrade Quick Reference

## For project orchestrators: "Upgrade to v4.1.0 (nexus-ready)"

Tell your project's orchestrator:

```
Upgrade this project to meta-metacognition engine v4.1.0. Follow the upgrade steps in 
C:\Dev\meta-metacognition\UPGRADING.md under "v4.0.0 → v4.1.0 Nexus-Ready". 
Key actions: create essence.md at project root if missing, verify .brain/config.yaml 
has orchestrator.name + project.name + project.version, create .brain/principles.md 
if missing, then register with nexus in nexus.config.yaml.
```

## Manual fallback (v4.x)

1. Create `essence.md` at project root (what this project is, who it serves, what makes it valuable)
2. Verify `.brain/config.yaml` has `orchestrator.name`, `project.name`, `project.version`
3. Create `.brain/principles.md` with core engineering principles
4. Copy latest `skills/` from engine repo if outdated
5. Register in `nexus.config.yaml` (see `templates/nexus-registration.template.md`)

## First-time engine connection

If `engine_source` isn't set in `.brain/config.yaml`:
```
Upgrade the engine from https://github.com/pazhenchira/meta-metacognition.git
```

## Rollback

```bash
git reset --hard pre-upgrade-backup
```

See **UPGRADING.md** for full step-by-step details.
