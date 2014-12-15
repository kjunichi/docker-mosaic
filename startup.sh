#!/bin/bash
export DISPLAY=:1
Xvfb :1 -screen 0 1280x1024x16 -ac &
openbox-session&
Mosaic &
x11vnc -display :1 -bg -usepw -listen localhost -xkb -ncache 10 -ncache_cr -forever
cd /root/noVNC && ./utils/launch.sh --vnc localhost:5900
