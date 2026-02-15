function peco_complete_cmd_anything
    set -l tokens (commandline --tokenize)

    set -l len (count $tokens)

    test $len -eq 0; and return

    for i in (seq $len)
        set -l token $tokens[$i]
        switch "$token"
            case git
                __peco_git_dispatch $tokens[$i..$len]
            case cd
                __peco_cd_dispatch
            case '*'
                return
        end
    end
end

function __peco_git_unstaged_file_dir
    set -l sub_prompt " git unstaged files "
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "git status -uall --porcelain"
    set -l select_cmd "awk '{print \$NF}'"

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function __peco_git_branch
    set -l sub_prompt " git branches "
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "git branch --format='%(refname:short)'"
    set -l select_cmd ""

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function __peco_git_tag
    set -l sub_prompt " git tag "
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "git tag"
    set -l select_cmd ""

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function __peco_git_branch_or_tag
    set -l sub_prompt " git branches  / tags "
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "git branch --format='%(refname:short)'" "git tag"
    set -l select_cmd "sort -u"

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function __peco_git_remote
    set -l sub_prompt " git remotes 󰖟"
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "git remote show"
    set -l select_cmd ""

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function __peco_git_dispatch
    set -l len (count $argv)

    test $len -lt 2; and return

    set -l subcmd $argv[2]

    switch "$subcmd"
        case add
            __peco_git_unstaged_file_dir
        case branch merge rebase
            __peco_git_branch
        case tag
            __peco_git_tag
        case push
            # TODO: if argc == 2, complete remote, and if 3, complete branch/tag
            __peco_git_branch_or_tag
        case checkout switch diff log
            __peco_git_branch_or_tag
        case remote
            __peco_git_remote
        case '*'
            return
    end
end

function __peco_cd_dispatch
    set -l sub_prompt " ls/bd/z candidates 󰔰"
    set -l popup_status (create_dracula_theme_prompt $sub_prompt)
    set -l list_cmds "complete -C 'cd '" "complete -C 'bd '" "complete -C 'z '"
    set -l select_cmd "xargs realpath"

    set -l target (call_cmd_peco_tmux_popup $list_cmds $select_cmd $popup_status)
    test -z "$target"; and return
    commandline --insert -- "$target"
end
