    ##SHORT ALIASES##
alias Zconfig='vim ~/.zshrc'
alias Zsource='source ~/.zshrc'
alias Zhistory='cat ~/.zhistory | grep '
alias sudo='sudo '
alias sued='sudo $EDITOR '
alias inst='sudo apt install '
alias remo='sudo apt remove '
alias updt='sudo apt update && sudo apt upgrade'
alias srch='apt search'
alias exe='chmod +x '
alias ls='ls -FCa --color=always '
alias sprungeus="curl -F 'sprunge=<-' http://sprunge.us"
alias clbin="curl -F 'clbin=<-' https://clbin.com"
alias shrug="xclip -i <<< '¯\\_(ツ)_/¯'"
alias neofetch='neofetch --block_range 0 15 --colors 4 2 5 4 5 15 --ascii_colors 32 25'

#1337 aliases
alias clock="watch -t -n 1 'date +%I:%M:%S | figlet'"
alias fortune='fortune | cowsay'


##FUNCTIONS##
##USE WHEN APPROPRIATE##

uridecode() {
    # change plus to space
    local uri="${1//+/ }"
    # convert % to hex literal and print
    printf '%b' "${uri//%/\\x}"
}

ghetty_up() {
	scp ${1} website@ghetty.space:~/ghetty/scp_upload/
}

getmac() {
	ping $1 -c 1 >/dev/null
	arp -a $1
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

export PATH=/usr/share/perl6/vendor/bin:~/.composer/vendor/bin:~/.cabal/bin:~/bin:$PATH
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
# source ~/bin/zsh-syn/zsh-syntax-highlighting.zsh
# source ~/src/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
# source ~/src/zsh-git-prompt/zshrc.sh
 
 #ZSH PROMPT#
 PS1="%{${ret_status}%}┌─%{$fg_bold[cyan]%}[%{$reset_color%}%D %*%{$fg_bold[cyan]%}]%{$reset_color%} <%{$fg[cyan]%}%n%{$reset_color%}@%m%{$fg[cyan]%}>%{$reset_color%}
└─%{$fg_bold[cyan]%}[%{$reset_color%}%~%{$fg_bold[cyan]%}]%{$reset_color%}─> "

# PS1="%{$fg[white]%}┌─%{$fg_bold[cyan]%}[%{$reset_color%}%{$fg[white]%}%D %*%{$fg_bold[cyan]%}]%{$reset_color%}%{$fg[white]%} %{$fg[white]%}<%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[white]%}%m%{$fg[cyan]%}>%{$reset_color%}
#%{$fg[white]%}└─%{$fg_bold[cyan]%}[%{$reset_color%}%{$fg[white]%}%~%{$fg_bold[cyan]%}]%{$reset_color%}%{$fg[white]%}─>%{$reset_color%} "
 
# PERL
PATH="/home/prussian/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/prussian/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/prussian/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/prussian/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/prussian/perl5"; export PERL_MM_OPT;

# RUBY
GEM_HOME=~/.vagrant.d/gems
GEM_PATH=$GEM_HOME:/opt/vagrant/embedded/gems
# PATH=/opt/vagrant/embedded/bin:$PATH
