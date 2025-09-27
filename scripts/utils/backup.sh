#!/usr/bin/env bash

# This script creates a copy of the current git branch
# on the origin remote. The backup branch should be
# the original name prefixed by "bkp/".
#
# help: creates a backup of the current branch
#
# Completions
# --name[Backup branch suffix]:name:

REMOTE=${REMOTE:-origin}

backup_name=""

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --name)
      if [[ -n "$2" && "$2" != --* ]]; then
        backup_name="$2"
        shift
      fi
      ;;
    --) # End of all options
      shift
      break
      ;;
  esac
  shift
done

main() {
  target_backup_name=""
  if [ -n "$backup_name" ]; then
    target_backup_name="-$backup_name"
  fi

  current_branch=$(git rev-parse --abbrev-ref HEAD)
  target_branch=$(echo "bkp/$current_branch$target_backup_name")

  git push "$REMOTE" HEAD:"$target_branch" $@ # extra arguments will be passed to git itself
}

main "$@"
