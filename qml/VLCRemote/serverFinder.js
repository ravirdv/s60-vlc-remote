var sModel = null;
WorkerScript.onMessage = function(local) {

    var baseIP = local.ip.split(".");
    sModel = local.model;
           for(var index = 1; index <255; index++)
           {
               baseIP[3] = index
               var url = "http://" + baseIP[0] + "." + baseIP[1] + "." + baseIP[2] + "." + baseIP[3] + ":8080"
               scanHost(url)
           }
}

function scanHost(host)
{
    console.debug("scanning " + host)
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            if (doc.status === 200) {
                sModel.append({ 'server': host});
                sModel.sync();
                console.debug("server found, synced");
            }
        }
    }
    doc.open("GET", host + "/requests/status.xml");
    doc.send();
}
