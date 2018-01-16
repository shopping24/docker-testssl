#!/bin/bash
#
# docker-entrypoint for testssl

set -e

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi

# execute command passed in as arguments.
# The Dockerfile has specified the PATH to include
# /opt/testssl-scripts (for our scripts).
exec "$@"
