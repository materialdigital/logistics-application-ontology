#
# Test a single pattern against its shape and the autoshapes.
# Usage: sh test.sh "shipment-by-sea"
#
# Requires: pyshacl (pip install pyshacl)
#           ROBOT available as java -jar robot.jar or via ODK
#

PATTERN="$1"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ODK="docker run --rm -v ${REPO_ROOT}:/work -w /work/src/ontology obolibrary/odkfull:latest robot"

echo "=== Testing pattern: ${PATTERN} ==="
mkdir -p tmp

echo "Merging ontology..."
$ODK --catalog catalog-v001.xml \
  merge --input log-edit.owl \
  --output /work/patterns/tmp/merged-log.ttl

echo "Merging ontology into shape-data..."
$ODK --catalog catalog-v001.xml \
  merge --input /work/patterns/tmp/merged-log.ttl \
        --input /work/patterns/${PATTERN}/shape-data.ttl \
  remove --select imports \
  --output /work/patterns/tmp/merged-data.ttl

echo "Reasoning..."
$ODK reason --input /work/patterns/tmp/merged-data.ttl \
  --reasoner hermit \
  --axiom-generators "SubClass EquivalentClass ClassAssertion PropertyAssertion SubObjectProperty InverseObjectProperties" \
  remove --term owl:topObjectProperty \
  --output /work/patterns/tmp/shape-data-reasoned.ttl

echo "Validating against hand-written shape..."
python3 -m pyshacl -s "${REPO_ROOT}/patterns/${PATTERN}/shape.ttl" \
  "${REPO_ROOT}/patterns/tmp/shape-data-reasoned.ttl"

echo "Validating against auto-shapes (open)..."
python3 -m pyshacl -s "${REPO_ROOT}/patterns/autoshape/auto-shapes-open.ttl" \
  "${REPO_ROOT}/patterns/tmp/shape-data-reasoned.ttl"

echo "=== Done ==="
