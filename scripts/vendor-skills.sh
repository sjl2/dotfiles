#!/usr/bin/env bash
#
# Vendors skills from mattpocock/skills flat into agents/skills/ so they can be
# edited in place. Each SKILL.md gets a provenance stamp recording where it came
# from, so a re-sync can tell upstream changes from local edits.
#
# By default it refreshes only the skills already vendored here, so a re-sync
# never resurrects one that was deliberately pruned.
#
#   scripts/vendor-skills.sh                     # refresh what's already here
#   scripts/vendor-skills.sh --skill tdd         # add or refresh one (repeatable)
#   scripts/vendor-skills.sh --all               # everything upstream ships
#   scripts/vendor-skills.sh --sha <sha>         # pin to a commit
#
# See agents/README.md for the re-sync procedure.
#
set -euo pipefail

UPSTREAM_REPO="mattpocock/skills"
PINNED_SHA="84fdeffd12f2ee307994d1eb6feb48173b6e0502"

SHA="$PINNED_SHA"
MODE="curated"
SELECTED=""

while [ $# -gt 0 ]; do
  case "$1" in
    --all) MODE="all"; shift ;;
    --skill) MODE="selected"; SELECTED="$SELECTED $2"; shift 2 ;;
    --sha) SHA="$2"; shift 2 ;;
    -h|--help) sed -n '3,16p' "$0"; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
DEST="$DOTFILES_DIR/agents/skills"
TODAY="$(date -u +%F)"

command -v jq > /dev/null 2>&1 || { echo "jq is required (brew install jq)" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "Cloning $UPSTREAM_REPO..."
git clone --quiet --filter=blob:none "https://github.com/$UPSTREAM_REPO" "$WORK/src"
git -C "$WORK/src" checkout --quiet "$SHA"

# Drive off upstream's own plugin manifest rather than globbing the tree: the
# repo also contains in-progress/, misc/ and deprecated/ skills that upstream
# deliberately does not ship.
MANIFEST="$WORK/src/.claude-plugin/plugin.json"
[ -f "$MANIFEST" ] || { echo "no plugin.json at $SHA" >&2; exit 1; }
jq -r '.skills[] | ltrimstr("./")' "$MANIFEST" > "$WORK/shipped"
echo "upstream ships $(wc -l < "$WORK/shipped" | tr -d ' ') skills at ${SHA:0:7}"

# Flattening is only safe while basenames are unique. Fail loudly rather than
# silently overwrite if upstream ever adds engineering/foo next to
# productivity/foo.
DUPES="$(while read -r rel; do basename "$rel"; done < "$WORK/shipped" | sort | uniq -d)"
if [ -n "$DUPES" ]; then
  echo "basename collision, cannot flatten: $DUPES" >&2
  exit 1
fi

# Decide what to vendor. In curated mode that is whatever is already vendored
# here -- identified by the provenance stamp, so a skill of my own that happens
# to share a name with an upstream one is never clobbered.
: > "$WORK/want"
while read -r rel; do
  name="$(basename "$rel")"
  case "$MODE" in
    all)
      echo "$rel" >> "$WORK/want"
      ;;
    selected)
      case " $SELECTED " in *" $name "*) echo "$rel" >> "$WORK/want" ;; esac
      ;;
    curated)
      if [ -f "$DEST/$name/SKILL.md" ] && grep -q '^# vendored-from:' "$DEST/$name/SKILL.md"; then
        echo "$rel" >> "$WORK/want"
      fi
      ;;
  esac
done < "$WORK/shipped"

if [ "$MODE" = "selected" ]; then
  for name in $SELECTED; do
    grep -q "/$name\$" "$WORK/want" ||
      { echo "upstream does not ship a skill named '$name' at ${SHA:0:7}" >&2; exit 1; }
  done
fi

WANT_COUNT="$(wc -l < "$WORK/want" | tr -d ' ')"
[ "$WANT_COUNT" -gt 0 ] || { echo "nothing to vendor"; exit 0; }
echo "vendoring $WANT_COUNT"

# Vendoring overwrites the whole skill directory, so any local edit is reverted.
# That is the intended re-sync flow -- re-vendor, then re-apply -- but it has to
# be impossible to miss, since the edits are gone by the time you notice.
: > "$WORK/clobbered"
while read -r rel; do
  name="$(basename "$rel")"
  edits="$(sed -n 's/^# local-edits: *//p' "$DEST/$name/SKILL.md" 2> /dev/null || true)"
  case "$edits" in ''|none) ;; *) echo "  $name ($edits)" >> "$WORK/clobbered" ;; esac
done < "$WORK/want"

if [ -s "$WORK/clobbered" ]; then
  echo
  echo "  !! these carry local edits that are about to be reverted:"
  cat "$WORK/clobbered"
  echo "     Re-apply them afterwards, or 'git checkout agents/skills' to undo."
  echo
fi

mkdir -p "$DEST"
while read -r rel; do
  name="$(basename "$rel")"
  src="$WORK/src/$rel"

  [ -f "$src/SKILL.md" ] || { echo "no SKILL.md in $rel" >&2; exit 1; }
  # The stamp goes inside the frontmatter block. An HTML comment above the
  # opening --- would push the frontmatter off line 1, and Claude Code would
  # then parse none of it -- silently losing name, description, and
  # disable-model-invocation.
  [ "$(head -n 1 "$src/SKILL.md")" = "---" ] ||
    { echo "$rel/SKILL.md has no frontmatter on line 1" >&2; exit 1; }

  rm -rf "${DEST:?}/$name"
  cp -R "$src" "$DEST/$name"

  awk -v repo="$UPSTREAM_REPO" -v path="$rel" -v sha="$SHA" -v on="$TODAY" '
    NR == 1 {
      print
      print "# vendored-from: " repo
      print "# vendored-path: " path
      print "# vendored-sha:  " sha
      print "# vendored-on:   " on
      print "# local-edits:   none"
      next
    }
    { print }
  ' "$DEST/$name/SKILL.md" > "$DEST/$name/SKILL.md.tmp"
  mv "$DEST/$name/SKILL.md.tmp" "$DEST/$name/SKILL.md"

  echo "  $name <- $rel"
done < "$WORK/want"

# Say what was deliberately left behind, so a silent omission never reads as
# full coverage.
if [ "$MODE" != "all" ]; then
  while read -r rel; do
    name="$(basename "$rel")"
    grep -q "^$rel\$" "$WORK/want" || echo "  not tracked: $name"
  done < "$WORK/shipped"
fi

echo "...done"
