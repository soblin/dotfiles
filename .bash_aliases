alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
alias mkdir="mkdir -p"
alias tree='tree -I ".git|__pycache__|node_modules|.ipynb_checkpoints|build|gitignore"'
alias dc='cd'

alias gcm='git commit --signoff -m'
alias gst='git status -uall'
alias gck='git checkout'
alias gfp='git fetch --prune'
alias glg='git log --graph --oneline --decorate --all --pretty="format:%C(yellow)%h %C(cyan)%ad %C(green)%an%Creset%x09%s %C(red)%d%Creset"'
alias gls='git log -S'
alias glgrep='git log --grep'
alias gdf='git diff'
alias gdfs='git diff --staged'
function psgrep() {
    ps aux | grep "$1"
}
