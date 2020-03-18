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

# load vcs_info plugin
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats $'%s\0%r\0%b\0%R\0/%S'
zstyle ':vcs_info:*' actionformats $'%s\0%r\0%b\0%R\0/%S'

precmd() {
    local last_exit=$?

    case $last_exit in
        0) last_exit="${green_exit}${last_exit}$reset_color" ;;
        *) last_exit="${red_exit}${last_exit}$reset_color" ;;
    esac

    vcs_info
    local curr_dir="${PWD/#$HOME/~}"

    if [[ -n $vcs_info_msg_0_ ]]; then
        local vcs_infos=(${(ps:\0:)vcs_info_msg_0_})
        local vcs_type=${vcs_infos[1]}
        local repo=${vcs_infos[2]}
        local branch=${vcs_infos[3]}
        local parent_dir="${vcs_infos[4]}/"
        local lpath="${vcs_infos[5]#/}/"

        if [[ $vcs_type == 'git' ]]; then
            local vcs_changes=']─['
            # porcelain v1 output has different meanings during a merge
            if [[ -f $parent_dir/.git/MERGE_HEAD ]]; then
                vcs_changes+='MERGE'
            else
                integer untracked=0
                integer staged=0
                integer unstaged=0
                git status --porcelain=v1 | \
                while IFS= read -r st; do
                    case ${st:0:2} in
                        '??') untracked+=1 ;;
                        ?' ') staged+=1 ;;
                        ' '?) unstaged+=1 ;;
                        ??)   staged+=1; unstaged+=1 ;;
                    esac
                done
                vcs_changes+="S(${fg[green]}$staged$reset_color) "
                vcs_changes+="U(${fg[yellow]}$unstaged$reset_color) "
                vcs_changes+="N(${fg[red]}$untracked$reset_color)"
                COLOR_SIZE=$(( COLOR_SIZE + 6 ))
            fi
        fi

        local right_var="$parent_dir]
├─[${vcs_type}://${repo}:${branch}]─[${lpath}"
    else
        local right_var="$curr_dir"
    fi

    local left="┌─[$USER_P@$HOST_P]─[${last_exit}${vcs_changes}]─[$right_var]"
    if (( ${#left} - COLOR_SIZE >= COLUMNS )); then
        left="┌─[$USER_P@$HOST_P]─[$last_exit${vcs_changes}]
├─[$right_var]"
    fi

    print -r -- $left
}
PROMPT="└─> "
