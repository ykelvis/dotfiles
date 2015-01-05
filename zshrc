export ZSH=$HOME/.oh-my-zsh
#ZSH_THEME="agnoster"
CASE_SENSITIVE="false"
DISABLE_AUTO_UPDATE="true"
HIST_STAMPS="yyyy-mm-dd"
#ZSH_THEME="gentoo"
plugins=(git autojump systemd taskwarrior)
source $ZSH/oh-my-zsh.sh

autoload -U colors && colors
autoload -U compinit&&compinit -u
autoload -U promptinit&&promptinit
autoload -U edit-command-line

[[ -s /etc/profile.d/autojump.sh ]] && . /etc/profile.d/autojump.sh
export PATH=$HOME/git/dotfiles/scripts:$HOME/.local/bin/node_modules/.bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/vendor_perl:/usr/bin/core_perl
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

function prompt_char {
    if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

PROMPT='%{$fg_bold[green]%}%n@%m%{$fg_bold[blue]%}%~$(git_prompt_info)%(?,%{$fg_bold[white]%},%{$fg_bold[red]%})%_$(prompt_char)%{$reset_color%} '
RPROMPT='%{$fg_bold[white]%}%*%{$reset_color%}'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[red]%}%B✘%b%F{154}%f%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✔%F{154}"
#命令提示符
#for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
#eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
#eval $color='%{$fg[${(L)color}]%}'
#(( count = $count + 1 ))
#done
#FINISH="%{$terminfo[sgr0]%}"
#RPROMPT=$(echo "%{\e[1;32m%}%*$FINISH")
#PROMPT=$(echo "%n%{\e[1;32m%}@%{\e[1;37m%}%M%{\e[1;31m%}:%~>$FINISH ")
#PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p%{$fg[cyan]%}%d %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$reset_color%}>'

#ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
#ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

bindkey '^U' backward-kill-line
bindkey '^Y' yank

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
#setopt INTERACTIVE_COMMENTS     
setopt AUTO_CD
setopt complete_in_word 
setopt AUTO_LIST
setopt AUTO_MENU
#setopt MENU_COMPLETE

#禁用 core dumps
limit coredumpsize 0
 
#Emacs风格 键绑定
bindkey -e
#bindkey -v
#设置 [DEL]键 为向后删除
bindkey "\e[3~" delete-char
 
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
eval $(dircolors -b)
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
#}}}
 
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
hash -d a="/tmp"
hash -d s="/tmp/N"
hash -d dt="$HOME/git/dotfiles"
hash -d gt="$HOME/git"
#}}}
 
 
#{{{自定义补全
#补全 ping
zstyle ':completion:*:ping:*' hosts 192.168.1.{1,50,51,100,101} www.google.com www.baidu.com
 
#补全 ssh scp sftp 等
#zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
#}}}

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

#
alias ls="ls --color"
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
alias pacqo='pacman -Qo'
alias pacqs='pacman -Qs'
alias pacqdt="pacman -Qdt"
alias pacscc="sudo pacman -Scc"
alias pacql="pacman -Ql"
alias pacdexp="pacman -D --asexp"
alias pacddep="pacman -D --asdep"
alias pacsdeps='sudo pacman -S --asdeps'
alias pacqtdq="pacman -Qtdq > /dev/null && sudo pacman -Rns \$(pacman -Qtdq | sed -e ':a;N;$!ba;s/\n/ /g')"


alias yaog='yaourt -G'
alias yaob='yaourt -B'
alias yaoqbak='yaourt -Q --backupfile'
alias yaosyua='yaourt -Syua --devel '
#
alias splitmusic='cue2tracks -R -c flac -o "%n - %t" "$@" *.cue'
alias pm25='sed -n "2p" $HOME/.weather/pm25.history|cut -d"(" -f1'
alias dstatt='dstat -cdlmnpsy'

alias proxy="env http_proxy=localhost:8118 https_proxy=localhost:8118"
alias proxyset="export http_proxy=localhost:8118;export https_proxy=localhost:8118"
alias wallpaper="find ~/.wallpaper -type f \( -name '*.jpg' -o -name '*.png' \) -print0 |shuf -n1 -z | xargs -0 feh --bg-fill"
#alias urxvtc='urxvtc "$@";if [ $? -eq 2 ]; then urxvtd -q -o -f; urxvtc "$@";fi'

#[[ -z "$TMUX" ]] && exec tmux
alias tm="$HOME/Dropbox/scripts/tm;tmux attach-session -t work"
alias hdon="xrandr --output HDMI-0 --auto --left-of LVDS-0"
alias hdoff="xrandr --output HDMI-0 --off"
alias xx="startx"
alias mc="ncmpcpp"
alias wow="LC_ALL='zh_CN.UTF-8' wine ~/WOW/Wow-64.exe -opengl"
alias ovpn="cd $HOME/Downloads/config;sudo openvpn --config ipv4.ovpn;cd -"
alias svpnon="sudo shadowvpn -c $HOME/Downloads/shadowvpn/client.conf  -s start"
alias svpnoff="sudo shadowvpn -c $HOME/Downloads/shadowvpn/client.conf  -s stop"

alias b1="archlinuxcn-x86_64-build"
alias b2="archlinuxcn-i686-build"
alias getold="pacman -Sl archlinuxcn | awk '{print \$2, \$3}' > old_ver.txt"
alias checknew="nvchecker nvchecker.ini"
alias shownew="nvcmp nvchecker.ini"
unset GREP_OPTIONS
