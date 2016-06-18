$ ->
  App.endpoint_uuid = uuid.v1();

  App.positions = App.cable.subscriptions.create 'PositionsChannel',


    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (message) ->
      console.log(message)
      if (message.hdr.from != App.endpoint_uuid)
        if (message.hdr.type == "data")
          if (message.hdr.subtype == "update")
            if (message.hdr.record == "user")
              @updateMarker(message.body.user)
            if (message.hdr.record == "position")
              @updateMarkerPosition(message.body.position)

        if (message.hdr.type == "live_data")
          if (message.hdr.subtype == "update")
            if (message.hdr.record == "position")
              @updateMarkerPosition(message.body.position)

    send_msg: (message) ->
      console.log(message)
      @perform 'recv_msg', message: message

    ######################
    ## helper functions ##
    ######################
    updateMarker: (user) ->

      bFound = false
      i = 0
      while !bFound and i < window.map_markers.length
        map_marker = window.map_markers[i]

        if (map_marker.id == user.id)
          bFound = true
          console.log('Found existing marker ' + user.username + ' ' + user.id);
        i++

      if (!bFound)
        console.log('NOT found adding new marker ' + user.username + ' ' + user.id);
        map_marker = new google.maps.Marker
         #position: { lat: "0.0", lng: "0.0" }
          map: window.map
          draggable:true
          title: "#{user.username}"

        map_marker.set('id', user.id);
        
        window.map_markers.push(map_marker)

        #/////////////////////////////////////////////////////////////
        google.maps.event.addListener map_marker, 'drag', (event) ->
          id = @get('id')
          id = map_marker.id
          lat = event.latLng.lat()
          lng = event.latLng.lng()
          record = 
            user_id: id
            latitude: lat
            longitude: lng
          hdr = 
            to: 'server'
            from: App.endpoint_uuid
            type: 'live_data'
            subtype: 'update'
            record: 'position'
          msg = 
            hdr: hdr
            body: position: record
          
          App.positions.send_msg msg
          return        
      
        #/////////////////////////////////////////////////////////////
        google.maps.event.addListener map_marker, 'dragend', (event) ->
          id = @get('id')
          id = map_marker.id
          lat = event.latLng.lat()
          lng = event.latLng.lng()
          record = 
            user_id: id
            latitude: lat
            longitude: lng
          hdr = 
            to: 'server'
            from: App.endpoint_uuid
            type: 'data'
            subtype: 'update'
            record: 'position'
          msg = 
            hdr: hdr
            body: position: record
          
          App.positions.send_msg msg
          return
                  
    ######################
    ## helper functions ##
    ######################
    updateMarkerPosition: (position) ->

      bFound = false
      i = 0
      while !bFound and i < window.map_markers.length
        map_marker = window.map_markers[i]

        if (map_marker.id == position.user_id)
          bFound = true
          console.log('Found updating marker position ' + map_marker.title + ' ' + position.user_id + ' ' + position.latitude + ' ' + position.longitude);
          newLatLng = new google.maps.LatLng(position.latitude, position.longitude);
          map_marker.setPosition(newLatLng);          
        i++

      if (!bFound)
        console.log('NOT found not updating marker position ' + position.user_id + ' ' + position.latitude + ' ' + position.longitude);

return
