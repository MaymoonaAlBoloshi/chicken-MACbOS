<div align="center" style="display: flex; align-items: center; gap: 16px;">
  <h1>chicken MACbOS / my dotfiles on mac</h1>

  <img
    width="122"
    height="80"
    alt="image"
    src="https://github.com/user-attachments/assets/419bd15b-a84c-468f-9d03-15e69ddbaeff"
  />
</div>

macOS dotfiles for a Linux-like tiling, bar, terminal, and wallpaper-themed workflow. note btop is not auto themed for nwo

<img width="2580" height="1446" alt="image" src="https://github.com/user-attachments/assets/cef71c87-8230-4886-9283-cf78b9639205" />
<img width="2580" height="1446" alt="image" src="https://github.com/user-attachments/assets/471506d6-a2e8-44d8-b513-994450ac7c7a" />
<img width="2580" height="1446" alt="image" src="https://github.com/user-attachments/assets/9e52b097-55ca-4112-9a71-c9bede1cdbe0" />

## Modules

- `aerospace`: tiling window manager config
- `sketchybar`: menu bar replacement and plugins
- `kitty`: terminal config and wal color include
- `wal`: pywal hooks
- `zsh`: shell config and Powerlevel10k prompt config
- `bin`: helper scripts

## Install

From this directory:

```sh
stow aerospace sketchybar kitty wal zsh bin
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
```

Start services and apps:

```sh
brew services start sketchybar
open -a AeroSpace
```

Then in macOS System Settings:

- Give AeroSpace Accessibility permissions.
- Give your terminal/AeroSpace permission to control System Events if macOS asks when using the wallpaper hotkey.
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

To switch to the next Irvue wallpaper and immediately sync colors:

```sh
~/bin/irvue-next-wal.sh
```

AeroSpace binds this to `cmd+shift+w`.
