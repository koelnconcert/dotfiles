#!/bin/bash

# disable screensaver
xset s off
xset -dpms

# auto lock on sleep
exec xss-lock slock &

# systray
exec nm-applet &
exec pasystray &
exec diodon &
exec fdpowermon &
exec system-config-printer-applet &

# others
exec dropbox start &
exec conky &
autorandr -c

# window manager
exec awesome
