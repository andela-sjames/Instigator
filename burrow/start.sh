#!/bin/sh
echo "=========start burrow==========="
exec $GOPATH/bin/Burrow --config-dir /etc/burrow "${@}"
echo "=========starting burrow========"
