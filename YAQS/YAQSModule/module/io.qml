import QtQuick 2.6
import QtQuick.Controls 2.1

Page {
    Slider{
        from:0
        to:100
        onPositionChanged: proxy.dperc_ThrottlePos = position * 100.
        snapMode: Slider.SnapAlways
    }

}
