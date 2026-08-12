#!/usr/bin/env bash
#
# Vendors mattpocock/skills' shipped skills flat into agents/skills/ so they can
# be edited in place. Each SKILL.md gets a provenance stamp recording where it
# came from, so a re-sync can tell upstream changes from local edits.
#
#   scripts/vendor-skills.sh          # vendor the pinned commit
#   scripts/vendor-skills.sh <sha>    # vendor a specific commit
#
# See agents/README.md for the re-sync procedure.
#
set -euo pipefail

UPSTREAM_REPO="mattpocock/skills"
PINNED_SHA="84fdeffd12f2ee307994d1eb6feb48173b6e0502"

SHA="${1:-$PINNED_SHA}"
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
jq -r '.skills[] | ltrimstr("./")' "$MANIFEST" > "$WORK/rels"
echo "upstream ships $(wc -l < "$WORK/rels" | tr -d ' ') skills at ${SHA:0:7}"

# Flattening is only safe while basenames are unique. Fail loudly rather than
# silently overwrite if upstream ever adds engineering/foo next to
# productivity/foo.
DUPES="$(while read -r rel; do basename "$rel"; done < "$WORK/rels" | sort | uniq -d)"
if [ -n "$DUPES" ]; then
  echo "basename collision, cannot flatten: $DUPES" >&2
  exit 1
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
done < "$WORK/rels"

echo "...done"
