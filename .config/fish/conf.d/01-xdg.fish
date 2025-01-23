set -q XDG_CONFIG_HOME || set -x XDG_CONFIG_HOME "$HOME/.config"
set -q XDG_CACHE_HOME || set -x XDG_CACHE_HOME "$HOME/.cache"
set -q XDG_DATA_HOME || set -x XDG_DATA_HOME "$HOME/.local/share"
set -q XDG_STATE_HOME || set -x XDG_STATE_HOME "$HOME/.local/state"
set -q XDG_RUNTIME_DIR || set -x XDG_RUNTIME_DIR "$HOME/.local/run"
set -q XDG_DATA_DIRS || set -x --path XDG_DATA_DIRS "$XDG_DATA_HOME:/usr/local/share:/usr/share"
set -q XDG_CONFIG_DIRS || set -x XDG_CONFIG_DIRS /etc/xdg
