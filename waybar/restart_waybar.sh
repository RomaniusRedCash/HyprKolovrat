#!/bin/bash


while pgrep -u $USER -x waybar >/dev/null; do
pkill -x waybar
sleep 1
done
while pgrep -u $USER -x kded6 >/dev/null; do
pkill -x kded6
sleep 1
done

hyprctl dispatch exec waybar &
