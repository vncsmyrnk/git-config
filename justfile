os := `cat /etc/os-release | grep "^NAME=" | cut -d "=" -f2 | tr -d '"'`

scripts_path := "${SU_SCRIPTS_PATH:-$HOME/.config/util/scripts}/git"
config_path := "${UTILS_RC_PATH:-$HOME/.utils/rc}/git"

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
  mkdir -p {{scripts_path}} {{config_path}}
  stow -t {{home_dir()}} . --ignore=scripts --ignore='^config'
  stow -t {{scripts_path}} scripts
  stow -t {{config_path}} config

unset-config:
  stow -D -t {{home_dir()}} . --ignore=scripts --ignore='^config'
  stow -D -t {{scripts_path}} scripts
  stow -D -t {{config_path}} config
