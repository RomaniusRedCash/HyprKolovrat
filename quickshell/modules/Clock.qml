import QtQuick
import QtQuick.Controls

import "."

BaseText {
    id: clock
    property bool showFullDate: false
    property bool isHovering: false
    anchors.verticalCenter: parent.verticalCenter

    function getFormattedTime() {
        const now = new Date();
        if (!showFullDate) {
            return now.toLocaleTimeString(Qt.locale(), "hh:mm:ss");
        } else {
            const w = now.toLocaleString(Qt.locale(), "ddd");
            const d = now.toLocaleDateString(Qt.locale(), Locale.ShortFormat);
            const t = now.toLocaleTimeString(Qt.locale(), "hh:mm");
            return `${w}, ${d} ${t}`;
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = clock.getFormattedTime()
    }
    Component.onCompleted: clock.text = getFormattedTime()
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: (mouse) => {
            clock.showFullDate = !clock.showFullDate;
            clock.text = clock.getFormattedTime()
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
    WinCalendar {
        anchorItem: clock
        isHovering: clock.isHovering
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
