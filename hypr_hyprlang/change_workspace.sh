#!/bin/bash

MONITOR="$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')"

if [[ "$MONITOR" == "DVI-I-1" ]]; then
    hyprctl dispatch workspace $((0 + $1))
elif [[ "$MONITOR" == "DP-1" ]]; then
    hyprctl dispatch workspace $((20 + $1))
else
    hyprctl dispatch workspace $((10 + $1))
fi
