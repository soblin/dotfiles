set -U theme_display_date no 
set -U theme_display_cmd_duration no
set -g theme_display_hostname no
set -g theme_display_user no

bass source ~/.profile
bass source ~/.bash_aliases
bass source ~/.bashrc
eval (dircolors -c ~/.dircolors)

set -g -x PATH /usr/local/bin $PATH
set -g -x PATH ~/.local/bin $PATH
set -g -x PATH ~/.local/bin/custom $PATH

# https://zenn.dev/kenji_miyake/articles/c149cc1f17e168
alias colcon='__colcon_find_workspace_dir > /dev/null && cd (__colcon_find_workspace_dir); command colcon'
alias roscd="ccd -o"
register-python-argcomplete --shell fish ros2 | source

function colcon_all
   colcon build --symlink-install --continue-on-error --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache
end

function colcon_select
   colcon build --packages-up-to $argv --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache
end
