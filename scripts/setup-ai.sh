#!/usr/bin/env bash
#
# Links agents/ into the places Claude Code and other Agent Skills harnesses
# read from. Run by setup.sh, or on its own. Idempotent.
#
#   scripts/setup-ai.sh              # link it
#   scripts/setup-ai.sh --dry-run    # print what would change
#
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
AGENTS_DIR="$DOTFILES_DIR/agents"
OLD_DIR="$DOTFILES_DIR/old"
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) DRY_RUN=1 ;;
    -h|--help) sed -n '3,8p' "$0"; exit 0 ;;
    *) echo "unknown flag: $arg" >&2; exit 2 ;;
  esac
done

log() { printf '  %s\n' "$*"; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

# link SRC DEST [BACKUP_NAME]
#
#   already correct    -> no-op
#   wrong/broken link  -> replaced
#   real file or dir   -> copied to $OLD_DIR/$BACKUP_NAME, then replaced
#   real, no backup    -> refuse, so nothing is ever destroyed silently
#
# ln -sfn, not ln -sf: with -f alone, a destination that is a directory (or a
# symlink to one) gets the new link created *inside* it rather than replaced.
# -n makes ln treat a symlink-to-directory as a plain file so -f can clobber it.
link () {
  local src="$1" dest="$2" backup="${3:-}"

  if [ ! -e "$src" ]; then
    echo "  !! missing source: $src" >&2
    return 1
  fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    log "ok    $dest"
    return 0
  fi

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    if [ -z "$backup" ]; then
      echo "  !! $dest exists and is not a symlink; refusing to replace it" >&2
      echo "     move it aside yourself, then re-run" >&2
      return 1
    fi
    log "save  $dest -> $OLD_DIR/$backup"
    run mkdir -p "$(dirname "$OLD_DIR/$backup")"
    run cp -R "$dest" "$OLD_DIR/$backup"
    run rm -rf "$dest"
  fi

  run mkdir -p "$(dirname "$dest")"
  run ln -sfn "$src" "$dest"
  log "link  $dest -> $src"
}

# Refuse to link entries into a directory that is itself a symlink into this
# repo. Claude Code writes into ~/.claude/skills (claude plugin init, synced
# skills, anything you install by hand) and all of that would land in the git
# tree. Upstream's own link-skills.sh guards the same case.
assert_real_dir () {
  local dest="$1" resolved
  if [ -L "$dest" ]; then
    resolved="$(readlink "$dest")"
    case "$resolved" in
      "$DOTFILES_DIR"|"$DOTFILES_DIR"/*)
        echo "  !! $dest is a symlink into $DOTFILES_DIR ($resolved)." >&2
        echo "     Anything written there would land in the git repo." >&2
        echo "     Run: rm \"$dest\"   then re-run this script." >&2
        return 1
        ;;
    esac
  fi
  run mkdir -p "$dest"
}

# Remove symlinks under $1 that point into $2 but whose target is gone, so a
# skill renamed or dropped upstream doesn't leave a dangling link behind.
prune_stale () {
  local dest="$1" prefix="$2" entry target
  [ -d "$dest" ] || return 0
  for entry in "$dest"/*; do
    [ -L "$entry" ] || continue
    target="$(readlink "$entry")"
    case "$target" in
      "$prefix"/*)
        if [ ! -e "$target" ]; then
          log "prune $entry (dangling -> $target)"
          run rm -f "$entry"
        fi
        ;;
    esac
  done
}

# Link each skill directory individually rather than the whole skills/ dir, for
# the reason in assert_real_dir above.
link_skills_into () {
  local dest="$1" bucket="$2" skill_md src name
  assert_real_dir "$dest"

  if [ -d "$AGENTS_DIR/skills" ]; then
    while IFS= read -r skill_md; do
      src="$(dirname "$skill_md")"
      name="$(basename "$src")"
      link "$src" "$dest/$name" "$bucket/$name"
    done < <(find "$AGENTS_DIR/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | sort)
  fi

  prune_stale "$dest" "$AGENTS_DIR/skills"
}

link_commands_into () {
  local dest="$1" f
  assert_real_dir "$dest"
  for f in "$AGENTS_DIR"/claude/commands/*.md; do
    [ -e "$f" ] || continue
    link "$f" "$dest/$(basename "$f")" "claude-commands/$(basename "$f")"
  done
  prune_stale "$dest" "$AGENTS_DIR/claude/commands"
}

# The symlinks and the plugin are two install paths for the same skills, and
# they do not compose: plugin skills are namespaced, so you get both /foo and
# /sjl2:foo, each costing context every turn.
warn_if_plugin_installed () {
  command -v claude > /dev/null 2>&1 || return 0
  if claude plugin list 2> /dev/null | grep -q 'sjl2@sjl2-dotfiles'; then
    cat >&2 <<'EOF'
  !! WARNING: the sjl2@sjl2-dotfiles plugin is installed on this machine.
     Your skills will now appear twice: as /<name> (these symlinks) and as
     /sjl2:<name> (the plugin). Pick one path per machine:
       symlinks   -> claude plugin uninstall sjl2@sjl2-dotfiles
       the plugin -> don't run this script here
EOF
  fi
}

echo "Linking agent config from $AGENTS_DIR..."
[ "$DRY_RUN" -eq 1 ] && echo "  (dry run: nothing will change)"

if [ ! -d "$AGENTS_DIR" ]; then
  echo "  !! $AGENTS_DIR not found" >&2
  exit 1
fi
run mkdir -p "$OLD_DIR"

# Claude Code reads ~/.claude/CLAUDE.md, not ~/AGENTS.md. The second link is
# the cross-harness convention (Codex and friends), not a Claude Code path.
link "$AGENTS_DIR/CLAUDE.md"            "$HOME/.claude/CLAUDE.md"     "claude-CLAUDE.md"
link "$AGENTS_DIR/CLAUDE.md"            "$HOME/AGENTS.md"             "AGENTS.md"
link "$AGENTS_DIR/claude/settings.json" "$HOME/.claude/settings.json" "claude-settings.json"

# Linked one by one rather than as a directory, matching the skills/commands
# handling above. There is only the one hook so far; make this a loop if that
# changes.
link "$AGENTS_DIR/claude/hooks/tmux-status.sh" "$HOME/.claude/hooks/tmux-status.sh" "claude-hooks/tmux-status.sh"

link_commands_into "$HOME/.claude/commands"

# ~/.agents/skills is where non-Claude harnesses look. Claude Code loads a skill
# once even when the same target is reachable from two locations, so linking
# both costs nothing.
link_skills_into "$HOME/.claude/skills" "claude-skills"
link_skills_into "$HOME/.agents/skills" "agents-skills"

warn_if_plugin_installed
echo "...done"
