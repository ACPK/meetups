$ ->
  App.endpoint_uuid = uuid.v1();

  App.positions = App.cable.subscriptions.create 'PositionsChannel',

    received: (message) ->
      console.log(message)
      if (message.hdr.from != App.endpoint_uuid)
        if (message.hdr.type == "data")
          if (message.hdr.subtype == "update")
            if (message.hdr.record == "position")
              @updateMarker(message.body.position)

        if (message.hdr.type == "live_data")
          if (message.hdr.subtype == "update")
            if (message.hdr.record == "position")
              @updateMarker(message.body.position)

    send_msg: (message) ->
      console.log(message)
      @perform 'recv_msg', message: message

    ######################
    ## helper functions ##
    ######################
    updateMarker: (position) ->

      bFound = false
      i = 0
      while !bFound and i < window.map_markers.length
        map_marker = window.map_markers[i]

        if (map_marker.id == position.id)
          bFound = true
          #console.log('Found update dropMarker ' + position.id + ' ' + position.latitude + ' ' + position.longitude);
          newLatLng = new google.maps.LatLng(position.latitude, position.longitude);
          map_marker.setPosition(newLatLng);          
        i++

      if (!bFound)
        #console.log('NOT found new dropMarker ' + position.id + ' ' + position.latitude + ' ' + position.longitude);
        map_marker = new google.maps.Marker
          position: { lat: position.latitude, lng: position.longitude }
          map: window.map
          animation: google.maps.Animation.DROP
          draggable:true
          title: "#{position.id} #{position.address} #{position.zipcode}"

        map_marker.set('id', position.id);
        window.map_markers.push(map_marker)
      
return
