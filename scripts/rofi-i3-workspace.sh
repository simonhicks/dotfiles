#!/usr/bin/env bash

# get list of workspaces
list_workspaces() {
  i3-msg -t get_workspaces | jq '.[] | .name' | sed -e 's/^"//' -e 's/"$//'
}

# switch to named workspace
focus_workspace() {
  i3-msg "workspace $@" > /dev/null
  return 0
}

if [ "$1" ]; then
  focus_workspace "$@"
  exit 0
else
  list_workspaces
fi
