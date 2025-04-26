#!/bin/sh

command -v gh >/dev/null || {
  echo "gh not installed, no update needed."
  exit 0
}

gh extension upgrade copilot
