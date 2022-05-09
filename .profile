# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.local/bin/custom" ] || [ -L "$HOME/.local/bin/custom" ]; then
    PATH="$HOME/.local/bin/custom:$PATH"
fi

# from https://astherier.com/blog/2020/08/run-gui-apps-on-wsl2/
# now wsl2 supports native GUI, so this line is not necessary
# export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0

# change caps lock to ctrl
setxkbmap -option "ctrl:nocaps"
. "$HOME/.cargo/env"
