import QtQuick 1.1
import com.nokia.symbian 1.1
Dialog{
    id:aboutDialog
    title: [
        Row{
            Image{
                height: 48
                width: 48
                source:"qrc:/icons/VLCRemote.svg"
            }

        Text{
            font.pointSize: 12
            color:"white"
            text:"VLC Remote."
        }
        }

    ]
    buttons: [
        Button{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin:5
            anchors.bottom: parent.bottom
            text:"Back"
            onClicked: {
                aboutDialog.close()
            }
        }
    ]
    content: [
        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                font.pointSize: 5
                color:"white"
                text:"Version 1.0.0"
            }
            Text{
                font.pointSize: 7
                color:"white"
                text:"By Ravi Vagadia"
            }
            Row{
                spacing: 5
                Image{
                    source:"qrc:/icons/facebook.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("http://www.facebook.com/hyperdude")
                        }
                    }
                }
                Image{
                    source:"qrc:/icons/twitter.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("http://www.twitter.com/ravirdv")
                        }
                    }
                }
                Image{
                    source:"qrc:/icons/blogspot.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("http://ravirdv.blogspot.com")
                        }
                    }
                }

            }
            Text{
                font.pointSize: 6
                color:"white"
                text:"<b>Web:</b> <a href=\"http://www.hyperdude.co.cc\">http://www.hyperdude.co.cc </a>"
            }
            Text{
                font.pointSize: 6
                color:"white"
                text:"<b>Email : </b> ravirdv@gmail.com"
            }
        }

    ]

}
