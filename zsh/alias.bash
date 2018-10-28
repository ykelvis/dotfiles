OS=`uname`
if [[ $OS == "CYGWIN" || $OS == "MSYS" ]]; then
  OS=Linux
elif [[ $OS == "Darwin" ]]; then
  OS=Darwin
fi
SHELL=`ps -p $$ -oargs=`
if [[ $SHELL == "bash" ]]; then
    SHELL=Bash
else
    SHELL=zsh
    alias -s conf=vim
    alias -s log="less -MN"
    alias -g gp="|grep -i"
fi

256tab(){
    for k in `seq 0 1`;do
        for j in `seq $((16+k*18)) 36 $((196+k*18))`;do
            for i in `seq $j $((j+17))`; do
                printf "\e[01;$1;38;5;%sm%4s" $i $i;
            done;echo;
        done;
    done
}

show_256_colours() {
    for i in {0..255} ; do
    printf "\x1b[38;5;${i}m%3d " "${i}"
    if (( $i == 15 )) || (( $i > 15 )) && (( ($i-15) % 12 == 0 )); then
        echo;
    fi
    done
}
bin-exist(){[[ -n ${commands[$1]} ]]}
#man page to pdf
(bin-exist ps2pdf) && man2pdf() {  man -t ${1:?Specify man as arg} | ps2pdf -dCompatibility=1.3 - - > ${1}.pdf; }

#help command for builtins
help() { man zshbuiltins | sed -ne "/^       $1 /,/^\$/{s/       //; p}"}

(bin-exist ffmpeg) && extract_mp3() { ffmpeg -i $1 -acodec libmp3lame -metadata TITLE="$2" ${2// /_}.mp3 }

# ssh over proxy
nc_ssh(){
    local ip=$1
    local SHELL=/bin/zsh
    ssh -q -o ConnectTimeout=10 \
           -o StrictHostKeyChecking=no root@${ip} \
           -o "ProxyCommand=/usr/bin/nc -x 127.0.0.1:8081 %h %p"
}

cut_video(){
    local start=$1
    local end=$2 # -to 00:03
    local filename=$3
    ffmpeg -ss ${start} -to ${end} -i "${filename}" -vcodec copy -acodec copy output.mp4
}

log(){
    echo -e "[$(date --rfc-3339=seconds)]: $*"
}

calc(){ awk "BEGIN{ print $* }" ; }
mcd(){ mkdir -p "$1"; cd "$1"; }
cls(){ cd "$1"; ls; }
backup(){ cp "$1"{,.bak}; }
md5check(){ md5sum "$1"|grep -i "$2"; }
sha256check(){ shasum -a 256 "$1"|grep -i "$2"; }
sha512check(){ shasum -a 512 "$1"|grep -i "$2"; }
psg(){ ps aux | grep -v grep | grep -i -e VSZ -e "$1"; }
listen(){ $1 lsof -P -i -n|grep LISTEN; }
histg(){ fc -il 1|grep $*; }
glogger(){ git log|grep -B4 $1; }
makescript(){ fc -rnl -999|head -$1 > $2; }
extract(){ 
    if [ -f $1 ] ; then 
      case $1 in
        *.tar.bz2)   tar xjf $1     ;; 
        *.tar.gz)    tar xzf $1     ;; 
        *.bz2)       bunzip2 $1     ;; 
        *.rar)       unrar e $1     ;; 
        *.gz)        gunzip $1      ;; 
        *.tar)       tar xf $1      ;; 
        *.tbz2)      tar xjf $1     ;; 
        *.tgz)       tar xzf $1     ;; 
        *.zip)       unzip $1       ;; 
        *.Z)         uncompress $1  ;; 
        *.7z)        7z x $1        ;; 
        *)     echo "'$1' cannot be extracted via extract()" ;; 
         esac 
     else
         echo "'$1' is not a valid file"
     fi 
}
dusort (){
    du -sm "$@" | sort -n
}
sdu(){
    du -k $@| sort -n | awk '
         BEGIN {
            split("KB,MB,GB,TB", Units, ",");
         }
         {
            u = 1;
            while ($1 >= 1024) {
               $1 = $1 / 1024;
               u += 1
            }
            $1 = sprintf("%.1f %s", $1, Units[u]);
            print $0;
         }'
}
ipip(){
    local api pipe
    case "$1" in
        "-4")
            api="http://v4.ipv6-test.com/api/myip.php"
            ;;
        "-6")
            api="http://v6.ipv6-test.com/api/myip.php"
            ;;
        "-q")
            api="http://freeapi.ipip.net/$2"
            pipe="|jq"
            ;;
        "-v")
            api="https://api.ip.sb/geoip/$2"
            pipe="|jq"
            ;;
        *)
            #api="http://ipv6-test.com/api/myip.php"
            api="http://myip.ipip.net"
            ;;
    esac
    sh -c "curl -s ${api} ${pipe}"
}
screen2clipboard () { # 截图到剪贴板 {{{2
  if [[ $OS == "Darwin" ]]; then
      local fname="Screen Shot `date +%Y-%m-%d` at `date +%I.%M.%S` `date +%p`"
      screencapture "$fname"
      pbcopy < "$fname"
  else
      import png:- | xclip -i -selection clipboard -t image/png
  fi
}
mvgb () { # 文件名从 GB 转码，带确认{{{2
  for i in $*; do
    local new="`echo $i|iconv -f utf8 -t latin1|iconv -f gbk`"
    echo $new
    echo -n 'Sure? '
    read -q ans && mv -i $i $new
    echo
  done
}
w_radar(){
    local p
    local d=`pwd`
    mkdir -p /tmp/radar/;cd /tmp/radar
    if [[ -z ${1} ]]; then
        curl -s "http://bjweather.iyuebo.com/weather.php?a=rs" | jq -r '.redar[] | "\(.imgname)"'|xargs -I {} wget -q "http://bjweather.iyuebo.com/real_weather/radar/{}"
    else
        p=$1
        curl -s --compressed "http://products.weather.com.cn/product/radar/index/procode/${p}.shtml" | grep -Eo 'http://pi.weather.com.cn/i/product/pic/l[^"]+'|sort|uniq|grep -v 20170823033600000|tail -10|xargs wget -q
    fi
    convert -delay 30 -loop 0 *.png radar.gif
    mv radar.gif ~/Desktop
    rm -rf /tmp/radar
    cd $d
}
export TODOTXT_DEFAULT_ACTION=ls
alias t='todo.sh'
tad(){
    local da=${date '+%Y-%m-%d'};
    t add $da $@;
}
proxy_on() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

    if [[ $1 == "-p" ]]; then
        echo -n "username: "; read username
        if [[ $username != "" ]]; then
            echo -n "password: "
            read -es password
            local pre="$username:$password@"
        fi
        echo -n "server: "; read server
        echo -n "port: "; read port
        export http_proxy="http://$pre$server:$port/"
    elif (( $# > 0 )); then
        valid=$(echo $@ | sed 's/\([0-9]\{1,3\}.\)\{4\}:\([0-9]\+\)/&/p')
        if [[ $valid != $@ ]]; then
            >&2 echo "Invalid address"
            return 1
        fi
        export http_proxy="http://$1/"
    elif (( $# == 0 )); then
        export http_proxy="http://127.0.0.1:8080"
    fi

    export all_proxy=$http_proxy
    export https_proxy=$http_proxy
    export ftp_proxy=$http_proxy
    export rsync_proxy=$http_proxy
    export ALL_PROXY=$http_proxy
    export HTTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export FTP_PROXY=$http_proxy
    export RSYNC_PROXY=$http_proxy
    echo "Proxy environment variable set."
}

proxy_off(){
    unset no_proxy
    unset all_proxy
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
    unset rsync_proxy
    unset ALL_PROXY
    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset FTP_PROXY
    unset RSYNC_PROXY
    echo -e "Proxy environment variable removed."
}
archcnck(){
    local name owner
    echo "cheking new version..."
    pacman -Sl archlinuxcn | awk '{print $2, $3}' > old_ver.txt&&nvchecker nvchecker.ini&&nvcmp nvchecker.ini > /tmp/checklog
    echo "getting details"
    detail=`pacman -Slq archlinuxcn|xargs pacman -Si|grep -Eo '(^Name|^Packager).*'`
    while read cont;do 
        name=`echo $cont|cut -d" " -f1`;
        owner=`echo $detail|grep -E "Name\s*:\s*${name}$" -A1|grep -E "^Packager"|cut -d':' -f2`
        printf $cont;echo $owner;
    done < /tmp/checklog
}
#useful functions
alias history='fc -il 1'
alias cr="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias meminf="ps -eo rss,pmem,pcpu,vsize,args |  sort -k 1 -r -n | less"
alias ll="ls -l"
alias llt='ls -alhtr'
alias lls='ls -alhSr'
alias l="ls -al"
alias vi="vim"
alias aria2c="aria2c --file-allocation=none"
alias mp="ncmpcpp"
alias vmarch="VBoxManage startvm arch --type headless"
alias genpasswd="sh -c 'cat /dev/urandom | env LC_CTYPE=C tr -dc a-zA-Z0-9 | head -c 100'"
#fasd
alias v="f -e vim"
alias m="f -e open"
alias a="fasd -a"         #any
alias s="fasd -si"        #show / search / select
alias d="fasd -d"         #directory
alias f="fasd -f"         #file
alias sd="fasd -sid"      #interactive directory selection
alias sf="fasd -sif"      #interactive file selection
alias c="fasd_cd -d"
alias cc="fasd_cd -d -i"
# alias and listing colors
alias -g A="|awk"
alias -g B='|sed -r "s:\x1B\[[0-9;]*[mK]::g"'       # remove color, make things boring
alias -g C="|wc"
alias -g E="|sed"
alias -g G='|GREP_COLOR=$(echo 3$[$(date +%N)%6+1]'\'';1;7'\'') egrep -i --color=always'
alias -g H="|head -n $(($LINES-2))"
alias -g L="|less"
alias -g P="|column -t"
alias -g R="|tac"
alias -g S="|sort"
alias -g T="|tail -n $(($LINES-2))"
alias -g X="|xargs"
alias -g N="> /dev/null"
alias -g NF="./*(oc[1])"      # last modified(inode time) file or directory
#ssh-indent
alias sshi="ssh-ident"
#osx
if [[ $OS == "Darwin" ]]; then
    command -v reattach-to-user-namespace&&alias mpv='reattach-to-user-namespace mpv'
    unset -f archcnck
    alias keyoff="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
    alias keyon="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
    alias ls='ls -G'
    alias shuf="gshuf"
else
    alias ls='ls --color=auto'
    alias pacsy='sudo pacman -Sy'
    alias pacsyu='sudo pacman -Syu'
    alias pacsyy='sudo pacman -Syy'
    alias pacsyyu='sudo pacman -Syyu'
    alias pacs='sudo pacman -S'
    alias pacsw='sudo pacman -Sw'
    alias pacu='sudo pacman -U'
    alias pacr='sudo pacman -R'
    alias pacrns='sudo pacman -Rns'
    alias pacrscn='sudo pacman -Rscn'
    alias pacsi='pacman -Sii'
    alias pacss='pacman -Ss'
    alias pacqi='pacman -Qi'
    alias pacql="pacman -Ql"
    alias pacqo='pacman -Qo'
    alias pacqs='pacman -Qs'
    alias pacqdt="pacman -Qdt"
    alias pacscc="sudo pacman -Scc"
    alias pacdexp="pacman -D --asexp"
    alias pacddep="pacman -D --asdep"
    alias pacsdeps='sudo pacman -S --asdeps'
    alias pacqtdq="pacman -Qtdq > /dev/null && sudo pacman -Rns \$(pacman -Qtdq | sed -e ':a;N;$!ba;s/\n/ /g')"
    alias yaog='yaourt -G'
    alias yaob='yaourt -B'
    alias yaos='yaourt -S'
    alias yaoqdt='yaourt -Qdt'
    alias yaoss='yaourt -Ss'
    alias yaoqbak='yaourt -Q --backupfile'
    alias yaosyua='yaourt -Syua --devel '
    alias splitmusic='cue2tracks -R -c flac -o "%n - %t" "$@" *.cue'
    alias dstatt='dstat -cdlmnpsy'
    alias wallpaper="find ~/.wallpaper -type f \( -name '*.jpg' -o -name '*.png' \) -print0 |shuf -n1 -z | xargs -0 feh --bg-fill"
    alias hdon="xrandr --output HDMI-0 --auto --left-of LVDS-0"
    alias hdoff="xrandr --output HDMI-0 --off"
    alias wow="LC_ALL='zh_CN.UTF-8' wine ~/WOW/Wow-64.exe -opengl"
    alias b1="archlinuxcn-x86_64-build"
    alias b2="archlinuxcn-i686-build"
    alias b3="mv *pkg.tar.xz ~/repo"
fi

MACHINE_TYPE=`uname -m`
SYS_TYPE=`uname -s`
if [[ $OS == "Darwin" ]]; then
    alias gost="gost-osx64"
    alias cow="cow-osx64"
    alias gotop="gotop-osx64"
    alias glider="glider-osx64"
else
    if [[ ${MACHINE_TYPE} == "x86_64" ]]; then
        alias gost="gost-linux64"
        alias cow="cow-linux64"
        alias gotop="gotop-linux64"
        alias glider="glider-linux64"
    else
        alias gost="gost-linux32"
        alias cow="cow-linux32"
        alias gotop="gotop-linux32"
        alias glider="glider-linux32"
    fi
fi

