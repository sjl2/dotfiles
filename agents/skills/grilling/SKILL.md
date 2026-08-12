---
# vendored-from: mattpocock/skills
# vendored-path: skills/productivity/grilling
# vendored-sha:  84fdeffd12f2ee307994d1eb6feb48173b6e0502
# vendored-on:   2026-08-12
# local-edits:   askuserquestion
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Put the questions to the user with the **AskUserQuestion** tool, so each one renders as a set of selectable options rather than prose they have to answer by hand. Give every question a short `header`, put your recommended answer first in the options list and label it `(Recommended)`, and write a `description` for each option saying what choosing it actually commits them to. Don't add an "other" option — the tool already offers a free-text escape.

The tool takes at most 4 questions per call, with 2–4 options each. A frontier wider than that goes out as consecutive calls inside the same round; never shrink the frontier to fit the tool.

Fall back to this prose format only for a question whose answers can't be enumerated as options:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it — don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report — ask the rest of the frontier now. The _decisions_ are the user's — put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
