$ ->
  App.endpoint_uuid = uuid.v1();

  App.positions = App.cable.subscriptions.create 'PositionsChannel',


    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (message) ->
      #console.log(message)
      if (message.hdr.from != App.endpoint_uuid)
        if (message.hdr.type == "data")
          if (message.hdr.subtype == "update")
            if (message.hdr.record == "user")
              window.updateMarker(message.body.user)
            if (message.hdr.record == "position")
              window.updateMarkerPosition(message.body.position)

        if (message.hdr.type == "live_data")
          if (message.hdr.subtype == "update")
            if (message.hdr.record == "position")
              window.updateMarkerPosition(message.body.position)

    send_msg: (message) ->
      #console.log(message)
      @perform 'recv_msg', message: message


return
