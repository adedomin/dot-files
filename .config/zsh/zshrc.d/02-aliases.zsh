alias vim='TERM= nvim'
alias nvim='TERM= nvim'
alias sudo='sudo '
alias exe='chmod +x'
alias ls='ls --classify --all --color=auto --hyperlink=auto --group-directories-first'
alias clbin="curl -F 'clbin=<-' https://clbin.com"
alias shrug="xclip -i <<< '¯\\_(ツ)_/¯'"

# distros like fedora have a "vimx" for their +clipboard vim
#if type vimx 2>/dev/null >&2; then
#    alias vim="vimx"
#    export EDITOR=vimx
#else
#    export EDITOR=vim
#fi
export EDITOR=nvim
