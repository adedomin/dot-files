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
