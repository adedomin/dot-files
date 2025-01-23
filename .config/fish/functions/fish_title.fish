function fish_title
    set -q argv[1]; or set argv (path resolve /proc/self/fd/0)
    echo "$argv"
end
