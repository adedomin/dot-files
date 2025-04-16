function host_color
    if set -q custom_user_hash_color
        return
    end
    if get_term_bg
        is_light_color $term_bg_red $term_bg_green $term_bg_blue
        set --local is_light_back $status
        set --local i 0
        while test $i -le 10
            set --local j 0
            set --local hashstr ""
            while test $j -le $i
                set hashstr $hashstr$hostname
                set j (math $j + 1)
            end
            color_hash $hashstr
            is_light_color $hash_red $hash_green $hash_blue
            if test $status -ne $is_light_back
                set --global custom_user_hash_color $color_hash_set_color
                return 0
            end
            set i (math $i + 1)
        end
        return 1
    end
end
