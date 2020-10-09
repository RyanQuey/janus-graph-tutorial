#!/bin/sh


# always base everything relative to this file to make it simple
# NOTE this won't work if you hack your `cd` command, like I normally do, e.g., having it call `ll` after running `cd`

env_vars_parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

export DATA_UTILS_VERSION=0.6.0

export JANUS_GRAPH_KEYSPACE="janusgraph"

export JANUS_GRAPH_PROJECT_DIR=$env_vars_parent_path/../..
export JANUS_GRAPH_SCRIPTS_DIR=$JANUS_GRAPH_PROJECT_DIR/scripts

# TODO all other script files should use these same vars by using `. ../setup/env-vars.sh`
