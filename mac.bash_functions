# Functions
# #########

if [ "${ORDERFILE}" != '' ];then
    echo "$0 .bash_functions        Start" >> $ORDERFILE
fi


# Some example functions
function settitle() { echo -ne "\033]2;$@\a\033]1;$@\a"; }

function sudofunc() { echo -e "\n${BRed}SUDO FUNCTION${NC}"; }

function stealfocus() { echo -e "\033]1337;StealFocus\x7"; }

function exists() {
	for i; do
		which $i >/dev/null 2>&1 || return 1
	done
	return 0
}

function fexists() {
	for i; do
		if [ ! -e $1 ]; then
			return 1
		fi
	done
	return 0
}

function check_agent ()
{
	if exists ssh-agent; then
		if [[ -z $SSH_AUTH_SOCK ]]; then
			if [[ -f ~/.agent.env ]]; then
				. ~/.agent.env -s > /dev/null
				if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
					ssh-agent -s > ~/.agent.env
					. ~/.agent.env > /dev/null 2>&1
				fi
			else
				ssh-agent -s > ~/.agent.env
				. ~/.agent.env > /dev/null 2>&1
			fi
		fi
	fi
}

function _exit()			  # Function to run upon exit of shell.
{
	echo -e "${BRed}Hasta la vista, baby${NC}"
}
trap _exit EXIT

# Returns system load as percentage, i.e., '40' rather than '0.40)'.
function load()
{
	if [[ "$SAHOS" != darwin15 ]]; then
		local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
	else
		local SYSLOAD=$(sysctl -n vm.loadavg | cut -d " " -f2 | tr -d '.')
	fi
	# System load of the current host.
	echo $((10#$SYSLOAD))	   # Convert to decimal.
}

# Returns a color indicating system load.
function load_color()
{
	local SYSLOAD=$(load)
	if [ ${SYSLOAD} -gt ${XLOAD} ]; then
		echo -en ${ALERT}
	elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
		echo -en ${Red}
	elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
		echo -en ${BRed}
	else
		echo -en ${Green}
	fi
}

# Returns a color according to free disk space in $PWD.
function disk_color()
{
	if [ ! -w "${PWD}" ] ; then
		echo -en ${Red}
		# No 'write' privilege in the current directory.
	elif [ -s "${PWD}" ] ; then
		local used=$(command df -P "$PWD" | 
					awk 'END {print $5}' | 
					tr -d "%")
#					cut -d "%" -f1)
		if [ ${used} -gt 95 ]; then
			echo -en ${ALERT}		   # Disk almost full (>95%).
		elif [ ${used} -gt 90 ]; then
			echo -en ${BRed}			# Free disk space almost gone.
		else
			echo -en ${Green}		   # Free disk space is ok.
		fi
	else
		echo -en ${Cyan}
		# Current directory is size '0' (like /proc, /sys etc).
	fi
}

# Returns a color according to running/suspended jobs.
function job_color()
{
	if [[ "$SAHOS" = darwin15 ]]; then
		if [ $(jobs -s | wc -l | cut -d " " -f8) -gt "0" ]; then
			echo -en ${BRed}
		elif [ $(jobs -r | wc -l | cut -d " " -f8) -gt "0" ] ; then
			echo -en ${BCyan}
		fi
	else
		if [ $(jobs -s | wc -l) -gt "0" ]; then
			echo -en ${BRed}
		elif [ $(jobs -r | wc -l) -gt "0" ] ; then
			echo -en ${BCyan}
		fi
	fi	
}

#-------------------------------------------------------------
# A few fun ones
#-------------------------------------------------------------

# Adds some text in the terminal frame (if applicable).

function xtitle()
{
	case "$TERM" in
		*term* | rxvt)
			echo -en  "\033]0;$*\a" ;;
		*)  ;;
	esac
}


# Aliases that use xtitle
alias top='xtitle Processes on $HOST && top'
alias make='xtitle Making $(basename $PWD) ; make'

# .. and functions
function man()
{
	for i ; do
		xtitle The $(basename $1|tr -d .[:digit:]) manual
		command man -a "$i"
	done
}


#-------------------------------------------------------------
# Make the following commands run in background automatically:
#-------------------------------------------------------------

function te()  # wrapper around xemacs/gnuserv
{
	if [ "$(gnuclient -batch -eval t 2>&-)" == "t" ]; then
	   gnuclient -q "$@";
	else
	   ( xemacs "$@" &);
	fi
}

function soffice() { command soffice "$@" & }
function firefox() { command firefox "$@" & }
function xpdf() { command xpdf "$@" & }


#-------------------------------------------------------------
# File & strings related functions:
#-------------------------------------------------------------


# Find a file with a pattern in name:
function ff() { sudofunc; sudo find . -type f -iname '*'"$*"'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { sudofunc; sudo find . -type f -iname '*'"${1:-}"'*' -exec ${2:-file} {} \;  ; }

#  Find a pattern in a set of files and highlight them:
#+ (needs a recent version of egrep).
function fstr()
{
	OPTIND=1
	local mycase=""
	local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
	while getopts :it opt
	do
		case "$opt" in
		   i) mycase="-i " ;;
		   *) echo "$usage"; return ;;
		esac
	done
	shift $(( $OPTIND - 1 ))
	if [ "$#" -lt 1 ]; then
		echo "$usage"
		return;
	fi
	sudofunc
	sudo find . -type f -name "${2:-*}" -print0 | xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more

}


function swap()
{ # Swap 2 filenames around, if they exist (from Uzi's bashrc).
	local TMPFILE=tmp.$$

	[ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
	[ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
	[ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

	mv "$1" $TMPFILE
	mv "$2" "$1"
	mv $TMPFILE "$2"
}

function puff()	  # Handy Extract Program
{
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)	tar xvjf $1		;;
			*.tar.gz)	tar xvzf $1		;;
			*.bz2)		bunzip2 $1		;;
			*.rar)		unrar x $1		;;
			*.gz)		gunzip $1		;;
			*.tar)		tar xvf $1		;;
			*.tbz2)		tar xvjf $1		;;
			*.tgz)		tar xvzf $1		;;
			*.zip)		unzip $1		;;
			*.Z)		uncompress $1   ;;
			*.7z)		7z x $1			;;
			*)			echo "'$1' cannot be extracted via >puff<" ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}


# Creates an archive (*.tar.gz) from given directory.
function maketar() { gnutar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder.
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

# Make your directories and files access rights sane.
function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}


#-------------------------------------------------------------
# SSH and SCP  related functions:
#-------------------------------------------------------------

# SCP a single file to all Network Intelligence Lab boxes into the /home/saherr dir
function scpdist()
{
	for i in {5..8}
	do
		echo nie0$i
		scp $1 nie0$i:$1
	done
	for i in {1..2}
	do
		echo sde0$i
		scp $1 sde0$i:$1
	done
}

#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------


function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps -f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }


function killps()   # kill by process name
{
	local pid pname sig="-TERM"   # default signal
	if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
		echo "Usage: killps [-SIGNAL] pattern"
		return;
	fi
	if [ $# = 2 ]; then sig=$1 ; fi
	for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} )
	do
		pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
		if ask "Kill process $pid <$pname> with signal $sig?"
			then kill $sig $pid
		fi
	done
}

function my_df()		 # Pretty-print of 'df' output.
{					   # Inspired by 'dfc' utility.
	for fs ; do

		if [ ! -d $fs ]
		then
		  echo -e $fs" :No such file or directory" ; continue
		fi

		local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
		local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
		local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
		local out="["
		for ((j=0;j<20;j++)); do
			if [ ${j} -lt ${nbstars} ]; then
			   out=$out"*"
			else
			   out=$out"-"
			fi
		done
		out=${info[2]}" "$out"] ("$free" free on "$fs")"
		echo -e $out
	done
}


function my_ip() # Get IP adress on ethernet.
{
	if   [[ "$SAHOS" = cygwin ]]; then
		MY_IP=$(ipconfig | awk '/IPv4 Address/ {print $14}')
	elif [[ "$SAHOS" = darwin15 ]]; then
		MY_IP=$(ipconfig getifaddr en0)
		if [[ "$MY_IP" == "" ]]; then
			MY_IP=$(ipconfig getifaddr en2)
		fi
	else
		MY_IP=$(/sbin/ifconfig eth1 | awk '/inet/ { print $2 } ' | sed -e s/addr://)
		if [[ "$MY_IP" == "" ]]; then
			MY_IP=$(/sbin/ifconfig eth2 | awk '/inet/ { print $2 } ' | sed -e s/addr://)
		fi
	fi
	echo ${MY_IP:-"Not connected"}
}

alias meminfo='free -m -l -t'

function ii()   # Get current host related info.
{
	if [[ "$SAHOS" != cygwin ]]; then
		clear
		echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan} - DISPLAY on ${BRed}$DISPLAY${NC}\n"
		if exists fortune; then
			fortune -s     # Makes our day a bit more fun.... :-)
		fi
		echo -e "\n${BRed}Current date:$NC\t\t" `date`
		echo -e "${BRed}You are logged on:$NC\t $HOSTNAME"
		echo -e "${BRed}Local IP Address:$NC\t "`my_ip`
		echo -e "${BRed}Machine Info:$NC\t\t" `uname -a|cut -c1-80`
		echo -e "${BRed}Machine stats:$NC\t\t"`uptime`
		if [[ "$SAHOS" != darwin15 ]]; then
			echo -e "\n${BRed}Users logged on:$NC" ; w -hs | cut -d " " -f1 | sort | uniq
		else
			echo -e "\n${BRed}Users logged on:$NC" ; w -h | cut -d " " -f1 | sort | uniq
		fi
		echo -e "\n${BRed}Memory stats:$NC" ; meminfo
		if [[ "$HOSTNAME" = nie08mpwdco ]]; then
                        echo -e "\n${BRed}Diskspace:$NC" ; my_df / $HOME /data
                else
                        echo -e "\n${BRed}Diskspace:$NC" ; my_df / $HOME
                fi
#		echo -e "\n${BRed}Open connections:$NC "; netstat -pan --inet;
		echo
	else
		cls
		echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan} - DISPLAY on ${BRed}$DISPLAY${NC}\n"
		if exists /usr/games/fortune; then
			/usr/games/fortune -s     # Makes our day a bit more fun.... :-)
		fi
		echo -e "${BRed}Current date:$NC " `date`
		echo -e "${BRed}You are logged on:$NC $HOSTNAME"
		echo -e "${BRed}Local IP Address:$NC" `my_ip`
		echo -e "${BRed}Machine Info:$NC "`uname -a| cut -c1-80`
		echo -e "\n${BRed}Diskspace:$NC " ; my_df / $HOME
#               echo -e "\n${BRed}Users logged on:$NC " ; w -hs | cut -d " " -f1 | sort | uniq
#               echo -e "\n${BRed}Machine stats:$NC " ; uptime
#               echo -e "\n${BRed}Memory stats:$NC " ; free
#               echo -e "\n${BRed}Open connections:$NC "; netstat -anp TCP;
                echo
	fi
}

#-------------------------------------------------------------
# Misc utilities:
#-------------------------------------------------------------

function repeat()	   # Repeat n times command.
{
	local i max
	max=$1; shift;
	for ((i=1; i <= max ; i++)); do  # --> C-like syntax
		eval "$@";
	done
}


function ask()		  # See 'killps' for example of use.
{
	echo -n "$@" '[y/n] ' ; read ans
	case "$ans" in
		y*|Y*) return 0 ;;
		*) return 1 ;;
	esac
}

function corename()   # Get name of app that created a corefile.
{
	for file ; do
		echo -n $file : ; gdb --core=$file --batch | head -1
	done
}


function get_xserver ()
{
	case $TERM in
		xterm )
			XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
			# Ane-Pieter Wieringa suggests the following alternative:
			 # I_AM=$(who am i)
			 # SERVER=${I_AM#*(}
			 # SERVER=${SERVER%*)}
			XSERVER=${XSERVER%%:*}
			;;
		aterm | rxvt)
			# Find some code that works here. ...
			;;
	esac
}

function legend ()
{
	echo " TIME:"
	echo -e "    ${Green}Green${NC}     == machine load is low"
	echo -e "    ${Orange}Orange${NC}    == machine load is medium"
	echo "    Red       == machine load is high"
	echo "    ALERT     == machine load is very high"
	echo " USER:"
	echo "    Cyan      == normal user"
	echo "    Orange    == SU to user"
	echo "    Red       == root"
	echo " HOST:"
	echo "    Cyan      == local session"
	echo "    Green     == secured remote connection (via ssh)"
	echo "    Red       == unsecured remote connection"
	echo " PWD:"
	echo "    Green     == more than 10% free disk space"
	echo "    Orange    == less than 10% free disk space"
	echo "    ALERT     == less than 5% free disk space"
	echo "    Red       == current user does not have write privileges"
	echo "    Cyan      == current filesystem is size zero (like /proc)"
	echo " >:"
	echo "    White     == no background or suspended jobs in this shell"
	echo "    Cyan      == at least one background job in this shell"
	echo "    Orange    == at least one suspended job in this shell"
}


# Opens a new tab in the current Terminal window and optionally executes a command.
# When invoked via a function named 'newwin', opens a new Terminal *window* instead.
newtab() {

    # If this function was invoked directly by a function named 'newwin', we open a new *window* instead
    # of a new tab in the existing window.
    local funcName=$FUNCNAME
    local targetType='tab'
    local targetDesc='new tab in the active Terminal window'
    local makeTab=1
    case "${FUNCNAME[1]}" in
        newwin)
            makeTab=0
            funcName=${FUNCNAME[1]}
            targetType='window'
            targetDesc='new Terminal window'
            ;;
    esac

    # Command-line help.
    if [[ "$1" == '--help' || "$1" == '-h' ]]; then
        cat <<EOF
Synopsis:
    $funcName [-g|-G] [command [param1 ...]]

Description:
    Opens a $targetDesc and optionally executes a command.

    The new $targetType will run a login shell (i.e., load the user's shell profile) and inherit
    the working folder from this shell (the active Terminal tab).
    IMPORTANT: In scripts, \`$funcName\` *statically* inherits the working folder from the
    *invoking Terminal tab* at the time of script *invocation*, even if you change the
    working folder *inside* the script before invoking \`$funcName\`.

    -g (back*g*round) causes Terminal not to activate, but within Terminal, the new tab/window
      will become the active element.
    -G causes Terminal not to activate *and* the active element within Terminal not to change;
      i.e., the previously active window and tab stay active.

    NOTE: With -g or -G specified, for technical reasons, Terminal will still activate *briefly* when
    you create a new tab (creating a new window is not affected).

    When a command is specified, its first token will become the new ${targetType}'s title.
    Quoted parameters are handled properly.

    To specify multiple commands, use 'eval' followed by a single, *double*-quoted string
    in which the commands are separated by ';' Do NOT use backslash-escaped double quotes inside
    this string; rather, use backslash-escaping as needed.
    Use 'exit' as the last command to automatically close the tab when the command
    terminates; precede it with 'read -s -n 1' to wait for a keystroke first.

    Alternatively, pass a script name or path; prefix with 'exec' to automatically
    close the $targetType when the script terminates.

Examples:
    $funcName ls -l "\$Home/Library/Application Support"
    $funcName eval "ls \\\$HOME/Library/Application\ Support; echo Press a key to exit.; read -s -n 1; exit"
    $funcName /path/to/someScript
    $funcName exec /path/to/someScript
EOF
        return 0
    fi

    # Option-parameters loop.
    inBackground=0
    while (( $# )); do
        case "$1" in
            -g)
                inBackground=1
                ;;
            -G)
                inBackground=2
                ;;
            --) # Explicit end-of-options marker.
                shift   # Move to next param and proceed with data-parameter analysis below.
                break
                ;;
            -*) # An unrecognized switch.
                echo "$FUNCNAME: PARAMETER ERROR: Unrecognized option: '$1'. To force interpretation as non-option, precede with '--'. Use -h or --h for help." 1>&2 && return 2
                ;;
            *)  # 1st argument reached; proceed with argument-parameter analysis below.
                break
                ;;
        esac
        shift
    done

    # All remaining parameters, if any, make up the command to execute in the new tab/window.

    local CMD_PREFIX='tell application "Terminal" to do script'

        # Command for opening a new Terminal window (with a single, new tab).
    local CMD_NEWWIN=$CMD_PREFIX    # Curiously, simply executing 'do script' with no further arguments opens a new *window*.
        # Commands for opening a new tab in the current Terminal window.
        # Sadly, there is no direct way to open a new tab in an existing window, so we must activate Terminal first, then send a keyboard shortcut.
    local CMD_ACTIVATE='tell application "Terminal" to activate'
    local CMD_NEWTAB='tell application "System Events" to keystroke "t" using {command down}'
        # For use with -g: commands for saving and restoring the previous application
    local CMD_SAVE_ACTIVE_APPNAME='tell application "System Events" to set prevAppName to displayed name of first process whose frontmost is true'
    local CMD_REACTIVATE_PREV_APP='activate application prevAppName'
        # For use with -G: commands for saving and restoring the previous state within Terminal
    local CMD_SAVE_ACTIVE_WIN='tell application "Terminal" to set prevWin to front window'
    local CMD_REACTIVATE_PREV_WIN='set frontmost of prevWin to true'
    local CMD_SAVE_ACTIVE_TAB='tell application "Terminal" to set prevTab to (selected tab of front window)'
    local CMD_REACTIVATE_PREV_TAB='tell application "Terminal" to set selected of prevTab to true'

    if (( $# )); then # Command specified; open a new tab or window, then execute command.
            # Use the command's first token as the tab title.
        local tabTitle=$1
        case "$tabTitle" in
            exec|eval) # Use following token instead, if the 1st one is 'eval' or 'exec'.
                tabTitle=$(echo "$2" | awk '{ print $1 }') 
                ;;
            cd) # Use last path component of following token instead, if the 1st one is 'cd'
                tabTitle=$(basename "$2")
                ;;
        esac
        local CMD_SETTITLE="tell application \"Terminal\" to set custom title of front window to \"$tabTitle\""
            # The tricky part is to quote the command tokens properly when passing them to AppleScript:
            # Step 1: Quote all parameters (as needed) using printf '%q' - this will perform backslash-escaping.
        local quotedArgs=$(printf '%q ' "$@")
            # Step 2: Escape all backslashes again (by doubling them), because AppleScript expects that.
        local cmd="$CMD_PREFIX \"${quotedArgs//\\/\\\\}\""
            # Open new tab or window, execute command, and assign tab title.
            # '>/dev/null' suppresses AppleScript's output when it creates a new tab.
        if (( makeTab )); then
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active tab after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_SAVE_ACTIVE_TAB" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$cmd in front window" -e "$CMD_SETTITLE" -e "$CMD_REACTIVATE_PREV_APP" -e "$CMD_REACTIVATE_PREV_TAB" >/dev/null
                else
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$cmd in front window" -e "$CMD_SETTITLE" -e "$CMD_REACTIVATE_PREV_APP" >/dev/null
                fi
            else
                osascript -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$cmd in front window" -e "$CMD_SETTITLE" >/dev/null
            fi
        else # make *window*
            # Note: $CMD_NEWWIN is not needed, as $cmd implicitly creates a new window.
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active window after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_WIN" -e "$cmd" -e "$CMD_SETTITLE" -e "$CMD_REACTIVATE_PREV_WIN" >/dev/null
                else
                    osascript -e "$cmd" -e "$CMD_SETTITLE" >/dev/null
                fi
            else
                    # Note: Even though we do not strictly need to activate Terminal first, we do it, as assigning the custom title to the 'front window' would otherwise sometimes target the wrong window.
                osascript -e "$CMD_ACTIVATE" -e "$cmd" -e "$CMD_SETTITLE" >/dev/null
            fi
        fi        
    else    # No command specified; simply open a new tab or window.
        if (( makeTab )); then
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active tab after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_SAVE_ACTIVE_TAB" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$CMD_REACTIVATE_PREV_APP" -e "$CMD_REACTIVATE_PREV_TAB" >/dev/null
                else
                    osascript -e "$CMD_SAVE_ACTIVE_APPNAME" -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" -e "$CMD_REACTIVATE_PREV_APP" >/dev/null
                fi
            else
                osascript -e "$CMD_ACTIVATE" -e "$CMD_NEWTAB" >/dev/null
            fi
        else # make *window*
            if (( inBackground )); then
                # !! Sadly, because we must create a new tab by sending a keystroke to Terminal, we must briefly activate it, then reactivate the previously active application.
                if (( inBackground == 2 )); then # Restore the previously active window after creating the new one.
                    osascript -e "$CMD_SAVE_ACTIVE_WIN" -e "$CMD_NEWWIN" -e "$CMD_REACTIVATE_PREV_WIN" >/dev/null
                else
                    osascript -e "$CMD_NEWWIN" >/dev/null
                fi
            else
                    # Note: Even though we do not strictly need to activate Terminal first, we do it so as to better visualize what is happening (the new window will appear stacked on top of an existing one).
                osascript -e "$CMD_ACTIVATE" -e "$CMD_NEWWIN" >/dev/null
            fi
        fi
    fi

}

# Opens a new Terminal window and optionally executes a command.
newwin() {
    newtab "$@" # Simply pass through to 'newtab', which will examine the call stack to see how it was invoked.
}

if [ "${ORDERFILE}" != '' ];then
    echo "$0 .bash_functions        Stop" >> $ORDERFILE
fi
