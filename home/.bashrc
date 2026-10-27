#
# ~/.bashrc
#
# Riccardo Palombo - https://riccardo.im
# Preparato per la community Patreon: patreon.com/riccardopalombo
# Qualche alias utile (bisogna installare exa!)
# 
[[ $- != *i* ]] && return

alias ls='exa -lgh'
alias ll='exa -lgha'
alias lt='exa --tree'
#alias conf='micro ~/.config/hypr/hyprland.conf'
#alias conf-term='micro ~/.config/foot/foot.ini'
#alias chx='chmod +x'
#alias dots='cd ~/Documents/dotfiles && lazygit'
#alias ddu='du -sh * | sort -hr | head -20'
#alias waykill='killall waybar && ~/scripts/waybar_top.sh && ~/scripts/waybar_bottom.sh'
#PS1='[\u@\h \W]\$ '
export TERM=xterm-256color
PS1='%F{blue}%~%f %F{red}>%F{yellow}>%F{cyan}>%f '
export MICRO_TRUECOLOR=1
if [[ $- == *i* ]] && command -v zsh &>/dev/null; then
    exec zsh
fi
