#!/bin/bash -e

APT_OPTION="-qq"

# install prerequisites
# emacs27, fish3, tmux, tree, xclip, xsel, fonts-powerline

echo "Installing tmux, tree, xclip, xsel, fonts-powerline"

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

sudo apt-get ${APT_OPTION} install fonts-powerline

echo "Installed tmux, tree, xclip, xsel, fonts-powerline"

function get_major_ver_num() {
    echo "$1" | cut -d "." -f1
}

function get_emacs_ver_string() {
    # GNU Emacs 26.3 => 26
    emacs --version | head -n1 | cut -d " " -f3
}

function get_fish_ver_string() {
    # fish, version 3.1.2 => 3.1.2
    fish --version | head -n1 | cut -d " " -f3
}

uninstall_old_emacs=false
install_emacs=false

if command -v emacs &> /dev/null; then
    emacs_ver_string=$(get_emacs_ver_string)
    emacs_major_ver=$(get_major_ver_num $emacs_ver_string)
    if [ $emacs_major_ver -lt 26 ]; then
        echo "Your Emacs version is ${emacs_ver_string}. I want to use Emacs >= 26 !"
        uninstall_old_emacs=true
        install_emacs=true
    else
        echo "Emacs ${emacs_ver_string} is already installed."
    fi
else
    echo "Emacs was not found."
    install_emacs=true
fi

if $uninstall_old_emacs; then
    read -p "Are you OK to remove old emacs before upgrade? [Yn]: " yn
    case $yn in
        [Yy*] )
            echo "Purging emacs."
            sudo apt purge ${APT_OPTION} emacs
            sudo apt ${APT_OPTION} autoremove
            echo "Done.";;
        * )
            echo "Skip this process and exit."
            exit;;
    esac
fi

if $install_emacs; then
    echo "Adding ppa:kelleyk/emacs."
    sudo add-apt-repository ppa:kelleyk/emacs
    sudo apt-get ${APT_OPTION} update
    echo "Done."
    read -p "Specify the version 26 or 27(default): " ver
    case $ver in
        "26" )
            echo "Installing Emacs-26"
            sudo apt-get ${APT_OPTION} install emacs26
            echo "Done"
            sudo apt ${APT_OPTION} clean;;
        * )
            echo "Installing Emacs-27"
            sudo apt-get install emacs27
            echo "Done"
            sudo apt ${APT_OPTION} clean;;
    esac
fi

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
create_symlink_d ".dircolors" ".dircolors"

if [ ! -d "${home_dir}/.local/bin" ]; then
    echo "Creating ${home_dir}/.local/bin"
    mkdir -p "${home_dir}/.local/bin"
fi

create_symlink_d ".local/bin/custom" ".local/bin/custom"

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
    echo "Done"
fi

if [ ! -d "${home_dir}/.config/tmux/plugin/tmux-resurrect" ]; then
    echo "Installing tmux-resurrect"
    git clone https://github.com/tmux-plugins/tmux-resurrect.git "${home_dir}/.config/tmux/plugin/tmux-resurrect"
    echo "Done"
fi

if [ ! -d "${home_dir}/.config/tmux/plugin/tmux-continuum" ]; then
    echo "Installing tmux-continuum"
    git clone https://github.com/tmux-plugins/tmux-continuum.git "${home_dir}/.config/tmux/plugin/tmux-continuum"
    echo "Done"
fi

# Additional
if [ -d "${home_dir}/.julia" ]; then
    echo "Detected Julia in ${home_dir}/.julia"
    if [ ! -d "{home_dir}/.julia/config" ]; then
        create_symlink_d ".config/julia" ".julia/config"
    fi
fi

if [ -d "/opt/ros" ]; then
    create_symlink_f ".ros2rc" ".ros2rc"
fi
