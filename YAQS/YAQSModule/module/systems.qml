import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Extras 1.4

Page {

    CircularGauge{
        minimumValue:0
        maximumValue:3000
        value:proxy.dperc_ThrottlePos * 20
        tickmarksVisible: false
    }



}
