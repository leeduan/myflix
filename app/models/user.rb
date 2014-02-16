class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order('list_order') }

  validates_presence_of :full_name
  validates :email, presence: true, uniqueness: { case_sensitive: true }
  validates :password, presence: true, on: :create
  has_secure_password validations: false
end