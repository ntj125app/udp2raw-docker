#!/bin/bash

# init PID
pid=0

# SIGTERM signal handlers
sigterm_handler() {
    if [ $pid -ne 0 ]; then
        kill -s SIGTERM $pid
        wait $pid
    fi
    exit 143; # 128 + 15 -- SIGTERM
}

# CTRL + C signal handlers
abort_handler() {
    if [ $pid -ne 0 ]; then
        kill -s SIGTERM $pid
        wait $pid
    fi
    exit 130; # 128 + 2 -- SIGINT
}

trap 'sigterm_handler' SIGTERM
trap 'abort_handler' SIGINT INT

# run application if no ARGS / CMD
if [ $# -eq 0 ] && [ "$MODE" == "server" ]; then
    /udp2raw/udp2raw_amd64 -s -l $LOCALADDR:$LOCALPORT -r $REMOTEADDR:$REMOTEPORT -k $KEY --raw-mode faketcp -a
elif [ $# -eq 0 ] && [ "$MODE" == "client" ]; then
    /udp2raw/udp2raw_amd64 -c -l $LOCALADDR:$LOCALPORT -r $REMOTEADDR:$REMOTEPORT -k $KEY --raw-mode faketcp -a
else
    exec "$@"
fi
