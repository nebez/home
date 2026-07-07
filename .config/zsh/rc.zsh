if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

autoload -U promptinit
promptinit
zstyle :prompt:pure:git:stash show yes
zstyle :prompt:pure:git:dirty detailed yes
zstyle :prompt:pure:environment:node_version show yes
zstyle :prompt:pure:environment:node_version symbol '⬢ '
zstyle :prompt:pure:environment:nix-shell show no
zstyle :prompt:pure:path:separator dim yes
prompt pure

[[ -r "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"
