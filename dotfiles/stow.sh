#!/bin/bash
dotfiles=/home/jasonw/.git/jwos-dotfilesv2/dotfiles

# Stow home files
cd $dotfiles/home
stow . -t /home/jasonw/
# Stow etc files
cd $dotfiles/root/etc
sudo stow . -t /etc/
