if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

[[ -r "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"
