import QtQuick 2.13
import QtQuick.Layouts 1.13

import AudioNotes 1.0

Item {

    property var audioSamples
    property AudioNotePlayback playback

    width: parent.width
    height: 40
    Layout.preferredHeight: 40

    Rectangle {
        anchors.fill: parent
        Rectangle {
            color: "lightblue"
            opacity: 0.25
            anchors.fill: parent
        }
        Rectangle {
            color: "lightblue"
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width * currentPercentage()
        }
    }


    function currentPercentage() {
        if (playback.active && playback.duration) {
            return playback.postition / playback.duration;
        }
        return 0.0;
    }
}
