#!/usr/bin/env bash

list_actions() {
  echo Rename Workspace
  echo Rename Window
  echo Move Window to Workspace
  echo Jump to Marked Window
  echo Open Workspace
}

get_input() {
  rofi -dmenu -P "$1" -lines 0 -config ~/.config/regolith3/looks/simons-look/rofi-dmenu-theme.rasi
}

rename_workspace() {
  name=$(get_input "Workspace Name")

  if [ "$name" ]; then
    bash -c "i3-msg 'rename workspace to \"$name\"'"
  fi
}

rename_window() {
  name=$(get_input "Window Name")
  ACTIVE_WINDOW_IDENTIFIER=$(xdotool getactivewindow)
  xdotool set_window --name "$name" $ACTIVE_WINDOW_IDENTIFIER
}

list_workspaces() {
  i3-msg -t get_workspaces | jq '.[] | .name' | sed -e 's/^"//' -e 's/"$//'
}

move_window_to_workspace() {
  name=$(list_workspaces | get_input "Workspace")
  i3-msg "move to workspace $name"
}

list_marked_windows() {
  echo -en $( i3-msg -t get_tree | jq '[.. | arrays | .[] | objects | select(.marks) | select(.marks != []) | [.name, .window_properties.class, (.marks | .[])] | join("\t")] | join("\n")' | sed -e 's/"//g')
}

jump_to_marked_window() {
  chosen_window=$(list_marked_windows | get_input "Window" | cut -f 3)
  i3-msg "[con_mark=$chosen_window] focus"
}

open_workspace() {
  name=$(list_workspaces | get_input "Workspace")
  i3-msg "workspace $name"
}

if [ "$1" = "Rename Workspace" ]; then
  coproc ( rename_workspace  > /dev/null 2>&1 )
  exit 0
elif [ "$1" = "Rename Window" ]; then
  coproc ( rename_window  > /dev/null 2>&1 )
  exit 0
elif [ "$1" = "Move Window to Workspace" ]; then
  coproc ( move_window_to_workspace > /dev/null 2>&1 )
  exit 0
elif [ "$1" = "Jump to Marked Window" ]; then
  coproc ( jump_to_marked_window > /dev/null 2&1 )
  exit 0
elif [ "$1" = "Open Workspace" ]; then
  coproc ( open_workspace > /dev/null 2&1 )
  exit 0
else
  list_actions
fi
