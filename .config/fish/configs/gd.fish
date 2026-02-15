function gd
    set -l sub_prompt " 󰳏 cd ghq repos 󰔰"
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "ghq list"
    set -l select_cmd ""
    set -l repo (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)

    test -z "$repo"; and return
    cd (ghq root)/$repo
end
