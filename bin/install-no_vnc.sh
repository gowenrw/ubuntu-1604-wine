#!/usr/bin/env bash

### Exit script on error
set -e

echo "Download noVNC (HTML based VNC) server binary"
mkdir -p $HOME/noVNC/utils/websockify
wget -qO- https://github.com/novnc/noVNC/archive/v0.6.2.tar.gz | tar xz --strip 1 -C $HOME/noVNC
# use older version of websockify to prevent hanging connections on offline containers, see https://github.com/ConSol/docker-headless-vnc-container/issues/50
wget -qO- https://github.com/novnc/websockify/archive/v0.6.1.tar.gz | tar xz --strip 1 -C $HOME/noVNC/utils/websockify
chmod +x -v $HOME/noVNC/utils/*.sh
## create index.html to forward automatically to `vnc_auto.html`
ln -s $HOME/noVNC/vnc_auto.html $HOME/noVNC/index.html
