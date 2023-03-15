#pragma once

#include <QAbstractListModel>
#include <memory>

class AudioNotesRepo;
class QUrl;

class AudioNotesReposModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(bool processingRepos READ processingRepos NOTIFY processingReposChanged)
public:
    explicit AudioNotesReposModel(QObject *parent = nullptr);
    ~AudioNotesReposModel() = default;

    int rowCount(const QModelIndex &) const override;
    QVariant data(const QModelIndex &index, int) const override;
    QHash<int, QByteArray> roleNames() const override;

    bool processingRepos() const;

    void addRepo(const QUrl &path);
//    void addRepo(QString path);

signals:
    void processingReposChanged(bool processingRepos);

private:
    std::vector<std::unique_ptr<AudioNotesRepo>> m_items;
    QAtomicInt reposInProgress;
    void addRepo(std::unique_ptr<AudioNotesRepo>&& repoPtr);
};

