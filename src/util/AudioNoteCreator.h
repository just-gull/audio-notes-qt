#pragma once

#include <QObject>

#include "AudioNoteRecorder.h"

class AudioNotesRepo;
class AudioNote;
class AudioNoteCreator : public QObject
{
    Q_OBJECT

    Q_PROPERTY(AudioNote* audioNote READ audioNote CONSTANT)
    Q_PROPERTY(bool isRecording READ isRecording NOTIFY isRecordingChanged)
    Q_PROPERTY(qreal recordingAmplitude READ recordingAmplitude NOTIFY recordingAmplitudeChanged)
    Q_PROPERTY(QStringList inputDevices READ inputDevices NOTIFY inputDevicesChanged)
    Q_PROPERTY(QString recordDuration READ recordDuration CONSTANT)
    Q_PROPERTY(bool recordingAccepted READ recordingAccepted NOTIFY isRecordingChanged)

    Q_PROPERTY(bool ready READ ready NOTIFY readyChanged)
public:
    explicit AudioNoteCreator(QObject *parent = nullptr);

    bool ready()const;
    QStringList inputDevices() const;
    bool isRecording() const;
    bool isRecordingAccepted() const;

    qreal recordingAmplitude() const;
    QString recordDuration() const;
    bool recordingAccepted() const;

public slots:
    void startRecording(const QString & device);
    void stopRecording();
    void cancelRecording();
    void create(AudioNotesRepo* targetRepo);
    void reset();
signals:
    void readyChanged();
    void inputDevicesChanged();
    void isRecordingChanged();
    void recordingAmplitudeChanged();

private:
    AudioNote *m_audioNote;
    AudioNoteRecorder *m_audioNoteRecorder;
    AudioNote *audioNote() const;
};

