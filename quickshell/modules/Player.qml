import Quickshell
import Quickshell.Io
import QtQuick

Row {
    id: palyerContent
    spacing: 10
    height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    BaseText {
        text: "⏮"
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: (mouse) => {
                    previosPlayProcess.running = true;
            }
        }
        Process {
            running: false
            id: previosPlayProcess
            command: ["playerctl", "previous"]
            onExited: {
                playStatusProcess.running = true
            }
        }
    }
    BaseText {
        id: playPause
        text: "⏵"
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => {
                if (mouse.button == Qt.LeftButton) {
                    playPauseProcess.running = true;
                } else {
                    // Quickshell.execDetached(["strawberry"])
                }
            }
        }
        Process {
            id: playPauseProcess
            running: false
            command: ["playerctl", "play-pause"];
            onExited: {
                playStatusProcess.running = true
            }
        }
    }
    BaseText {
        text:"⏭"
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: (mouse) => {
                nextPlayProcess.running = true;
            }
        }
        Process {
            running: false
            id: nextPlayProcess
            command: ["playerctl", "next"];
            onExited: {
                playStatusProcess.running = true
            }
        }
    }
    Process {
        id: playStatusProcess
        running: true
        command: ["playerctl", "status"]
        stdout: StdioCollector {
            onStreamFinished: {
                let data = this.text.trim();
                if (!data) return;
                if (data.includes("Playing")) {
                    playPause.text = "⏸"
                    return;
                } else {
                    playPause.text = "⏵"
                }
            }
        }
    }
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: playStatusProcess.running = true
    }
    property bool isHovering: false
    WinPlayer {
        anchorItem: palyerContent
        isHovering: palyerContent.isHovering
        onHoverStatusChanged: (isHovered) => {
            if (isHovered) hideTimer.stop()
                else hideTimer.restart()
        }
    }
    Timer {
        id: hideTimer
        interval: Theme.showDuration
        onTriggered: isHovering = false
    }
    HoverHandler {
        onHoveredChanged: {
            if (hovered) {
                palyerContent.isHovering = true;
                hideTimer.stop();
            } else {
                hideTimer.restart();
            }
        }
    }
}
