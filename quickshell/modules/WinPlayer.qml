import QtQuick
import QtQuick.Controls
import Quickshell
import QtQuick.Layouts
import Quickshell.Io

PopupWindow {
    id: playerContainer
    required property Item anchorItem
    required property bool isHovering

    signal hoverStatusChanged(bool isHovered)

    visible: isHovering

    implicitWidth: 300
    implicitHeight: 400
    color: Theme.bg2

    anchor {
        window: anchorItem.QsWindow.window
        adjustment: PopupAdjustment.None
        gravity: Edges.Bottom | Edges.Right

        onAnchoring: {
            const pos = anchorItem.QsWindow.contentItem.mapFromItem(
                anchorItem,
                anchorItem.width / 2 - playerContainer.width/2,
                anchorItem.height + 7
            );
            anchor.rect.x = pos.x;
            anchor.rect.y = pos.y;
        }
    }

    property string searchedSong: "";
    property int nowPlay: 0;
    property int percent: 0;
    property int percentVolume: 0;
    property string totalTime: "";
    property string curTime: "";
    property string defaultPicSource: Quickshell.iconPath("audio-x-generic", 32) || "/usr/share/icons/breeze/mimetypes/32/audio-x-generic.svg"
    property string nowPicSource: Quickshell.iconPath("audio-x-generic", 32) || "/usr/share/icons/breeze/mimetypes/32/audio-x-generic.svg"

    ColumnLayout {
        id: playerColumn
        anchors.fill: parent
        anchors.margins: 2.5
        RowLayout {
            Layout.fillWidth: true
            spacing: 2.5
            BaseButton {
                Layout.preferredWidth: 70
                Layout.preferredHeight: 20
                text: "Обновить";
                onClicked: songProcess.running = true
            }
            TextField {
                id: inputField
                Layout.fillWidth: true
                placeholderText: "Найти трек..."
                font.family: Theme.globalFontFamily
                color: "#ffffff"
                placeholderTextColor: "#aaaaaa"
                background: Rectangle {
                    color: Theme.bg2
                    border.color: inputField.activeFocus ? Theme.text : Theme.textOff
                }
                onTextChanged: {
                    searchedSong = text;
                }
            }
        }
        Rectangle {
            id: oneSongContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            border.color: Theme.bg
            border.width: 2.5
            ListView {
                id: listView
                model: songModel
                boundsBehavior: Flickable.StopAtBounds
                anchors.fill: parent
                anchors.margins: 2.5
                anchors.rightMargin: 3.5
                clip: true
                ScrollBar.vertical: ScrollBar {
                    active: true
                    policy: ScrollBar.AsNeeded
                }
                delegate: Rectangle {
                    id: oneSong
                    visible: searchedSong === "" || model.songTitle.toLowerCase().includes(searchedSong.toLowerCase())
                    width: oneSongContainer.width
                    height: visible ? 32 : 0
                    property bool isHoveredSong: false
                    property color songColor: {
                        if (playerContainer.nowPlay === index + 1) {
                            if (isHoveredSong) return Theme.bg
                            return Theme.focusedWS;
                        }
                        if (isHoveredSong) return Theme.textOff;
                        return "transparent"
                    }
                    color: oneSong.songColor
                    RowLayout {
                        anchors.fill: parent
                        Image {
                            id: pic
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            sourceSize.width: 32
                            sourceSize.height: 32
                            fillMode: Image.PreserveAspectCrop
                            cache: true
                            property string picSource: "img/" + model.songTitle + ".jpg"
                            source: picSource
                            onStatusChanged: {
                                if (status === Image.Error) {
                                    source = playerContainer.defaultPicSource;
                                }
                                if (playerContainer.nowPlay === index + 1) {
                                    playerContainer.nowPicSource = pic.source;
                                }
                            }
                        }
                        Column {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 32
                            Layout.topMargin: 2.5
                            spacing: 2.5
                            BaseText {
                                text: model.songTitle
                                color: Theme.text
                                width: parent.width
                                anchors.leftMargin: 5
                                anchors.rightMargin: 5
                                elide: Text.ElideRight
                            }
                            BaseText {
                                anchors.right: parent.right
                                font.pointSize: 7
                                text: model.duration
                                anchors.rightMargin: 15
                            }
                        }
                    }
                    TapHandler {
                        acceptedButtons: Qt.LeftButton
                        onTapped: {
                            Quickshell.execDetached(["mpc", "play", (index + 1)]);
                            getNowId.running = true;
                            console.log(index);
                        }
                    }
                    HoverHandler {
                        onHoveredChanged: {
                            isHoveredSong = hovered
                        }
                    }
                }
                Connections {
                    target: playerContainer
                    function onNowPlayChanged() {
                        playerContainer.updateViewPosition();
                    }
                }
            }
        }
        RowLayout {
            ColumnLayout {
                id: nowSongCol
                Layout.fillWidth: true
                RowLayout {
                    id: nowSongContainer
                    Layout.preferredHeight: 32
                    Image {
                        id: picNowSong
                        sourceSize.width: 32
                        sourceSize.height: 32
                        fillMode: Image.PreserveAspectCrop
                        cache: true
                        source: playerContainer.nowPicSource
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        color: "transparent"
                        Column {
                            spacing: 2.5
                            width: parent.width
                            height: childrenRect.height
                            anchors.verticalCenter: parent.verticalCenter
                            BaseText {
                                text: (playerContainer.nowPlay > 0 && playerContainer.nowPlay <= songModel.count) ? songModel.get(playerContainer.nowPlay - 1).songTitle : "Ничего не играет"
                                color: Theme.text
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                elide: Text.ElideRight
                            }
                            BaseText {
                                anchors.right: parent.right
                                font.pointSize: 7
                                text: playerContainer.curTime + '/' + playerContainer.totalTime
                            }
                        }
                    }
                }
                RowLayout {
                    BaseButton {
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                        text: "⏮";
                        onClicked: {
                            Quickshell.execDetached(["mpc", "prev"])
                            getNowId.running = true;
                        }
                    }
                    BaseButton {
                        id: toggleButtom
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                        text: "⏵";
                        onClicked: {
                            Quickshell.execDetached(["mpc", "toggle"])
                            start.running = true;
                            getNowId.running = true;
                        }
                        Process {
                            id: start
                            command: ["mpc", "status", "%state%"]
                            running: true
                            stdout: StdioCollector {
                                onStreamFinished: {
                                    let data = this.text.trim()
                                    if (!data) return;
                                    if (data.includes("playing")) toggleButtom.text = "⏸";
                                    else toggleButtom.text = "⏵";
                                }
                            }
                        }
                        Timer {
                            interval: 1000
                            running: playerContainer.visible
                            repeat: true
                            onTriggered: start.running = true;
                        }
                    }
                    BaseButton {
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                        text: "⏭";
                        onClicked: {
                            Quickshell.execDetached(["mpc", "next"])
                            getNowId.running = true;
                        }
                    }
                    Slider {
                        id: posSlider
                        Layout.fillWidth: true
                        value: playerContainer.percent
                        from: 0
                        to: 100
                        background: Rectangle {
                            x: posSlider.leftPadding
                            y: posSlider.topPadding + posSlider.availableHeight / 2 - height / 2
                            implicitWidth: 100
                            implicitHeight: 4
                            width: posSlider.availableWidth
                            height: implicitHeight
                            border.color: Theme.border
                            border.width: 0.5
                            Rectangle {
                                width: posSlider.visualPosition * parent.width
                                height: parent.height
                                color: posSlider.pressed ? Theme.bg : Theme.bg2
                                border.color: Theme.border
                                border.width: 0.5
                            }
                        }
                        handle: Rectangle {
                            x: posSlider.leftPadding + posSlider.visualPosition * (posSlider.availableWidth - width)
                            y: posSlider.topPadding + posSlider.availableHeight / 2 - height / 2
                            implicitWidth: 5
                            implicitHeight: 14
                            color: posSlider.pressed ? Theme.bg : Theme.bg2
                            border.color: Theme.border
                            border.width: 0.5
                        }
                        onMoved: {
                            let seekValue = value.toFixed(0) + "%";
                            Quickshell.execDetached(["mpc", "seek", seekValue]);
                        }
                    }
                }
            }
            Slider {
                id: volumeSlider
                orientation: Qt.Vertical
                Layout.preferredWidth: 20
                Layout.preferredHeight: nowSongCol.height
                value: playerContainer.percentVolume
                from: 0
                to: 100
                background: Rectangle {
                    x: volumeSlider.leftPadding + volumeSlider.availableWidth / 2 - width / 2
                    y: volumeSlider.topPadding
                    implicitWidth: 4
                    implicitHeight: 100
                    width: implicitWidth
                    height: volumeSlider.availableHeight
                    border.color: Theme.border
                    border.width: 0.5
                    Rectangle {
                        width: parent.width
                        height: (1 - volumeSlider.visualPosition) * parent.height
                        anchors.bottom: parent.bottom
                        color: volumeSlider.pressed ? Theme.bg : Theme.bg2
                        border.color: Theme.border
                        border.width: 0.5
                    }
                }
                handle: Rectangle {
                    x: volumeSlider.leftPadding + volumeSlider.availableWidth / 2 - width / 2
                    y: volumeSlider.topPadding + volumeSlider.visualPosition * (volumeSlider.availableHeight - height)
                    implicitWidth: 14
                    implicitHeight: 5
                    color: volumeSlider.pressed ? Theme.bg : Theme.bg2
                    border.color: Theme.border
                    border.width: 0.5
                }
                onMoved: {
                    Quickshell.execDetached(["mpc", "volume", value.toFixed(0)]);
                }
            }
        }
    }
    ListModel {
        id: songModel
    }
    Process {
        id: songProcess
        command: ["mpc", "playlist", "-f", "%time%---%file%"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let data = this.text.trim();
                if (!data) return;
                let lines = data.split('\n');
                songModel.clear();
                for (let line of lines) {
                    if (line !== "") {
                        let subLines = line.split("---")
                        songModel.append({ "songTitle": subLines[1], "duration": subLines[0]});
                    }
                }
                Quickshell.execDetached([
                    "bash", "-c",
                    "printf '%s\\0' \"$@\" | xargs -0 -I {} -P 4 bash -c ' " +
                    "  FULL_NAME=\"{}\"; " +
                    "  FILE=$(echo \"$FULL_NAME\" | sed -E \"s/^[0-9]+:[0-9]+---//\"); " +
                    "  FILE_PATH=\"$HOME/.config/quickshell/modules/img/$FILE.jpg\"; " +
                    "  if [ ! -e \"$FILE_PATH\" ]; then " +
                    "    mpc -q readpicture \"$FILE\" > \"$FILE_PATH\" 2>/dev/null; " +
                    "    if [ ! -s \"$FILE_PATH\" ]; then " +
                    "      rm -f \"$FILE_PATH\"; " +
                    "    fi; " +
                    "  fi; " +
                    "'",
                    "bash"
                ].concat(lines));
            }
        }
    }
    Process {
        id: getNowId
        command: ["mpc", "current", "-f", "%position%"]
        stdout: StdioCollector {
            onStreamFinished: {
                let data = this.text.trim()
                if (!data) return;
                playerContainer.nowPlay = parseInt(data);
            }
        }
    }
    Process {
        id: getLen
        command: ["mpc", "status", "%totaltime%,%currenttime%,%percenttime%,%volume%"]
        stdout: StdioCollector {
            onStreamFinished: {
                let data = this.text.trim()
                if (!data) return;
                data = data.split(',');
                playerContainer.totalTime = data[0];
                playerContainer.curTime = data[1];
                playerContainer.percent = parseInt(data[2].replace('%', ''));
                playerContainer.percentVolume = parseInt(data[3].replace('%', ''));
            }
        }
    }
    Timer {
        interval: 500
        repeat: true
        running: playerContainer.visible
        onTriggered: {
            getNowId.running = true
            getLen.running = true;
        }
    }
    function updateViewPosition() {
        if (playerContainer.nowPlay > 0 && listView.count > 0) {
            let targetIndex = playerContainer.nowPlay - 1;
            listView.positionViewAtIndex(targetIndex, ListView.Center);
        }
    }
    HoverHandler {
        id: windowHoverHandler
        onHoveredChanged: {
            playerContainer.hoverStatusChanged(windowHoverHandler.hovered);
        }
    }
    onVisibleChanged: {
        playerContainer.updateViewPosition()
    }
}
