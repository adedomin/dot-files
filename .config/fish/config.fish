#if status is-interactive
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
#end
