#!/bin/bash

# /home/<user>
home_dir=`realpath ~`
cur_dir=`pwd`

function create_symlink_f() {
    file=$1
    dst="${home_dir}/${file}"
    src="${cur_dir}/${file}"
    if [ ! -L $dst ]; then
        echo "symlink $dst does not exists."
        if [ -f $dst ]; then
            echo "file $dst exists."
            read -p "Remove and backup file $dst and create a symlink to $src? [Yn]: " yn
        else
            read -p "Create a symlink to $src? [Yn]: " yn
        fi
        case $yn in
            "" | [Yy*] )
                if [ -f $dst ]; then
                    cp $dst "${dst}.old"
                    rm -rf "$dst"
                fi
                ln -sf "${src}" "${dst}"
                printf "Created symlink to ${dst}\n\n"
                ;;
            * )
                echo "Skip."
                ;;
        esac
    else
        printf "symlink ${src} => ${dst} already exists, skipping.\n\n"
    fi
}

function create_symlink_d() {
    dir=$1
    dst="${home_dir}/${dir}"
    src="${cur_dir}/${dir}"
    if [ ! -L $dst ]; then
        echo "symlink $dst does not exists."
        if [ -d $dst ]; then
            echo "directory $dst exists."
            read -p "Remove and backup directory $dst and create a symlink to $src? [Yn]: " yn
        else
            read -p "Create a symlink to $src? [Yn]: " yn
        fi
        case $yn in
            "" | [Yy*] )
                if [ -d $dst ]; then
                    cp -r $dst "${dst}.old"
                    rm -rf "$dst"
                fi
                ln -s "${src}" "${dst}"
                printf "Created symlink to ${dst}\n\n"
                ;;
            * )
                echo "Skip."
                ;;
        esac
    else
        printf "symlink ${src} => ${dst} already exists, skipping.\n\n"
    fi
}


create_symlink_f ".emacs"
create_symlink_d ".emacs.d"

create_symlink_f ".bashrc"

create_symlink_f ".gitignore"
create_symlink_f ".gitconfig"

create_symlink_f ".tmux.conf"

create_symlink_d ".config/ls"
create_symlink_d ".config/tmux"
create_symlink_d ".config/fish"

create_symlink_d ".local/bin/custom"
