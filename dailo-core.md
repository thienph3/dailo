# Dailo Core

> The engine. Course-agnostic mechanics and data model that every course plugs into.

Dailo Core is the reusable foundation. It knows nothing about *what* is being taught —
it only knows how to render a skill tree, run a lesson, grade exercises, and track
progress. Courses (under `courses/`) are pure content that the core consumes.

## Data Model

The content hierarchy, from largest to smallest:

```
Course
 └─ Unit            (a themed section of the tree)
     └─ Skill       (a node in the tree; the thing that unlocks)
         └─ Lesson  (one short sitting, 3–7 min)
             └─ Exercise  (a single question/interaction)
```

### Course
- `id`, `title`, `description`, `icon`
- ordered list of **Units**

### Unit
- `id`, `title`, `summary`
- ordered list of **Skills**

### Skill (skill-tree node)
- `id`, `title`, `icon`
- `prerequisites`: list of skill ids that must be completed first
- ordered list of **Lessons**
- derived state: `locked` / `available` / `in-progress` / `completed`

### Lesson
- `id`, `title`
- ordered list of **Exercises**
- `baseXp`: XP awarded on completion

### Exercise
- `id`, `type` (see exercise types below)
- `prompt`, type-specific payload, and the correct answer(s)
- `explanation` (shown after answering)

## Exercise Types (core-supported)

These are generic across subjects. A course picks which to use.

| Type | Interaction |
|------|-------------|
| `multipleChoice` | Pick one correct option from several |
| `multiSelect` | Pick all correct options |
| `trueFalse` | Binary choice |
| `fillBlank` | Type the missing token(s) |
| `orderBlocks` | Drag blocks into the correct order (great for code) |
| `matchPairs` | Match items in column A to column B |
| `tapTokens` | Build an answer by tapping tokens in order |

> `orderBlocks` and `tapTokens` are especially suited to a programming course
> (arranging lines of code, assembling a statement from tokens).

## Gamification Logic

### XP
- Each completed lesson awards `baseXp`.
- Perfect run (no wrong answers) awards a bonus (e.g. +50%).
- XP is cumulative and never decreases.

### Level
- Level is a function of cumulative XP.
- Curve is defined in one place so it can be tuned (linear vs escalating — TBD).

### Streak
- A single counter of consecutive calendar days with ≥1 completed lesson.
- Increments on the first lesson completed each day.
- Resets to 0 if a calendar day passes with no completed lesson.
- No energy, no penalty for wrong answers — the only "loss" is missing a day.

### Skill-tree progression
- A skill is `available` when all its `prerequisites` are `completed`.
- A skill is `completed` when all its lessons are completed (threshold rule TBD —
  could require all lessons, or a percentage).
- The home screen renders the tree with locked/available/completed states.

## Persistence (local, v1)

The core tracks per learner, on-device:
- cumulative XP and current level
- current streak + last-completed date
- per-skill and per-lesson completion state

No accounts, no cloud, no network in v1.

## Boundary: core vs content

| Core owns | Content (courses/) owns |
|-----------|--------------------------|
| Rendering the tree & lesson player | The actual units, skills, lessons |
| Grading exercises by `type` | The exercises, prompts, answers |
| XP / level / streak math | `baseXp` values, ordering, prerequisites |
| Persistence | Nothing — content is read-only data |

This boundary means adding a second course later (e.g. "Design Basics") is a
content-only task — no engine changes.
