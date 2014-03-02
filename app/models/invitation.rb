class Invitation < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  has_one :recipient, class_name: 'User'

  before_create :generate_token

  attr_accessor :message
  validates_presence_of :recipient_name, :sender_id, :message
  validates :recipient_email, presence: true, uniqueness: { scope: :sender_id }

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end