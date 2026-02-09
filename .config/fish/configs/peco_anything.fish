set -l peco_anything_prompt "  peco completion "

function peco_complete_cmd_anything
    set -l tokens (commandline --tokenize)

    set -l len (count $tokens)

    test $len -eq 0; and return

    for i in (seq $len)
        set -l token $tokens[$i]
        switch "$token"
            case git
                peco_git_dispatch $tokens[$i..$len]
            case '*'
                return
        end
    end
end

bind \cg peco_complete_cmd_anything

function peco_git_unstaged_file_dir
    set -l prompt (string join "" "$peco_anything_prompt" " git unstaged files  >")
    set -l target (
    git status -uall --porcelain \
        | awk '{print $NF}' \
        | peco --prompt $prompt
    )
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function peco_git_branch
    set -l prompt (string join "" "$peco_anything_prompt" " git branches  >")
    set -l target (
    git branch --format='%(refname:short)' \
        | peco --prompt $prompt
    )
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function peco_git_branch_or_tag
    set -l prompt (string join "" "$peco_anything_prompt" " git branches  / tags  >")
    set -l ref (
        begin
            git branch --format='%(refname:short)'
            git tag
        end | sort -u | peco --prompt $prompt
    )
    test -z "$ref"; and return
    commandline --insert -- "$ref"
end

function peco_git_remote
    set -l prompt (string join "" "$peco_anything_prompt" " git remotes 󰖟 >")
    set -l remote (
    git remote show \
        | peco --prompt $prompt
    )
    test -z "$remote"; and return
    commandline --insert -- "$remote"
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
