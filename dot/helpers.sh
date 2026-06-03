#!/bin/bash

# prints the input
function print_my_input() {
  echo 'Your input: ' $1
}


# creates a file and its parent directories
function mkdir_and_touch () {
  FILEPATH=$1
  DIR=$(dirname "${FILEPATH}")
  mkdir -p $DIR && touch $FILEPATH
}

alias mt="mkdir_and_touch"


# Open or attach the secureframe tmux session.
# Windows 1-10 map to ~/dev/secureframe-1..10.
function sf () {
  local session="sf"

  if tmux has-session -t "$session" 2>/dev/null; then
    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$session"
    else
      tmux attach -t "$session"
    fi
    return
  fi

  tmux new-session -d -s "$session" -n "sf-1" -c "$HOME/dev/secureframe-1"
  for i in 2 3 4 5 6 7 8 9 10; do
    tmux new-window -t "$session:$i" -n "sf-$i" -c "$HOME/dev/secureframe-$i"
  done
  tmux select-window -t "$session:1"

  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session"
  else
    tmux attach -t "$session"
  fi
}
