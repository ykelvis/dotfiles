unset GREP_OPTIONS
limit coredumpsize 0
autoload -U colors && colors
autoload -U compinit&&compinit -u
autoload -U promptinit&&promptinit
autoload -U edit-command-line
export EDITOR=vim
export HISTSIZE=99999
export SAVEHIST=99999
export HISTFILE=~/.zhistory
export TERM="xterm-256color"
CASE_SENSITIVE="false"
DISABLE_AUTO_UPDATE="true"
HIST_STAMPS="yyyy-mm-dd"
alias history='fc -il 1'

if [[ $LANG == "C"  || $LANG == "" ]]; then
    >&2 echo "$fg[red]The \$LANG variable is not set. This can cause a lot of problems.$reset_color"
fi

export ZSH_FOLDER=~/.zsh
[[ -s $ZSH_FOLDER/fasd ]]&&eval "$(fasd --init auto)"
ls -al $ZSH_FOLDER &>/dev/null&&
for i in $ZSH_FOLDER/*.zsh;do
    source $i;
done

export HOMEBREW_BUILD_FROM_SOURCE=1
export PATH=$HOME/.scripts:$HOME/.local/bin/node_modules/.bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/bin/vendor_perl:/usr/bin/core_perl

[[ -s $HOME/.perl5/etc/bashrc ]] && source $HOME/.perl5/etc/bashrc
which brew&>/dev/null&&[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]]&&. $(brew --prefix)/etc/profile.d/autojump.sh
[[ -s /etc/profile.d/autojump.sh ]]&&. /etc/profile.d/autojump.sh

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

zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey '^U' backward-kill-line
bindkey '^Y' yank
bindkey -e
bindkey "\e[3~" delete-char

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

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
RPROMPT='${vcs_info_msg_0_}'
if [[ ! -z "$SSH_CLIENT" ]]; then
    RPROMPT="$RPROMPT ⇄" # ssh icon
fi

# Git plugin/prompt
setopt promptsubst
autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:(git*):*" get-revision true
zstyle ":vcs_info:(git*):*" check-for-changes true

local _branch="%c%u%m %{$fg[green]%}%b%{$reset_color%}"
local _repo="%{$fg[green]%}%r %{$fg[yellow]%}%{$reset_color%}"
local _revision="%{$fg[yellow]%}%.7i%{$reset_color%}"
local _action="%{$fg[red]%}%a%{$reset_color%}"
zstyle ":vcs_info:*" stagedstr "%{$fg[yellow]%}✓%{$reset_color%}"
zstyle ":vcs_info:*" unstagedstr "%{$fg[red]%}✗%{$reset_color%}"
zstyle ":vcs_info:git*" formats "$_branch:$_revision - $_repo"
zstyle ":vcs_info:git*" actionformats "$_branch:$_revision:$_action - $_repo"
zstyle ':vcs_info:git*+set-message:*' hooks git-stash
# Uncomment to enable vcs_info debug mode
# zstyle ':vcs_info:*+*:*' debug true

function +vi-git-stash() {
    if [[ -s "${hook_com[base]}/.git/refs/stash" ]]; then
        hook_com[misc]="%{$fg_bold[grey]%}~%{$reset_color%}"
    fi
}

precmd() {
    vcs_info
}

#自动补全选项
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand_alias _expand _complete _correct _ignored _approximate
zstyle ':completion:*' format '-- %d --'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -e -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' menu select
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
 
#彩色补全菜单
#eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[33m | \e[1;7;32m %d \e[m\e[33m |\e[m' 
zstyle ':completion:*:messages' format $'\e[33m | \e[1;7;32m %d \e[m\e[0;33m |\e[m'
zstyle ':completion:*:warnings' format $'\e[33m | \e[1;7;33m No Matches \e[m\e[0;33m |\e[m'
zstyle ':completion:*:corrections' format $'\e[33m | \e[1;7;35m %d [errors: %e] \e[m\e[0;33m |\e[m'
#错误校正     
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
zstyle ':completion:*:ping:*' hosts 192.168.1.{1,50,51,100,101} www.google.com www.baidu.com

#漂亮又实用的命令高亮界面
setopt extended_glob
 TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')
  
 recolor-cmd() {
     region_highlight=()
     colorize=true
     start_pos=0
     for arg in ${(z)BUFFER}; do
         ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
         ((end_pos=$start_pos+${#arg}))
         if $colorize; then
             colorize=false
             res=$(LC_ALL=C builtin type $arg 2>/dev/null)
             case $res in
                 *'reserved word'*)   style="fg=magenta,bold";;
                 *'alias for'*)       style="fg=cyan,bold";;
                 *'shell builtin'*)   style="fg=yellow,bold";;
                 *'shell function'*)  style='fg=green,bold';;
                 *"$arg is"*)        
                     [[ $arg = 'sudo' ]] && style="fg=red,bold" || style="fg=blue,bold";;
                 *)                   style='none,bold';;
             esac
             region_highlight+=("$start_pos $end_pos $style")
         fi
         [[ ${${TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
         start_pos=$end_pos
     done
 }
check-cmd-self-insert() { zle .self-insert && recolor-cmd }
 check-cmd-backward-delete-char() { zle .backward-delete-char && recolor-cmd }
  
 zle -N self-insert check-cmd-self-insert
 zle -N backward-delete-char check-cmd-backward-delete-char

#alias
#alias ls="ls --color"
alias ll="ls -l"
alias l="ls -al"
alias vi="vim"
alias aria2c="aria2c --file-allocation=none"

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
alias pm25='sed -n "2p" $HOME/.weather/pm25.history|cut -d"(" -f1'
alias dstatt='dstat -cdlmnpsy'

alias wallpaper="find ~/.wallpaper -type f \( -name '*.jpg' -o -name '*.png' \) -print0 |shuf -n1 -z | xargs -0 feh --bg-fill"

alias hdon="xrandr --output HDMI-0 --auto --left-of LVDS-0"
alias hdoff="xrandr --output HDMI-0 --off"
alias mp="ncmpcpp"
alias wow="LC_ALL='zh_CN.UTF-8' wine ~/WOW/Wow-64.exe -opengl"

alias b3="mv *pkg.tar.xz ~/repo"
alias b1="archlinuxcn-x86_64-build"
alias b2="archlinuxcn-i686-build"
alias archcnck="pacman -Sl archlinuxcn | awk '{print \$2, \$3}' > old_ver.txt&&nvchecker archcn.log&&nvcmp archcn.log"
#alias tmux="tmux -2"

#fasd
alias v='f -e vim'
alias m='f -e open'
alias a='fasd -a'         #any
alias s='fasd -si'        #show / search / select
alias d='fasd -d'         #directory
alias f='fasd -f'         #file
alias sd='fasd -sid'      #interactive directory selection
alias sf='fasd -sif'      #interactive file selection
alias z='fasd_cd -d'      #cd, same functionality as j in autojump
alias zz='fasd_cd -d -i'  #cd with interactive selection
alias c='fasd_cd -d'
alias cc='fasd_cd -d -i'

#useful functions
alias genpasswd="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"
alias cr="clear"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
mcd(){ mkdir -p "$1"; cd "$1" }
cls(){ cd "$1"; ls; }
backup(){ cp "$1"{,.bak}; }
md5check(){ md5sum "$1"|grep -i "$2"; }
psg(){ ps aux | grep -v grep | grep -i -e VSZ -e "$1" }
listen(){ $1 lsof -P -i -n|grep LISTEN; }
histg(){ history|grep $1; }
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
myip(){
    local api
    case "$1" in
        "-4")
            api="http://v4.ipv6-test.com/api/myip.php"
            ;;
        "-6")
            api="http://v6.ipv6-test.com/api/myip.php"
            ;;
        *)
            api="http://ipv6-test.com/api/myip.php"
            ;;
    esac
    curl -s "$api"
    echo # Newline.
}
alias keyoff="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
alias keyon="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"

export TODOTXT_DEFAULT_ACTION=ls
alias t='todo.sh'
tad(){da=`date +%Y-%m-%d`;t add $da $@}
