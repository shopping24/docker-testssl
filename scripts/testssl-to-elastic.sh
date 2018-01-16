#!/bin/bash
#
# Source the initdb, then run the testssl.sh script
set -e

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi

. /opt/testssl-scripts/run-initdb

/opt/testssl.sh/testssl.sh --openssl=/usr/bin/openssl --warnings=batch --openssl-timeout=60 --log --json --csv "$@"
