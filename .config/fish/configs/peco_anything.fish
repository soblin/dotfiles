function set_bold
    set -l text $argv[1]
    printf "%b%s%b" (tput bold) "$text" (tput sgr0)
end

function set_fg
    printf "\e[38;5;%sm" $argv[1]
end

function set_bg
    printf "\e[48;5;%sm" $argv[1]
end

function set_reset
    printf "\e[0m"
end

function create_color_string
    set -l fg $argv[1] # 256 color
    set -l bg $argv[2] # 256 color
    set -l text $argv[3..-1]

    printf "%b%b%s%b" (set_fg $fg)(set_bg $bg) "$text" (set_reset)
end

set -g peco_anything_prompt "  peco completion "

function create_dracula_prompt
    set -l prompt (set_bold (string join "" $argv[1] " "))
    set -l gray_blue 60
    set -l dark_gray_blue 238
    set -l pink_violet 141
    set -l pink 212
    set -l black 237
    set -l peco_anything_prompt_bold (set_bold $peco_anything_prompt)
    set -l separator " "

    printf "%b%b%b%b%s%b" (create_color_string $dark_gray_blue $gray_blue $peco_anything_prompt_bold ) \
        (create_color_string $gray_blue $pink_violet $separator ) \
        (create_color_string $black $pink_violet $prompt) \
        (set_fg $pink_violet) "$separator" (set_reset)
end

function peco_complete_cmd_anything
    set -l tokens (commandline --tokenize)

    set -l len (count $tokens)

    test $len -eq 0; and return

    for i in (seq $len)
        set -l token $tokens[$i]
        switch "$token"
            case git
                peco_git_dispatch $tokens[$i..$len]
                # docker, etc.
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
        case branch merge
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
