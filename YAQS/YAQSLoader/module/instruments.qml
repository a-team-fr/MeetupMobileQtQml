import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Extras 1.4

Page {
    CircularGauge{
        minimumValue:0
        maximumValue:220
        value:proxy.kmhSpeed
        tickmarksVisible: true
    }

}
