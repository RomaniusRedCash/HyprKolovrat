import QtQuick
import Quickshell.Io
import "."

Row {
    spacing: 2.5
    height: parent.height
    BaseText {
        id: cpuIco
        text: ""
        font.pointSize: 18
        height: parent.height
    }

    BaseText {
        property bool isAll: false
        id: cpuUsage
        text: "0%"
        anchors.verticalCenter: parent.verticalCenter
        Process {
            id: cpuUsageProcess
            command: ["sh", "-c", "~/.config/quickshell/modules/cpu_parcer/cpu_parcer"]
            running: true
            stdout: StdioCollector {
                waitForEnd: false
                onTextChanged: {
                    let rawText = this.text.trim();
                    if (!rawText) return;
                    let lastLine = rawText.split("\n")
                    lastLine = lastLine[lastLine.length - 1].split(' ');
                    cpuUsage.text = lastLine[0]+'%'
                    if (cpuUsage.isAll) {
                        let str = ""
                        for (let i = 1; i < lastLine.length; i++) {
                            str += "core " + i + ": " + lastLine[i] + '%';
                            if (i + 1 < lastLine.length) {str+='\n'}
                        }
                        cpuUsageTooltip.text = str
                    }
                }
            }
        }
        MouseArea {
            id: widgetMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onContainsMouseChanged: {
                if (containsMouse) {
                    cpuUsage.isAll = true
                } else {
                    cpuUsage.isAll = false
                }
            }
        }
        Tooltip {
            id: cpuUsageTooltip
            anchorItem: cpuUsage
            text: " "
            visible: widgetMouseArea.containsMouse
        }
    }
    Rectangle{
        width: 2.5
        height: 20
        color: "#00ffffff"
    }
    BaseText {
        id: cpuTemper
        text: "0°C"
        anchors.verticalCenter: parent.verticalCenter
        Process {
            id: cpuTemperProcess
            command: ["cat", "/sys/class/hwmon/hwmon3/temp1_input"]
            running: true
            stdout: StdioCollector {
                onStreamFinished: {
                    let data = this.text.trim()
                    if (!data) return
                        cpuTemper.text = parseInt(data)/1000 + "°C"
                }
            }
        }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            cpuTemperProcess.running = true
        }
    }
    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            cpuUsageProcess.running = false
            cpuUsageProcess.running = true
        }
    }
}
