class User < ApplicationRecord
  has_many :messages
  has_many :meetups, through: :messages

  validates :username, presence: true, uniqueness: true
 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
