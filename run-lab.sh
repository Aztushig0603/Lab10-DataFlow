#!/usr/bin/env bash
set -euo pipefail
mkdir -p results
SOURCE='src/main/java/mn/edu/must/sqat/DataFlowTargets.java'
BACKUP="$(mktemp)"
cp "$SOURCE" "$BACKUP"
restore() { cp "$BACKUP" "$SOURCE"; rm -f "$BACKUP"; }
trap restore EXIT
run_mutation() {
  local logfile="$1"
  if mvn test 2>&1 | tee "$logfile"; then
    echo "Mutation test command exited 0: $logfile"
  else
    local status=$?
    echo "Mutation test command exited $status (expected for killed mutants): $logfile"
  fi
  restore_source_only
}
restore_source_only() { cp "$BACKUP" "$SOURCE"; }

# M1: remove streak update
python3 - <<'PYCODE'
p='src/main/java/mn/edu/must/sqat/DataFlowTargets.java'
s=open(p,encoding='utf-8').read(); old='                streak = streak + 1;\n'
assert s.count(old)==1
open(p,'w',encoding='utf-8').write(s.replace(old,''))
PYCODE
run_mutation results/mvn-test-M1.txt

# M2: use present instead of best streak
python3 - <<'PYCODE'
p='src/main/java/mn/edu/must/sqat/DataFlowTargets.java'
s=open(p,encoding='utf-8').read(); old='                    best = streak;\n'
assert s.count(old)==1
open(p,'w',encoding='utf-8').write(s.replace(old,'                    best = present;\n'))
PYCODE
run_mutation results/mvn-test-M2.txt

# M3: add an unused local definition
python3 - <<'PYCODE'
p='src/main/java/mn/edu/must/sqat/DataFlowTargets.java'
s=open(p,encoding='utf-8').read(); old='        int score = 0;\n'
assert s.count(old)==1
open(p,'w',encoding='utf-8').write(s.replace(old,'        int total = present + best; // intentionally unused\n'+old))
PYCODE
run_mutation results/mvn-test-M3.txt

restore_source_only
mvn verify 2>&1 | tee results/mvn-verify-final.txt
cp target/site/jacoco/jacoco.csv results/jacoco-final.csv
restore
trap - EXIT
