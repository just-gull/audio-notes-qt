import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import AudioNotes 1.0

ItemDelegate {
    id: listItem
    property AudioNote audioNote
    anchors.left: parent.left
    anchors.right: parent.right
    height: listItemContent.height + 12

    signal audioNoteRemoved(AudioNote audioNote)

    Rectangle {
        id: topSpacer
        anchors.left: parent.left
        anchors.top: parent.top
        implicitHeight: 8
        Layout.fillWidth: true
    }
    ColumnLayout {
        id: listItemContent
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: topSpacer.top
        anchors.margins: 12
        RowLayout {
            Rectangle {
                width: 40
                height: 40
                radius: width/2
                color: listItem.audioNote ? listItem.audioNote.color : "#000000"

                Label {
                    anchors.centerIn: parent
                    text: "🔒"
                    color: "white"
                    visible: listItem.audioNote ? listItem.audioNote.encrypted : null
                    font.pointSize: 14
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    text: "Комментарий: " + (listItem.audioNote ? listItem.audioNote.name : "")
                }
                Label {
                    text: "Длительность: " + durationString()
                }
            }


        }
        RowLayout {
            RoundButton {
                text: listItem.audioNote ? (listItem.audioNote.playback.active ? "⏸" : "▶️") : null
                onClicked:{
                    if(listItem.audioNote.playback.active){
                        listItem.audioNote.playback.stop()
                    } else {
                        if(listItem.audioNote.encrypted) {
                            passwordField.visible = true
                            passwordTextField.focus = true
                        } else {
                            listItem.audioNote.playback.play()
                        }
                    }
                }
            }

            AudioTrackView {
                Layout.fillWidth: true
                audioSamples: listItem.audioNote ? listItem.audioNote.samples : null
                playbackPosition: listItem.audioNote ? listItem.audioNote.playback.postition : 0
                Layout.preferredHeight: listItem.audioNote ? (listItem.audioNote.playback.active ? 60
                                                           : 40) : 0

            }
            RoundButton {
                text: "Х"
                onClicked:{
//                    audioNoteRemoveClick = listItem.audioNote
                    removeAudioNote.open()
                }
            }
        }
        RowLayout {
            id: passwordField
            visible: false

            TextField{
                id: passwordTextField
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                onAccepted: checkPassword()
            }
            RoundButton {
                text: "✓"
                onClicked: checkPassword()
            }

        }
        Rectangle {
            implicitHeight: 1
            Layout.fillWidth: true
            color: "lightgray"
            Layout.bottomMargin: 3
        }
    }

    function checkPassword() {
        if(listItem.audioNote.checkPassword(passwordTextField.text)) {
            passwordField.visible = false
            listItem.audioNote.playback.play()
        } else {
            passwordErrorDialog.open()
        }
        passwordTextField.text = ""
    }

    function durationString() {
        if (listItem.audioNote) {
            if (listItem.audioNote.playback.active) {
                return timeString(listItem.audioNote.playback.postition) + " / " + timeString(listItem.audioNote.playback.duration)
            } else {
                return timeString(listItem.audioNote.playback.duration)
            }
        } else {
            return "00:00"
        }
    }

    function timeString(milliseconds) {
        var seconds = Math.round(milliseconds / 1000);
        var hours   = Math.round(seconds / 3600);
        var minutes = Math.round((seconds - (hours * 3600)) / 60);
        seconds = seconds - (hours * 3600) - (minutes * 60);

        if (hours   < 10) { hours = "0" + hours; }
        if (minutes < 10) { minutes = "0" + minutes; }
        if (seconds < 10) { seconds = "0" + seconds; }
        if (milliseconds > 3600000) {
            return hours + ':' + minutes + ':' + seconds;
        } else {
            return minutes + ':' + seconds;
        }
    }

    Dialog {
        id: passwordErrorDialog
        parent: Overlay.overlay
        anchors.centerIn: parent
        title: qsTr("Ошибка")
        standardButtons: Dialog.Ok

        Label {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            color: "red"
            text: qsTr("Неверный пароль")
        }
    }

    Dialog{
        id : removeAudioNote
        parent: Overlay.overlay
        anchors.centerIn: parent
        title: qsTr("Удалить файл")
        standardButtons: Dialog.Ok | Dialog.Cancel

        Label {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Вы действительно хотите удалить аудиозаметку?")
        }

        onAccepted: {
//            audioNoteRemoveClick.remove()
            listItem.audioNoteRemoved(listItem.audioNote)
        }
    }
}
