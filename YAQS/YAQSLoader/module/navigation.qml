import QtQuick 2.6
import QtQuick.Controls 2.1
import QtLocation 5.6
import QtPositioning 5.3

Page {

    Plugin{
        id:googlemaps
        name:"osm"
        // googlemaps requires an special plugin "googlemaps"
    }

    Map{
        id:myMap
        anchors.fill:parent
        plugin:googlemaps
        center:carSymbol.coordinate//QtPositioning.coordinate(47.212047, -1.551647)
        zoomLevel: myMap.maximumZoomLevel

        MapQuickItem {
            id:carSymbol
            coordinate: QtPositioning.coordinate(proxy.latitude, proxy.longitude)
            sourceItem:  Image{
                source: "qrc:/img/carTop.png"
                rotation: proxy.heading
                transformOrigin: Item.Bottom
            }
        }


    }



}
