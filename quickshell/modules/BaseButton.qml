import QtQuick
import QtQuick.Controls

import "."

Button {
    width: 20
    height: 20
    text: "Обновить";
    font.family: Theme.globalFontFamily;
    palette.buttonText: Theme.text
    background: Rectangle {
        color: parent.hovered ? Theme.focusedWS : Theme.bg
    }
}
