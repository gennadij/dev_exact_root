 document.addEventListener('DOMContentLoaded', main, false);
 
 function main(){
  const httpPort = location.port;
  const httpHostname = location.hostname;
  const param = location.pathname;
  var wsUrl = "ws://" + httpHostname + ":" + httpPort + "/" + param;
  console.log("Connected to " + wsUrl);
  // ws =  new WebSocket("ws://localhost:9160/");
  ws = new WebSocket("ws://localhost:8000/ws");
  $("#result").html("Ergebniss: ")
  createWebsocket(ws);
  $("#senden").on("click", function(e){
    var rad = $("#radicand").val()
    //haskel
    // ws.send(JSON.stringify(
    //   {requestAction :"exactRoot", 
    //     requestData : { 
    //       radicand : parseInt(rad),
    //       resExactRootMultiplier : "",
    //       resExactRootSqrt : ""
    //     }
    //   }
    // ))
    // rust
    ws.send(JSON.stringify(
      {
        jsonrpc: "2.0", 
        method: "exact_root", 
        params: {radikand : parseInt(rad)}, 
        id: 1
      }))
  })
}

function createWebsocket(ws) {
    ws.onopen = function() {
      $('#serverStatus').text('Websocket open');
   }
   //rust response
   // {"jsonrpc":"2.0","result":{"multiplikator":1,"wurzelwert":5},"id":1}
   ws.onmessage = function (evt) {
      console.log("Server sendet : " + evt.data)
      var received_msg = JSON.parse(evt.data);
      console.log("Received Message: " + evt.data);
      //haskell
      // console.log("Received Message: " + received_msg.responseData.resExactRootMultiplier)

      // var root = received_msg.responseData.resExactRootSqrt
      // var multiplier = received_msg.responseData.resExactRootMultiplier
      var root = received_msg.result.wurzelwert;
      var multiplier = received_msg.result.multiplikator;
      $("#result").html(
        "Ergebnis: " +  
        multiplier + 
        "&times;&radic;<span style=\"text-decoration: overline\">" + 
        root + 
        "</span>"
      )
   }

   ws.onclose = function() {
     $('#serverStatus').text('Websocket closed');
     console.log("Connection is closed...");
   }
}
