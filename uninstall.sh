#!/bin/bash

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

dot_emacs_path="${home_path}/.emacs"
unlink_symlink "$dot_emacs_path"

dot_emacs_d_path="${home_path}/.emacs.d"
unlink_symlink "$dot_emacs_d_path"

dot_bashrc_path="${home_path}/.bashrc"
unlink_symlink "$dot_bashrc_path"

dot_tmux_conf_path="${home_path}/.tmux.conf"
unlink_symlink "$dot_tmux_conf_path"

dot_config_git_path="${home_path}/.config/git"
unlink_symlink "$dot_config_git_path"

dot_config_ls_path="${home_path}/.config/ls"
unlink_symlink "$dot_config_ls_path"

dot_config_tmux_path="${home_path}/.config/tmux"
unlink_symlink "$dot_config_tmux_path"

dot_config_fish_path="${home_path}/.config/fish"
unlink_symlink "$dot_config_fish_path"

dot_local_bin_custom_path="${home_path}/.local/bin/custom"
unlink_symlink "$dot_local_bin_custom_path"
