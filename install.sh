#!/bin/bash -e

cur_dir=`pwd`

function create_symlink_f() {
    file=$1
    dst_path=$2
    dst="${home_dir}/${dst_path}"
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
                printf "Created symlink to ${dst}\n"
                ;;
            * )
                echo "Skip."
                ;;
        esac
    else
        printf "symlink ${src} => ${dst} already exists, skipping.\n"
    fi
}

function create_symlink_d() {
    dir=$1
    dst_dir=$2
    dst="${home_dir}/${dst_dir}"
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
                printf "Created symlink to ${dst}\n"
                ;;
            * )
                echo "Skip."
                ;;
        esac
    else
        printf "symlink ${src} => ${dst} already exists, skipping.\n"
    fi
}

# system, bash
create_symlink_f ".bashrc" ".bashrc"
create_symlink_f ".bash_aliases" ".bash_aliases"
create_symlink_f ".profile" ".profile"
create_symlink_f ".dircolors" ".dircolors"

# .rc files
create_symlink_d ".config/rcs" ".config/rcs"

# git
create_symlink_f ".gitignore" ".gitignore"
create_symlink_f ".gitconfig" ".gitconfig"
