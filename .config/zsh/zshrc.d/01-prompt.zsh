autoload -U colors
autoload -U promptinit
colors
promptinit

# $1 - get hash of string
# common hash algo
color_hash() {
    local LANG=C
    declare -i chr=0 hash=5381 i=1 len=$#1
    # i=1 because zsh indexing
    for (( i=1; i<=len; ++i )); do
        printf -v chr '%d' \'"${1[$i]}"
        hash='((hash << 5) + hash) + chr'
    done
    print -r -- "$(( abs(hash) ))"
}

# $1 - get hash of string
# sdbm hash algo
color_hash2() {
    local LANG=C #8bit char
    declare -i chr=0 hash=0 i=1 len=$#1
    # i=1 because zsh indexing
    for (( i=1; i<=len; ++i )); do
        printf -v chr '%d' \'"${1[$i]}"
        hash='chr + (hash << 6) + (hash << 16) - hash'
    done
    print -r -- "$(( abs(hash) ))"
}

# $1 - string to hash
serv_color() {
    local col_arr=("${(@k)fg}")
    local filter=(white black default)
    # will conflict with colorized terms
    col_arr=("${(@)col_arr:|filter}")
    print -r "${col_arr[$(($(color_hash2 "$1") % ${#col_arr[@]} + 1))]}"
}

PS1_COLOR=$(serv_color "$(hostname)")
#PS1_COLOR=cyan
# BOX: │ ├ ┐ └ ┘ ┌ ┼ ─ ┤ ╵ ╷ ╴ ╶
HOST_P="$(hostname -s)"
USER_P="${fg[$PS1_COLOR]}$USER$reset_color"
red_exit="${fg[red]}"
green_exit="${fg[green]}"
COLOR_SIZE="${fg[$PS1_COLOR]}$reset_color${red_exit}$reset_color"
COLOR_SIZE=${#COLOR_SIZE}

precmd() {
    local last_exit=$?

    case "$last_exit" in
        0) last_exit="${green_exit}${last_exit}$reset_color" ;;
        *) last_exit="${red_exit}${last_exit}$reset_color" ;;
    esac

    local right="${PWD/$HOME/~}"
    local left="┌─[$USER_P@$HOST_P]─[$last_exit]─[$right]"
    if (( ${#left} - COLOR_SIZE >= COLUMNS )); then
        left="┌─[$USER_P@$HOST_P]-[$last_exit]
├─[$right]"
    fi
    print -r -- $left
}
PROMPT="└─> "

