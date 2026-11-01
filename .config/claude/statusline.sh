#!/bin/bash

# Claude Code statusline
# input: JSON from Claude Code via stdin (https://code.claude.com/docs/en/statusline)

readonly RESET=$'\033[0m'
readonly DIM=$'\033[2m'
readonly GREEN=$'\033[32m'
readonly YELLOW=$'\033[33m'
readonly RED=$'\033[31m'
readonly BLUE=$'\033[1;34m'
readonly MAGENTA=$'\033[35m'
readonly SEP="${DIM} | ${RESET}"
readonly GAUGE_WIDTH=10

color_of() {
	local pct=$1
	if ((pct >= 80)); then
		printf '%s' "$RED"
	elif ((pct >= 50)); then
		printf '%s' "$YELLOW"
	else
		printf '%s' "$GREEN"
	fi
}

# gauge <percentage> -> "██████░░░░ 60%"
gauge() {
	local pct filled i full="" empty=""
	pct=$(printf '%.0f' "$1")
	((pct > 100)) && pct=100
	filled=$(((pct * GAUGE_WIDTH + 50) / 100))
	for ((i = 0; i < GAUGE_WIDTH; i++)); do
		if ((i < filled)); then
			full+="█"
		else
			empty+="░"
		fi
	done
	printf '%s%s%s%s%s %3d%%' "$(color_of "$pct")" "$full" "$DIM" "$empty" "$RESET" "$pct"
}

# remaining time until <epoch>: "in 3h26m" if within a day, otherwise "09/12 04:00"
reset_time() {
	local resets_at=$1 now diff
	now=$(date +%s)
	diff=$((resets_at - now))
	if ((diff <= 0)); then
		printf 'now'
	elif ((diff < 86400)); then
		printf 'in %dh%02dm' $((diff / 3600)) $((diff % 3600 / 60))
	else
		date -d "@$resets_at" '+%m/%d %H:%M'
	fi
}

rate_limit() {
	local label=$1 pct=$2 resets_at=$3 out
	[[ -z "$pct" ]] && return
	out="${label} $(gauge "$pct")"
	[[ -n "$resets_at" ]] && out+=" ${DIM}->${RESET} $(reset_time "$resets_at")"
	printf '%s%s' "$SEP" "$out"
}

main() {
	local model project_dir worktree ctx_pct five_pct five_reset week_pct week_reset line
	# // cSpell:disable
	eval "$(jq -r '
		@sh "model=\(.model.display_name // "")",
		@sh "project_dir=\(.workspace.project_dir // .workspace.current_dir // "")",
		@sh "worktree=\(.workspace.git_worktree // "")",
		@sh "ctx_pct=\(.context_window.used_percentage // "")",
		@sh "five_pct=\(.rate_limits.five_hour.used_percentage // "")",
		@sh "five_reset=\(.rate_limits.five_hour.resets_at // "")",
		@sh "week_pct=\(.rate_limits.seven_day.used_percentage // "")",
		@sh "week_reset=\(.rate_limits.seven_day.resets_at // "")"
	')"
	# // cSpell:enable

	line="${model}${SEP}${BLUE}${project_dir/#$HOME/\~}${RESET}"
	[[ -n "$worktree" ]] && line+=" ${MAGENTA}[${worktree}]${RESET}"
	[[ -n "$ctx_pct" ]] && line+="${SEP}ctx $(gauge "$ctx_pct")"
	line+=$(rate_limit 5h "$five_pct" "$five_reset")
	line+=$(rate_limit 7d "$week_pct" "$week_reset")
	printf '%s\n' "$line"
}

main
