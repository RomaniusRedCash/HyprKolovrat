import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

BaseText {
    id: layoutText
    anchors.verticalCenter: parent.verticalCenter
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout") {
                // let parts = event.data.split(",");
                // if (parts.length > 1) {
                    // let lang = parts[1].trim();
                layoutText.text = formatLanguage(event.data);
                // }
            }
        }
    }
    function formatLanguage(langName) {
        let lower = langName//.toLowerCase();
        if (lower.includes("Russian")) return "RU";
        if (lower.includes("English")) return "EN";

        return langName//.substring(0, 2).toUpperCase();
    }
    Component.onCompleted: {
        initProc.running = true;
    }
    Process {
        id: initProc
        command: ["sh", "-c", "hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap'"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim()) {
                    layoutText.text = layoutText.formatLanguage(this.text.trim());
                }
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: Quickshell.execDetached(["hyprctl", "switchxkblayout", "at-translated-set-2-keyboard", "next"])
    }
}
