hl.on("hyprland.start", function ()
  hl.exec_cmd(apps.lock .. " & hyprpolkitagent & dunst & hyprpaper & pipewire & " .. apps.bar)
  hl.exec_cmd("sleep 5 && sunshine & " .. apps.telegram .. " -startintray & if [ -z \"$(pgrep -x mpd)\" ]; then mpd; fi && mpdris2-rs -n")
end)
