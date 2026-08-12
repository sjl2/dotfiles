# Dotfiles

User configurations that are tailored to my liking.

## Prerequisites

**Xcode Command Line Tools** — the only thing you need before running `setup.sh`.
They supply `git` (to clone this repo) and the compilers Homebrew depends on:

```bash
xcode-select --install
```

See [Apple's Xcode resources](https://developer.apple.com/xcode/resources/) if you
want the full Xcode app or a specific version. Everything else is installed for you.

## Usage

```bash
cd ~
git clone https://github.com/sjl2/dotfiles.git dotfiles
cd dotfiles
./setup.sh
```

The repo must live at `~/dotfiles` — `setup.sh` symlinks out of that path.

## What does it do?

* Installs [Homebrew](https://brew.sh/)
* Installs CLI tools:
  cmake, fzf, [gh](https://cli.github.com), jq, postgres, pipenv, pyenv, nodenv,
  openssl, ripgrep, tmux, tree, vim, wget, yarn, and zsh with
  zsh-autosuggestions, zsh-completions, and zsh-syntax-highlighting
* Installs GUI apps:
  [Claude Code](https://code.claude.com/docs/en/setup), Docker, Google Chrome,
  Insomnia, iTerm2, ShiftIt, Slack, and Visual Studio Code
* Installs [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) and makes zsh the login shell
* Backs up existing dotfiles into `old/`, then symlinks `dot/*` into the home directory
* Symlinks the `robin` zsh theme and installs [Powerline fonts](https://github.com/powerline/fonts)
* Links iTerm2 profiles (`iterm/profiles.json`) and VS Code settings (`code/settings.json`)
* Disables press-and-hold so key repeat works

## After setup

A few things can't be automated:

* `gh auth login` — authenticate the GitHub CLI ([docs](https://cli.github.com/manual/gh_auth_login))
* `claude` — the first run opens a browser to sign in ([docs](https://code.claude.com/docs/en/setup)).
  The Homebrew cask doesn't auto-update; run `brew upgrade --cask claude-code`.
* Set the default profile in iTerm2

## Platforms supported

- [x] Mac OS X
- [ ] Ubuntu
