#!/bin/bash

dir="/home/romaniusredcash/Настройки/hyprland/waybar/modules/pusk_img"
index_file="/tmp/waybar_pusk_index"

# Инициализация индекса
[ ! -f "$index_file" ] && echo 0 > "$index_file"

idx=$(cat "$index_file")

# Выводим номер кадра (1, 2, 3, 4)
echo "$((idx + 1))"

# Следующий кадр (цикл 0-3)
echo "$(( (idx + 1) % 4 ))" > "$index_file"
