if command -q cargo
    set -x CARGO_HOME $XDG_STATE_HOME/cargo
    set --prepend -x PATH "$CARGO_HOME/bin"
end
if command -q rustup
    set -x RUSTUP_HOME $XDG_STATE_HOME/rustup
    set --prepend -x PATH (path dirname (rustup which rustc))
end
