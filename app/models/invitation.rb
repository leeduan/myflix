class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :sender, class_name: 'User'
  has_one :recipient, class_name: 'User'

  attr_accessor :message

  validates_presence_of :recipient_name, :sender_id, :message
  validates :recipient_email, presence: true, uniqueness: { scope: :sender_id }
end