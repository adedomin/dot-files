function get_term_bg -d "Get terminal background."
    if not tty -s
        return 1
    end
    # get background color
    read \
        --silent \
        --nchars 21 \
        --delimiter / \
        --prompt-str \e']11;?'\a \
        term_bg_red term_bg_green term_bg_blue
    # OSC 11 repeats the color twice for some reason? preparing for 10bit+ color?
    set --global term_bg_red 0x(string sub --start=-2 $term_bg_red)
    set --global term_bg_green 0x(string sub --start=-2 $term_bg_green)
    set --global term_bg_blue 0x(string sub --start=-2 $term_bg_blue)
end
