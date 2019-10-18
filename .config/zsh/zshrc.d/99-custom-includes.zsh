# source customizations
[[ -n $XDG_CONFIG_HOME/zsh/custom/*(#qN) ]] && {
    for f in $XDG_CONFIG_HOME/zsh/custom/*.zsh; do
        source $f
    done
}
