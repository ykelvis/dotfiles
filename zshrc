export ZSH=$HOME/.oh-my-zsh
CASE_SENSITIVE="false"
DISABLE_AUTO_UPDATE="true"
HIST_STAMPS="yyyy-mm-dd"
#ZSH_THEME="miloshadzic"
plugins=(git autojump systemd taskwarrior)
source $ZSH/oh-my-zsh.sh

autoload -U colors && colors
autoload -U compinit&&compinit -u
autoload -U promptinit&&promptinit
autoload -U edit-command-line

export PATH=$HOME/git/dotfiles/scripts:$HOME/.local/bin/node_modules/.bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/bin/vendor_perl:/usr/bin/core_perl

[[ -s $HOME/.perl5/etc/bashrc ]] && source $HOME/.perl5/etc/bashrc
[[ -s /etc/profile.d/autojump.sh ]] && . /etc/profile.d/autojump.sh

function prompt_char {
    if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

PROMPT='%{$fg_bold[green]%}%n@%m%{$fg_bold[blue]%}%~$(git_prompt_info)%(?,%{$fg_bold[white]%},%{$fg_bold[red]%})%_$(prompt_char)%{$reset_color%} '
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[red]%}%B✘%b%F{154}%f%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✔%F{154}"

zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey '^U' backward-kill-line
bindkey '^Y' yank
bindkey -e
bindkey "\e[3~" delete-char

export EDITOR=vim
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zhistory
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

#禁用 core dumps
limit coredumpsize 0

#以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
#}}}

#自动补全缓存
#zstyle ':completion::complete:*' use-cache on
#zstyle ':completion::complete:*' cache-path .zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd
 
#自动补全选项
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand_alias _expand _complete _correct _ignored _approximate
zstyle ':completion:*' format '-- %d --'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' verbose false
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -e -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' menu select

#路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'
 
#彩色补全菜单
#eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# 补全提示 标题描述 group matches and descriptions
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:descriptions' format $'\e[33m | \e[1;7;32m %d \e[m\e[33m |\e[m' 
zstyle ':completion:*:messages' format $'\e[33m | \e[1;7;32m %d \e[m\e[0;33m |\e[m'
zstyle ':completion:*:warnings' format $'\e[33m | \e[1;7;33m No Matches \e[m\e[0;33m |\e[m'
zstyle ':completion:*:corrections' format $'\e[33m | \e[1;7;35m %d [errors: %e] \e[m\e[0;33m |\e[m'

#修正大小写
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#错误校正     
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

#补全类型提示分组
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'
 
# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
 
##空行(光标在行首)补全 "cd " {{{
user-complete(){
case $BUFFER in
"" )                       # 空行填入 "cd "
BUFFER="cd "
zle end-of-line
zle expand-or-complete
;;
"cd --" )                  # "cd --" 替换为 "cd +"
BUFFER="cd +"
zle end-of-line
zle expand-or-complete
;;
"cd +-" )                  # "cd +-" 替换为 "cd -"
BUFFER="cd -"
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
 
##在命令前插入 sudo 
sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
zle end-of-line
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line
 
#[Esc][h] man 当前命令时，显示简短说明
alias run-help >&/dev/null && unalias run-help
autoload run-help
 
#路径别名 {{{
#进入相应的路径时只要 cd ~xxx
hash -d s="/tmp/N"

#补全 ping
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
alias vi="vim"

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
alias xx="startx"
alias mc="ncmpcpp"
alias wow="LC_ALL='zh_CN.UTF-8' wine ~/WOW/Wow-64.exe -opengl"
alias ovpn="cd $HOME/Downloads/config;sudo openvpn --config ipv4.ovpn;cd -"

alias b3="mv *pkg.tar.xz ~/repo"
alias b1="archlinuxcn-x86_64-build"
alias b2="archlinuxcn-i686-build"
alias archcnck="pacman -Sl archlinuxcn | awk '{print \$2, \$3}' > old_ver.txt&&nvchecker nvchecker.ini&&nvcmp nvchecker.ini"
#alias tmux="tmux -2"
unset GREP_OPTIONS
#export TERM="xterm-256color"

#useful functions
alias genpasswd="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"
alias c="clear"
alias ..='cd ..'
alias ...='cd ../..'
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
mcd() { mkdir -p "$1"; cd "$1" }
cls() { cd "$1"; ls; }
backup() { cp "$1"{,.bak}; }
md5check() { md5sum "$1"|grep -i "$2"; }
psg() { ps aux|grep $1; }
listen() { $1 lsof -P -i -n|grep LISTEN; }
histg() { history|grep $1; }
glogger() { git log|grep -B4 $1; }
makescript() { fc -rnl -999|head -$1 > $2; }

extract() { 
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

alias keyoff="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
alias keyon="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
