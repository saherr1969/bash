#########################################
## SSH aliases                         ##
#########################################

if [ "${ORDERFILE}" != '' ];then
    echo "$0 .bash_aliases         Start" >> $ORDERFILE
fi


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
#    for j in {1..5}
#    do
#        alias nie$i$j='ssh nie'$i$j''
#        alias n$i$j='nie'$i$j
#    done
done

alias ssh='liner;ssh'
alias rasp='ssh rasp'
alias n5nie='ssh n5nie'
alias mcp='ssh mcp'
alias reno='ssh reno'
alias vmtroot='ssh root@vmt '
alias vmt6root='ssh root@vmt-dnvr '
alias wam='ssh wam'
alias wam2='liner;~/.ssh/scripts/wam2.expect'
alias wamlab='ssh wamlab'

alias sshhosts='\grep -E "^Host [^\*]|HostName|User " ~/.ssh/config | less -N'

alias wamgetmysql='/Users/sherr1/Desktop/NIE/WAM\ Project/wam_mysql_data/wam_mysql_data_collector > ~/Desktop/NIE/WAM\ Project/wam_mysql_data/wam_mysql_data_$(date +%Y%m%d%H%M%S).txt'
alias wamgetblade='/Users/sherr1/Desktop/NIE/WAM\ Project/wam_blade_info_collector'
alias wambladenet='cd ~/Desktop/NIE/WAM\ Project/wam_blade_info;rm -f port_usage.csv;grep -E "java|mysql" *.txt|./wam_blade_info_sed > port_usage.csv'

alias sshutsonusdev='sshuttle --pidfile=/tmp/sshuttle.pid -Dr sa 172.16.40.96/29'
alias sshutx='[[ -f /tmp/sshuttle.pid ]] && kill $(cat /tmp/sshuttle.pid) && echo "Disconnected."'

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
#    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -h --file-type --color=auto --group-directories-first'
    alias ll='ls -lv'                       #  Long display with natural sort order by version number
    alias lx='ls -XB'                       #  Sort by extension.
    alias lk='ls -Sr'                       #  Sort by size, biggest last.
    alias lt='ls -tr'                       #  Sort by date, most recent last.
    alias lc='ls -tcr'                      #  Sort by/show change time,most recent last.
    alias lu='ls -tur'                      #  Sort by/show access time,most recent last.
    alias lm='ls -lv|less'                #  Pipe through 'less'
    alias l.='ls -lvd .*'                   #  Show only . files and directories.
    alias lr='ls -R'            #  Recursive ls.
    alias la='ls -al'            #  Show hidden files.
    alias ldir='ls -ld -- */'            #  Show only directories
    if exists tree;then
        alias tree='tree -CAsuh --dirsfirst'        #  Nice alternative to 'recursive ls' ...
    fi

    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

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

if [[ "$my_OS" = Darwin ]]; then
    alias fixlync='rm -f /Users/sherr1/Library/Keychains/OC_KeyContainer__stephen.herr\@charter.com\-db'
fi

alias h='history'

alias innot='ssh -t nie08 "innotop";exit'

alias j='jobs -l'

alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias mkdir='mkdir -pv'

alias mysql='/usr/local/mysql/bin/mysql -p'

if [[ "$my_OS" != Darwin ]]; then
    alias mount='mount |column -t'
fi

alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

alias path='echo -e ${PATH//:/\\n}'

alias taildir='tail -fn +1 $(ls -1tr|tail -1)'

alias vnc='vncserver -geometry 1680x1050 -depth 24 -NeverShared -localhost'
alias vncstatus='ps -fp $(pgrep -d, vnc)'
alias vnckill='vncserver -kill :1'

alias whence='type -a'                        # where, of a sort
alias which='type -a'

# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
        if [[ "$my_OS" != Darwin ]]; then
            alias ports='sudo netstat -antpul'
            alias portslisten='sudo netstat -antpul|grep LIST'
        else
            alias ports='sudo netstat -an -f inet'
            alias portslisten="sudo lsof -nP |\grep -E 'UDP|TCP'|\grep -vE 'CLOSED|\->'|awk '{print \$3, \$1, \$5, \$8\":\"\$9}'|sort -k3,4|uniq|column -t"
            alias npm='sudo npm'
            alias netstat='sudo netstat'
        fi
fi

if exists curl; then
        # get web server headers #
        alias header='curl -I'

        # find out if remote server supports gzip / mod_deflate or not #
        alias headerc='curl -I --compress'
fi

# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -i --preserve-root'
 
# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
 
# Parenting changing perms on / #
alias chown='sudo chown --preserve-root'
alias chmod='sudo chmod --preserve-root'
alias chgrp='sudo chgrp --preserve-root'

# top is atop, just like vi is vim
if exists atop; then
    alias top='atop'
elif exists htop; then
        alias top='htop -d 5'
fi

#### Network Aliases ####
if [[ "$my_OS" != cygwin ]]; then
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
if exists iptables; then
        alias ipt='sudo /sbin/iptables'

        # display all rules #
        alias iptlist='ipt -L -n -v --line-numbers'
        alias iptlistin='ipt -L INPUT -n -v --line-numbers'
        alias iptlistout='ipt -L OUTPUT -n -v --line-numbers'
        alias iptlistfw='ipt -L FORWARD -n -v --line-numbers'
        alias firewall='iptlist'
fi


# distro specific  - Redhat #
# install with apt-get
if [[ "$my_OS" == Redhat ]]; then
    alias apt-get='sudo apt-get'
    alias updatey='sudo apt-get --yes'
    # update on one command
    alias update='sudo apt-get update && sudo apt-get upgrade'
elif [[ "$my_OS" = Darwin ]]; then
    alias pip='sudo -H pip'
    alias pipupdate="pip freeze --local|sed -rn 's/^([^=#\t\\][^t=]*)=.*/echo; echo Processing \1 ...; sudo -H pip install -U \1/p'|sh"
    alias port='sudo port'
    alias portupdate='port selfupdate && port installed outdated && port upgrade outdated && port -q reclaim'
    alias portset='port select --set'
    alias portsetlist='port select --summary'
fi


# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'
if exists poweroff; then
        alias poweroff='sudo /sbin/poweroff'
fi


if exists mplayer; then
    ## play video files in a current directory ##
    # cd ~/Download/movie-name
    # playavi
    alias playavi='mplayer *.avi'

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
fi

if exists vlc; then
    ## play video files in a current directory ##
    # cd ~/Download/movie-name
    # vlc
    alias vlc='vlc *.avi'
fi

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
if exists free; then
    alias meminfo='free -m -l -t'
fi

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

if [ "${ORDERFILE}" != '' ];then
    echo "$0 .bash_aliases         Stop" >> $ORDERFILE
fi
