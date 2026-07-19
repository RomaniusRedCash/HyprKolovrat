import QtQuick
import QtQuick.Controls
import Quickshell

PopupWindow {
    id: volumeSliderContainer
    required property Item anchorItem
    required property bool isHovering

    property int value: 0
    property int from: 0
    property int to: 100
    property int rotation: -90

    signal sliderMoved(int newValue)
    signal hoverStatusChanged(bool isHovered)

    visible: isHovering
    implicitWidth: volumeSlider.implicitHeight
    implicitHeight: volumeSlider.implicitWidth
    color: "transparent"

    anchor {
        window: anchorItem.QsWindow.window
        adjustment: PopupAdjustment.None
        gravity: Edges.Bottom | Edges.Right

        onAnchoring: {
            const pos = anchorItem.QsWindow.contentItem.mapFromItem(
                anchorItem,
                anchorItem.width / 2 - volumeSliderContainer.width / 2,
                anchorItem.height + 7
            );
            anchor.rect.x = pos.x;
            anchor.rect.y = pos.y;
        }
    }
    Slider {
        id: volumeSlider
        anchors.centerIn: parent
        value: volumeSliderContainer.value
        from: volumeSliderContainer.from
        to: volumeSliderContainer.to
        rotation: volumeSliderContainer.rotation
        background: Rectangle {
            x: volumeSlider.leftPadding
            y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
            implicitWidth: 100
            implicitHeight: 4
            width: volumeSlider.availableWidth
            height: implicitHeight
            border.color: Theme.border
            border.width: 0.5
            Rectangle {
                width: volumeSlider.visualPosition * parent.width
                height: parent.height
                color: volumeSlider.pressed ? Theme.bg : Theme.bg2
                border.color: Theme.border
                border.width: 0.5
            }
        }
        handle: Rectangle {
            x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
            y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
            implicitWidth: 5
            implicitHeight: 14
            color: volumeSlider.pressed ? Theme.bg : Theme.bg2
            border.color: Theme.border
            border.width: 0.5
        }
        onMoved: {
            volumeSliderContainer.sliderMoved(value)
            volumeSliderContainer.hoverStatusChanged(hovered)
        }
        onHoveredChanged: volumeSliderContainer.hoverStatusChanged(hovered)
    }
}
