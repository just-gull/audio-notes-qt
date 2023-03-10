import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Dialogs 1.3

Item {
    anchors.fill: parent
    SplitView {
        id: rootSplitView
        anchors.fill: parent
//        visible: !modelAudioNotes.emptyNotes

        RepositoryListView {
            id: repositoryView
            SplitView.minimumWidth: 200

        }

        AudioNotesListView {
            id: notesView
//            repo: repositoryView.selectedRepo
            SplitView.minimumWidth: 200
            SplitView.fillWidth: true
        }
    }

}
