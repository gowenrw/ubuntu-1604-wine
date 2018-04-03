#!/usr/bin/env bash

### Exit script on error
set -e

echo "Download TigerVNC server binary"
wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /

echo "Set the TigerVNC Password"
PASSWD_PATH="$HOME/.vnc/passwd"
mkdir $HOME/.vnc
echo "$MYPSD" | vncpasswd -f >> $PASSWD_PATH 
chmod 600 $PASSWD_PATH

