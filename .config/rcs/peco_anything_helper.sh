#!/bin/bash

set_bold() {
    local text="$1"
    printf "%b%s%b" "$(tput bold)" "$text" "$(tput sgr0)"
}

set_fg() {
    local color="$1"
    printf "\e[38;5;%sm" "$color"
}

set_bg() {
    local color="$1"
    printf "\e[48;5;%sm" "$color"
}

set_reset() {
    printf "\e[0m"
}

create_color_string() {
    local fg="$1"
    local bg="$2"
    shift 2
    local text="$*"

    printf "%b%b%s%b" \
        "$(set_fg "$fg")" \
        "$(set_bg "$bg")" \
        "$text" \
        "$(set_reset)"
}

peco_anything_prompt="  peco completion "

create_dracula_prompt() {
    local prompt
    prompt="$(set_bold "$1 ")"

    local gray_blue=60
    local dark_gray_blue=238
    local pink_violet=141
    local pink=212
    local black=237

    local peco_anything_prompt_bold
    peco_anything_prompt_bold="$(set_bold "$peco_anything_prompt")"

    local separator=" "

    printf "%b%b%b%b%s%b" \
        "$(create_color_string "$black" "$pink_violet" "$peco_anything_prompt_bold")" \
        "$(create_color_string "$pink_violet" "$pink" "$separator")" \
        "$(create_color_string "$dark_gray_blue" "$pink" "$prompt")" \
        "$(set_fg "$pink")" \
        "$separator" \
        "$(set_reset)"
}
