class Message < ApplicationRecord
  belongs_to :meetup
  belongs_to :user
end
