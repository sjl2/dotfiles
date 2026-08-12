# Packages installed by setup.sh via `brew bundle install`.
#
# This file is the source of truth for what gets installed. setup.sh runs it in
# additive mode (no --cleanup), so anything you install by hand survives.
#
#   brew bundle check --file=Brewfile --verbose   # what's missing?
#   brew bundle install --file=Brewfile           # install it

tap "nodenv/nodenv"

# CLI
brew "cmake"
brew "fzf"
brew "gh"
brew "goenv"
brew "jq"
brew "nodenv"
brew "nodenv/nodenv/nodenv-default-packages"
brew "openssl@3"
brew "pipenv"
brew "postgresql@18"
brew "pyenv"
brew "ripgrep"
brew "tmux"
brew "tree"
brew "vim"
brew "wget"
brew "yarn"
brew "zsh"
brew "zsh-syntax-highlighting" # sourced by dot/zshrc

# zsh-autosuggestions is deliberately absent: dot/zshrc loads it as an oh-my-zsh
# plugin, which setup.sh clones separately. Installing the formula too is a no-op.

# GUI
cask "claude-code" # does not auto-update; brew upgrade --cask claude-code
cask "docker-desktop"
cask "font-meslo-lg-nerd-font" # Nerd Fonts supply the glyphs robin.zsh-theme needs
cask "ghostty"
cask "google-chrome"
cask "rectangle"
cask "visual-studio-code"
