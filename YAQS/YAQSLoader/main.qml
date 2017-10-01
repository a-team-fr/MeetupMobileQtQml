import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("YAQS")



    header:ToolBar{
        RowLayout {
            anchors.fill: parent

            Label {
                text: "modules broadcasting to port "+proxy.getPortNumber()
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                text: qsTr("⋮")
                onClicked: moduleSelector.open()
            }
        }
    }




    ListModel{
        id:availableModules
        ListElement{
            qmlUrl:"qrc:/module/systems.qml"
            moduleType:1
            name:"Systems"
            description:"driving and engine models, computations"
        }
        ListElement{
            qmlUrl:"qrc:/module/io.qml"
            moduleType:2
            name:"IO"
            description:"get position of wheel steering, pedals, switches..."
        }
        ListElement{
            qmlUrl:"qrc:/module/sound.qml"
            moduleType:3
            name:"Sounds"
            description:""
        }
        ListElement{
            qmlUrl:"qrc:/module/instruments.qml"
            moduleType:4
            name:"Instruments"
            description:""
        }
        ListElement{
            qmlUrl:"qrc:/module/navigation.qml"
            moduleType:5
            name:"Navigation"
            description:""
        }
        ListElement{
            qmlUrl:"qrc:/module/visual.qml"
            moduleType:6
            name:"Visual"
            description:""
        }
    }

    Dialog{
        id:moduleSelector
        visible: true
        x:parent.width*0.2
        y:parent.height*0.2
        width:parent.width * 0.6
        height: parent.height * 0.6
        modal:true
        title: "list of selected modules"
        clip:true
        ListView{
            model:availableModules

            anchors.fill:parent
            anchors.margins: 10

            ScrollBar.vertical: ScrollBar {}

            delegate: Row{
                CheckBox{
                    id:isSelected
                    onPressed: {
                        if (!checked)
                        {
                            proxy.addModuleType(model.moduleType)
                            tabBar.addNewTab(model.name);
                            moduleView.addNewTab(model.qmlUrl);
                        }
                        else{
                            proxy.removeModuleType(model.moduleType)
                            var index = moduleView.findIndexFromUrl(model.qmlUrl)
                            if (index != -1){
                                tabBar.removeItem(index);
                                moduleView.removeItem(index);
                            }
                        }
                    }

                }
                Text{
                    text:model.name
                }

            }
        }
    }

    SwipeView {
        id: moduleView
        anchors.fill: parent

        function findIndexFromUrl(url){
            for (var index =0; index< moduleView.count; index++)
            {
                var item = moduleView.itemAt(index);
                if (item.source == url)
                    return index;
            }
            return -1;
        }

        function addNewTab(url)
        {
            addItem(modulePage.createObject(moduleView, {"source": url}))
        }
        Component {
            id:modulePage
            Loader{
            }
        }

    }

    footer: TabBar {
        id: tabBar
        currentIndex: moduleView.currentIndex
        visible:moduleView.count>1
        function addNewTab(label)
        {
            addItem(tabButton.createObject(tabBar, {"text": label, "index": count}))
        }

        Component {
            id:tabButton
            TabButton {
                property int index:0
                onClicked: moduleView.currentIndex = index
            }
        }

    }

}
