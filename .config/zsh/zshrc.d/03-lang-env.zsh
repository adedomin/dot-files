[[ -n $XDG_CONFIG_HOME/zsh/lang-env/*.zsh ]] && {
    for f in $XDG_CONFIG_HOME/zsh/lang-env/*.zsh; do
        source $f
    done
}
