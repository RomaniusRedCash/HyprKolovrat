import QtQuick
import Quickshell.Io
import "."

BaseText {
    id: colovrat
    text: "1488"
    font.pointSize: 18
    anchors.verticalCenter: parent.verticalCenter
    width: 20
    horizontalAlignment: Text.AlignHCenter
    Process {
        id: colovratProcess
        command: ["sh", "-c", "~/.config/quickshell/modules/colovrat/colovrat 75"]
        running: true
        stdout: StdioCollector {
            waitForEnd: false
            onTextChanged: {
                let lines = this.text.split('\r');
                if (lines.length > 0) {
                    lines = lines[lines.length - 1].trim();
                    colovrat.text = lines;
                }
            }
        }
    }
    Timer {
        interval: 60000 // Раз в минуту
        running: true
        repeat: true
        onTriggered: {
            colovratProcess.running = false
            colovratProcess.running = true
        }
    }
}
