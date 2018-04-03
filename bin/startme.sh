#!/bin/bash

### Exit script on error
set -e

# Start SSHD server
/usr/sbin/sshd -D &

# Need to set the bash environment up for vnc to inherit
source $HOME/.bashrc

# Start NOVNC Server
echo "Starting noVNC Server..."
echo "$HOME/noVNC/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT "
$HOME/noVNC/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT &

# Start VNC Server
vncserver -kill $DISPLAY || rm -rfv /tmp/.X*-lock /tmp/.X11-unix || echo "remove old vnc locks to be a reattachable container"
echo "Starting VNC Server..."
echo "vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION "
vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION

## either tail the vnc log or pass through a different command
echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with ThisContainerIP:$VNC_PORT"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://ThisContainerIP:$NO_VNC_PORT/?password=...\n"
if [ -z "$1" ] || [[ $1 =~ -t|--tail-log ]]; then
    # if option `-t` or `--tail-log` block the execution and tail the VNC log
    echo -e "\n------------------ $HOME/.vnc/*$DISPLAY.log ------------------"
    tail -f $HOME/.vnc/*$DISPLAY.log
else
    # unknown option ==> call command
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '$@'"
    exec "$@"
fi
