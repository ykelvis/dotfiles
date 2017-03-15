unset GREP_OPTIONS
limit coredumpsize 0
autoload -U colors && colors
autoload -U compinit&&compinit -u
autoload -U promptinit&&promptinit
autoload -U edit-command-line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload predict-on
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt AUTO_CD
setopt complete_in_word
setopt AUTO_LIST
setopt AUTO_MENU
#setopt MENU_COMPLETE
#setopt SHARE_HISTORY

export HISTSIZE=99999
export SAVEHIST=99999
export HISTFILE=~/.zhistory
export TERM="xterm-256color"
export EDITOR=vim
export CASE_SENSITIVE="false"
export DISABLE_AUTO_UPDATE="true"
export HIST_STAMPS="yyyy-mm-dd"
export HOMEBREW_BUILD_FROM_SOURCE=1
export PATH=$HOME/.scripts:$HOME/.local/bin/node_modules/.bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/bin/vendor_perl:/usr/bin/core_perl

OS=${$(uname)%_*}
if [[ $OS == "CYGWIN" || $OS == "MSYS" ]]; then
  OS=Linux
elif [[ $OS == "Darwin" ]]; then
  OS=Darwin
fi

if [[ $LANG == "C"  || $LANG == "" ]]; then
    >&2 echo "$fg[red]The \$LANG variable is not set. This can cause a lot of problems.$reset_color"
fi

eval "$(fasd --init auto)"
export ZSH_FOLDER=~/.zsh
ls -al $ZSH_FOLDER &>/dev/null&&
for i in $ZSH_FOLDER/*.zsh;do
    source $i;
done

[[ -s $HOME/.perl5/etc/bashrc ]] && source $HOME/.perl5/etc/bashrc
which brew&>/dev/null&&[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]]&&. $(brew --prefix)/etc/profile.d/autojump.sh
[[ -s /etc/profile.d/autojump.sh ]]&&. /etc/profile.d/autojump.sh

bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey '^U' backward-kill-line
bindkey '^Y' yank
bindkey -e
bindkey "\e[3~" delete-char
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
zle -N edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

#prompt
local _time="%{$fg[yellow]%}[%*]"
local _path="%{$fg[magenta]%}%(8~|...|)%7~"
local _usercol
if [[ $EUID -lt 1000 ]]; then
    # red for root, magenta for system users
    _usercol="%(!.%{$fg[red]%}.%{$fg[green]%})"
else
    _usercol="$fg[cyan]"
fi
local _user="%{$_usercol%}%n@%M:"
local _prompt="%{$fg[white]%}$"

PROMPT="$_time$_user$_path$_prompt%b%f%k "

setopt prompt_subst
# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg[red]%}●%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg[yellow]%}●%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg[green]%}●%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}
# Show different symbols as appropriate for various Git repository states
parse_git_state() {
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""
  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi
  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi
  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi
  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi
  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}
# If inside a Git repository, print its branch and state
git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
}
# Set the right-hand prompt
RPROMPT='$(git_prompt_string)'
if [[ ! -z "$SSH_CLIENT" ]]; then
    RPROMPT="$RPROMPT ⇄" # ssh icon
fi

zstyle ':completion:*' menu select
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 2 numeric
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _match #_user_expand
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct

#kill 命令补全     
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'
 
# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

user-complete(){
case $BUFFER in
"" )                    
BUFFER="cd "
zle end-of-line
zle expand-or-complete
;;
* )
zle expand-or-complete
;;
esac
}
zle -N user-complete
bindkey "\t" user-complete
#}}}
 
sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
zle end-of-line
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

#hash -d s="/tmp/N"
zstyle ':completion:*:ping:*' hosts 192.168.1. 192.168.0. 10. 1.2.4.8 www.google.com www.baidu.com

#alias
mcd(){ mkdir -p "$1"; cd "$1" }
cls(){ cd "$1"; ls; }
backup(){ cp "$1"{,.bak}; }
md5check(){ md5sum "$1"|grep -i "$2"; }
sha512check(){ shasum -a 512 "$1"|grep -i "$2"; }
psg(){ ps aux | grep -v grep | grep -i -e VSZ -e "$1" }
listen(){ $1 lsof -P -i -n|grep LISTEN; }
histg(){ fc -il 1|grep $1; }
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
    local api
    case "$1" in
        "-4")
            api="http://v4.ipv6-test.com/api/myip.php"
            ;;
        "-6")
            api="http://v6.ipv6-test.com/api/myip.php"
            ;;
        *)
            #api="http://ipv6-test.com/api/myip.php"
            api="http://myip.ipip.net"
            ;;
    esac
    curl -s "$api"
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
    (
    mkdir -p /tmp/radar/;cd /tmp/radar
    curl -s --compressed "http://products.weather.com.cn/product/radar/index/procode/JC_RADAR_AZ9010_JB" | grep -Eo 'http://pi.weather.com.cn/i/product/pic/l[^"]+'|sort|uniq|tail -20|xargs wget -q
    convert -delay 50 -loop 0 *.png radar.gif
    mv radar.gif ~/Desktop
    rm -rf /tmp/radar
    )
}
export TODOTXT_DEFAULT_ACTION=ls
alias t='todo.sh'
tad(){da=`date +%Y-%m-%d`;t add $da $@}
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
alias -s conf=vim
alias -s log="less -MN"
alias -g gp="|grep -i"
alias cr="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias ll="ls -l"
alias l="ls -al"
alias vi="vim"
alias aria2c="aria2c --file-allocation=none"
alias mp="ncmpcpp"
alias vmarch="VBoxManage startvm arch --type headless"
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

#osx
if [[ $OS == 'Darwin' ]]; then
    unset -f archcnck
    alias keyoff="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
    alias keyon="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
    alias ls='ls -G'
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
    alias genpasswd="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"
fi

MACHINE_TYPE=`uname -m`
SYS_TYPE=`uname -s`
if [[ $OS == "Darwin" ]]; then
    alias gost="gost-osx-64"
else
    if [[ ${MACHINE_TYPE} == "x86_64" ]]; then
        alias gost="gost-linux-64"
    else
        alias gost="gost-linux-32"
    fi
fi

unset OS MACHINE_TYPE SYS_TYPE
