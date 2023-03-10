import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Dialogs 1.3

import AudioNotes 1.0

SplitView {
    id: rootSplitView
    anchors.fill: parent
//        visible: !modelAudioNotes.emptyNotes

    required property AudioNotesReposModel reposModel

    signal folderAdded(url folderPath)

    RepositoryListView {
        id: repositoryView
        SplitView.minimumWidth: 200

        model: reposModel

        onFolderAdded: (folder) => rootSplitView.folderAdded(folder)
    }

    AudioNotesListView {
        id: notesView
        repo: repositoryView.selectedRepo
        SplitView.minimumWidth: 200
        SplitView.fillWidth: true
    }
}