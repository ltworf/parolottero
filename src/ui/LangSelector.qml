/*
parolottero
Copyright (C) 2021-2022 Salvo "LtWorf" Tomaselli

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

author Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import ltworf.parolottero 1.0

Item {
    property int language_index: -1
    property alias seed: spinseed.value
    property alias use_seed: switchseed.checked
    property alias duration: durationspin.value

    ColumnLayout{
        anchors.fill: parent
        spacing: 2

        ListView {
            Layout.alignment: Qt.AlignLeft
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            clip: true

            model: items

            ScrollBar.vertical: ScrollBar { }

            header: Label {
                font.pointSize: 25
                text: qsTr("Pick a language")
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            // Load list of languages
            function refreshList() {
                items.clear()
                var languages = languageManager.languages();
                for(var i = 0; i < languages.length; i++) {
                    items.append({name: languages[i], index: i, local: true, url: ""})
                }
            }

            Component.onCompleted: refreshList()

            // Implement refresh when scrolling down
            property variant yposflick
            onFlickStarted: {
                yposflick = atYBeginning
            }

            onFlickEnded: {
                if ( atYBeginning === yposflick ) {
                    yposflick = null
                    languageManager.rescan()
                    refreshList()
                }
            }

            // Button to download language list
            footer: Button {
                width: parent.width
                text: qsTr("Download more languages")
                id: downloadlanguagelist
                onClicked: {
                    downloadlanguagelist.enabled = false
                    downloadlanguagelist.text = qsTr("Downloading…")
                    var http = new XMLHttpRequest()
                    http.responseType = "json"
                    var url = "https://api.github.com/repos/ltworf/parolottero-languages/releases/latest"

                    http.open("GET", url);
                    http.onreadystatechange = function() {
                        if (http.readyState !== XMLHttpRequest.DONE) return;
                        // Error
                        if (http.status !== 200) {
                            downloadlanguagelist.text = qsTr("Download error")
                            return;
                        }

                        downloadlanguagelist.visible = false
                        text = qsTr("Download more languages")

                        var assets = http.response['assets']

                        for (var i = 0; i < assets.length; i++) {
                            var name = assets[i]["name"]
                            if (name.includes("wordlist"))
                                continue;
                            var download_url = assets[i]["browser_download_url"]
                            var item = {name: name, url: download_url, local: false, index: -1}
                            items.append(item)
                        }
                    }
                    http.send()
                }
            }

            ListModel {
                id: items
            }

            // Start a match or download a language
            delegate: Button {
                width: parent.width
                text: local ? name : qsTr("Download: ") + name
                enabled: downloader.state === LanguageDownloader.Idle

                LanguageDownloader {
                    id: downloader
                    onStateChanged: {
                        if (downloader.getState() === LanguageDownloader.Error)
                            text = qsTr("Error downloading: ") + name
                        else if (downloader.getState() === LanguageDownloader.Done)
                            text = qsTr("Downloaded: ") + name
                        else
                            text = qsTr("Downloading: ") + name
                    }
                }
                onClicked: {
                    if (local)
                        language_index = index
                    else {
                        downloader.download(url)
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
            columns: 2

            Switch {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.rightMargin: 5
                LayoutMirroring.enabled: true
                text: qsTr("User defined seed")
                id: switchseed
            }

            Label {
                text: qsTr("Seed")
                Layout.fillWidth: true
                Layout.leftMargin: 5
            }

            SpinBox {
                id: spinseed
                from: 1
                to: 10000
                editable: true
                enabled: switchseed.checked
                Layout.rightMargin: 5
            }

            Label {
                text: qsTr("Duration")
                Layout.fillWidth: true
                Layout.leftMargin: 5
            }

            SpinBox {
                id: durationspin
                from: 1
                to: 10
                editable: true
                Layout.rightMargin: 5
            }

            Button {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                text: qsTr("About")
                onClicked: aboutoverlay.visible = true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.bottomMargin: 5
            }

        }
    }

    About {
        visible: false
        id: aboutoverlay
        anchors.fill: parent
    }
}
