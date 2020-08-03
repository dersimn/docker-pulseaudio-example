#!/bin/bash
set -e

# Build Config
export MO_FALSE_IS_EMPTY=true
mo /etc/pulse/client.conf.mo > /etc/pulse/client.conf

# Run
echo -e "System variables\n--------------"
export
echo -e "Config file\n--------------"
cat /etc/pulse/client.conf
echo -e "Play file\n--------------"
exec mplayer /piano.wav
