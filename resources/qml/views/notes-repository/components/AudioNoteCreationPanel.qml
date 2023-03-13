import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Dialogs 1.3

import AudioNotes 1.0

Item {
    id: rootItem
    implicitWidth: 400
    implicitHeight: panelContent.implicitHeight

    property AudioNotesRepo targetRepo
    property bool isAudioRecorded: false

    AudioNoteCreator{
        id: noteCreator
    }
    property alias newNote : noteCreator.audioNote

    ColumnLayout {
        id: panelContent
        anchors.left: parent.left
        anchors.right: parent.right
        RowLayout {
            Layout.fillWidth: true
            Rectangle {
                implicitWidth: 40
                implicitHeight: implicitWidth
                radius: width/2
                color: newNote.color
                MouseArea{
                    anchors.fill: parent
                    onClicked: colorSelectionDialog.open()
                }
            }

            TextField{
                placeholderText: qsTr("Название заметки")
                text: newNote.name
                Layout.fillWidth: true
                onTextEdited: newNote.name = text
            }
        }
        RowLayout {
            Layout.leftMargin: -6
            Switch {
                id: control
                checked: newNote.encrypted
                text: qsTr("Зашифрованная заметка")
                onClicked:  {
                    newNote.encrypted = !newNote.encrypted
                }
            }
        }
        TextField {
            id: passwordField
            Layout.fillWidth: true
            placeholderText: qsTr("Пароль")
            visible: newNote.encrypted
            onTextEdited: newNote.password = text
            echoMode: TextInput.PasswordEchoOnEdit
            Connections {
                target: newNote
                function onPasswordChanged() {
                    if(passwordField.text != newNote.password){
                        passwordField.text = newNote.password
                    }
                }
            }
        }

        ComboBox {
            id: inputDevicesCombo
            Layout.topMargin: 12
            Layout.fillWidth: true
            model: noteCreator.inputDevices
            currentIndex: 0
        }

        RowLayout {
            RoundButton {
                enabled: inputDevicesCombo.count != 0
                text: noteCreator.isRecording ? "⏹"
                                              : "⏺"
                onClicked: {
                    if(noteCreator.isRecording){
                        noteCreator.stopRecording()
                        rootItem.isAudioRecorded = true
                    } else {
                        noteCreator.startRecording(inputDevicesCombo.currentText)
                    }
                }
            }
            Rectangle { // filler
                Layout.fillWidth: true
            }

            ListView {
                id: runningDiagram
                Layout.preferredHeight: 80
                Layout.preferredWidth: 300
                orientation: ListView.Horizontal
                currentIndex: count - 1

                Timer {
                    id: recoringTimer
                    running: noteCreator.isRecording
                    repeat: true
                    onTriggered: {
                        if (diagramModel.count < 50) {
                            diagramModel.append({"value": noteCreator.recordingAmplitude});
                        } else {
                            diagramModel.move(1, 0, 49);
                            diagramModel.set(49, {"value": noteCreator.recordingAmplitude});
                        }
                    }
                    interval: 50
                }


                model: ListModel {
                    id: diagramModel
                }
                delegate: Rectangle {
                    width: 6
                    height: (parent.height - 2) * value + 2
                    color: "blue"
                    anchors.bottom: parent.bottom
                }
            }
            Rectangle { // filler
                Layout.fillWidth: true
            }

            Text {
                id: recordingDuration
                visible: noteCreator.isRecording
                text: "0:00"
            }
        }
    }

    function processBuild() {
        if(!noteCreator.ready){
            return;
        }
        noteCreator.create(targetRepo)
    }

    function cancelRecording() {
        noteCreator.cancelRecording()
    }

    function resetPanel() {
        noteCreator.reset()
    }

    ColorDialog {
        id: colorSelectionDialog
        onAccepted: {
            newNote.color = colorSelectionDialog.color
        }
    }
}
