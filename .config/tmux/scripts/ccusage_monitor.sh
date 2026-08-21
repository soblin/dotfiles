#!/bin/bash

claude_icon='󱙺'
token_icon=''
timer_icon='󰔟'

ccusage_cmd() {
	if command -v bunx >/dev/null 2>&1; then
		bunx ccusage "$@"
	else
		return 127
	fi
}

monitor_ccusage() {
	local json
	json=$(ccusage_cmd blocks --offline --active --json 2>/dev/null)
	if [[ $? -ne 0 || -z "$json" ]]; then
		echo "Claude $claude_icon / no ccusage "
		return
	fi
	# // cSpell:disable
	echo "$json" | jq -r --arg c "$claude_icon" --arg t "$token_icon" --arg r "$timer_icon" '
		.blocks[0] // empty
		| "Claude \($c) / \($t) \((.totalTokens / 1000) | round)k / \($r) \(.projection.remainingMinutes // 0)m / \(((.burnRate.tokensPerMinute // 0) / 1000) | round)k/min"
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
