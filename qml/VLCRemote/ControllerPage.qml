import QtQuick 1.0
import com.nokia.symbian 1.1
import "VLCRemote.js" as VLC
import "Utilities.js" as Helper
import QtWebKit 1.0
import com.nokia.extras 1.1
import QtMobility.systeminfo 1.2
Page{
    id:controllerPage
    tools: controllerToolBar
    ListView{
        width:parent.width
        anchors.bottom: slideRow.top
        anchors.top: parent.top
        model: xmlModel
        delegate: listViewDelegate
        header: playlistHeader
        clip: true
    }

    XmlListModel {
        id: xmlModel
        query: "//leaf"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "author"; query: "artist/string()" }
        XmlRole { name: "name"; query: "@name/string()" }
        XmlRole { name: "id"; query: "@id/string()" }
    }
    Component {
        id: playlistHeader

        ListHeading {
            ListItemText {
                id: headingText
                anchors.fill: parent.paddingItem
                role: "Heading"
                text: "Current Playlist:"
            }
        }
    }
    Component {
        id: listViewDelegate
        ListItem {
            id: listItem
            Column {
                anchors.fill: listItem.paddingItem
                ListItemText {
                    mode: listItem.mode
                    role: "Title"
                    text: name // Title text from model
                    font.pointSize: 10
                    width: parent.width
                }
                ListItemText {
                    mode: listItem.mode
                    role: "Author"
                    text: author // SubTitle text from model
                    width: parent.width
                }
            }
            onClicked: {
                VLC.play("&id=" + id)
                console.log("ListItem clicked and the id is " + id)
            }
        }
    }
    Column
    {
        id:slideRow
        anchors.bottom: mediaControlRow.top
        anchors.bottomMargin: 5
        width:parent.width
        Slider{
            id:seekBar
            width:parent.width
            maximumValue: 100
            stepSize: 1
            value:0
            onPressedChanged: {
                VLC.seek(value +"%")
            }
        }
        Row{
            width: parent.width
            Image{
                id:volumeIcon
                width: 32
                height: 32
                source: "qrc:/icons/volume.png"
                states: [
                    State {
                        name: "mute"
                        PropertyChanges {  target: volumeIcon; source:"qrc:/icons/volumeM.png"
                        }
                    },
                    State {
                        name: "unmute"
                        PropertyChanges {  target: volumeIcon; source:"qrc:/icons/volumeM.png"
                        }
                    }
                ]
            }

            Slider{
                id:volumeBar
                anchors.verticalCenter: volumeIcon.verticalCenter
                width:parent.width - volumeIcon.width
                maximumValue: 256
                stepSize: 3
                onValueChanged: {

                    VLC.setVolume(value)
                }
            }
        }
    }
    ButtonRow {
        id:mediaControlRow
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        checkedButton: btnPlay

        ToolButton {
            id: btnPrevious;
            iconSource: "toolbar-mediacontrol-backwards"
            onClicked: { VLC.previous(); VLC.getPlaylist() }
        }
        ToolButton {
            id: btnPlay
            iconSource: "toolbar-mediacontrol-play"
            onClicked: { VLC.togglePlay() }
            states: [
                State{
                    name:"paused"
                    PropertyChanges {
                        target: btnPlay; iconSource: "toolbar-mediacontrol-play" }
                },
                State{
                    name:"playing"
                    PropertyChanges {
                        target: btnPlay; iconSource: "qrc:/icons/i_pause.svg"

                    }
                }

            ]
        }
        ToolButton {
            id: btnNext
            iconSource: "toolbar-mediacontrol-forward"
            onClicked: { VLC.next(); VLC.getPlaylist() }
        }
    }
}
