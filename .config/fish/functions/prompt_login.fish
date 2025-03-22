function prompt_login --description "display user name for the prompt"
    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY; and set -q fish_color_host_remote
        set color_host $fish_color_host_remote
    end

    set -l color_user $fish_color_user
    if host_color
        set color_user $custom_user_hash_color
    end

    echo -n -s (set_color $color_user) "$USER" (set_color normal) @ (set_color $color_host) (prompt_hostname) (set_color normal)
end
