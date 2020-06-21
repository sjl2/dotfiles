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
