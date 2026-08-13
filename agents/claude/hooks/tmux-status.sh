#!/usr/bin/env bash
#
# Flags the tmux window running this Claude session as waiting on you, so the
# window list can tell "blocked on a permission prompt" apart from "finished".
#
#   tmux-status.sh attn     # waiting on you
#   tmux-status.sh clear    # no longer waiting
#
# Only this one state needs a hook. Working vs. idle is already readable from
# the spinner glyph Claude Code writes into the tmux pane title, and dot/tmux.conf
# picks it up from there — see the @_cc_sym fragment.
#
# Wired up in agents/claude/settings.json.
set -u

# No tmux (plain terminal, IDE, CI) means nothing to flag. Not an error.
[ -n "${TMUX_PANE:-}" ] || exit 0

# -w sets the option on the *window* containing this pane, not the pane, so the
# flag survives splitting the window off to poke at files.
case "${1:-}" in
  attn)  tmux set -w -t "$TMUX_PANE" @claude_attn 1 ;;
  clear) tmux set -uw -t "$TMUX_PANE" @claude_attn ;;
  *)     echo "usage: $(basename "$0") attn|clear" >&2 ;;
esac 2>/dev/null

# Repaint now instead of waiting out status-interval.
tmux refresh-client -S 2>/dev/null

# Always succeed. A status symbol is not worth failing a hook over, and any
# non-zero exit gets logged as a hook error.
exit 0
