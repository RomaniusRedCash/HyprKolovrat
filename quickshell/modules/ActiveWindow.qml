import QtQuick
import Quickshell.Hyprland

BaseText {
    id: activeWindowTitle
    height: parent.height
    anchors.centerIn: parent

    text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "Desktop"

    width: Math.min(implicitWidth, parent.width * 0.2)
    elide: Text.ElideRight

    color: Theme.text
}
