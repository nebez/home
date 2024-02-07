# home

https://www.atlassian.com/git/tutorials/dotfiles

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
