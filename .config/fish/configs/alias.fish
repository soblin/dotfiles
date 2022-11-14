function psgrep
   ps aux | grep $argv[1]
end

function pbcopy
    set temp_file $(tempfile)
    tmux save-buffer $temp_file
    xsel -i -b < $temp_file
    rm -rf $temp_file
end

function e
    if not emacsclient -nw $argv
        emacs --daemon
        emacsclient -nw $argv
    end
end

function kill-emacs
    emacsclient -e "(kill-emacs)"
end

function del
    mv $argv ~/.local/share/Trash/files
end

function update
    sudo apt update
    sudo apt upgrade
    sudo apt dist-upgrade
    sudo apt autoremove
    sudo apt clean
end

function apt-unlock
    sudo rm /var/lib/dpkg/lock
    sudo rm /var/lib/dpkg/lock-frontend
    sudo rm -rf /var/lib/apt/lists/lock
end

function git-time
    set current_time $(LANG=C date)
    set commit "$argv ($current_time)"
    git commit -m "$commit"
end
