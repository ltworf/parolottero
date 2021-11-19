import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

ColumnLayout{
    property int language_index: -1
    property alias seed: spinseed.text
    property alias duration: durationspin.value
    spacing: 2

    ListView {
        Layout.alignment: Qt.AlignLeft
        Layout.fillHeight: true
        Layout.fillWidth: true

        model: items

        header: Label {
            font.pointSize: 25
            text: qsTr("Pick a language")
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }

        ListModel {
            id: items
        }

        delegate: Button {
            width: parent.width
            text: name
            onClicked: {
                language_index = index
            }
        }
    }

    GridLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignBottom
        columns: 2

        Label {
            text: qsTr("Seed")
            Layout.alignment: Qt.AlignLeft
        }
        TextField {
            id: spinseed
            placeholderText: qsTr("Seed")
            validator: IntValidator {bottom: 1; top: 100}
            Layout.alignment: Qt.AlignRight
        }

        Label {
            text: qsTr("Duration")
            Layout.alignment: Qt.AlignLeft
        }

        SpinBox {
            id: durationspin
            from: 1
            to: 10
        }

    }

    Component.onCompleted: {
        items.clear()
        var languages = languageManager.languages();
        for(var i=0; i < languages.length; languages++) {
            items.append({name: languages[i], index: i})
        }
    }
}
