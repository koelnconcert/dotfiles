#!/bin/bash

# auto lock on sleep
exec xss-lock slock &

# systray
exec nm-applet &
exec pasystray &
exec glipper &
exec fdpowermon &
exec gtk-redshift &
exec system-config-printer-applet &

# others
exec dropbox start &
exec conky &
autorandr -c

# window manager
exec awesome
