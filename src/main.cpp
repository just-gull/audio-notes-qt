#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "models/AudioNote.h"
#include "models/AudioNotesApp.h"
#include "models/AudioNotesRepo.h"
#include "models/AudioNotesModel.h"
#include "models/AudioNotesReposModel.h"
#include "AudioNotePlayback.h"
#include "util/AudioNoteCreator.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<AudioNotesApp>("AudioNotes", 1, 0, "AudioNotesApp");
    qmlRegisterType<AudioNotesRepo>("AudioNotes", 1, 0, "AudioNotesRepo");
    qmlRegisterType<AudioNotesReposModel>("AudioNotes", 1, 0, "AudioNotesReposModel");
    qmlRegisterType<AudioNote>("AudioNotes", 1, 0, "AudioNote");
    qmlRegisterType<AudioNotesModel>("AudioNotes", 1, 0, "AudioNotesModel");
    qmlRegisterType<AudioNotePlayback>("AudioNotes", 1, 0, "AudioNotePlayback");
    qmlRegisterType<AudioNoteCreator>("AudioNotes", 1, 0, "AudioNoteCreator");


//    AudioNotesApp* notesApp = new AudioNotesApp();

//    engine.rootContext()->setContextProperty("notesApp", notesApp);

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

//    notesApp->init();

    return app.exec();
}
