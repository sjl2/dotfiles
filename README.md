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
* Installs every CLI tool, GUI app, and font listed in [`Brewfile`](Brewfile) —
  that file is the source of truth, so read it rather than a list here that would drift
* Installs [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) and makes zsh the login shell
* Backs up existing dotfiles into `old/`, then symlinks `dot/*` into the home directory
* Symlinks the `robin` zsh theme
* Links VS Code settings (`code/settings.json`)
* Disables press-and-hold so key repeat works

Packages are installed additively (`brew bundle install`), so anything you install by
hand is left alone. To see what's missing without installing:

```bash
brew bundle check --file=Brewfile --verbose
```

## After setup

A few things can't be automated:

* `gh auth login` — authenticate the GitHub CLI ([docs](https://cli.github.com/manual/gh_auth_login))
* `claude` — the first run opens a browser to sign in ([docs](https://code.claude.com/docs/en/setup)).
  The Homebrew cask doesn't auto-update; run `brew upgrade --cask claude-code`.

## Platforms supported

- [x] Mac OS X
- [ ] Ubuntu
