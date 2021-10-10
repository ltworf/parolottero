import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    property variant language: null;
    model: items

    ListModel {
        id: items

        Component.onCompleted: {
            var languages = languageManager.languages();
            console.debug(languages)
            for(var i=0; i < languages.size(); languages++) {
                items.append(languages[i])
            }

            console.debug(items)
        }
    }

    header: Label {
        text: "Pick a language"
    }

    delegate: Button {
        width: parent.width * 0.95
        height: 31
        text: 'ciccio'

    }

}


