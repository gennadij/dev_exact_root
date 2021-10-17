function websocketHaskell(){
    const httpPort = location.port;
    const httpHostname = location.hostname;
    const param = location.pathname;
    var wsUrl = "ws://" + httpHostname + ":" + httpPort + "/" + param;
    console.log("Connected to " + wsUrl);
    // ws =  new WebSocket("ws://localhost:9160/");
    ws = new WebSocket("ws://localhost:9160");
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
    // {"result":{"multiplikator":-1,"wurzelwert":5,"radikand":-1},"jsonrpc":"2.0","id":1}
    ws.onmessage = function (evt) {
      console.log("Server sendet : " + evt.data)
      var received_msg = JSON.parse(evt.data)
      console.log("Received Message: " + evt.data)
      var multiplikator = received_msg.result.multiplikator
      var wurzelwert = received_msg.result.wurzelwert
      var radikand = received_msg.result.radikand
      if(multiplikator == -1 && radikand == -1){
        // {"result":{"multiplikator":-1,"wurzelwert":-1,"radikand":21},"jsonrpc":"2.0","id":1}
        $("#resultHaskell").html(
          "Ergebnis: " + wurzelwert + "</span>"
        )
      }else if(multiplikator == -1 && wurzelwert == -1){
        // {"result":{"multiplikator":-1,"wurzelwert":-1,"radikand":21},"jsonrpc":"2.0","id":1}
        $("#resultHaskell").html(
          "Ergebnis: " + "&radic;<span style=\"text-decoration: overline\">" + 
          radikand + 
          "</span>"
        )
      }else{
        // {"result":{"multiplikator":5,"wurzelwert":2,"radikand":-1},"jsonrpc":"2.0","id":1}
        $("#resultHaskell").html(
          "Ergebnis: " +  
          multiplikator + 
          "&times;&radic;<span style=\"text-decoration: overline\">" + 
          wurzelwert + 
          "</span>"
        )
      }
    }
  
    ws.onclose = function() {
      $('#serverStatusHaskell').text('closed');
      console.log("Connection is closed...");
    }
}