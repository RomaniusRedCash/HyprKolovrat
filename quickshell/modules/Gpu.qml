import QtQuick
import Quickshell.Io
import "."

Row {
    id: gpuContent
    spacing: 2.5
    height: parent.height
    BaseText {
        id: gpuIco
        text: ""
        font.pointSize: 18
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle {
        width: 2.5
        height: parent.height
        color: "#00000000"
    }
    Row {
        id: nvidiaContent
        height: parent.height
        spacing: 2.5
        BaseText {
            id: nvidiaName
            font.pointSize: 7
            text: "nv"
            anchors.bottom: nvidiaData.bottom
        }
        BaseText {
            id: nvidiaData
            text: ""
            anchors.verticalCenter: parent.verticalCenter
            Process {
                id: nvidiaProcess
                command: ["nvidia-smi","--query-gpu=temperature.gpu,utilization.gpu", "--format=csv,noheader,nounits"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: {
                        let data = this.text.trim();
                        if (!data) {return;};
                        data = data.split(", ");
                        nvidiaData.text = data[0] + "°C " + data[1] + '%';
                    }
                }
            }
        }
    }
    BaseText {
        id: gpuSepor
        height: parent.height
        text: "|"
    }
    Row {
        id: amdContent
        height: parent.height
        spacing: 2.5
        BaseText {
            id: amdName
            font.pointSize: 7
            text: "amd"
            anchors.bottom: amdData.bottom
        }
        BaseText {
            id: amdData
            text: ""
            anchors.verticalCenter: parent.verticalCenter
            Process {
                id: amdProcess
                command: ["cat", "/sys/class/hwmon/hwmon1/temp1_input"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: {
                        let data = this.text.trim();
                        if (!data) {return;}
                        data = data.split(", ");
                        amdData.text = Math.round(parseInt(data[0]) / 1000) + "°C";
                    }
                }
            }
        }
    }
    Timer {
        id: gpuTimer
        running: true
        interval: 1000
        repeat: true
        onTriggered: {
            nvidiaProcess.running = true
            amdProcess.running = true
        }
    }
}
