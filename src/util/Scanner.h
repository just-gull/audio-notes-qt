#pragma once

#include <QObject>
#include <QStringList>
#include <memory>
#include <QHash>
#include <QThread>


class Scanner;

class ScannerThread: public QThread {
    Q_OBJECT

private:
    QString folder;
    void scanDir(QString dir);
public:
    QStringList result;

    ScannerThread(const QString& folder = QString(), QObject *parent = nullptr);

signals:
    void done(const QStringList result);

    // QThread interface
protected:
    virtual void run() override;
};


class Scanner : public QObject
{
    Q_OBJECT
public:
    explicit Scanner(QObject *parent = nullptr);
public slots:
    void scanFolder(QString path);

signals:
    void scanComplete(QStringList audioNotes);
};

