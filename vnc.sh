#!/bin/bash
while [ 1 ]
do
  ps -fe|grep Xtightvnc |grep -v grep
  if [ $? -ne 0 ]
  then
  echo "start vnc ..."
  rm -f /tmp/.X1-lock
  rm -f /tmp/.X11-unix/X1
  /usr/bin/vncserver :1 -geometry 1280x800 -depth 24
  else
  echo "vnc is running"
  fi
  sleep 30
 done
