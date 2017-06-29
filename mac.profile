# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
#
#
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

ORDERFILE="$HOME/order.log"
echo $(date +%Y.%m.%d-$H:$M:$S) >> $ORDERFILE
echo "$0 .profile	start" >> $ORDERFILE

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    echo "out to	.bashrc" >> $ORDERFILE
    my_OS=$(uname)                                  #`expr "$OSTYPE" : '\(^[^\.]*\)'`
    export $my_OS
    echo $my_OS
    if [ -f $HOME/.bashrc ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d $HOME/bin ] ; then
    PATH="$HOME/bin:$PATH"
fi

##
# Your previous /Users/sherr1/.profile file was backed up as /Users/sherr1/.profile.macports-saved_2016-10-06_at_16:02:35
##

# MacPorts Installer addition on 2016-10-06_at_16:02:35: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/libexec/gnubin/:/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# Adding an appropriate PATH variable for use with MySQL
export PATH="/usr/local/mysql-5.7.17-macos10.12-x86_64/bin:$PATH"

if [ -f $HOME/.bash_prompt ]; then
    # include .bash_prompt if it exists
    echo "out to	.bash_prompt" >> $ORDERFILE
    . "$HOME/.bash_prompt"
fi

if [ -f $HOME/.bash_functions ]; then
    # include .bash_functions if it exists
    echo "out to	.bash_functions" >> $ORDERFILE
    . "$HOME/.bash_functions"
fi

if [ -f $HOME/.bash_aliases ]; then
    # include .bash_aliases if it exists
    echo "out to	.bash_aliases" >> $ORDERFILE
    . "$HOME/.bash_aliases"
fi


echo "$0 .profile	return" >> $ORDERFILE


export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts

ii

echo "$0 .profile	finish" >> $ORDERFILE



test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
