#!/bin/bash

NAME = "pusk"

while [ "$(pgrep -x "$NAME" | wc -l)" -gt 0 ]; do
    pkill -x "$NAME"
    sleep 0.2
done

~/.config/waybar/modules/pusk &
