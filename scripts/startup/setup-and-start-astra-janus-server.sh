#!/bin/bash -eux

if [ "$BASH" != "/bin/bash" ]; then
  echo "Please do ./$0"
  exit 1
fi

# always base everything relative to this file to make it simple
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
. $parent_path/../config/env-vars.sh

###############################################
# Copy configs over 
###############################################
cp $parent_path/../../conf/astra-gremlin-server-cql-es.yaml ~/lib/janusgraph-0.5.2/conf/gremlin-server/
cp $parent_path/../../conf/astra-janusgraph-cql-es-server.properties ~/lib/janusgraph-0.5.2/conf/gremlin-server/

################################################
# start janus server
################################################

~/lib/janusgraph-0.5.2/bin/gremlin-server.sh ~/lib/janusgraph-0.5.2/conf/gremlin-server/astra-gremlin-server-cql-es.yaml
 
