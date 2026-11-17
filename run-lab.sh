#!/usr/bin/env bash
set -euo pipefail
mkdir -p results
restore() { git restore src/main/java/mn/edu/must/sqat/DataFlowTargets.java; }
trap restore EXIT

# Run this script after recording the all-defs-only results separately.
# The following commands create the mutation and final-stage evidence.

# M1: remove streak update
python3 - <<'PYCODE'
p='src/main/java/mn/edu/must/sqat/DataFlowTargets.java'
s=open(p,encoding='utf-8').read(); old='                streak = streak + 1;\n'
assert s.count(old)==1
open(p,'w',encoding='utf-8').write(s.replace(old,''))
PYCODE
mvn test 2>&1 | tee results/mvn-test-M1.txt
restore

# M2: use present instead of best streak
python3 - <<'PYCODE'
p='src/main/java/mn/edu/must/sqat/DataFlowTargets.java'
s=open(p,encoding='utf-8').read(); old='                    best = streak;\n'
assert s.count(old)==1
open(p,'w',encoding='utf-8').write(s.replace(old,'                    best = present;\n'))
PYCODE
mvn test 2>&1 | tee results/mvn-test-M2.txt
restore

# M3: add an unused local definition
python3 - <<'PYCODE'
p='src/main/java/mn/edu/must/sqat/DataFlowTargets.java'
s=open(p,encoding='utf-8').read(); old='        int score = 0;\n'
assert s.count(old)==1
open(p,'w',encoding='utf-8').write(s.replace(old,'        int total = present + best; // intentionally unused\n'+old))
PYCODE
mvn test 2>&1 | tee results/mvn-test-M3.txt
restore

mvn verify 2>&1 | tee results/mvn-verify-final.txt
cp target/site/jacoco/jacoco.csv results/jacoco-final.csv
