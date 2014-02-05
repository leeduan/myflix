class User < ActiveRecord::Base
  validates_presence_of :email, :full_name
  validates :password, presence: true, on: :create
  has_secure_password validations: false
end