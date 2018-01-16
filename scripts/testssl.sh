#!/bin/bash
#
# Source the initdb, then run the testssl.sh script
set -e

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi

. /opt/testssl-scripts/run-initdb

exec /opt/testssl.sh/testssl.sh --openssl /usr/bin/openssl "$@"
