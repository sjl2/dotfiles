# Global instructions

<!--
Symlinked from ~/dotfiles/agents/AGENTS.md by scripts/setup-ai.sh.
Applies to every project on this machine, so keep it general — anything
repo-specific belongs in that repo's own AGENTS.md.
HTML comments are stripped before this file is injected, so notes like this
one are free.
-->

## Working style

- Make one commit per logical change, and say what each one does and why before
  moving on. Don't batch unrelated changes into a single commit.
- Commit by explicit path, in one command — `git commit <the files you changed> -m …`.
  `git add -A` and `git commit -a` are off the table, and so is leaving files sitting
  staged between calls: parallel sessions share the working tree, so a blanket stage
  sweeps their work into your commit, and anything left in the index rides along on
  theirs.
- Keep generated or vendored content in its own commit, separate from hand edits,
  so both stay reviewable.
- Don't push, open PRs, or otherwise publish anything unless I ask.

<!--
TODO: write the rule - agents don't author or edit the prose of AGENTS.md or a
SKILL.md; they only insert my wording.
Replace this comment with a bullet to make it live. HTML comments are stripped
before injection, so while it sits here the agent never sees it.
-->

## Code

- Automate setup rather than documenting it. A new tool belongs in the install
  script; a README instruction telling me to run something by hand is a last resort.
- Comments explain *why*, not *what* — especially non-obvious choices and
  deliberate omissions. "X is deliberately absent because Y" is worth a line.
- Shell scripts are idempotent and safe to re-run. Back up before overwriting
  anything I might have edited by hand.
- Match the surrounding code's style, naming, and comment density rather than
  importing conventions from elsewhere.
- Use the Edit tool for editing files unless there's a performance reason for
  using a script.

## Replies

- Open with the action — the command, path, or diff first, context after. End
  when the answer ends. Preamble ("Let me…", "Great question") and closers
  ("Hope that helps", "Let me know if…") are the two habits to drop.
- Number multi-step work, one bounded action per step, and restate where we are
  ("step 3 of 5 done, next is the backfill") instead of expecting me to hold it.
- Finish the thing in front of you before raising the next one. A second issue
  gets one line at the end: what it is, and an offer to take it next.
- Estimate in concrete units — "15 minutes", "an afternoon" — or say you can't.
- Report errors flat: location, cause, fix.
- Show about five items at a time, most relevant first. That bounds what you
  display, not what you consider — say when you're holding more back.
- Length follows the ask. "Explain", "walk me through", and "what are my
  options" all want the whole answer; brevity never eats the answer itself.

## Suggestions and reviews

- Label every suggestion, finding, or option, at the head of its own line and
  ahead of the detail, so I can reply "do B and D". Pick the scheme that fits —
  nesting them (`A1`, `A2b`) when the items group is welcome.
- Labels hold for the rest of the conversation. Something found later takes the
  next unused label; nothing gets renumbered.
