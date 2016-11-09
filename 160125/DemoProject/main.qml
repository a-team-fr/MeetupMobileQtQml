import QtQuick 2.3
import QtQuick.Window 2.2
import QtPositioning 5.3
import QtLocation 5.5
import QtQuick.Controls 1.4
import QtQuick.XmlListModel 2.0

Window {
    visible: true
    width: 1024//Screen.desktopAvailableWidth
    height: 768//Screen.desktopAvailableHeight

    MapboxCredentials{
        id:mapboxCredentials
    }

    PositionSource{
        id:myPos
        updateInterval: 1000
        active:true
        preferredPositioningMethods: PositionSource.AllPositioningMethods
    }


    XmlListModel
    {
        id: bikeModelXml
        source: "https://www.capitalbikeshare.com/data/stations/bikeStations.xml"
        query: "/stations/station"
        XmlRole { name: "latitude"; query: "lat/string()"; isKey: true }
        XmlRole { name: "longitude"; query: "long/string()"; isKey: true }
    }


    PlaceSearchModel {
        id: searchModel
        plugin: mapbox
        searchTerm: searchFieldName.text
        searchArea: QtPositioning.circle(myMap.center, Number(searchFieldRadius.text));
        Component.onCompleted: update()
        limit:100

    }

    Location{
        id:myLocation
        coordinate {  latitude: 47.212047; longitude: -1.551647}
    }


    GeocodeModel{
        id:geocodeModel
        plugin:mapbox
        autoUpdate:false

    }

    Plugin{
        id:mapbox
        name: "mapbox"
        PluginParameter{
            name:"mapbox.access_token"
            value:"PLACE HERE YOUR ACCESS TOKEN"
        }
        PluginParameter{
            name:"mapbox.map_id"
            value:"<PLACE HERE YOUR MAP ID"
        }
    }

    Plugin{
        id:osm
        name: "osm"
    }

    ListModel{
        id:dummyModel
        ListElement {
            Latitude: 47.212047
            Longitude: -1.551647
            Label: "something"
            Orientation: 0
            Color:"green"

        }
        ListElement {
            Latitude: 47.3
            Longitude: -1.581647
            Label: "something else"
            Orientation: 90
            Color:"darkgreen"
        }

    }

    Map{
        id:myMap
        anchors.fill : parent
        plugin:mapbox
        center:useDeviceLocation.checked ? myPos.position.coordinate : QtPositioning.coordinate(47.212047, -1.551647)//myLocation.coordinate
        //maximumZoomLevel:
        zoomLevel: myMap.maximumZoomLevel


        //dynamic items
        MapItemView{
            id:dynamicMapObject
            model: dummyModel
            delegate: MapQuickItem {
               coordinate: QtPositioning.coordinate(Latitude,Longitude)
               sourceItem:  Text{
                   width:100
                   height:50
                   text:model.Label
                   rotation: model.Orientation
                   opacity: 0.6
                   color:model.Color
             }
           }

        }
        MapItemView{
            model: bikeModelXml
            delegate: MapQuickItem {
               coordinate: QtPositioning.coordinate(model.latitude,model.longitude)
               sourceItem:  Image{ width:50;height:50;source:"qrc:/bike.png"

             }
           }

        }

        MapItemView{
            model: searchModel
            delegate: MapQuickItem {
               coordinate: model.place.location.coordinate
               sourceItem:  Image{ width:64;height:64;source:model.place.icon.url(Qt.size(64,64));
                   Text{
                       anchors.fill:parent
                       text:model.title
                   }

             }
           }

        }


        //Bunch of static items
        MapQuickItem {
          //a static item (fixed screen size) always at 50m west of the map center
          id:west50mScreenDimension
          coordinate: myMap.center.atDistanceAndAzimuth(50,270)
          sourceItem:  Rectangle{
              width:50; height:50; radius:25; color:"blue"; opacity:0.8
          }
        }
        MapCircle {
          //a static item (fixed real dimension) always at 100m east of the map center
          id:east100mFixedDimension
          center: myMap.center.atDistanceAndAzimuth(100,90)
          opacity:0.8
          color:"red"
          radius:10

        }


        MapQuickItem {
          id:geocodeResult
          coordinate: geocodeModel.count >  0 ? geocodeModel.get(0).coordinate : QtPositioning.coordinate()
          sourceItem:  Image{ width:50;height:50;source:"qrc:/poi.png" }

        }

    }


    Text{
        id:mapErrorMessage
        visible:myMap.error !== Map.NoError
        text: myMap.errorString
        anchors.fill: parent
        color:"red"
    }
    Text{
        id:navErrorMessage
        visible:routeQuery.error !== RouteModel.NoError
        text: routeQuery.errorString ? routeQuery.errorString : ""
        anchors.fill: parent
        color:"red"
    }


    RouteQuery{
        id:routeQuery
        travelModes:RouteQuery.CarTravel
        routeOptimizations : RouteQuery.FastestRoute
    }

    RouteModel {
        id: routeModel
        plugin:mapbox
        query: routeQuery
        onQueryChanged: Console.log(count)
        autoUpdate: false

    }

    ListView {
        id: listview
        anchors.fill: parent

        spacing: 10
        model: routeModel.status == RouteModel.Ready ? routeModel.get(0).segments : null
        visible: model ? true : false
        delegate: Rectangle{
            width: parent.width
            height:50
            color:"lightgrey"
            Row {
            anchors.fill: parent
            spacing: 10
            property bool hasManeuver : modelData.maneuver && modelData.maneuver.valid
            visible: hasManeuver
            Text { text: (1 + index) + "." }
            Text { text: hasManeuver ? modelData.maneuver.instructionText : "" }
            }
        }
    }

    /*----------------------------------------------------------------------------------
    //UI Control Panel
    -----------------------------------------------------------------------------------*/
    Item{
        width:controls.childrenRect.width
        height:controls.childrenRect.height
        Rectangle{
            anchors.fill: parent
            color:"lightgreen"
            opacity:0.6
            radius:10
        }
        Flow{
            id:controls
            width:parent.width
            GroupBox{
                title:"Device location (GPS)"
                CheckBox{
                    id:useDeviceLocation
                    text:"Use"
                }
            }
            GroupBox{
                title:"map types"
                ComboBox{
                    model:myMap.supportedMapTypes
                    textRole:"description"
                    onCurrentIndexChanged: myMap.activeMapType = myMap.supportedMapTypes[currentIndex]
                }
            }
            GroupBox{
                title:"Zoom control"
                Slider{
                    value:myMap.maximumZoomLevel
                    minimumValue: myMap.minimumZoomLevel
                    maximumValue: myMap.maximumZoomLevel
                    onValueChanged: myMap.zoomLevel=value

                }
            }


            GroupBox{
                title:"center coordinate"
                Row{

                TextField{
                    text:myMap.center.latitude.toFixed(6)
                    onEditingFinished: myMap.center.latitude = text
                }
                TextField{
                    text:myMap.center.longitude.toFixed(6)
                    onEditingFinished: myMap.center.longitude = text
                }
                Button{
                    text:"Go near to Bike stations"; onClicked: myMap.center = QtPositioning.coordinate("38.9","-77.0")
                }
                }

            }
            GroupBox{
                title:"Add a new item"
                Row{

                    TextField{ id:newItemName;text:"new item label";}
                    TextField{ id:newItemColor;text:"red";}
                    TextField{ id:newItemOrientation;text:"90";}
                    Button{
                        text:"Add new item"
                        onClicked: {
                            dummyModel.append({
                                "Latitude": myMap.center.latitude,"Longitude":myMap.center.longitude,"Label":newItemName.text , "Color":newItemColor.text, "Orientation":Number(newItemOrientation.text), })
                        }
                    }
                    Button{
                        text:"Clear"
                        onClicked: {
                            dummyModel.clear();
                        }
                    }
                }

            }

            GroupBox{
                title:"Search POI"
                Row{

                    TextField{ id:searchFieldName;text:"restaurant";}
                    TextField{ id:searchFieldRadius;text:"5000";}
                    TextField{ readOnly: true; text:searchModel.count}
                    Button{ text:"update"; onClicked: searchModel.update()}
                }

            }
            GroupBox{
                title:"adress lookup"
                Row{

                    TextField{ id:searchAddress;text:"11 rue juton, 44000 Nantes";}
                    Button{ text:"update"; onClicked: {
                            geocodeModel.query =  searchAddress.text
                            geocodeModel.update()
                        }}
                }

            }

            GroupBox{
                title:"Route"
                Row{
                    Button{ text:"add map center as waypoint"; onClicked: {
                            routeQuery.addWaypoint(myMap.center);
                            routeModel.update();
                    }}
                    Button{ text:"reset"; onClicked: {
                            routeQuery.clearWaypoints();
                            routeModel.update();
                    }}
                }

            }


        }
    }

}
