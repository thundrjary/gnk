#
# ~/.bash_profile
#
# Launch Hyprland only once, only on the first console (tty1)
if [[ -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
    exec Hyprland
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc


