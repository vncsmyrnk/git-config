#!/usr/bin/env bash

# This script uses the github cli for adding the current
# user as a reviewer for the PR number passed as an argument
#
# help: adds my gh user as a reviewer for a PR

deps=(gh jq)
command -v $deps >/dev/null || {
  echo "Install all dependencies before using this command: ${deps[@]}"
  exit 1
}

if [ -z "$1" ]; then
  echo "usage: pr-add-me-as-reviewer <PR_NUMBER>"
  exit 1
fi

pr_number="$1"

gh_user_name=$(gh api user | jq -r .login)
if [ -z "$gh_user_name" ]; then
  echo "not possible to retrieve GH user name via gh"
  exit 1
fi

gh pr edit "$pr_number" --add-reviewer "$gh_user_name"
