# Agent configuration

Claude Code configuration and skills, kept here so a new machine gets them without
hand-copying anything.

```
agents/
  CLAUDE.md            user-level instructions -> ~/.claude/CLAUDE.md and ~/AGENTS.md
  claude/
    settings.json      -> ~/.claude/settings.json
    commands/          flat .md commands, linked one by one
    subagents/         subagent definitions, published by the plugin only
  skills/
    <name>/SKILL.md    linked one by one into ~/.claude/skills and ~/.agents/skills
```

## Two ways to install, one per machine

| | Personal machine | Machine you can't clone into |
|---|---|---|
| How | `scripts/setup-ai.sh` (run by `setup.sh`) | the plugin |
| Gets | everything, including the vendored skills | only my own skills |
| Invoked as | `/tdd` | `/sjl2:tdd` |
| Updates | `git pull` — links are live | `/plugin marketplace update sjl2-dotfiles` |

```bash
# personal
./scripts/setup-ai.sh            # or --dry-run to see what would change

# anywhere else, no clone needed
/plugin marketplace add sjl2/dotfiles
/plugin install sjl2@sjl2-dotfiles
```

If GitHub shorthand fails on a locked-down machine it is cloning over SSH — either set
`CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` or use the full
`https://github.com/sjl2/dotfiles.git` URL. Third-party marketplaces do not auto-update
by default.

**Don't run both on the same machine.** Plugin skills are namespaced, so you would get
both `/tdd` and `/sjl2:tdd` — listed twice, and charged to context twice. `setup-ai.sh`
warns if it finds the plugin installed. To try the plugin without installing it:
`claude --plugin-dir ~/dotfiles`.

## What setup-ai.sh will and won't touch

Skills and commands are linked **entry by entry**, never as whole directories.
`~/.claude/skills` is a directory Claude Code writes into — `claude plugin init`
scaffolds there, skill sync writes there, and it is where you would install someone
else's skill by hand. Owning it with a directory symlink would drop all of that into
this git repo. The script refuses to run if that has already happened.

`~/.claude/plugins/` is machine state and is deliberately never linked.

Anything real that gets displaced is copied into `old/` first (gitignored).

`settings.json` is a live symlink, and Claude Code writes through it — so `/config`
changes land in this repo as a `git diff`. That also means machine-local plugin state
(`enabledPlugins`, `extraKnownMarketplaces`) can appear there. `git checkout
agents/claude/settings.json` when it is noise.

## Publishing to the plugin

`.claude-plugin/plugin.json` lists **only my own** skills, so nothing vendored gets
republished under my name. `skills` is currently empty because I haven't written one yet
— adding a skill means adding one line:

```json
"skills": ["./agents/skills/my-skill"]
```

Two manifest behaviors worth remembering:

- Because the marketplace entry's `source` is the marketplace root, declaring `skills`
  **replaces** the default `skills/` scan instead of adding to it. Never create a
  top-level `skills/` directory in this repo.
- `agents` is `[]` rather than absent. It replaces the default scan, and the default is
  `<plugin root>/agents/` — this directory. Left undeclared, Claude Code would try to
  parse `agents/CLAUDE.md` as a subagent. It accepts `.md` file paths only, not
  directories, so each subagent gets listed individually.

To release: bump `version` in `plugin.json`, push, then `/plugin marketplace update
sjl2-dotfiles` on the consuming machine. Check your work with `claude plugin validate
~/dotfiles --strict`.

## Vendored skills

`agents/skills/` holds all 25 skills [mattpocock/skills](https://github.com/mattpocock/skills)
ships (MIT). They are copied flat rather than submoduled so they can be edited in place.
Each `SKILL.md` carries the provenance in its frontmatter:

```yaml
# vendored-from: mattpocock/skills
# vendored-path: skills/engineering/tdd
# vendored-sha:  84fdeffd12f2ee307994d1eb6feb48173b6e0502
# vendored-on:   2026-08-12
# local-edits:   none
```

These are YAML comments *inside* the frontmatter block for a reason: an HTML comment
above the opening `---` would push the frontmatter off line 1, and Claude Code would then
parse none of it — silently losing `name`, `description`, and `disable-model-invocation`.

### Local edits

- `grilling`, `grill-me`, `grill-with-docs` — ask questions with the `AskUserQuestion`
  tool so they render as selectable options. The instruction lives in `grilling`; the
  other two are one-line delegations to it.

### Re-syncing with upstream

```bash
# what's upstream, and what am I on?
git ls-remote https://github.com/mattpocock/skills refs/heads/main
grep -h vendored-sha agents/skills/*/SKILL.md | sort -u

# where will the conflicts be?
grep -rn 'local-edits:' agents/skills/*/SKILL.md | grep -v ': *none'

# re-vendor onto a branch and review
git switch -c vendor-sync
./scripts/vendor-skills.sh <new-sha>
git diff agents/skills
```

The diff shows upstream's changes *and* the reversion of your local edits — re-apply
those from the list above, reset each `local-edits:` field, then merge. If the local
edits ever outgrow that, keep a pristine vendored tree on its own branch and re-vendor
onto that instead, so you get real three-way merges.
