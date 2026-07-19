import Quickshell.Io
import QtQuick
import QtQuick.Controls
import Quickshell

import "."

Row {
    id: soundWidget
    property bool isHovering: false
    spacing: 2.5
    anchors.verticalCenter: parent.verticalCenter
    BaseText {
        id: soundIcon
        text: ""
        // clip: true
        height: sound.height
        font.pointSize: 18
        // height: 18
        anchors.verticalCenter: parent.verticalCenter
        // anchors.verticalCenterOffset: -0.8
        MouseArea {
            id: widgetMouseArea
            width: sound.width + soundIcon.width
            height: sound.height
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onWheel: (wheel) => {
                if (wheel.angleDelta.y > 0) {
                    changeVolumeProcess.command = ["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "1%+"];
                } else {
                    changeVolumeProcess.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "1%-"];
                }
                changeVolumeProcess.running = true;
            }
            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    changeVolumeProcess.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"];
                    changeVolumeProcess.running = true;
                } else Quickshell.execDetached(["qpwgraph"])
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
        id: sound
        anchors.verticalCenter: parent.verticalCenter
        Process {
            id: soundProcess
            command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
            running: true
            stdout: StdioCollector {
                onStreamFinished: {
                    let data = this.text.trim();
                    if (!data) return;
                    if (data.includes("[MUTED]")) {
                        sound.text = "";
                        soundIcon.text = ""
                        return;
                    }
                    let volume = Math.round(parseFloat(data.split(":")[1]) * 100)
                    sound.text = volume + '%'//.match(/Volume: \s*([0-9.]+)/)
                    if (volume == 0) {
                        soundIcon.text = ""
                        soundIcon.color = Theme.textOff
                    } else {
                        soundIcon.text = ""
                        soundIcon.color = Theme.text
                    }
                }
            }
        }
        Process {
            id: changeVolumeProcess
            command: []
            onExited: function(exitCode, exitStatus) {
                soundProcess.running = true;
            }
        }
        Timer {
            interval: 2000
            running: true
            repeat: true
            onTriggered: soundProcess.running = true
        }
    }
    VolumeSlider {
        anchorItem: soundWidget
        isHovering: soundWidget.isHovering
        value: parseInt(sound.text.replace('%', ''))
        onSliderMoved: (val) => {
            changeVolumeProcess.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", val + "%"]
            changeVolumeProcess.running = true
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
