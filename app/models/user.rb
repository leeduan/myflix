class User < ActiveRecord::Base
  validates_presence_of :full_name
  validates :email, presence: true, uniqueness: { case_sensitive: true }
  validates :password, presence: true, on: :create
  has_secure_password validations: false
end