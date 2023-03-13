#include "AudioNotesApp.h"

#include "AudioNotesRepo.h"
#include "AudioNotesReposModel.h"
#include <QFile>
#include <QTextStream>
#include <QUrl>

#include <QDebug>

#define INIT_FILENAME "init.txt"

AudioNotesApp::AudioNotesApp(QObject *parent)
    : QObject{parent}
{
    m_reposModel = new AudioNotesReposModel(this);
}

bool AudioNotesApp::emptyNotes() const
{
    return m_reposModel->rowCount(QModelIndex()) == 0;
}

void AudioNotesApp::init()
{
    QFile file{ INIT_FILENAME };
    if (file.open(QIODevice::ReadOnly)){
        QTextStream in(&file);
        while (!in.atEnd()){
            if(const auto& path = in.readLine(); path != ""){
                m_reposModel->addRepo(QUrl(path));
            }
        }
        file.close();
    }
}

void AudioNotesApp::saveRepo(const QUrl &path)
{
    QFile file{ INIT_FILENAME };
    if (file.open(QIODevice::Append)) {
        QTextStream stream(&file);
        stream << path.toString() << endl;
        file.close();
    }
}

void AudioNotesApp::addAudioRepo(const QUrl &path)
{
    saveRepo(path);
    m_reposModel->addRepo(path);
}

AudioNotesReposModel *AudioNotesApp::reposModel() const
{
    return m_reposModel;
}
