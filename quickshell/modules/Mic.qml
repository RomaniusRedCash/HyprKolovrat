import Quickshell
import Quickshell.Io
import QtQuick

import "."

Row {
    id: micWidget
    property bool isHovering: false
    spacing: 2.5
    height: parent.height
    BaseText {
        id: micIcon
        font.pointSize: 18
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        // anchors.verticalCenterOffset: -0.8
        MouseArea {
            width: mic.width + micIcon.width
            height: micIcon.height
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onWheel: (wheel) => {
                if (wheel.angleDelta.y > 0) {
                    changeMicVolumeProcess.command = ["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SOURCE@", "1%+"];
                } else {
                    changeMicVolumeProcess.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", "1%-"];
                }
                changeMicVolumeProcess.running = true;
            }
            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    changeMicVolumeProcess.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"];
                    changeMicVolumeProcess.running = true;
                } else Quickshell.execDetached(["pavucontrol"])
            }
            hoverEnabled: true
            onContainsMouseChanged: {
                if (containsMouse) {
                    isHovering = true;
                    hideTimer.stop();
                } else {
                    hideTimer.restart();
                }
            }
        }
    }
    BaseText {
        id: mic
        height: parent.height
        Process {
            id: micProcess
            command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SOURCE@"]
            running: true
            stdout: StdioCollector {
                onStreamFinished: {
                    let data = this.text.trim();
                    if (!data) return;
                    if (data.includes("[MUTED]")) {
                        mic.text = "";
                        micIcon.text = ""
                        micIcon.color = Theme.textOff
                        return;
                    }
                    let volume = Math.round(parseFloat(data.split(":")[1]) * 100)
                    mic.text = volume + '%'//.match(/Volume: \s*([0-9.]+)/)
                    micIcon.text = ""
                    micIcon.color = Theme.text
                }
            }
        }
        Process {
            id: changeMicVolumeProcess
            command: []
            onExited: function(exitCode, exitStatus) {
                micProcess.running = true;
            }
        }
        Timer {
            interval: 2000
            running: true
            repeat: true
            onTriggered: micProcess.running = true
        }
    }
    VolumeSlider{
        anchorItem: micWidget
        isHovering: micWidget.isHovering
        value: parseInt(mic.text.replace('%', ''))
        onSliderMoved: (val) => {
            changeMicVolumeProcess.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", val + "%"]
            changeMicVolumeProcess.running = true
            hideTimer.restart()
        }
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
}


