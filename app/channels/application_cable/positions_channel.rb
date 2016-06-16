class PositionsChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "positions"

    logger.debug('PositionsChannel objectid = ' + self.object_id.to_s)
  end

  def unsubscribed
    stop_all_streams
  end

  def recv_msg(data)
    message = data['message']

    logger.debug(message)

    hdr   = message['hdr']
    body  = message['body']

    if (hdr['type'] == 'data')
      if (hdr['subtype'] == 'update')
        if (hdr['record'] == 'position')
          update_position_position(body['position'])
        end
      end
    elsif (hdr['type'] == 'live_data')
      PositionsChannel.broadcast_msg(message)
    end

  end

  def update_position_position(position)
    begin
      id  = position['id']
      lat = position['latitude']
      lng = position['longitude']

      @position = Position.find(id)

      position_params = { latitude: lat, longitude: lng }
    
      if @position.update(position_params)
        logger.debug("succeeded in updating position location")
      else
        logger.debug("failed in updating position location")
      end
    rescue Exception => e 
      logger.debug("exception in updating position location")
    end

  end

  #############################################################################
  def self.broadcast_msg(message)
    
    #logger.debug(message)

    ActionCable.server.broadcast "positions", message
  end

  #############################################################################
  def self.broadcast_record_update(record)

    hdr = { :to => "all", :from => "server", :type => "data", :subtype => "update", :record => "position" }

    msg = { hdr: hdr , body: { position: record }}

    ActionCable.server.broadcast "positions", msg

    #PositionsChannel.send_msg(msg)

    ############################################
    ############################################
    # connections = ActionCable.server.connections

    # channel = ActionCable.server.channel_classes["PositionsChannel"]

    # logger.debug('PositionsChannel objectid =' + channel.object_id.to_string)

    # ####channel.send_msg(msg)

    # #  #TODO move this into the channel for processing
    # #   relayjob = PositionRelayJob.new

    # #   relayjob.perform_later(channel, msg) 
  end
  
end
