#!/usr/bin/env python3
"""Summarize independent process pairs, preserving their run-order strata."""
import argparse
import json
from pathlib import Path
import random
from statistics import median

p = argparse.ArgumentParser()
p.add_argument("results", type=Path)
a = p.parse_args()
runs = json.loads((a.results / "runs.json").read_text())
config = json.loads((a.results / "config.json").read_text())
by_pair = {}
for run in runs:
    cases = {}
    for sample in run["samples"]:
        cases.setdefault(sample["case"], []).append(sample["elapsed_ns"] / sample["iterations"])
    if any(len(case) != config["rounds_per_process"] for case in cases.values()):
        raise ValueError("incomplete process")
    by_pair.setdefault(run["pair"], {})[run["variant"]] = {
        case: median(values) for case, values in cases.items()}
if len(by_pair) != config["pairs"] or any(set(pair) != {"before", "after"} for pair in by_pair.values()):
    raise ValueError("incomplete before/after pairs")

def quantile(sorted_values, fraction):
    n = fraction * (len(sorted_values) - 1)
    lo = int(n)
    return sorted_values[lo] + (sorted_values[min(lo + 1, len(sorted_values) - 1)] -
                                sorted_values[lo]) * (n - lo)

summary = {}
for case in sorted(by_pair[0]["before"]):
    before = [by_pair[i]["before"][case] for i in range(len(by_pair))]
    after = [by_pair[i]["after"][case] for i in range(len(by_pair))]
    savings = [(1 - new / old) * 100 for old, new in zip(before, after)]
    ab, ba = savings[::2], savings[1::2]
    rng = random.Random(2731)
    draws = sorted(median(rng.choices(ab, k=len(ab)) + rng.choices(ba, k=len(ba)))
                   for _ in range(10000))
    summary[case] = {
        "before_median_ns": median(before), "after_median_ns": median(after),
        "paired_reduction_pct": median(savings),
        "bootstrap95_pct": [quantile(draws, .025), quantile(draws, .975)],
        "ab_reduction_pct": median(ab), "ba_reduction_pct": median(ba),
        "all_pair_reductions_pct": savings}
print("| Case | Before ns/call | After ns/call | Paired reduction | 95% bootstrap interval |")
print("| --- | ---: | ---: | ---: | ---: |")
for case, row in summary.items():
    lo, hi = row["bootstrap95_pct"]
    print(f'| `{case}` | {row["before_median_ns"]:.1f} | {row["after_median_ns"]:.1f} | '
          f'{row["paired_reduction_pct"]:+.1f}% | {lo:+.1f}% to {hi:+.1f}% |')
(a.results / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
