upath=($XDG_CONFIG_HOME/zsh/util-bin ~/.local/bin)
path=($upath $XDG_DATA_HOME/yarn/bin $path)
export JAVA_FONTS=/usr/share/fonts/TTF
# needed for some apps
export COLORTERM=gnome-terminal

setopt autocd
setopt extendedglob
setopt kshglob
bindkey -v

# stuff like $(( abs(-1) ))
zmodload zsh/mathfunc
