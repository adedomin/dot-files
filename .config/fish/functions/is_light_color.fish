function is_light_color -d 'Determine if a color is light. Arg order: R G B'
    test (math \( $argv[1] '*' 299 + $argv[2]'*' 587 + $argv[3] '*' 114 \) / 1000) \
        -gt 125
end
