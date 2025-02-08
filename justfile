os := `cat /etc/os-release | grep "^NAME=" | cut -d "=" -f2 | tr -d '"'`

utils_path := "${UTILS_SCRIPTS_DIR:-$HOME/utils}"

default:
  just --list

install-deps:
  #!/bin/bash
  if [ "{{os}}" = "Debian GNU/Linux" ] || [ "{{os}}" = "Ubuntu" ]; then
    sudo apt-get git
  elif [ "{{os}}" = "Arch Linux" ]; then
    sudo pacman -S git
  fi

install: install-deps config

config:
  @rm -rf ~/.gitconfig*
  envsubst < .gitconfig.private.template > .gitconfig.private
  stow -t {{home_dir()}} . --ignore=utils
  stow -t {{utils_path}} utils

unset-config:
  stow -D -t {{home_dir()}} . --ignore=utils
  stow -D -t {{utils_path}} utils
