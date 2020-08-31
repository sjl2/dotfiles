#!/bin/bash

# TODO: install xcode and git
# TODO: seek inspiration from https://github.com/monfresh/laptop

# CLI Apps to install (e.g. brew install <app>)
APPS=''
APPS+=' ag'
APPS+=' cmake'
APPS+=' fzf'
APPS+=' nvim'
APPS+=' goenv'
APPS+=' jq'
APPS+=' postgres'
APPS+=' pipenv'
APPS+=' pyenv'
APPS+=' nodenv'
APPS+=' nodenv/nodenv/nodenv-default-packages'
APPS+=' reattach-to-user-namespace'
APPS+=' ripgrep'
APPS+=' tmux'
APPS+=' tree'
APPS+=' vim'
APPS+=' wget'
APPS+=' yarn'
APPS+=' zsh'
APPS+=' zsh-autosuggestions'
APPS+=' zsh-completions'
APPS+=' zsh-syntax-highlighting'

# Apps to install with GUIs & Licenses (e.g. requires brew cask)
APPS_GUI=''
APPS_GUI+=' docker'
APPS_GUI+=' google-chrome'
APPS_GUI+=' insomnia'
APPS_GUI+=' iterm2'
APPS_GUI+=' shiftit'
APPS_GUI+=' slack'

# Variables
DOTFILES_DIR=~/dotfiles
OLD_DIR=$DOTFILES_DIR/old

# Ensure we're in the dotfiles directory
cd $DOTFILES_DIR

# List of dotfiles for home directory
DOTFILES=''
DOTFILES+=' aliases'
DOTFILES+=' bash_profile'
DOTFILES+=' config'
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
  echo "Installing$APPS..."
  brew install $APPS 2> /dev/null

  echo "Installing$APPS_GUI..."
  brew cask install $APPS_GUI 2> /dev/null
}

echo
echo "Setting up dependencies..."
if [[ $OSTYPE == darwin* ]]; then
  install_brew()
  install_apps()

  if [ ! -d ~/.oh-my-zsh ]; then
    echo "Installing Oh My Zsh..."
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
    chsh -s /bin/zsh
  fi
  if [ ! -d ~/.rvm ]; then
    echo "Installing rvm..."
    \curl -sSL https://get.rvm.io | bash
  fi
  echo "Installing fzf extensions..."
  /usr/local/opt/fzf/install
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
  mkdir $OLD_DIR
fi

for f in $DOTFILES; do
  if check_file ~/.$f; then
    echo "Copying old ~/.$f into $OLD_DIR..."
    cp ~/.$f $OLD_DIR/.$f
  fi
  ln -sf $DOTFILES_DIR/dot/$f ~/.$f
done
echo "...done"
echo

# TODO: replace with neovim
echo
echo "Setting up vim..."
if [ ! -d ~/.vim/bundle ]; then
  mkdir -p ~/.vim/bundle
  mkdir -p ~/.vim/undo
  git clone https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
  cd ~/.vim/bundle/YouCompleteMe
  git submodule update --init --recursive
  ./install.sh
  cd $DOTFILES_DIR
  vim +PluginInstall +qall
fi
echo "...done"
echo

echo
echo "Setting up zsh..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
mkdir -p ~/.oh-my-zsh/custom/themes
if check_file ~/.oh-my-zsh/custom/themes/robin.zsh-theme; then
  echo "Copying old robin.zsh-theme into $OLD_DIR..."
  cp ~/.oh-my-zsh/custom/themes/robin.zsh-theme $OLD_DIR
fi
ln -sf $DOTFILES_DIR/robin.zsh-theme ~/.oh-my-zsh/custom/themes
echo "...done"
echo

echo
echo "Setting up iTerm2..."
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
if check_file '~/Library/Application Support/iTerm2/DynamicProfiles/profiles.json'; then
  echo "Copying old iTerm2 profiles.json into $OLD_DIR..."
  cp ~/Library/Application\ Support/iTerm2/DynamicProfiles/profiles.json $OLD_DIR
fi

### Load Iterm Profiles
# This must be a hard link because iTerm can't read symlinks
ln -f $DOTFILES_DIR/iterm/profiles.json "~/Library/Application Support/iTerm2/DynamicProfiles"
echo "=== Make sure you set default profile in iTerm2 ==="
echo "...done"
echo
