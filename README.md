# Hyprland config

Скопировать (или создать ссылки) вручную, или использовать `install.sh`.

**hypr**: есть старая конфигурация на hyprlang и новая на lua.

**hyprshot-gui**: когда-то нашёл на гитхабе, потом его потёрли. Я добавли функцию извлечения папки pictures через XDG переменные. Нужно добавить в `~/.bash_profile`: 
```bash
export PATH="$PATH:$HOME/.local/bin
```

**waybar**: от него отказался, но вдург пригодится. Там есть отключённая анимашка `pusk.cpp`, её билдить надо.

**quickshell**: для работы нужен mpc, mpd, mpdris2-rs, playerctl. По умолчанию настроена на nvidia + radeon, при другой конфигурации требуется редакция `hyprland/quickshell/modules/Gpu.qml`. Так же для работы необходимо сбилдить hyprland/quickshell/modules/cpu_parcer (`cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build` в каталоге) и `hyprland/quickshell/modules/colovrat` (`g++ -O3 colovrat.cpp colovrat`).

**Шрифт**: когда-то откуда-то скачал.

**Курсор**: майнкрафт это ммоя жизнь.

**Плеер**: как писалось ранее, система настроена на MPD. Для него нужно положить в `~/.bashrc`:
```bash
export PATH="$PATH:$HOME/.local/bin"
export MPD_HOST="$HOME/.config/mpd/socket"
```
