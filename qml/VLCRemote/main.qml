import QtQuick 1.0
import com.nokia.symbian 1.1
import "VLCRemote.js" as VLC
import "Utilities.js" as Helper
import QtWebKit 1.0
import com.nokia.extras 1.1
import QtMobility.systeminfo 1.2
Window {
    id: window
    NetworkInfo{
        id:networkInfo
    }

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

    ConfigPage {
        id: configPage
    }
    ControllerPage {
        id: controllerPage
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
        updateData("192.168.1.0")
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

