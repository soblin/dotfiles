#!/bin/bash

docker_icon='󰡨'
project_icon=''
container_icon='󰋷'

monitor_docker() {
	if ! docker info >/dev/null 2>&1; then
		echo "$docker_icon  down"
		return
	fi
	local projects containers
	projects=$(docker compose ls -q 2>/dev/null | wc -l)
	containers=$(docker container ls -q 2>/dev/null | wc -l)
	echo "Docker $docker_icon / #${projects} $project_icon / #${containers} $container_icon "
}

monitor() {
	monitor_docker
	sleep "$1"
}

main() {
	rate=5
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
