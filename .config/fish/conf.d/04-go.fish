if command -q go
    set -x GOPATH "$XDG_STATE_HOME/go"
    set --prepend -x PATH "$GOPATH/bin"
end
