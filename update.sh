#!/bin/sh
base=$HOME/.git/jwos-dotfilesv2

# Update repo
cd $base
git add -A 
git commit -m 'automatic script update'
git push

# Run stow commands
sudo $base/stow.sh

# Copy Xsessions
sudo cp $base/xsessions/* /usr/share/xsessions/

# Copy icons
sudo cp -r $base/icons/* /usr/share/icons/
