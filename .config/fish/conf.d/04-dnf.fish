if status is-interactive
    if command -q dnf
        alias inst 'sudo dnf install'
        alias remo 'sudo dnf remove'
        alias updt 'sudo dnf update'
        alias srch 'dnf search -C'
        alias what 'dnf provides'
        alias debuginfo 'sudo dnf --enablerepo=fedora-debuginfo --enablerepo=updates-debuginfo install'
    end
end
