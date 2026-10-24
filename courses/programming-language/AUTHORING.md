# Authoring Contract — Dailo "Learn to Program" Lessons

> **Read this before authoring any lesson.** It is the single source of truth for *how* to write
> content so it is consistent, in-scope, and passes the validator. One lesson = one file =
> one sub-agent task. Do not edit `course.json` or `config.json` — structure and policy are
> owned by the lead.

## Your inputs (given per task)
- **Unit id + title**, its **beat** (`MEET`/`TOOL`/`PRACTICE`/`LOOP`), and its **In/Out** goals.
- The **lesson id + title + idea** you must author (10 exercises).
- Your unit's **scope** from `scope.json` → `units.<unitId>`:
  - **`allows`** — the cumulative toolbox you MAY use (everything introduced by this unit or
    any earlier one).
  - **`excludes`** — everything NOT yet introduced. You MUST NOT use any of it, not even as a
    "gentle preview." If a tool is in `excludes`, treat it as if it does not exist yet.
  - Scope is a **rule you follow**, not an automated gate — the validator cannot catch scope
    leaks (prose and code share too many tokens), so staying in scope is *your* responsibility.
    Reaching ahead is the most common authoring bug; check `excludes` before using any syntax.

## Hard rules (the validator enforces these — see "Validate" below)
1. **Exactly 10 exercises** per lesson.
2. **Unique ids**: lesson `uNNlMM`, exercise `uNNlMMeKK` (zero-padded, e.g. `u11l06e03`).
3. **Every exercise** has `id`, `type`, `prompt`, `explanation`.
4. **`type`** is one of the 7 in `config.json`; payload matches that type (see Schema).
5. **Answer in range**: `multipleChoice` answer is a valid index; `multiSelect` all valid;
   `orderBlocks` answer is a permutation of its blocks.
6. **In scope**: use only syntax introduced by this unit or earlier. When in doubt, don't.
7. **`unitId` / `lessonId`** inside the file match what `course.json` expects.

## Beat rules (what the lesson must feel like)
- **`MEET`** — thinking only, little/no code. Identify inputs/outputs, order a plain-English
  plan, spot a flawed approach. If it compiles, it's probably mis-beat.
- **`TOOL`** — introduce exactly one construct, shown with **visible output** the learner can
  predict. Still keep ≥ half the exercises about thinking (predict/choose/spot), not typing.
- **`PRACTICE`** — the core. Each lesson is **one small problem (or two) walked through UEPCC**.
  Tag every exercise with a `uepcc` field: `U`, `E`, `P`, `C`, or `Check`. **All five steps must
  appear in the unit, and ≥ 50% of exercises must be thinking (U/E/P/Check), not Code.** A
  PRACTICE lesson that is mostly `tapTokens`/`fillBlank` of syntax has failed — it's a drill.
- **`LOOP`** — no new concept. Interleave this lap + earlier laps (spaced repetition).

## The UEPCC spine (for PRACTICE especially)
Walk the learner through solving, never hand them the answer:
| Step | `uepcc` | The exercise asks… |
|------|---------|--------------------|
| Understand | `U` | What are the inputs / output / goal? |
| Examples | `E` | Work one concrete input→output **by hand**, before code. This becomes the check value. |
| Plan | `P` | What are the ordered steps? Which operation/tool? (decomposition, pattern choice) |
| Code | `C` | Write/arrange the code for a planned step. |
| Check | `Check` | Does the output match the hand example? Re-run with new inputs. |

Good PRACTICE habits: start by naming inputs/output; hand-work the example first; make the
*plan* choose the operation; show a wrong-approach ("why is this answer wrong?") at least
sometimes; always re-check with fresh numbers to prove the solution generalizes.

**Value-mapping rule (PRACTICE):** every number stated in the problem must appear in the code
as a **named variable** — do not hardcode or silently drop a value. If the problem says "2 meals
and 3 drinks," the code has `meal_count`, `meal_price`, `drink_count`, `drink_price` — all four.
Hardcoding one (`total = meals_cost + 5`) or dropping a count (treating "3 drinks" as one drink)
teaches a sloppy habit and makes the lesson self-contradict when you re-check with new numbers.

**Naming rule:** use **descriptive variable names that echo the problem** — `ticket_price`,
`meal_count`, `bill`, `change` — not bare generic names like `p`, `c`, or an ambiguous `price`
/`count` when the problem has more than one priced thing. Names should make the code read like
the plan. Keep naming consistent *within a unit* (don't mix `count` in one lesson and
`pen_count` in the next). Result variables like `total` / `area` / `average` are fine as-is.

**Numbers-before-strings rule (Units 1–14):** until **Unit 15** introduces strings, a VARIABLE
must only ever hold a **number**. Do NOT assign a quoted string to a variable
(`name = "Ada"`, `light = "red"`, `door = "open"` are all WRONG before Unit 15). Illustrate
every idea with numbers instead (`score = 7`, `level = 1`, `battery = 100`, `floor = 3`).
Printing a text *label* is still fine — `print("Hello")` is Unit-1 `print` — the rule is only
about what a *variable* is assigned. This was a real, repeated leak: reassignment and tracking
examples are tempting to write with words, but words are out of scope until Unit 15.

**No-builtin-shortcuts rule (whole course):** this course teaches learners to COMPUTE things
themselves with loops — a running total (`total = 0; for x in nums: total = total + x`), the
biggest (`best = nums[0]; for x in nums: if x > best: best = x`), a count, a filter. Do NOT use
the Python builtins `sum()`, `max()`, `min()`, or `sorted()` in code — they are never taught
and using them defeats the accumulate/track/filter patterns that are the whole point.
(`len()` IS allowed — introduced Unit 53 — for the SIZE of a list, not for summing.) It is fine
to NAME a pattern in prose/options as "sum (a running total)" or "max (track the biggest)" —
that is the pattern's name, not a function call. The rule bans the *function call* in code.

## Overlap rule (spaced repetition)
~**70% new** material for this unit, ~**30% review** of earlier units. `LOOP` lessons and the
last lesson of a unit lean review-heavy. Reviewing earlier laps (e.g. recalling `print` or
variables inside a later unit) is encouraged and expected.

## Tone (absolute beginner)
- Warm, plain language. Short sentences. No jargon without immediately explaining it.
- Celebrate small wins ("You just wrote real code!"). Never condescending.
- Explanations teach the *why*, not just confirm the answer. One or two sentences.
- Prefer everyday problem framings (shopping, scores, splitting a bill) over abstract math.

## Schema (one lesson file)
```json
{
  "unitId": "u11",
  "lessonId": "u11l01",
  "title": "…",
  "idea": "one line: the single small thing this lesson teaches",
  "problem": "(PRACTICE only) the word problem this lesson solves",
  "exercises": [ { …exercise… }, … 10 total … ]
}
```

### Exercise shapes by `type`
```json
// multipleChoice — one correct option
{ "id":"…","type":"multipleChoice","uepcc":"P","prompt":"…",
  "options":["a","b","c","d"],"answer":0,"explanation":"…" }

// multiSelect — all correct options
{ "id":"…","type":"multiSelect","prompt":"…",
  "options":["…"],"answer":[0,2],"explanation":"…" }

// trueFalse
{ "id":"…","type":"trueFalse","prompt":"…","answer":true,"explanation":"…" }

// fillBlank — typed answer; list acceptable variants
{ "id":"…","type":"fillBlank","prompt":"… ____ …",
  "answer":"+","acceptable":["+"],"explanation":"…" }

// orderBlocks — answer is a permutation of blocks' indices
{ "id":"…","type":"orderBlocks","prompt":"…",
  "blocks":["first","second","third"],"answer":[0,1,2],"explanation":"…" }

// matchPairs — engine shuffles; pairs carry the truth
{ "id":"…","type":"matchPairs","prompt":"…",
  "pairs":[{"left":"…","right":"…"}],"explanation":"…" }

// tapTokens — answer is the tokens in order
{ "id":"…","type":"tapTokens","prompt":"…",
  "tokens":["print","(","\"Hi\"",")"],"answer":["print","(","\"Hi\"",")"],"explanation":"…" }
```
- `uepcc` is **required on every PRACTICE exercise**, optional elsewhere.
- Keep `multipleChoice` from dominating a PRACTICE lesson; vary types for engagement.

## Validate (you MUST run this before marking a lesson done)
From the course folder:
```
python3 validate.py
```
It checks every authored unit: 10×10, unique ids, required fields, type payloads, answer
ranges, id/unit matches, and for PRACTICE units: all 5 UEPCC steps present + thinking ≥ 50%.
Exit 0 = pass. **A lesson is not done until `validate.py` exits 0.** If it fails for the same
reason twice, stop and report the error rather than guessing.

## Reference examples (copy their shape)
- `content/unit-01/` — a full `TOOL` unit (visible output, spot-the-mistake lessons).
- `content/unit-11/` — a full `PRACTICE` unit (guided UEPCC, 74% thinking). This is the bar.
