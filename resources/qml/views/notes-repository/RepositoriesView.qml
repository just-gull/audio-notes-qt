import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Dialogs 1.3

import AudioNotes 1.0

Item {
    id: rootView

    anchors.fill: parent

    required property AudioNotesReposModel reposModel

    signal folderAdded(url folderPath)

    SplitView {
        id: splitView
        anchors.fill: parent
    //        visible: !modelAudioNotes.emptyNotes

        RepositoryListView {
            id: repositoryView
            SplitView.minimumWidth: 200

            model: rootView.reposModel

            onFolderAdded: (folder) => rootView.folderAdded(folder)
        }

        AudioNotesListView {
            id: notesView
            repo: repositoryView.selectedRepo
            SplitView.minimumWidth: 200
            SplitView.fillWidth: true
        }
    }

    Rectangle {
        id: loaderView
        visible: reposModel.processingRepos
        anchors.fill: parent
        color: "#DDFFFFFF"
        BusyIndicator {
            anchors.centerIn: parent
            running: true
        }
    }

}
