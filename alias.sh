cls() { cd "$1"; ls; };
backup() { cp "$1"{,.bak}; };
md5check() { md5sum "$1"|grep "$2"; };
sbs() { du -sm $1|sort -n; };
psg() { ps aux|grep $1; };
listen() { lsof -P -i -n $1; };
histg() { history|grep $1; };
glogger() { git log|grep -B4 $1; };
makescript() { fc -rnl -999|head -$1 > $2; };

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
