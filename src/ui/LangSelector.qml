import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    property int language_index: -1;
    model: items

    ListModel {
        id: items
    }

    header: Label {
        font.pointSize: 25
        text: qsTr("Pick a language")
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
    }

    delegate: Button {
        width: parent.width
        text: model.name
        onClicked: {
            language_index = model.index
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
