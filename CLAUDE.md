# dotfiles

<!--
Project-scoped instructions for this repo only. Not to be confused with
agents/CLAUDE.md, which is the *global* file symlinked to ~/.claude/CLAUDE.md and
applies to every project on this machine. Both are loaded here, and they
concatenate rather than override — so keep this file to things that are true of
this repo and nowhere else.
-->

## Agent skills

### Issue tracker

Issues live as markdown files under `.scratch/<feature>/`, which is gitignored.
See `docs/agents/issue-tracker.md`.

### Domain docs

Single-context: `CONTEXT.md` and `docs/adr/` at the repo root, both created lazily.
See `docs/agents/domain.md`.
