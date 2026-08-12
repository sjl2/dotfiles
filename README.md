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
* Links Ghostty (`ghostty/config`) and VS Code (`code/settings.json`) settings
* Links Claude Code config and skills from [`agents/`](agents/README.md) into `~/.claude`
* Disables press-and-hold so key repeat works

Packages are installed additively (`brew bundle install`), so anything you install by
hand is left alone. To see what's missing without installing:

```bash
brew bundle check --file=Brewfile --verbose
```

## Claude Code on a machine you can't clone into

This repo doubles as a Claude Code marketplace, so a work machine can have the
config without a dotfiles install:

```
/plugin marketplace add sjl2/dotfiles
/plugin install sjl2@sjl2-dotfiles
```

Use one path or the other on a given machine, not both — see
[`agents/README.md`](agents/README.md) for why, and for how the skills are organised.

## After setup

A few things can't be automated:

* `gh auth login` — authenticate the GitHub CLI ([docs](https://cli.github.com/manual/gh_auth_login))
* `claude` — the first run opens a browser to sign in ([docs](https://code.claude.com/docs/en/setup)).
  The Homebrew cask doesn't auto-update; run `brew upgrade --cask claude-code`.

`~/.claude/settings.json` and `~/.claude/CLAUDE.md` are symlinks into this repo, and
Claude Code writes through them — so `/config` changes show up as a `git diff`.

## Platforms supported

- [x] Mac OS X
- [ ] Ubuntu
