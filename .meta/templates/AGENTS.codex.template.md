# {APP_NAME} - App Orchestrator Instructions

This file provides instructions for OpenAI Codex CLI when working on this application.

---

## Application Context

**App Name**: {APP_NAME}

**Purpose**: (Read from `app_intent.md` for current application goals)

**Architecture**: Built using meta-orchestrator engine principles (KISS, LEGO, Thompson #5)

---

## Core Instructions

When working on this application:

1. **Read `app_intent.md` first** - Understand the current application requirements and goals
2. **Apply meta-orchestrator principles**:
   - KISS: Keep implementations simple and correct
   - LEGO: Single-responsibility components
   - Thompson #5: Do one thing well
3. **Reference engine logic**: See `.meta/AGENTS.md` for full meta-orchestrator workflow
4. **Follow app structure**:
   - Source code: `src/`
   - Tests: `tests/` (maintain >80% coverage)
   - Documentation: `README.md`, `internal-notes.md`
   - Configuration: Check `meta_config.json` if present

If `meta_config.json` specifies `preferred_runtime: "codex-cli-mcp"` and `enable_subagents: true`:
- Delegate per-role work to MCP sub-agents (essence, PM, architect, developer, tester, writer, ops)
- If MCP sub-agents are unavailable, fall back to role-switching in this session
- Ensure `codex_mcp_server.py` is available and run it before sub-agent delegation
- Ensure `.app/runtime/codex_mcp_servers.toml` is merged into `~/.codex/config.toml` before starting Codex
- Use the Codex MCP tools (one per role server) with role briefs in the prompt (no OpenAI Agents SDK)

If `meta_config.json` specifies `preferred_runtime: "codex-cli-parallel"` and `enable_subagents: true`:
- Spawn one `codex exec` session per role with the role brief
- Collect outputs and REVIEW NOTES, then merge in the main session

Documentation integrity:
- Update `app_intent.md` for any feature/behavior change
- Update `APP_VERSION` on every change (create if missing)
- Keep README + docs/user + docs/dev in sync

---

## Maintenance Mode

For app modifications (new features, bug fixes):

1. Read `app_intent.md` to understand what changed
2. Identify affected LEGOs (single-responsibility components)
3. Apply GEN+REVIEW cycle:
   - Generate updated code/tests/docs
   - Review for antipatterns (God Object, Golden Hammer, Magic Numbers)
   - Iterate until quality standards met
4. Update tests first (TDD when possible)
5. Validate all tests pass before considering done

---

## Upgrade Mode

For engine upgrades (new `.meta/` folder version):

1. Check `.meta/VERSION` for new engine version
2. Read `UPGRADING.md` in meta-orchestrator repo for migration guide
3. Follow UPGRADE mode workflow from `.meta/AGENTS.md`
4. Regenerate `AGENTS.md` (this file) if template updated

---

## Key Principles

- **Wisdom-Driven**: Apply engineering wisdom from `.meta/wisdom/` (Thompson, Knuth, Pike, Kernighan)
- **Antipattern Detection**: Avoid God Objects, Golden Hammers, Magic Numbers
- **Quality Metrics**: >80% test coverage, clear documentation, single-responsibility design
- **User Value**: Always validate app delivers its essence (what makes it valuable)

---

## References

- **App Intent**: `app_intent.md` ← What the app should do
- **Engine Logic**: `.meta/AGENTS.md` ← How meta-orchestrator builds apps
- **Principles**: `.meta/principles.md` ← KISS, LEGO, GEN+REVIEW
- **Wisdom**: `.meta/wisdom/` ← Engineering best practices
- **Patterns**: `.meta/patterns/` ← Antipatterns and success patterns

---

**Remember**: This app was built by meta-orchestrator. Respect its architecture and principles when making changes.
