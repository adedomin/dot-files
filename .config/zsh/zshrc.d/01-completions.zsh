fpath=($XDG_DATA_HOME/zsh/completions $XDG_DATA_HOME/zsh-completions/src $fpath)
autoload -U compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION 
