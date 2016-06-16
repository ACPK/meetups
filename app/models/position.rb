class Position < ApplicationRecord
  # TODO this needs to be polymorphic for User, Place etc
  #      probably thru Track, Track event models
  belongs_to :user
end
