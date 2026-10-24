# Dailo — App Plan

> A gamified, course-focused learning app built with Flutter.
> Duolingo-style mechanics, stripped of the noise.

## Concept

Dailo teaches any subject through **bite-sized daily lessons** organized into a
**skill tree**. It keeps the parts of gamified learning that build a habit and drops
the parts that get in the way.

**Keep:** short lessons · streaks · XP · levels · skill tree
**Remove:** social feed / leaderboards · energy (hearts/lives) · ads

The result: **unlimited, distraction-free, self-paced learning.** You can study as much
as you want, whenever you want. No lives to run out of, no ads to sit through, no social
pressure — just you and the course.

The name **Dailo** plays on *daily* — the core habit the app is built around.

## Core Mechanics

| Mechanic | Role | Notes |
|----------|------|-------|
| **Lesson** | Smallest learning unit | 3–7 minutes, a handful of exercises |
| **Skill** | A node in the skill tree | Groups related lessons; unlocks the next skill |
| **Unit** | A themed section of the tree | Several skills that build on each other |
| **Course** | A full subject | A tree of units (e.g. "Programming Language") |
| **XP** | Progress currency | Earned per lesson/exercise; drives levels |
| **Level** | Learner advancement | Derived from cumulative XP |
| **Streak** | Daily-habit counter | Increments on any day the learner completes a lesson |

### What's deliberately absent
- **No energy/hearts** — mistakes don't cost "lives"; learners get instant feedback and
  move on. Wrong answers can recycle within the lesson instead of ending it.
- **No social** — no friends, leaderboards, or feeds. Progress is personal.
- **No ads** — no interstitials, no banners.

### Progression rules (draft)
- A skill unlocks when the prerequisite skill(s) reach a completion threshold.
- A lesson awards a base XP amount; a small bonus for a perfect (no-mistake) run.
- Streak increments once per calendar day on first completed lesson; resets if a day is missed.
  (A grace/streak-freeze mechanic is a possible later addition — not in v1.)
- Levels are thresholds on cumulative XP (curve TBD in design).

## Architecture (high level)

```
dailo/
  plan.md                         # this file
  courses/                        # course content (data, not code)
    programming-language/         # first course — see its curriculum.md
  (app source to be scaffolded)   # Flutter project — added when we move to build
```

### Separation of concerns
- **Content** (`courses/`) is data: units, skills, lessons, and exercises described
  declaratively (JSON/YAML or Dart data files). Authoring a course should not require
  touching app code.
- **Core app** renders that content and owns the mechanics: XP, streak, level, skill-tree
  state, lesson player, and local persistence.

### Proposed app structure (for the build phase — not created yet)
```
lib/
  core/            # theme, routing, constants, utilities
  gamification/    # XP, streak, level, skill-tree progression logic
  models/          # Course, Unit, Skill, Lesson, Exercise
  content/         # loaders that read courses/ into models
  features/
    home/          # skill-tree view
    lesson/        # lesson player (exercise runner)
    progress/      # XP / level / streak dashboard
    profile/       # settings, course selection
  data/            # local persistence (progress, streak, XP)
```

### Tech choices (proposed — confirm before build)
- **Flutter** (stable channel)
- **State management:** Riverpod (less boilerplate, good fit for this scope)
- **Local persistence:** lightweight local store for progress/streak/XP
  (e.g. shared_preferences for simple values, or a small embedded DB if content grows)
- **No backend in v1** — fully offline, content bundled with the app

> Package versions will be pinned to exact versions at scaffold time.

## Scope

### v1 (first milestone)
- One course: **Programming Language**
- Skill tree with units → skills → lessons
- Lesson player with a few exercise types
- XP, levels, streak, local persistence
- Offline-only, no accounts

### Explicitly out of scope for v1
- Multiple courses / course marketplace
- Accounts, cloud sync, backend
- Social features, energy, ads (permanently out — core product decision)
- Streak freeze / grace days (possible later)

## Open questions
1. **Pronunciation & branding** — "DAY-lo" vs "DYE-lo"? Mascot direction?
2. **Trademark / App Store** — confirm "Dailo" is clear before heavy branding.
3. **Content format** — JSON vs YAML vs Dart for authoring courses?
4. **Level curve** — how much XP per level; linear or escalating?
5. **First course = Python (beginner)** — the app is Flutter; the course content teaches Python. See `courses/programming-language/curriculum.md`.
