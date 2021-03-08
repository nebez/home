alias ls='ls -G'
alias ll='ls -alG'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias df='df -h'
alias du='du -h'

alias nano='nano -wc'

alias yarn='yarn --silent'

alias clip='pbcopy'

alias clean_chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="$(mktemp -d)" --disable-extensions'

function tcurl() {
  curl -so /dev/null -w "\
                HTTP: %{http_version} %{http_code}\n\
        Content Type: %{content_type}\n\
     Number Connects: %{num_connects}\n\
    Number Redirects: %{num_redirects}\n\
        Redirect URL: %{redirect_url}\n\
       Effective URL: %{url_effective}\n\
       Size Download: %{size_download} bytes \n\
      Time Handshake: %{time_appconnect}\n\
     Time Namelookup: %{time_namelookup}\n\
        Time Connect: %{time_connect}\n\
    Time Pretransfer: %{time_pretransfer}\n\
       Time Redirect: %{time_redirect}\n\
 Time Start Transfer: %{time_starttransfer}\n\
          Time Total: %{time_total}\n\
  " "$@" | GREP_COLOR='1;30' grep -E "^.*: " --color=always
}
