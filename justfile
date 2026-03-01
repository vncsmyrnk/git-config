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
  stow -t {{home_dir()}} . --ignore=scripts --ignore='^config'
  util config add scripts/utils -t git
  util config add config -p setup -t git
  util config add scripts/on-update -p scripts/on-update

unset-config:
  stow -D -t {{home_dir()}} . --ignore=scripts --ignore='^config'
  util config remove scripts/git --force
  util config remove setup/git --force
  util config remove scripts/on-update --original-source scripts/on-update --force
