class PositionsChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "positions"

    logger.debug('PositionsChannel objectid = ' + self.object_id.to_s)
  end

  def unsubscribed
    stop_all_streams
  end

  def recv_msg(data)
    #logger.debug(data)
    raw_message = data['message'].to_json

    begin
      message = JSON.parse(raw_message, object_class: OpenStruct)
    rescue JSON.parse_error => ex
      logger.warn("Attempted to decode invalid JSON message: #{raw_message}")
    else
      if (message.hdr.type == 'data')
        if (message.hdr.subtype == 'update')
          if (message.hdr.record == 'position')
            update_position_position(message.body.position)
          end
        end
      elsif (message.hdr.type == 'live_data')
        PositionsChannel.broadcast_msg(message)
      end
    end

  end

  def update_position_position(position)
    
    begin
      @position = Position.find(position.id)

      position_params = { latitude: position.latitude, longitude: position.longitude }
    
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
