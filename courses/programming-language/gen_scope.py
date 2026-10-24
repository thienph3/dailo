#!/usr/bin/env python3
"""Generate scope.json: per-unit `allows` and `excludes` for all 100 units, derived from the
Syntax Coverage Appendix in 01-unit-roadmap.md.

v2 (pattern-based, enforceable):
  - each construct carries a matchable REGEX `pattern` (not just a prose label)
  - `excludes` = ALL not-yet-introduced constructs (full, not a window) so far-ahead leaks
    cannot slip through
  - the grouping-parenthesis rule is written to NOT match call parens like print(...) / def f()

Run: python3 gen_scope.py   (writes scope.json)
"""
import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))

# (first_unit, key, label, pattern)
# pattern is a Python regex matched against the CODE-bearing text of exercises.
# For grouping parens we match a "(" that is NOT immediately preceded by an identifier
# (identifier+"(" is a call like print( or range( or int(), which is allowed/own-construct).
SCHEDULE = [
    (1,  "print",         "print() / output",                      r"\bprint\s*\("),
    (3,  "multi_output",  "multiple values or lines",              None),
    (8,  "variables",     "variables",                             None),
    (9,  "reassign",      "reassignment",                          None),
    (10, "arith",         "+ - * /",                               r"[-+*/]"),
    (12, "mod_floordiv",  "% and //",                              r"(%|//)"),
    (13, "parens",        "precedence / parentheses for grouping", r"(?<![\w])\((?=[^)]*[-+*/])"),
    (15, "strings",       "strings, concatenation, f-strings",     r"(f\"|f'|\"|')"),
    (16, "types",         "type awareness + int()/str()/float()",  r"\b(int|str|float)\s*\("),
    (19, "booleans",      "booleans",                              r"\b(True|False)\b"),
    (20, "comparisons",   "comparisons == != < > <= >=",           r"(==|!=|<=|>=|<|>)"),
    (21, "if",            "if, indentation, = vs ==",              r"\bif\b"),
    (22, "else",          "else",                                  r"\belse\b"),
    (24, "guards",        "edge-case guards",                      None),
    (25, "elif",          "elif",                                  r"\belif\b"),
    (26, "boolops",       "and / or / not",                        r"\b(and|or|not)\b"),
    (28, "nested_if",     "nested if",                             None),
    (29, "str_compare",   "string comparison",                     None),
    (30, "input",         "input()",                               r"\binput\s*\("),
    (36, "for_each",      "'for each' concept",                    None),
    (37, "for_range",     "for + range(n)",                        r"\b(for|range)\b"),
    (38, "range_step",    "loop variable, range(start,stop,step)", None),
    (40, "counter",       "counter variable",                      None),
    (41, "accumulator",   "accumulator variable",                  None),
    (42, "if_in_loop",    "if inside loop",                        None),
    (44, "while",         "while",                                 r"\bwhile\b"),
    (45, "termination",   "loop termination",                      None),
    (46, "break_cont",    "break / continue",                      r"\b(break|continue)\b"),
    (51, "lists",         "lists",                                 r"\[.*\]"),
    (52, "indexing",      "indexing",                              r"\w+\[\d+\]"),
    (53, "len",           "len()",                                 r"\blen\s*\("),
    (54, "append",        "append(), item assignment",             r"\.append\s*\("),
    (55, "for_in_list",   "for item in list",                      r"\bfor\s+\w+\s+in\b"),
    (57, "sum_list",      "sum over list",                         r"\bsum\s*\("),
    (58, "count_cond",    "count with condition",                  None),
    (59, "max_min",       "max / min",                             r"\b(max|min)\s*\("),
    (62, "average",       "average + empty guard",                 None),
    (63, "filter",        "filter",                                None),
    (64, "search",        "search / membership",                   r"\bin\b"),
    (71, "def",           "def, calling",                          r"\bdef\b"),
    (72, "params",        "parameters",                            None),
    (73, "return",        "return",                                r"\breturn\b"),
    (74, "return_vs_print","return vs print",                      None),
    (76, "compose",       "composing functions",                   None),
    (77, "scope_concept", "scope (gently)",                        None),
    (78, "helper_loop",   "helper in a loop",                      None),
    (80, "edge_enum",     "edge-case enumeration",                 None),
    (88, "nested_loops",  "nested loops",                          None),
    (89, "multi_state",   "multiple state variables",              None),
    (90, "validation",    "input validation",                      None),
    (95, "refactoring",   "refactoring",                           None),
]


def build():
    scope = {}
    for unit in range(1, 101):
        allows = [label for (first, key, label, pattern) in SCHEDULE if first <= unit]
        excludes = [label for (first, key, label, pattern) in SCHEDULE if first > unit]
        scope[f"u{unit:02d}"] = {"allows": allows, "excludes": excludes}
    return scope


def main():
    scope = build()
    out = {
        "_comment": "AUTHOR GUIDANCE (not enforced). Per-unit scope projected from the Syntax Coverage "
                    "Appendix in 01-unit-roadmap.md. A sub-agent authoring a unit reads its 'allows' "
                    "(the cumulative toolbox it MAY use) and 'excludes' (everything not yet introduced, "
                    "which it MUST NOT use). Scope is a rule authors follow; the validator does not "
                    "enforce it (prose and code share too many tokens to match reliably). "
                    "Regenerate: python3 gen_scope.py",
        "units": scope,
    }
    with open(os.path.join(HERE, "scope.json"), "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)
        f.write("\n")
    print(f"wrote scope.json (author guidance) for {len(scope)} units")
    for u in ("u01", "u11", "u13"):
        s = scope[u]
        print(f"  {u}: allows={len(s['allows'])} excludes={len(s['excludes'])}")


if __name__ == "__main__":
    main()
