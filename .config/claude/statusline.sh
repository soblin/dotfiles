#!/bin/bash

# Claude Code statusline
# input: JSON from Claude Code via stdin (https://code.claude.com/docs/en/statusline)

readonly RESET=$'\033[0m'
readonly DIM=$'\033[2m'
readonly GREEN=$'\033[32m'
readonly YELLOW=$'\033[33m'
readonly RED=$'\033[31m'
readonly BLUE=$'\033[1;34m'
readonly GIT_CLEAN=$'\033[30;42m'
readonly GIT_STAGED=$'\033[30;43m'
readonly GIT_DIRTY=$'\033[30;48;5;208m'
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

# git <dir> [worktree] -> branch segment colored by state, like bobthefish
# clean: green, staged only: yellow, unstaged or untracked: orange
git_segment() {
	local dir=$1 worktree=$2 status head="" oid="" staged=0 dirty=0 untracked=0 xy label flags="" color
	status=$(git -C "$dir" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null) || return
	while IFS= read -r l; do
		case $l in
		'# branch.head '*) head=${l#\# branch.head } ;;
		'# branch.oid '*) oid=${l#\# branch.oid } ;;
		'1 '* | '2 '*)
			xy=${l:2:2}
			[[ ${xy:0:1} != . ]] && staged=1
			[[ ${xy:1:1} != . ]] && dirty=1
			;;
		'u '*) dirty=1 ;;
		'? '*) untracked=1 ;;
		esac
	done <<<"$status"
	[[ $head == '(detached)' ]] && head="➦ ${oid:0:7}"
	label=$head
	[[ -n "$worktree" ]] && label="${worktree}: ${head}"

	((staged)) && flags+="+"
	((dirty)) && flags+="●"
	((untracked)) && flags+="…"
	if ((dirty || untracked)); then
		color=$GIT_DIRTY
	elif ((staged)); then
		color=$GIT_STAGED
	else
		color=$GIT_CLEAN
	fi
	printf '%s%s %s%s %s' "$SEP" "$color" "$label" "${flags:+ $flags}" "$RESET"
}

rate_limit() {
	local label=$1 pct=$2 resets_at=$3 out
	[[ -z "$pct" ]] && return
	out="${label} $(gauge "$pct")"
	[[ -n "$resets_at" ]] && out+=" ${DIM}->${RESET} $(reset_time "$resets_at")"
	printf '%s%s' "$SEP" "$out"
}

main() {
	local model current_dir project_dir worktree ctx_pct five_pct five_reset week_pct week_reset line
	# // cSpell:disable
	eval "$(jq -r '
		@sh "model=\(.model.display_name // "")",
		@sh "current_dir=\(.workspace.current_dir // "")",
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
	line+=$(git_segment "${current_dir:-$project_dir}" "$worktree")
	[[ -n "$ctx_pct" ]] && line+="${SEP}ctx $(gauge "$ctx_pct")"
	line+=$(rate_limit 5h "$five_pct" "$five_reset")
	line+=$(rate_limit 7d "$week_pct" "$week_reset")
	printf '%s\n' "$line"
}

main
