import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Dialogs 1.3

Item {
    id: topView

    anchors.fill: parent

    signal folderSelected(url folderPath)

    RowLayout {
        id: defaulModal
        anchors.centerIn: parent

        RoundButton {
            text: "+"
            Layout.alignment: Qt.AlignHCenter
            onClicked: selectRepoFolderDialog.open()
        }

        Label {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Добавить репозиторий")
        }
    }

    FileDialog {
        id: selectRepoFolderDialog

        folder: shortcuts.home
        selectFolder: true

        onAccepted: {
            topView.folderSelected(folder)
        }
    }
}
