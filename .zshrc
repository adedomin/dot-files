ZSH_EXTRA="$HOME/.zshrc.d"
##SHORT ALIASES##
alias Zconfig='vim ~/.zshrc'
alias Zsource='source ~/.zshrc'
alias Zhistory='cat ~/.zhistory | grep '
alias sudo='sudo '
if which apt 2>/dev/null >&2; then
    alias inst='sudo apt install '
    alias remo='sudo apt remove '
    alias updt='sudo apt update && sudo apt upgrade'
    alias srch='apt search'
elif which dnf 2>/dev/null >&2; then
    alias inst='sudo dnf install '
    alias remo='sudo dnf remove '
    alias updt='sudo dnf update '
    alias srch='dnf search '
elif which yum 2>/dev/null >&2; then
    alias inst='sudo yum install '
    alias remo='sudo yum remove '
    alias updt='sudo yum update '
    alias srch='yum search '
elif which pacman 2>/dev/null >&2; then
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

# distros like fedora have a "vimx" for their +clipboard 
# vim
if which vimx 2>/dev/null >&2; then
    alias vim="vimx"
fi

#1337 aliases
alias clock="watch -t -n 1 'date +%I:%M:%S | figlet'"
alias fortune='fortune | cowsay'


##FUNCTIONS##
##USE WHEN APPROPRIATE##

# $1 file path
# $2 channel (optional)
# $3 caption (optional)
ghetty_up() {
    curl 'https://images.ghetty.space/upload' \
         --http1.1 \
         -F "caption=${3}" \
         -F "channel=${2:--nochan-}" \
         -F "file=@${1};type=$(file --mime-type "$1" | grep -Po '(?<=: ).*')" \
         | grep -Po -m 1 '(?<=Redirecting to ).*'
}

uridecode() {
    # change plus to space
    local uri="${1//+/ }"
    # convert % to hex literal and print
    printf '%b\n' "${uri//\%/\\x}"
}

getmac() {
	ping "$1" -c 1 >/dev/null
	ip neigh show "$1"
}

znc() {
    irssi -c "znc-$1"
}

back ()
{
	for x in $(seq "$1");
	do
		cd ..;
	done
}

uriencode() {
    echo -nE "$1" \
    | curl -Gso /dev/null \
        -w '%{url_effective}' \
        --data-urlencode @- '' \
    | cut -c 3-
}

# faster urandom source using openssl
urandom() {
    head --bytes=128 /dev/urandom 2>/dev/null \
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
randomhex() {
    head --bytes="${1:-8}" /dev/urandom \
    | xxd -ps \
    | tr -d '\n'
    echo ''
}

# $1 - get hash of string
# common colored name algo
color_hash() {
    declare -i chr hash_val i len
    chr=0
    hash_val=0
    len=${#1}
    # i=1 because zsh indexing
    for (( i=1; i<len+1; ++i )); do
        printf -v chr '%d' \'"${1[$i]}"
        hash_val='hash_val * 32 - hash_val + chr'
    done
    echo "$hash_val"
}

# $1 - string to hash
serv_color() {
    local COL_ARR=("${(@k)fg}")
    # will conflict with colorized terms
    COL_ARR=(${COL_ARR/white})
    # will conflict with colorized terms
    COL_ARR=(${COL_ARR/black})
    echo "${COL_ARR[$(($(color_hash "$1") % ${#COL_ARR[@]} + 1))]}"
}

export PATH=~/.local/bin:$PATH
export EDITOR=vim
export JAVA_FONTS=/usr/share/fonts/TTF
export GIT_PROMPT_EXECUTABLE="haskell"

##ZSH SETTINGS##
setopt autocd
autoload -U colors 
autoload -U compinit
autoload -U promptinit
colors
promptinit
compinit
bindkey -v

#ZSH HISTORY#
export HISTSIZE=2000 
export HISTFILE="$HOME/.zhistory"
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups

#ZSH SCRIPTS#
source ~/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
 
#ZSH PROMPT#
PS1_COLOR=$(serv_color "$(hostname)")
#PS1_COLOR=cyan
# BOX: │ ├ ┐ └ ┘ ┌ ┼ ─ ┤ ╵ ╷ ╴ ╶
HOST_P="$(hostname -s)"
USER_P="${fg[$PS1_COLOR]}$USER$reset_color"
COLOR_SIZE="${fg[$PS1_COLOR]}$reset_color"
COLOR_SIZE=${#COLOR_SIZE}
precmd() {
    RIGHTVAR="${PWD/$HOME/~}"
    LEFT="┌─[$USER_P@$HOST_P]─[$RIGHTVAR]"
    if (( ${#LEFT} - COLOR_SIZE >= COLUMNS )); then
        LEFT="┌─[$USER_P@$HOST_P]
├─[$RIGHTVAR]"
    fi
    print "${LEFT}"
}
PROMPT="└─> "

### XDG - may be defined by gnome or other de
[ -z "$XDG_CONFIG_HOME" ] && XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_CACHE_HOME"  ] && XDG_CACHE_HOME="$HOME/.cache"
[ -z "$XDG_DATA_HOME"   ] && XDG_DATA_HOME="$HOME/.local/share"
[ -z "$XDG_RUNTIME_DIR" ] && XDG_RUNTIME_DIR="$HOME/.local/run"
[ -z "$XDG_DATA_DIRS"   ] && XDG_DATA_DIRS="/usr/share:/usr/local/share"
[ -z "$XDG_CONFIG_DIRS" ] && XDG_CONFIG_DIRS="/etc/xdg"

# source customizations
for file in "$HOME"/.zshrc.d/*; do
    source "$file"
done 2> /dev/null
