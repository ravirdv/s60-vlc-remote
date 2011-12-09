import QtQuick 1.0
import com.nokia.symbian 1.0
import "VLCRemote.js" as VLC
import "Utilities.js" as Helper
import QtWebKit 1.0
import com.nokia.extras 1.0
Window {
    id: window
    StatusBar{
        id:statusBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
    }
    PageStack{
        id:pageStack
        anchors.top: statusBar.bottom
        anchors.bottom: sharedToolBar.top
        toolBar:sharedToolBar
    }
    ToolBar
    {
        id:sharedToolBar
        anchors{
            bottom:parent.bottom
            right: parent.right
            left: parent.left
        }
    }

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


    AboutMe{
        id:aboutQuery
    }
    Dialog{
        id:welcomeDialog
        anchors.fill: parent

        title: [
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 12
                color:"white"
                text:"Welcome."
            }

        ]
        buttons: [
            ButtonRow{
                width:parent.width
                Button{
                    text:"Back"
                    onClicked: {
                        welcomeDialog.close()
                    }
                }
                Button{
                    id:helpButton
                    text:"Setup Guide"
                    onClicked: Qt.openUrlExternally("http://www.hyperdude.co.cc/2011/07/control-vlc-player-over-http.html")
                }
            }
        ]
        content: [
            Text{
                anchors.fill: parent
                anchors.margins: 5
                font.pointSize: 8
                color:"white"
                wrapMode: Text.Wrap
                text:"Please Setup HTTP Interface in VLC Player before using this application. Please click on \"Setup VLC Player\" Button to view the setup guide."
            }

        ]
    }


    ToolBarLayout {
        id: configToolBar
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: Qt.quit()
        }

    }
    ToolBarLayout {
        id: controllerToolBar
        ToolButton { iconSource: "toolbar-back";  onClicked: pageStack.pop() }
        ToolButton { id:btnLoop; iconSource: "qrc:/icons/tb_repeat.svg"; checkable: true; onClicked: VLC.toggleRepeat() }
        ToolButton { id:btnRandom ;iconSource: "qrc:/icons/tb_random.svg"; checkable: true; onClicked: VLC.toggleRandom() }
        ToolButton { iconSource: "toolbar-list"; onClicked:aboutQuery.open() }
    }
    Timer {
        id:updateTimer
        interval: 1500; repeat: true
        onTriggered: VLC.getStatus()
    }
    Component.onCompleted: {
        pageStack.push(configPage)
        Helper.initialize()
        updateData("192.168.2.2")
        if(Helper.getSetting("IP") != "Unknown")
        {
            txtIP.text = Helper.getSetting("IP")
            txtPort.text = Helper.getSetting("Port")
         }

        if(Helper.getSetting("FirstStart") == "Unknown")
        {
            welcomeDialog.open();
            Helper.setSetting("FirstStart", "0");
        }

    }


    WorkerScript {
        id: myWorker
        source: "serverFinder.js"
//        onMessage: {
//            //serverModel.append({"server": messageObject.server})
//            console.debug("server found at " + messageObject.server)
//        }
    }
    function updateData(localIP)
    {
        var msg = {'ip': localIP, 'model': serverModel};
        console.debug("server scanner started")
        myWorker.sendMessage(msg)
    }

    function populatePlaylist(xmlsrc)
    {
        //callback to reload xmlModel
        xmlModel.xml = xmlsrc
        xmlModel.reload()

    }
    function updateUI(statusXML)
    {
        var status = statusXML.documentElement
        for (var ii = 0; ii < status.childNodes.length; ++ii) {
            if(status.childNodes[ii].nodeName == "volume" ) {
                volumeBar.value = status.childNodes[ii].childNodes[0].nodeValue;

            }
            if(status.childNodes[ii].nodeName == "state" ) btnPlay.state = status.childNodes[ii].childNodes[0].nodeValue
            if(status.childNodes[ii].nodeName == "position" ) seekBar.value = status.childNodes[ii].childNodes[0].nodeValue
            if(status.childNodes[ii].nodeName == "repeat" ) btnLoop.checked = toBoolean(status.childNodes[ii].childNodes[0].nodeValue)
            if(status.childNodes[ii].nodeName == "random" ) btnRandom.checked = toBoolean(status.childNodes[ii].childNodes[0].nodeValue)
        }
    }
    InfoBanner {
         id: banner
         text: "Unable to Connect to server."
     }

    Timer{
        id:waitTimer
        interval: 3000
        repeat: false
        onTriggered: {
            console.debug("timer triggered")
            waitTimer.stop()
            if(VLC.isConnected)
            {
                Helper.setSetting("IP", txtIP.text)
                Helper.setSetting("Port", txtPort.text)
                VLC.getPlaylist()
                updateTimer.start()
                pageStack.push(controllerPage)
            }
            else
            {
                console.debug("Failed to connect to VLC server.")
                banner.open();
            }
        }

    }

    function connectButton()
    {
        VLC.serverIP = txtIP.text
        VLC.serverPort = txtPort.text
        VLC.connect()
        waitTimer.start()


    }
    function toBoolean(value)
    {
        if(value == "0") return false;
        if(value == "1") return true;
    }
}

