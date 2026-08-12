# Global instructions

<!--
Symlinked from ~/dotfiles/agents/CLAUDE.md by scripts/setup-ai.sh.
Applies to every project on this machine, so keep it general — anything
repo-specific belongs in that repo's own CLAUDE.md.
HTML comments are stripped before this file is injected, so notes like this
one are free.
-->

## Working style

- Make one commit per logical change, and say what each one does and why before
  moving on. Don't batch unrelated changes into a single commit.
- Keep generated or vendored content in its own commit, separate from hand edits,
  so both stay reviewable.
- Don't push, open PRs, or otherwise publish anything unless I ask.

## Code

- Automate setup rather than documenting it. A new tool belongs in the install
  script; a README instruction telling me to run something by hand is a last resort.
- Comments explain *why*, not *what* — especially non-obvious choices and
  deliberate omissions. "X is deliberately absent because Y" is worth a line.
- Shell scripts are idempotent and safe to re-run. Back up before overwriting
  anything I might have edited by hand.
- Match the surrounding code's style, naming, and comment density rather than
  importing conventions from elsewhere.
