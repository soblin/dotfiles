#!/bin/bash -e

APT_OPTION="-qq"

# install prerequisites

echo "Installing etckeeper, git, tmux, tree, xclip, xsel, mlocate, htop, ccls, ccache, cmake, clang, fzf, fd-find, jq, ninja, systemd-coredump, pandoc, markdown"

if ! command -v etckeeper &>/dev/null; then
    sudo apt-get ${APT_OPTION} install etckeeper
fi

if ! command -v git &>/dev/null; then
    sudo apt-get ${APT_OPTION} install git git-lfs
fi

if ! command -v tmux &>/dev/null; then
    sudo apt-get ${APT_OPTION} install tmux
fi

if ! command -v tree &>/dev/null; then
    sudo apt-get ${APT_OPTION} install tree
fi

if ! command -v xclip &>/dev/null; then
    sudo apt-get ${APT_OPTION} install xclip
fi

if ! command -v xsel &>/dev/null; then
    sudo apt-get ${APT_OPTION} install xsel
fi

if ! command -v mlocate &>/dev/null; then
    sudo apt-get ${APT_OPTION} install mlocate
fi

if ! command -v htop &>/dev/null; then
    sudo apt-get ${APT_OPTION} install htop
fi

if ! command -v ccls &>/dev/null; then
    sudo apt-get ${APT_OPTION} install ccls
fi

if ! command -v ccache &>/dev/null; then
    sudo apt-get ${APT_OPTION} install ccache
fi

if ! command -v cmake &>/dev/null; then
    sudo apt-get ${APT_OPTION} install cmake
fi

if ! command -v clang &>/dev/null; then
    sudo apt-get ${APT_OPTION} install clang llvm clang-format
fi

if ! command -v fzf &>/dev/null; then
    sudo apt-get ${APT_OPTION} install fzf
fi

if ! command -v fdfind &>/dev/null; then
    sudo apt-get ${APT_OPTION} install fd-find
    # https://zenn.dev/kenji_miyake/articles/c149cc1f17e168
    ln -s $(which fdfind) ~/.local/bin/fd
fi

if ! command -v jq &>/dev/null; then
    sudo apt-get ${APT_OPTION} install jq
fi

if ! command -v ninaj &>/dev/null; then
    sudo apt-get ${APT_OPTION} install ninja-build
fi

if ! command -v coredumpctl &>/dev/null; then
    sudo apt-get ${APT_OPTION} install systemd-coredump
    ulimit -c unlimited
fi

if ! command -v pandoc &>/dev/null; then
    sudo apt-get ${APT_OPTION} install pandoc markdown
fi

echo "Installing extra fonts"

sudo apt-get ${APT_OPTION} install fonts-powerline fonts-takao-gothic fonts-takao-pgothic

echo "Installing utilities"

sudo apt-get ${APT_OPTION} install vlc simplescreenrecorder gparted

echo "Installed dependencies."

function get_major_ver_num() {
    echo "$1" | cut -d "." -f1
}

function get_fish_ver_string() {
    # fish, version 3.1.2 => 3.1.2
    fish --version | head -n1 | cut -d " " -f3
}

# install emacs with snap(from Ubuntu22 this provides nativecomp version)
sudo snap install emacs --classic

uninstall_old_fish=false
install_fish=false

if command -v fish &> /dev/null; then
   fish_ver_string=$(get_fish_ver_string)
   fish_major_ver=$(get_major_ver_num $fish_ver_string)
   if [ $fish_major_ver -lt 3 ]; then
       echo "Your fish version is ${fish_ver_string}. I want to use fish >= 3 !"
       uninstall_old_fish=true
       install_fish=true
   else
       echo "fish ${fish_ver_string} is already installed."
   fi
else
    echo "fish was not found."
    install_fish=true
fi

if $uninstall_old_fish; then
    read -p "Are you OK to remove old fish before upgrade? [Yn]: " yn
    case $yn in
        [Yy*] )
            echo "Purging fish."
            sudo apt purge ${APT_OPTION} fish
            sudo apt ${APT_OPTION} autoremove
            echo "Done.";;
        * )
            echo "Skip this process and exit."
            exit;;
    esac
fi

if $install_fish; then
    echo "Adding ppa:fish-shell/release-3"
    sudo apt-add-repository ppa:fish-shell/release-3
    sudo apt-get ${APT_OPTION} update
    echo "Done."
    echo "Installing fish-3"
    sudo apt-get ${APT_OPTION} install fish
    echo "Done"
    sudo apt ${APT_OPTION} clean
fi

if ! command -v tmux-mem-cpu-load &> /dev/null; then
    echo "Please install or set path to tmux-mem-cpu-load to display resource load in tmux status bar."
    echo "You can install it from https://github.com/thewtex/tmux-mem-cpu-load."
    echo "You will need cmake and g++ and/or clang to build this."
fi

# /home/<user>
home_dir=`realpath ~`
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

if [ ! -d "${home_dir}/.local/bin" ]; then
    echo "Creating ${home_dir}/.local/bin"
    mkdir -p "${home_dir}/.local/bin"
fi

# .rc files
create_symlink_d ".config/rcs" ".config/rcs"

# fish
create_symlink_d ".config/fish" ".config/fish"

# git
create_symlink_f ".gitignore" ".gitignore"
create_symlink_f ".gitconfig" ".gitconfig"

# emacs
create_symlink_f ".emacs" ".emacs"
create_symlink_d ".emacs.d" ".emacs.d"

if [ ! -d "${home_dir}/.emacs.d/elpa" ]; then
    echo "Cloning Emacs elpa"
    git clone https://github.com/soblin/elpa.git "${home_dir}/.emacs.d/elpa"
    echo "Done"
fi

# tmux
create_symlink_f ".tmux.conf" ".tmux.conf"
create_symlink_d ".config/tmux" ".config/tmux"

if [ ! -d "${home_dir}/.config/tmux/plugin" ]; then
    mkdir -p "${home_dir}/.config/tmux/plugin"
    echo "Created ${home_dir}/.config/tmux/plugin."
fi

if [ ! -d "${home_dir}/.config/tmux/plugin/tmux-sidebar/" ]; then
    echo "Installing tmux-sidebar."
    git clone https://github.com/tmux-plugins/tmux-sidebar.git "${home_dir}/.config/tmux/plugin/tmux-sidebar"
    echo "Cloned tmux-sidebar"
fi

if [ ! -d "${home_dir}/.config/tmux/plugin/tmux-resurrect" ]; then
    echo "Installing tmux-resurrect"
    git clone https://github.com/tmux-plugins/tmux-resurrect.git "${home_dir}/.config/tmux/plugin/tmux-resurrect"
    echo "Cloned tmux-resurrect"
fi

if [ ! -d "${home_dir}/.config/tmux/plugin/tmux-continuum" ]; then
    echo "Installing tmux-continuum"
    git clone https://github.com/tmux-plugins/tmux-continuum.git "${home_dir}/.config/tmux/plugin/tmux-continuum"
    echo "Cloned tmux-continuum"
fi

if [ ! -d "${home_dir}/.config/tmux/plugin/tmux-named-snapshot" ]; then
    echo "Installing tmux-continuum"
    git clone https://github.com/spywhere/tmux-named-snapshot "${home_dir}/.config/tmux/plugin/tmux-named-snapshot"
    echo "Cloned tmux-named-snapshot"
fi
