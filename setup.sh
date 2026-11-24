#!/bin/bash

# TODO: seek inspiration from https://github.com/monfresh/laptop

# Packages live in ./Brewfile

# Variables
DOTFILES_DIR=~/dotfiles
OLD_DIR=$DOTFILES_DIR/old

# Ensure we're in the dotfiles directory
cd $DOTFILES_DIR

# List of dotfiles for home directory
DOTFILES=''
DOTFILES+=' aliases'
DOTFILES+=' bash_profile'
DOTFILES+=' helpers.sh'
DOTFILES+=' gitconfig'
DOTFILES+=' goto.sh'
DOTFILES+=' inputrc'
DOTFILES+=' psqlrc'
DOTFILES+=' tmux.conf'
DOTFILES+=' vimrc'
DOTFILES+=' zshrc'

# Checks if a file exists but isn't a symlink
function check_file () {
  [ -f "$1" ] && [ ! -h "$1" ]
}

function install_brew () {
  if ! type brew > /dev/null 2>&1; then
    echo "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

function install_apps () {
  echo "Installing packages from Brewfile..."
  # --adopt lets casks take over apps already in /Applications (e.g. a Chrome you
  # installed by hand) instead of erroring out on the existing bundle.
  HOMEBREW_CASK_OPTS="--adopt" brew bundle install --file="$DOTFILES_DIR/Brewfile"
}

echo
echo "Setting up dependencies..."
if [[ $OSTYPE == darwin* ]]; then
  install_brew
  install_apps

  if [ ! -d ~/.oh-my-zsh ]; then
    echo "Installing Oh My Zsh..."
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
    chsh -s /bin/zsh
  fi
  echo "Installing fzf extensions..."
  "$(brew --prefix)/opt/fzf/install" --all --no-bash
fi
echo "...done"
echo

echo
echo "Copying home directory dotfiles..."
# Create directory to house current dotfiles
# as a backup so you can restore your previous
# setup
if [ ! -e $OLD_DIR ]; then
  echo "Creating directory for current dotfiles: $OLD_DIR..."
fi
mkdir -p $OLD_DIR

for f in $DOTFILES; do
  if check_file ~/.$f; then
    echo "Copying old ~/.$f into $OLD_DIR..."
    cp ~/.$f $OLD_DIR/.$f
  fi
  ln -sf $DOTFILES_DIR/dot/$f ~/.$f
done
echo "...done"
echo

echo
echo "Setting up vim..."
mkdir -p ~/.vim/undo
echo "...done"
echo

echo
echo "Setting up zsh..."
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
fi
mkdir -p ~/.oh-my-zsh/custom/themes
if check_file ~/.oh-my-zsh/custom/themes/robin.zsh-theme; then
  echo "Copying old robin.zsh-theme into $OLD_DIR..."
  cp ~/.oh-my-zsh/custom/themes/robin.zsh-theme $OLD_DIR
fi
ln -sf $DOTFILES_DIR/robin.zsh-theme ~/.oh-my-zsh/custom/themes
echo "...done"
echo

echo
echo "Setting up Ghostty..."
mkdir -p ~/.config/ghostty
if check_file ~/.config/ghostty/config; then
  echo "Copying old ghostty config into $OLD_DIR..."
  cp ~/.config/ghostty/config $OLD_DIR/ghostty-config
fi
ln -sf $DOTFILES_DIR/ghostty/config ~/.config/ghostty/config
echo "...done"
echo

echo
echo "Setting up VS Code..."
mkdir -p ~/Library/Application\ Support/Code/User
if check_file "$HOME/Library/Application Support/Code/User/settings.json"; then
  echo "Copying old settings.json into $OLD_DIR..."
  cp ~/Library/Application\ Support/Code/User/settings.json $OLD_DIR/vscode-settings.json
fi
ln -sf $DOTFILES_DIR/code/settings.json ~/Library/Application\ Support/Code/User/settings.json
echo "...done"
echo

echo
echo "Setting up Claude Code..."
# Soft-fail here and hard-fail at the end: this script has no `set -e` and is a
# long linear installer, so aborting mid-run would leave a half-configured
# machine. A silent failure is worse, hence the exit code below.
AI_SETUP_FAILED=0
if [ -x "$DOTFILES_DIR/scripts/setup-ai.sh" ]; then
  "$DOTFILES_DIR/scripts/setup-ai.sh" || AI_SETUP_FAILED=1
else
  echo "scripts/setup-ai.sh is missing or not executable - skipping"
  AI_SETUP_FAILED=1
fi
if [ "$AI_SETUP_FAILED" -eq 1 ]; then
  echo "...FAILED (continuing; see the warning at the end)"
else
  echo "...done"
fi
echo

echo
echo "Setting macOS preferences..."
if [[ $OSTYPE == darwin* ]]; then
  # Keyboard: press-and-hold off so keys repeat, at the fastest rate and shortest delay
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
  # Tab moves focus between all controls, not just text fields and lists
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

  # Caps Lock -> Control. Copied rather than symlinked: launchd can skip symlinked
  # agents at login.
  CAPSLOCK_AGENT=com.sjl2.capslock-to-control.plist
  mkdir -p ~/Library/LaunchAgents
  if [ -f ~/Library/LaunchAgents/$CAPSLOCK_AGENT ] &&
     ! cmp -s ~/Library/LaunchAgents/$CAPSLOCK_AGENT $DOTFILES_DIR/macos/$CAPSLOCK_AGENT; then
    echo "Copying old $CAPSLOCK_AGENT into $OLD_DIR..."
    cp ~/Library/LaunchAgents/$CAPSLOCK_AGENT $OLD_DIR
  fi
  cp $DOTFILES_DIR/macos/$CAPSLOCK_AGENT ~/Library/LaunchAgents/
  # The agent only runs at login, so apply the mapping now as well
  /usr/bin/hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}' > /dev/null

  # Trackpad: faster tracking, tap to click, three-finger drag. Written to both the
  # built-in and Bluetooth (Magic Trackpad) domains. Three-finger drag takes over the
  # three-finger swipes, so they move to four fingers.
  defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  for domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
    defaults write $domain Clicking -bool true
    defaults write $domain TrackpadThreeFingerDrag -bool true
    defaults write $domain TrackpadThreeFingerHorizSwipeGesture -int 0
    defaults write $domain TrackpadThreeFingerVertSwipeGesture -int 0
    defaults write $domain TrackpadFourFingerHorizSwipeGesture -int 2
    defaults write $domain TrackpadFourFingerVertSwipeGesture -int 2
  done

  # Dark mode. Uses defaults rather than osascript, which would switch it immediately
  # but needs an Automation permission prompt for System Events.
  defaults write NSGlobalDomain AppleInterfaceStyle -string Dark
fi
echo "...done (log out and back in for keyboard, trackpad and appearance changes)"
echo

echo
echo "Untracked leftovers you may want to remove:"
echo "  brew uninstall reattach-to-user-namespace the_silver_searcher neovim"
echo

if [ "${AI_SETUP_FAILED:-0}" -eq 1 ]; then
  echo "WARNING: Claude Code setup failed. Re-run it on its own:"
  echo "  ~/dotfiles/scripts/setup-ai.sh"
  echo
  exit 1
fi
