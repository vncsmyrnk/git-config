#!/usr/bin/env bash

# [help]
# Adds current gh user as a reviewer for a PR.
#
# The gh client is necessary for updating the PR.
#
# Usage: NUM

deps=(gh jq)
command -v $deps >/dev/null || {
  echo "Install all dependencies before using this command: ${deps[@]}"
  exit 1
}

if [ -z "$1" ]; then
  echo "A PR number is required."
  exit 1
fi

pr_number="$1"

gh_user_name=$(gh api user | jq -r .login)
if [ -z "$gh_user_name" ]; then
  echo "Not possible to retrieve GH user name via gh."
  exit 1
fi

gh pr edit "$pr_number" --add-reviewer "$gh_user_name"
