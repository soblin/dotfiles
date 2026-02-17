#!/usr/bin/env bash
# // cSpell:disable
#===============================================================================
#   Author: Wenxuan
#    Email: wenxuangm@gmail.com
#  Created: 2018-04-05 17:37
#===============================================================================
# https://github.com/wfxr/tmux-power
# $1: option
# $2: default value
# // cSpell:enable

tmux_get() {
	local value="$(tmux show -gqv "$1")"
	[ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
	tmux set-option -gq "$1" "$2"
}

# Options
# copy thd glyphs from https://www.nerdfonts.com/cheat-sheet
user_icon=''
time_icon=''
date_icon=''
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)

# short for Theme-Colour
theme="dracula" # gold | dracula

case "$theme" in
"dracula")
	TC=colour141
	BG=colour235
	EM=colour212

	GR1=colour236
	GR2=colour237
	GR3=colour239
	GR4=colour240
	;;

*)
	echo "Unknown theme: $theme" >&2
	exit 1
	;;
esac

GPU_COLOR=colour76

# Status options
tmux_set status-interval 1
tmux_set status on

# Basic status bar colors
tmux_set status-fg "$FG"
tmux_set status-bg "$BG"
tmux_set status-attr none

# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]#[bg=$TC]#[fg=$BG]"
tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]"

# Left side of status bar
tmux_set status-left-bg "$BG"
tmux_set status-left-length 150
user=$(whoami)
LS="#[fg=$BG,bg=$EM,bold] $user@#h #[fg=$EM,bg=$GR2,nobold]#[fg=$TC,bg=$GR2] #S "
LS="$LS#[fg=$GR2,bg=$BG]"
if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
	LS="$LS#{prefix_highlight}"
fi
tmux_set status-left "$LS"

# Right side of status bar
tmux_set status-right-bg $BG
tmux_set status-right-length 150
RS="#[fg=$EM,bg=$GR2] $time_icon  %T #[fg=$EM,bg=$GR2]#[fg=$BG,bg=$EM] $date_icon  %F "
RS="#[fg=$TC,bg=$GPU_COLOR]#[fg=$GR1,bg=$TC]   PC |  |  | 󰊚 | #(tmux-mem-cpu-load -g 5 -a 1 --interval 1) #[fg=$GR2,bg=$TC]$RS"
RS="#[fg=$GPU_COLOR]#[fg=$BG,bg=$GPU_COLOR] #(gpu_monitor.sh -r 0.1) $RS"
if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
	RS="#{prefix_highlight}$RS"
fi
tmux_set status-right "$RS"

# Window status
tmux_set window-status-format "#[fg=$TC] #I:#W#F "
tmux_set window-status-current-format "#[fg=$BG,bg=$GR2]#[fg=$EM,bold] #I:#W#F #[fg=$GR2,bg=$BG,nobold]"

# Window separator
tmux_set window-status-separator ""

# Window status alignment
tmux_set status-justify left

# Current window status
tmux_set window-status-current-status fg=$TC bg=$BG

# Pane border
tmux_set pane-border-style fg=$GR3 bg=default

# Active pane border
tmux_set pane-active-border-style fg=$TC bg=$BG

# Pane number indicator
tmux_set display-panes-colour $GR3
tmux_set display-panes-active-colour $TC

# Clock mode
tmux_set clock-mode-colour $TC
tmux_set clock-mode-style 24

# Message
tmux_set message-style fg=$TC bg=$BG

# Command message
tmux_set message-command-style fg=$TC bg=$BG

# Copy mode highlight
tmux_set mode-style bg=$TC fg=$BG
