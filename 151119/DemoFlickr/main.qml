import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.XmlListModel 2.0

Window {
    visible: true
    width: 1024; height: 768

    Component{
        id:myDelegate
        Image{
            id:image
            property var modelData:model
            height: lstImages.cellHeight
            width: lstImages.cellHeight
            source: url
            Image{
                id:highQuality
                anchors.fill: parent
                source: parent.modelData.url.toString().replace("_s","_b")
                visible : progress === 1
            }
            Text{
                id:info
                text:parent.modelData.title + " - Loading:" + Math.ceil(highQuality.progress *100) + "%"
            }
        }
    }

    Column{
        anchors.fill: parent
        TextEdit{
            id:myTextEdit
            height : Math.min(50, parent.height*0.05)
            width:parent.width
            text:"trip"
        }

        GridView{
            id:lstImages
            height: parent.height - myTextEdit.height
            width: parent.width
            property int nbImage : 3
            cellHeight: height / nbImage
            cellWidth: cellHeight
            delegate:myDelegate
            model: flickerModel//staticModel//flickerModel
        }
    }

    XmlListModel{
        id:flickerModel
        source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=" + myTextEdit.text
        query: "/rss/channel/item"
        namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
        XmlRole { name:"title"; query: "title/string()"}
        XmlRole { name:"url"; query: "media:thumbnail/@url/string()"}
    }

    ListModel{
        id:staticModel
        ListElement{ title:"image 1";url:"http://www.lyonbureaux.com/wp-content/uploads/2015/09/roadtrip.jpg"}
        ListElement{ title:"image 2";url:"http://d3hp9ud7yvwzy0.cloudfront.net/wp-content/uploads/2014/08/theqtcompany-523x236.png"}
    }
}

