#!/bin/sh
x11vnc -rfbauth /home/root/.vnc/passwd.txt -forever -nolookup -display :0
