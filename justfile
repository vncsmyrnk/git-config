os := `cat /etc/os-release | grep "^NAME=" | cut -d "=" -f2 | tr -d '"'`

scripts_path := "${SU_SCRIPTS_PATH:-$HOME/.config/util/scripts}/git"
config_path := "${SU_RC_SOURCE_PATH:-$HOME/.config/setup}/git"
on_update_scripts_path := "${SU_SCRIPTS_ON_UPDATE_PATH:-$HOME/.config/util/scripts/on-update}"

default:
  just --list

install-deps:
  #!/bin/bash
  if [ "{{os}}" = "Debian GNU/Linux" ] || [ "{{os}}" = "Ubuntu" ]; then
    sudo apt-get git
    command -v nix-env >/dev/null || {
      read -p "nix has the latest version for gh, apt version is outdated. Install gh over nix or exit? (Y/n)" choice
      [[ ${choice-y} == "y" ]] || {
        exit 0
      }
    }
    nix-env -iA nixpkgs.gh
  elif [ "{{os}}" = "Arch Linux" ]; then
    sudo pacman -S git gh
  fi

install: install-deps config

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
