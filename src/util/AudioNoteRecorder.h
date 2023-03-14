#pragma once

#include <QObject>
#include <QAudioDeviceInfo>

class QAudioRecorder;

class AudioNoteRecorder : public QObject
{
    Q_OBJECT
public:
    explicit AudioNoteRecorder(QObject *parent = nullptr);
    QStringList inputDevices() const;
    bool isRecording() const;
    qreal recordingAmplitude() const;
    QString recordedPath() const;
    void removeRecordedFile();

public slots:
    void startRecording(const QString & device);
    void stopRecording();
    void cancelRecording();
signals:
    void inputDevicesChanged();
    void isRecordingChanged();
    void recordingAmplitudeChanged();
    void recordingPathChanged();

private:
    QList<QAudioDeviceInfo> m_inputDevices;
    QAudioRecorder* m_recorder;
    qreal m_recordingAmplitude;
    QString m_recordedPath;
    bool m_recordingAccepted;
    void updateInputDevices();
};
