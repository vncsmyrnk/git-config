#!/bin/bash

stdout_file=/dev/null
stderr_file=.git-config-error-log

name=$1
email=$2

handle_error() {
  echo -e "\033[1;31m[Error]\033[0m $1"
  exit 1
}

end() {
  echo -e "\033[1;32m\nAll done.\033[0m"
  exit 0
}

if [ $(id -u) -ne 0 ]; then
  handle_error "This script requires sudo privileges for installing git"
fi

if [ -z "$name" ] || [ -z "$email" ]; then
  handle_error "Usage: git-config.sh <name> <email>"
fi

while :; do
  case $3 in
    -c|--config-only) is_config_only="SET"            
      ;;
    *) break
  esac
  shift
done

echo "Installing git..."
apt-get install -y git >> $stdout_file 2> $stderr_file || handle_error "A problem occurred while installing \033[1mgit\033[0m"

echo "Setting up git..."
git config --global user.name $name
git config --global user.email $email
git config --global --add safe.directory '*' # Fixing the dubious ownership issue
git config --global pull.ff true

echo -e "\033[1mGit installed and configured.\033[0m"

# Exits early if param --config-only is set
if [ ! -z "$is_config_only" ]; then
  end
fi

echo "Generating SSH Keys..."
ssh-keygen -t rsa -b 4096 -C $email

echo "The next line is you SSH Key. Save it on GitHub to login"
cat ~/.ssh/id_rsa.pub

end
