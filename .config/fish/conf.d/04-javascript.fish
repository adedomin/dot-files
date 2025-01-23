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
