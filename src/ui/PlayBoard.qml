import QtQuick 2.0
import QtQuick.Layouts 1.15

import ltworf.parolottero 1.0

ColumnLayout {

    property int language_id

    BoardManager {
        seed: 0
        language: language_id
    }
}
