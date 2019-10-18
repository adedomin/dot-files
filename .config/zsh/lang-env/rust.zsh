if [[ -d $XDG_DATA_HOME/cargo ]]; then
    export CARGO_HOME=$XDG_DATA_HOME/cargo
    path=($upath $XDG_DATA_HOME/cargo/bin $path)
fi

if type rustup 2>/dev/null >&2; then
    export RUSTUP_HOME=$XDG_DATA_HOME/rustup
fi
