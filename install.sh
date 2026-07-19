#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

HYPRLANDCONF="hypr_lua"
CONF_PATH="$HOME/.config"
BIN_PATH="$HOME/.local/bin"
FONTS_PATH="$HOME/.local/share/fonts"
CURSOR_PATH="$HOME/.local/share/icons"

create_link() {
    if [ -e "$2" ] || [ -L "$2" ]; then
        echo "Файл/ссылка $2 уже существует, пропускаем."
    else
        echo "Ссылка: $1 -> $2"
        ln -s "$1" "$2"
    fi
}

for i in hyprpaper.conf hyprlock.conf; do
    create_link "$BASE_DIR/$HYPRLANDCONF/$i" "$CONF_PATH/hypr/$i"
done

create_link "$BASE_DIR/$HYPRLANDCONF" "$CONF_PATH/hypr"

for i in quickshell dunst wofi; do
    create_link "$BASE_DIR/$i" "$CONF_PATH/$i"
done

create_link "$BASE_DIR/hyprshot-gui.sh" "$BIN_PATH/hyprshot-gui"
create_link "$BASE_DIR/VHS+icons.ttf" "$FONTS_PATH/VHS+icons.ttf"
create_link "$BASE_DIR/minecur" "$CURSOR_PATH/minecur"
