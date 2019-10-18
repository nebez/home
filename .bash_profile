 # If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# If you'd like to use existing homebrew v1 completions, uncomment the following line:
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Colored prompt magic...
if [ -f ~/.git-prompt.sh ]; then
    export GIT_PS1_SHOWCOLORHINTS=1
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_DESCRIBE_STYLE="branch"

    get_sha() {
        git rev-parse --short HEAD 2>/dev/null
    }

    error_test() {
        local EXITCODE="$?"

        local LIGHTRED="\033[1;31m"
        local RESET="\033[0;00m"

        if [[ "$EXITCODE" != "0" ]]; then
            echo -e "${LIGHTRED}[${EXITCODE}]${RESET}"
        fi
    }

    # λ $
    PROMPT_COMMAND='__git_ps1 "\n\[\e[32m\]\u \[\e[33m\]\w\[\e[0m\] " " $(error_test)\nλ " "(%s \e[1;37m$(get_sha)\e[0m)"'
fi

# Fix for gpg passphrase prompt
# https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)
