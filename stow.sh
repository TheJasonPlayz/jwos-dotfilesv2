#!/bin/bash
stow=/home/jasonw/.git/jwos-dotfilesv2/stow

# Stow home files
cd $stow/home
stow . -t /home/jasonw/
# Stow etc files
cd $stow/root/etc
sudo stow . -t /etc/
