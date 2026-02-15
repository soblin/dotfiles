function create_dracula_theme_prompt
    set -l peco_anything_prompt " peco completion"
    set -l sub_prompt $argv
    set -l gray_blue color60
    set -l dark_gray_blue color238
    set -l pink_violet color141
    set -l pink color212
    set -l black color237
    set -l separator ""
    printf " #[fg=%s, bg=%s, bold] %s #[fg=%s, bg=%s]%s#[fg=%s, bg=%s, bold] %s #[fg=%s, bg=default]%s " $black $pink_violet $peco_anything_prompt $pink_violet $pink $separator $gray_blue $pink $sub_prompt $pink $separator
end
