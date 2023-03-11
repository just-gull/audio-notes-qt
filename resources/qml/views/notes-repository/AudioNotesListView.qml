import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import QtQuick.Dialogs 1.3

import AudioNotes 1.0

import "./components"

ListView {
    property AudioNotesRepo repo
    property AudioNote audioNoteRemoveClick
    model: repo ? repo.notesModel : null

    header: Label {
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: qsTr("Заметки")
        font.bold: true
        font.pointSize: 16
        topPadding: 8
        bottomPadding: 8
    }

    delegate: AudioNoteListItemView {
        id: listItem
        audioNote: modelData
    }

    remove: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; to: 0; duration: 500 }
            NumberAnimation { properties: "y"; to: 200; duration: 500 }
        }
    }

    add: Transition {
        NumberAnimation { properties: "x,y"; from: 100; duration: 500 }
    }

    footer: ItemDelegate {
        anchors.left: parent.left
        anchors.right: parent.right
        contentItem: RowLayout {
            anchors {
                fill: parent
                leftMargin: 8
                topMargin: 8
            }
            RoundButton{
                text: "+"
                Layout.alignment: Qt.AlignHCenter
                onClicked: audioNoteCreation.open()
            }
            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Добавить")
            }
        }
        onClicked: audioNoteCreation.open()
        enabled: repo != null
    }

    Dialog {
        id: audioNoteCreation
        contentItem: Item {
            implicitWidth: 500
            implicitHeight: 500
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20

                AudioNoteCreationPanel{
                    id: creationPanel
                    targetRepo: repo
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                RowLayout {
                    Button{
                        text: "Создать"
                        onClicked: {
                            creationPanel.processBuild()
                            audioNoteCreation.close()
                        }
                    }
                    Button {
                        text: "Выход"
                        onClicked: audioNoteCreation.close()
                    }
                }
            }
        }
    }
}
