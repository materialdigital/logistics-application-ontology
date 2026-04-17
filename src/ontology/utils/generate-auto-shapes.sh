#!/bin/bash
# Generate SHACL shapes from the LOG ontology in three strictness profiles.
# Run from src/ontology/ directory.
set -e

REPO_ROOT="$(pwd)/../.."
docker run --rm -v "${REPO_ROOT}:/work" -w /work/src/ontology obolibrary/odkfull:latest robot \
  --catalog catalog-v001.xml \
  merge --input log-edit.owl \
  remove --term owl:real \
  reason --reasoner hermit \
    --axiom-generators "SubClass SubObjectProperty ClassAssertion InverseObjectProperties PropertyAssertion" \
  query --update utils/remove-isabout.sparql \
  --output ./tmp/tmp-reasoned.ttl

docker run --rm -v ./:/data ghcr.io/ashleycaselli/shacl:latest \
  infer -datafile /data/tmp/tmp-reasoned.ttl \
        -shapesfile /data/utils/owl2shacl/owl2sh-open.ttl \
  > ../../patterns/autoshape/auto-shapes-open.ttl

docker run --rm -v ./:/data ghcr.io/ashleycaselli/shacl:latest \
  infer -datafile /data/tmp/tmp-reasoned.ttl \
        -shapesfile /data/utils/owl2shacl/owl2sh-semi-closed.ttl \
  > ../../patterns/autoshape/auto-shapes-semi-closed.ttl

docker run --rm -v ./:/data ghcr.io/ashleycaselli/shacl:latest \
  infer -datafile /data/tmp/tmp-reasoned.ttl \
        -shapesfile /data/utils/owl2shacl/owl2sh-closed.ttl \
  > ../../patterns/autoshape/auto-shapes-closed.ttl

echo "Auto-shapes generated in patterns/autoshape/"
