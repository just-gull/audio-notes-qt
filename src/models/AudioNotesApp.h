#pragma once

#include <QObject>
#include <QVector>
#include <QUrl>

class AudioNotesReposModel;

class AudioNotesApp : public QObject
{
    Q_OBJECT
    Q_PROPERTY(AudioNotesReposModel* reposModel READ reposModel CONSTANT)
    Q_PROPERTY(bool emptyNotes READ emptyNotes CONSTANT)
public:
    explicit AudioNotesApp(QObject *parent = nullptr);

    bool emptyNotes() const;

    Q_INVOKABLE void init();

signals:
    void updateWindow();

public slots:
    void addAudioRepo(const QUrl &path);

private:
    AudioNotesReposModel *m_reposModel;

    AudioNotesReposModel *reposModel() const;
    void saveRepo(const QUrl &path);
};

