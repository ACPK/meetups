# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      
      if (current_user)
        logger.add_tags current_user.username
      end
    end

    def disconnect
      # Any cleanup work needed when the cable connection is cut.
    end

    protected
      def find_verified_user
       #if current_user = User.find_by_identity cookies.signed[:identity_id]
        if current_user = env['warden'].user
          current_user
        else
          #reject_unauthorized_connection
          current_user = nil
        end
      end
  end

end
