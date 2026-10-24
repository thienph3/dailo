# Learn to Program (Beginner) — Spiral Roadmap (v3)

> **Layer 2 (spine).** The course is a **spiral of small circles**, not big blocks. Each circle
> repeats one rhythm and goes a little deeper than the last. Thinking skills (U-E-P-Check,
> decomposition, pattern recognition) are **re-taught in every circle**, never front-loaded.
> See `00-high-level-plan.md`.
>
> **Goal (v3):** recognize + follow good problem-solving through **many guided problems** — not
> an unaided final exam (Dailo grades fixed answers). Breadth of guided problems is the product.
>
> **Length:** 100+ units, growing. Never shortened. Drop-off handled by **save-and-resume** in
> the app, so a long course is a library, not a gauntlet.
>
> **Honest ceiling (tell the learner):** because every exercise is tap/choose/order, this course
> builds the ability to **recognize the right approach and follow a guided path** — a strong
> foundation, but *not* the same as sitting at a blank editor and writing a program unaided. The
> course should set that expectation plainly: "After Dailo, your next step is writing real code
> in a real editor." Graduates should feel *prepared*, not *falsely fluent*.

## The rhythm of every circle

Each circle is a small group of units following the same four beats:

| Beat | Unit role | Weight |
|------|-----------|--------|
| ① **Meet** | a new *kind of problem* — thinking only (understand + example), tiny | 1 unit |
| ② **Tool** | the Python tool that solves it — **see real output run** | 1–2 units |
| ③ **Practice** | *many* similar problems, each guided through UEPCC — the bulk | 2–4 units |
| ④ **Loop back** | consolidate + interleave with earlier circles (review) | 1 unit |

Then the next circle repeats ①–④ on a harder kind of problem. **Most units are beat ③** —
that's where the "more and more problems" goal lives.

> **Lap 0 is a deliberate exception to this order.** Instead of Meet→Tool, it runs **Tool
> first** (Unit 1 prints immediately) so the learner gets a visible win in the first session,
> *then* names the thinking they just used (Meet). The hook beats the rhythm once, on purpose —
> every later lap follows Meet→Tool→Practice→Loop as stated.

## The laps (what deepens each time)

Early laps are kept **short** on purpose: a beginner is most fragile in the first weeks, so the
two biggest topics are split into sub-laps (2a/2b, 4a/4b) — the learner reaches a completion
milestone sooner and more often. The split is a **boundary + a mid consolidation**, not a
renumber: absolute unit numbers stay 1–100.

| Lap | Units | Kind of problem introduced | Pillars re-taught (deeper) |
|-----|-------|----------------------------|----------------------------|
| 0 | 1–6 | "Make the computer show something" | understand, example, check |
| 1 | 7–18 | Remember & compute a result | decomposition (2–3 steps), plan |
| 2a | 19–26 | A simple yes/no choice | pattern: "is it true?"; edge cases |
| 2b | 27–34 | Several conditions, debugging choices | combined logic; debug the reasoning |
| 3 | 35–50 | Do something many times | pattern: repetition; trace to check |
| 4a | 51–56 | Hold & walk a collection | lists; "do it to each value" |
| 4b | 57–68 | Keep a result while walking | pattern: accumulate / track / filter |
| 5 | 69–84 | Too big for one plan → split it | decomposition (into functions) |
| 6 | 85–96 | Combine several techniques | pattern selection across laps |
| 7 | 97–100+ | More & harder guided problems | all pillars, endlessly extensible |

Every lap starts with a *little* thinking and shows runnable code early. The same pillar grows
across laps — decomposition is "2 tiny steps" in Lap 1 and "split into helpers" in Lap 5.

Each unit below is tagged by beat: `[MEET]` `[TOOL]` `[PRACTICE]` `[LOOP]`.

---

## Lap 0 — "Make the computer show something" (Units 1–6)
*The fastest path to a visible win. The learner runs real output inside the first few units —
then we name the thinking they just used.*

### Unit 1 — What a program is, and making it say something  `[TOOL]`
- **In:** nothing; may never have seen code.
- **Out:** can make the computer print a message and predict what appears. *Tool:* `print()`.
- *Note: visible output in Unit 1 — the learner "does programming" immediately.*

### Unit 2 — What goes in, what comes out  `[MEET]`
- **In:** has seen a program produce output.
- **Out:** can name the **input** and **output** of a tiny task (the U of UEPCC), now that
  they've seen output happen.

### Unit 3 — Showing several things  `[PRACTICE]`
- **In:** can print one thing; knows input/output.
- **Out:** can solve "report a few facts" problems. *Tool:* several `print`s, order of output.

### Unit 4 — Working an example by hand  `[MEET]`
- **In:** can produce multi-line output.
- **Out:** can write a concrete input→output example for a task before coding (the E).

### Unit 5 — Did it do what I expected?  `[MEET]`
- **In:** can produce an example.
- **Out:** can compare real output to the expected example and judge pass/fail (the Check).

### Unit 6 — Loop back: show, example, check  `[LOOP]`
- **In:** units 1–5.
- **Out:** can take a tiny "show this" task and run the mini-rhythm (example → code → check) on
  it. First full micro-circle; no new concept.

## Lap 1 — "Remember and compute a result" (Units 7–18)
*New kind of problem: hold a value, do something with it. Thinking deepens: decomposition now
means "break this into 2–3 ordered steps," and we name the Plan step.*

### Unit 7 — Problems where you break it into a few steps  `[MEET]`
- **In:** can run the show→example→check rhythm.
- **Out:** can split a slightly bigger task into 2–3 ordered sub-steps (decomposition, lap-1
  depth) and write them as a plain-words plan (the P).

### Unit 8 — Remembering a value for a later step  `[TOOL]`
- **In:** can plan 2–3 steps.
- **Out:** can store a value and use it in a later step, seeing the result. *Tool:* variables.

### Unit 9 — Updating what you remembered  `[TOOL]`
- **In:** can store a value.
- **Out:** can solve problems where a value changes as the plan runs. *Tool:* reassignment.

### Unit 10 — Problems that combine numbers  `[TOOL]`
- **In:** has values in variables.
- **Out:** can solve "combine these numbers into a result" problems. *Tool:* `+ - * /`.

### Unit 11 — Practice: small calculation problems  `[PRACTICE]`
- **In:** variables + arithmetic.
- **Out:** can walk many "store → compute → show" problems through the plan→code→check rhythm.

### Unit 12 — Problems about sharing and leftovers  `[TOOL]`
- **In:** can do basic math.
- **Out:** can solve "how many each / left over / is it even" problems. *Tool:* `%`, `//`.

### Unit 13 — Getting a multi-step calculation right  `[TOOL]`
- **In:** can combine operators.
- **Out:** can solve problems where calculation order changes the answer. *Tool:* precedence,
  parentheses.

### Unit 14 — Practice: more number problems  `[PRACTICE]`
- **In:** all arithmetic tools.
- **Out:** can decompose and solve varied multi-step number problems (guided UEPCC).

### Unit 15 — Problems about words and messages  `[TOOL]`
- **In:** can handle numbers.
- **Out:** can solve problems whose data is text, and report a value in a sentence.
  *Tool:* strings, joining, f-strings.

### Unit 16 — Word or number? (and converting)  `[TOOL]`
- **In:** has text and numbers.
- **Out:** can avoid the "added text instead of numbers" bug and convert when needed.
  *Tool:* `str` vs `int`, `int()/str()/float()`.

### Unit 17 — Practice: build a readable report  `[PRACTICE]`
- **In:** numbers + text + conversion.
- **Out:** can solve "compute values and present them as a clear message" problems (guided).

### Unit 18 — Loop back: remember & compute  `[LOOP]`
- **In:** all of Lap 1.
- **Out:** can take an unseen "store → compute → report" problem and run full UEPCC; interleaves
  Lap 0 + Lap 1. No new concept.

## Lap 2a — "A simple yes/no choice" (Units 19–26)
*New kind of problem: choose between outcomes. Thinking deepens: the "is it true?" pattern, and
the edge-case habit ("what if there's nothing / it's zero?") starts here, not late. This
sub-lap stops at a natural milestone — the learner can make real decisions before tackling
combined logic in 2b.*

### Unit 19 — Problems with a yes/no question inside  `[MEET]`
- **In:** straight-line problems.
- **Out:** can recognize when a problem's answer hinges on a yes/no fact. *Tool:* booleans.

### Unit 20 — Comparing two things  `[TOOL]`
- **In:** sees yes/no questions.
- **Out:** can solve "is A bigger/equal/different from B?" problems. *Tool:* `== != < > <= >=`.

### Unit 21 — Doing a step only sometimes  `[TOOL]`
- **In:** can write a comparison.
- **Out:** can solve "do this only when … is true" problems. *Tool:* `if` + indentation.
- *Note: hardest beginner leap — extra scaffolding across its 10 lessons; the `=` vs `==` trap
  is taught here too.*

### Unit 22 — This, otherwise that  `[TOOL]`
- **In:** can do a one-sided choice.
- **Out:** can solve two-outcome problems. *Tool:* `else`.

### Unit 23 — Practice: one-choice problems  `[PRACTICE]`
- **In:** `if`/`else` + comparisons.
- **Out:** can walk many "decide between two outcomes" problems through guided UEPCC.

### Unit 24 — What if there's nothing, or it's zero?  `[MEET]`
- **In:** can write a choice.
- **Out:** can spot and handle the empty/zero/missing case in a problem (edge-case habit,
  seeded early). *Tool:* guard conditions.

### Unit 25 — Several possible outcomes  `[TOOL]`
- **In:** can branch two ways + guard edges.
- **Out:** can solve "sort into one of several buckets" problems. *Tool:* `elif`.

### Unit 26 — Needing more than one condition  `[TOOL]`
- **In:** can branch several ways.
- **Out:** can solve "both …", "either …", "unless …" problems. *Tool:* `and`, `or`, `not`.

## Lap 2b — "Several conditions, and debugging choices" (Units 27–34)
*Deepens Lap 2a: combine conditions, decide from input, and debug the reasoning of a wrong
decision — the first real "why is this wrong?" skill.*

### Unit 27 — Practice: multi-condition problems  `[PRACTICE]`
- **In:** elif + boolean operators.
- **Out:** can solve varied "classify by several rules" problems (guided UEPCC).

### Unit 28 — A choice inside a choice  `[TOOL]`
- **In:** can combine conditions.
- **Out:** can solve problems needing a second decision after the first. *Tool:* nested `if`.

### Unit 29 — Deciding based on words  `[TOOL]`
- **In:** can compare numbers.
- **Out:** can solve "does this match / which word is it?" problems. *Tool:* string comparison.

### Unit 30 — Reacting to what the user types  `[TOOL]`
- **In:** can branch; needs input.
- **Out:** can solve "ask, then react to the answer" problems. *Tool:* `input()` + branching.

### Unit 31 — Practice: interactive decisions  `[PRACTICE]`
- **In:** input + all branching tools.
- **Out:** can solve varied "ask and respond" problems, including odd answers (guided).

### Unit 32 — Why is this giving the wrong answer?  `[MEET]`
- **In:** can write branching logic.
- **Out:** can debug the *reasoning* of a wrong if/elif chain, incl. a missed edge case.

### Unit 33 — Practice: fix and finish decision problems  `[PRACTICE]`
- **In:** can debug conditions.
- **Out:** can repair broken decision solutions and complete them (guided, bug-focused).

### Unit 34 — Loop back: decisions  `[LOOP]`
- **In:** all of Lap 2.
- **Out:** can solve unseen decision problems (incl. edge cases); interleaves Laps 0–2. No new
  concept.

## Lap 3 — "Do something many times" (Units 35–50)
*New kind of problem: repetition. Thinking deepens: the repetition pattern, and tracing a loop
to check it. Intuitive "for each" idea first; `while` lands beside a problem that needs it.*

### Unit 35 — Problems that repeat something  `[MEET]`
- **In:** decisions + straight-line problems.
- **Out:** can recognize "do this N times / for each thing" in a problem. *Tool:* the pattern.

### Unit 36 — Doing the same thing to each item  `[TOOL]`
- **In:** sees repetition.
- **Out:** can repeat a step once per item conceptually — the most intuitive loop shape first.
  *Tool:* "for each" idea (gentle).

### Unit 37 — Repeating a known number of times  `[TOOL]`
- **In:** grasps "once per item."
- **Out:** can solve "repeat exactly N times" problems. *Tool:* `for` + `range(n)`.

### Unit 38 — Using the step number each time  `[TOOL]`
- **In:** can repeat N times.
- **Out:** can use the current count each pass (e.g. "print 1..N"). *Tool:* loop variable,
  `range(start, stop, step)`.

### Unit 39 — Practice: counting-loop problems  `[PRACTICE]`
- **In:** for + range + loop variable.
- **Out:** can solve varied "repeat and vary" problems (guided UEPCC).

### Unit 40 — Counting how many times something happens  `[TOOL]`
- **In:** can repeat with a changing value.
- **Out:** can solve "how many times did … happen?" problems. *Tool:* a counter variable.

### Unit 41 — Adding things up as you go  `[TOOL]`
- **In:** can keep a counter.
- **Out:** can solve "what's the running total?" problems. *Tool:* an accumulator.

### Unit 42 — Acting only on some repeats  `[TOOL]`
- **In:** repeats + decisions separately.
- **Out:** can solve "for each, but only when …" problems. *Tool:* an `if` inside a loop.

### Unit 43 — Practice: count and accumulate  `[PRACTICE]`
- **In:** counter + accumulator + in-loop condition.
- **Out:** can solve varied "count/total with a rule" problems (guided).

### Unit 44 — Repeating until something changes  `[TOOL]`
- **In:** can repeat N times; can read input + branch.
- **Out:** can solve "keep asking/trying until it's right" problems — the first problem that
  genuinely needs condition-controlled repetition. *Tool:* `while`.

### Unit 45 — Making sure it actually stops  `[TOOL]`
- **In:** can write a `while`.
- **Out:** can ensure progress; spot/fix infinite loops. *Tool:* termination reasoning.

### Unit 46 — Stopping or skipping mid-repeat  `[TOOL]`
- **In:** can write both loop kinds.
- **Out:** can solve "stop at first match" and "skip the ones that …" problems. *Tool:*
  `break`, `continue`.

### Unit 47 — Which kind of repeat does this need?  `[MEET]`
- **In:** knows both loop styles.
- **Out:** can choose count-controlled vs condition-controlled for a problem (pattern choice).

### Unit 48 — Predicting what a loop will do  `[MEET]`
- **In:** can write loops with conditions, break/continue.
- **Out:** can hand-trace a loop's values each pass to check the result (Check, deeper).

### Unit 49 — Practice: mixed repetition problems  `[PRACTICE]`
- **In:** all loop tools + tracing.
- **Out:** can solve varied repetition problems and pick the right loop (guided UEPCC).

### Unit 50 — Loop back: repetition  `[LOOP]`
- **In:** all of Lap 3.
- **Out:** can solve unseen repetition problems; interleaves Laps 0–3. No new concept.

## Lap 4a — "Hold and walk a collection" (Units 51–56)
*New kind of problem: a collection. This sub-lap stops at a milestone — the learner can create,
index, size, grow, and loop a list — before the accumulate/track/filter patterns in 4b.*

### Unit 51 — Problems about a whole collection  `[MEET]`
- **In:** variables, loops, "for each."
- **Out:** can recognize "this problem is about many values at once." *Tool:* lists.

### Unit 52 — Picking one out by position  `[TOOL]`
- **In:** can hold many values.
- **Out:** can solve "get the first/third/last" problems. *Tool:* indexing, 0-based.

### Unit 53 — How many are there?  `[TOOL]`
- **In:** can index.
- **Out:** can solve problems depending on size. *Tool:* `len()`.

### Unit 54 — Growing or changing a collection  `[TOOL]`
- **In:** can index.
- **Out:** can solve "add this / change that" problems. *Tool:* `append()`, item assignment.

### Unit 55 — Doing something to every value  `[TOOL]`
- **In:** can make/index a list; can loop.
- **Out:** can solve "for each value, do …" problems. *Tool:* `for item in list`.

### Unit 56 — Practice: walking a collection  `[PRACTICE]`
- **In:** list basics + loop.
- **Out:** can solve varied "go through the list and do something" problems (guided).

## Lap 4b — "Keep a result while walking" (Units 57–68)
*Deepens Lap 4a: the accumulate / track-the-best / filter / search patterns become named tools
the learner selects per problem. The max→min pair (59→60) is kept adjacent for transfer.*

### Unit 57 — The total of many values  `[TOOL]`
- **In:** loop a list; accumulator (Lap 3).
- **Out:** can solve "sum all of them" problems. *Tool:* accumulator over a list.

### Unit 58 — How many fit a rule  `[TOOL]`
- **In:** can total a list.
- **Out:** can solve "how many are …?" problems. *Tool:* counter + condition over a list.

### Unit 59 — The biggest one  `[TOOL]`
- **In:** can loop + keep a variable.
- **Out:** can solve "which is largest?" problems. *Tool:* track-the-best-so-far (max).

### Unit 60 — The smallest one  `[TOOL]`
- **In:** can find the biggest.
- **Out:** can solve "which is smallest?" — *same pattern, flipped* (transfer). *Tool:* min.

### Unit 61 — Practice: totals, counts, best-of  `[PRACTICE]`
- **In:** sum/count/max/min patterns.
- **Out:** can pick the right pattern for varied list problems (guided UEPCC).

### Unit 62 — The average (and the empty case)  `[TOOL]`
- **In:** can sum and count a list.
- **Out:** can solve "what's the average?" incl. empty list. *Tool:* sum+count, zero-guard
  (reuses the edge-case habit from Lap 2).

### Unit 63 — Keeping only some values  `[TOOL]`
- **In:** can loop + test items.
- **Out:** can solve "keep only the ones that …" problems. *Tool:* building a filtered list.

### Unit 64 — Is it in there?  `[TOOL]`
- **In:** can loop + decide.
- **Out:** can solve "is this present / where?" problems. *Tool:* searching a list.

### Unit 65 — Practice: filter and search  `[PRACTICE]`
- **In:** filter + search.
- **Out:** can solve varied "find/keep matching items" problems (guided).

### Unit 66 — Why is this off by one (or wrong)?  `[MEET]`
- **In:** can write list loops.
- **Out:** can debug off-by-one and wrong-accumulator approaches.

### Unit 67 — Practice: fix and finish list problems  `[PRACTICE]`
- **In:** can debug list loops.
- **Out:** can repair and complete broken list solutions (guided, bug-focused).

### Unit 68 — Loop back: many values  `[LOOP]`
- **In:** all of Lap 4.
- **Out:** can solve unseen list problems; interleaves Laps 0–4. No new concept.

## Lap 5 — "Too big for one plan → split it" (Units 69–84)
*New kind of problem: it won't fit one straight plan. Thinking deepens to its fullest:
decomposition now means splitting into named sub-plans (functions) and composing them.*

### Unit 69 — Knowing when a problem is too big  `[MEET]`
- **In:** can solve single-plan problems.
- **Out:** can recognize a problem that must be split into sub-problems (decomposition, deepest
  depth — same pillar first met in Lap 1 as "2–3 steps").

### Unit 70 — Naming a sub-plan so you can reuse it  `[MEET]`
- **In:** sees the need to split.
- **Out:** can name a repeated sub-plan the main plan refers to. *Tool:* the idea of a function.

### Unit 71 — Writing and using a sub-plan  `[TOOL]`
- **In:** knows what a sub-plan is for.
- **Out:** can define a named sub-plan and call it; knows define ≠ run. *Tool:* `def`, calling.

### Unit 72 — Sub-plans that need information  `[TOOL]`
- **In:** can define/call.
- **Out:** can solve sub-problems depending on values handed in. *Tool:* parameters (one, several).

### Unit 73 — Sub-plans that hand back an answer  `[TOOL]`
- **In:** can pass inputs in.
- **Out:** can solve sub-problems that compute a result the main plan uses. *Tool:* `return`.

### Unit 74 — Show it vs hand it back  `[TOOL]`
- **In:** can return a value.
- **Out:** can choose display vs return and avoid the mix-up. *Tool:* `return` vs `print`.

### Unit 75 — Practice: build and use small sub-plans  `[PRACTICE]`
- **In:** def/call/params/return.
- **Out:** can solve varied problems by writing and calling helper functions (guided).

### Unit 76 — Building the answer from several sub-answers  `[TOOL]`
- **In:** can write individual sub-plans.
- **Out:** can solve problems by combining results from several functions. *Tool:* composition.

### Unit 77 — Why a sub-plan's notes don't leak out  `[TOOL]`
- **In:** can write/call sub-plans.
- **Out:** can avoid expecting a function's private values outside it. *Tool:* scope (gently).

### Unit 78 — Using a sub-plan on every value  `[TOOL]`
- **In:** functions + loops.
- **Out:** can solve "do this helper for each item" problems. *Tool:* a helper inside a loop.

### Unit 79 — Practice: compose sub-plans  `[PRACTICE]`
- **In:** composition + helper-in-loop.
- **Out:** can solve varied multi-part problems by composing helpers (guided UEPCC).

### Unit 80 — Finding the tricky cases before you code  `[MEET]`
- **In:** can decompose + test.
- **Out:** can enumerate edge cases (empty, zero, biggest) as a planning step (edge-case habit
  at its deepest).

### Unit 81 — Why did my split give the wrong answer?  `[MEET]`
- **In:** can compose sub-plans.
- **Out:** can debug a faulty decomposition (missing case, wrong sub-result wired in).

### Unit 82 — Practice: decompose harder problems  `[PRACTICE]`
- **In:** all of Lap 5's tools + edge cases.
- **Out:** can take a bigger problem, split it into helpers, and solve it (guided).

### Unit 83 — Practice: fix and finish split problems  `[PRACTICE]`
- **In:** can debug decompositions.
- **Out:** can repair and complete broken multi-function solutions (guided, bug-focused).

### Unit 84 — Loop back: breaking problems down  `[LOOP]`
- **In:** all of Lap 5.
- **Out:** can solve unseen "too big for one plan" problems; interleaves Laps 0–5. No new concept.

## Lap 6 — "Combine several techniques" (Units 85–96)
*New kind of problem: multi-part, needing several patterns at once. Thinking deepens: choosing
which pattern each part needs, across everything learned in Laps 0–5.*

### Unit 85 — Making sense of a big problem statement  `[MEET]`
- **In:** all core skills.
- **Out:** can read a multi-part problem and restate goal/inputs/outputs.

### Unit 86 — Splitting a big problem into parts  `[MEET]`
- **In:** can restate a big problem.
- **Out:** can produce an ordered list of sub-problems for it (decomposition at scale).

### Unit 87 — Picking the right pattern for each part  `[MEET]`
- **In:** knows accumulate/track/filter/search.
- **Out:** can match each sub-problem to the pattern that solves it (pattern selection).

### Unit 88 — Problems about every pair / grid  `[TOOL]`
- **In:** can loop a collection.
- **Out:** can solve "each thing against each other thing" problems. *Tool:* nested loops.

### Unit 89 — Tracking several things at once  `[TOOL]`
- **In:** can track one running value.
- **Out:** can solve problems keeping several pieces of state through one pass. *Tool:* multiple
  state variables.

### Unit 90 — Problems where the input might be bad  `[TOOL]`
- **In:** can read + branch on input; can loop-until (Lap 3).
- **Out:** can solve problems that reject or re-ask on invalid input. *Tool:* validation loops.

### Unit 91 — Practice: multi-part problems  `[PRACTICE]`
- **In:** nested loops + multi-state + validation.
- **Out:** can solve varied multi-part problems, choosing techniques (guided UEPCC).

### Unit 92 — Weaving sub-plans, repeats, and choices together  `[TOOL]`
- **In:** each technique individually.
- **Out:** can integrate functions + loops + decisions into one coherent solution.

### Unit 93 — Practice: full integrated problems  `[PRACTICE]`
- **In:** integration.
- **Out:** can solve larger integrated problems end-to-end (guided).

### Unit 94 — Proving the whole thing works  `[MEET]`
- **In:** can write multi-step solutions.
- **Out:** can run every example (normal + edge) and confirm the full solution (Check, hardest).

### Unit 95 — Making a working solution clearer  `[MEET]`
- **In:** has a correct solution.
- **Out:** can simplify/rename without breaking it (first taste of refactoring).

### Unit 96 — Loop back: combining techniques  `[LOOP]`
- **In:** all of Lap 6.
- **Out:** can solve unseen multi-part problems; interleaves Laps 0–6. No new concept.

---

## Lap 7 — "More and more guided problems" (Units 97–100+, open-ended)
*No new concepts. This is the **growing tail** that fulfills the goal: an ever-expanding set of
guided problems that recombine everything, each walked through UEPCC. New themed problem-sets
are added here over time — the course never "ends," it accretes.*

### Unit 97 — Guided problem set: number & math puzzles  `[PRACTICE]`
- **In:** entire course.
- **Out:** can solve a themed batch (e.g. FizzBuzz reasoned, digit sums, simple patterns) via
  guided UEPCC, choosing techniques.

### Unit 98 — Guided problem set: text & message tools  `[PRACTICE]`
- **In:** entire course.
- **Out:** can solve a themed batch of text problems (counting words, building reports) guided.

### Unit 99 — Guided problem set: lists & data questions  `[PRACTICE]`
- **In:** entire course.
- **Out:** can solve a themed batch of collection problems (tallies, bests, filters) guided.

### Unit 100 — Guided problem set: small interactive programs  `[PRACTICE]`
- **In:** entire course.
- **Out:** can solve a themed batch of interactive programs (guessing game, menu, mini
  adventure) via guided UEPCC.

### Units 101+ — Future guided problem sets  `[PRACTICE]`
- **In:** entire course.
- **Out:** each new unit adds ~10 fresh guided problems on a theme. **This is where the course
  grows** — authoring continues here indefinitely to deliver "more and more problems."

> **Note for tooling:** this `Units 101+` entry is a *growth placeholder*, not a numbered unit.
> That is why the roadmap shows 101 `### Unit` headings while `scope.json` has exactly 100
> real units (u01–u100). The off-by-one is intentional — do not "fix" it by forcing the counts
> equal. Each real future unit (u101, u102, …) gets its own scope entry when authored.

---

## Why this shape (v3 spiral) answers the three decisions

- **Decision 1 (goal = many guided problems):** every lap is ~40% `[PRACTICE]` units, and Lap 7
  is *all* practice and grows forever. The product is breadth of guided problems, not a final
  exam. Late units say "guided problem set," never "solve unaided."
- **Decision 2 (100+, never shorter; save-and-resume):** laps are self-contained wins, and the
  tail (97+) extends indefinitely. Length is safe because the app remembers where you stopped
  (persistence requirement recorded in `00-high-level-plan.md` and `../../dailo-core.md`).
- **Decision 3 (flatten thinking into a circle):** there is **no code-free front block**. Unit 1
  already prints. Thinking pillars recur every lap: decomposition at Lap 1 = "2–3 steps," at
  Lap 5 = "split into functions"; the edge-case habit at Lap 2 = "what if zero," at Lap 5 =
  "enumerate edge cases." Same skills, spiralled deeper.

## Beat distribution (per lap)

| Lap | Units | MEET | TOOL | PRACTICE | LOOP |
|-----|-------|------|------|----------|------|
| 0 | 1–6 | 3 | 1 | 1 | 1 |
| 1 | 7–18 | 1 | 7 | 3 | 1 |
| 2 | 19–34 | 3 | 8 | 4 | 1 |
| 3 | 35–50 | 3 | 9 | 3 | 1 |
| 4 | 51–68 | 2 | 10 | 5 | 1 |
| 5 | 69–84 | 4 | 7 | 4 | 1 |
| 6 | 85–96 | 5 | 4 | 2 | 1 |
| 7 | 97+ | — | — | all | — |

Every lap opens by *meeting* a problem and closes by *looping back* (review). The middle is
tool + heavy practice. Early laps front-load MEET (thinking) in small doses; later laps shift
toward MEET+PRACTICE as syntax is mostly known and thinking dominates.

## Appendix — Syntax Coverage Checklist (hidden spine, v3 unit numbers)

| Python feature | First introduced |
|----------------|-------------------|
| `print()`, output | Unit 1 |
| multiple values / lines | Unit 3 |
| variables | Unit 8 |
| reassignment | Unit 9 |
| `+ - * /` | Unit 10 |
| `%`, `//` | Unit 12 |
| precedence, parentheses | Unit 13 |
| strings, concatenation, f-strings | Unit 15 |
| type awareness + `int()/str()/float()` | Unit 16 |
| booleans | Unit 19 |
| comparisons | Unit 20 |
| `if`, indentation, `=` vs `==` | Unit 21 |
| `else` | Unit 22 |
| edge-case guards | Unit 24 |
| `elif` | Unit 25 |
| `and` / `or` / `not` | Unit 26 |
| nested `if` | Unit 28 |
| string comparison | Unit 29 |
| `input()` | Unit 30 |
| "for each" (concept) | Unit 36 |
| `for` + `range(n)` | Unit 37 |
| loop variable, `range(start,stop,step)` | Unit 38 |
| counter | Unit 40 |
| accumulator | Unit 41 |
| `if` inside loop | Unit 42 |
| `while` | Unit 44 |
| loop termination | Unit 45 |
| `break` / `continue` | Unit 46 |
| lists | Unit 51 |
| indexing | Unit 52 |
| `len()` | Unit 53 |
| `append()`, item assignment | Unit 54 |
| `for item in list` | Unit 55 |
| sum over list | Unit 57 |
| count with condition | Unit 58 |
| max / min | Units 59–60 |
| average + empty guard | Unit 62 |
| filter | Unit 63 |
| search / membership | Unit 64 |
| `def`, calling | Unit 71 |
| parameters | Unit 72 |
| `return` | Unit 73 |
| `return` vs `print` | Unit 74 |
| composing functions | Unit 76 |
| scope (gently) | Unit 77 |
| helper in a loop | Unit 78 |
| edge-case enumeration | Unit 80 |
| nested loops | Unit 88 |
| multiple state variables | Unit 89 |
| input validation | Unit 90 |
| refactoring | Unit 95 |

**Gap check:** every beginner Python construct has a first-introduction unit. Deferred to a
future Intermediate course: dictionaries, sets, tuples, comprehensions, OOP/classes, files,
modules/imports, recursion, exceptions, Big-O.

## Next step: parallel authoring
Each unit = 10 lessons × 10 questions, authorable by **sub-agents in parallel batches** (e.g.
one lap per batch). Feed each: the unit's In/Out and **beat tag**, its *Tool* line, the
exercise patterns from `00-high-level-plan.md`, and the overlap rule. Authoring rules by beat:
- `[MEET]` — thinking only, no/minimal syntax; mostly identify-I/O, order-the-plan, spot-flaw.
- `[TOOL]` — introduce one construct with **visible runnable output**; still ≥ half thinking.
- `[PRACTICE]` — *many guided problems*, each walked through UEPCC; the product's core value.
- `[LOOP]` — interleaved review of this lap + earlier laps; no new concept.
