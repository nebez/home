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

# if on a mac keyboard layout (hid_apple), install below patched apple kernel module
# https://github.com/free5lot/hid-apple-patched

# And on a mac mouse (hid_magicmouse), use below options in /etc/modprobe.d/hid_magicmouse.conf:
# options hid_magicmouse emulate_3button=N
# options hid_magicmouse scroll-speed=45
# options hid_magicmouse scroll-acceleration=1
