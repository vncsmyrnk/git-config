#!/bin/sh

command -v gh >/dev/null || {
  exit 0
}

gh extension upgrade copilot
