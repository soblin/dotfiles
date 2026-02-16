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

    # argc == 1
    set -l popup_cmd "
    begin
        $argv[1]
    end $filter_pipe |
    peco --prompt '(i-search)`\'' > $tmp
    "

    # argc == 2
    if test $cmd_len -eq 2
        set -l cmds (string join "\n    " $list_cmds)
        set popup_cmd "
        begin
            # NOTE: $cmds does not work. Why?
            $list_cmds[1]
            $list_cmds[2]
        end $filter_pipe |
        peco --prompt '(i-search)`\'' > $tmp
        "
    end

    # argc == 3
    if test $cmd_len -eq 3
        set popup_cmd "
        begin
            # NOTE: $cmds does not work
            $list_cmds[1]
            $list_cmds[2]
            $list_cmds[3]
        end $filter_pipe |
        peco --prompt '(i-search)`\'' > $tmp
        "
    end

    tmux display-popup -E -T "$popup_status" -d (pwd) "$popup_cmd"
    if test -s $tmp
        printf (cat $tmp)
    end
end
