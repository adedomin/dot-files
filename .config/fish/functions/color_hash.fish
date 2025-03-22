function color_hash --description "Hash given string with a color, based on sdbm."
    set --function hash 0
    for chr in (string split '' $argv[1])
        set --local chrv (printf '%d' "'$chr")
        set hash \
            (math --scale=0 '(' $chrv + $hash '*' 65600 - $hash ')' % 'pow(2,32)')
    end
    # echo (math --base=16 $hash)
    set --global hash_red (math --base=16 --scale=0 $hash / 'pow(2,24)' % 'pow(2,8)')
    set --global hash_green (math --base=16 --scale=0 $hash / 'pow(2,16)' % 'pow(2,8)')
    set --global hash_blue (math --base=16 --scale=0 $hash / 'pow(2,8)' % 'pow(2,8)')
    # lol?
    #set --global hash_alpha (math --base=16 --scale=0 $hash % 'pow(2,8)')
    # value suitable for set color
    set --global color_hash_set_color (printf '%02x%02x%02x' $hash_red $hash_green $hash_blue)
end
