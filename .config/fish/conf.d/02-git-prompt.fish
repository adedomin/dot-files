if status is-interactive
    set __fish_git_prompt_show_informative_status 1
    set __fish_git_prompt_showcolorhints 1
    set __fish_git_prompt_showuntrackedfiles 1
    # the unicode chars suck.
    set __fish_git_prompt_char_dirtystate '*'
    set __fish_git_prompt_char_invalidstate '#'
    set __fish_git_prompt_char_stagedstate '+'
    set __fish_git_prompt_char_stashstate '$'
    set __fish_git_prompt_char_stateseparator '|'
    set __fish_git_prompt_char_untrackedfiles '%'
    set __fish_git_prompt_char_upstream_ahead '↑'
    set __fish_git_prompt_char_upstream_behind '↓'
    set __fish_git_prompt_char_upstream_diverged '<>'
    set __fish_git_prompt_char_upstream_equal '='
    set __fish_git_prompt_char_upstream_prefix ''
end
