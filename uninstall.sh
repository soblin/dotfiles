#!/bin/bash -e

function unlink_symlink() {
    path=$1
    if [ -L $path ]; then
        local question="Are you sure to unlink $path ? [Yn]: "
        read -p "$question" yn
        case $yn in
            [Yy*] )
                unlink $path
                printf "Unlinked $path\n\n"
                ;;
            [Nn*] )
                printf "Skip\n\n"
                ;;
            * )
                printf "Please enter yes or no\n\n"
                ;;
        esac
    fi
}

home_path=`realpath ~`

unlink_symlink "${home_path}/.bashrc"
unlink_symlink "${home_path}/.bash_aliases"
unlink_symlink "${home_path}/.profile"
unlink_symlink "${home_path}/.dircolors"

unlink_symlink "${home_path}/.config/fish"

unlink_symlink "${home_path}/.gitignore"
unlink_symlink "${home_path}/.gitconfig"

unlink_symlink "${home_path}/.emacs"
unlink_symlink "${home_path}/.emacs.d"

unlink_symlink "${home_path}/.tmux.conf"
unlink_symlink "${home_path}/.config/tmux"
