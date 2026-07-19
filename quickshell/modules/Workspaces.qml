import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Row {
    id: workspacesRoot
    height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    Repeater {
        model: 10

        delegate: Rectangle {
            id: ws
            readonly property int workspaceId: modelData + rootWindow.startWS
            width: wsText.width + 10
            height: parent.height

            readonly property bool isFocused: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === workspaceId
            readonly property bool isActive: checkActiveProc.activeWorkspaces[workspaceId] ?? false
            property bool hovered: false

            color: hovered ? Theme.bg2 : (isFocused ? Theme.focusedWS : Theme.bg)

            BaseText {
                id: wsText
                text: workspaceId
                color: isFocused && isActive ? Theme.text : (isActive ? Theme.text : Theme.textOff)
                anchors.centerIn: parent
            }
            Rectangle {
                width: parent.width
                height: 2.25
                anchors.bottom: parent.bottom
                visible: isFocused
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onContainsMouseChanged: {
                    if (containsMouse) {
                        ws.hovered = true;
                    } else {
                        ws.hovered = false;
                    }
                }
                onClicked: {
                    // Hyprland.dispatch("workspace " + parent.workspaceId);
                    Hyprland.dispatch("hl.dsp.focus({ workspace = " + parent.workspaceId + " })");
                }
            }
        }
    }

    Process {
        id: checkActiveProc
        command: ["hyprctl", "workspaces", "-j"]
        running: true
        property var activeWorkspaces: ({})
        stdout: StdioCollector {
            onStreamFinished: {
                let data = JSON.parse(this.text);
                let newMap = {};
                for (let ws of data) {
                    newMap[ws.id] = (ws.windows > 0);
                }
                checkActiveProc.activeWorkspaces = newMap;
            }
        }
    }
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "openwindow" || event.name === "closewindow" || event.name === "movewindow") {
                checkActiveProc.running = true;
            }
        }
    }
}
