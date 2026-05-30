# ------------------------------------------------------
# PATH
# ------------------------------------------------------
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"

# ------------------------------------------------------
# Prompt
# ------------------------------------------------------
if [ -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# ------------------------------------------------------
# Plugins (manual loading)
# ------------------------------------------------------

# Autosuggestions
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax Highlighting
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# History substring search
if [ -f /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
  source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

# ------------------------------------------------------
# Shell Options (popular)
# ------------------------------------------------------
setopt auto_cd               # cd by typing folder name
setopt correct               # ask to auto-correct command names
setopt histignorealldups     # no duplicate history entries
setopt share_history         # share history across tabs
setopt interactivecomments   # allow comments in terminal

# ------------------------------------------------------
# Completion
# ------------------------------------------------------
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit
compinit

# ------------------------------------------------------
# Aliases (your custom ones)
# ------------------------------------------------------
alias lg="lazygit"
alias ld="lazydocker"

# Common aliases
alias ll="ls -lah"
alias la="ls -A"
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."

# Git shortcuts
alias gs="git status"
alias gl="git pull"
alias gp="git push"

# NeoVim
alias vim="nvim"
export EDITOR="vim"

# ------------------------------------------------------
# Terminal title
# ------------------------------------------------------
_kitty_short_title() {
  emulate -L zsh

  local title
  local repo_root
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"

  if [[ -n "$repo_root" ]]; then
    title="${repo_root:t}"
  elif [[ "$PWD" == "$HOME" ]]; then
    title="~"
  else
    title="${PWD:t}"
  fi

  print -Pn "\e]0;${title}\a"
}

precmd_functions+=(_kitty_short_title)
chpwd_functions+=(_kitty_short_title)

# ------------------------------------------------------
# Prompt fallback (in case p10k doesn't load)
# ------------------------------------------------------
export PROMPT='%F{cyan}%n@%m%f:%F{yellow}%~%f %# '

# Created by `pipx` on 2025-12-12 16:32:01
export PATH="$PATH:/Users/maymoonabalushi/.local/bin"

# Added by Antigravity
export PATH="/Users/maymoonabalushi/.antigravity/antigravity/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
