# home

https://www.atlassian.com/git/tutorials/dotfiles

## setup

These dotfiles are meant to be opt-in. The repo provides partial files under
`.config/`; it should not own or overwrite local startup files like
`~/.zprofile` and `~/.zshrc`.

To enable the shared zsh login/session setup, add this to `~/.zprofile`:

```zsh
[[ -r "$HOME/.config/zsh/profile.zsh" ]] && source "$HOME/.config/zsh/profile.zsh"
```

To enable the shared interactive zsh setup, add this to `~/.zshrc`:

```zsh
[[ -r "$HOME/.config/zsh/rc.zsh" ]] && source "$HOME/.config/zsh/rc.zsh"
```

To enable the shared SSH setup, add this to `~/.ssh/config`:

```sshconfig
Include ~/.config/ssh/config
```

## qol changes

show app switcher on all displays [[source]](https://superuser.com/a/1625752)

```
defaults write com.apple.Dock appswitcher-all-displays -bool true
killall Dock
```

## `bin`

To bind more loopback interfaces other than 127.0.0.1, there's a launch daemon
built specifically for Darwin in `bin/localhost_alias`. Install and
uninstall it by running these commands:

```bash
./bin/localhost_alias/install
./bin/localhost_alias/uninstall
```

Currently it binds from `.10` to `.20` (inclusive). Adjust the `.plist` file to expand or contract the range.
