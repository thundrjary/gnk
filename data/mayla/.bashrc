#
# ~/.bashrc
#
[[ $- != *i* ]] && return

prettytree() {
    echo -e "\n\033[1;35m🌳 What's in here:\033[0m"
    tree -C --dirsfirst -F -L ${1:-2} --charset=utf-8 | sed "s/├──/📁 /g; s/└──/📁 /g; s/│   /    /g; s/│  /   /g; s/│ /  /g"
}

alias look='prettytree'
alias ls='ls -1 --color=auto'
alias grep='grep --color=auto'
#PS1='\n\[\033[0;90m\]📁 WHERE YOU ARE:\[\033[0m\] \[\033[1;34m\]\w\[\033[0m\]\n\[\033[0;90m\]MAGIC WORDS:\[\033[0m\] \[\033[1;36m\]ls\[\033[0m\] \[\033[0;90m\](see files)\[\033[0m\] • \[\033[1;36m\]cd\[\033[0m\] \[\033[0;90m\](go)\[\033[0m\] • \[\033[1;36m\]pwd\[\033[0m\] \[\033[0;90m\](where am I?)\[\033[0m\] • \[\033[1;36m\]look\[\033[0m\] \[\033[0;90m\](map)\[\033[0m\] • \[\033[1;36m\]./\[\033[0m\] \[\033[0;90m\](run)\[\033[0m\]\n\[\033[1;35m\]→\[\033[0m\] \[\033[0;90m\](help)\[\033[0m\]\n\[\033[1;35m\]→\[\033[0m\] '
PS1='\n\[\033[0;90m\]📁 WHERE YOU ARE:\[\033[0m\] \[\033[1;34m\]\w\[\033[0m\]\n\[\033[0;90m\]MAGIC WORDS:\[\033[0m\] \[\033[1;36m\]ls\[\033[0m\] \[\033[0;90m\](see files)\[\033[0m\] • \[\033[1;36m\]cd\[\033[0m\] \[\033[0;90m\](go)\[\033[0m\] • \[\033[1;36m\]pwd\[\033[0m\] \[\033[0;90m\](where am I?)\[\033[0m\] • \[\033[1;36m\]look\[\033[0m\] \[\033[0;90m\](map)\[\033[0m\] • \[\033[1;36m\]./\[\033[0m\] \[\033[0;90m\](run)\[\033[0m\] • \[\033[1;36m\]Ctrl+L\[\033[0m\] \[\033[0;90m\](clear screen)\[\033[0m\]\n\[\033[0;90m\]Type \[\033[0;91m\]help\[\033[0;90m\] if you need more!\[\033[0m\]\n\[\033[1;35m\]→\[\033[0m\] '


# ~/.bash_profile or ~/.bashrc

clear

videos() {
    cd ~/videos
    local prefix file
    prefix=$(printf '%s\n' * | sed -E 's/-[0-9]+(\.[^./]+)?$//' | sort -u | fzf) || return
    file=$(printf '%s\n' "${prefix}-"* | fzf) || return
    setsid "./$file" >/dev/null 2>&1 &
    clear
}
alias v='videos'

show_help() {
    echo -e "
\033[1;35m*** COMPUTER HELPER ***\033[0m

\033[1;33m╔══ WHERE TO GO ════════════════╦══ WHAT TO DO ════════════╦══ MAGIC KEYS ════════════╗\033[0m
\033[1;33m║\033[0m \033[1;36m~\033[0m     My room (/home/mayla)   \033[1;33m║\033[0m \033[1;36mls\033[0m      See all my stuff  \033[1;33m║\033[0m UP ARROW  Do it again   \033[1;33m║\033[0m
\033[1;33m║\033[0m \033[1;36m..\033[0m    The room before         \033[1;33m║\033[0m \033[1;36mclear\033[0m   Clean the screen  \033[1;33m║\033[0m TAB KEY   Finish word   \033[1;33m║\033[0m
\033[1;33m║                               ║\033[0m \033[1;36mecho\033[0m    Say something     \033[1;33m║\033[0m CTRL + C  Stop it       \033[1;33m║\033[0m
\033[1;33m╚═══════════════════════════════╩═══════════════════════════╩═════════════════════════╝\033[0m

\033[1;35mCOLORS:\033[0m
  \033[1;34mdirectory\033[0m		 Like a box to put things in 
  \033[1;32mprogram\033[0m		 Games and apps you can use
  \033[0;37mfile.txt\033[0m		 Pictures, songs, or stories

\033[1;35mTRY THESE:\033[0m
  \033[1;36mls\033[0m                     Look around
  \033[1;36mcd ~\033[0m                   Go to my room
  \033[1;36mcd /home/jarom\033[0m         Try to go to dad's room
  \033[1;36mcd ..\033[0m                  Go back out
  \033[1;36mecho hello\033[0m             Make computer say hello
  \033[1;36mecho I am 7!\033[0m           Tell computer how old you are
  \033[1;36mecho I am 7! | cowsay\033[0m  Can the COW say it?
  \033[1;36mclear\033[0m                  Clean the screen

"
}

# Dad's room is locked!
cd() {
    if [ "$1" = "/home/jarom" ]; then
        echo -e "\033[1;31m🔒 Dad's room is locked! 🔒\033[0m"
        echo -e "\033[0;90mYou need permission to go there!\033[0m"
    else
        builtin cd "$@"
    fi
}

alias help='show_help'


