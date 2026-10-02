---
# vendored-from: mattpocock/skills
# vendored-path: skills/engineering/grill-with-docs + skills/productivity/grilling
# vendored-sha:  84fdeffd12f2ee307994d1eb6feb48173b6e0502
# vendored-on:   2026-08-12
# local-edits:   askuserquestion, renamed from grill-with-docs, grilling folded in
# TODO: rewrite description in my own words
name: grill
description: A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go.
# TODO: decide whether grill earns a model-facing description
disable-model-invocation: true
---

<!--
TODO: rewrite every line below in my own words - it is all still mattpocock's.
`grilling` was its own skill until c210a8d deleted it; this is that text folded
in so one skill carries the whole method. Section order here is the rewrite's
outline, so keep the headings even as the prose changes.
-->

<!-- TODO: rewrite - the tree -->
Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

<!-- TODO: rewrite - rounds and the frontier -->
Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

<!-- TODO: rewrite - the AskUserQuestion spec. This is my own addition, not vendored, and stays inline here rather than in its own file. -->
Put the questions to the user with the **AskUserQuestion** tool, so each one renders as a set of selectable options rather than prose they have to answer by hand. Give every question a short `header`, put your recommended answer first in the options list and label it `(Recommended)`, and write a `description` for each option saying what choosing it actually commits them to. Don't add an "other" option — the tool already offers a free-text escape.

The tool takes at most 4 questions per call, with 2–4 options each. A frontier wider than that goes out as consecutive calls inside the same round; never shrink the frontier to fit the tool.

<!-- TODO: rewrite - the prose fallback -->
Fall back to this prose format only for a question whose answers can't be enumerated as options:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

<!-- TODO: rewrite - recomputing the frontier -->
Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

<!-- TODO: rewrite - facts are mine to find, decisions are the user's -->
Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it — don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report — ask the rest of the frontier now. The _decisions_ are the user's — put each to them and wait.

<!-- TODO: rewrite - the done condition -->
The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.

<!--
TODO: rewrite, and decide where this belongs once the method is mine - the docs
half of the old grill-with-docs. domain-modeling stays its own skill rather than
being absorbed here, so this is the seam between the two.
-->
Use the `/domain-modeling` skill throughout, so the glossary and the ADRs get written as the session settles them.
