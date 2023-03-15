import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Dialogs 1.3

import AudioNotes 1.0

ListView {
    id: listView

    property AudioNotesRepo selectedRepo

    signal folderAdded(url folderPath)

    header: Label {
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: qsTr("Репозитории")
        font.bold: true
        font.pointSize: 22
        topPadding: 12
        bottomPadding: 12
    }

    delegate: ItemDelegate {
        id: listItem

        property AudioNotesRepo repo: modelData

        anchors.left: parent.left
        anchors.right: parent.right
        highlighted: ListView.isCurrentItem

        onClicked:{
            selectedRepo = repo
            listView.currentIndex = index
        }
        ListView.onAdd: {
            if (listView.count > 0 && listView.currentIndex === -1) {
                listView.currentIndex = 0
                selectedRepo = listView.currentItem.repo
            }
        }

        Label {
            text: listItem.repo.name
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            anchors.left: parent.left
            width: listView.width - 16
            clip: true
            font.bold: true
        }
        Rectangle {
            implicitHeight: 1
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "lightgray"
        }
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
                onClicked: selectRepoFolderDialog.open()
            }
            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: "Добавить"
            }
        }
        onClicked: selectRepoFolderDialog.open()
    }

    FileDialog {
        id: selectRepoFolderDialog
        selectFolder: true
        onAccepted: {
            listView.folderAdded(folder);
        }
    }
}
