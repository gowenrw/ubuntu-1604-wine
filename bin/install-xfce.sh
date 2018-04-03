#!/usr/bin/env bash

### Exit script on error
set -e

echo "Install Xfce4"
apt-get install -y xfce4 xfce4-terminal
#xfce4-goodies <-nice but not req and add lots of size
apt-get purge -y pm-utils xscreensaver*

