class Meetup < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
  
  validates :topic, presence: true, uniqueness: true, case_sensitive: false
  
  before_validation :sanitize


  def sanitize
    self.topic = self.topic.strip
  end
    
end
