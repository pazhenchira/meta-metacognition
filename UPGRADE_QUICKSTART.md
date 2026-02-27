# Upgrade Quick Reference

Tell your app orchestrator:

```
Upgrade the meta-orchestrator engine to the latest version
```

**First time?** If `engine_source` isn't set yet:
```
Upgrade the engine from https://github.com/pazhenchira/meta-metacognition.git
```

**Manual fallback**: `cp -r /path/to/meta-metacognition/.meta ./`

**Rollback**: `git reset --hard pre-upgrade-backup`

See **UPGRADING.md** for full details.
