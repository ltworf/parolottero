import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    property variant language: null;
    model: items

    ListModel {
        id: items
    }

    header: Label {
        text: qsTr("Pick a language")
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
    }

    delegate: Button {
        width: parent.width
        text: model.name
        onClicked: {
            language = model.name
        }
    }

    Component.onCompleted: {
        items.clear()
        var languages = languageManager.languages();
        for(var i=0; i < languages.length; languages++) {
            items.append({name: languages[i]})
        }
    }

}
