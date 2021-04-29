alias rm="rm -i"
alias mv="mv -i"
alias tree='tree -I ".git|__pycache__|node_modules|.ipynb_checkpoints"'
alias emacs='emacs 2>/dev/null'
alias rlqt='tmux kill-session -t husky_sim; rosrun tmux_scripts cleanup.sh'
alias rlt='tmuxp load `rospack find tmux_scripts`/tmuxp_config/husky_sim.yaml; rlqt'
alias rlt2='tmuxp load `rospack find tmux_scripts`/tmuxp_config/husky_simple_sim.yaml; rlqt'