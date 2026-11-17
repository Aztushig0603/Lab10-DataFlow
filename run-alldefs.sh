#!/usr/bin/env bash
set -euo pipefail
mkdir -p results
TEST_FILE='src/test/java/mn/edu/must/sqat/BonusTest.java'
BACKUP="$(mktemp)"
cp "$TEST_FILE" "$BACKUP"
restore() { cp "$BACKUP" "$TEST_FILE"; rm -f "$BACKUP"; }
trap restore EXIT
# f9faab2 is the commit that contains only the two minimum all-defs tests.
git show f9faab2:"$TEST_FILE" > "$TEST_FILE"
mvn verify 2>&1 | tee results/mvn-verify-alldefs.txt
cp target/site/jacoco/jacoco.csv results/jacoco-alldefs.csv
restore
trap - EXIT
