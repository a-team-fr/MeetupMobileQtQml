import QtQuick 2.6
import QtQuick.Controls 2.1
import QtMultimedia 5.5
import QtAudioEngine 1.1

Page {
    id: pageSound

    SoundInstance{
        id: sinstance
        engine:audioEngine
        sound:"engineRPM"
        pitch: 0.5 + proxy.throttlePos/100.
    }

    SoundInstance{
        id: sbrake
        engine:audioEngine
        sound:"brakes"

        property bool braking: proxy.wheelPos > 20

        onBrakingChanged: {

            if(braking)
                play();
            else
                stop();
        }
    }

    Component.onCompleted: {
        sinstance.play();
    }

    AudioEngine{
        id:audioEngine
        AudioSample{
            name:"sampleMotor"
            source:"qrc:/res/engine-loop.wav"
            preloaded:true
        }
        AudioSample{
            name:"sampleBrake"
            source:"qrc:/res/break.wav"
            preloaded:true
        }

        Sound{
            name:"engineRPM"
            PlayVariation{
                sample:"sampleMotor"
                looping:true
            }
        }
        Sound{
            name:"brakes"
            PlayVariation{
                sample:"sampleBrake"
                looping:false
            }
        }


    }

}
