import QtQuick 2.0 as QQ
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0


Entity{
    id:root
    property color color : "lightgrey"

    signal clicked(int idStick)

    PhongMaterial {
        id: mat
        ambient: Qt.darker(root.color)
        diffuse: root.color
    }

    Entity{
        CuboidMesh {
            id: holder
            xExtent: 5
            yExtent: 0.5
            zExtent: 5
        }

        components: [
            holder,  mat
        ]
    }

    NodeInstantiator{
        model:16
        delegate: Stick{
            idStick:index
            onClicked:root.clicked(index)
        }
    }


}
