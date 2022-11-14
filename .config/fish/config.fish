set -U theme_display_date no 
set -U theme_display_cmd_duration no
set -g theme_display_hostname no
set -g theme_display_user no

bass source ~/.profile
bass source ~/.bashrc
bass source ~/.bash_aliases
eval (dircolors -c ~/.dircolors)

set -g -x PATH /usr/local/bin $PATH
set -g -x PATH ~/.local/bin $PATH

# https://gist.github.com/dfrommi/453f4e2c6635d2965802ac84b88519f5
for file in (find $HOME/.config/fish/configs/ -path "*.fish" -type f -mindepth 1 -maxdepth 1 2> /dev/null)
    builtin source $file 2> /dev/null
end
