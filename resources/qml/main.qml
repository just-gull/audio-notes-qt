import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Dialogs 1.3

import AudioNotes 1.0

import "./views/empty-repository"
import "./views/notes-repository"

Window {
    id: mainWindow

    width: 640
    height: 480
    minimumWidth: 480
    minimumHeight: 200
    visible: true
    title: qsTr("Audio notes")

    AudioNotesApp {
        id: appModel
        onUpdateWindow: updateComponentsVisibility();
    }

    EmptyRepositoriesView {
        id: emptyView
        visible: false

        onFolderSelected: (folder) => appModel.addAudioRepo(folder);
    }

    RepositoriesView {
        id: repositoriesView
        visible: false

        reposModel: appModel.reposModel

        onFolderAdded: (folder) => appModel.addAudioRepo(folder);
    }

    Component.onCompleted: {
        // загружаем сохраненные данные
        // и показываем разные экраны в зависимости от этого
        appModel.init();
        updateComponentsVisibility();
    }

    function updateComponentsVisibility() {
        if (appModel.emptyNotes) {
            emptyView.visible = true;
            repositoriesView.visible = false;
        } else {
            repositoriesView.visible = true;
            emptyView.visible = false;
        }
    }
}
