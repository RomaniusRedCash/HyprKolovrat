import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    id: trayContent
    spacing: 4
    height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    Repeater {
        model: SystemTray.items
        delegate: Rectangle {
            id: trayItem
            Layout.preferredWidth: trayIcon.width
            Layout.preferredHeight: trayIcon.height
            // height: trayIcon.height
            color: "transparent"
            // color: "#ffffff"
            // anchors.verticalCenter: parent.verticalCenter
            Image {
                id: trayIcon
                anchors.centerIn: parent
                sourceSize.width: trayContent.height / 1.5
                sourceSize.height: trayContent.height / 1.5
                source: {
                    const icon = modelData.icon ?? ""
                    if (typeof icon === "string" && icon.includes("?path=")) {
                        const parts = icon.split("?path=")
                        const name = parts[0]
                        const base = parts[1] ?? ""
                        const fileName = name.slice(name.lastIndexOf("/") + 1)
                        return Qt.resolvedUrl(`${base}/${fileName}`)
                    }
                    return icon
                }
                visible: status === Image.Ready
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => {
                    const globalPos = mapToItem(null, mouse.x, mouse.y)
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate(0, 0)
                    } else if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                        modelData.display(rootWindow, globalPos.x, globalPos.y)
                    }
                }
            }
        }
    }
}
