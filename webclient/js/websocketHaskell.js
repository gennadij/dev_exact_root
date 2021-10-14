function websocketHaskell(){
    const httpPort = location.port;
    const httpHostname = location.hostname;
    const param = location.pathname;
    var wsUrl = "ws://" + httpHostname + ":" + httpPort + "/" + param;
    console.log("Connected to " + wsUrl);
    // ws =  new WebSocket("ws://localhost:9160/");
    ws = new WebSocket("ws://localhost:8000/ws");
    $("#resultHaskell").html("Ergebniss von Haskell: ")
    createWebsocket(ws);
    $("#sendenHaskell").on("click", function(e){
      var rad = $("#radicandHaskell").val()
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
      $('#serverStatusHaskell').text('open');
    }
    //rust response
    // {"jsonrpc":"2.0","result":{"multiplikator":1,"wurzelwert":5},"id":1}
    ws.onmessage = function (evt) {
      console.log("Server sendet : " + evt.data)
      var received_msg = JSON.parse(evt.data);
      console.log("Received Message: " + evt.data);
      var root = received_msg.result.wurzelwert;
      var multiplier = received_msg.result.multiplikator;
      var radicand = received_msg.result.radikand;
      $("#resultHaskell").html(
        "Ergebnis: " +  
        multiplier + 
        "&times;&radic;<span style=\"text-decoration: overline\">" + 
        root + 
        "</span>"
      )
    }
  
    ws.onclose = function() {
      $('#serverStatusHaskell').text('closed');
      console.log("Connection is closed...");
    }
}