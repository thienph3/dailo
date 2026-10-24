# How the Community Teaches Programming to Beginners — Research

> Research backing Dailo's course design. Captured 2026-10-22.
> Question: how do respected programs teach people to *program* (problem-solving),
> not just teach *syntax*?

## TL;DR — the consensus

The evidence is unusually consistent across decades of CS-education research and the most
respected intro courses: **teach problem-solving first, map it to syntax last.**

> "Students are encouraged to think about the abstract steps from inputs to outputs
> **before mapping anything down to syntax.**" — PCDIT framework paper

> "This course teaches you **how to solve problems, both with and without code**… Topics
> include computational thinking, abstraction, algorithms." — CS50 syllabus

A "syntax-first" approach — where novices write *anything* before analysing the problem —
is repeatedly named as the central failure mode. Our redesign must invert it.

## Source 1 — PCDIT Framework (arXiv 2109.08896)

*"Steps Before Syntax: Helping Novice Programmers Solve Problems"* — a non-linear,
scaffolded problem-solving process taught explicitly in a first-year course. Five phases:

| Phase | Meaning | What the learner does |
|-------|---------|-----------------------|
| **P** — Problem definition | Understand the problem | Identify **inputs** and **outputs**; restate the goal |
| **C** — Cases | Concrete examples **before any code** | Hand-work specific input→output examples, including edge cases |
| **D** — Design of algorithm | The plan | Write abstract steps / pseudocode from inputs to outputs |
| **I** — Implementation | Only now, code | Map the plan down to language syntax |
| **T** — Testing | Verify | Run the earlier concrete cases against the solution |

**Key insights for Dailo:**
- The **"C" phase is the differentiator**: work concrete input→output cases *by hand* before
  writing any code. This builds a mental model and surfaces edge cases early.
- The process is **non-linear/iterative** — learners loop back (e.g. a failed test sends you
  back to the plan), not a straight march.
- It makes explicit "the problem-solving process we naturally follow but many novices do not."
- Rooted in **Pólya's "How to Solve It"**: (1) understand, (2) devise a plan, (3) carry it
  out, (4) look back. The classic, battle-tested 4-step model.

## Source 2 — CS50 (Harvard) syllabus

The most famous intro course; two-thirds of students have never programmed.

- **Week 0 is Scratch (block-based, zero syntax).** It teaches *Computational Thinking,
  Problem Solving: Inputs/Outputs, Abstraction, Algorithms, Pseudocode* — and the
  programming *constructs* (functions, variables, conditionals, loops) **before** the learner
  ever touches a real language's syntax.
- Stated learning objectives, in the program's own words, include:
  - "think more methodically"
  - "**decompose problems into parts and compose solutions** thereto"
  - "**recognize patterns among problems**"
  - "operate at multiple levels of abstraction"
  - "separate design from implementation details"
  - "test solutions… find faults, and **identify corner cases**"
- Explicit philosophy: *"More than teach you how to program in one language, this course
  teaches you how to program fundamentally."*

**Takeaway:** the single most respected intro course spends its **entire first week on
problem-solving with no syntax**, then introduces a language as a way to *express* solutions.

## Source 3 — The "four pillars" of computational thinking (Code.org, BBC, widely used)

A common vocabulary for what "thinking like a programmer" actually means:

1. **Decomposition** — break a big problem into smaller, well-defined parts
2. **Pattern recognition** — spot similarities to problems you've solved before
3. **Abstraction** — ignore irrelevant detail; focus on what matters
4. **Algorithm design** — write the step-by-step plan

Code.org's decomposition lesson has students break a problem into steps **in pseudocode
first**, then translate to code via pair programming, testing, and debugging.

## Source 4 — Recurring findings across the CS-education literature

- **Cognitive overload is the enemy.** Novices juggle syntax + IDE + engineering principles
  + computational thinking all at once. Separating *problem-solving* from *syntax* reduces
  load. (Multiple papers; "syntax-driven approach and knowledge fragmentation… cognitive
  overload when facing authentic problems.")
- **Concrete cases before code** measurably improve correct solutions and metacognition.
- **Make the process explicit and reflective** — don't assume problem-solving is "picked up
  along the way." It must be *taught*.
- **Decomposition is increasingly emphasized** (partly because GenAI writes the syntax now —
  the durable human skill is decomposing and planning).

## What this means for Dailo's course

The course must teach a **repeatable problem-solving process**, with syntax introduced only
as the tool for the Implementation step. Concretely:

1. **Adopt an explicit, named process** — a beginner-friendly blend of Pólya + PCDIT:
   **Understand → Examples → Plan → Code → Check** (UEPCC).
   Teaching a *named, reusable* method is itself a core learning objective.
2. **Lead with the thinking, not the keyword.** Every problem starts with inputs/outputs and
   hand-worked examples *before* any code appears.
3. **Teach the four pillars explicitly** — decomposition, pattern recognition, abstraction,
   algorithm design — as recurring, named skills.
4. **Difficulty arc = problem complexity, not syntax complexity.** Easy → medium → hard is
   about how many steps a problem needs and how much decomposition, not about introducing
   fancier language features.
5. **Assess the *process*, not just the answer.** Exercises must make learners order the
   steps, pick the right next move, match a problem to a technique, and spot *why* an
   approach is wrong — not merely produce a final line of code. (This fits Dailo's static
   grading: we grade the reasoning steps, not free-form code.)
6. **Syntax is "just enough, just in time."** Introduce a Python construct at the moment a
   problem needs it, framed as "the tool that implements this step."

## Sources
- PCDIT framework — https://arxiv.org/html/2109.08896v1 (Kurniawan et al., SUTD/SMU, 2021)
- CS50 syllabus — https://cs50.harvard.edu/syllabus/ (Harvard, Fall 2026)
- Code.org decomposition lesson — https://studio.code.org/courses/foundations-of-ai-programming-2025/units/1/lessons/11
- "Assessing Problem Decomposition in CS1 for the GenAI Era" — https://arxiv.org/html/2511.05764v1
- Pólya, *How to Solve It* (1945) — the foundational 4-step problem-solving model
