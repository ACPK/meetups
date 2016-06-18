class PositionsChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "positions"

    logger.debug('PositionsChannel objectid = ' + self.object_id.to_s)
  end

  def unsubscribed
    stop_all_streams
  end

  #############################################################################
  def self.broadcast_msg(message)
    
    #logger.debug(message)

    ActionCable.server.broadcast "positions", message
  end

  #############################################################################
  def self.broadcast_record_update(record)

    record_name = record.model_name.name.downcase

    hdr = { :to => "all", :from => "server", :type => "data", :subtype => "update", :record => record_name }

    msg = { hdr: hdr , body: { record_name => record }}

    PositionsChannel.broadcast_msg(msg)

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

  #############################################################################
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
        #logger.debug('PositionsChannel rebroadcasting live_data')
        
        # TODO queue these and delete old if we are running behind
        # TODO can we do this on a per connection basis ???
        PositionsChannel.broadcast_msg(data['message'])
      end
    end

  end

  #############################################################################
  def get_online_users

    connections =  ActionCable.server.remote_connections
    
    a = 1
#    n = connections.count
#    logger.debug(n + "users are online")
    
    # online_users = User.joins(:sessions).distinct

    # logger.debug(online_users.count + "users are online")

    # online_users.each do |user|
    #   logger.debug("user " + user.username + " is online")
    # end

  end
 
  #############################################################################
  def update_position_position(position)
    
    begin

      online_users = get_online_users

      bSendUserRecord = false

      if (position.user_id == '00000000-0000-0000-0000-000000000000')
        bSendUserRecord = true
        position.user_id = current_user.id
      end

      @user     = User.find(position.user_id)
      @position = Position.find_by(user_id: position.user_id)

      if (@position == nil)
        @position         = Position.new
        @position.user_id = position.user_id
      end

      position_params = { latitude: position.latitude, longitude: position.longitude }
    
      if @position.update(position_params)
        logger.debug("succeeded in updating position location")

       #if (bSendUserRecord)
        if (true)
          PositionsChannel.broadcast_record_update(@user)
        end
        PositionsChannel.broadcast_record_update(@position)
      else
        logger.debug("failed in updating position location")
      end
    rescue Exception => ex 
      logger.debug("exception in updating position location " + ex.to_s)
    end

  end

end
