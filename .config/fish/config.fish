set -q XDG_CONFIG_HOME || set -x XDG_CONFIG_HOME "$HOME/.config"
set -q XDG_CACHE_HOME || set -x XDG_CACHE_HOME "$HOME/.cache"
set -q XDG_DATA_HOME || set -x XDG_DATA_HOME "$HOME/.local/share"
set -q XDG_STATE_HOME || set -x XDG_STATE_HOME "$HOME/.local/state"
set -q XDG_RUNTIME_DIR || set -x XDG_RUNTIME_DIR "$HOME/.local/run"
set -q XDG_DATA_DIRS || set -x --path XDG_DATA_DIRS "$XDG_DATA_HOME:/usr/local/share:/usr/share"
set -q XDG_CONFIG_DIRS || set -x XDG_CONFIG_DIRS /etc/xdg

if status is-interactive
    # disable help message.
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
    set --prepend -x PATH "$XDG_CONFIG_HOME/zsh/util-bin:$HOME/.local/bin"
    ## END ENV

    # TODO: WIP automatic host coloring.
    # set -e fish_color_host
    # set -e fish_color_host_remote
    # set -e fish_color_user
    # # get background color
    # read \
    #     --nchars 22 \
    #     --delimiter / \
    #     --prompt-str \e']11;?'\a \
    #     term_bg_red term_bg_green term_bg_blue
    # # OSC 11 repeats the color twice for some reason? preparing for 10bit+ color?
    # set term_bg_red 0x(string sub --start=-2 $term_bg_red)
    # set term_bg_green 0x(string sub --start=-2 $term_bg_green)
    # set term_bg_blue 0x(string sub --start=-2 $term_bg_blue)

    # function is_light_color -d 'Determine if a color is light'
    #     test (math \( $argv[1] '*' 299 + $argv[2]'*' 587 + $argv[3] '*' 114 \) / 1000) \
    #         -gt 125
    # end

    function fish_title
        set -q argv[1]; or set argv (path resolve /proc/self/fd/0)
        echo "$argv"
    end

    alias which 'command -s'
    alias hash 'command -q'

    # BEGIN DNF aliases #
    if command -q dnf
        alias inst 'sudo dnf install'
        alias remo 'sudo dnf remove'
        alias updt 'sudo dnf update'
        alias srch 'dnf search -C'
        alias what 'dnf provides'
        alias debuginfo 'sudo dnf --enablerepo=fedora-debuginfo --enablerepo=updates-debuginfo install'
    end
    # END   DNF aliases #

    # BEGIN rust #
    if command -q cargo
        set -x CARGO_HOME $XDG_STATE_HOME/cargo
        set --prepend -x PATH "$CARGO_HOME/bin"
    end
    if command -q rustup
        set -x RUSTUP_HOME $XDG_STATE_HOME/rustup
        set --prepend -x PATH (path dirname (rustup which rustc))
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
        set --prepend -x PATH "$XDG_STATE_HOME/npm/bin"
    end
    # END   javascript #

    # BEGIN kube #
    set -x KUBECONFIG "$XDG_DATA_HOME/kube"
    # END kube #

    # BEGIN go #
    if command -q go
        set -x GOPATH "$XDG_STATE_HOME/go"
        set --prepend -x PATH "$GOPATH/bin"
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
