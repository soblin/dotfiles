#!/bin/bash

nvidia_gpu=$(lspci -v | grep VGA | grep NVIDIA | head -n 1 | awk '{print $5}')

monitor_nvidia() {
	power=$(nvidia-smi --query-gpu=power.draw,power.limit --format=csv,noheader,nounits | awk -F ', *' '{ printf("%.2f%%", $0 / $2 * 100) }')
	vram=$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits | awk -F ', *' '{ printf("%.2f%%", $0 / $2 * 100) }')
	usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk -F ', *' '{ printf("%.2f%%", $1) }')
	echo "󰢮 $1 | ⏻  ${power} |   ${vram} | 󰊚  ${usage}"
}

monitor() {
	if [[ "$nvidia_gpu" == "NVIDIA" ]]; then
		monitor_nvidia "NVIDIA"
	else
		echo "No GPU"
	fi
	sleep $1
}

main() {
	rate=0.1
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

main $@
