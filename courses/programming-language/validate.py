#!/usr/bin/env python3
"""Validate authored Dailo course content against the authoring contract.

Resolves course.json -> config.json -> per-lesson content files and checks:
  - every authored unit has 10 lessons, each with 10 exercises
  - unique lesson + exercise ids
  - every exercise has id/type/prompt/explanation and a valid type payload
  - answer indices in range; orderBlocks answers are permutations
  - lessonId/unitId inside files match course.json
  - PRACTICE units: all 5 UEPCC steps present AND >= 50% thinking (U/E/P/Check)

Exit 0 = all pass. Exit 1 = problems found (printed). Usage: python3 validate.py
"""
import json
import os
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))


def load(path):
    with open(os.path.join(HERE, path), encoding="utf-8") as f:
        return json.load(f)


def main():
    course = load("course.json")
    config = load(course["configRef"])
    valid_types = set(config["exerciseTypes"])
    per_lesson = config["authoring"]["exercisesPerLesson"]
    per_unit = config["authoring"]["lessonsPerUnit"]

    problems = []
    seen_ids = set()
    total_ex = 0
    units_checked = 0

    # units referenced by laps but not yet authored are fine (stubs); we only
    # validate units that have a definition in course["units"].
    for u in course["units"]:
        units_checked += 1
        uid = u["id"]
        beat = u.get("beat")
        lessons = u.get("lessons", [])
        if len(lessons) != per_unit:
            problems.append(f"{uid}: {len(lessons)} lessons (want {per_unit})")

        uepcc = Counter()
        for lmeta in lessons:
            lid = lmeta["id"]
            path = lmeta["file"]
            full = os.path.join(HERE, path)
            if not os.path.exists(full):
                problems.append(f"{uid}: missing content file {path}")
                continue
            c = load(path)
            if c.get("lessonId") != lid:
                problems.append(f"{path}: lessonId {c.get('lessonId')} != {lid}")
            if c.get("unitId") != uid:
                problems.append(f"{path}: unitId {c.get('unitId')} != {uid}")
            for dup_id in (lid,):
                if dup_id in seen_ids:
                    problems.append(f"duplicate lesson id {dup_id}")
                seen_ids.add(dup_id)

            exs = c.get("exercises", [])
            if len(exs) != per_lesson:
                problems.append(f"{path}: {len(exs)} exercises (want {per_lesson})")

            for e in exs:
                total_ex += 1
                eid = e.get("id", "?")
                if eid in seen_ids:
                    problems.append(f"duplicate exercise id {eid}")
                seen_ids.add(eid)
                for field in ("id", "type", "prompt", "explanation"):
                    if field not in e:
                        problems.append(f"{eid}: missing {field}")
                t = e.get("type")
                if t not in valid_types:
                    problems.append(f"{eid}: bad type {t}")
                    continue
                # per-type payload + answer checks
                if t == "multipleChoice":
                    opts = e.get("options", [])
                    a = e.get("answer")
                    if not (isinstance(a, int) and 0 <= a < len(opts)):
                        problems.append(f"{eid}: multipleChoice answer out of range")
                elif t == "multiSelect":
                    opts = e.get("options", [])
                    a = e.get("answer", [])
                    if not (isinstance(a, list) and a and all(isinstance(i, int) and 0 <= i < len(opts) for i in a)):
                        problems.append(f"{eid}: multiSelect answer out of range")
                elif t == "trueFalse":
                    if not isinstance(e.get("answer"), bool):
                        problems.append(f"{eid}: trueFalse answer not boolean")
                elif t == "fillBlank":
                    if "answer" not in e:
                        problems.append(f"{eid}: fillBlank missing answer")
                elif t == "orderBlocks":
                    blocks = e.get("blocks", [])
                    a = e.get("answer", [])
                    if sorted(a) != list(range(len(blocks))):
                        problems.append(f"{eid}: orderBlocks answer not a permutation of blocks")
                elif t == "matchPairs":
                    pairs = e.get("pairs", [])
                    if not pairs or not all("left" in p and "right" in p for p in pairs):
                        problems.append(f"{eid}: matchPairs needs pairs with left/right")
                elif t == "tapTokens":
                    toks = e.get("tokens", [])
                    a = e.get("answer", [])
                    if not toks or not isinstance(a, list) or sorted(a) != sorted(toks):
                        problems.append(f"{eid}: tapTokens answer must be a reordering of tokens")

                if beat == "PRACTICE":
                    step = e.get("uepcc", "MISSING")
                    uepcc[step] += 1

        if beat == "PRACTICE":
            for step in ("U", "E", "P", "C", "Check"):
                if uepcc.get(step, 0) == 0:
                    problems.append(f"{uid}: PRACTICE unit missing UEPCC step {step}")
            if uepcc.get("MISSING", 0) > 0:
                problems.append(f"{uid}: {uepcc['MISSING']} PRACTICE exercises missing uepcc tag")
            thinking = sum(uepcc.get(s, 0) for s in ("U", "E", "P", "Check"))
            total = sum(uepcc.values())
            if total and thinking / total < 0.5:
                problems.append(f"{uid}: thinking {thinking}/{total} below 50% floor")

    print(f"units checked: {units_checked} | total exercises: {total_ex}")
    if problems:
        print("FAIL — problems found:")
        for p in problems:
            print("  -", p)
        sys.exit(1)
    print("PASS — all authored content satisfies the authoring contract")
    sys.exit(0)


if __name__ == "__main__":
    main()
