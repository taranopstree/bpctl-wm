#!/bin/bash
TEMPLATE_FOLDER=
#set -x
source data.properties
source functions.sh

echo "Generating bpctl manifests at"
echo "${TGT_FOLDER}"

# SOURCE_CSV=../../examples/repos.csv
# generateReposManifests

# SOURCE_CSV=../../examples/service.csv
# generateServiceManifests

# pause

# SOURCE_CSV=../../examples/serviceEnv.csv
# generateServiceEnvManifests

# pause

SOURCE_CSV=../../examples/ci.csv
generateCIManifests

# pause

# SOURCE_CSV=../../examples/cd.csv
# generateServiceCDManifests
