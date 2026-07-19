#!/bin/bash

# if [[ "$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')" == "DVI-I-1" ]]; then
#     hyprctl dispatch movetoworkspace $((10 + $1))
# else
#     hyprctl dispatch movetoworkspace $1
# fi


MONITOR="$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')"

if [[ "$MONITOR" == "DVI-I-1" ]]; then
    hyprctl dispatch movetoworkspace $((0 + $1))
elif [[ "$MONITOR" == "DP-1" ]]; then
    hyprctl dispatch movetoworkspace $((20 + $1))
else
    hyprctl dispatch movetoworkspace $((10 + $1))
fi
