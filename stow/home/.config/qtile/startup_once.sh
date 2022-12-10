
#!/bin/bash

# System
pulseaudio &
picom &
nm-applet &
volumeicon &
cbatticon &
redshift -l 38.973320:-104.622971 &

# Apps
flameshot &
discord &
emacs --daemon &

# DE
nitrogen --restore &
xmonadmap ~/.Xmodmap &
