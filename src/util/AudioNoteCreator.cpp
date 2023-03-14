#include "AudioNoteCreator.h"
#include "../AudioNote.h"
#include "../models/AudioNotesRepo.h"
#include <QDateTime>

#include <QDebug>

AudioNoteCreator::AudioNoteCreator(QObject *parent)
    : QObject{parent},
      m_audioNote(new AudioNote(this)),
      m_audioNoteRecorder(new AudioNoteRecorder(this))
{
    connect(m_audioNote, &AudioNote::nameChanged, this, &AudioNoteCreator::readyChanged);
    connect(m_audioNote, &AudioNote::pathChanged, this, &AudioNoteCreator::readyChanged);
    connect(m_audioNote, &AudioNote::encryptedChanged, this, [this](){
        if(!m_audioNote->encrypted()) {
            m_audioNote->setPassword("");
        }
        emit readyChanged();
    });
    connect(m_audioNote, &AudioNote::passwordChanged, this, &AudioNoteCreator::readyChanged);
    connect(m_audioNoteRecorder, &AudioNoteRecorder::recordingPathChanged, this, &AudioNoteCreator::readyChanged);
    connect(m_audioNoteRecorder, &AudioNoteRecorder::inputDevicesChanged, this, &AudioNoteCreator::inputDevicesChanged);
    connect(m_audioNoteRecorder, &AudioNoteRecorder::isRecordingChanged, this, &AudioNoteCreator::isRecordingChanged);
}

AudioNote *AudioNoteCreator::audioNote() const
{
    return m_audioNote;
}


bool AudioNoteCreator::ready() const
{
    return !m_audioNote->name().isEmpty() && !m_audioNoteRecorder->recordedPath().isEmpty() && !(m_audioNote->encrypted() && m_audioNote->password().isEmpty());
}

QStringList AudioNoteCreator::inputDevices() const
{
    return m_audioNoteRecorder->inputDevices();
}

void AudioNoteCreator::startRecording(const QString &device) {
    m_audioNoteRecorder->startRecording(device);
}

void AudioNoteCreator::stopRecording()
{
    m_audioNoteRecorder->stopRecording();
}

void AudioNoteCreator::cancelRecording()
{
    m_audioNoteRecorder->cancelRecording();
}

void AudioNoteCreator::reset()
{
    m_audioNote->setName("");
    m_audioNote->setColor(QColor::fromRgb(0, 0, 0));
    m_audioNote->setEncrypted(false);
    m_audioNote->setPassword("");
}

void AudioNoteCreator::create(AudioNotesRepo *targetRepo)
{
    auto* audioNote = new AudioNote(targetRepo);
    audioNote->setName(m_audioNote->name());
    audioNote->setColor(m_audioNote->color());
    audioNote->setEncrypted(m_audioNote->encrypted());
    audioNote->setPassword(m_audioNote->password());
    audioNote->setPath(targetRepo->path() + "/" + QString::number(QDateTime::currentMSecsSinceEpoch()) + ".audionote");
    audioNote->saveToFile(m_audioNoteRecorder->recordedPath());
    audioNote->init();
    targetRepo->addNote(audioNote);

    m_audioNoteRecorder->removeRecordedFile();
}

bool AudioNoteCreator::isRecording() const
{
    return m_audioNoteRecorder->isRecording();
}

qreal AudioNoteCreator::recordingAmplitude() const
{
    return m_audioNoteRecorder->recordingAmplitude();
}
