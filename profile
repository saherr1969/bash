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

ORDERFILE="${HOME}/order.log"
echo -e '\n\n'$(date +%Y.%m.%d-%H:%M:%S) >> ${ORDERFILE}
echo ".profile  	start" >> ${ORDERFILE}

export my_OS=$(uname)
echo   ${my_OS}

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f ${HOME}/.bashrc ]; then
        echo "out to	    .bashrc" >> ${ORDERFILE}
	. "${HOME}/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d ${HOME}/bin ] ; then
    export PATH="${HOME}/bin:${PATH}"
fi

if   [[ "${my_OS}" = Darwin ]]; then
    # MacPorts Access
    export PATH="/opt/local/libexec/gnubin/:/opt/local/bin:/opt/local/sbin:$PATH"
    # MySQL Access
    export PATH="/usr/local/mysql-5.7.17-macos10.12-x86_64/bin:$PATH"
fi

for fname in prompt functions aliases
do
    BFNAME=${HOME}"/.bash_"${fname}
    # include various .bash_XXXXXXXX files if the exist
    if [ -f ${BFNAME} ]; then
        echo "out to        ${BFNAME}" >> ${ORDERFILE}
        . ${BFNAME}
        echo ".profile	return" >> ${ORDERFILE}
    fi
done

#-------------------------------------------------------------
## Display checking
#-------------------------------------------------------------

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) || ${XSERVER} == "unix" ]]; then
        DISPLAY=":0.0"          # Display on local host.
    else
        DISPLAY=${XSERVER}:0.0     # Display on remote host.
    fi
fi

export DISPLAY

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

echo ".profile	finish" >> ${ORDERFILE}

ii

