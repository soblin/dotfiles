set -g peco_anything_prompt " peco completion"

set -l gray_blue 60
set -l dark_gray_blue 238
set -l pink_violet 141
set -l pink 212
set -l black 237

function peco_complete_cmd_anything
    set -l tokens (commandline --tokenize)

    set -l len (count $tokens)

    test $len -eq 0; and return

    for i in (seq $len)
        set -l token $tokens[$i]
        switch "$token"
            case git
                peco_git_dispatch $tokens[$i..$len]
            case cd
                peco_cd_dispatch
            case '*'
                return
        end
    end
end

bind \cg peco_complete_cmd_anything

function create_dracula_theme_prompt
    set -l sub_prompt $argv
    set -l gray_blue color60
    set -l dark_gray_blue color238
    set -l pink_violet color141
    set -l pink color212
    set -l black color237
    set -l separator ""
    printf " #[fg=%s, bg=%s, bold] %s #[fg=%s, bg=%s]%s#[fg=%s, bg=%s, bold] %s #[fg=%s, bg=default]%s " $black $pink_violet $peco_anything_prompt $pink_violet $pink $separator $gray_blue $pink $sub_prompt $pink $separator
end

function call_cmd_peco_tmux_popup
    set -l list_cmds $argv[1]
    set -l cmd_len (math (count $argv) - 2)
    if test $cmd_len -gt 1
        set list_cmds $argv[1..$cmd_len]
    end
    set -l select_cmd $argv[-2]
    set -l popup_status $argv[-1]

    set -l tmp (mktemp)
    # if $select_cmd == "", | | is invalid
    set -l filter_pipe ""
    test -n "$select_cmd"; and set filter_pipe " | $select_cmd"

    set -l popup_cmd "
    begin
        $argv[1]
    end $filter_pipe |
    peco --prompt '(i-search)`\'' > $tmp
    "
    if test $cmd_len -gt 1
        set -l cmds (string join "\n    " $list_cmds)
        set popup_cmd "
        begin
            $list_cmds[1]
            $list_cmds[2]
        end $filter_pipe |
        peco --prompt '(i-search)`\'' > $tmp
        "
    end
    tmux display-popup -E -T "$popup_status" -d (pwd) "$popup_cmd"
    if test -s $tmp
        printf (cat $tmp)
    end
end

function peco_git_unstaged_file_dir
    set -l sub_prompt " git unstaged files "
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "git status -uall --porcelain"
    set -l select_cmd "awk '{print \$NF}'"

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function peco_git_branch
    set -l sub_prompt " git branches "
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "git branch --format='%(refname:short)'"
    set -l select_cmd ""

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function peco_git_branch_or_tag
    set -l sub_prompt " git branches  / tags "
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "git branch --format='%(refname:short)'" "git tag"
    set -l select_cmd "sort -u"

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function peco_git_remote
    set -l sub_prompt " git remotes 󰖟"
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "git remote show"
    set -l select_cmd ""

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function peco_git_dispatch
    set -l len (count $argv)

    test $len -lt 2; and return

    set -l subcmd $argv[2]

    switch "$subcmd"
        case add
            peco_git_unstaged_file_dir
        case branch merge rebase
            peco_git_branch
        case push
            # TODO: if argc == 2, complete remote, and if 3, complete branch/tag
            peco_git_branch_or_tag
        case checkout switch diff log
            peco_git_branch_or_tag
        case remote
            peco_git_remote
        case '*'
            return
    end
end

function peco_cd_dispatch
    set -l sub_prompt " ls/bd/z candidates "
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "complete -C 'cd '" "complete -C 'bd '" "complete -C 'z '"
    set -l select_cmd ""

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end
