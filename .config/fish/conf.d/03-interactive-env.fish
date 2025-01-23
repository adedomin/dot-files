if status is-interactive
    set -x EDITOR hx
    set --prepend -x PATH "$XDG_CONFIG_HOME/zsh/util-bin:$HOME/.local/bin"
    alias which 'command -s'
    alias hash 'command -q'
    # Get SSH auth from logged in machine
    if set -q SSH_CLIENT && ! set -q SSH_AUTH_SOCK
        set -x SSH_AUTH_SOCK "$(
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
        )"
    end
end
