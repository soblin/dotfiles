set -U theme_display_date no 
set -U theme_display_cmd_duration no
set -g theme_display_hostname no
set -g theme_display_user no

bass source ~/.profile
bass source ~/.bash_aliases
eval (dircolors -c ~/.dircolors)

set -g -x PATH /usr/local/bin $PATH
set -g -x PATH ~/.local/bin $PATH
set -g -x PATH ~/.local/bin/custom $PATH

source ~/.config/fish/ros2.fish
