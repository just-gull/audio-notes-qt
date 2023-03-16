#include "Scanner.h"
#include <mutex>
#include <QDir>
#include <QFileInfo>
#include <QDebug>

#include <QThreadPool>

Scanner::Scanner(QObject *parent)
    : QObject{parent}
{
}

void Scanner::scanFolder(QString path)
{
    ScannerThread* thread = new ScannerThread(path, this);
    connect(thread, &ScannerThread::done, this, &Scanner::scanComplete);
    thread->start();
}

ScannerThread::ScannerThread(const QString& folder, QObject *parent)
    : QThread{ parent }, folder{ folder }
{
}

void ScannerThread::scanDir(QString dir) {
    QDir folder_Dir(dir);
    auto &&folder_Entries = folder_Dir.entryInfoList();
    for(auto &&entry: folder_Entries) {
        if(!(entry.fileName() == ".") && entry.fileName() != "..") {
            if(entry.isDir()) {
                // Можно сделать сканирование каждой новой директории в отдельном потоке
                // но так как задача сканирования является ограниченной по вводу/выводу
                // то нужно предварительно оценить выгоду от такого решения, так как
                // в ряде случаев (много пустых директорий или сканирование медленного hdd)
                // производительность может снизится по сравненению со сканированием в один поток
                scanDir(entry.filePath());
            }
            if(entry.isFile() && (entry.completeSuffix() == "audionote")) {
                result.append(entry.filePath());
            }
        }
    }
}

void ScannerThread::run() {
    scanDir(folder);
    // sorting array by creation time (filename = creation time) before emitting the result
    result.sort();
    emit done(result);
}
