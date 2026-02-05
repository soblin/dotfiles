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

    printf "%b%s%b" (set_fg $fg)(set_bg $bg) "$text" (set_reset)
end

function create_dracula_prompt
    set -l prompt $argv[1]
    set -l gray_blue 60
    set -l dark_gray_blue 238
    set -l pink_violet 141
    set -l black 237
    set -l peco_anything_prompt "  peco completion "
    set -l separator ""

    printf "%b%b%b%b%s%b" (create_color_string $dark_gray_blue $gray_blue $peco_anything_prompt ) \
        (create_color_string $gray_blue $pink_violet $separator ) \
        (create_color_string $black $pink_violet $prompt ) \
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
            case '*'
                return
        end
    end
end

bind \cg peco_complete_cmd_anything

function peco_git_unstaged_file_dir
    set -l prompt " git unstaged files  >"
    set -l color_prompt (printf (create_dracula_prompt $prompt))
    echo $color_promt

    set -l target (
    git status -uall --porcelain \
        | awk '{print $NF}' \
        | peco --prompt "$color_prompt"
    )
    test -z "$target"; and return

    commandline --insert -- "$target"
end

function peco_git_branch
    set -l prompt " git branches  >"
    set -l color_prompt (printf (create_dracula_prompt $prompt))

    set -l target (
    git branch --format='%(refname:short)' \
        | peco --prompt "$color_prompt"
    )
    test -z "$target"; and return
    commandline --insert -- "$target"
end

function peco_git_branch_or_tag
    set -l prompt " git branches  / tags  >"
    set -l color_prompt (printf (create_dracula_prompt $prompt))

    set -l ref (
        begin
            git branch --format='%(refname:short)'
            git tag
        end | sort -u | peco --prompt "$color_prompt"
    )
    test -z "$ref"; and return
    commandline --insert -- "$ref"
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
        case checkout switch diff log push
            peco_git_branch_or_tag
        case '*'
            return
    end
end
