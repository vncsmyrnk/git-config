#!/usr/bin/env bash

# This script generates a new ssh key
# for the current git email
#
# help: generates a new ssh key for the current git user

email=$(git config user.email)

if [ -z "$email" ]; then
  echo "Please set git config name and email first."
  exit 1
fi

ssh-keygen -t ed25519 -C "$email"
xclip -selection clipboard <~/.ssh/id_ed25519.pub
echo "key copied to clipboard"
