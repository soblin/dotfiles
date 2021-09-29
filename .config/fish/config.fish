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

set -g -x LD_LIBRARY_PATH ~/.local/lib $LD_LIBRARY_PATH
set -g -x CPLUS_INCLUDE_PATH "~/.local/include" $CPLUS_INCLUDE_PATH
set -g -x CMAKE_PREFIX_PATH ~/.local/lib/cmake $CMAKE_PREFIX_PATH
