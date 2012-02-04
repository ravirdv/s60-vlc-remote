import QtQuick 1.0
import com.nokia.symbian 1.1
import "VLCRemote.js" as VLC
import "Utilities.js" as Helper
import QtWebKit 1.0
import com.nokia.extras 1.1
import QtMobility.systeminfo 1.2
Page{
    id:configPage
    tools:configToolBar
    Row{
        id:serverInfoRow
        width: parent.width
        TextField{
            id:txtIP
            //inputMask: "000.000.000.000;_"
            placeholderText: "IP Address/Hostname"
        }
        TextField{
            id:txtPort
            inputMask: "00000"
            placeholderText: "Port"
            ToolButton{
                id:btnConnect
                height: parent.height
                anchors.left: parent.right
                iconSource: "toolbar-next"
                onClicked: connectButton()
            }
        }

    }
    ListView{
        id:serverList
        width: parent.width
        anchors.bottom: parent.bottom
        anchors.top: serverInfoRow.bottom

        visible: true //TEMPORARY (FEATURE DISABLED)

        model: serverModel
        header: listHeader
        delegate: serverDelegate
        clip:true
        focus:true

    }
    ListModel{
        id:serverModel
    }
    Component {
        id: serverDelegate
        ListItem {
            id: listItem
            Column {
                anchors.fill: listItem.paddingItem
                Row{
                    ListItemText {
                        id:listItemText
                        mode: listItem.mode
                        role: "Title"
                        text: server // Title text from model
                        font.pointSize: 10
                        width: window.width
                        ToolButton{
                            id:nextIcon
                            anchors.left: parent.right
                            iconSource: "toolbar-next"
                            enabled: false
                        }
                    }

                }
            }
            onClicked: {
                VLC.connectToHost(server)
                VLC.getPlaylist()
                updateTimer.start()
                pageStack.push(controllerPage)
            }
        }
    }
    Component {
        id: listHeader

        ListHeading {
            id: listHeading

            ListItemText {
                id: headingText
                anchors.fill: listHeading.paddingItem
                role: "Heading"
                text: "Servers :"
            }
        }
    }



}
