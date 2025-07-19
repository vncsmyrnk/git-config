os := `cat /etc/os-release | grep "^NAME=" | cut -d "=" -f2 | tr -d '"'`

scripts_path := "${SU_SCRIPTS_PATH:-$HOME/.config/util/scripts}/git"
config_path := "${SU_RC_SOURCE_PATH:-$HOME/.config/setup}/git"
on_update_scripts_path := "${SU_SCRIPTS_ON_UPDATE_PATH:-$HOME/.config/util/scripts/on-update}"

default:
  just --list

check-deps:
  #!/bin/bash
  dependencies=(git gh)
  missing_dependencies=($(for dep in "${dependencies[@]}"; do command -v "$dep" &> /dev/null || echo "$dep"; done))

  if [ ${#missing_dependencies[@]} -gt 0 ]; then
    echo "Dependencies not found: ${missing_dependencies[*]}"
    echo "Please install them with the appropriate package manager"
    exit 1
  fi

install: check-deps config

config:
  @rm -rf ~/.gitconfig*
  envsubst < .gitconfig.private.template > .gitconfig.private
  mkdir -p  {{scripts_path}} {{config_path}} {{on_update_scripts_path}}
  stow -t {{home_dir()}} . --ignore=scripts --ignore='^config'
  stow -t {{scripts_path}} -d scripts utils
  stow -t {{config_path}} config
  stow -t {{on_update_scripts_path}} -d scripts on-update

unset-config:
  stow -D -t {{home_dir()}} . --ignore=scripts --ignore='^config'
  stow -D -t {{scripts_path}} -d scripts utils
  stow -D -t {{config_path}} config
  stow -D -t {{on_update_scripts_path}} -d scripts on-update
