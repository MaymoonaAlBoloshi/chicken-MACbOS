# dotfiles-mac

macOS dotfiles for a Linux-like tiling, bar, terminal, and wallpaper-themed workflow.

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

## Notes

AeroSpace expects TOML config at `~/.config/aerospace/aerospace.toml`.
