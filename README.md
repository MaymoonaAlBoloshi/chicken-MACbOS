# dotfiles-mac

macOS dotfiles for a Linux-like tiling, bar, terminal, and wallpaper-themed workflow.

## Modules

- `aerospace`: tiling window manager config
- `sketchybar`: menu bar replacement and plugins
- `kitty`: terminal config and wal color include
- `wal`: pywal hooks
- `zsh`: shell config and Powerlevel10k prompt config
- `bin`: helper scripts
- `launchagents`: background wal sync for wallpaper changes

## Install

From this directory:

```sh
stow aerospace sketchybar kitty wal zsh bin
cp launchagents/Library/LaunchAgents/com.maymoona.wal-sync.plist ~/Library/LaunchAgents/
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.maymoona.wal-sync.plist
```

## New Mac Bootstrap

Install Homebrew:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install required packages and apps:

```sh
brew install git gh gnupg coreutils wget stow pipx powerlevel10k zsh-autosuggestions zsh-syntax-highlighting sketchybar kitty wezterm ghostty bpytop osx-cpu-temp
brew install --cask nikitabobko/tap/aerospace font-jetbrains-mono-nerd-font ubersicht
```

Install pywal:

```sh
pipx install pywal
pipx ensurepath
```

Clone and stow:

```sh
cd ~
git clone <your-github-url>/dotfiles-mac.git
cd dotfiles-mac
stow aerospace sketchybar kitty wal zsh bin
cp launchagents/Library/LaunchAgents/com.maymoona.wal-sync.plist ~/Library/LaunchAgents/
```

Start services and apps:

```sh
brew services start sketchybar
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.maymoona.wal-sync.plist
open -a AeroSpace
```

Then in macOS System Settings:

- Give AeroSpace Accessibility permissions.
- Give `/bin/bash` Full Disk Access if you want the wal LaunchAgent to read Irvue wallpapers in the app container.
- Enable menu bar auto-hide.
- Confirm AeroSpace starts at login.
- Set keyboard, trackpad, Mission Control, and Dock preferences.

Verify:

```sh
aerospace list-workspaces --all
sketchybar --query bar
~/bin/irvue-wal-sync.sh --force
```

## Notes

AeroSpace expects TOML config at `~/.config/aerospace/aerospace.toml`.

The wal sync script can be run manually at any time:

```sh
~/bin/irvue-wal-sync.sh --force
```

The LaunchAgent runs the same script every five minutes and no-ops when the detected wallpaper has not changed.
