[ -z "$XDG_CONFIG_HOME" ] && set -x XDG_CONFIG_HOME "$HOME/.config"
[ -z "$XDG_CACHE_HOME" ] && set -x XDG_CACHE_HOME "$HOME/.cache"
[ -z "$XDG_DATA_HOME" ] && set -x XDG_DATA_HOME "$HOME/.local/share"
[ -z "$XDG_STATE_HOME" ] && set -x XDG_STATE_HOME "$HOME/.local/state"
[ -z "$XDG_RUNTIME_DIR" ] && set -x XDG_RUNTIME_DIR "$HOME/.local/run"
[ -z "$XDG_DATA_DIRS" ] && set -x XDG_DATA_DIRS "$XDG_DATA_HOME:/usr/local/share:/usr/share"
[ -z "$XDG_CONFIG_DIRS" ] && set -x XDG_CONFIG_DIRS /etc/xdg

if status is-interactive
    set fish_greeting
    ## START GIT
    set __fish_git_prompt_show_informative_status 1
    set __fish_git_prompt_showcolorhints 1
    set __fish_git_prompt_showuntrackedfiles 1
    # the unicode chars suck.
    set __fish_git_prompt_char_dirtystate '*'
    set __fish_git_prompt_char_invalidstate '#'
    set __fish_git_prompt_char_stagedstate '+'
    set __fish_git_prompt_char_stashstate '$'
    set __fish_git_prompt_char_stateseparator '|'
    set __fish_git_prompt_char_untrackedfiles '%'
    set __fish_git_prompt_char_upstream_ahead '↑'
    set __fish_git_prompt_char_upstream_behind '↓'
    set __fish_git_prompt_char_upstream_diverged '<>'
    set __fish_git_prompt_char_upstream_equal '='
    set __fish_git_prompt_char_upstream_prefix ''
    ## END GIT

    ## START ENV
    set -x EDITOR hx
    # basic $PATH
    set -x PATH "$XDG_CONFIG_HOME/zsh/util-bin:$HOME/.local/bin:$PATH"
    ## END ENV

    function fish_title
        set -q argv[1]; or set argv (path resolve /proc/self/fd/0)
        echo "$argv"
    end

    # BEGIN DNF aliases #
    if command -q dnf
        alias inst 'sudo dnf install'
        alias remo 'sudo dnf remove'
        alias updt 'sudo dnf update'
        alias srch 'dnf search -C'
        alias what 'dnf whatprovides'
        alias debuginfo 'sudo dnf --enablerepo=fedora-debuginfo --enablerepo=updates-debuginfo install'
    end
    # END   DNF aliases #

    # BEGIN rust #
    if command -q cargo
        set -x CARGO_HOME $XDG_STATE_HOME/cargo
        set -x PATH "$CARGO_HOME/bin:$PATH"
    end
    if command -q rustup
        set -x RUSTUP_HOME $XDG_STATE_HOME/rustup
        set -x PATH (path dirname (rustup which rustc))":$PATH"
    end
    # END   rust #

    # BEGIN javascript #
    if command -q npm
        set -x NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/config
        if [ ! -f $XDG_CONFIG_HOME/npm/config ]
            mkdir -p $XDG_CONFIG_HOME/npm $XDG_STATE_HOME/npm
            begin
                echo "prefix=$XDG_STATE_HOME/npm"
                echo "cache=$XDG_CACHE_HOME/npm"
            end >$NPM_CONFIG_USERCONFIG
        end
        set -x PATH "$XDG_STATE_HOME/npm/bin:$PATH"
    end
    # END   javascript #

    # BEGIN kube #
    set -x KUBECONFIG "$XDG_DATA_HOME/kube"
    # END kube #

    # BEGIN go #
    if command -q go
        set -x GOPATH "$XDG_STATE_HOME/go"
        set -x PATH "$GOPATH/bin:$PATH"
    end
    # END go #

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
