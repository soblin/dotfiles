#!/bin/bash

claude_icon='󱙺'
token_icon=''
timer_icon='󰔟'
limit_icon='󰄼'

ccusage_cmd() {
	if command -v bunx >/dev/null 2>&1; then
		bunx ccusage "$@"
	else
		return 127
	fi
}

monitor_ccusage() {
	local json
	json=$(ccusage_cmd blocks --offline --json 2>/dev/null)
	if [[ $? -ne 0 || -z "$json" ]]; then
		echo "Claude $claude_icon / no ccusage "
		return
	fi
	# // cSpell:disable
	echo "$json" | jq -r --arg c "$claude_icon" --arg t "$token_icon" --arg r "$timer_icon" --arg l "$limit_icon" '
		[.blocks[] | select(.isGap | not)] as $blocks
		| ($blocks | map(select(.isActive | not) | .costUSD) | max // 0) as $limit
		| ($blocks[] | select(.isActive)) // empty
		| (.burnRate.costPerHour // 0) as $rate
		| (.burnRate.tokensPerMinute // 0) as $token_rate
		| (.projection.remainingMinutes // 0) as $remaining
		| (if $limit <= 0 or $rate <= 0 then $remaining
			elif .costUSD >= $limit then 0
			else (($limit - .costUSD) / $rate * 60) | floor end) as $eta_min
		| (if $eta_min > $remaining then ">\($remaining)min" else "\($eta_min)min" end) as $eta_text
		| "Claude \($c) / \($t) \((.totalTokens / 1000) | round)k / \($r) \($remaining)min(\($l) \($eta_text)) / \((($token_rate) / 1000) | round)k/min"
	' | grep . || echo "Claude $claude_icon / idle "
	# // cSpell:enable
}

monitor() {
	monitor_ccusage
	sleep "$1"
}

main() {
	rate=60
	while [[ $# -gt 0 ]]; do
		case $1 in
		-r | --rate)
			rate=$2
			shift
			shift
			;;
		*)
			break
			;;
		esac
	done
	monitor $rate
}

main "$@"
