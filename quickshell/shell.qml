//@ pragma UseQApplication
import Quickshell
import QtQuick

QtObject {
    property Instantiator _generator: Instantiator {
        model: Quickshell.screens
        delegate: Bar {
            required property var modelData
            screen: modelData
            startWS: {
                if (modelData.name == "DVI-I-1") return 1
                    if (modelData.name == "DP-1") return 21
                        return 11
            }
        }
        function getObjects() {
            let list = [];
            for (let i = 0; i < count; i++) {
                list.push(objectAt(i));
            }
            return list;
        }
    }
    property list<QtObject> panels: _generator.getObjects()
}
