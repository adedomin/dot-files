##SHORT ALIASES##
alias Zconfig='vim ~/.zshrc'
alias Zsource='source ~/.zshrc'
alias Zhistory='cat ~/.zhistory | grep '
alias sudo='sudo '
if type apt 2>/dev/null >&2; then
    alias inst='sudo apt install '
    alias remo='sudo apt remove '
    alias updt='sudo apt update && sudo apt upgrade'
    alias srch='apt search'
elif type dnf 2>/dev/null >&2; then
    alias inst='sudo dnf install '
    alias remo='sudo dnf remove '
    alias updt='sudo dnf update '
    alias srch='dnf search '
    alias what='dnf whatprovides '
elif type yum 2>/dev/null >&2; then
    alias inst='sudo yum install '
    alias remo='sudo yum remove '
    alias updt='sudo yum update '
    alias srch='yum search '
    alias what='yum whatprovides '
elif type pacman 2>/dev/null >&2; then
    alias inst='sudo pacman -S '
    alias ainst='yaourt -S '
    alias remo='sudo pacman -R '
    alias aremo='yaourt -R '
    alias updt='yaourt -Syu '
    alias aupdt='yaourt -Syua '
    alias srch='yaourt -Ss '
fi
alias exe='chmod +x '
alias ls='ls -FCa --color=always '
alias sprungeus="curl -F 'sprunge=<-' http://sprunge.us"
alias clbin="curl -F 'clbin=<-' https://clbin.com"
alias shrug="xclip -i <<< '¯\\_(ツ)_/¯'"

# distros like fedora have a "vimx" for their +clipboard vim
if type vimx 2>/dev/null >&2; then
    alias vim="vimx"
    export EDITOR=vimx
else
    export EDITOR=vim
fi

#1337 aliases
alias clock="watch -t -n 1 'date +%I:%M:%S | figlet'"
#alias fortune='fortune | cowsay'


##FUNCTIONS##
##USE WHEN APPROPRIATE##

# $1 - file
# $2 - channels, comma separated (optional)
# $3 - caption (optional)
ghetty_up() {
    case "$1" in
        -h|--help)
            print -u 2 -r -- \
                'usage: ghetty_up [-l|--list] picture.ext \#channel "caption"'
            return 1
        ;;
        -l|--list)
            curl -sSf 'https://images.ghetty.space/channels' \
            | jq -r '.[] | .'
            return
        ;;
    esac

    curl -sSf 'https://images.ghetty.space/upload' \
        --http1.1 \
        -F "caption=${3}" \
        -F "channel=${2}" \
        -F "file=@${1};type=$(file --mime-type "$1" | grep -Po '(?<=: ).*')" \
    | jq -r '.href'
}

encrypt_file() {
    case "$1" in ''|-h|--help)
        print -u 2 -r -- \
            'usage: encrypt_file target [destination]'
        print -u 2 -r -- \
            'if - is given for target, the contents of STDIN are encrypted.'
        return 1
    esac

    [[ ! -f $1 && $1 != '-' ]] && {
        print -u 2 -r -- "Error: no such file ($1)"
        return 1
    }

    local file=$1
    local dest=$2
    if [[ -z $dest && $file == '-' ]]; then
        dest='-'
    elif [[ -z $dest ]]; then
        dest=${file}.gpg
    fi

    gpg2 --sign --encrypt --output $dest -- $file || {
        print -u 2 -r -- 'Note: set default-recipient-self in ~/.gnupg/gpg.conf'
    }
}

uridecode() {
    # change plus to space
    local uri="${1//+/ }"
    # convert % to hex literal and print
    printf '%b\n' "${uri//\%/\\x}"
}

getmac() {
    ping $1 -c 1 >/dev/null
    ip neigh show $1
}

znc() {
    irssi -c "znc-$1"
}

back () {
    case "$1" in ''|0|*[!0-9]*)
        print -l -u 2 -r -- \
            'usage: back NUMBER' \
            'go back NUMBER directories'
        return 1
    esac

    integer i
    for (( i=0; i<$1; ++i )); do
        cd ..;
    done
}

uriencode() {
    local LANG=C # split letters by 8bit char, should preserve encoding.
    local escaped_query=
    for chr in ${(s::)1}; do
        case $chr in
            [-_.~[:alnum:]]) escaped_query+=$chr ;;
            *) printf -v chr %%%02x "'$chr"; escaped_query+=$chr ;;
        esac
    done
    printf '%s\n' $escaped_query
}

# faster urandom source using openssl
urandom() {
    head \
        --bytes=128 \
        /dev/urandom \
    | base64 \
    | openssl enc -aes-256-ctr \
        -in /dev/zero \
        -nosalt \
        -pass stdin \
        2>/dev/null
}

# $1 - number of bytes of hex to generate
# return - hex string with a minimum length of 2
# default - hex of 16 chars
# see: openssl rand -hex
# randomhex() {
#     head --bytes="${1:-8}" /dev/urandom \
#     | xxd -ps \
#     | tr -d '\n'
#     echo ''
# }

# $1 - get hash of string
# common hash algo
color_hash() {
    declare -i chr hash_val i len
    chr=0
    hash_val=5381
    len=${#1}
    # i=1 because zsh indexing
    for (( i=1; i<=len; ++i )); do
        printf -v chr '%d' \'"${1[$i]}"
        hash_val='((hash_val << 5) + hash_val) + chr'
    done
    echo "$(( abs(hash_val) ))"
}

# $1 - get hash of string
# sdbm hash algo
color_hash2() {
    declare -i chr hash_val i len
    chr=0
    hash_val=0
    len=${#1}
    # i=1 because zsh indexing
    for (( i=1; i<=len; ++i )); do
        printf -v chr '%d' \'"${1[$i]}"
        hash_val='chr + (hash_val << 6) + (hash_val << 16) - hash_val'
    done
    echo "$(( abs(hash_val) ))"
}

# $1 - string to hash
serv_color() {
    local col_arr=("${(@k)fg}")
    local filter=(white black default)
    # will conflict with colorized terms
    col_arr=("${(@)col_arr:|filter}")
    echo "${col_arr[$(($(color_hash2 "$1") % ${#col_arr[@]} + 1))]}"
}

# $* a set of valid maths
calc() {
    gawk --bignum 'BEGIN { print '"$*"' }'
}

# join arguments by common delimiter
# $1 - the delimiter
# ${@:1} - the strings to join
join_by() {
    local IFS="$1"
    shift
    printf '%s\n' "${*}"
}

export PATH=~/.local/bin:~/.local/share/yarn/bin:$PATH
export JAVA_FONTS=/usr/share/fonts/TTF

##ZSH SETTINGS##
setopt autocd
fpath=("$HOME"/.local/share/zsh-completions/src "${fpath[@]}")
autoload -U colors
autoload -U compinit
autoload -U promptinit
colors
promptinit
compinit
bindkey -v
# basic math
zmodload zsh/mathfunc
# bash/ksh style globs
setopt kshglob
setopt no_bare_glob_qual

#ZSH HISTORY#
export HISTSIZE=10000
export HISTFILE="$HOME/.zhistory"
export SAVEHIST=$HISTSIZE
setopt inc_append_history
setopt hist_ignore_all_dups

#ZSH SCRIPTS#
source ~/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
 
#ZSH PROMPT#
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

### XDG - may be defined by gnome or other de
[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z "$XDG_CACHE_HOME"  ]] && export XDG_CACHE_HOME="$HOME/.cache"
[[ -z "$XDG_DATA_HOME"   ]] && export XDG_DATA_HOME="$HOME/.local/share"
[[ -z "$XDG_RUNTIME_DIR" ]] && export XDG_RUNTIME_DIR="$HOME/.local/run"
[[ -z "$XDG_DATA_DIRS"   ]] && export XDG_DATA_DIRS="/usr/share:/usr/local/share:$HOME/.local/share"
[[ -z "$XDG_CONFIG_DIRS" ]] && export XDG_CONFIG_DIRS="/etc/xdg"
# if connected over ssh, look for SSH_AUTH_SOCK in systemd env
[[ -n "$SSH_CLIENT"      ]] && {
    if SSH_AUTH_SOCK="$(
        systemctl --user show-environment \
        | sed -n '
            b start
            :quit
            q 0
            :start
            s/SSH_AUTH_SOCK=//p
            t quit
            $ { q 1 }
        '
    )"; then
        export SSH_AUTH_SOCK
    else
        unset SSH_AUTH_SOCK
    fi
}

# source customizations
for file in $HOME/.zshrc.d/*; do
    source $file
done
