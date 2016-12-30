#########################################
## SSH aliases                         ##
#########################################

echo "$0 .bash_aliases         Start" >> $ORDERFILE


alias liner='echo -en "\n****************************************\n****************************************\n"'

for i in 1 5 6 7 8
do
	alias nie0$i='ssh nie'0$i''
	alias n$i='nie'0$i
	alias nie0$i'p'='ssh nie'0$i'port'
	alias n$i'p'='nie'0$i'p'
done

for i in {1..2}
do
	alias sde$i='ssh sde0'$i''
#	for j in {1..5}
#	do
#		alias nie$i$j='ssh nie'$i$j''
#		alias n$i$j='nie'$i$j
#	done
done

alias ssh='liner;ssh'
alias rasp='ssh rasp'
alias n5nie='ssh n5nie'
alias mcp='ssh n6mcp'
alias reno='ssh reno'
alias vmtroot='ssh root@vmt '
alias wam='ssh wam'
alias wam2='liner;~/.ssh/scripts/wam2.expect'
alias wamlab='ssh wamlab'

alias sshhosts='\grep -E "^Host [^\*]|HostName|User " ~/.ssh/config | less -N'

alias wamgetmysql='/Users/sherr1/Desktop/NIE/WAM\ Project/wam_mysql_data/wam_mysql_data_collector > ~/Desktop/NIE/WAM\ Project/wam_mysql_data/wam_mysql_data_$(date +%Y%m%d%H%M%S).txt'
alias wamgetblade='/Users/sherr1/Desktop/NIE/WAM\ Project/wam_blade_info_collector'
alias wambladenet='cd ~/Desktop/NIE/WAM\ Project/wam_blade_info;rm -f port_usage.csv;grep -E "java|mysql" *.txt|./wam_blade_info_sed > port_usage.csv'


#-------------------
# Voice/MCP Aliases
#-------------------
alias voice8='ssh n8voice'
alias voice6='ssh n6voice'
alias watchmcp="n8 -tt \"/home/voice/src/m/mcp/mcpwatch $1\""

#-------------------
# Personnal Aliases
#-------------------

## a quick way to get out of current directory ##
alias cd~='cd ~'
alias cd..='cd ..'
alias cd1='cd ..'
alias cd2='cd ../../'
alias cd3='cd ../../../'
alias cd4='cd ../../../../'
alias cd5='cd ../../../../../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias cdalias='alias|\grep -E "=.cd \."'

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
#if [ -x /usr/bin/dircolors ]; then
#	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    if [[ "$SAHOS" = darwin14 ]]; then
	    alias ls='gls -hGF --color=auto --group-directories-first'
    elif [[ "$SAHOS" = darwin15 ]]; then
	    alias ls='ls -hGF --color=auto --group-directories-first'
	    # alias ls='ls -hGF'
    else
	    alias ls='ls -hGF --color=auto --group-directories-first'
    fi

	alias ll='ls -lv'
	alias lx='ls -XB'         #  Sort by extension.
	alias lk='ls -Sr'         #  Sort by size, biggest last.
	alias lt='ls -tr'         #  Sort by date, most recent last.
	alias lc='ls -tcr'        #  Sort by/show change time,most recent last.
	alias lu='ls -tur'        #  Sort by/show access time,most recent last.
	alias lm='ls -lv|less'		#  Pipe through 'less'
	alias l.='ls -lvd .*'       #  Show only . files and directories.
	alias lr='ls -R'			#  Recursive ls.
	alias la='ls -A'			#  Show hidden files.
	alias ldir='ls -ld -- */'	# Show only directories
	alias tree='tree -CAsuh'		#  Nice alternative to 'recursive ls' ...

    if [[ "$SAHOS" != darwin15 ]]; then
    	alias dir='dir --color=auto'
	    alias vdir='vdir --color=auto'
    else
    	alias dir='gdir --color=auto'
	    alias vdir='gvdir --color=auto'
    fi

	alias grep='grep -n --color=auto'
	alias fgrep='fgrep -n --color=auto'
	alias egrep='egrep -n --color=auto'
#fi

# install  colordiff package :)
if exists colordiff; then
	alias diff='colordiff'
fi

#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------

alias more='less'
export PAGER=less
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-' # Use this if lesspipe.sh exists.
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\033[01;31m'
export LESS_TERMCAP_md=$'\033[01;31m'
export LESS_TERMCAP_me=$'\033[0m'
export LESS_TERMCAP_se=$'\033[0m'
export LESS_TERMCAP_so=$'\033[01;44;33m'
export LESS_TERMCAP_ue=$'\033[0m'
export LESS_TERMCAP_us=$'\033[01;32m'


#-------------------------------------------------------------
# Spelling typos - highly personnal and keyboard-dependent :-)
#-------------------------------------------------------------

alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'

#-------------------------------------------------------------
# Misc. aliases
#-------------------------------------------------------------

alias c='clear'

alias df='df -H'
alias du='du -ch'

alias e='exit'

alias h='history'

alias innot='ssh -t nie08 "innotop";exit'

alias j='jobs -l'

alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias mkdir='mkdir -pv'

alias mysql='/usr/local/mysql/bin/mysql -p'

if [[ "$SAHOS" != darwin15 ]]; then
	alias mount='mount |column -t'
fi

alias now='date +"%T'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

alias path='echo -e ${PATH//:/\\n}'

alias top='htop'

alias vnc='vncserver -geometry 1680x1050 -depth 24 -NeverShared -localhost'
alias vncstatus='ps -fp $(pgrep -d, vnc)'
alias vnckill='vncserver -kill :1'

alias whence='type -a'						# where, of a sort
alias which='type -a'

# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
	alias reboot='sudo reboot'
	alias update='sudo apt-get upgrade'
fi

# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
	if [[ "$SAHOS" != darwin15 ]]; then
		alias ports="sudo netstat -antpul"
		alias reboot='sudo reboot'
	else
	        alias port='sudo port'
	        alias portupdate='port selfupdate && port upgrade outdated'
	        alias npm='sudo npm'

	        alias netstat='sudo netstat'
	        alias ports='netstat -an -f inet'
	fi
fi

# get web server headers #
alias header='curl -I'

# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

# do not delete / or prompt if deleting more than 3 files at a time #
if [[ "$SAHOS" != darwin15 ]]; then
	alias rm='rm -i --preserve-root'
else
	alias rm='rm -i --preserve-root'
	alias tar="gnutar"
fi

# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# Parenting changing perms on / #
if [[ "$SAHOS" != darwin15 ]]; then
	alias chown='sudo chown --preserve-root'
	alias chmod='sudo chmod --preserve-root'
	alias chgrp='sudo chgrp --preserve-root'
else
	alias chown='sudofunc;sudo chown'
	alias chmod='sudofunc;sudo chmod'
	alias chgrp='sudofunc;sudo chgrp'
fi

# top is atop, just like vi is vim
if exists atop; then
	alias top='atop'
elif exists htop
then
        alias top= htop
fi

#### Network Aliases ####
if [[ "$SAHOS" != cygwin ]]; then
    # Stop after sending 5 ECHO_REQUEST packets #
    alias ping='ping -c 5'
    # Do not wait interval 1 second, go fast #
    alias fastping='ping -c 100 -s.2'
else
    alias ping='ping -n 10'
    alias fastping='ping -n 100 -w 200'
fi



##### iptables Aliases ####
## shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'

# display all rules #
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist


# distro specific  - Redhat #
# install with apt-get
if [[ "$SAHOS" != darwin15 ]]; then
	alias apt-get="sudo apt-get"
	alias updatey="sudo apt-get --yes"
	# update on one command
	alias update='sudo apt-get update && sudo apt-get upgrade'
fi


# reboot / halt / poweroff
if [[ "$SAHOS" != darwin15 ]]; then
	alias reboot='sudo /sbin/reboot'
	alias poweroff='sudo /sbin/poweroff'
	alias halt='sudo /sbin/halt'
	alias shutdown='sudo /sbin/shutdown'
fi

## play video files in a current directory ##
# cd ~/Download/movie-name
# playavi or vlc
alias playavi='mplayer *.avi'
alias vlc='vlc *.avi'

# play all music files from the current directory #
alias playwave='for i in *.wav; do mplayer "$i"; done'
alias playogg='for i in *.ogg; do mplayer "$i"; done'
alias playmp3='for i in *.mp3; do mplayer "$i"; done'

# play files from nas devices #
alias nplaywave='for i in /nas/multimedia/wave/*.wav; do mplayer "$i"; done'
alias nplayogg='for i in /nas/multimedia/ogg/*.ogg; do mplayer "$i"; done'
alias nplaymp3='for i in /nas/multimedia/mp3/*.mp3; do mplayer "$i"; done'

# shuffle mp3/ogg etc by default #
alias music='mplayer --shuffle *'

## All of our servers eth1 is connected to the Internets via vlan / router etc  ##
alias dnstop='dnstop -l 5  eth1'
alias vnstat='vnstat -i eth1'
alias iftop='iftop -i eth1'
alias tcpdump='tcpdump -i eth1'
alias ethtool='ethtool eth1'

# work on wlan0 by default #
# Only useful for laptop as all servers are without wireless interface
alias iwconfig='iwconfig wlan0'

## pass options to free ##
alias meminfo='free -m -l -t'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

## Get server cpu info ##
alias cpuinfo='lscpu'

## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##

## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

## restate xtitle aliases to use aliases if necessary ##
alias top='xtitle Processes on $HOST && top'
alias make='xtitle Making $(basename $PWD) ; make'

###################################
#  Scripts
###################################
alias astart='/home/saherr/www/bin/astart'
alias astop='/home/saherr/www/bin/astop'
alias arestart='/home/saherr/www/bin/arestart'

echo "$0 .bash_aliases         Stop" >> $ORDERFILE
