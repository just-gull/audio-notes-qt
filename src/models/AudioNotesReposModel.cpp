#include "AudioNotesReposModel.h"
#include "AudioNotesRepo.h"
#include <QUrl>
#include <QDebug>

#include <QThreadPool>

AudioNotesReposModel::AudioNotesReposModel(QObject *parent)
    : QAbstractListModel{parent}, reposInProgress{ 0 }
{

}

int AudioNotesReposModel::rowCount(const QModelIndex &) const
{
    return m_items.size();
}

QVariant AudioNotesReposModel::data(const QModelIndex &index, int ) const
{
    return QVariant::fromValue(m_items[index.row()].get());
}

QHash<int, QByteArray> AudioNotesReposModel::roleNames() const
{
    static QHash<int, QByteArray> sNames = { { 1, "repo" }};
    return sNames;
}

void AudioNotesReposModel::addRepo(const QUrl &path)
{
    ++reposInProgress;
    emit processingReposChanged(processingRepos());

    std::unique_ptr<AudioNotesRepo> repoPtr = std::make_unique<AudioNotesRepo>(path.toLocalFile());

    auto* repo = repoPtr.get();
    connect(repo, &AudioNotesRepo::initializationFinished, this, [this, repo](){
        --reposInProgress;
        emit processingReposChanged(processingRepos());
        disconnect(repo, &AudioNotesRepo::initializationFinished, this, nullptr);
    });

    repo->init();
    addRepo(std::move(repoPtr));
}

void AudioNotesReposModel::addRepo(std::unique_ptr<AudioNotesRepo>&& repoPtr)
{
    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    m_items.push_back(std::move(repoPtr));
    endInsertRows();
}

bool AudioNotesReposModel::processingRepos() const
{
    return reposInProgress > 0;
}
