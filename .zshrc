##SHORT ALIASES##
alias Zconfig='vim ~/.zshrc'
alias Zsource='source ~/.zshrc'
alias Zhistory='cat ~/.zhistory | grep '
alias sudo='sudo '
if [ -n "$(which apt)" ]; then
    alias inst='sudo apt install '
    alias remo='sudo apt remove '
    alias updt='sudo apt update && sudo apt upgrade'
    alias srch='apt search'
elif [ -n "$(which dnf)" ]; then
    alias inst='sudo dnf install '
    alias remo='sudo dnf remove '
    alias updt='sudo dnf update '
    alias srch='dnf search '
elif [ -n "$(which yum)" ]; then
    alias inst='sudo yum install '
    alias remo='sudo yum remove '
    alias updt='sudo yum update '
    alias srch='yum search '
fi
alias exe='chmod +x '
alias ls='ls -FCa --color=always '
alias sprungeus="curl -F 'sprunge=<-' http://sprunge.us"
alias clbin="curl -F 'clbin=<-' https://clbin.com"
alias shrug="xclip -i <<< '¯\\_(ツ)_/¯'"

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
         -F "caption=${3}" \
         -F "channel=${2:--nochan-}" \
         -F "file=@${1};type=$(file --mime-type "$1" | grep -Po '(?<=: ).*')" \
         | grep -Po -m 1 '(?<=Redirecting to ).*'
}

uridecode() {
    # change plus to space
    local uri="${1//+/ }"
    # convert % to hex literal and print
    printf '%b' "${uri//%/\\x}"
}

getmac() {
	ping "$1" -c 1 >/dev/null
	arp -a "$1"
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
    tr -d $'\n' <<< "$1" |
    curl -Gso /dev/null \
        -w '%{url_effective}' \
        --data-urlencode @- '' |
    cut -c 3- |
    sed 's/%0A$//g'
}

# faster urandom source using openssl
urandom() {
    openssl enc -aes-256-ctr \
        -pass pass:"$(
            dd if=/dev/urandom bs=128 count=1 2>/dev/null \
            | base64
        )" \
        -nosalt </dev/zero 2>/dev/null
}

# $1 - number of hex chars to generate
# return - hex string with a minimum length of 2
# default - hex of 16 chars
randomhex() {
    count=$(( ${1:-16} / 2 ))
    [ "$count" -le 0 ] && count=1
    openssl enc -aes-256-ctr \
        -pass pass:"$(
            dd if=/dev/urandom bs=128 count=1 2>/dev/null \
            | base64
        )" \
        -nosalt < <( dd if=/dev/zero bs="$count" count=1 2>/dev/null ) \
    | xxd -ps \
    | tr -d '\n'
}

# $1 - string to hash
serv_color() {
    local COL_ARR=("${(@k)fg}")
    # will conflict with colorized terms
    COL_ARR=(${COL_ARR/white})
    # will conflict with colorized terms
    COL_ARR=(${COL_ARR/black})

    declare -i chr
    chr=0
    declare -i hash_val
    hash_val=0
    for (( i=1; i<${#1}+1; ++i )); do
        chr=$(echo -n "${1[$i]}" | od -A n -t d1)
        hash_val=$(( hash_val * 32 - hash_val + chr ))
    done
    echo "${COL_ARR[$((hash_val % ${#COL_ARR[@]} + 1))]}"
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
 source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
 
PS1_COLOR=$(serv_color "$(hostname)")
#PS1_COLOR=cyan
#ZSH PROMPT#
PS1="%{${ret_status}%}┌─%{$fg_bold[cyan]%}[%{$reset_color%}%D %*%{$fg_bold[cyan]%}]%{$reset_color%} <%{$fg[$PS1_COLOR]%}%n%{$reset_color%}@%m%{$fg[$PS1_COLOR]%}>%{$reset_color%}
└─%{$fg_bold[cyan]%}[%{$reset_color%}%~%{$fg_bold[cyan]%}]%{$reset_color%}─> "

