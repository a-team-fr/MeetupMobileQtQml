import QtQuick 2.6
import QtQuick.Controls 2.1
import QtMultimedia 5.5
import QtAudioEngine 1.1

Page {

    Component.onCompleted: audioEngine.sounds["engineRPM"].play();
    AudioEngine{
        id:audioEngine
        AudioSample{
            name:"engineRPM"
            source:"qrc:/res/engine-loop.wav"
            preloaded:true
        }
        Sound{
            name:"engineRPM"
            PlayVariation{
                sample:"engineRPM"
                looping:true
            }
            //playType:
        }
    }

}
