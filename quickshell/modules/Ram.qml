import QtQuick
import Quickshell.Io
import "."

Row {
    id: ramWidget
    property bool isGb: false
    spacing: 2.5
    anchors.verticalCenter: parent.verticalCenter
    BaseText {
        id: ramIco
        text: "מ"
        height: parent.height
        font.pointSize: 18
        MouseArea {
            width: parent.width + ramData.width
            height: parent.height
            acceptedButtons: Qt.LeftButton
            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    ramWidget.isGb = !ramWidget.isGb
                }
                getRamProcess.running = true
            }
        }
    }
    BaseText {
        id: ramData
        text: "0%"
        anchors.verticalCenter: parent.verticalCenter
        function getRam(data) {
            if (ramWidget.isGb) {
                if (!data) return;
                data = data.split('\n')[1].split(/\s+/)
                ramData.text = data[2].replace("Gi", '')+'/'+data[1]
            } else {
                data = data.split('\n')[1].split(/\s+/)
                ramData.text = Math.round(parseFloat(data[2].replace(',','.').replace("Gi", '')) / parseFloat(data[1].replace(',','.').replace("Gi", '')) * 100) + '%'
            }
        }
        Process {
            id: getRamProcess
            command: ["free", "-h"]
            stdout: StdioCollector {
                onStreamFinished: {
                    ramData.getRam(this.text.trim())
                }
            }
        }
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: getRamProcess.running = true
        }
    }
}
