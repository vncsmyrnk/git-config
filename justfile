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
  @mkdir -p "$HOME/.config/shell-setup/git"
  envsubst < .gitconfig.private.template > .gitconfig.private
  stow -t {{home_dir()}} . --ignore=scripts --ignore='^config'
  stow -t "$HOME/.config/shell-setup/git" config --no-folding
  util config add scripts/utils -t git
  util config add scripts/on-update -t on-update

unset-config:
  stow -D -t {{home_dir()}} . --ignore=scripts --ignore='^config'
  stow -D -t "$HOME/.config/shell-setup/git" config
  util config remove git --force
  (cd scripts/on-update; find -type f | cut -b 3- | xargs -I{} util config remove on-update/{} --force)
