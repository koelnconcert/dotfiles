# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

source_if() {
  [ -f $1 ] && source "$1"
}

# if running bash
if [ -n "$BASH_VERSION" ]; then
  source_if "$HOME/.bashrc"
fi

add_to_path() {
  [ -d "$1" ] && PATH="$PATH:$1"
}

add_to_path "$HOME/bin"
add_to_path "$HOME/apps/.bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.local/share/fnm"
add_to_path "$HOME/src/tib/peterss/tib-scripts/bin"
add_to_path "/snap/bin"
