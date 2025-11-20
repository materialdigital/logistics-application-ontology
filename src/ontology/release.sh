VERSION=1.0.0; 
PRIOR_VERSION=0.0.1  # ignored now; please uncomment in log.Makefile for next version
ONTBASE=https://w3id.org/pmd/log/
ANNOTATE_ONTOLOGY_VERSION="annotate -V $ONTBASE$VERSION/\$@ --annotation owl:versionInfo $VERSION"

sh run.sh make clean

sh run.sh make VERSION=$VERSION ONTBASE=$ONTBASE ANNOTATE_ONTOLOGY_VERSION="$ANNOTATE_ONTOLOGY_VERSION" prepare_release

sh run.sh make VERSION=$VERSION PRIOR_VERSION=$PRIOR_VERSION update-ontology-annotations

# finally refresh imports again, so that version IRIs in imports are updated back to "normal". 
#sh run.sh make no-mirror-refresh-imports

