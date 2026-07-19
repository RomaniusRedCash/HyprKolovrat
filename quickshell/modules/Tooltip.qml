import QtQuick
import Quickshell
import Quickshell.Widgets

PopupWindow {
    id: popup
    required property Item anchorItem
    property string text: ""
    property string actionText
    property bool show: false
    property int merge: 7

    anchor {
        window: anchorItem.QsWindow.window
        adjustment: PopupAdjustment.None
        gravity: Edges.Bottom | Edges.Right

        onAnchoring: {
            const pos = anchorItem.QsWindow.contentItem.mapFromItem(
                anchorItem,
                anchorItem.width / 2 - popup.width / 2,
                anchorItem.height + merge
            );
            anchor.rect.x = pos.x;
            anchor.rect.y = pos.y;
        }
    }

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    WrapperRectangle {
        id: content
        color: Theme.bg2
        border.color: Theme.border
        margin: 5

        BaseText {
            text: popup.text
            color: Theme.toolTipText
        }
    }
}
