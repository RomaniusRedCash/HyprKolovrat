import Quickshell // for PanelWindow
import QtQuick // for Text
import Quickshell.Io // for Process
import QtQuick.Layouts

import "./modules"


PanelWindow {
    focusable: true
    id: rootWindow
    property int startWS: 1
    screen: Quickshell.screens.length > 1 ? Quickshell.screens[0] : Quickshell.screens[0]
    color: Theme.bg
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 20
    implicitWidth: Screen.width

    Row {
        // spacing: 2.5
        anchors {
            fill: parent
            // leftMargin: 2.5
        }
        height: parent.height
        Colovrat{}
        Workspaces{}
    }

    ActiveWindow{}

    Row {
        id: rightRow
        layoutDirection: Qt.RightToLeft
        height: parent.height
        spacing: 5
        anchors {
            fill: parent
            rightMargin: 2.5
        }

        Clock {}
        Separator{}
        KeyboardLayout{}
        Separator{}
        Sound{}
        Separator{}
        Player{}
        Separator{}
        Mic{}
        Separator{}
        Gpu{}
        Separator{}
        Ram{}
        Separator{}
        Cpu{}
        Separator{}
        Tray{}
        // Separator{}

        Item {Layout.fillWidth: true}
    }
}
