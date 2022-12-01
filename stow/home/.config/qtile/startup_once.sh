#!/bin/bash
pulseaudio &
picom &
nm-applet & 
volumeicon &
cbatticon &
redshift -l 38.973320:-104.622971 &

flameshot &
discord &
emacs --daemon &

nitrogen --restore &

xmodmap ~/.Xmodmap &
