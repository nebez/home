alias ls='ls --color=auto --group-directories-first'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias df='df -h'
alias du='du -h'

alias nano='nano -wuc'

alias yarn='yarn --silent'

alias clip='xclip -selection clipboard'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

e.() {
    nautilus --no-desktop --browser ${1:-.} &> /dev/null &
}
