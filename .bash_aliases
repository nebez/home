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

alias tcurl='curl -so /dev/null -w "\nContent Type: %{content_type} \
\nHTTP Code: %{http_code} \
\nHTTP Connect:%{http_connect} \
\nNumber Connects: %{num_connects} \
\nNumber Redirects: %{num_redirects} \
\nRedirect URL: %{redirect_url} \
\nSize Download: %{size_download} \
\nSize Upload: %{size_upload} \
\nSSL Verify: %{ssl_verify_result} \
\nTime Handshake: %{time_appconnect} \
\nTime Connect: %{time_connect} \
\nName Lookup Time: %{time_namelookup} \
\nTime Pretransfer: %{time_pretransfer} \
\nTime Redirect: %{time_redirect} \
\nTime Start Transfer: %{time_starttransfer} \
\nTime Total: %{time_total} \
\nEffective URL: %{url_effective}\n"'
