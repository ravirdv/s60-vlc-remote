Qt.include("main.qml")
var serverIP = "127.0.0.1"
var serverPort = "8080"
var server = "http://" + serverIP + ":" + serverPort
var failCount = 0
var isConnected = false
function connected()
{

}
function failedToConnecy()
{

}

function connect()
{
    server = "http://" + serverIP + ":" + serverPort
    console.debug("DEBUG: Server is " + server)
    sendStatusCommand("")
    return isConnected
}
function connectToHost(host)
{
    server = host
}

function sendStatusCommand(command)
{
    var cmd = "?command=" + command;
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE && doc.status == 200) {
           if(command === "")updateUI(doc.responseXML);

           isConnected = true
           connected();
           failCount = 0
        }
        else
        {
            failCount++
            if(failCount > 5)
            {
                isConnected = false
             }

        }
    }
    doc.open("GET", server + "/requests/status.xml" + cmd);
    doc.send();
}

//Get Playlist
function getPlaylist()
{
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var status = doc.responseXML
            for (var ii = 0; ii < status.childNodes.length; ++ii) {
                if(status.childNodes[ii].nodeName == "title" ) console.debug(status.childNodes[ii].nodeName)
            }
            populatePlaylist(doc.responseText)
        }

    }
    doc.open("GET", server + "/requests/playlist.xml");
    doc.send();
}

function browsePath(path)
{

    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);
            console.log("done");
        }
        if(doc.status != 200)
            console.debug("ERROR :(")
    }
    doc.open("GET", server + "/requests/browse.xml?dir=" + path);
    doc.send();
}



//TODO
//Play using MRL
//Add MRL to Playlisyt
//
function getStatus()
{
    return sendStatusCommand("");
}

function togglePlay()
{
    //handleID
    sendStatusCommand("pl_pause&id=0");
}
function togglePause()
{
    //handle ID
    sendStatusCommand("pl_pause&id=0")
}
function deleteItem()
{
    //Handle ID
    sendStatusCommand("pl_delete&id=0");
}
function stopPlayback()
{
    sendStatusCommand("pl_stop");
}
function next()
{
    sendStatusCommand("pl_next");
}
function play(id)
{

    sendStatusCommand("pl_play" + id);
}
function pause()
{
    sendStatusCommand("pl_pause");
}
function previous()
{
    sendStatusCommand("pl_previous");
}
function clearPlaylist()
{
    sendStatusCommand("pl_empty")
}
function  toggleRandom()
{
    sendStatusCommand("pl_random");
}
function  toggleLoop()
{
    sendStatusCommand("pl_loop");
}
function  toggleRepeat()
{
    sendStatusCommand("pl_repeat");
}
function  toggleFullscreen()
{
    sendStatusCommand("fullscreen");
}
function setVolume(value)
{
    sendStatusCommand("volume&val=" + value)
}
function seek(value)
{
    console.debug("Seeking to " + value)
    sendStatusCommand("seek&val=" + value)
}

function updateInterface(statusXML)
{
    var status = statusXML.documentElement
    for (var ii = 0; ii < status.childNodes.length; ++ii) {
        if(status.childNodes[ii].nodeName == "volume" ) volumeSlider.value = status.childNodes[ii].childNodes[0].nodeValue;
        if(status.childNodes[ii].nodeName == "state" ) playButton.state = status.childNodes[ii].childNodes[0].nodeValue
        if(status.childNodes[ii].nodeName == "length" ) seekSlider.maximumValue = status.childNodes[ii].childNodes[0].nodeValue
        if(status.childNodes[ii].nodeName == "position" ) seekSlider.value = status.childNodes[ii].childNodes[0].nodeValue

    }
}


function populatePlaylistModel(xmlsrc)
{
    xmlModel.source = xmlsrc
    console.debug("loading xml model")
}
