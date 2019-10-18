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
