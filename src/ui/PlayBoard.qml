import QtQuick 2.0
import QtQuick.Layouts 1.15

ColumnLayout {

    property int language_id

    property variant board: boardGenerator.board(language_id, 0)

}
