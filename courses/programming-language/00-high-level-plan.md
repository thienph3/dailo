# Course: Learn to Program (Beginner) — High-Level Plan

> Dailo's first course. Teaches **how to program** — the problem-solving process — using
> Python as the vehicle. Grounded in `research-teaching-approach.md`.
>
> This is **Layer 1 of 3**: the blueprint. Layer 2 breaks each unit (`unit-breakdown.md`);
> Layer 3 authors every lesson (`lessons/`).

## The one thing this course is about

**Teach the learner to RECOGNIZE and FOLLOW good problem-solving — by walking them through a
huge number of problems, each guided step-by-step — not to memorize syntax.**

Honest framing (why this wording): Dailo grades fixed answers (tap/choose/order), so the
course cannot verify "the learner solved a brand-new problem unaided" — a tappable question
always reduces to *recognizing* the right pre-built answer. So the goal is not "solve from a
blank page." The goal is **exposure + guided repetition at scale**: the learner meets *many*
varied problems and is led through the UEPCC process on each, until the *process itself*
becomes second nature. Value comes from **volume and guided practice**, not from one unaided
"final exam" the engine can't actually grade.

A graduate can look at a problem, recognize its shape, know which steps the process demands,
pick the right technique from ones they've practiced, and follow a plan to a correct solution —
because they've been guided through that exact rhythm hundreds of times. Syntax is taught *in
service of* that — never as the point. (See research doc: CS50, PCDIT, Code.org consensus.)

**Design consequence:** the course needs *more and more problems*, not a harder final test.
Breadth of guided problems is the product. Authoring prioritizes problem variety and
step-by-step guidance over clever one-off challenges.

## The process we teach: UEPCC

Every problem in the course is attacked with one **named, repeatable process** — a
beginner-friendly blend of Pólya's *How to Solve It* and the PCDIT framework. The learner
internalizes these five steps and applies them to every problem, easy to hard:

| Step | Name | Question the learner answers | Pillar |
|------|------|------------------------------|--------|
| **U** | Understand | What are the **inputs** and **outputs**? What's the goal? | — |
| **E** | Examples | What's a concrete input → output? What's a tricky/edge case? | — |
| **P** | Plan | What are the **steps** from input to output? (plain English / pseudocode) | Decomposition, Algorithm design |
| **C** | Code | How do I write each step in Python? | (syntax, just-in-time) |
| **C** | Check | Do my examples from step E actually pass? | Testing |

**The pedagogy, in one line:** lead with U-E-P (no code), introduce syntax only at the
second C, and always close with Check. Syntax is the *fourth* thing a learner does, not the
first.

### The four pillars (taught explicitly, by name)
Recurring skills surfaced throughout: **Decomposition** · **Pattern Recognition** ·
**Abstraction** · **Algorithm Design**. Lessons name them when they're used, so the learner
builds a vocabulary for thinking.

## Structure: a SPIRAL of many small circles (not big blocks)

The old design front-loaded ~12 code-free "thinking" units, then big syntax blocks. For a
casual, gamified, primary-level audience that is too long to wait before *doing* something —
the learner needs to feel progress early and often.

So the course is a **spiral**: many small **circles**, each circle repeating the same rhythm,
each circle slightly deeper than the last. Thinking skills (U-E-P-Check, decomposition,
pattern recognition) are **not a front block** — they are **re-taught in every circle**, a
little deeper each time. The learner sees real code output within the first circle.

### The rhythm of one circle (≈ a handful of units)

```
①  Meet a new kind of problem        (thinking: understand + example)   ← short
②  A tool to solve it, see it run    (code: syntax just-in-time, visible output)
③  Solve several similar problems    (guided UEPCC, lots of variety)    ← the bulk
④  Consolidate & interleave          (review: mix with earlier circles)
```

Then the next circle repeats ①–④ with a harder *kind of problem*. Every circle:
- starts with a little thinking, **not** 120 exercises of it;
- shows runnable, visible output early so the learner feels they "did programming";
- spends most of its weight on step ③ — *many guided problems* (the product's core value);
- loops earlier circles back in at step ④ (spaced repetition).

### The difficulty spiral (what deepens each lap)

```
lap 1   one step, shown on screen        (print a thing)
lap 2   remember & compute               (variables, math)
lap 3   a choice                         (conditions)
lap 4   a repeat                         (loops)
lap 5   a repeat with memory             (collections, accumulate/track)
lap 6   split into parts                 (decomposition, functions)
lap 7+  combine & vary endlessly         (more and more problems)
```

Difficulty rises with **problem complexity**, never with syntax exotica. Syntax appears the
first moment a problem needs it, framed as "the tool that implements this planning step."
Because the thinking is spiralled, the *same* pillar (e.g. decomposition) is taught at lap 1
as "2 tiny steps" and by lap 6 as "split into helper functions" — same skill, deeper dose.

## How we grade *thinking*, not just answers (fits static grading)

Dailo v1 grades fixed answers (no free-form code execution). The design challenge from the
research — "teach how to solve, not the answer" — is met by exercise **patterns that force
the learner through the reasoning steps**, not just the final line of code:

| Pattern | Teaches | Core type(s) |
|---------|---------|--------------|
| **Identify I/O** | Understand step | `multipleChoice`, `matchPairs` |
| **Work a case by hand** | Examples step — predict output for a given input | `multipleChoice`, `fillBlank` |
| **Order the plan** | Decomposition — arrange *plain-English* steps in order | `orderBlocks` |
| **Pick the next step** | Algorithm design — "what should we do first/next?" | `multipleChoice` |
| **Match problem → technique** | Pattern recognition — "counting things → loop + counter" | `matchPairs` |
| **Plan → code mapping** | Map one planned step to its Python line | `matchPairs`, `tapTokens` |
| **Spot the flaw** | Debugging the *approach*, not a typo — "why is this plan wrong?" | `multipleChoice` |
| **Assemble the solution** | Build/arrange the final code once the plan is clear | `orderBlocks`, `tapTokens` |
| **Trace & check** | Testing — "does this pass the example from step E?" | `multipleChoice`, `trueFalse` |

Rule of thumb for every lesson: **at least half the exercises are about the thinking
(U-E-P-Check), not the syntax (C).** A lesson that is all `tapTokens` has regressed to a
syntax drill.

## Vehicle language

**Python** — minimal syntax keeps the Code step from stealing attention from the thinking.
The *problems and process are language-agnostic*; only the Code step is Python-specific. A
future course could reuse the entire structure with a different language's Code step.

## Length & retention: long is fine, because progress is saved

The course is **100+ units and will keep growing** — more guided problems is the goal, so the
spiral never has a hard cap. We do **not** shorten the course to fight drop-off.

Instead, drop-off is handled by the **app**, not the curriculum:
- **Save-and-resume is a hard product requirement.** The learner may stop any time and the app
  remembers exactly which unit/lesson they left at and resumes there. (This belongs in the
  core engine's persistence — see `../../dailo-core.md` and `../../plan.md`.)
- A long course is a **library to progress through at your own pace**, not a gauntlet. Each
  circle is a self-contained win, so stopping after any circle still leaves the learner more
  capable than before — and a clear "continue" path back in.
- Because every circle re-teaches the thinking pillars, a learner returning after a break is
  re-grounded automatically; they don't fall off a cliff for having forgotten.

## Every unit is defined by FOUR things (title, in, out — plus scope)

Until now a unit was described by three things: **title**, **In** (what the learner knows
entering), **Out** (what they can do leaving). That left a gap: *which syntax a lesson may use*
was only implied. That gap caused real bugs — content reached ahead and taught tools from
future units. So every unit now declares **two more required fields**:

| Field | Meaning | Why it exists |
|-------|---------|---------------|
| **title** | the kind of problem / thinking move | identity (never a syntax keyword) |
| **in** | what the learner can already do entering | chains from the previous unit's `out` |
| **out** | what they can solve leaving | the unit's goal |
| **allows** *(new)* | the syntax/concepts a lesson in this unit MAY use — everything introduced by this unit **or any earlier unit** (cumulative) | tells the author the full toolbox available |
| **excludes** *(new)* | the not-yet-introduced tools a lesson MUST NOT use — a curated **trap list** of the near-future constructs most likely to leak in | tells the author exactly what to avoid |

### The rule
- **`allows` is cumulative.** A unit inherits everything taught before it, plus what it adds.
  Authors may use anything in `allows`.
- **`excludes` is the near-future trap list.** It names the handful of constructs a sub-agent
  is most tempted to reach for too early (e.g. in an early arithmetic unit: parentheses for
  grouping, `%`, `//`, `input()`, `if`, `for`). If a tool is in `excludes`, a lesson must not
  use it — full stop, no "gentle preview."
- **No reaching ahead.** A "peek" at a future concept is a scope violation, not a bonus. If the
  learner needs a tool, it belongs in the unit that introduces it — not sprinkled early.
- **Source of truth.** Each unit's `allows`/`excludes` is derived from the roadmap's **Syntax
  Coverage Appendix** (`01-unit-roadmap.md`), which already records where each construct is
  first introduced. The appendix stays the master list; per-unit `allows`/`excludes` is its
  machine-usable projection.

### How it's used
- **Authoring:** a sub-agent reads a unit's `allows` (its toolbox) and `excludes` (its
  landmines) and writes only in-scope lessons. This is what makes parallel authoring safe.
- **Enforcement:** the validator computes each unit's cumulative `allows` and fails any content
  file that uses a token in `excludes`. Scope becomes an automated gate, not a human catch.
- **Storage:** these fields live on each unit in `course.json` (scope is structural — it sits
  with the unit it governs).

## Scope: beginner only

**In:** the UEPCC process; the four pillars; sequencing, conditions, loops, lists, and simple
functions — each introduced *because a problem needs it*; an ever-growing set of guided
problems spiralling from one step to multi-part.

**Out (future Intermediate course):** dictionaries & nested data, OOP/classes, files, modules,
comprehensions, recursion, error handling, efficiency/Big-O.

## Deliverable layers
1. **This file** — high-level plan (goal, UEPCC, spiral model, grading patterns).
2. **`01-unit-roadmap.md`** — the spiral laid out as 100+ units (circles), each with In/Out.
3. **`lessons/`** — authored lessons + exercises per unit (10 lessons × 10 questions).

## Locked decisions
1. **Goal** — recognize + follow good problem-solving via *many guided problems*; not an
   unaided final exam (the static-grading engine can't grade that). Breadth is the product.
2. **Length** — 100+ units, growing; never shortened. Drop-off handled by **save-and-resume**
   in the app, not by cutting content.
3. **Shape** — a **spiral of small circles** (meet problem → tool+run → many guided problems →
   consolidate), each lap deeper. Thinking pillars re-taught every circle, not front-loaded.

## Still open
- **UEPCC naming/mascot** — teach the 5 steps as "Dailo's steps" with a mascot guiding each
  problem? (branding call, doesn't block authoring)
- **Capstone wording** — late units are "harder guided problems," not "solve unaided." Confirm
  that framing when we reach them.
